Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32EA2259CBD;
	Tue, 17 Feb 2026 20:47:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361225; cv=none; b=Lkwf58SK/MiOdkNc+tWK/HC3c3rnWOoPalq5Liu2ecmTaAeVoSjaT5E8MDJubkgM8yWhQfIZLCYSMR8r5t00Uo5jiz7IF90qU9PjY1jxf2OGt7Ld/cm7jNhUOjz+3oK9MKMJtRbVqArL70RktEuVYjrcissAmnulhO4Z0e/NP94=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361225; c=relaxed/simple;
	bh=vRw1fgIZX+mFRnsaLiMtIVXCs4Axph9YIrIXh+tz3FI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mNL6Zr1JT2Y/KY6du520OARDrxahdftNiEsb0dzNmkZqW+h5KJXZraFhyYmXpMtjhi4j1mv5GNs5AXXAc0syuLHj4mzwC4mjkXQU03Mo/tvEXZWkhF4G9jCPw/GdeFiqNfcT8t+7u+bI0TATl/fUd7v9o6PBM0enoOumLm1FK+Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VUL54AnG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VUL54AnG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A0D7C4CEF7;
	Tue, 17 Feb 2026 20:47:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361225;
	bh=vRw1fgIZX+mFRnsaLiMtIVXCs4Axph9YIrIXh+tz3FI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VUL54AnGXXL1rYCcafSrNBuER4rSrXi9dGvZ2uSzhrBGAi54IPbV+GJP2nvMjXd2D
	 A/9FYm+Pe8R84bD8+TkrCX4Sjd5ZT4CISiUlcOwNzCPTahbdbF9SRFy52JSbLALuAb
	 NMzjbc1ILNVvbvD+ZxcrlzDyPgXbtS2Fi/AH2Tak=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 38/64] ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()
Date: Tue, 17 Feb 2026 21:31:34 +0100
Message-ID: <20260217200008.935275555@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200007.505931165@linuxfoundation.org>
References: <20260217200007.505931165@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit f514248727606b9087bc38a284ff686e0093abf1 ]

fsl_xcvr_activate_ctl() has
lockdep_assert_held(&card->snd_card->controls_rwsem),
but fsl_xcvr_mode_put() calls it without acquiring this lock.

Other callers of fsl_xcvr_activate_ctl() in fsl_xcvr_startup() and
fsl_xcvr_shutdown() properly acquire the lock with down_read()/up_read().

Add the missing down_read()/up_read() calls around fsl_xcvr_activate_ctl()
in fsl_xcvr_mode_put() to fix the lockdep assertion and prevent potential
race conditions when multiple userspace threads access the control.

Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260202174112.2018402-1-n7l8m4@u.northwestern.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 5b61b93772d64..e6c0e6609cbe0 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -203,10 +203,13 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 
 	xcvr->mode = snd_soc_enum_item_to_val(e, item[0]);
 
+	down_read(&card->snd_card->controls_rwsem);
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_ARC));
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_EARC));
+	up_read(&card->snd_card->controls_rwsem);
+
 	/* Allow playback for SPDIF only */
 	rtd = snd_soc_get_pcm_runtime(card, card->dai_link);
 	rtd->pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream_count =
-- 
2.51.0



