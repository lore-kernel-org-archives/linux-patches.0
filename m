Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BA07563FC2;
	Wed,  9 Sep 2026 13:57:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962278; cv=none; b=XglWfIKET4KoRZSMlH+HDig6kqGBTanTZCNbtME+TnHgrEqhGRT9WMEdUKVokcNFeUAIg9BSDEXHDkPilf004Ntmqbj8nzf+3FqjTgU7HlF2u7XS9/JA1tQ7Hkwe5L4cL6gZI4EajXsNq09kr8HoJ663qHEkyLniT9TB+u3TeRE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962278; c=relaxed/simple;
	bh=XHl2P8CIXyHAW/KX6JLDnX0/l9QawA+/Iso6VypMVlE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V1dNw8gndMjYSxYGPTYBbw3FQAHRehvwEjI28zpwuhhUsDJv9rnPVELHHyCHTCK23vOQgv0xIJHcqw1BpawlDqpQFhP8kohPUBgYE/fsD/Tg6e4k9YT4ep1GyEXx2UlxGK4WvgfZu5A+4+F/2XXh3AmgNOVCTClXAZeGxBilbQA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kloa3D8C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kloa3D8C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 010621F00A3A;
	Wed,  9 Sep 2026 13:57:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962277;
	bh=qQ6ak5NIu9zWD78WFGSOjQ/l9x7HXKTfcNgar0Vxgd4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Kloa3D8CBI2kA+nzoQCx/s9KUuZNKBDC9UtWV1r+VsvPVT3V9kiH2rpB0TBF8kkqw
	 62EeWXfEDKg7G9RiBe16Y5P1J62LfbtcGjb0S8K8LEOeW6/UXWBVHrlFx5w+ngtPCr
	 xg4Nss67yOjVAq55Y5HlVUiNl0fQnhR2BGG0RreU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Peter Ujfalusi <peter.ujfalusi@linux.intel.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.2 235/556] ASoC: rt1316-sdw: sort the register default table
Date: Wed,  9 Sep 2026 15:38:35 +0200
Message-ID: <20260909134238.679008602@linuxfoundation.org>
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

commit 7b48eccfbb9bf15e9b7377a5296bfd01815c62d8 upstream.

reg_defaults must be sorted by ascending register address, as
regcache_lookup_reg() locates entries in it with bsearch().  See commit
fd80df352ba1 ("regcache: Add support for sorting defaults arrays").

rt1316_reg_defaults[] is not in address order, so the binary search does
not find one of its entries.  regcache_reg_needs_sync() then cannot
compare it against its default and reports that a sync is needed, so it
is written to the device on every regcache_sync() even when it was never
touched.

Sort the table by register address.

Fixes: 2b719fd20f32 ("ASoC: rt1316: Add RT1316 SDCA vendor-specific driver")
Cc: stable@vger.kernel.org
Signed-off-by: Peter Ujfalusi <peter.ujfalusi@linux.intel.com>
Link: https://patch.msgid.link/20260805090240.16991-16-peter.ujfalusi@linux.intel.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/rt1316-sdw.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/soc/codecs/rt1316-sdw.c
+++ b/sound/soc/codecs/rt1316-sdw.c
@@ -59,13 +59,13 @@ static const struct reg_default rt1316_r
 	{ 0xd101, 0x00 },
 	{ 0xd102, 0x30 },
 	{ 0xd103, 0x00 },
-	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_UDMPU21, RT1316_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_FU21, RT1316_SDCA_CTL_FU_MUTE, CH_L), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_FU21, RT1316_SDCA_CTL_FU_MUTE, CH_R), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_XU24, RT1316_SDCA_CTL_BYPASS, 0), 0x01 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE23, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE22, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
 	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_PDE24, RT1316_SDCA_CTL_REQ_POWER_STATE, 0), 0x03 },
+	{ SDW_SDCA_CTL(FUNC_NUM_SMART_AMP, RT1316_SDCA_ENT_UDMPU21, RT1316_SDCA_CTL_UDMPU_CLUSTER, 0), 0x00 },
 };
 
 static const struct reg_sequence rt1316_blind_write[] = {


