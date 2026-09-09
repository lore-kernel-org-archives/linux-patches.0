Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B994553FD2B;
	Wed,  9 Sep 2026 13:58:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962311; cv=none; b=mN2tZJq24a/FQhmMNj2CMz4T4zPJRU76nuBtxfPMMOk8ABPFcCECKNgnI8Wn3UW9zB1suebdPxo0kc+Zy03pxH7w0tpqDCpb95WeLjwIdV8wVRCySU+Beg0YDM/gkZLzeabxjSRZNOww4g8sb7iTIc51H7WYizPJrKG5Tj988wA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962311; c=relaxed/simple;
	bh=HruMZB/6Nt4uF3g0uMglGCRQnCl5wxZ1tz66cZzEKJQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mDw/hUHxkx1gtZl0XnUlPbBNrv+stgSudGAlCfMUm6w/0M+8UTWCHJ2IivP0Nj+20Wc3Dus34rCIkK4Z7V+o0ae939arkRFRi3gtITpEycX2Nvm71CK2jmTMLI5uRiey0Svo/0tOsBrpySn4oiONbCEZKFzJvcFiVAx6YZcnMdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JEqfMNJf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JEqfMNJf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFD831F00A3A;
	Wed,  9 Sep 2026 13:58:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962309;
	bh=Gb3GnRtaDFXkXqvleNVLfLZvD0cZVU/iJICVFl+5IS0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JEqfMNJfad5JKLf04tw4knrWgNgH8/spJBgoQ6lJLouKqLHjZhCl6cjjw8iSlp+i+
	 AW2rioslJSO5b+s4Nhv785DiI2Kflt4UIHexbUQMRaix2lz68rd6GEj3H7dZY0Z2gn
	 N0reBsNT68lAact78oIcxrQCda2+SL+VchyUi/0c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 245/556] ASoC: rt712-sdca-dmic: sort the register default table
Date: Wed,  9 Sep 2026 15:38:45 +0200
Message-ID: <20260909134239.058308802@linuxfoundation.org>
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


