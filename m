Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795019222;
	b=H0SNMIgZIqc2jSp+IEdit98VOFIvIDlcfccanetK1v9R6hHe1RLXGAC0XDGxRtn/2wdw
	 jFATCMbj4tN54GpE7Zjx5e41IKubNzmNZVB2JaGyFZ5bLnlNHxYL8Pj1lP1kqqsQZAx1u
	 ARBi34rzrlyrpB+fXwj3PKIwVr8LjDrOtkBdUHR0MdSJTpRRVxviG2c8LVIWkOBJ81FGP
	 9A40+ebAB7old1xQ5wHbwjHYRfanib48joiyPEZhU5ylTxLLZVmZPADiCxPJDMH7bjk0r
	 mgFGhUBOixPnzGJY257MJLD8wKw5LFCpfVxVV2Pt/XKWtsCOe2IpT6QWwrf0tgTd1Xw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795019222;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=IHPpq9O7Bob2HxoLcb71VWWoRVf/AH6ANUh3guwmlyQ=;
	b=E85WgbOvXF3Oac0dIPGebVybCeXMQDEz4uqKVX3a2K6B9zukuNE5FFj3Kjb6CDyCrVcR
	 bRufeeL7UOPeb3XKvnELpZ6IrsVtJvZ3loYbxvMy859ftm5g5ZH6uovZGWYOfJ3enLe0E
	 yQ87LgQ9J3TkfTFZHMXCfGXaaiGbAks60DdFXYcABzWeGwtF49p/tjZHNyjGIF3gHC6Kk
	 3k9NbSNSOaX/n2w6LSQFnNMsyuhSa0Vfos0Y4pQKBxQ4YQkG/9V7lsxpFxFK55qQzPr45
	 vAkSXTkVF8/ViV/gQM2zEVTh3Y22H62fhN1xC1zcYDiFVYVrXWdrmDvsir3oDUqD7/g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DiwygPKU;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DFB55606A331;
	Wed, 18 Nov 2026 16:27:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=DiwygPKU
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE65D1F000C4;
	Wed, 18 Nov 2026 16:27:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795019221;
	bh=IHPpq9O7Bob2HxoLcb71VWWoRVf/AH6ANUh3guwmlyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DiwygPKUz7Lpq7hEO0aQq+rcOeE/k7CVwJxNIcHCMxG4Kar5VDVda5chUt5p71KBJ
	 Er62d3F0Ojyru1XepRI4O8nKGEa9rrF87KsGvN2QtJRBNXlXqOjUYQ/bRtYJl4atcU
	 BQRvH6zbcq7sTfSv7pSmneVGtYwdeH9oiTXET5d0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1518/2651] ALSA: usb-audio: Check mixer matrix size for UAC2/3 at parsing
Date: Wed, 18 Nov 2026 15:45:58 +0100
Message-ID: <20261118150342.644717228@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 22185ffd7b31885d03fdeb20055a8707779a70f9 ]

The matrix of input/output channels specified in a UAC2/3 mixer unit
must fit to the upper limit 256.  Add a sanity check and returns an
error if an invalid size is detected.

Link: https://lore.kernel.org/d46fcac6-bd7e-4fc4-95e1-4e8d39f92ad3@zipdox.net
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Link: https://patch.msgid.link/20260930155356.348608-2-tiwai@suse.de
Stable-dep-of: c01fb2ed90c0 ("ALSA: usb-audio: Fix invalid UAC2/3 mixer unit matrix evaluation")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/mixer.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/sound/usb/mixer.c b/sound/usb/mixer.c
index d78314939be13..13e53e2a9fa26 100644
--- a/sound/usb/mixer.c
+++ b/sound/usb/mixer.c
@@ -2459,6 +2459,16 @@ static int parse_audio_mixer_unit(struct mixer_build *state, int unitid,
 	num_outs = err;
 	input_pins = desc->bNrInPins;
 
+	if (state->mixer->protocol == UAC_VERSION_2 ||
+	    state->mixer->protocol == UAC_VERSION_3) {
+		if (input_pins * num_outs > 256) {
+			usb_audio_err(state->chip,
+				      "invalid channels for MIXER UNIT %d: input=%d, output=%d\n",
+				      unitid, input_pins, num_outs);
+			return -EINVAL;
+		}
+	}
+
 	num_ins = 0;
 	ich = 0;
 	for (pin = 0; pin < input_pins; pin++) {
-- 
2.53.0



