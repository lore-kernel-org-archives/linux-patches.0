Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041515;
	b=XeRCr5v5enjIMDDdTR0QYBc8h0U9Z1r/AroVyudDyhF+RjWkoHD2Q/mwlCkVya2JBv1U
	 P0Y920x8LXw70RqEDnTEJfZprzo4CFNzEebyEHUljR1sFOV5dqGhK0GMi++3NrJO+vOYU
	 xGT2CGAa0q43VCNPjYK/9fSPEj6JpYWPpQw4fNpiLc55MdQA+EUjcpZ3ZPyyzsGDOTFf6
	 0eLNe7vtZnr94BrD9sNv98DOtCoPVfaeOJtOLTyKq9Rlgan0aBQeu5hwbrvz8nt+okQBG
	 enUhdyhsqC+3ERNbzeYXgPp/H+WiDHcP5z6fEQ8vWV7u8X8mNpcKFSLe0BOFQeBddXg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041515;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=BnJ+0Y4eKv8D62CvxCoBelLnG1IMR3UaVSLENcBkFg0=;
	b=og3aBguY9bzmDfGfy6Z5ounS5UfE8NoykO3AzqxC7jKjQVm2PsJj84VOp6wLws8plvo2
	 STN1DHhsLVLLpZII6IPrb9yVo44onRp8bm7JCiYERjBrb6ULdsWUnWT++SqVS6SCZGKSz
	 C/DQYrJlpP7RbY0Aq+uQOqFNqF9dYp00R13t3lgutX1CEviK/+jT6G2keXuwOhLZavBpS
	 UzL9EKy4hADh6SEiQg6yAzsE/jT/EMyG4rRZwMNJ8QLYCAsekkheRwMWvUpfO/Q7RWNZw
	 ldssxkHPchsgkIKln9S7FISQzzIIONw5aBN6aDc5k+xPYZs2AfWhMkK7gAtccZD7jFw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZLZWDfh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A471A606A9B1;
	Wed, 18 Nov 2026 22:38:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=UZLZWDfh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0970A1F000C4;
	Wed, 18 Nov 2026 22:38:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041515;
	bh=BnJ+0Y4eKv8D62CvxCoBelLnG1IMR3UaVSLENcBkFg0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UZLZWDfhT3lp+Bj/xiwx9proM6JU7jjAoJrqsvf0bdLimlKTMQ30H+y3+UPGacEV8
	 NX/kr9N+m4GdDmK4fqgvvEEiEZ2oLC9PM0cNCzJZ6BLD6Fk+yVnenumdg77BLq7YxL
	 IhfKFta3FIdHm53aO4ra361b2sXzQKNwLiqSMqXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2840/3318] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:57:42 +0100
Message-ID: <20261118150445.819145009@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 4a84a3584ae09..7f92f27edfeb7 100644
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



