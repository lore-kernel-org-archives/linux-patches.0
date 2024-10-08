Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5FC118CC12;
	Tue,  8 Oct 2024 12:14:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728389694; cv=none; b=l9iYzCVOyn8zdX0dxmoqEllYy47kTAmTcCSykfnhKvkVJABML5IuY+Cd1LXUGSRgbfTpDf5WgJ7fcWiWOsk0e6u5SLQTLiB6rd5xH7vzh+5WxlBRcRhkqg/ttewwIQhh5aagC5Rqj6sUEb1T0wVLbireQYCTxOU6LIeQLx0aEKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728389694; c=relaxed/simple;
	bh=f8VdD7bO89cKTypZMqfpWNHsZgwfqHztZVJwPMaHUUg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fyj7j+pfG7VZOKx6XoV8vr47OV1mtUP2sZ6G6i4KVLVueiwzWY9WFvnOgx2ijzvBEmwntAzs/GXMTO4TpflSFYYM7C+N5oeqKoeLgibwvvLVrjqvRgrKS8ajVD+Q12TkYOtkDB1nCEN83jzaBJ4WMHOwreaORCYm1x5ewpgfBn8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0Hfs1sxD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0Hfs1sxD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB8D0C4CEC7;
	Tue,  8 Oct 2024 12:14:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728389694;
	bh=f8VdD7bO89cKTypZMqfpWNHsZgwfqHztZVJwPMaHUUg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Hfs1sxDJfq74gxtwKiOqH2W/oT6CwWfNESSoBaFJbQCH+/2tQUY7g5+SX5NtyUHC
	 yJeuuHdIZRpK0V0wIRG1XrljqUHiinvuUC7tweYy9gSeBUCW1bYp8zkxzwaQ46AZMc
	 c9eWgg2+A6yZ2SIiSDMPerYT531Q8TDuvQsBknnY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christophe JAILLET <christophe.jaillet@wanadoo.fr>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 069/482] ALSA: gus: Fix some error handling paths related to get_bpos() usage
Date: Tue,  8 Oct 2024 14:02:12 +0200
Message-ID: <20241008115651.022948937@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115648.280954295@linuxfoundation.org>
References: <20241008115648.280954295@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

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



