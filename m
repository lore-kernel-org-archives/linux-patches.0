Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BD30A2D0C94;
	Sat, 12 Sep 2026 19:36:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241818; cv=none; b=KrBkfIgrfqwqD3mrr7SDjyfKw5C7JZTN9rHn+LT+46Etq7+hRL5s8Fht5UVXS96I2FV1H0Znbn1TlI6iyCIqL1X5pQbr8zhgr9gHHXYDn2xeLBARfzpLikp60FIJVAOGcduh/OgPUWquJpVvVsWjYj+OvaRePTbMOezfW0IejOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241818; c=relaxed/simple;
	bh=QJr/ItbN0pRr28x6hbGL0S2u7oMzB8ASChW5k6wiCa4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MwcbPbMPVn4pSCGtqfhATN0/5izwgTZWpkdEQLQIdf+2DLTHoP9vQopj1WQEBqnFvjd7PRQpWJbZedCuuy3wyvOpLNcWNaZwTzi4w3jqoJHtl6SACl8dpOcckNsuqmsh/mphpzvOn2t379Gi81MloArZc9BrMe+QKLhU3TrmZLA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VdkEqEN+; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VdkEqEN+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3E261F000FF;
	Sat, 12 Sep 2026 19:36:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241817;
	bh=kJoIkguYQBY1r5TyhgWmyFPJ6EUMDz7a9w58MnL/Qbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=VdkEqEN+VNcQoMWevt1CSaw3zfN1ORuf4CSSbu72FRpipV66F+YimkWd21xuybeYP
	 zOTu2L3MI6DsxxoBMwzRXB+UCB3Y2m1WQ7ofMye4NgnTrvSUgz8yubP9OhhnRwoTWM
	 1/WYSFQcAnGQCn8pdfbTJIJzxf4uABjgTl9/4TXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 5.10 214/798] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Sat, 12 Sep 2026 08:57:22 +0200
Message-ID: <20260912065522.017409823@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
@@ -990,6 +990,8 @@ static void snd_usbmidi_us122l_output(st
 	default:
 		count = 2;
 	}
+	if (ep->max_transfer < count)
+		return;
 	count = snd_rawmidi_transmit(ep->ports[0].substream,
 				     urb->transfer_buffer,
 				     count);


