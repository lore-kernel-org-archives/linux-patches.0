Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795055976;
	b=fwYFlMMd9RYIpQzo5KPGTaGzGBPWRa1bYXPy5Sh8nBENJ9zn2mA7y73ZSONiJRjsymDF
	 9S7z5Rz0GLaQ54DCGBmIvzo78GUsMhy+qZ8kMvm5xaFff0au8HSbEVvfx9PF0Nd7hsGC7
	 CO2vpHLcDFfsC2P7GyVErs52iowq4leiiYPnG7amsazWfG1Xet7mcKfM7h3PqYi7t68jw
	 tvw3GatZ5rF77QJiUVmbgaMGdIePMKB34FhjYN2lJQgufCDNue81jPyfsRoKwjeaW9wup
	 ZzX44CoIm5Fzjat8YkAze6GzA/jZt1F8H5L/3MlGdZOC3kC+clanjGI0VxjG7ntsGWg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795055976;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PSpl55FUY+ewRt7eghqEpDJRNkkSJSKKTbSDduaMhV8=;
	b=bLw7IQt8Q9cvtgdHaV8RSCsB8ZI8OzhmN7IWrHNykc//tzVnD1Z2hQ5WYfv+7dBRj17s
	 xFJ0ky2Z0oLKpPyQrUGmsR03Slaw10qKrmlklHYckfRTqekDOAVz9vVmLmRZvwWlbGZ+a
	 d1IXqPrYpfysTIeQ2rbZf2N5tRgv/HZqQTF+sgkKsaRsisqXBw5nAYMABz7QiYt6p1YKh
	 0Bk0aujAL1vt8AHLVOojm1CX20jE8aw+Jn9TZVOSL3d4sV2s7+yg/GcSghPLRwAHWuUXM
	 l55EwzkBLEDm0OZn2xS9G1R8rC0WWdfN2r8UdWxLMfO1Z+OtYmJuYlTRuO0T13zClww==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQAhBQ1u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 759B2606A31C;
	Thu, 19 Nov 2026 02:39:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wQAhBQ1u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2C151F000C4;
	Thu, 19 Nov 2026 02:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795055976;
	bh=PSpl55FUY+ewRt7eghqEpDJRNkkSJSKKTbSDduaMhV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wQAhBQ1uUdNBt3UAqrS3VEw77AMniUozy2VwYRtFi2/NI77UbD3r/Us9xGW0S2XmM
	 5lY0YnjI8FbQzHmriWi9TmK5BsOCRihroHKsoHkLhnShwPFEXg/70lETUO+rmIdjfm
	 p/wL276X73neZuJBPyY9NK1H5O92TVc52MEV4FB8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1824/2214] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:58:20 +0100
Message-ID: <20261118150124.419925409@linuxfoundation.org>
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
index 2f7490c8693fa..5d63a329b3b10 100644
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



