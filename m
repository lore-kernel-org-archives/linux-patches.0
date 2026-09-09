Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486FE53A8BD;
	Wed,  9 Sep 2026 13:47:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788961665; cv=none; b=WFM0MRf9GcZjZ5Y1GzJ76HjHlh9nwFgVjpH3vIeM5cIyHN5mZ2w16EOyUgKDoHuBbu+l8JvykHVZpKIfjdVxwRbWeHUm05ghRPKQi0ON7bZoLZqLiHsAgrkA94iY/RKg/Scgo8aPB0wzDvobmwrg2HRLfV3PaIz95IGrRoX+ELI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788961665; c=relaxed/simple;
	bh=pNwTu/17gt2oMX0M+ZluXuU++2rekd2MztFG0LElnbo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jaJdh3oim9Oq5C9Ih0m6E7SzyGfgqUNcRRg/jPtB9OONgIus7gCm6QJMeiOp0AW6Z7J5k7l0b+b/P0DDheeiu6q+oJURV6DOHIj8WT47wDvuZk3ClEQTYAwGkA9e2RlPyCJrIAvhe7P6glr5Ka8BR+lM4avPlKU2r3Ibpikmy1M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OatAcmfE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OatAcmfE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6B8B31F00A3A;
	Wed,  9 Sep 2026 13:47:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788961664;
	bh=DP2z9FBwxvVsOLgLHNxNDxDCAxcjOQ/AtRTPgQKq22A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OatAcmfE/EFKIqDpdUW94OrSxZyljGIyG5yhlGa09ahn+8S5mUHQgEggQMk9tpz+9
	 nnDqVsZ/46i2P7n+FtfJJbuUJrskhTICDYz3SCTBervkFlkRKcdJdm/6sFFKEueWAT
	 k3RAaUKVESnkxAB11aB0DX+kglO6q7G1kYxFrDvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.2 026/556] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Wed,  9 Sep 2026 15:35:06 +0200
Message-ID: <20260909134231.424309305@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: HyeongJun An <sammiee5311@gmail.com>

commit e4637ce34607f1733a34a57294966d26b263e626 upstream.

The snd_usbmidi_us122l_output() picks a count of 2 on anything slower
than high speed and never relates it to ep->max_transfer.  The URB
buffer holds exactly max_transfer bytes, so a device declaring a one
byte bulk endpoint takes two bytes from snd_rawmidi_transmit(), and the
memset that pads the rest computes 1 - 2 in int and wraps to SIZE_MAX.

Only 0x800e and 0x800f are pinned to nine bytes.  The US-122MKII at
0x0644:0x8021 falls to the default and takes usb_maxpacket(), which the
USB core only clamps downward.

The akai and novation output ops in this file were given the same guard
recently.  Do the same here.

Fixes: 030a07e44129 ("ALSA: Add USB US122L driver")
Cc: stable@vger.kernel.org
Assisted-by: Claude:claude-opus-5
Signed-off-by: HyeongJun An <sammiee5311@gmail.com>
Link: https://patch.msgid.link/20260901090409.1478573-1-sammiee5311@gmail.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/midi.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/sound/usb/midi.c
+++ b/sound/usb/midi.c
@@ -971,6 +971,8 @@ static void snd_usbmidi_us122l_output(st
 	default:
 		count = 2;
 	}
+	if (ep->max_transfer < count)
+		return;
 	count = snd_rawmidi_transmit(ep->ports[0].substream,
 				     urb->transfer_buffer,
 				     count);


