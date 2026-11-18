Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795026024;
	b=M9L5L4uY3SP4lTjpoG3wwJjZrIU2UDF2xbfDBxMR8M2U0Jjx8pyV2w5TDWWEED0oAEct
	 lLvXE27+Vu4pV9xRYZKwDArhitYxJ1Mlm5GM8Em0IJ7f7Yhr9JGe7hoBXxgH8m3q/qZyG
	 fN7GiS9P9k9Ojm5GViil4Xoy58vmMQw7MwA+hERp5vhhSzc9LA5X1fA9t+XOiMMgbNnRd
	 Vn/UJfmrrqFec1e6Wh4PHH4oAOolHiIqJVA2GnEse2kMCdDUyK9GDlVf4+JQRncgkGOIN
	 RT9rNGiqMqK8jcNu15UWQO9b29Q6RyFQ1VqXCnNlTQEtqGkxMtSTGyzPB4t87htQhpg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795026024;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=5QXiXvGBuwvMIk4anXcYYTwEPiIn/gKnSsoFv1T/jW0=;
	b=O7jSoRvvqnEXN4JLRyDC/nafgQg0Ng39ywrgXWhzE5A3qEvJBH20oiHHxHQ2g/D6cR6n
	 ZBdWj4Qnpk4eYfODatE+aqFW5CsFCTOMHal5R2ah9eMSyFHl735I/Z+MTHPL281SVT9pC
	 kNRrN5+UaZQCv4wIKSJZ7Weda/cmNslrUh+S/otSldaQZSt0r+FG3gW2cVOQ8bqkIDy+L
	 tPiP0eeqJeqm66z9rzNchDRKVaFhVUDpvZsSGpBQX7FaIngUR08lGEWvqOT9jnUpQ/mQu
	 /H7M/Nd0wfhbivNk12fDzrXV0iBWcvngUT9jM6SCCGm3LD6R5o7l++22viEy9fB6WJg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xd9cHwLs;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 485C2606A31C;
	Wed, 18 Nov 2026 18:20:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xd9cHwLs
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 986D61F000C4;
	Wed, 18 Nov 2026 18:20:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795026024;
	bh=5QXiXvGBuwvMIk4anXcYYTwEPiIn/gKnSsoFv1T/jW0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xd9cHwLsMUGHQ/IhOwLZ0/OaH7FyPY01DyTLMcorJAjkC3r7mtqrWSn8/J6UsIJ/g
	 jXwVZVPhO6npW82hmCusbfxm2MkBpIRvsYE1RKMs5CaCcjtMXxuVQHujG6rbU+X6R3
	 WC8KDJEPK7/cozEhqJH5/zLq4vtt1uz4EVp/2ZKs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1285/2151] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:50:20 +0100
Message-ID: <20261118150208.949995322@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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



