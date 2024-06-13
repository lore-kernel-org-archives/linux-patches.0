Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 666D01448F2;
	Thu, 13 Jun 2024 12:08:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718280500; cv=none; b=BH6BBzvX9QPk1ZAqRiiQehSxT18IKnp6n/vyH52TFYKvOpAtfK05nCia3LxGAqJjHMrrXKMxfvrSmm5nJY50Mbc+tIMtpDQP7dEjV7m5qzf0CCBOAVavAJO2t9n/apqnebYSQUGoxNprbF5knpKP6gmy8BzC/zYFSUK+hRWgGPA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718280500; c=relaxed/simple;
	bh=2EBqkgkJQNZ19KocOdWX47LjYHK+5CbpR8g6gwsAOk8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZTITzxcSMjfK8q2N30Th2M7P92DmU/pHW6pnJn2aWJ+3FhwyVUihjm0oJIOwsso8Gw2kYO3EWp51qcG2BCn54YCDx+tWMBy34DHClEfVPld5Acb/LgNhUd9LBi+jeUrvtwK5HmvqxEuEJhq3Jj+CgK0DulXfXr9nPhBtiwnO3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Wh++jGw6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Wh++jGw6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2ECBC2BBFC;
	Thu, 13 Jun 2024 12:08:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718280500;
	bh=2EBqkgkJQNZ19KocOdWX47LjYHK+5CbpR8g6gwsAOk8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Wh++jGw6YN14ujPSQMelbsua1dJVxLA7cO6273XpYkl7HzZTSeMQmBRZ47Y+owueY
	 SRQujgcJwGQptatfJJc9gtzhown54iP7uofXiRK/1kDyOCsq5SfuXXYbhT7QrKKtzI
	 VksAYFK2RIfK+idXyCtFHTc9dX30R1oT1xwjw0qo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sakari Ailus <sakari.ailus@linux.intel.com>
Subject: [PATCH 6.6 043/137] media: v4l2-core: hold videodev_lock until dev reg, finishes
Date: Thu, 13 Jun 2024 13:33:43 +0200
Message-ID: <20240613113224.960321193@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240613113223.281378087@linuxfoundation.org>
References: <20240613113223.281378087@linuxfoundation.org>
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

From: Hans Verkuil <hverkuil-cisco@xs4all.nl>

commit 1ed4477f2ea4743e7c5e1f9f3722152d14e6eeb1 upstream.

After the new V4L2 device node was registered, some additional
initialization was done before the device node was marked as
'registered'. During the time between creating the device node
and marking it as 'registered' it was possible to open the
device node, which would return -ENODEV since the 'registered'
flag was not yet set.

Hold the videodev_lock mutex from just before the device node
is registered until the 'registered' flag is set. Since v4l2_open
will take the same lock, it will wait until this registration
process is finished. This resolves this race condition.

Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Reviewed-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Cc: <stable@vger.kernel.org>      # for vi4.18 and up
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/v4l2-core/v4l2-dev.c |    3 +++
 1 file changed, 3 insertions(+)

--- a/drivers/media/v4l2-core/v4l2-dev.c
+++ b/drivers/media/v4l2-core/v4l2-dev.c
@@ -1034,8 +1034,10 @@ int __video_register_device(struct video
 	vdev->dev.devt = MKDEV(VIDEO_MAJOR, vdev->minor);
 	vdev->dev.parent = vdev->dev_parent;
 	dev_set_name(&vdev->dev, "%s%d", name_base, vdev->num);
+	mutex_lock(&videodev_lock);
 	ret = device_register(&vdev->dev);
 	if (ret < 0) {
+		mutex_unlock(&videodev_lock);
 		pr_err("%s: device_register failed\n", __func__);
 		goto cleanup;
 	}
@@ -1055,6 +1057,7 @@ int __video_register_device(struct video
 
 	/* Part 6: Activate this minor. The char device can now be used. */
 	set_bit(V4L2_FL_REGISTERED, &vdev->flags);
+	mutex_unlock(&videodev_lock);
 
 	return 0;
 


