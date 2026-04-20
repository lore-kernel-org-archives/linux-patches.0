Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BCD333F5AE;
	Mon, 20 Apr 2026 16:02:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700972; cv=none; b=ZsaIXFkcUirHhLl9drviZWNj3h1TRtKUHIHgd6JiuFSDsGm5j0UONU7ujg0VpfhoZC2W+vOBRrypPvu1rFlMUvgn0QzYSIODmu9KRP/KC/PYnL1yvL847yMbXMgZogzTOYpZJdP8lBp1g4raUHTCv82XmwSs1GohH+NcxjV4pkM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700972; c=relaxed/simple;
	bh=FDtjR6lYM83MJzRtoYOWRC2f0ajqQXKdL0t4qE+IS9s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SvdJRFJUqaZ/n0aMLwKKLXYky7JJ8dJB7A4qZ7/4MYFFuAqNBdxSgghlurrXCuExdbmTc3VkKepgTFDl16NHrUgTNi4FwOgqxKAGsLZptCQ+57CKtGZdoNDZfPUddYsptcbeh0S0qH+ERz+/+B8ROkbrzrzVLElxR2uLxfwC4j4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0t8qje/H; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0t8qje/H"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1214FC19425;
	Mon, 20 Apr 2026 16:02:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700972;
	bh=FDtjR6lYM83MJzRtoYOWRC2f0ajqQXKdL0t4qE+IS9s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0t8qje/HqNDzS00QvZ859BaGEgzPR9HNWgi0fn4bg8qIK4qcxRqW4AbUmmo2w+R0+
	 kqaqwcMQNxEnSWMBzh+aSmbi0qWzsq6KxrLpdFqxJ2bRl686DI9/y1zPcHKy5MYKdj
	 YFcxrx57o/L5gJnIqpWwscDQXSiIlRUl/oo6MXuY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.18 131/198] ALSA: usx2y: us144mkii: fix NULL deref on missing interface 0
Date: Mon, 20 Apr 2026 17:41:50 +0200
Message-ID: <20260420153940.325853046@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153935.605963767@linuxfoundation.org>
References: <20260420153935.605963767@linuxfoundation.org>
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
@@ -421,7 +421,11 @@ static int tascam_probe(struct usb_inter
 
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


