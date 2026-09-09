Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BB3C158038B;
	Wed,  9 Sep 2026 14:22:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963774; cv=none; b=Kgmg/GCBA54ecZuKHr84j25UkWJZCb4DcWM0vlexzQiqGQXUDvG02zicifcEwfCB5iLPmpAKqO0j3yVo9g12EcnLdHbZ1Eqc1ApYXdYXQOS2R+IpS4Jnj5Kj9duoOc9b/rZ7x+3FfaJVe/MEehdkzz+G6qO0Guinoma0x0h6S78=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963774; c=relaxed/simple;
	bh=SdWolGlwVE0nwLI74gKOeTA9wb5AhgsNVCZjSlvdqD8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iADsVHbFhjmVFMZwzr+CYmCqB6gGdPi8PukUKGMr941PoIYV/B7mgXB0PJ2YlsAstBC+xkemiL9krdrj2b/iM15g3rNemztb5BPBL6xWxNQUmBaq18x0MxDjH3IxMvGvhhihUdxAEUzhJTtG9B9Zveio5V8spKfAJvMAiPVxgA4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AvNtX8cn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AvNtX8cn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BE0B1F00A3A;
	Wed,  9 Sep 2026 14:22:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963773;
	bh=fdTAWNk52S7hMBn1PrHvCncWqcDJLB/YELeiMz1gzCQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AvNtX8cnneg1L/LFcmOB3YuyD8XsZeElP0ED0IzyEWeV5/zpuQmloLbMRIy+1IVjY
	 87GmOxKtKMg2FyLcWjHyfqDSLV3tbugKh6BnfQtCEyWr96pB7PSTDAJLSLpwKEwt+w
	 FIVA0wTJJuhY7aZk4bCoMg91ZURt9Xt5CSiQekVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 194/583] ASoC: tas2780: sort the register default table
Date: Wed,  9 Sep 2026 15:37:59 +0200
Message-ID: <20260909134244.885249121@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit e725093e9e53db9298e38e7332a44dcaac2fd135 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

TAS2780_DVC (0x1a) is listed before TAS2780_CHNL_0 (0x03), which makes
it unreachable.  regcache_reg_needs_sync() then cannot compare it
against its default and reports that a sync is needed, so it is written
to the device on every regcache_sync() even when it was never touched.

Sort the table by register address.

Fixes: eae9f9ce181b ("ASoC: add tas2780 driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805104149.9795-5-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/tas2780.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/tas2780.c
+++ b/sound/soc/codecs/tas2780.c
@@ -530,13 +530,13 @@ static const struct reg_default tas2780_
 	{ TAS2780_PAGE, 0x00 },
 	{ TAS2780_SW_RST, 0x00 },
 	{ TAS2780_PWR_CTRL, 0x1a },
-	{ TAS2780_DVC, 0x00 },
 	{ TAS2780_CHNL_0, 0x00 },
 	{ TAS2780_TDM_CFG0, 0x09 },
 	{ TAS2780_TDM_CFG1, 0x02 },
 	{ TAS2780_TDM_CFG2, 0x0a },
 	{ TAS2780_TDM_CFG3, 0x10 },
 	{ TAS2780_TDM_CFG5, 0x42 },
+	{ TAS2780_DVC, 0x00 },
 };
 
 static const struct regmap_range_cfg tas2780_regmap_ranges[] = {


