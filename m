Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BFD938C421;
	Fri,  7 Aug 2026 14:49:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786114168; cv=none; b=TA45sdzii1G6CmBsZkI8+uBwnxJlOWdNE187HtRIk029wvHBHDvofGKNi/QaU7bPbcBqNN1JBpEwwvv3BzNIrsqxbYGRge7sQkw/qcFJDQwve85493zz3n9gkP0c5BoK38i+ZiHFybDV3xAlupZng78ThV9UtuHq+vRWQk4XJeQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786114168; c=relaxed/simple;
	bh=qxgCRuDZGVGO3XgHPc4d3TRpHqxAXh/mZ8GwBc/25xU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QfETfknBBajyGH90VFiEyQ0TKyp7I1amD66js43PGOI2yA6UHvkEfnLX+3QZh5K4meDntI22ttfg8GWRJpAtPmqloiKcG5YfzXeAFawAkMXxISZl/pA9xFX8baAFNZnGMt6DOeGJU/9Yz0cVeRaXDBq6lPFt+AYW3bykbh3pXkA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NZBwHS7i; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NZBwHS7i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6AA21F000E9;
	Fri,  7 Aug 2026 14:49:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786114167;
	bh=k0YkrF7f49wHdC7N+DGK80NwmDC5V/wF4IOdu/gdjm4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NZBwHS7iGm+KAHomIpQ936ByBEAj8s8b/J8iwPPgln13ZuRPTaKQOyWUR71dGXbN4
	 s/yBbf47ru+GVSRtBH8PxFUFTvvAwYWpgwBqTmV/wZ+eKvaiC4RfTvfJ1pnoayqh4e
	 ZXx2q7jrB5w05ei5Yh6eds15NlYcQNCT894q/C+8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.12 166/337] ALSA: usb-audio: fix stack info leak in RME Digiface status
Date: Fri,  7 Aug 2026 16:36:09 +0200
Message-ID: <20260807143422.152998700@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143418.516897842@linuxfoundation.org>
References: <20260807143418.516897842@linuxfoundation.org>
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

From: Baul Lee <baul.lee@xbow.com>

commit 441aaad150c57edaf57ee482a79a3bf4c5b7e353 upstream.

snd_rme_digiface_read_status() reads a four-word status block from the
device into an uninitialised on-stack __le32 buf[4] and, whenever the
vendor control-IN transfer does not return a negative error, copies all
four words into the caller's status[].

snd_usb_ctl_msg() copies the full requested size back into the caller's
buffer regardless of how many bytes the data stage actually delivered:

	buf = kmemdup(data, size, GFP_KERNEL);
	err = usb_control_msg(dev, pipe, request, requesttype,
			      value, index, buf, size, timeout);
	memcpy(data, buf, size);

usb_control_msg() returns the transferred length on a short control-IN,
which is a non-negative value, and writes only that many bytes.  The
remainder of the copy back is the kmemdup()ed image of the caller's
buffer, so a device answering with a short data stage leaves the
trailing words of buf[] holding leftover kernel stack.  The only guard
in the caller is err < 0, so those words are stored into status[].

They then reach user space: snd_rme_digiface_get_status_val() selects a
16-bit halfword of status[] per the control's reg/mask, and the eight
Digiface status controls together expose the whole 16-byte frame to an
unprivileged reader of /dev/snd/controlC*.

Zero-initialise the buffer so a short read yields zeros instead of stack
residue.  This mirrors snd_rme_get_status1(), which already clears its
output word before the same kind of vendor read.

Discovered by XBOW, triaged by Baul Lee <baul.lee@xbow.com>

Fixes: 611a96f6acf2 ("ALSA: usb-audio: Add mixer quirk for RME Digiface USB")
Reported-by: Federico Kirschbaum <federico.kirschbaum@xbow.com>
Reported-by: Baul Lee <baul.lee@xbow.com>
Cc: stable@vger.kernel.org
Signed-off-by: Baul Lee <baul.lee@xbow.com>
Link: https://patch.msgid.link/20260726065020.46070-1-baul.lee@xbow.com
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/mixer_quirks.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/sound/usb/mixer_quirks.c
+++ b/sound/usb/mixer_quirks.c
@@ -3413,7 +3413,7 @@ static int snd_rme_digiface_read_status(
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
 	struct snd_usb_audio *chip = list->mixer->chip;
 	struct usb_device *dev = chip->dev;
-	__le32 buf[4];
+	__le32 buf[4] = {};
 	int err;
 
 	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),


