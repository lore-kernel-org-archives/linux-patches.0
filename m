Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D038B560AB3;
	Wed,  9 Sep 2026 13:58:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962305; cv=none; b=WKjjsGZKxHm9uWl71fp0/blDd48xzGo7K06MKNjtgTViQMsHip4g02GlmTUttBiN790U2dEN8AdGJDys6uasJOtFOIfQUcgRZIu5NcxxhWrMhhNzqel6IhOE8SDkOKQdiclSqm/3iTvafktBSfoUXQcsn2LQLu+rgxJBgoqcfUE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962305; c=relaxed/simple;
	bh=3jiNF02yxjH+9KZ4izVtnU9naFwuhlSzOgC+5EWea1E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KhTWMcPLlm5+PcLT+KJRooOHSZFMTSomGGRqCyVIk+UYA3PTxF3OI9ATzD09jsAeRM4B2gZTC4OQwC8S5MgJJx84q1GUqzPI0Gu4QY1Mi8pRhkaL8gTQtA21/VVzfQ16QbwpqfcG3SlRJsOkU6VomcywD0oevJhw1EkHOimRwpI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qlKALRDh; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qlKALRDh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7AF91F00A3A;
	Wed,  9 Sep 2026 13:58:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962303;
	bh=bPlYIETaERYuqxAYHuA6q1yYy7VIF3PZOygz6XO62uw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qlKALRDhfhpsuHeQh8z/OGE5onBgjfjRCpPnhb3QUbxYpTz0BMuGHP3eyXY07cZq8
	 PFEUrwC4oCWYwHifXAEAGNgkvn+uDwbuSJncI5qre0uL4kOzx4eyxjAhtaGfhirrcB
	 kleVXVXMFveJ6ekhWsRjt7x8js/pmPOxjm0B1MVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 243/556] ASoC: rt711-sdca: sort the register default tables
Date: Wed,  9 Sep 2026 15:38:43 +0200
Message-ID: <20260909134238.988864704@linuxfoundation.org>
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

commit b8fdd467bb5d2eb89b665331065e9e3ade964a3e upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

Both tables group the entries by SDCA entity instead: in
rt711_sdca_reg_defaults[] the CS01 sample frequency index is listed before
the FU05 controls (1 of 54 entries unreachable), and in
rt711_sdca_mbq_defaults[] the MIC_ARRAY FU1E volumes are listed before the
JACK_CODEC FU0F volumes (2 of 25 entries unreachable).
regcache_reg_needs_sync() then cannot compare those against their default
and reports that a sync is needed, so they are written to the device on
every regcache_sync() even when they were never touched.

Sort both tables by register address.

Fixes: 7ad4d237e7c4 ("ASoC: rt711-sdca: Add RT711 SDCA vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-8-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt711-sdca-sdw.h |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/sound/soc/codecs/rt711-sdca-sdw.h
+++ b/sound/soc/codecs/rt711-sdca-sdw.h
@@ -58,12 +58,12 @@ static const struct reg_default rt711_sd
 	{ 0x2f0f, 0x00 },
 	{ 0x2f50, 0x03 },
 	{ 0x2f5a, 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_CS01, RT711_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU05, RT711_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU05, RT711_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU0F, RT711_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU0F, RT711_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_PDE28, RT711_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_CS01, RT711_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 };
@@ -86,14 +86,14 @@ static const struct reg_default rt711_sd
 	{ 0x610003f, 0xff12 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU05, RT711_SDCA_CTL_FU_VOLUME, CH_L), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU05, RT711_SDCA_CTL_FU_VOLUME, CH_R), 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_VOLUME, CH_L), 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_VOLUME, CH_R), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU0F, RT711_SDCA_CTL_FU_VOLUME, CH_L), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_USER_FU0F, RT711_SDCA_CTL_FU_VOLUME, CH_R), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_PLATFORM_FU44, RT711_SDCA_CTL_FU_CH_GAIN, CH_L), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_JACK_CODEC, RT711_SDCA_ENT_PLATFORM_FU44, RT711_SDCA_CTL_FU_CH_GAIN, CH_R), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_PLATFORM_FU15, RT711_SDCA_CTL_FU_CH_GAIN, CH_L), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_PLATFORM_FU15, RT711_SDCA_CTL_FU_CH_GAIN, CH_R), 0x00 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_VOLUME, CH_L), 0x00 },
+	{ SDW_SDCA_CTL(FUNC_NUM_MIC_ARRAY, RT711_SDCA_ENT_USER_FU1E, RT711_SDCA_CTL_FU_VOLUME, CH_R), 0x00 },
 };
 
 #endif /* __RT711_SDW_SDCA_H__ */


