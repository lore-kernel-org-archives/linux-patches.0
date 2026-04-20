Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 54D432741A0;
	Mon, 20 Apr 2026 15:52:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1776700379; cv=none; b=DV8EWE49LXzkR69PoICw8yrTYwpOV42h56oPC/hUM4Ci3CsUQv+Hg1Cm1MoXf9U2zxgRGzoAao0z6NXyPJoTZT/9tBWpVW4zx/+qk17+8cwH0iwwWPJG0Am4qWoo399z45ZVxaA2xHiAmArAErHWMW188ZVE9mOWeMQprh42WGQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1776700379; c=relaxed/simple;
	bh=7mMpzfna4D/Q/trlVyipXu8fvEmMjJLoI95ljBy1qTk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JOzg6Rug3poRTgi0iRvOgKNoFEnkkm1/+1Uk831D3e56vkZUbgiyu6B/FsJWuUXBgAHWir3565hGpHQnuwoUkFrWRJ5J+QU2nAi0aouMs7JuqjhzH5ZUvW1//BPmPkSmijgerD2ILOQlmhsmlzm6ioCUHbni2h8vdQ+p3TwVGYw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Kecjt19o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Kecjt19o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D6A58C19425;
	Mon, 20 Apr 2026 15:52:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1776700379;
	bh=7mMpzfna4D/Q/trlVyipXu8fvEmMjJLoI95ljBy1qTk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Kecjt19oyd/mH6+qThCGdLdZuucKvo5iipwGg73di8joidlIr8/+J9Z7AbBOr9KYq
	 7e4F/WEDnB+bhqKHP7dHXfKRoPchaYIZeQF2B9oR0KR6LGRfjK5QAZHzMhl0fMv0BM
	 E9eQHnGo+mqEoxH07uN9ci6b8e5S/d7Inke7X8Go=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jaroslav Kysela <perex@perex.cz>,
	Takashi Iwai <tiwai@suse.com>,
	stable <stable@kernel.org>,
	Takashi Iwai <tiwai@suse.de>
Subject: [PATCH 6.19 150/220] ALSA: usx2y: us144mkii: fix NULL deref on missing interface 0
Date: Mon, 20 Apr 2026 17:41:31 +0200
Message-ID: <20260420153939.429880355@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260420153934.013228280@linuxfoundation.org>
References: <20260420153934.013228280@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

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


