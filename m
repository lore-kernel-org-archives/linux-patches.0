Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C718481DD;
	Sat, 30 May 2026 17:03:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780160623; cv=none; b=CLHgOHDW9BSDttQvZ83L06j2Chk0tAv9iiA/ylsTAj6PFMqYNM+ExOF82qmsNZ+xglZgddPSv98IwGMxkLCLkBVFEeycb7dFENJoVGEjMG+n3wFVdDvwVU20zILZ3Iv4eGRZBptAs3VN1lRUtC1O0vpVZ4yHP61kSNWFmL2eQEg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780160623; c=relaxed/simple;
	bh=lJ9DhHne/kK5l6o9Qm29Wkd9mUuxKiKPqFOoLiCYIiE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0MqLh0/TRTatrHwMwAavDE33jr0ZAJNOgNprvat0YzG5oCl5vpMO7itwutSrCcCLXPy8Gv0HO9I3yzGB9XSJTTItgLjiweQwitMBOt1IyYgWdXx6evJmvW5CLKkqePn8a1YmwdbWCDm8++3YOnbo5CtDvOxVPAkwupwAFR5XbI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FztR87i2; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FztR87i2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6C031F00893;
	Sat, 30 May 2026 17:03:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780160622;
	bh=N/GQ1AtFG7LduDfvGKYz2Edenj5hxg/L9wfFBTAms4Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FztR87i2Gh8ppyOJAYQ2jR5oUTNdRYK6NGuglEtZUe+EYGKhoy3vQ3aK4ePO5fOWF
	 uAAaoZbwyN+WdBZiXlU5+0xbNWgpHyqphOKgXqiNJMBLi+4y2cjhyK+cF3J/gGupBx
	 JOLNFl9WqV9imE8QZInXsbk2IDc8vYiJGRPJ+A/k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.1 388/969] media: rc: xbox_remote: heed DMA restrictions
Date: Sat, 30 May 2026 17:58:32 +0200
Message-ID: <20260530160311.022721508@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

From: Oliver Neukum <oneukum@suse.com>

commit e280d1e5e3f2595bbb43fe6e1bce00c59a43c0ff upstream.

The buffer for IO must not be part of the device structure
because that violates the DMA coherency rules.

Fixes: 02d32bdad3123 ("media: rc: add driver for Xbox DVD Movie Playback Kit")
Cc: stable@vger.kernel.org
Signed-off-by: Oliver Neukum <oneukum@suse.com>
Signed-off-by: Sean Young <sean@mess.org>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/rc/xbox_remote.c |    9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

--- a/drivers/media/rc/xbox_remote.c
+++ b/drivers/media/rc/xbox_remote.c
@@ -55,7 +55,7 @@ struct xbox_remote {
 	struct usb_interface *interface;
 
 	struct urb *irq_urb;
-	unsigned char inbuf[DATA_BUFSIZE] __aligned(sizeof(u16));
+	u8 *inbuf;
 
 	char rc_name[NAME_BUFSIZE];
 	char rc_phys[NAME_BUFSIZE];
@@ -218,6 +218,10 @@ static int xbox_remote_probe(struct usb_
 	if (!xbox_remote || !rc_dev)
 		goto exit_free_dev_rdev;
 
+	xbox_remote->inbuf = kzalloc(DATA_BUFSIZE, GFP_KERNEL);
+	if (!xbox_remote->inbuf)
+		goto exit_free_inbuf;
+
 	/* Allocate URB buffer */
 	xbox_remote->irq_urb = usb_alloc_urb(0, GFP_KERNEL);
 	if (!xbox_remote->irq_urb)
@@ -262,6 +266,8 @@ exit_kill_urbs:
 	usb_kill_urb(xbox_remote->irq_urb);
 exit_free_buffers:
 	usb_free_urb(xbox_remote->irq_urb);
+exit_free_inbuf:
+	kfree(xbox_remote->inbuf);
 exit_free_dev_rdev:
 	rc_free_device(rc_dev);
 	kfree(xbox_remote);
@@ -286,6 +292,7 @@ static void xbox_remote_disconnect(struc
 	usb_kill_urb(xbox_remote->irq_urb);
 	rc_unregister_device(xbox_remote->rdev);
 	usb_free_urb(xbox_remote->irq_urb);
+	kfree(xbox_remote->inbuf);
 	kfree(xbox_remote);
 }
 


