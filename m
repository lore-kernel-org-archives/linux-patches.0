Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795049400;
	b=duuB3PO7QLJcxdLLSDTVOtZ5g655sqK4Xs11IFVRlTqfuLzd45JiUEW6RryeehWJ6yau
	 fkaxFtvJYzjvZhH/cu3aVUdjQ2y6wW2dQsCGkKHwY+Y0LclJe6Qk2qQ3QEGN4UEe5oZ5G
	 Ow6Ihq0s5vwgEorSRlRoeCThrvdJbNVIgw508EPmnb0RH2tRT65QItj4RgKOPKHQItQyy
	 2mOlT3zOq0b4hmFPdyOyz/adV2bqZS8a0mZpurBDpZe/sPgACqtr1Du9kaW9F/823VfOf
	 zGwh586wWW2nneu6qUFP8P6NlwTzDsjk4FWl9yNQKbjuXNzASbLAYAF/v6RcpXNQu8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795049400;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=mA+XK8dS4YHv+2ZNoOrvyxLP5RCwXygf1n0MzOfB7YA=;
	b=LjFUw2CcWVoEDfD7XipYD9WyySGw4lYPFoKm3BmL+Umyxb5T6dcY33lh1CYIVVlhTVb0
	 k20MU3Qeuoli8+eqAKbtCcf+Lxfwsw5l6nk356cGIU/oSJZNmD2u/Hx16wZwOcnaq2MCJ
	 HVkMHdaIZU8o5xSVYh2z4OaXYkreOrVN/6EWoGYpTqVZjkWESJLXSK63OhccRetDmOT6t
	 H4sLgubD7Ebw4uOVUnTl2a8XM+8QL7g4jAPf2A2JGRaQsK1xo/uCNjP68CzSBBFnz3r/9
	 kD3hYPRLQjD+96y7hWOBCMIYwLNc4b9onbgZ4gzEhSFY37XTVqUbggKoG/2F6CLcogw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6xD8BRz;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6647E606A31C;
	Thu, 19 Nov 2026 00:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=V6xD8BRz
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B68511F000C5;
	Thu, 19 Nov 2026 00:49:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795049400;
	bh=mA+XK8dS4YHv+2ZNoOrvyxLP5RCwXygf1n0MzOfB7YA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=V6xD8BRzEVkXroS9ARa+uI/Dq5/KhFvZVc1sT9aev1xnKhdCZKh42lOtQH9lGCSln
	 bLlUzDnvbK8whKJvcN1/lITXBJKmTk0m18ryY6xYXlYcLg1n9M3bLVu47UOK7CRMfM
	 pNIYAeWUZDJISdWKObAeHiwPM+ZPHGhGIqR1wcIU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2338/2857] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:56:12 +0100
Message-ID: <20261118150325.714667285@linuxfoundation.org>
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



