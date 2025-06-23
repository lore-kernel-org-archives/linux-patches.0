Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CBB30223DEE;
	Mon, 23 Jun 2025 22:10:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750716622; cv=none; b=U3rVpy/ec4L95xnUv2H1qKBTANgK/+05cFWZt0IAhC8oQlL5NNfbD2/WL8VVrtv2D9RCu1v90Cj3PHMpyt/JiL+CkQbk4DyEoc2Gjg+Yr97aa6WtNmdxa1VEVVQMs2kbcM5F568DYMD8D3zZMP7Sh5uhBKmSNVkcTrNmlsy1sYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750716622; c=relaxed/simple;
	bh=al0t6YL8E1BewrliYbWwoQ6bq68Zzhk4XlISVORaclM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GMVGVKKEKVJLZ86xiWDpe5UOFWx/+CV89KXRMYevjVKFlZCIBzDOQhxEF9OkOY8Wn30MGNNzmQ/5P70H/tCX4jUkE0ZkZSk78T2GdNmaotMxkwUSe/rvMwKbtuQALoBSuw5LMWsxiWiT6sWCWPvvqLoid+YWBxzztCqE6GRK+Jk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TarGmooM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TarGmooM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62F79C4CEED;
	Mon, 23 Jun 2025 22:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750716622;
	bh=al0t6YL8E1BewrliYbWwoQ6bq68Zzhk4XlISVORaclM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TarGmooMiXejz55woo/kD350ub6CPGlcQdi4wek0fBxRuRYzAS50vtecS0/H0lMst
	 98AVJ3TooIg0qFqq+a9ntPHbyWHYYi50f+qso31EWploEcj4IYm1Mh0Bx3Sw7gaZ+l
	 uUMGpm5dVmRWoFD85PWQbkyyLZ1n20Exm/eze3Hk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ma Ke <make24@iscas.ac.cn>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.1 316/508] media: v4l2-dev: fix error handling in __video_register_device()
Date: Mon, 23 Jun 2025 15:06:01 +0200
Message-ID: <20250623130653.098248716@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 


