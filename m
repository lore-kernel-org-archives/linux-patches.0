Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795056327;
	b=kjOjzUu32yE6oxnzqUhl+Fl0DMZhvAURQCjIeh3ct/oCc1Z3qXHE/ezRWx0ihBJTc+Fk
	 IA30SBcUGHGO/CJBATsOqpr3eRE3KeDStYM0uGVHlx0AmRqBmmtxPCIX0oyu77hSdJVvS
	 lZ2mEmpes3TnW5PhCnM+xprD8G+1P6AEBYPdJQbsFuJ7xdHInC0ogl88dSTAsziQXBts0
	 tByUL0L6np54FXdCwiayoJamNwYzpMmUKVkI0cLi40QatSOilBp3GFDWbGVQQmzIlYpqq
	 HTmlMe/2ZR0yOWexX+dDcMj1Sf5q6hlt3hsogtkidElsQLAnV8YKMBRrMClN+LifmUw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795056327;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RXPYcY2TFI9r+XmZByda5lnfLuUR+N1tUC0PPAU6OTk=;
	b=KfcPWBDdHzkjOb/mcTu+y79A87MnkW0QVge6cQ9U/stConzi9K3mMowLMGg+OY0kBDaj
	 oloq4KOZTxO9cT60+n3Jb37mNYfruJBap7meoaxZZeEm5ICSAbIIS06WDWaHoFy8FwJuT
	 Z4k/UyOUwszAaVJWvWMuGi5TKGJEPG7D2xBJGu2mcPd2uumWQ37gAgNbB+35jtWW5rIRR
	 dnlF6dZPFVwXzTv0YU9bdnIh3Sj5SxwNf+y6LUj7+CtgCvmwubL+RMylOk9nu74u+ERxP
	 cNUAmbFXkHtxkhVeYD2/9iKdbk27wH4io8zPqZZ/rxJebgNmpnH9xmOaeK573Q3Ntzw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f28hQTja;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD0EE606A31C;
	Thu, 19 Nov 2026 02:45:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=f28hQTja
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C06321F000C4;
	Thu, 19 Nov 2026 02:45:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795056327;
	bh=RXPYcY2TFI9r+XmZByda5lnfLuUR+N1tUC0PPAU6OTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=f28hQTjaIy3lCmNhIeJHpdh2rUIN6vo3hcpsONkJ3Q2I4+4ejiAeWOYV44RsZc+Ti
	 IxJODerHLU6GMon/lglTfx6rz1LCXN9twp5XOwv4qnAnQzurJu/AKFinzvmtaAWJf6
	 IPUSc8o82w8xBpRlt8CIC4DwyX2KjQHSExdAcAEY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1905/2214] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:59:41 +0100
Message-ID: <20261118150127.333139177@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 59b7c6beef6c5..5c940eb54e02a 100644
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



