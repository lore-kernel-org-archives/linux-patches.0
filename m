Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B5765632A6;
	Wed,  9 Sep 2026 14:23:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963824; cv=none; b=ijLppHQwAx/5FL6pe/oC5VlnTXilp8ICOxZZ13XGBqyCj3Hsn7MwbEeB3bt9wzxan5QK1lYJ4/oQZFxngi1eQMyLUjnzEMKMxSCOaAyLulxI+3H1OKmY1pOefQJ4T+FB8C0S0+/XRYN+bYramKWy3t+BzBGyPCmrrPBu2RjXDUg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963824; c=relaxed/simple;
	bh=wkDYLS2LmVHa3RXRD7XJ5AlwjJHXXp1YUPkkZBt+ZLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=prxvce9qz+nIuxg8HFqqlQQkmAjWpxmKeyG8y6oO+9tjwwOYuyjJD8xJ9lCdqP5mOonProSLdE7jIxuQv0qim8w370Z4fIFmA4XObdfm22MADq287fp/0GHPA8IKNn16n6LCUPTpyOXsk6myj4vRSEqxoV6w4gZZEll0WsZo57U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NgnjFsgC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NgnjFsgC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 498071F00A3A;
	Wed,  9 Sep 2026 14:23:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963822;
	bh=pi3GuN72x6pIQ6SP9EjzYQmtkT9XAgLA3eyKEZ+NqCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NgnjFsgCI3yftfhM3NGcbf44O3KLtgMmU2KPF3qm64fbUgOXaorFBFA5J8EtZ1u4I
	 m0seceY1qLwvF6e9focMA9fA1zavILHlItrRIYCfoJ4IVQM221aHQxbEnZZEL04IjS
	 Oz1VMIpKt3AHtD1SnGwu8YiFQOnqT6ei1vOkbokg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 174/583] ASoC: rt1318-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:37:39 +0200
Message-ID: <20260909134244.222837980@linuxfoundation.org>
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

commit 3673b33633a5daf2f52aff03b57f7b25352fe234 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt1318_reg_defaults[] is not in address order, so the binary search does
not find 3 of its entries.  regcache_reg_needs_sync() then cannot compare
those against their default and reports that a sync is needed, so they
are written to the device on every regcache_sync() even when they were
never touched.

Sort the table by register address.

Fixes: 6ad73a2b42ea ("ASoC: rt1318: Add RT1318 SDCA vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-18-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1318-sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/rt1318-sdw.c
+++ b/sound/soc/codecs/rt1318-sdw.c
@@ -236,10 +236,10 @@ static const struct reg_default rt1318_r
 	{ 0xf805, 0x00 },
 	{ 0xf806, 0x07 },
 	{ 0xf807, 0xff },
-	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_UDMPU21, RT1318_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_FU21, RT1318_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_FU21, RT1318_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_PDE23, RT1318_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_UDMPU21, RT1318_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1318_SDCA_ENT_CS21, RT1318_SDCA_CTL_SAMPLE_FREQ_INDEX, 0), 0x09 },
 };
 


