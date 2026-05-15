Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 600783FD95B;
	Fri, 15 May 2026 16:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862409; cv=none; b=VPbp+EtUotkDSnrc/kXxlcpOobUUiONdwZ19Ik1grcxgrvtCfMu322RhWXKzhJ/MMukexXhKp483MZt5FGPXY5ZjjC7RuY2H/nMgLgSNPcpAxPlyL34rbno5IM7zeHIqheqpH5bXos90XqAAMJ8TeePTgxUIo9RlZBED1VpKcSk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862409; c=relaxed/simple;
	bh=kJEMRW47mo9xQ3BJ8qLcwJqDDi95qGy0I8vcWfkCUh0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=W3memdDp9+uKkp0V7ltQNqss+kjVZ/KjK8kg5fuXD2mZ64n36TVm3OB4XXmknKPNyIB8x1xW1EBJl9jMqt61mtSb4dRe3XQTVKvff8D0xgDnB3PrNGlgCmAhtd1vSR8KnenIqDHw67+LtdtEbjxAsJQGFjYXAUpy23zI+F5o8XI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MKIKZwfL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MKIKZwfL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A843C2BCB0;
	Fri, 15 May 2026 16:26:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862408;
	bh=kJEMRW47mo9xQ3BJ8qLcwJqDDi95qGy0I8vcWfkCUh0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MKIKZwfLf9+Ifkv6llVqSOGBjMBkAhqqgpV6jW0XEsV610PEzMumrwWgHvJsBaFJN
	 j5XPw/WEQOy/NzV9ZCSK3x5xsO9RbHbLpnCXgZ0Uy29nUQsdIpclkdCRV5gBW2W0if
	 PN7i/O1uhWrCeMqen7hGSLHYHE6mfmOwPyFSjVBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Oliver Neukum <oneukum@suse.com>,
	Sean Young <sean@mess.org>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 036/201] media: rc: xbox_remote: heed DMA restrictions
Date: Fri, 15 May 2026 17:47:34 +0200
Message-ID: <20260515154659.317022289@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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
 


