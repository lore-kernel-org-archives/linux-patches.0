Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD8735C69C;
	Sat, 12 Sep 2026 19:23:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789241020; cv=none; b=dzrXtwOBDZK5iSla3rUaKY2u66/Ct9KiR5ttSHC9AVUDlg656Zccl0MBjKtA/KJ7vHZvys4lK8y3oxvMXuapc9khmA5iw6T4IBlUAuhZqCEo+E/fJEesFuzsmp63Chx+L6duOdf613ZuaFDMHtfx2rDd2myGvJ38xJUNR/f0BpA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789241020; c=relaxed/simple;
	bh=thH+zOz0RYeDwBtMFx7AESjCvtHkvjgKzTGSVzRI+ek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDyJWR2KOYvLexOTqHAt0DyOJTx8aZiGfrTzlGMO6arWMbfVKiWczvBszkfsCJJSfNJh4t89q+0ndRHIjkfrcB8sXzHtyQbuHErkYgrK8U326Qxt+4lFOJCPqcM63BXaRj0k9vv6tZML1IfeKm42mlJNyxel2EG+3lPil7+cxBY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ECbxWO1I; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ECbxWO1I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FC621F000FF;
	Sat, 12 Sep 2026 19:23:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789241019;
	bh=97YBEof0VgjvdJs6iMMbEjI6QEmXjbvk/MYggT7L7hU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ECbxWO1Is9uJNqt3RuSmwGJwfZyNNDmFU9TGwxJ2JtU7rZhSK6qA6pjfK7xTLrqje
	 0HPHsQKm7VqNQatdHxtS18gRoqpwebh3dErFNrhrXW5HrSoC19scFHeo7Jx1Km8o+o
	 B6WjAc+HdVcOQ8niUV3v7/iuNxXbbkaBSYnFGpAc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 5.10 013/798] Revert "media: v4l2-dev: fix error handling in __video_register_device()"
Date: Sat, 12 Sep 2026 08:54:01 +0200
Message-ID: <20260912065517.264807189@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065516.948645775@linuxfoundation.org>
References: <20260912065516.948645775@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hans Verkuil <hverkuil+cisco@kernel.org>

commit e7600f5cee5de14065f950807931d6e6d40fb2d7 upstream.

This reverts commit 2a934fdb01db6458288fc9386d3d8ceba6dd551a.

The intentions of that patch were good, but it doesn't work.

The idea is that if device_register fails, you have to do a put_device
to let the ref counter release resources.

However, the V4L2 API says that if video_register_device() fails, then
you have to call video_device_release(), which kfree()s the video_device
struct.

But the put_device() will already have freed the struct, so you end
up in a double-free scenario.

There is not really a good way of fixing this without breaking
video_register_device() into two parts, one that initializes everything,
and one that does the actual device_register, and then converting all
V4L2 drivers to this new model.

That is a massive job, and it is very unlikely that device_register
will fail.

So rather than ending up in a double-free scenario, just revert this
patch, and in that case we'll have a small memory leak. Which is a lot
more robust.

Reviewed-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
Fixes: 2a934fdb01db ("media: v4l2-dev: fix error handling in __video_register_device()")
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/linux-media/20260520090624.1071139-1-lgs201920130244@gmail.com/
Link: https://lore.kernel.org/all/2026042058-charm-storable-4ad8@gregkh/
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dev.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1029,25 +1029,25 @@ int __video_register_device(struct video
 	vdev->dev.class = &video_class;
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	vdev->dev.parent = vdev->dev_parent;
-	vdev->dev.release = v4l2_device_release;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
-
-	/* Increase v4l2_device refcount */
-	v4l2_device_get(vdev->v4l2_dev);
-
 	mutex_lock(&videodev_lock);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
 		mutex_unlock(&videodev_lock);
 		pr_err("%s: device_register failed\n", __func__);
-		put_device(&vdev->dev);
-		return ret;
+		goto cleanup;
 	}
+	/* Register the release callback that will be called when the last
+	   reference to the device goes away. */
+	vdev->dev.release = v4l2_device_release;
 
 	if (nr != -1 && nr != vdev->num && warn_if_nr_in_use)
 		pr_warn("%s: requested %s%d, got %s\n", __func__,
 			name_base, nr, video_device_node_name(vdev));
 
+	/* Increase v4l2_device refcount */
+	v4l2_device_get(vdev->v4l2_dev);
+
 	/* Part 5: Register the entity. */
 	ret = video_register_media_controller(vdev);
 


