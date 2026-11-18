Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038457;
	b=FPR/et0N6TC9tVnbr2HAFr74gcM3XiRDQV8YbVIA7M7K5YIIGxSYjynDgwAM0w671m0s
	 Nrl6+dm6UYP7ELl/zhAp3M9nPp6rURaaXGSsQcUgy+7rOUkL0vtjLs16TMRpxSu+xVtHC
	 JYX+z0pc7jtsfTQlo15c6KqVeMJjsbIg8u/JxrVxNlz0kU++ZMmuWqEpbkt/9orykR2Y9
	 A/EvlCFbPs0BgA7NykqymtnDY5wqv7u3XReP9MFCAhM3TpEZStVY1ic/onA49oW5nQ2gU
	 ap2nOiRg8S5TeLGUGAnHatL0TM1LYBijvCORblIpOcL/ECvJ2rk5anlUPHr9lA4l5lQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038457;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+IPL28HwQp86M55mN7/Lu+SMB/XNrVHbnvO4Ug6lXJE=;
	b=IRWjMpHhgGXuuHPh2Efx6pXqVz47Xa8QiQ0X2IO/TLfEMCRWt18NeGg8ixIS7z9oEFJj
	 UhlixILivZG5FBUKRBFG40aYzP/mb0UGAyoTjceEBW47H6F/xKDLtOtHs1Zzmpfhp/3ek
	 UiGpDc0VG8cSOQ9DgKA+llmW4WtDf69R1HgXvBz8cKjc7kULoB+5rjDzUCWk5vaXitMA1
	 VZSjS+xa2Cq6l3jg+oyVJVLtoFMODb9gp2UUsmtMwpYfjWvc50CFq2c37LEmeDWy2rjQk
	 jbj0d3YfjlAQt5U4dvPpMXsJjCnOBfX2i3r+EChr766lcktRzs8c0nRfOIRvMusSJMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P62ZfoQa;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A1EF606A320;
	Wed, 18 Nov 2026 21:47:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=P62ZfoQa
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 556AA1F000C4;
	Wed, 18 Nov 2026 21:47:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038456;
	bh=+IPL28HwQp86M55mN7/Lu+SMB/XNrVHbnvO4Ug6lXJE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P62ZfoQa3FPnWClutR6s2m0QO8kI0e346jwZmIg8xQ6uBp55QVomBvtqp0EYF/led
	 vFzku8/uP3jECj308jRHmGKr+T/32Wf5DMlSI3GQltLKQT3bqG3XssJ1myhNbYfqSF
	 LDs1LSg6SIs2IQ1fn67vxCZZjlcPXY++8rPeF2oU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oswald Buddenhagen <oswald.buddenhagen@gmx.de>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1751/3318] ALSA: emux: fix validation of snd_emux.num_ports
Date: Wed, 18 Nov 2026 15:39:33 +0100
Message-ID: <20261118150414.389763521@linuxfoundation.org>
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

From: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>

[ Upstream commit 19061f35b3eaf4925960be44d870244b99df8d1d ]

Both bounds had off-by-one errors.

Signed-off-by: Oswald Buddenhagen <oswald.buddenhagen@gmx.de>
Message-ID: <20240406064830.1029573-4-oswald.buddenhagen@gmx.de>
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Stable-dep-of: 34e3e04b8a17 ("ALSA: emux: Fix UAF of soundfont zones at note-on")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/synth/emux/emux_seq.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/sound/synth/emux/emux_seq.c b/sound/synth/emux/emux_seq.c
index b227c7e0bc2ac..1adaa75df2f6a 100644
--- a/sound/synth/emux/emux_seq.c
+++ b/sound/synth/emux/emux_seq.c
@@ -65,11 +65,11 @@ snd_emux_init_seq(struct snd_emux *emu, struct snd_card *card, int index)
 		return -ENODEV;
 	}
 
-	if (emu->num_ports < 0) {
+	if (emu->num_ports <= 0) {
 		snd_printk(KERN_WARNING "seqports must be greater than zero\n");
 		emu->num_ports = 1;
-	} else if (emu->num_ports >= SNDRV_EMUX_MAX_PORTS) {
-		snd_printk(KERN_WARNING "too many ports."
+	} else if (emu->num_ports > SNDRV_EMUX_MAX_PORTS) {
+		snd_printk(KERN_WARNING "too many ports. "
 			   "limited max. ports %d\n", SNDRV_EMUX_MAX_PORTS);
 		emu->num_ports = SNDRV_EMUX_MAX_PORTS;
 	}
-- 
2.53.0



