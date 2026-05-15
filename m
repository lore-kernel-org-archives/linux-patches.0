Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C471217AE11;
	Fri, 15 May 2026 15:51:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860265; cv=none; b=G7oPzhM+SljkO1uT4gXFrGvENcVkvxmE9k6Qp/fB8QGkhZ2LxzMSwPidI5SPYKN0giWgk6/TCHiK8HFsleUy3UD/dL26OJaTHtoiIDEpxH8VfFdWsziWANO7MHrDImsKZ6hO54ln4t4piKJpSy9R6tE/gQCf8SCFTlqWG1utbjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860265; c=relaxed/simple;
	bh=XAloqg1A90mdHQxHIXAH4uPwX0ZNihCJgf76O4gOHsA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d2vYiqXFaSXzX2lm6hISs3vMBDsOG79/PqyAKCJDsDas8Ko1cDSP3sQwx8kW9a1/BxWGLx6VtzekOkIMvfLXILYb5YI2EMBFe31UZlQskPTMfs9ZgYKQQfTnz+ac7g+0sfCHtkLIDdp2/o1o+Kfkgn0SLW7iZdKiar/lcvTJ5yg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eBH0Le4o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eBH0Le4o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B1D3C2BCB0;
	Fri, 15 May 2026 15:51:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860265;
	bh=XAloqg1A90mdHQxHIXAH4uPwX0ZNihCJgf76O4gOHsA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eBH0Le4oTsN3P+KKi5/jDWX2SVmoLnEYSrrD1KsbluZEaFjL70E97fL5fA3sL8weQ
	 wtvUsKRlbY39iti+njuy5DGDzi+EMkmjxtXCZf8qoQomDzdUAkfuH8NjG/wS4GSM+/
	 +0O7wDLM2AM6/OS54tXzOV2uKk3WtgOi2NMKsk3k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.12 015/144] media: rc: xbox_remote: heed DMA restrictions
Date: Fri, 15 May 2026 17:47:21 +0200
Message-ID: <20260515154653.846436581@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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
 


