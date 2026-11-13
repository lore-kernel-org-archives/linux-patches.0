Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590472;
	b=x9GIYVJyBGuoYw61PJ40pLAMhwPcp9RBs7Evthe+549SxzRUlhyH8Es8+TAloLWrHkjB
	 fjHK8b784aDkcEggkR+9NUmeCUGHG6LuT2r5rKati77ZH84vrgLBLp0e8/PwCI/IAz+VV
	 KTz5xk3gtjrY2Wsf4fyg8Qmc1VnlThT5+AZEquSSPIS6IbkDsXhuJji84Q9gzp7ftPizH
	 8WuAXRon5S9ADKOOyV+3y60B1pPIByYOCgkKxjiFqxkP7iuJoFztRWj1uC8q3zWeRPU2a
	 opzQ0KP0qNSpESUBqOiIabTVtGmy+4ws1Yx5WOwn4ZF+7lkL8//pfuHjgXeflY44Kug==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590472;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=d1mFhdyEaGlP3qcUiWDE5LAj+gvKIPPsRXQ60inVH88=;
	b=zHXEHm/RmRTGYDEt5h1janq2jyvZiF9uyQu0lO8eAnFYM+dJUg27Xz3rNGl4QwnsqD2V
	 HQlUul0CP/QGBTJ0wxTOTSp2VIqP2bo8I76p6DWvO4W3YjrgksbOilDTf/19Uu+Sh1niH
	 YqyEsr/gpTgQ7iqS470kBetQ+dLO9VE9hPQulhgFF9pI+TlmoP4AfGv00nF/YWUMED9TQ
	 sLyP1k1kX5xFpFx8na7iSliDFaqv5GIKizqZnziFjbatO6guBCUTaLCNFhgn+Wrc6G9dV
	 dStTh+2TGWvc1qprVib5oLZUQqi4XhOrBWEa86stDkjv4CXrMuSdMOGBUhPZRPSM4vQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pHvnr2k;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE050606A89E;
	Fri, 13 Nov 2026 17:21:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2pHvnr2k
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89DC81F000C4;
	Fri, 13 Nov 2026 17:21:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590472;
	bh=d1mFhdyEaGlP3qcUiWDE5LAj+gvKIPPsRXQ60inVH88=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2pHvnr2kAFpq02DZ7FQikCGISH7eYJ4P3ouvm+Q9jDZLfxjQ+8U+XFd+pQ0lfAN/z
	 QZTGImmZeftBcPA+hR3qCtiutbeGFktsQHBOchLDBbC0OD0BckuQtSYs5PGsoiKurM
	 F6q13ObFiwhUdRPZmK9Wf3MyeGzIotvtgOF73xUo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 427/686] ALSA: ump: Fix dropped data bytes at UMP System message conversion
Date: Fri, 13 Nov 2026 10:49:20 -0500
Message-ID: <20261113153835.404270364@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

From: HyeongJun An <sammiee5311@gmail.com>

[ Upstream commit ac1cac4c1f1b143650f7261ae78f64a3e22fa4d6 ]

The cvt_ump_system_to_legacy() function switches on
ump_message_status_code(), which returns only the upper 4 bits of the
status. The case labels are the full 0xf1, 0xf2 and 0xf3 values, so they
never match. MIDI Time Code, Song Position and Song Select are converted
to the status byte alone, and their data bytes are lost.

Switch on the full status byte in buf[0] instead.

Both callers of snd_ump_convert_from_ump() pass the result on as is: the
legacy rawmidi input of a UMP endpoint, and the MIDI 1.0 path of the
f_midi2 USB gadget.

Fixes: 0b5288f5fe63 ("ALSA: ump: Add legacy raw MIDI support")
Cc: stable@vger.kernel.org
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20261029130538.1985867-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/core/ump_convert.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/sound/core/ump_convert.c b/sound/core/ump_convert.c
index 0a7972d91ec52..ecbd894f4c83a 100644
--- a/sound/core/ump_convert.c
+++ b/sound/core/ump_convert.c
@@ -69,7 +69,7 @@ static u32 upscale_14_to_32bit(u16 src)
 static int cvt_ump_system_to_legacy(u32 data, unsigned char *buf)
 {
 	buf[0] = ump_message_status_channel(data);
-	switch (ump_message_status_code(data)) {
+	switch (buf[0]) {
 	case UMP_SYSTEM_STATUS_MIDI_TIME_CODE:
 	case UMP_SYSTEM_STATUS_SONG_SELECT:
 		buf[1] = (data >> 8) & 0x7f;
-- 
2.53.0



