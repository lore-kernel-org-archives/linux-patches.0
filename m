Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B04FA2253F2;
	Thu, 12 Dec 2024 16:41:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734021665; cv=none; b=H5M/CFgpc538WOd0HSC9P1fjdZbGPHrTGbCMT73+CWK+5s5kpLH/9fCRVH9HuFX5boT7F5Y0DZr0rZuMpMPSRoJaCb6zsnv56LZtqsBdNe/xWDWxVa/ua0i7slmf7Jll1FDd7hm5VrBqq6L+WXA9d1z5yUWHis6su8oIgCSJK2A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734021665; c=relaxed/simple;
	bh=f31i87D2h87JUEB6VnAOX+4Iv+7Ksq1bR/8YNoxnq+M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GI4QTRjPqtyxdSENmm9GgKOLg3LRQEGectl9E3ZzzkxwLFnHTWE70akpddfGdT7xuPSs9jXlpJqkm3PUvEXyvo7QR4UmJX7bWZPx/2vYXjKXlnEKj4y3YRZ88koEAEtt/UHd28G5ZGV+8V+b5XjYZ1bdYD/53IVqSZF+5sglWuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F0MGzEc1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F0MGzEc1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005F8C4CECE;
	Thu, 12 Dec 2024 16:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734021665;
	bh=f31i87D2h87JUEB6VnAOX+4Iv+7Ksq1bR/8YNoxnq+M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F0MGzEc1ZulqgpPZqCzKmLh7LQfUSDmIPp4enH4zw2j1zicAfdEmmSg6J2ajijFSo
	 D8dKRVtJT/6ttasKzt/mril8E+lDjRpRReW5qMKhl7aqv2MViT9uadk8iw4UkZ1yef
	 nDZCWC3nIziBz+JtPFqqpbF8L6JXjwkzekE/IAeM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Subject: [PATCH 5.15 009/565] media: uvcvideo: Stop stream during unregister
Date: Thu, 12 Dec 2024 15:53:24 +0100
Message-ID: <20241212144311.815369266@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

commit c9ec6f1736363b2b2bb4e266997389740f628441 upstream.

uvc_unregister_video() can be called asynchronously from
uvc_disconnect(). If the device is still streaming when that happens, a
plethora of race conditions can occur.

Make sure that the device has stopped streaming before exiting this
function.

If the user still holds handles to the driver's file descriptors, any
ioctl will return -ENODEV from the v4l2 core.

This change makes uvc more consistent with the rest of the v4l2 drivers
using the vb2_fop_* and vb2_ioctl_* helpers.

This driver (and many other usb drivers) always had this problem, but it
wasn't possible to easily fix this until the vb2_video_unregister_device()
helper was added. So the Fixes tag points to the creation of that helper.

Reviewed-by: Hans Verkuil <hverkuil@xs4all.nl>
Suggested-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Reviewed-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Fixes: f729ef5796d8 ("media: videobuf2-v4l2.c: add vb2_video_unregister_device helper function")
Cc: stable@vger.kernel.org # 5.10.x
[hverkuil: add note regarding Fixes version]
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/usb/uvc/uvc_driver.c |   32 +++++++++++++++++++++++++++++++-
 1 file changed, 31 insertions(+), 1 deletion(-)

--- a/drivers/media/usb/uvc/uvc_driver.c
+++ b/drivers/media/usb/uvc/uvc_driver.c
@@ -2153,11 +2153,41 @@ static void uvc_unregister_video(struct
 	struct uvc_streaming *stream;
 
 	list_for_each_entry(stream, &dev->streams, list) {
+		/* Nothing to do here, continue. */
 		if (!video_is_registered(&stream->vdev))
 			continue;
 
+		/*
+		 * For stream->vdev we follow the same logic as:
+		 * vb2_video_unregister_device().
+		 */
+
+		/* 1. Take a reference to vdev */
+		get_device(&stream->vdev.dev);
+
+		/* 2. Ensure that no new ioctls can be called. */
 		video_unregister_device(&stream->vdev);
-		video_unregister_device(&stream->meta.vdev);
+
+		/* 3. Wait for old ioctls to finish. */
+		mutex_lock(&stream->mutex);
+
+		/* 4. Stop streaming. */
+		uvc_queue_release(&stream->queue);
+
+		mutex_unlock(&stream->mutex);
+
+		put_device(&stream->vdev.dev);
+
+		/*
+		 * For stream->meta.vdev we can directly call:
+		 * vb2_video_unregister_device().
+		 */
+		vb2_video_unregister_device(&stream->meta.vdev);
+
+		/*
+		 * Now both vdevs are not streaming and all the ioctls will
+		 * return -ENODEV.
+		 */
 
 		uvc_debugfs_cleanup_stream(stream);
 	}


