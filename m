Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACA4B377A93;
	Fri,  7 Aug 2026 15:07:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786115264; cv=none; b=Z4O/eAy2f9S/c6CeP2P4RcoEpznTgnU22E/HgloxI4Eo/DwVSGtZ/+/o4Twb4bsnOgYuBDTBIMgFugshod0njdyp2C9Q/m4oYyuJOmDRLb266gZCbI7eYZFiUo6zrfNGp9EvvWWDgjVjqWqK9BvGVWckZM/ShcQ9Tnu+lHjQCBU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786115264; c=relaxed/simple;
	bh=I24sH/+awHpUVhNMwcHUXwRDVGHPOxK7cvEC3vyWC78=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjclQFyPNt3SrLH41BIHQD/u3LuvsWDg5VTbLlklof1aDzHsLBz1FGQ48b4rbzIWz4xzDpZX2mNPf55sK6PDXKno9+yEcMnHx3Gv5uWNdAazlf4dGeznjyMX7Yk9n5NdDXiH+FHQ6825SX53abCx0gx57+mWpNfHMOXpy0pS/Gs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=B+v9MeyE; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="B+v9MeyE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AFDE61F000E9;
	Fri,  7 Aug 2026 15:07:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786115263;
	bh=qGJi730d9/vgCKzE4mg8LwYo5AiVojmrVmhPvNQciv8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=B+v9MeyEw34YvfXzS2wpzKNCR18l4XC5fBbXgOfUsllOLdmQJLtyB+lYRdGT/VsVe
	 16R7wRO3XJRUd594WMCtWZWNPR4+ye+y7u6c+6spDBbsX5/woUZWKwPbz6AQE1Tony
	 15fq+NvEq8Hy5mSRHJ4ufvrVua32o+3csLSjGOic=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Federico Kirschbaum <federico.kirschbaum@xbow.com>,
	Baul Lee <baul.lee@xbow.com>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 215/396] ALSA: usb-audio: fix stack info leak in RME Digiface status
Date: Fri,  7 Aug 2026 16:36:15 +0200
Message-ID: <20260807143428.904658928@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260807143424.272339768@linuxfoundation.org>
References: <20260807143424.272339768@linuxfoundation.org>
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
@@ -3352,7 +3352,7 @@ static int snd_rme_digiface_read_status(
 	struct usb_mixer_elem_list *list = snd_kcontrol_chip(kcontrol);
 	struct snd_usb_audio *chip = list->mixer->chip;
 	struct usb_device *dev = chip->dev;
-	__le32 buf[4];
+	__le32 buf[4] = {};
 	int err;
 
 	err = snd_usb_ctl_msg(dev, usb_rcvctrlpipe(dev, 0),


