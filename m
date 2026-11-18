Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019310;
	b=HoRo66VzPdOXYH15lm7HBqrraY+2oVJpRXPe5aW6ZMaGvuXHDcPDHFgzuaQMIx+IZsRf
	 nG1XxfKpSiOvvos5UY38KhmWvRZVN3rsj6W+Qy4jAQJQ7jKNqbZ1/Bn6ip3jV/UuVHMne
	 gmRAXQMwLPPg85BocIza7zlEoUIAxVH2/sD5qHndOm7T4wpn3syPu8oqo0mGSXRnumM5Y
	 q59xISg/oygVgbcXWxiVh1gFMgjDCWlBs5T/sivqBsBsl1hPtVGOImvLY3c1JVyjnJaDO
	 q7DQgKvX3JSryKiswdt5ovWuwTEz5DHTqAyCbfdc5qolbu+ne3IYGUuuLnCFa5uydyw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019310;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=V1vYCkuvxcHrufrTdu3zmekUms0nlZEEjZzbN7mbAR4=;
	b=h3EAEu81J1lNmYTFirKzpNjboLFMMt0MaEyPfEjcsb05fxsuNIH2ekwsPhB90SYTlBTv
	 8nEcaWXEwAL3iXyKT+KAYD3zkBDSytWHdNU9puXCKr+bG87Kl01+eBmhwHUVvtGfJpMBE
	 yOfHffg8sNETiwWRdKGicJgL6a/7/qLtNY9M1m7jEQggv5XEIUyXnegJr6uNsQPV+nnZK
	 aPefRlD72BHs+mprOcqcLJvcAMbaeNSIfRgq2Koy+kzAN6vXyu5QjllVLA8t2pjBcXX4L
	 d+KpLPsHwI6m8k5JCsLqe9QCTmPo91jYldYjeUWY0AqitJRWbLdexdpEk1RTosmNieg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mygsdHfH;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2EAE660A2607;
	Wed, 18 Nov 2026 16:28:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=mygsdHfH
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 853971F000C4;
	Wed, 18 Nov 2026 16:28:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019310;
	bh=V1vYCkuvxcHrufrTdu3zmekUms0nlZEEjZzbN7mbAR4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mygsdHfHoZLXNRuGfzKFDOH9p1CLQpbKZPt5trAXNP0WV2ovOzNVD/SPXxBcz6WUI
	 VgxJ/Hl9vjthXHCIT1qwiz8Wdr0E1lXqv0qAS1K0BACeGreYeuwH7K9sWgcHLnJURH
	 RfQeuRM7yTh3aSSYYeKobNQeGK/AUlKj/AGIJwQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1550/2651] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:46:30 +0100
Message-ID: <20261118150343.761627276@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
index 32922b7f2ffc7..626274e503c7a 100644
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



