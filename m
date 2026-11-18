Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795041145;
	b=SCJC2FXNkU5Jt4EiwM+sDlL3F45Hsv00t7MXCdgVOKpczbaksv4s/5E2XnM4zIs2XHBR
	 Ah8AIgvxzhpEtO8n2PsmZh3nxqWDg/kU1lkmTGlvE5/opknCpgfQ4FWLDysLODY/I/EjT
	 bqHMyCEBZhfggciSE886hZCsk1ZpcCUcYvqX9BMyCaU6L8420AotqwkXFqKWgLHmfvpE9
	 3AJpPQq2pxnJnn+ivZS1klo7YAHq666nbGKbChFZNg/rWZ/iUei8Sc2lopeiMdX8e/2fg
	 RJa6ppPTB7BFZu8nU268r6kQ+3r5AIKsgoBlwfTVut5w/RG0qDkkT0ofyCH0u/U3Teg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795041145;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=lAgjankL0Y2iKOiXYA9HneQ9+Eb3k5v4/SdDfM/jkKQ=;
	b=oQq9yQ9RzhUEvqiioLSXhp0hBxKE5rG55gfboT192f+tSlFsRHHM675uP8TvOyuMcRCl
	 OCiYw+UxycMATaA4IydV29UicF8BhMxcYc5iK62L4datTBFnkGOxgl3ae7vo0x4zUe88L
	 T6+qgEZTAja/A2Ef4iiIazPnQswhhbUq7ybRB84cZgLmeIt1JBKplqa8+URMsgXmjh0gh
	 CtZgpnmEhDATEfUIJxngj2SoTwOR4PeOnicQklufiZ9qW64yz+5YMF3g+KPzVUZSUiZmc
	 0bK/l6ap5fC6myBy7po6NAX5maVZZmcT9dDPpEpwkwaQqHwO7jmP2L8q5me4mDvptIg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="wnUl/QDi";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA31606A325;
	Wed, 18 Nov 2026 22:32:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=wnUl/QDi
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17C81F000C4;
	Wed, 18 Nov 2026 22:32:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795041145;
	bh=lAgjankL0Y2iKOiXYA9HneQ9+Eb3k5v4/SdDfM/jkKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wnUl/QDiyO1EmKMZD15XNe046+ABZbW2BFe1G1VrzJlVb6UP6lTFvU2DCtB0OsRJ4
	 56HOhTQnr3A0PFxoJS+S5gi93kYuHAefZmAS4qKE9nNtfchw18Csy+gITWLsnr1N1m
	 aG1U6wKPX8OCvQZIQ9aWgNAfKvma7gdv4bbNzxuE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 2708/3318] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:55:30 +0100
Message-ID: <20261118150442.132105523@linuxfoundation.org>
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
index 17c00d8912d9e..3683e509ab7c2 100644
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



