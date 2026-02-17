Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCBC7286D4D;
	Tue, 17 Feb 2026 20:43:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771361010; cv=none; b=tJIWa1midW14natxofLQIotDPSdMBygq38fmL1l//Atogn0hePoHuy1VLTAM/X8Tb44TuJhohw8aMn4JyQa/gJcFrOBfoVpd6/f1RbjoK0qO+FRA6uj/nwb8GNyr6ffi514S4TiGLX0gGPcgZtqeM5rXNsFvdHY5jP1IarBKS+8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771361010; c=relaxed/simple;
	bh=0OK2YQcIB/lJiBUJ5mpJazhjYWsCNPhtGUJ3zaKGWic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fGtbICD04h8I6E4dWGvNdEhizuC6rvkf2HNuCKZZtyRTf2VOBmzw9SjLWuUkHya8uUfcICMhzKC61HlUluZbVoXPI3+o/mVyxeWuYTQxPbUR12u+Ve78ACryKNLQvt8EqqilCEdozz3DeJa3WLryIG1v1yEKxbCS5o3DNDfhfuQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v/mHMV8e; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v/mHMV8e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AC6C4CEF7;
	Tue, 17 Feb 2026 20:43:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771361010;
	bh=0OK2YQcIB/lJiBUJ5mpJazhjYWsCNPhtGUJ3zaKGWic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v/mHMV8eFqQx8inBbh8UPS0pQDJ/SCPcT0UJjrr7G1v3+8mpOOMIy8fOwB20lKwxc
	 CfqZt2CxSqETgA90soxCesFfJfb8J4nQphtNjZxqYRp9bTPFGug3mUZ+R5s39iyb4a
	 ZIR9is7eTUuEid9SuhBerBm1eU9jnhTFKoBAO6OQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 15/39] ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()
Date: Tue, 17 Feb 2026 21:31:24 +0100
Message-ID: <20260217200003.516889235@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260217200002.929083107@linuxfoundation.org>
References: <20260217200002.929083107@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index ae5960b2b6a95..c4deb09c9a9bc 100644
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



