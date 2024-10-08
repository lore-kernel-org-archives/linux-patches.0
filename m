Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 404DB1DF24A;
	Tue,  8 Oct 2024 13:12:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393130; cv=none; b=RdkxZZlcgpuMOCpyio0WBHarQITXBghm+gGMjbpj2drNe0C7VszYEZVxMHcuDl2ZdDATVcStWmWjMYE9HIzPCFeTWhQdTwX4Jjm38L3E23VKLLAMwPw7+Y1hy5xx9B/bfVfe/Hxly/MAsdygFtL5S8snhODSMa8YGO0sbVtQ/yM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393130; c=relaxed/simple;
	bh=DQDOANH4sKrMHiEKgl4w8S6QxUDF3c55JLXReVuPIHw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PJlFwtcPgxBIXXlxY0p7uN3BT/G3rYjDNxYNj91LSB+dnOels0ppLSNkrzbTXJAntiIes8psMXjChpz4hTn0vk7S43EKmN5FyT/31TJGNAWZGRMCDDayBAkwHZOVma3xQgT/ltsmqXeYb38YINC8XWHNt9sAyPNab+hWoSpd53Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jkdNL7n0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jkdNL7n0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A77B0C4CECF;
	Tue,  8 Oct 2024 13:12:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393130;
	bh=DQDOANH4sKrMHiEKgl4w8S6QxUDF3c55JLXReVuPIHw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jkdNL7n0dLrMFrdWQ5X3aR8jLGMfh1+RsA7ZePPsw53Y+uQDU4cbkSkrxJtFFxDZW
	 jMk61GL+eZSQg0SkYtuVptWhJF45z9tEWcDqWa7cw9/GAtDwUyWx4bL4Rs5iQD3GEy
	 sAMluF+4rw9W/enxAcvbxJwkgULGNfvpR0sWYHm8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/386] ALSA: gus: Fix some error handling paths related to get_bpos() usage
Date: Tue,  8 Oct 2024 14:04:59 +0200
Message-ID: <20241008115631.596921710@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

[ Upstream commit 9df39a872c462ea07a3767ebd0093c42b2ff78a2 ]

If get_bpos() fails, it is likely that the corresponding error code should
be returned.

Fixes: a6970bb1dd99 ("ALSA: gus: Convert to the new PCM ops")
Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Link: https://patch.msgid.link/d9ca841edad697154afa97c73a5d7a14919330d9.1727984008.git.christophe.jaillet@wanadoo.fr
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/isa/gus/gus_pcm.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/sound/isa/gus/gus_pcm.c b/sound/isa/gus/gus_pcm.c
index 850544725da79..d55c3dc229c0e 100644
--- a/sound/isa/gus/gus_pcm.c
+++ b/sound/isa/gus/gus_pcm.c
@@ -378,7 +378,7 @@ static int snd_gf1_pcm_playback_copy(struct snd_pcm_substream *substream,
 
 	bpos = get_bpos(pcmp, voice, pos, len);
 	if (bpos < 0)
-		return pos;
+		return bpos;
 	if (copy_from_iter(runtime->dma_area + bpos, len, src) != len)
 		return -EFAULT;
 	return playback_copy_ack(substream, bpos, len);
@@ -395,7 +395,7 @@ static int snd_gf1_pcm_playback_silence(struct snd_pcm_substream *substream,
 	
 	bpos = get_bpos(pcmp, voice, pos, len);
 	if (bpos < 0)
-		return pos;
+		return bpos;
 	snd_pcm_format_set_silence(runtime->format, runtime->dma_area + bpos,
 				   bytes_to_samples(runtime, count));
 	return playback_copy_ack(substream, bpos, len);
-- 
2.43.0



