Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FF551DED64;
	Tue,  8 Oct 2024 12:42:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728391322; cv=none; b=lxrRGnxXmjVg5hNteYHObyKdhgi39HE6g8CV7WaQR+mlRHuyqp/7+BPnp98scwAAgIlIIIDj36EhK0Y3VD9GLr2kblJXsd0t0QNwDj0RRS/h0ZLujcOgDiJlsii4e77JjEupyps/M+hX+eLXnN5WjHfEbQgOPqSPbwN9nhE0JF0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728391322; c=relaxed/simple;
	bh=Vu6fnFr0xVYr+N+aARf6tjPVq+koNQ+7jzsKhXuKFNA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FtochfEovtwMvLeas6KEwtKoH2e0cmaWhxgfTb57Wn5ovipExF9R+PnHG39vuA47XGOpotm/x04RnV+a9E92oynKcDj86dxjVvhtTa6eMJYPbtIzXJfC4Uq7lAZ5UlvMuSGc1muDPjgwQd/d65u+pcbobJxtE7yo1q2CHWj5WU8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pvBdUTxB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pvBdUTxB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98420C4CEC7;
	Tue,  8 Oct 2024 12:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728391322;
	bh=Vu6fnFr0xVYr+N+aARf6tjPVq+koNQ+7jzsKhXuKFNA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pvBdUTxBBXPg3T0MOqkltnTfnNVPzFWXK41XzXlvL6C6bTBXRBrivDNbePL7y7QU4
	 GriLhx9z+MqH++dhf6G3Tt2fOaC0FVVsktp8PBEnMYCFMZVWvRJHLuiote2Btv3g2S
	 kFB6kTfh6JDMYUIPJE2jj6ea89fDLDknySHFyokA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 078/558] ALSA: gus: Fix some error handling paths related to get_bpos() usage
Date: Tue,  8 Oct 2024 14:01:48 +0200
Message-ID: <20241008115705.445942829@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115702.214071228@linuxfoundation.org>
References: <20241008115702.214071228@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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



