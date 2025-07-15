Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6374B2ECD3C;
	Tue, 15 Jul 2025 13:38:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586698; cv=none; b=VDjomGXph7HoX9cQ6lPAIE1TjnWwAhhohffhs+8f8IdC4hPL4V7PeX9MR1/sM7AKDkqS1i40oEZExxNJAg0j8Gt6nsBQeqwwIjUTFjD/OqXfmHiBg3IhDAi80H8oHEqYjQH1NKKSUCIvRjPyJCQOAAog1u20NIqqPuRwNQ7jScs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586698; c=relaxed/simple;
	bh=caCSB1tiO4wnPqnKJOt5vBdMXclyK4M8thMvNFLPjPI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IW8sQzYNM8Xvnr8xH5BD3O5TPeiybkMBoVpFzzyiY2PLFGSjKmr16WWF8gqIxRoda7FB3kkNAWY4ZaEC8n4k7ZsTWZMIP7FTKKCXO24xQQQSzPCDTR6sNGf+182Qm3gIG88UPQGS28MHSJMza+avUZdO87760fHfbuj0i2HUhWM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YOXx6BgS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YOXx6BgS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1044C4CEF6;
	Tue, 15 Jul 2025 13:38:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586698;
	bh=caCSB1tiO4wnPqnKJOt5vBdMXclyK4M8thMvNFLPjPI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YOXx6BgSWOe9mObbwgJ/ayE/NXEK6usWmBFDA4BXsaOSEcYGIFX7JT44m6kqyprYh
	 sC/YBWN8B3hoqf5gOf/VVIicWj+LF8pdc6byaZQ9fp6ntC19RrGGY3e1UlZE7bEiHB
	 5JDv0aWfkVvd6foMH2kmoMpoPaSa2EVhjrN3oJtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Richard Fitzgerald <rf@opensource.cirrus.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 015/192] ASoC: cs35l56: probe() should fail if the device ID is not recognized
Date: Tue, 15 Jul 2025 15:11:50 +0200
Message-ID: <20250715130815.472942377@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Richard Fitzgerald <rf@opensource.cirrus.com>

[ Upstream commit 3b3312f28ee2d9c386602f8521e419cfc69f4823 ]

Return an error from driver probe if the DEVID read from the chip is not
one supported by this driver.

In cs35l56_hw_init() there is a check for valid DEVID, but the invalid
case was returning the value of ret. At this point in the code ret == 0
so the caller would think that cs35l56_hw_init() was successful.

Signed-off-by: Richard Fitzgerald <rf@opensource.cirrus.com>
Fixes: 84851aa055c8 ("ASoC: cs35l56: Move part of cs35l56_init() to shared library")
Link: https://patch.msgid.link/20250703102521.54204-1-rf@opensource.cirrus.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/codecs/cs35l56-shared.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/soc/codecs/cs35l56-shared.c b/sound/soc/codecs/cs35l56-shared.c
index e28bfefa72f33..016a6248ab8f0 100644
--- a/sound/soc/codecs/cs35l56-shared.c
+++ b/sound/soc/codecs/cs35l56-shared.c
@@ -811,7 +811,7 @@ int cs35l56_hw_init(struct cs35l56_base *cs35l56_base)
 		break;
 	default:
 		dev_err(cs35l56_base->dev, "Unknown device %x\n", devid);
-		return ret;
+		return -ENODEV;
 	}
 
 	cs35l56_base->type = devid & 0xFF;
-- 
2.39.5



