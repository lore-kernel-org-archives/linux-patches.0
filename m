Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B1C8566C53;
	Wed,  9 Sep 2026 14:14:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788963248; cv=none; b=NRDHysAfblMswkOPacGaZPbZmMxzRYltl3VSvO0L56Mq1SKTkPVdHbta7vE00C0UHSq4GHL2TMh0UX3r1s7Ff2/LUGLQqD6BfWy/6cVKjqkL5f3BHnlW6KcD58790sbpzlpJOs/ay+uAkZkePUsfFfDCltoddMTpZsa+BPd4p7E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788963248; c=relaxed/simple;
	bh=SDHG6zTd6ZvgVF3h04q08aa1HigfmzUDEz/caB0bkJw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NPrMCkSG7XTXatz13OPQIgF5jOzw42gl3C8Dvq6T/ZSOlZeKxs8ge9XvA3gZ8lzrnLG8bi1+xrKSqZ3Xqy4OfRlUIgajucLQeys/SvnZpAbK75yPYp6Hz+ZKs6PGAVGfwAs5R0PfJO/2RY3dOUELLLmcpDZnVUvdNQdrEuI/3sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqpkS5y9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqpkS5y9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B29D71F00A3A;
	Wed,  9 Sep 2026 14:14:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788963247;
	bh=DirP6V2fHkBYtZAeJjyEhfD4kQt9p0SLOHJ6mPVPnL8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RqpkS5y93QABBoCMcz8PTrqchQxJw0MsDrBAhKHXsy7Zdv00KS0VPJdh2a47gz2a7
	 QUWCw7yHU17nRJRRXWXsT1jsj6rnr+HZxeridQomLuswh1fJHH6HQC2lctRlpfF5Yl
	 aGjN+BLi0jry8V61RSJey1Y1/sxxM4AaJNcxKotY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 014/583] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Wed,  9 Sep 2026 15:34:59 +0200
Message-ID: <20260909134238.296931302@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -967,6 +967,8 @@ static void snd_usbmidi_us122l_output(st
 	default:
 		count = 2;
 	}
+	if (ep->max_transfer < count)
+		return;
 	count = snd_rawmidi_transmit(ep->ports[0].substream,
 				     urb->transfer_buffer,
 				     count);


