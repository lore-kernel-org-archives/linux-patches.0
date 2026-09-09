Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1B6A0568FA6;
	Wed,  9 Sep 2026 14:22:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963738; cv=none; b=cuQgBtLQ23dfzKlg5TdEYOJUY1WdyPf2aiC3su3G8JmHvNFO3lCFtLRnqz1Wo7bh/HEcDwjUUJ5oqWzbzc1tn+BD5DfFq3k3kRagR4pDU9tLPLRDzWN9UuulPg0UWsEzur9j5c61yeq06+7uboZDP0iWDn8NaIT3cP0GjbQjiQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963738; c=relaxed/simple;
	bh=Ll2qp9gjO4gVHgl7VixXb5kSL4FrsXUbY01rKGtUUH4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sJtGdIt+XFs7CM+mWcI3iHgAIaJloQJrHkqXPFMGFPlgIusZok6ZbpADgY0QnvxHwKe5a8FeX1DnosLT5JVnu+vjB+1H6d+W2F/XD46wVNt+AGWVESp456q6cS6r4remWr9IQN2r1KoX1yyPtWa8X3DIFf0NM2Wu7TMEIArO2fU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rv6vp/7r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rv6vp/7r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 73ACD1F00A3A;
	Wed,  9 Sep 2026 14:22:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963737;
	bh=Q3yXn8edrp1rwiU+iPtA1iBa0KbdiprT0cXgXf3JQuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rv6vp/7rCV6wdHErgDbXgVKB0dVpDTwcMm11+FnSUzHzURxgTM8jSPNuHhWKkXtW+
	 vcj2GZrOjWoOY6KPIItO7A+kivzoxYOCPvCmlNh2mIhb0Aik4z5uD0OKWsc1w5E+F3
	 fK8T2k3NJQlHGe2w4xx1syB3tQQSYyEvDpeUldyw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 183/583] ASoC: rt712-sdca-dmic: sort the register default table
Date: Wed,  9 Sep 2026 15:37:48 +0200
Message-ID: <20260909134244.521516822@linuxfoundation.org>
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

commit b9339ee3fccc79e751a2f7bde42c5dd57b38b2a9 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt712_sdca_dmic_reg_defaults[] is grouped by SDCA entity instead, so the
binary search does not find 3 of its entries.  regcache_reg_needs_sync()
then cannot compare those against their default and reports that a sync
is needed, so they are written to the device on every regcache_sync()
even when they were never touched.

Sort the table by register address.

Fixes: 63a511284c9e ("ASoC: rt712-sdca: Add RT712 SDCA driver for Mic topology")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-9-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt712-sdca-dmic.h |    6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

--- a/sound/soc/codecs/rt712-sdca-dmic.h
+++ b/sound/soc/codecs/rt712-sdca-dmic.h
@@ -36,6 +36,7 @@ struct rt712_sdca_dmic_kctrl_priv {
 #define CH_03	0x03
 #define CH_04	0x04
 
+/* must stay sorted by register address, regcache_lookup_reg() does a bsearch() */
 static const struct reg_default rt712_sdca_dmic_reg_defaults[] = {
 	{ 0x201a, 0x00 },
 	{ 0x201b, 0x00 },
@@ -72,15 +73,16 @@ static const struct reg_default rt712_sd
 	{ 0x2f59, 0x07 },
 	{ 0x3201, 0x01 },
 	{ 0x320c, 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_IT26, RT712_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_03), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_04), 0x01 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1F, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1C, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1F, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_IT26, RT712_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
 };
 
+/* must stay sorted by register address, regcache_lookup_reg() does a bsearch() */
 static const struct reg_default rt712_sdca_dmic_mbq_defaults[] = {
 	{ 0x0590001e, 0x0020 },
 	{ 0x06100000, 0x0010 },


