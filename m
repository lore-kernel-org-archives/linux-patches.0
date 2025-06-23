Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 946681ACEDA;
	Mon, 23 Jun 2025 21:08:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750712903; cv=none; b=IluSVRM1tAKH5OBkLgCjzAe4MAmParLRxsBp7XX7jI6wWodLJQSxzH+9jIb/cHp5HRKwrloLElspLYUz9uFbbwa2LQTLI8Wm95i3gXHFDLtCzDWeTj+oTQw34nKuGZ6d2Dv5lHiG88gZ1LfWDsMbKZPDj6c29sOrTO0J1ZaTBKE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750712903; c=relaxed/simple;
	bh=/gFPscZ6lrITXzuNOrDbnto73c7R6psSMZkBVcrlQUo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kRoZYwFMr/wpoWOCHoUTDuK+8535SfUyRH/0sEccBbeVWVt3uY972EzMQM+iw6NpjNL68nuJX8ZNKoh39juS8Xc2bljWbscpey53ni6W7rvjD2RiuYOg3M3wJCf9qfTQXnmv4niiTdv/YFrq354hkTqOqZJMOQJvCFSBRHN2sjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OP6yNfF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OP6yNfF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2B388C4CEEA;
	Mon, 23 Jun 2025 21:08:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750712903;
	bh=/gFPscZ6lrITXzuNOrDbnto73c7R6psSMZkBVcrlQUo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OP6yNfF6WZlPlsksBEBrkUAd9s0hGJcF1JA91V2oaT4EpncSjdUJ3crsr7DPDqxZ+
	 jtJsqOzFPyDfq+c371a3n0z4VUZnUKKLT06mmcuYCbGjZ/JsPiXvBJavRcZ2L9CXG1
	 qUVeq0SNXqUTAMGmidec5sho5SCKTAky7YqPEjVQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.6 037/290] media: v4l2-dev: fix error handling in __video_register_device()
Date: Mon, 23 Jun 2025 15:04:58 +0200
Message-ID: <20250623130628.113358789@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130626.910356556@linuxfoundation.org>
References: <20250623130626.910356556@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ma Ke <make24@iscas.ac.cn>

commit 2a934fdb01db6458288fc9386d3d8ceba6dd551a upstream.

Once device_register() failed, we should call put_device() to
decrement reference count for cleanup. Or it could cause memory leak.
And move callback function v4l2_device_release() and v4l2_device_get()
before put_device().

As comment of device_register() says, 'NOTE: _Never_ directly free
@dev after calling this function, even if it returned an error! Always
use put_device() to give up the reference initialized in this function
instead.'

Found by code review.

Cc: stable@vger.kernel.org
Fixes: dc93a70cc7f9 ("V4L/DVB (9973): v4l2-dev: use the release callback from device instead of cdev")
Signed-off-by: Ma Ke <make24@iscas.ac.cn>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1033,25 +1033,25 @@ int __video_register_device(struct video
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	vdev->dev.parent = vdev->dev_parent;
+	vdev->dev.release = v4l2_device_release;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
+
+	/* Increase v4l2_device refcount */
+	v4l2_device_get(vdev->v4l2_dev);
+
 	mutex_lock(&videodev_lock);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
 		mutex_unlock(&videodev_lock);
 		pr_err("%s: device_register failed\n", __func__);
-		goto cleanup;
+		put_device(&vdev->dev);
+		return ret;
 	}
-	/* Register the release callback that will be called when the last
-	   reference to the device goes away. */
-	vdev->dev.release = v4l2_device_release;
 
 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
 		pr_warn("%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
-	/* Increase v4l2_device refcount */
-	v4l2_device_get(vdev->v4l2_dev);
-
 	/* Part 5: Register the entity. */
 	ret = video_register_media_controller(vdev);
 


