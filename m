Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031450;
	b=KQXoSUZK6xTjHIWApobk2HpJWyZQlZFxT2eX5ZpNzzmLMpJlneE2WJGNq3D/IIcnvl04
	 LTD5gzLHGB/8koXsZ1TmvACl9VoWnJ5tNmq2O3ngXckVX3vzBMFN6BRMNHfgS6xnHxZlO
	 MGq25zexVtz7YgWyVqqyLE9c4cQvlWNYI1k/TrHAwmNoxsyAq06qi0OjGl2hPZX8TvzVj
	 +WSCXG0W73uIHZYN734OexE+fB8/mSDzt9Zutuo9UV+1Oxi9cNh5Ke49YzWddpJrl7/zI
	 yMtMqoKa41rzhyFO/JvtYUNz5GpuzwVAivDk21/HiBVwm2b/AAAC04NZ1fHiAZiV52Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031450;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Gq+E1WJxp3NEqFPMFT8VrnJeIMJgtgEhG2UzNyIFMpA=;
	b=WBQRXZyA7Kh1QTWcnYxe904pDD5AA87yVhtwhBgxP5wPa01JgAM+tKghzt8aur5H8SBj
	 me02+BUGHRY6zd4n6+23ChIHIYBucblgX434QkZPFc8gaqSbPb3IoHGqXPxgh8zfoiHGD
	 OEXMS2ipygR8Hl2RDYcOV6h2qqj3rg/uwJndf+fibWTBt6n8AauSNr4kDKZ0julGdRrcq
	 2c8OkFLB81oVX2hWI4XCbFiloWLqhgFFfWLB72Jpzzv3J2QYsY7BC42ADHvv/gmwP3pyC
	 mzrjo71YVo1rfneMLcdwZ7uW8u/DuYwjbLBXqYhIh5z0P7rwTDm3xR3xh5bd2eSINhA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoZu20Jf;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D489606A320;
	Wed, 18 Nov 2026 19:50:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=QoZu20Jf
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC1621F000C4;
	Wed, 18 Nov 2026 19:50:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031450;
	bh=Gq+E1WJxp3NEqFPMFT8VrnJeIMJgtgEhG2UzNyIFMpA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=QoZu20Jfha0iFZwJW//1vLXpWa7D+nhU6ZyMRAXFEUaJEqtyDQdQDsbODzliuKdIG
	 pj7C3y2Yt/ixy/l6Tj+Lwwj08ynpRiG0csmTJPRlL7mSFDdwKs0reXFAQwt7mQJbij
	 Rr3rLlnbsqMSoSzpw40+afsJaKnGWyzCJnZOF/nU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1020/1756] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:52:27 +0100
Message-ID: <20261118150050.719996949@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150007.957976754@linuxfoundation.org>
References: <20261118150007.957976754@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit d69798357b5d562bcda1af488cda3ead4d039f8f ]

line6_capture_copy() copies the data for the original byte size, but
the buffer overwrap is checked against the frame size.  Because of it,
when the data size isn't aligned in frames, the remaining bytes might
be still copied above the buffer size.

For avoiding the potential OOB write, correct the copied data size in
line6_capture_copy() to be aligned with frames.

Fixes: 1027f476f507 ("staging: line6: sync with upstream")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261008192553.300025-11-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/capture.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/line6/capture.c b/sound/usb/line6/capture.c
index f59ec9c4a1a52..ad0588973cbc4 100644
--- a/sound/usb/line6/capture.c
+++ b/sound/usb/line6/capture.c
@@ -129,7 +129,8 @@ void line6_capture_copy(struct snd_line6_pcm *line6pcm, char *fbuf, int fsize)
 	} else {
 		/* copy single chunk */
 		memcpy(runtime->dma_area +
-		       line6pcm->in.pos_done * bytes_per_frame, fbuf, fsize);
+		       line6pcm->in.pos_done * bytes_per_frame, fbuf,
+		       frames * bytes_per_frame);
 	}
 
 	line6pcm->in.pos_done += frames;
-- 
2.53.0



