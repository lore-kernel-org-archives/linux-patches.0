Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 263783290A5;
	Fri, 24 Apr 2026 13:40:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038017; cv=none; b=NV1uIhEqaFTG+34NXoRsWucd/uEVq4Ejak/MoIb196H1NbfSgA10xtjJCszZfub+PFLZLx/4jebCbGCthSP50HVLhgt32nUCy8D0p8ZUcb/F9F6xo2kL/uuf7hxHFlFYBApfHKcovG05Ne9HhYLJutyJ7R6POQh0FA7YUJYx8Oc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038017; c=relaxed/simple;
	bh=bOz/VhuK035iHa0u2GB1fmH3Yfq+XF/vHlD7ikpWyag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jvGAHaZFIR0Rb4otV4qb9k4EvkdGNtxi0VQX1Orw03Ij7+syAm6IRuHaXLiXen0jd2nRg6ZpK8xBZ0CshyzFdqQeDnomjI71eg2CmYpZkW1UPwSL5wi5Tf+b7LNMb1+iLbwBS0mseskh27dPylMF/M9qxDXf3tt05gROJau/Ays=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IVIb/qz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IVIb/qz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1CC6C19425;
	Fri, 24 Apr 2026 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038017;
	bh=bOz/VhuK035iHa0u2GB1fmH3Yfq+XF/vHlD7ikpWyag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IVIb/qz3Y9AnHwwdu8uIM1U4dUR842gbVCKauxi9GYIuO0jdnxzPEtugz/yQ9ivgR
	 MKmE1pAW08EE2bbEXvSeuMIZnOEatR71XnP5h34lDz1iF1n/hhN8peTpXL2JVcpj8c
	 3+ZLUKn4ZRD7GQb6OwsZqH9s3SSdfZClHEuIcUQM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+6ffd76b5405c006a46b7@syzkaller.appspotmail.com,
	syzbot+f1b20958f93d2d250727@syzkaller.appspotmail.com,
	Jeongjun Park <aha310510@gmail.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 6.6 125/166] media: hackrf: fix to not free memory after the device is registered in hackrf_probe()
Date: Fri, 24 Apr 2026 15:30:39 +0200
Message-ID: <20260424132559.037823021@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132532.812258529@linuxfoundation.org>
References: <20260424132532.812258529@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jeongjun Park <aha310510@gmail.com>

commit 3b7da2b4d0fe014eff181ed37e3bf832eb8ed258 upstream.

In hackrf driver, the following race condition occurs:
```
		CPU0						CPU1
hackrf_probe()
  kzalloc(); // alloc hackrf_dev
  ....
  v4l2_device_register();
  ....
						fd = sys_open("/path/to/dev"); // open hackrf fd
						....
  v4l2_device_unregister();
  ....
  kfree(); // free hackrf_dev
  ....
						sys_ioctl(fd, ...);
						  v4l2_ioctl();
						    video_is_registered() // UAF!!
						....
						sys_close(fd);
						  v4l2_release() // UAF!!
						    hackrf_video_release()
						      kfree(); // DFB!!
```

When a V4L2 or video device is unregistered, the device node is removed so
new open() calls are blocked.

However, file descriptors that are already open-and any in-flight I/O-do
not terminate immediately; they remain valid until the last reference is
dropped and the driver's release() is invoked.

Therefore, freeing device memory on the error path after hackrf_probe()
has registered dev it will lead to a race to use-after-free vuln, since
those already-open handles haven't been released yet.

And since release() free memory too, race to use-after-free and
double-free vuln occur.

To prevent this, if device is registered from probe(), it should be
modified to free memory only through release() rather than calling
kfree() directly.

Cc: <stable@vger.kernel.org>
Reported-by: syzbot+6ffd76b5405c006a46b7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=6ffd76b5405c006a46b7
Reported-by: syzbot+f1b20958f93d2d250727@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f1b20958f93d2d250727
Fixes: 8bc4a9ed8504 ("[media] hackrf: add support for transmitter")
Signed-off-by: Jeongjun Park <aha310510@gmail.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/hackrf/hackrf.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/media/usb/hackrf/hackrf.c
+++ b/drivers/media/usb/hackrf/hackrf.c
@@ -1485,7 +1485,7 @@ static int hackrf_probe(struct usb_inter
 	if (ret) {
 		dev_err(dev->dev,
 			"Failed to register as video device (%d)\n", ret);
-		goto err_v4l2_device_unregister;
+		goto err_v4l2_device_put;
 	}
 	dev_info(dev->dev, "Registered as %s\n",
 		 video_device_node_name(&dev->rx_vdev));
@@ -1514,8 +1514,9 @@ static int hackrf_probe(struct usb_inter
 	return 0;
 err_video_unregister_device_rx:
 	video_unregister_device(&dev->rx_vdev);
-err_v4l2_device_unregister:
-	v4l2_device_unregister(&dev->v4l2_dev);
+err_v4l2_device_put:
+	v4l2_device_put(&dev->v4l2_dev);
+	return ret;
 err_v4l2_ctrl_handler_free_tx:
 	v4l2_ctrl_handler_free(&dev->tx_ctrl_handler);
 err_v4l2_ctrl_handler_free_rx:


