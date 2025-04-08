Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F0F482690D6;
	Tue,  8 Apr 2025 12:28:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115293; cv=none; b=CUmF9p0VKn/6qZEDYO5Ivt6kImzdB8EluisCklTNkeYo75NmaRQymcDySw/lHBlG9+riRAXiAVnBnqvL7X0JL0mHEVDdrzECcv8cpPtU6PMPjxLqSq0a9FiUYNMsy41DyjpFmqcA462O3R2/YU3rRsRa9YobprfOcVzfs+ShB3g=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115293; c=relaxed/simple;
	bh=yYkJ52Rgx/QelqzglN+GR1esxDkGe+q0nK1zG1oewH0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lbJMbv/5oLHUjN8UNnQj7URdIFvMaSmntcSFMDtKbPNweRLIe44G25aWPsas4+wN7cnifqhPkpcfe5mpMGhVtI9G5HF9XM9TraLsc4zaFB4HceMEEyX87cT/4B5pjmZXOybhYjEUFuUsYc3aTT9dOtG8SLTCyGXXvusVUYaqdr8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GBOlvTm4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GBOlvTm4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1FC85C4CEE7;
	Tue,  8 Apr 2025 12:28:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115292;
	bh=yYkJ52Rgx/QelqzglN+GR1esxDkGe+q0nK1zG1oewH0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GBOlvTm4OrIdU996PWcU0bv+FPM0gfriv5zONqrQ2u06rIqYHgbKc9hrKUqB2N6+7
	 oUV0d8/6Kvh7NPKAPdLToKrAQEw6XFFgbUxIyruXbD8v8zXKT+Fsb3mihxN3Pq7PzA
	 gHdTpmBX7wbVtRa0FSLxPu0WRMs1ni/pWLqhGU64=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Santosh Mahto <eisantosh95@gmail.com>,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 418/499] staging: gpib: Replace semaphore with completion for one-time signaling
Date: Tue,  8 Apr 2025 12:50:30 +0200
Message-ID: <20250408104901.651958759@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104851.256868745@linuxfoundation.org>
References: <20250408104851.256868745@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Santosh Mahto <eisantosh95@gmail.com>

[ Upstream commit 5d4db9cf4135d82634c7f31aac73081fba3a356e ]

Replaced 'down_interruptible()' and 'up()' calls
with 'wait_for_completion_interruptible()' and
'complete()' respectively. The completion API
simplifies the code and adheres to kernel best
practices for synchronization primitive

Signed-off-by: Santosh Mahto <eisantosh95@gmail.com>
Reviewed-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/20241212162112.13083-1-eisantosh95@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: a239c6e91b66 ("staging: gpib: Fix Oops after disconnect in ni_usb")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/staging/gpib/ni_usb/ni_usb_gpib.c | 16 ++++++++--------
 drivers/staging/gpib/ni_usb/ni_usb_gpib.h |  2 +-
 2 files changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
index b7b6fb1be3790..70b8b305e13b6 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.c
@@ -85,7 +85,7 @@ static void ni_usb_bulk_complete(struct urb *urb)
 
 //	printk("debug: %s: status=0x%x, error_count=%i, actual_length=%i\n",  __func__,
 //		urb->status, urb->error_count, urb->actual_length);
-	up(&context->complete);
+	complete(&context->complete);
 }
 
 static void ni_usb_timeout_handler(struct timer_list *t)
@@ -94,7 +94,7 @@ static void ni_usb_timeout_handler(struct timer_list *t)
 	struct ni_usb_urb_ctx *context = &ni_priv->context;
 
 	context->timed_out = 1;
-	up(&context->complete);
+	complete(&context->complete);
 };
 
 // I'm using nonblocking loosely here, it only means -EAGAIN can be returned in certain cases
@@ -124,7 +124,7 @@ static int ni_usb_nonblocking_send_bulk_msg(struct ni_usb_priv *ni_priv, void *d
 	}
 	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	out_pipe = usb_sndbulkpipe(usb_dev, ni_priv->bulk_out_endpoint);
-	sema_init(&context->complete, 0);
+	init_completion(&context->complete);
 	context->timed_out = 0;
 	usb_fill_bulk_urb(ni_priv->bulk_urb, usb_dev, out_pipe, data, data_length,
 			  &ni_usb_bulk_complete, context);
@@ -143,7 +143,7 @@ static int ni_usb_nonblocking_send_bulk_msg(struct ni_usb_priv *ni_priv, void *d
 		return retval;
 	}
 	mutex_unlock(&ni_priv->bulk_transfer_lock);
-	down(&context->complete);    // wait for ni_usb_bulk_complete
+	wait_for_completion(&context->complete);    // wait for ni_usb_bulk_complete
 	if (context->timed_out) {
 		usb_kill_urb(ni_priv->bulk_urb);
 		dev_err(&usb_dev->dev, "%s: killed urb due to timeout\n", __func__);
@@ -210,7 +210,7 @@ static int ni_usb_nonblocking_receive_bulk_msg(struct ni_usb_priv *ni_priv,
 	}
 	usb_dev = interface_to_usbdev(ni_priv->bus_interface);
 	in_pipe = usb_rcvbulkpipe(usb_dev, ni_priv->bulk_in_endpoint);
-	sema_init(&context->complete, 0);
+	init_completion(&context->complete);
 	context->timed_out = 0;
 	usb_fill_bulk_urb(ni_priv->bulk_urb, usb_dev, in_pipe, data, data_length,
 			  &ni_usb_bulk_complete, context);
@@ -231,7 +231,7 @@ static int ni_usb_nonblocking_receive_bulk_msg(struct ni_usb_priv *ni_priv,
 	}
 	mutex_unlock(&ni_priv->bulk_transfer_lock);
 	if (interruptible) {
-		if (down_interruptible(&context->complete)) {
+		if (wait_for_completion_interruptible(&context->complete)) {
 			/* If we got interrupted by a signal while
 			 * waiting for the usb gpib to respond, we
 			 * should send a stop command so it will
@@ -243,10 +243,10 @@ static int ni_usb_nonblocking_receive_bulk_msg(struct ni_usb_priv *ni_priv,
 			/* now do an uninterruptible wait, it shouldn't take long
 			 *	for the board to respond now.
 			 */
-			down(&context->complete);
+			wait_for_completion(&context->complete);
 		}
 	} else {
-		down(&context->complete);
+		wait_for_completion(&context->complete);
 	}
 	if (context->timed_out) {
 		usb_kill_urb(ni_priv->bulk_urb);
diff --git a/drivers/staging/gpib/ni_usb/ni_usb_gpib.h b/drivers/staging/gpib/ni_usb/ni_usb_gpib.h
index 9b21dfa0f3f6d..4b297db09a9bf 100644
--- a/drivers/staging/gpib/ni_usb/ni_usb_gpib.h
+++ b/drivers/staging/gpib/ni_usb/ni_usb_gpib.h
@@ -56,7 +56,7 @@ enum hs_plus_endpoint_addresses {
 };
 
 struct ni_usb_urb_ctx {
-	struct semaphore complete;
+	struct completion complete;
 	unsigned timed_out : 1;
 };
 
-- 
2.39.5



