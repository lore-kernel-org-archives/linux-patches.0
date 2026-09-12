Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A0548345CCE;
	Sat, 12 Sep 2026 15:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789227877; cv=none; b=JjHt4BuQ6ZpjgEzDpQTJXH5gh0y87/3FWGhNS1KCuTPEg1E+a5A3jEzqUefswqPpGHw/UXpSZ7OovtCbWQH+igV8BxFM3CrdkD/mxP0azrf4+DiCbXYGA8l1FRdFQJa6G6EfvqNUETSLJowX4MLn0H2rgngzGLf2iY044QCa/ZE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789227877; c=relaxed/simple;
	bh=2y9+MKN8RnQMiF8gQj5kCixGJS754jTQyQSnx3xn5nA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SyAt2NeeB0wIfFqwOubK9hzioVie7ZSp5/xAlEsHq6CzHWlToAhoiB2yowXSbYcI5l4AQJVD3KC+JBy6kjMyxBAzKJV8QBIW2a0qgvHdXSbrHM19YFYonWYF+SuEDH3yoikRWT8jNFj0+N8sSR8+H+TFChPvLro5mjXVXS9aAhk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=r+9RtWDa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="r+9RtWDa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 429C11F000FF;
	Sat, 12 Sep 2026 15:44:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789227876;
	bh=A/eBq+zSi2hueulRSQiU+guc02mtuErAwyKHbOTTlSo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=r+9RtWDahVrynf6S208GYRSjgoIEyOouIIRNVozzzWobedof1d66mVxXkXzcnsVVN
	 k/bIMuDaehIN2WxxrM9L36B/3RsiKS402XLdY9zQfRtkxRZg+FVgK+FqBY/B86az2H
	 xFgjqIennG/YiJiOvErLIfgQz7ENB0CD4Ik8LT9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.1 0270/1191] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Sat, 12 Sep 2026 08:49:58 +0200
Message-ID: <20260912065554.287539884@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -974,6 +974,8 @@ static void snd_usbmidi_us122l_output(st
 	default:
 		count = 2;
 	}
+	if (ep->max_transfer < count)
+		return;
 	count = snd_rawmidi_transmit(ep->ports[0].substream,
 				     urb->transfer_buffer,
 				     count);


