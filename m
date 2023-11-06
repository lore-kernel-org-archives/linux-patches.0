Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D22B200A5
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:08:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5p64B3W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE2D7C433C7;
	Mon,  6 Nov 2023 13:08:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276081;
	bh=dpHIt+GcD0RzbifWThVrrP20NhTHI5uXOZXOUGbutZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5p64B3WWotS0uFL6Ug6kXWag7v2Gh51sv9NGlCvFvJqyqv8/i7ar5IYOaa037Uh7
	 jiTUsaks2i7tZ4AnpMaqZOmcan5xphj7KQyS3bUOi3JPMo4zg7UhScl/9WlivR65Dd
	 em0HxUNIr9SNiBSMCPNbY4p2IQVXNmaif98izV9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Andrey Konovalov <andreyknvl@gmail.com>
Subject: [PATCH 6.6 14/30] usb: raw-gadget: properly handle interrupted requests
Date: Mon,  6 Nov 2023 14:03:32 +0100
Message-ID: <20231106130258.443613377@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130257.903265688@linuxfoundation.org>
References: <20231106130257.903265688@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andrey Konovalov <andreyknvl@gmail.com>

commit e8033bde451eddfb9b1bbd6e2d848c1b5c277222 upstream.

Currently, if a USB request that was queued by Raw Gadget is interrupted
(via a signal), wait_for_completion_interruptible returns -ERESTARTSYS.
Raw Gadget then attempts to propagate this value to userspace as a return
value from its ioctls. However, when -ERESTARTSYS is returned by a syscall
handler, the kernel internally restarts the syscall.

This doesn't allow userspace applications to interrupt requests queued by
Raw Gadget (which is required when the emulated device is asked to switch
altsettings). It also violates the implied interface of Raw Gadget that a
single ioctl must only queue a single USB request.

Instead, make Raw Gadget do what GadgetFS does: check whether the request
was interrupted (dequeued with status == -ECONNRESET) and report -EINTR to
userspace.

Fixes: f2c2e717642c ("usb: gadget: add raw-gadget interface")
Cc: stable <stable@kernel.org>
Signed-off-by: Andrey Konovalov <andreyknvl@gmail.com>
Link: https://lore.kernel.org/r/0db45b1d7cc466e3d4d1ab353f61d63c977fbbc5.1698350424.git.andreyknvl@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/gadget/legacy/raw_gadget.c |   26 ++++++++++++++++----------
 1 file changed, 16 insertions(+), 10 deletions(-)

--- a/drivers/usb/gadget/legacy/raw_gadget.c
+++ b/drivers/usb/gadget/legacy/raw_gadget.c
@@ -663,12 +663,12 @@ static int raw_process_ep0_io(struct raw
 	if (WARN_ON(in && dev->ep0_out_pending)) {
 		ret = -ENODEV;
 		dev->state = STATE_DEV_FAILED;
-		goto out_done;
+		goto out_unlock;
 	}
 	if (WARN_ON(!in && dev->ep0_in_pending)) {
 		ret = -ENODEV;
 		dev->state = STATE_DEV_FAILED;
-		goto out_done;
+		goto out_unlock;
 	}
 
 	dev->req->buf = data;
@@ -683,7 +683,7 @@ static int raw_process_ep0_io(struct raw
 				"fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
 		dev->state = STATE_DEV_FAILED;
-		goto out_done;
+		goto out_queue_failed;
 	}
 
 	ret = wait_for_completion_interruptible(&dev->ep0_done);
@@ -692,13 +692,16 @@ static int raw_process_ep0_io(struct raw
 		usb_ep_dequeue(dev->gadget->ep0, dev->req);
 		wait_for_completion(&dev->ep0_done);
 		spin_lock_irqsave(&dev->lock, flags);
-		goto out_done;
+		if (dev->ep0_status == -ECONNRESET)
+			dev->ep0_status = -EINTR;
+		goto out_interrupted;
 	}
 
 	spin_lock_irqsave(&dev->lock, flags);
-	ret = dev->ep0_status;
 
-out_done:
+out_interrupted:
+	ret = dev->ep0_status;
+out_queue_failed:
 	dev->ep0_urb_queued = false;
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);
@@ -1067,7 +1070,7 @@ static int raw_process_ep_io(struct raw_
 				"fail, usb_ep_queue returned %d\n", ret);
 		spin_lock_irqsave(&dev->lock, flags);
 		dev->state = STATE_DEV_FAILED;
-		goto out_done;
+		goto out_queue_failed;
 	}
 
 	ret = wait_for_completion_interruptible(&done);
@@ -1076,13 +1079,16 @@ static int raw_process_ep_io(struct raw_
 		usb_ep_dequeue(ep->ep, ep->req);
 		wait_for_completion(&done);
 		spin_lock_irqsave(&dev->lock, flags);
-		goto out_done;
+		if (ep->status == -ECONNRESET)
+			ep->status = -EINTR;
+		goto out_interrupted;
 	}
 
 	spin_lock_irqsave(&dev->lock, flags);
-	ret = ep->status;
 
-out_done:
+out_interrupted:
+	ret = ep->status;
+out_queue_failed:
 	ep->urb_queued = false;
 out_unlock:
 	spin_unlock_irqrestore(&dev->lock, flags);


