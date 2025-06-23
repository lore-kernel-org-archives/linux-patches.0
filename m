Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F2E1EE7C6;
	Mon, 23 Jun 2025 21:34:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714497; cv=none; b=o8WiXJ4st8aT62UAPaa60MMlDS4nx3mSyyJbcY5kyxJXuUvbr9vYsZQeTEkQn5xPklpsx15EYZRWcLEtsFJbuhTqrjDKoC8zQYlIzbIKP+RX5GrzxcqG4aIUmRBNkuNWWYVQk94PRMCQ4bml37HEhSnXKM2LfvvYq5a3Z7x/sl8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714497; c=relaxed/simple;
	bh=y0baPU/lU8cF33AExgyS14LyXL27I8F6l96tx5XKKsQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FidaaIVoqzQR1ZaeE78EPr7y0dNIAnJXh7KfwQYQjcLCRVhGdzV0oZz+eRMj3X2a4S073uzPF6z0GvpXk1Y9p+J+cZm3Rrq0/qE08jjtE3XE3F/0Zn3XSbdA2ThraU8UaMQRIi+k1HVmP1tjSVaHlsPDyLRef1YgEWMej7o01/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=E5PwGb5X; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="E5PwGb5X"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3215C4CEEA;
	Mon, 23 Jun 2025 21:34:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714497;
	bh=y0baPU/lU8cF33AExgyS14LyXL27I8F6l96tx5XKKsQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E5PwGb5XHYmJ0Fg2919/tw9V7n4LTttEwXEFeUiqb/rYfA5XXlf8V4kn325OC0z2v
	 zDP9T1pqFoZHLwwi/4ybnOlwF/w6+eFyvJdqxmglGTJ0Aiy8Dx03w5IO869RhqftSd
	 Dosw8zjt57LxIuIvZXd7VNFhbfZSQarSOcEMxn1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 5.15 212/411] media: v4l2-dev: fix error handling in __video_register_device()
Date: Mon, 23 Jun 2025 15:05:56 +0200
Message-ID: <20250623130639.006795561@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1032,25 +1032,25 @@ int __video_register_device(struct video
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
 


