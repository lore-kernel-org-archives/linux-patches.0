Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795025737;
	b=tPDrT1LxmjDL1W6tQhOJPa+41hm8oyaPJ4zHOKNG9Di4Z/MR9unEjsMVZyMU5qwajSRT
	 4C7+mKeikbJgRV6SucZtbWPLMxAf4UjRt10vm2i0EpsHOraKEhGU/ytJZYC1ermVqDlBV
	 sMqWd4IwIKxCzsxZ0qdph6Vv3dr672x/mI11exOHwZH/sJbUhNJGzEgYiwdX7MAu4Zxur
	 tLIggArjRW2WT41j0SEAGGnVBzBypEy1O7t8eNLahaPayalvhnR/sVqEZkzQltE8DTjVu
	 0F+1a7utUTu66flOVdLDkCL3KoFAEfcs7jYbkDLEFpYXTbodPZ/daN1d69PrAW9KDsg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795025737;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=Tyz5FZW29iNJJJ91vSaB8p2P9kAutKlDuCrKOsK6WVo=;
	b=J1kZau6pnR0ann0MihhFmZUFBfdJLQBDQMLZCP2IN1fApMy8wLBpKJZEx6YPAdw5visy
	 nbO1L2OxiQ8azSMTF1AIfGD4Sc/uARscLBTOEvrqkagtmJ7PPkrOpkrHDpYBQsp2YCU7Y
	 n9g+S0+xrozMbktkqvj2N0QCpBYZs8PcV3XIbSii1hN/QYopjM3DmCWsv7dEWKuuvvIdz
	 2O5al0dSoEWWh0Xvur2ViyfrLnXiq4Apikfn9J6/k5tXgssxSSosUtXHv3bz2s4qHvIea
	 A6QiuqjLnIst8AMqPGpQc6bWSptP0M7PS0LxCzSgtN1nIsnPmpY7zTqPWPwglExpC5g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rp7sByjt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 77424606A31C;
	Wed, 18 Nov 2026 18:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Rp7sByjt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C93BF1F000C4;
	Wed, 18 Nov 2026 18:15:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795025737;
	bh=Tyz5FZW29iNJJJ91vSaB8p2P9kAutKlDuCrKOsK6WVo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Rp7sByjtLB7Vay25Eis6GUbqY27zLuOI0xlqThaB2i0ZqwCgcDS0I79A7+YFusaZa
	 km7BMD5TymuCdcmVvLT7PzHeFiEkrkj6kg19uWtylPlx120L7tY0FMvcslWT4dl0io
	 +uMhMDqSZCZgiWzUz6g1OkJ+9/pwdouo5XBlsh+E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1184/2151] ALSA: caiaq: Allow zero-length packet handling for EP1
Date: Wed, 18 Nov 2026 15:48:39 +0100
Message-ID: <20261118150205.308198123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit ccfe6ab672c020fca56988e634088bfb7764e2a7 ]

The recent fix to avoid OOB access for malformed packets added a
packet length check and returns immediately if it's too short.
However, this can be lead to a regression because the completion
handler doesn't resubmit the packet, while a zero-length packet itself
is valid, per se.

For addressing the potential regression above, change the handling for
a zero-length packet to just resubmit without processing the incoming
contents.

Fixes: aba30af07d4f ("ALSA: usb-audio: caiaq: validate EP1 reply lengths")
Link: https://patch.msgid.link/20261006134405.479603-1-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/usb/caiaq/device.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/sound/usb/caiaq/device.c b/sound/usb/caiaq/device.c
index e8619bb743581..993858d18b680 100644
--- a/sound/usb/caiaq/device.c
+++ b/sound/usb/caiaq/device.c
@@ -142,7 +142,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		return;
 	}
 	if (urb->actual_length < 1)
-		return;
+		goto resubmit;
 
 	payload_len = urb->actual_length - 1;
 
@@ -192,6 +192,7 @@ static void usb_ep1_command_reply_dispatch (struct urb* urb)
 		break;
 	}
 
+ resubmit:
 	cdev->ep1_in_urb->actual_length = 0;
 	ret = usb_submit_urb(cdev->ep1_in_urb, GFP_ATOMIC);
 	if (ret < 0)
-- 
2.53.0



