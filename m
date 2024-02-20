Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1E8214A4E6;
	Tue, 20 Feb 2024 21:27:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464433; cv=none; b=tiL6ydEVym21K6cMUm6ew81Yf0xlEzIdMOZvTpKA1YxzwYtYdFQcgm0IzGfLgqiSEwPa/d2JVZ0tu8hnva34oE6xuL/dt+lbP1vmqjUO+Dk67F/Ck93r4OFdxavMf6N0ZlWQmtzq1gl67ZJiPt+6KVPIC9gROC9gjpZpID6CW6s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464433; c=relaxed/simple;
	bh=G9AS4yCR4bldmuW44VcQBRniLstrhH4czPLvwCGB8qU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Nmwj0hjJEbsm1F1sa9crAH/Gm9x65eyatCFsknin/pwvPYCU1EArOT1AkY8UU0PRXD1gsfErkS39wrxyj5Itp2Ndlc2dB3QeXJRojPzZL6P9YGcYeo2qs46XgKM/vmNwlPKBA0LMF0V6ienaT1GnC4ZczwYUjQaGj/MPrHn/HJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mrxCu0GS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mrxCu0GS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6EEE9C433F1;
	Tue, 20 Feb 2024 21:27:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464432;
	bh=G9AS4yCR4bldmuW44VcQBRniLstrhH4czPLvwCGB8qU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mrxCu0GSLCxoChZ9LCuzLzCFK7WZqN5Egs33RhF0konJoVOSH9K7Sr2UyfOGJiymr
	 iblKfh9UXccoEQwueZhA8hoLBVBJZYVSef+UG3+wGdhsvxkGGVjkZGA6Zifb36PWVk
	 4USA3RK3gQa1y/mqzZY2AsRm8/g75YV+I2IsfuC4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cezary Rojewski <cezary.rojewski@intel.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 023/309] ASoC: Intel: avs: Fix pci_probe() error path
Date: Tue, 20 Feb 2024 21:53:02 +0100
Message-ID: <20240220205633.907478342@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cezary Rojewski <cezary.rojewski@intel.com>

[ Upstream commit b5fbde22684af5456d1de60758950944d69d69ad ]

Recent changes modified operation-order in the probe() function without
updating its error path accordingly. If snd_hdac_i915_init() exists with
status EPROBE_DEFER the error path must cleanup allocated IRQs before
leaving the scope.

Fixes: 2dddc514b6e4 ("ASoC: Intel: avs: Move snd_hdac_i915_init to before probe_work.")
Signed-off-by: Cezary Rojewski <cezary.rojewski@intel.com>
Link: https://lore.kernel.org/r/20240202114901.1002127-1-cezary.rojewski@intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/intel/avs/core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/intel/avs/core.c b/sound/soc/intel/avs/core.c
index 59c3793f65df..db78eb2f0108 100644
--- a/sound/soc/intel/avs/core.c
+++ b/sound/soc/intel/avs/core.c
@@ -477,6 +477,9 @@ static int avs_pci_probe(struct pci_dev *pci, const struct pci_device_id *id)
 	return 0;
 
 err_i915_init:
+	pci_free_irq(pci, 0, adev);
+	pci_free_irq(pci, 0, bus);
+	pci_free_irq_vectors(pci);
 	pci_clear_master(pci);
 	pci_set_drvdata(pci, NULL);
 err_acquire_irq:
-- 
2.43.0



