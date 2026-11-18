Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795031781;
	b=Cc57PTFsfmUziD2WNWth620qe8GxzGRRiZLHIGNLzrsUXcLxDpQJCXJXbAi3Afjpei67
	 DZd82u7iHuP5+WtGWWG3FeuO9fzcaWixeH6qZtHKpwhED7ymdIizZcPJGIHIZ53VJy5s9
	 vRBt8scHYgQ02Qz0FNdBsn8ZmBbzqgoeZJPm+sYoE+ADCAEU44uqm7SPwhlRDri0Yu6Nm
	 B/i+gsVW4ZIczjQRbNQ4XFSmnqTEigfVTJFqqX+6kooFthPjiZmimrPADVI+Vf3yzSvoc
	 mlmWVaR/YeyCpTyBVNO3CpL3L/gyxAJJv/mucb+23D179ec3t0Y9mOVThehs8fWxXtw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795031781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=UjS2+7Ei2yCnieAGR0j2r1OpiCQJa7hSFjYsrgQqaNI=;
	b=l54KXyAnqZWVyyH46OeDCjUI3YF3NnR/y97G3TUvkB0LcwDfEOZQlTMd7UZYRkm0O1JF
	 9hukPA0VJOSzke8m4b8bvCtPm3mficUZUNi02H6os8HNE+961jSapGUuCc6tSRmCFTMvw
	 vMbhD2k5P/0bDaIHweLHzl8WHKo439GIQ741M3f2QdPwklxGRrAhC4SAWc6EbdHOC4C4g
	 wt/KWlEEu1/VCwFT2s/DFUkmJPYkMkfIsd6/bsFW3hed7C8v0MSvuSC/ib4mamvt8fMQC
	 nr6IV4hHbX4QWvXR03EqC6ADnoAVGZgx80NHCMbpB4y51sH0L9SI9gNDnk6VvCpcIPw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xh+HqbWE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2342260A2605;
	Wed, 18 Nov 2026 19:56:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Xh+HqbWE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7048E1F000C4;
	Wed, 18 Nov 2026 19:56:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795031781;
	bh=UjS2+7Ei2yCnieAGR0j2r1OpiCQJa7hSFjYsrgQqaNI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Xh+HqbWEjRPRCWlL1CysgWi6OhYuOU7cscOAV6FOZSORRvStKE12ChbcZvuTR3rAI
	 SDoScJmlli0DindY7AgOlNIMz+G/+5OSuYYNZaoZiS9AyDQ96wnI+htdVrqRLrPvWK
	 2aLwfqvp+41tFqbWCYG6jQJ0eIF95S9uZ1JRHRwA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1178/1756] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:55:05 +0100
Message-ID: <20261118150056.831307774@linuxfoundation.org>
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

[ Upstream commit 9ec633573c1d162bfc82cae52d14c220c875612f ]

LINE6 driver allocates the PCM buffer via kmalloc(), and this might
leave some bytes uninitialized that are out of the actual ring buffer
size, while it's still exposed via mmap.

For avoiding the leak of the uninitialized kernel memory, simply
replace it with kzalloc().

Fixes: 705ececd1c60 ("Staging: add line6 usb driver")
Reported-by: Sashiko <sashiko-bot@kernel.org>
Link: https://patch.msgid.link/20261013120528.52586-5-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/line6/pcm.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/usb/line6/pcm.c b/sound/usb/line6/pcm.c
index 586e38e40b930..6aab99760a6e0 100644
--- a/sound/usb/line6/pcm.c
+++ b/sound/usb/line6/pcm.c
@@ -155,7 +155,7 @@ static int line6_buffer_acquire(struct snd_line6_pcm *line6pcm,
 	/* Invoked multiple times in a row so allocate once only */
 	if (!test_and_set_bit(type, &pstr->opened) && !pstr->buffer) {
 		pstr->buffer =
-			kmalloc(array3_size(line6pcm->line6->iso_buffers,
+			kzalloc(array3_size(line6pcm->line6->iso_buffers,
 					    LINE6_ISO_PACKETS, pkt_size),
 				GFP_KERNEL);
 		if (!pstr->buffer)
-- 
2.53.0



