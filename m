Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D3EB565117;
	Wed,  9 Sep 2026 13:58:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962313; cv=none; b=X3vcX6vzBduO/0d8SC0VyJAWuIRaHEl5tpI4d6nuvVH2D8WJfoBIzcvgvzwqACYJt1uvWU0YQJ1njX8aHu5eOlCLJ60DtVGqrmBwIMOXTBqhVtnLeYTatBDYIPUsewr2Pho++y1sK8/DjS43sRP9j29cRrOxBkeaz6F2qeGNHSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962313; c=relaxed/simple;
	bh=ifOlT8OVdyKzjYqIPi54A/kGrm6bpzRiViOxU+ia6gY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sFM2aVoeNgspVY8AiIEJ2YX49cHBdIVDfgGjO0AaOu3Pcoc7JbLVgj5cvH/KrLBIfJCluy23l6zomMgefl0aTNbdClzCY3FQbO4bvIXZio4irIKucEgO16vCqG2azJzsoK6UOpacUjMk+dMHchwGj5z71fxdXOsuFW2/oCnWcsI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wW2SlokD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wW2SlokD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9153D1F00A3D;
	Wed,  9 Sep 2026 13:58:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962312;
	bh=A30p1mMuEJT9PaaGeczwdQbGY2T0Uw+XrBFpH/2L9n4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wW2SlokDwS/xABHaN6lvjolUq6qSSMlTDWKfAD2mxQ7bB6ctVetoy/abyomFFbeZ1
	 9Ti2QBJf9zBn9PnpMdIEquMMKEI8/qeMPQuKqYED1o36coV6GoA9YXExirPE61zMla
	 ZvyY7blfzHe1kOzcvJ1zOdkO8qV2TQRHWv5AKl5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 246/556] ASoC: rt712-sdca-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:38:46 +0200
Message-ID: <20260909134239.097759281@linuxfoundation.org>
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

commit efd430c4d0426e60fbec400c5a8ce62d886f6e21 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt712_sdca_reg_defaults[] is grouped by SDCA function instead, so the
binary search does not find 4 of its entries.  regcache_reg_needs_sync()
then cannot compare those against their default and reports that a sync
is needed, so they are written to the device on every regcache_sync()
even when they were never touched.

One of them is the Mic Array Clock Source 0x1C Sample Frequency Index
control, which a part without that function rejects:

  soundwire_intel.link.0: Msg ignored for Slave 6, addr: 0x8e00

Sort the table by register address.

Fixes: 936abb09c1c7 ("ASoC: rt712-sdca: add the function for version B")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-10-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt712-sdca-sdw.h |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/sound/soc/codecs/rt712-sdca-sdw.h
+++ b/sound/soc/codecs/rt712-sdca-sdw.h
@@ -11,21 +11,21 @@
 #include <linux/regmap.h>
 #include <linux/soundwire/sdw_registers.h>
 
+/* must stay sorted by register address, regcache_lookup_reg() does a bsearch() */
 static const struct reg_default rt712_sdca_reg_defaults[] = {
-
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_CS01, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_CS11, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_USER_FU05, RT712_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_USER_FU05, RT712_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_USER_FU0F, RT712_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_USER_FU0F, RT712_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_PDE40, RT712_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_PDE12, RT712_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1C, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_CS01, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_CS11, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT712_SDCA_ENT_PDE40, RT712_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_03), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_USER_FU1E, RT712_SDCA_CTL_FU_MUTE, CH_04), 0x01 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1C, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT712_SDCA_ENT_CS1F, RT712_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT712_SDCA_ENT_USER_FU06, RT712_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT712_SDCA_ENT_USER_FU06, RT712_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
@@ -34,6 +34,7 @@ static const struct reg_default rt712_sd
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT712_SDCA_ENT_OT23, RT712_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
 };
 
+/* must stay sorted by register address, regcache_lookup_reg() does a bsearch() */
 static const struct reg_default rt712_sdca_mbq_defaults[] = {
 	{ 0x2000004, 0xaa01 },
 	{ 0x200000e, 0x21e0 },


