Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795037851;
	b=Er0Vm+sQotMTcfdBEdZSU8pbobhcgXXt+sy2ApEgzdCkTDs+NBknuNcDDOkh6zRl13PZ
	 u/PBesavUytWnTqLp9skBC2kJsTf8yiyHEXLFp7RrPwj5YcDasY59zEiew9Z7yCqf10hn
	 RQ/xryG7ZmRl2Pwxyh3pRO+uYr1wU2qNmbCD48U8lPbVuefkmOR6ZTBhmTxriyVz17vqx
	 B8JylExYWdmV/o8LdGDacjAJnkCHbtUcsF8S42u653twtqqv9lYiy2X7z3ETUB+SkVA3l
	 H280XLHhcFl2BeVT7BMri2a6hYPOPfzTPJWyxTQJ0PoYmRcCF2cQZdHQE8EqvEHfjxA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795037851;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=iAfhDp9zZspCCQUPpek7DcsdseRpZoxh1r76zAPyKuQ=;
	b=toKEzawX4EQRBRjqajqaKUFZ92UyTO5D+ojHzLLiW2XoHMQQzRGu1KaaItb1HxI0U38s
	 gLRO8AOwLCrl5DZNXMXiTstlaO7e1XbXruBbmj/2i8zFk3tQkPmreXZ9MEjQN/5qPDhQ/
	 BUaFmETAEFkrL+jWiTl9HBWUa4iIuIkvZM+JmiEwpcl/q7YIiHCOc0P5/urF2LqvMbF9g
	 Mwuk8+tlHx8HLUt+dYu1ku0hoc/WBPQl2JPMLZmXMCZX2/+yNqapEhQSP2vxWM+ylaJhZ
	 OuqDg4HAH8BLcnDRqVFZDzh73seQP27A7eyZ3ueIWiMl7aDf5UXtcVn9ADx9DHwO81w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2IIR3CY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D037606A325;
	Wed, 18 Nov 2026 21:37:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=c2IIR3CY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC0651F000C4;
	Wed, 18 Nov 2026 21:37:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795037851;
	bh=iAfhDp9zZspCCQUPpek7DcsdseRpZoxh1r76zAPyKuQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=c2IIR3CYB3JkMMqhsvhWWJ4E2wa2erYvstJarjJ8z1szGGzz+SNd9D/QNZUZx5HQF
	 EyCz/6mdcdzfog6XPKcledz/Uel08MwVZhHQCfzf+Pgd7wbAg497/3YOPX1VXxlmgb
	 TrBaam3ci6tlK/AdfIW2RBYDcQjTm92bcFF3cnCM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1540/3318] ALSA: ump: Fix dropped data bytes at UMP System message conversion
Date: Wed, 18 Nov 2026 15:36:02 +0100
Message-ID: <20261118150407.178463458@linuxfoundation.org>
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



