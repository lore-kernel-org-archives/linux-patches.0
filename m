Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E3A75678D0;
	Wed,  9 Sep 2026 13:58:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962319; cv=none; b=AzmUz/yzldVJo8md6SO4felx2tJpXqwcTNFAYP0WrfyArD/Q6tF1qFJ5bsETuuzRerGUXKOzRAcMTNuIq5j30hQkVm5vW7vJQc0Vb5TDbKM1r2ftcWRKaYV/nkvf94UXSGny5TL/siq57imDYYbGrsHHKzSU1aj0NSXHmXG8y6o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962319; c=relaxed/simple;
	bh=wnsLuziEc6fN+CT+iwOPMyZEvkVEe4KuclbQtrKWbfE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nBy1jxP7BqPa+soCiUj3fvwms7bMHP0rg7mIoWFW1c5Qa7GIfPlxCFsrnv88qejrzfnsdJEc2sA34lT6He7fCQPVjrKz/dZd/1w9XtxcUUrO+ETfZNadyUWP5agkXQIvEHUf7mRqAm4GieD4eXYPhgzoCoXzFasFTSty5vPkpuY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HSNbRQwQ; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HSNbRQwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5A5931F00A3A;
	Wed,  9 Sep 2026 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962317;
	bh=xUwd4hmCWWAz6qKoYtNspnCucsv8IIZbtKXu8EN+Ivk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HSNbRQwQ0aPqnHKBGPYpg232vUpnW1hj3J5KxRqJWnih8YYLCH+6q6yhV8O57zgt6
	 5e6t0m1S6ERgM+dhZyFXlQtwTIlWw9EVZarAnOfhBOuTxKA9QVFZSMvnD194C0oZRF
	 kGaa5PMdtHs3Y+QHxMNlg3wJqyL2odOLqm4OaEPs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 248/556] ASoC: rt715-sdca: sort the register default tables
Date: Wed,  9 Sep 2026 15:38:48 +0200
Message-ID: <20260909134239.204642569@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>

commit 61a0321e4bc2ff9ecb38cda7d5a32ffacef71a75 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

Both tables group the entries by SDCA entity instead: in
rt715_reg_defaults_sdca[] the CX_CLK_SEL control is listed before the
ADC8_9, ADC10_11 and ADC7_27 mute controls (7 of 78 entries unreachable),
and in rt715_mbq_reg_defaults_sdca[] the AMIC_GAIN_EN CH_08 entry is listed
before the DMIC_GAIN_EN entries (1 of 32 entries unreachable).
regcache_reg_needs_sync() then cannot compare those against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort both tables by register address.

Fixes: 20d17057f0a8 ("ASoC: rt715-sdca: Add RT715 sdca vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-13-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt715-sdca-sdw.h |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/sound/soc/codecs/rt715-sdca-sdw.h
+++ b/sound/soc/codecs/rt715-sdca-sdw.h
@@ -76,8 +76,6 @@ static const struct reg_default rt715_re
 	{ 0x2f52, 0x01 },
 	{ 0x2f5a, 0x02 },
 	{ 0x2f5b, 0x05 },
-	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_CX_CLK_SEL_EN,
-		RT715_SDCA_CX_CLK_SEL_CTRL, CH_00), 0x1 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC8_9_VOL,
 		RT715_SDCA_FU_MUTE_CTRL, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC8_9_VOL,
@@ -98,6 +96,8 @@ static const struct reg_default rt715_re
 		RT715_SDCA_FU_MUTE_CTRL, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_ADC7_27_VOL,
 		RT715_SDCA_FU_MUTE_CTRL, CH_02), 0x01 },
+	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_CX_CLK_SEL_EN,
+		RT715_SDCA_CX_CLK_SEL_CTRL, CH_00), 0x1 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_SMPU_TRIG_ST_EN,
 		RT715_SDCA_SMPU_TRIG_EN_CTRL, CH_00), 0x02 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_SMPU_TRIG_ST_EN,
@@ -145,8 +145,6 @@ static const struct reg_default rt715_mb
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_06), 0x00 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_AMIC_GAIN_EN,
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_07), 0x00 },
-	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_AMIC_GAIN_EN,
-		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_08), 0x00 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_DMIC_GAIN_EN,
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_01), 0x00 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_DMIC_GAIN_EN,
@@ -161,6 +159,8 @@ static const struct reg_default rt715_mb
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_06), 0x00 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_DMIC_GAIN_EN,
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_07), 0x00 },
+	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_AMIC_GAIN_EN,
+		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_08), 0x00 },
 	{ SDW_SDCA_CTL(FUN_MIC_ARRAY, RT715_SDCA_FU_DMIC_GAIN_EN,
 		RT715_SDCA_FU_DMIC_GAIN_CTRL, CH_08), 0x00 },
 };


