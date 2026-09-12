Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78EB13793CA;
	Sat, 12 Sep 2026 18:22:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237323; cv=none; b=BCAEnoL4qlglZULdQqSYbgwGBYkVqPkvpSy+S9k7fIlWfjybP+06+UjtRREpWc8CaF9JnDntJyO4edOpUwR/QQAAJ/5jnhEkZ2HarSyxiu1VmtZX7icXbvCAl8vrsFDS5/ZegGeaxI/aQJaFLhLSEORA/jor533f51SjDmkZE2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237323; c=relaxed/simple;
	bh=OPxZ8w2CCKDqf3q5CmFK1j91Ux3sDJ7WzTrDhGxON6c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lNsex21K5qjUtVc2EfhOWr77OHIWmWTumkGBQtSb6mq004piOQW2+6IUUnfc43jbrP1EOj183T+KsHiyVXrP/ypor2Z6L457QM7QfqMKkhNkwDyqSjGhmHWVbzHSrHt3Ie41/T5B2nKAIM+2a5GmoZSpn/AVYLwCtL+oHrsMwvQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FVkHMv6C; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FVkHMv6C"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1B98D1F000FF;
	Sat, 12 Sep 2026 18:22:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237322;
	bh=mfiZmuj61ncLAwMYKizGzVuJtkGDWCT3wLluDPYbsoc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FVkHMv6CAuZbpc6cqs6QdfvlFifRGbhjIQrXh20KR0Y96ITxoGpC5rSGj0wmKnA1+
	 /cuT3nYUSNflrQVMbE4UylQ9Z+QpvGcs7HpLtLZYalI+8oT6obzbUR8mzqzwccvOlP
	 WCXzqYOx0UaVPtx8RGxOZ3S9APOELr1oI/BLy4H4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.15 235/935] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Sat, 12 Sep 2026 08:54:25 +0200
Message-ID: <20260912065532.218032346@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


