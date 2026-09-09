Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A64156B86A;
	Wed,  9 Sep 2026 14:22:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963752; cv=none; b=lGa/jHo3CfY1YNYEfKNKXYkcBfkW+3l956iuV8zN97SkdGXivhPlt2Sqqaf1/shdoOmFE4h16vSazDwaIFRE9MsIDAee3pE/BWkzgBgn8pT0qtT9DZy4s3FvKE88RXuIFiZDBVt3XiD0QewCqFsuG2FNcpZee0CFwP5XQIsl+k0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963752; c=relaxed/simple;
	bh=P7nzaQrHZvLdae9t95eY56fjNKQC7le8MB8aUcjL6Z8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j05N163Jr59JYLD0l3XKZ/tIX96oJX5hL6BZrR6JGJVNOeF2jBqnHSETYn3HbBU2p2a5odhojOFY8hZjMU7aZjs27OhNb8NnY6DsaG7mI6c8iyBlwZOqpr20s9w+vGNFopa8XnaoQAzTsD0NvixtaoTNVzqK2YcKOxJ+0zhjtjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=t4htw9MN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="t4htw9MN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1D291F00A3D;
	Wed,  9 Sep 2026 14:22:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963751;
	bh=Ow8ayq9bWV1L6ETWNZKJlibOOJr31IQaOKdBsYyOMTs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=t4htw9MNK+1NDFfIQDRPBvghqp50MP8BVYFwOImt/FIvjHdXXw1mPlY3G2da8X2IE
	 6y5eAewBlDcejSU+hXhjjEcF9tQExwMqicl3ZYyd/IualDRF2UWJ8C7F0MjIF0pLQC
	 ppMVGcvN9bPRA/G9DE991ucjjEv37/GbAxLzcurU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 188/583] ASoC: rt721-sdca-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:37:53 +0200
Message-ID: <20260909134244.688918073@linuxfoundation.org>
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

commit 70e0481c196e4822e683bca384e6bda89d944839 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt721_sdca_reg_defaults[] is grouped by SDCA function instead, so the
binary search does not find 12 of its entries.  regcache_reg_needs_sync()
then cannot compare those against their default and reports that a sync
is needed, so they are written to the device on every regcache_sync()
even when they were never touched.

Sort the table by register address.

Fixes: 86ce355c1f9a ("ASoC: rt721-sdca: Add RT721 SDCA driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-14-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt721-sdca-sdw.h |   28 ++++++++++++++--------------
 1 file changed, 14 insertions(+), 14 deletions(-)

--- a/sound/soc/codecs/rt721-sdca-sdw.h
+++ b/sound/soc/codecs/rt721-sdca-sdw.h
@@ -29,14 +29,6 @@ static const struct reg_default rt721_sd
 	{ 0x2f5b, 0x07 },
 	{ 0x2f5c, 0x27 },
 	{ 0x2f5d, 0x07 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_CS01,
-		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_CS11,
-		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_PDE12,
-		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_PDE40,
-		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_USER_FU05,
 		RT721_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_USER_FU05,
@@ -45,6 +37,14 @@ static const struct reg_default rt721_sd
 		RT721_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_USER_FU0F,
 		RT721_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_PDE12,
+		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_CS01,
+		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_CS11,
+		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT721_SDCA_ENT_PDE40,
+		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_USER_FU1E,
 		RT721_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_USER_FU1E,
@@ -53,30 +53,30 @@ static const struct reg_default rt721_sd
 		RT721_SDCA_CTL_FU_MUTE, CH_03), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_USER_FU1E,
 		RT721_SDCA_CTL_FU_MUTE, CH_04), 0x01 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_PDE2A,
+		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_CS1F,
 		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_IT26,
 		RT721_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT721_SDCA_ENT_PDE2A,
-		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
-	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_CS31,
-		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_USER_FU06,
 		RT721_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_USER_FU06,
 		RT721_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_PDE23,
 		RT721_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
-	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_OT23,
-		RT721_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_PDE23,
 		RT721_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_PDE23,
 		RT721_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
+	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_CS31,
+		RT721_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_FU55,
 		RT721_SDCA_CTL_FU_MUTE, CH_01), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_FU55,
 		RT721_SDCA_CTL_FU_MUTE, CH_02), 0x01 },
+	{ SDW_SDCA_CTL(FUNC_NUM_AMP, RT721_SDCA_ENT_OT23,
+		RT721_SDCA_CTL_VENDOR_DEF, 0), 0x00 },
 };
 
 static const struct reg_default rt721_sdca_mbq_defaults[] = {


