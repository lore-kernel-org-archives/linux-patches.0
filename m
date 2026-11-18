Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049846;
	b=c3qrvsSkz6K0KYZlAxZRerM+mxuZBNQLE5xpCwfZBWNMlPdAMyDo4K/FHiwLpmllt2Dw
	 40cyPstcrfMxCiPxhN8wq8R9gjMAT+4b10vEMSYJQ+yGCjySZtktq7MTnmjvCFg/E0m5C
	 G4CsahHtyr3fW8Yy4YcCkbgDstn+aEZ8+taEEXWKXcH4gFRAMZCoGWzdtOkkIXi7sa69F
	 aDNIlZIwKmhb+XfGZlbJdTXtt2WoFwuKRmX7gm9ZGyY6aWNp36G7pwsW/8CqDnZUPtRZs
	 W1XeVR/A5ibr0yQVpiuqLUx5sdbRAbgZ0b7FZod9vmxovRHB4yRJqGSI94SiLVgy4mw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049846;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=RW1WAeFir9K5N4yL1ggAz7IBkabRJ50EGgnLY4txeWY=;
	b=D0xn7d3fV76SgW7vx/4Ztri0XHRDLtqUiMMWYx6xgSjUnVCaJ9at0jDjjJHmBaoNvWkg
	 XiDunmi91b+V3eL4N1e3RPZslI1PaexbAbUmoP8xIKzgAlbYPLCmk5GaCBskblbEljt+S
	 7B4p+8u7ulRyrNGpxtdJ13/brVyvguywZQ846xHLnF95x+XaPJkGtIjG/7XousrjwQHRc
	 pjJkfvgTA3nIpNKlToVVvujeEu0SHuoxgxYv7z3WPAhIHw1mJ6C0GfZuC9xm7t8dU+4mO
	 +y0RkcjQ5dRqTfm1Y8K76Zitu+F5GtOJ90G3R/N1fk4ptAxvI342ZTm94sEJaKVDW+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFtO98iv;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07188606A320;
	Thu, 19 Nov 2026 00:57:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=iFtO98iv
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 602881F000C4;
	Thu, 19 Nov 2026 00:57:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049845;
	bh=RW1WAeFir9K5N4yL1ggAz7IBkabRJ50EGgnLY4txeWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=iFtO98iv50wkfYC47X2HDcOF08i1htXk4YOYbXetOtS2DBUa42e/08LqhRW+b4D20
	 n4+yR5aEN+S0qzSnvB325bxBEZpNdCp1YC+U41o9DKvVZ86KAbphsGhStipqH+NdPd
	 wozA2sBH/KYS6OVMUHPFH0/57+aYAs6LoePhcVuQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2456/2857] ALSA: line6: Use kzalloc() for PCM buffer allocation
Date: Wed, 18 Nov 2026 15:58:10 +0100
Message-ID: <20261118150329.996508466@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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



