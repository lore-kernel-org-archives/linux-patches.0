Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 808AE3B47E3;
	Tue, 21 Jul 2026 22:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784672249; cv=none; b=F2MDsKbe8/7Q5Cn/TW4i8uEKNF6LUeNKmtmroGgMFVDxuf64Yu7kY1PDzAhUMMc7HLvzB5TEn8Vk+H72+JzERfqt6l0kq9ePSjsdMltxnVTh2OqINFLP07hkA8/ckvlGSmJmQfKMyjbyu6xhQHfTeWbtknhh7IZV5z1j3lR8L3o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784672249; c=relaxed/simple;
	bh=3oqakKaw6V+fW0kNMFRObwElPgzBRBmLSQlG3VCMqk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=C87IDQZXMgo+w3RiR5EHjOLR66IhMarrfbGkrBZcGvyQu8P8OCkw6gGJVBf60BiThW2DmxTj+9hrYb1MO8XlmNdtz8vLLAWVp6Er/juTze3oxhTxVryaWXXKmgfq/IqhbQiNNN0hhapq+92tNAxkIz26qr1GMUF3uAx5GsNojwA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mbswq+Zn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mbswq+Zn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E17C61F000E9;
	Tue, 21 Jul 2026 22:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784672248;
	bh=MQZBG6kt8bWxvlucey3mURKBuFdvv3aU5z5C/1HXNwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mbswq+Znr82gLo7ldlodMgGqC0AiOYJsW5rgyIUvC6bDpMLF5H+WjGbNLtN7kfP/y
	 xoSexaVUQT9w9WZ2p4ONBFzF8/vnuIMHqTyNHMJWXYWcnrEGBQIubDF7/hS/thywAP
	 3RmKTeNEaNhmBz6eoUR56c7RAlc/VnxucbMkwbAQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Tianci <zhangtianci.1997@bytedance.com>,
	Xie Yongji <xieyongji@bytedance.com>,
	Jason Wang <jasowang@redhat.com>,
	=?UTF-8?q?Eugenio=20P=C3=A9rez?= <eperezma@redhat.com>,
	"Michael S. Tsirkin" <mst@redhat.com>
Subject: [PATCH 5.15 554/843] vduse: Fix race in vduse_dev_msg_sync and vduse_dev_read_iter
Date: Tue, 21 Jul 2026 17:23:09 +0200
Message-ID: <20260721152418.511519367@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152405.946368001@linuxfoundation.org>
References: <20260721152405.946368001@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhang Tianci <zhangtianci.1997@bytedance.com>

commit ae9c13b6fd79087cc5a216ee1649b6f012c2a238 upstream.

There is one race case in vduse_dev_msg_sync and vduse_dev_read_iter:

vduse_dev_read_iter():
    lock(msg_lock);
    dequeue_msg(send_list);
    unlock(msg_lock);
vduse_dev_msg_sync():
    wait_timeout() finish
    lock(msg_lock);
    check msg->complete is false
        list_del(msg);   <- double list_del() crash!

To fix this case, we shall ensure vduse_msg is on send_list or recv_list
outside the msg_lock critical section.

Fixes: c8a6153b6c59 ("vduse: Introduce VDUSE - vDPA Device in Userspace")
Cc: stable@vger.kernel.org
Signed-off-by: Zhang Tianci <zhangtianci.1997@bytedance.com>
Reviewed-by: Xie Yongji <xieyongji@bytedance.com>
Acked-by: Jason Wang <jasowang@redhat.com>
Acked-by: Eugenio Pérez <eperezma@redhat.com>
Acked-by: Michael S. Tsirkin <mst@redhat.com>
Signed-off-by: Michael S. Tsirkin <mst@redhat.com>
Message-ID: <20260226115550.1814-3-zhangtianci.1997@bytedance.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/vdpa/vdpa_user/vduse_dev.c |   37 +++++++++++++++++++++++++++----------
 1 file changed, 27 insertions(+), 10 deletions(-)

--- a/drivers/vdpa/vdpa_user/vduse_dev.c
+++ b/drivers/vdpa/vdpa_user/vduse_dev.c
@@ -308,6 +308,7 @@ static ssize_t vduse_dev_read_iter(struc
 	struct file *file = iocb->ki_filp;
 	struct vduse_dev *dev = file->private_data;
 	struct vduse_dev_msg *msg;
+	struct vduse_dev_request req;
 	int size = sizeof(struct vduse_dev_request);
 	ssize_t ret;
 
@@ -319,12 +320,11 @@ static ssize_t vduse_dev_read_iter(struc
 		msg = vduse_dequeue_msg(&dev->send_list);
 		if (msg)
 			break;
+		spin_unlock(&dev->msg_lock);
 
-		ret = -EAGAIN;
 		if (file->f_flags & O_NONBLOCK)
-			goto unlock;
+			return -EAGAIN;
 
-		spin_unlock(&dev->msg_lock);
 		ret = wait_event_interruptible_exclusive(dev->waitq,
 					!list_empty(&dev->send_list));
 		if (ret)
@@ -332,17 +332,34 @@ static ssize_t vduse_dev_read_iter(struc
 
 		spin_lock(&dev->msg_lock);
 	}
+
+	memcpy(&req, &msg->req, sizeof(req));
+	/*
+	 * We must ensure vduse_msg is on send_list or recv_list before unlock
+	 * dev->msg_lock. Because vduse_dev_msg_sync() may be timeout when we
+	 * copy data to userspace, and will call list_del() for this msg.
+	 */
+	vduse_enqueue_msg(&dev->recv_list, msg);
 	spin_unlock(&dev->msg_lock);
-	ret = copy_to_iter(&msg->req, size, to);
-	spin_lock(&dev->msg_lock);
+
+	ret = copy_to_iter(&req, size, to);
 	if (ret != size) {
+		/*
+		 * Roll back: move msg back to send_list if still pending.
+		 *
+		 * NOTE:
+		 * vduse_find_msg() must use req.request_id instead of `msg`.
+		 * A malicious userspace may reply to this request, and wake up
+		 * the caller, after which `msg` will have already been freed.
+		 * And here vduse_find_msg() will return NULL then do nothing.
+		 */
+		spin_lock(&dev->msg_lock);
+		msg = vduse_find_msg(&dev->recv_list, req.request_id);
+		if (msg)
+			vduse_enqueue_msg_head(&dev->send_list, msg);
+		spin_unlock(&dev->msg_lock);
 		ret = -EFAULT;
-		vduse_enqueue_msg_head(&dev->send_list, msg);
-		goto unlock;
 	}
-	vduse_enqueue_msg(&dev->recv_list, msg);
-unlock:
-	spin_unlock(&dev->msg_lock);
 
 	return ret;
 }


