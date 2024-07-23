Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17E4B158858;
	Tue, 23 Jul 2024 18:28:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759309; cv=none; b=T/1zAA8uydeyk4ppuJzgRcWJ5zNvfMcAo7Zaa3veT9ISH54vMN1PaTZ6RyZ/4sF9zS3sSN6m7WGdq/u86JptOwOAXxBQlb1UdvFX+1PeNSzLCw8at6V+Pkp6s4GDLBNIZo5FP9mLOHBtko41i/ILQ4pKyZl4IPcXRIViceUX6Rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759309; c=relaxed/simple;
	bh=xQ2Vxc1PsuBgc2+FWENJw/NG0X/jFysdZy5Z9uH2AmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RuhDS8x7ja31zAzT3IQhVypBPUvQnW+VxIYBbcwAJxJM8GUVUYRvffrBzxOMBS7W2aSRpfe4G9cZj6RJleP4dk8q84Wa6c+uQoAp4Xmv3rsWdK3s2yzLDoeieB/m/COry4OgkY1jUB04rENbZ/XYm+IYNgNjq+cnETjk4xSY0R8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SxPBwfu9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SxPBwfu9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91E51C4AF09;
	Tue, 23 Jul 2024 18:28:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759309;
	bh=xQ2Vxc1PsuBgc2+FWENJw/NG0X/jFysdZy5Z9uH2AmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SxPBwfu93lsdJNXh1TExQdrxxsRgFuViloc16KFRdFSzmlN162rvQE29wwpqOxoGL
	 xJI86XjD842HJJoO29eD8Pe4j50T7cOpn5fV0sjLV3hQ/ON5YbQTh6EaKTRivnuexF
	 VlJDsBUzBZYwUW+9oCKy5P2DVIzpiVp1LE02FWck=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/105] ALSA: PCM: Allow resume only for suspended streams
Date: Tue, 23 Jul 2024 20:23:50 +0200
Message-ID: <20240723180406.059575354@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180402.490567226@linuxfoundation.org>
References: <20240723180402.490567226@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 1225675ca74c746f09211528588e83b3def1ff6a ]

snd_pcm_resume() should bail out if the stream isn't in a suspended
state.  Otherwise it'd allow doubly resume.

Link: https://patch.msgid.link/20240624125443.27808-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/pcm_native.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/sound/core/pcm_native.c b/sound/core/pcm_native.c
index 9238abbfb2d62..2b73518e5e314 100644
--- a/sound/core/pcm_native.c
+++ b/sound/core/pcm_native.c
@@ -1781,6 +1781,8 @@ static int snd_pcm_pre_resume(struct snd_pcm_substream *substream,
 			      snd_pcm_state_t state)
 {
 	struct snd_pcm_runtime *runtime = substream->runtime;
+	if (runtime->state != SNDRV_PCM_STATE_SUSPENDED)
+		return -EBADFD;
 	if (!(runtime->info & SNDRV_PCM_INFO_RESUME))
 		return -ENOSYS;
 	runtime->trigger_master = substream;
-- 
2.43.0



