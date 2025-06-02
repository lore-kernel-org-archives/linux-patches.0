Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0D70222590;
	Mon,  2 Jun 2025 14:17:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873846; cv=none; b=OeDb3ATtAd7K9t3t7H5yxXd9BbujLP+0SRqqI78ht/wuVHKEeoKNcSHOVbpAf8M9fQ+Upq/0X0n9AlWkSC9+rFSwDE2av3i2MFVBxNn4TiUoUuIRDm2sJDMZdqTZ23cWoh2yaMVUv7IYU1QSxkWBzATbFjolOqJDkYPwsfEp3Bk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873846; c=relaxed/simple;
	bh=fmtJ+lMf6NJ1AY2teVVInixuB6mHzCzw5tkY5JWSOag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D6zb8bpZX5pIEmCbdL09JbYBwzDT/77XQwwDs9b3AyfB/EHtmy7q+gybQlv7bu/EGN0gYBH9c8j3jzXlsYlwCW6oIORQZlYQEOkYfJOauD6uXTRFPbhMlDuVvw9woc0Z6wuwuGKBoVTQhNxIMTxmoxLoa0DdKGReEWcImJiRI70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RruR+fXh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RruR+fXh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50100C4CEEB;
	Mon,  2 Jun 2025 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873846;
	bh=fmtJ+lMf6NJ1AY2teVVInixuB6mHzCzw5tkY5JWSOag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RruR+fXhOZEvxKsDjVpqFYm8rbha0Fpx/Fs2+2aZ4NOZF7WP0Jjunn0Dt+NY5BOKb
	 xSowz2eevFJilKpoagBFZBZsKd7vPJaXk6O2KCHFblhvfTq6BDU8P88Y0ciQiRVfO7
	 31piQSpPOEfcZxG1TLqd+b2jHhbcY3DvYllBNNbs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vijendar Mukunda <Vijendar.Mukunda@amd.com>,
	Vinod Koul <vkoul@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 242/444] soundwire: amd: change the soundwire wake enable/disable sequence
Date: Mon,  2 Jun 2025 15:45:06 +0200
Message-ID: <20250602134350.737723856@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vijendar Mukunda <Vijendar.Mukunda@amd.com>

[ Upstream commit dcc48a73eae7f791b1a6856ea1bcc4079282c88d ]

During runtime suspend scenario, SoundWire wake should be enabled and
during system level suspend scenario SoundWire wake should be disabled.

Implement the SoundWire wake enable/disable sequence as per design flow
for SoundWire poweroff mode.

Signed-off-by: Vijendar Mukunda <Vijendar.Mukunda@amd.com>
Link: https://lore.kernel.org/r/20250207065841.4718-2-Vijendar.Mukunda@amd.com
Signed-off-by: Vinod Koul <vkoul@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soundwire/amd_manager.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/soundwire/amd_manager.c b/drivers/soundwire/amd_manager.c
index 79173ab540a6b..31b203ebbae0c 100644
--- a/drivers/soundwire/amd_manager.c
+++ b/drivers/soundwire/amd_manager.c
@@ -1138,6 +1138,7 @@ static int __maybe_unused amd_suspend(struct device *dev)
 		amd_sdw_wake_enable(amd_manager, false);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		amd_sdw_wake_enable(amd_manager, false);
 		/*
 		 * As per hardware programming sequence on AMD platforms,
 		 * clock stop should be invoked first before powering-off
@@ -1165,6 +1166,7 @@ static int __maybe_unused amd_suspend_runtime(struct device *dev)
 		amd_sdw_wake_enable(amd_manager, true);
 		return amd_sdw_clock_stop(amd_manager);
 	} else if (amd_manager->power_mode_mask & AMD_SDW_POWER_OFF_MODE) {
+		amd_sdw_wake_enable(amd_manager, true);
 		ret = amd_sdw_clock_stop(amd_manager);
 		if (ret)
 			return ret;
-- 
2.39.5



