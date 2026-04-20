Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69EED3368AF;
	Mon, 20 Apr 2026 15:43:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776699824; cv=none; b=mmYWqFlnEOhC2K1NE0xP54KlhwYcPLJgGHCEL6qAQq63VjdjAfwosoppb67rMe+29+uLHuc6EUyvjVloaw0llECQI4l+uGaidYHiixwYaiZveAlFEBH+CfVQglNS2okQ70ZB08NrpilimW0zWPVBQ1yyeI6OG65qgRxN6CnCh9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776699824; c=relaxed/simple;
	bh=dScFOOfi3cKQxP/HVxXcM8eAxE8FM0SPa5PIxUFOl2g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UogmKv14unOkJheDuPTCf7l6HPtifdH0vrlLlWFBpTl+Wh8FUJS3u/dbuwjHRvjpkMqbdDdO1PEnXWJplMdGpINMfpe2gFj5VZTUeXkzu/YOWexhawKXnPuiHTPwqea5v82tSLJH+DPBgZfOO9VItj2YPNbSPxd+ji0+C/nxv0Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GDgogSN9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GDgogSN9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C60C0C2BCB4;
	Mon, 20 Apr 2026 15:43:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776699824;
	bh=dScFOOfi3cKQxP/HVxXcM8eAxE8FM0SPa5PIxUFOl2g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GDgogSN9eDG/Zk9a15NWS7SzsdzvRRagWso2SWMzokRVVQUPEKB5KF91U9afjuf/w
	 xTy731k5TpFzRY5acf4TKfYDD76EaLfLY6v5NCGQg6Z9rHV2JEf3BEhMxPizbrh6Aa
	 yBjuvPkpPPoZrApnYY9Fet1k9AWaqhHBxmmI3uRc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 7.0 12/76] ALSA: usx2y: us144mkii: fix NULL deref on missing interface 0
Date: Mon, 20 Apr 2026 17:41:23 +0200
Message-ID: <20260420153911.267426087@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153910.810034134@linuxfoundation.org>
References: <20260420153910.810034134@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

commit 48bd344e1040b9f2eb512be73c13f5db83efc191 upstream.

A malicious USB device with the TASCAM US-144MKII device id can have a
configuration containing bInterfaceNumber=1 but no interface 0.  USB
configuration descriptors are not required to assign interface numbers
sequentially, so usb_ifnum_to_if(dev, 0) returns will NULL, which will
then be dereferenced directly.

Fix this up by checking the return value properly.

Cc: Jaroslav Kysela <perex@perex.cz>
Cc: Takashi Iwai <tiwai@suse.com>
Fixes: dee1bcf28a3d ("ALSA: usb-audio: Add initial driver for TASCAM US-144MKII")
Cc: stable <stable@kernel.org>
Assisted-by: gregkh_clanker_t1000
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Link: https://patch.msgid.link/2026040955-fall-gaining-e338@gregkh
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/usb/usx2y/us144mkii.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/sound/usb/usx2y/us144mkii.c
+++ b/sound/usb/usx2y/us144mkii.c
@@ -420,7 +420,11 @@ static int tascam_probe(struct usb_inter
 
 	/* The device has two interfaces; we drive both from this driver. */
 	if (intf->cur_altsetting->desc.bInterfaceNumber == 1) {
-		tascam = usb_get_intfdata(usb_ifnum_to_if(dev, 0));
+		struct usb_interface *intf_zero = usb_ifnum_to_if(dev, 0);
+
+		if (!intf_zero)
+			return -ENODEV;
+		tascam = usb_get_intfdata(intf_zero);
 		if (tascam) {
 			usb_set_intfdata(intf, tascam);
 			tascam->iface1 = intf;


