Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 905F4479876;
	Sat, 12 Sep 2026 11:35:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789212928; cv=none; b=boXd147dFaQB8gHNqnDOp3XantqIOG1XbOfa1LVmmP/+Yygd6ogNi/wu/hHAFp76cgi4woxxNpiswNLmJNOlWMb8lAWfYQVAd9dvTG4CKrmXLO7/f0JwYxpOnFfFaVtbu1cK1ZDQIwr9eyIg3z6jLV7V2Av7OsY29CxEi+MV3p0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789212928; c=relaxed/simple;
	bh=Mla7pMiSrYf76HmnCLUGwsJiwqMIcev107gQq64ig6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R0UDXb6AeCXyswc6SQ8OvVQzhIkDZNA4e8hgWGqSpSYrr0Vi6hWcgEMPvnhzK6CZz7aENC5b5JypTTDFlp0Kd/Hsbm2IpqaToahBl8KY53CVbuJ4mVJMGLuJlZcNXdy73nXdWyTjXc9b4Itm03fpuRyY/aXdXLS+Sq8bg9gYpS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=K9DDyURT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="K9DDyURT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16DEB1F000FF;
	Sat, 12 Sep 2026 11:35:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789212926;
	bh=4WCV9hzbLJrO/mTYj9+eRW+eg4fouXTQQa8URNKIj/8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K9DDyURTQWryX9hPtaQA/RwJZQuEykeIw6hl28sVN1475WrkTlfNWCgcv4lf448YB
	 +SYnTm7+dWcCZrrcytByR5xP1AQqFpFI+j+XXZzZC4P/R1aOHf6Or/9BHvxm/iWK6z
	 P5wmoLFqn2TenD+MhBzoXb+MgULcsusVohuqNqQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	HyeongJun An <sammiee5311@gmail.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 0018/1376] ALSA: usb-audio: fix OOB write in snd_usbmidi_us122l_output()
Date: Sat, 12 Sep 2026 08:40:44 +0200
Message-ID: <20260912065607.955134655@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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


