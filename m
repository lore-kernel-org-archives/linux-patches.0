Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B6E4B568FA6;
	Wed,  9 Sep 2026 14:22:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963747; cv=none; b=ptIKo6wUuZPvjXqLgxRgEXzbT1UACo8ysyfxQP61B0wJw46cJsXVxDxIfv7Kb3wHGKyU9/Zn+QSLgn4bNTg7+HA/7MRnBXnR9BgGV3wquqSDPzUIcsxAm7DxxWEgdbGULsjIwXg3ztmYjYVWgGE68a/vX7xeiCDaoviH6w8kIhE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963747; c=relaxed/simple;
	bh=if03MNq+vdroTqb13gm4ZENkktHgu+Jxz4y33Z/HLF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VjfcmS3zbvocIdpXcs3wBsaq7Vi5gV83H7q2hg0r96ddr/iLxwdYAjCwl6RPlWErpYltB5dzG4jiItsnx0TP9jKdGfeuWyhDpA8jhfgj9RMtHlUqKtkEi7KLRMJN6C6rAZi0TT9el6zVcU9c5vTZLBbnbKxzIDWldRJpWhJKFS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Cp5erwH4; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Cp5erwH4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2004A1F00A3D;
	Wed,  9 Sep 2026 14:22:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963745;
	bh=8xCewG9Mc4SSwSPXt4+TF/ic8iYkAtWqA1Fb5GGHZ1g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Cp5erwH4PwqNIlgMw+kGCCxwlVg8YNhFXEAA/MAkfCuNMVF3nwrDl08fcD7BLBv2u
	 pBT8lKdb6bW1SWHwPFyNzjxbQFSYzDEooZw4A55Ry184sJY2muKq6NadVGN3XCBFn+
	 wTWPmYWqh0ugQHgeq8mPFCU1c7csoNp7dhUb0a6U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 186/583] ASoC: rt715-sdca: sort the register default tables
Date: Wed,  9 Sep 2026 15:37:51 +0200
Message-ID: <20260909134244.620632781@linuxfoundation.org>
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


