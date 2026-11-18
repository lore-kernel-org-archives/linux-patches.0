Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061576;
	b=Fpe9R6Tf0AtNar0n6MDLhq+1ORz5GsSbfe/iEDpkJB1P4/RMGolw7ECMXKvGeEDHKWYL
	 pCBUzb+a+v4HQeznUEmjTgr65x9Dx4jgmva/sJ6iE2Dv7T6eyUCbCfHo9AVYF+5QMWqbD
	 t/Sfd4x2XEoSHjIT9++Eiiz9bV5KjpJtY0lSeAH7nPdt0v+RX5uisTmMYGEErNk6Y6Qsw
	 8vTfpKi7ISsi1lHsZ/ykTqfih5pgd4sMzxaldgBjyhoVY/hq94CGveIDBPSGFUyoeuyOf
	 Z6FgJ8vbxpeL6y10+COAUrUYeO8XkhZH+LYiQEgYLzmFU2WQQm/gelPOCY92diudc1w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061576;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=QeX6X1hhI3H7BFhusOQtTtUdB/y7wKBogjI/GttPOPA=;
	b=tvrwks9RfT+yYw6JQFq+/S4wi7wsUPznse4DBNgjaDW3kVfZ74HbH10USwpRypOWLe3v
	 N3T3np5WI/53zv5OeGJyg9o9EcYjXlRJZr8OWZ1p2PmlJzfuceb0F6m/VPKIXw/cBHkCb
	 ABxMSUvxph1w19ZWFH2S7dTLW3SwLEVE5HSy08uOtHAOcCz3vRuRPwUSFEMBXd/3gw5ER
	 OS2p6n768xPr8qqcmDqq0sIWLtNqWzZw8iV9X3M6Rn5qGG/E4mow649IDOAHjxNdsnlwb
	 6V3CcUuvzhumshpS1j6TCnhB2SV/GkElQtBrP3ubF978npFlMvm+LsJn54AEtM3OMyg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojvNOKDN;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 549A2606A332;
	Thu, 19 Nov 2026 04:12:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ojvNOKDN
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAC491F000C7;
	Thu, 19 Nov 2026 04:12:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061576;
	bh=QeX6X1hhI3H7BFhusOQtTtUdB/y7wKBogjI/GttPOPA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ojvNOKDN4SMY0LWf5yjT8KbvhyIkGZjGzY1/G2I1Lyie/88LxC8BLYrFwDa64Ajb1
	 y+4Y09rK9JAzMBnxc45Dg5Y67tUBVY4DvO3MTqOifqBA9+jv89M9VX1chcaSNzqW86
	 OylkwvP5yURmZgJkCNN3kpQlKavH8HOX1IFMLQAA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1550/1848] ALSA: line6: Fix potential OOB write in line6_capture_copy()
Date: Wed, 18 Nov 2026 15:59:48 +0100
Message-ID: <20261118150024.513017968@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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



