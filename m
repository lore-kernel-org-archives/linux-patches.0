Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87FF9318EE6;
	Wed, 25 Feb 2026 06:59:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002758; cv=none; b=Um9ANDt/pgRdlnCrxM5I0TjJ3VviGshSYGItyqgtwg+Y0xpmYl+oH3xzg6u7xOSvo9B3cYkYLaC1yjEkh4QsIqdZR1Mc0r9UH0lLOhnausCMZJjxvNCUUFy7A9oB8H2JI2b7jJsMy2QuYXF39hYe6+6wlQ76gx3louJslKw8gFY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002758; c=relaxed/simple;
	bh=8n7qCmy5nHInLyGipCaqLMFM//Z72E/hb5lOaOqklyQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KL3jAe60mOvcFHDmS05BiDVtbicPfU8GToInzwQRwi+TWQpuOuHVCD2UvbEivqd3qsQIDt2Vo2Urgz4JOGiyRj0aBSJvQXWV2TysGi2ZwSjlwN4LQv3YWbv2lxqMwRFiSuek2RO16r3KlX1xmEtnWwIgnBvoQuGvCQJVMrxnoEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JLdhVUkh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JLdhVUkh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 61E8CC116D0;
	Wed, 25 Feb 2026 06:59:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002758;
	bh=8n7qCmy5nHInLyGipCaqLMFM//Z72E/hb5lOaOqklyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JLdhVUkhuybMaGNPZtDXZ3SwALCEmE8MzDbxF1/46hoUqZnLjhGMdiYlKcA5IWWs3
	 aeqquIXpBaqawQdnfTC58jWmY3gH6+pVjNmbv32GeWwkhGThpleHVcqxoLnP8b3FAu
	 gyX8fSQrDXDRfLli/clyeyIyo9t796I4XXwgHdkI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Ziyi Guo <n7l8m4@u.northwestern.edu>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 586/641] ASoC: fsl_xcvr: Revert fix missing lock in fsl_xcvr_mode_put()
Date: Tue, 24 Feb 2026 17:25:12 -0800
Message-ID: <20260225012402.711196080@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

From: Ziyi Guo <n7l8m4@u.northwestern.edu>

[ Upstream commit 9f16d96e1222391a6b996a1b676bec14fb91e3b2 ]

This reverts commit f51424872760 ("ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()").

The original patch attempted to acquire the card->controls_rwsem lock in
fsl_xcvr_mode_put(). However, this function is called from the upper ALSA
core function snd_ctl_elem_write(), which already holds the write lock on
controls_rwsem for the whole put operation. So there is no need to simply
hold the lock for fsl_xcvr_activate_ctl() again.

Acquiring the read lock while holding the write lock in the same thread
results in a deadlock and a hung task, as reported by Alexander Stein.

Fixes: f51424872760 ("ASoC: fsl_xcvr: fix missing lock in fsl_xcvr_mode_put()")
Reported-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Closes: https://lore.kernel.org/linux-sound/5056506.GXAFRqVoOG@steina-w/
Signed-off-by: Ziyi Guo <n7l8m4@u.northwestern.edu>
Link: https://patch.msgid.link/20260210185714.556385-1-n7l8m4@u.northwestern.edu
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/fsl/fsl_xcvr.c | 3 ---
 1 file changed, 3 deletions(-)

diff --git a/sound/soc/fsl/fsl_xcvr.c b/sound/soc/fsl/fsl_xcvr.c
index 51669e5fe8888..58db4906a01d5 100644
--- a/sound/soc/fsl/fsl_xcvr.c
+++ b/sound/soc/fsl/fsl_xcvr.c
@@ -223,13 +223,10 @@ static int fsl_xcvr_mode_put(struct snd_kcontrol *kcontrol,
 
 	xcvr->mode = snd_soc_enum_item_to_val(e, item[0]);
 
-	down_read(&card->snd_card->controls_rwsem);
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_arc_mode_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_ARC));
 	fsl_xcvr_activate_ctl(dai, fsl_xcvr_earc_capds_kctl.name,
 			      (xcvr->mode == FSL_XCVR_MODE_EARC));
-	up_read(&card->snd_card->controls_rwsem);
-
 	/* Allow playback for SPDIF only */
 	rtd = snd_soc_get_pcm_runtime(card, card->dai_link);
 	rtd->pcm->streams[SNDRV_PCM_STREAM_PLAYBACK].substream_count =
-- 
2.51.0



