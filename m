Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5ED7E1DDCE;
	Tue, 16 Jul 2024 16:06:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721145974; cv=none; b=AzfNCpSQKoDonw+2eCLG4LKTDbOHys9TnZGZcSj06mJ9iooHB+ZmFNJZttsvLKHlz83wilTy0M1taay+84N/e3nuqNPLkIcCfvq9/2t7i3oG1qgAPkY5ixuIRYOQXbtUovgwBqN78Hm4VHIpvQxShZ7+UjlK8VsHHeXKEjy1uJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721145974; c=relaxed/simple;
	bh=divymtBzc5R7TkWpv6k10EGJ9OW0kG9x5Fa2XmENvrQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pUWzrvMHynlxlGzsM0ZqIq/0Zrr6NFc5KyCTlu/ORVPlZLJKnxudCM6OVOf9TmXjsluatnkgmfGUJn+Ygn2f3tkpYuYAoPrFsX+e/7sjfG5ZS1+FCEWQj/1KMeyDN8QgrRubxrJvJez8HYpW+e9IAaSoxxlEhfVI/FF4RyEWilE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4raPy1M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4raPy1M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ABB4AC116B1;
	Tue, 16 Jul 2024 16:06:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721145974;
	bh=divymtBzc5R7TkWpv6k10EGJ9OW0kG9x5Fa2XmENvrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4raPy1MfgfYWub1WwjlKm7OqcI01Np31NuJ6Ina1qMeW7yQskGMzs1lP4qKYOcVa
	 1sYYZ8bMOlFsM8sJSrSzZZzrap/qDhIp3NYxggEYSH/zKYCdjuJNVCsRr8Fw0n8O2E
	 rNJdVMC2m+imekc+Kk/30nF8T9R4nnbgzM+yz/9M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ricardo Ribalda <ribalda@chromium.org>,
	Mauro Carvalho Chehab <mchehab@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 019/144] media: s2255: Use refcount_t instead of atomic_t for num_channels
Date: Tue, 16 Jul 2024 17:31:28 +0200
Message-ID: <20240716152753.273289913@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152752.524497140@linuxfoundation.org>
References: <20240716152752.524497140@linuxfoundation.org>
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

[ Upstream commit 6cff72f6bcee89228a662435b7c47e21a391c8d0 ]

Use an API that resembles more the actual use of num_channels.

Found by cocci:
drivers/media/usb/s2255/s2255drv.c:2362:5-24: WARNING: atomic_dec_and_test variation before object free at line 2363.
drivers/media/usb/s2255/s2255drv.c:1557:5-24: WARNING: atomic_dec_and_test variation before object free at line 1558.

Link: https://lore.kernel.org/linux-media/20240429-fix-cocci-v3-11-3c4865f5a4b0@chromium.org
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Signed-off-by: Mauro Carvalho Chehab <mchehab@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/s2255/s2255drv.c | 20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/media/usb/s2255/s2255drv.c b/drivers/media/usb/s2255/s2255drv.c
index acf18e2251a52..6c9870541c53d 100644
--- a/drivers/media/usb/s2255/s2255drv.c
+++ b/drivers/media/usb/s2255/s2255drv.c
@@ -247,7 +247,7 @@ struct s2255_vc {
 struct s2255_dev {
 	struct s2255_vc         vc[MAX_CHANNELS];
 	struct v4l2_device      v4l2_dev;
-	atomic_t                num_channels;
+	refcount_t		num_channels;
 	int			frames;
 	struct mutex		lock;	/* channels[].vdev.lock */
 	struct mutex		cmdlock; /* protects cmdbuf */
@@ -1550,11 +1550,11 @@ static void s2255_video_device_release(struct video_device *vdev)
 		container_of(vdev, struct s2255_vc, vdev);
 
 	dprintk(dev, 4, "%s, chnls: %d\n", __func__,
-		atomic_read(&dev->num_channels));
+		refcount_read(&dev->num_channels));
 
 	v4l2_ctrl_handler_free(&vc->hdl);
 
-	if (atomic_dec_and_test(&dev->num_channels))
+	if (refcount_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	return;
 }
@@ -1659,7 +1659,7 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 				"failed to register video device!\n");
 			break;
 		}
-		atomic_inc(&dev->num_channels);
+		refcount_inc(&dev->num_channels);
 		v4l2_info(&dev->v4l2_dev, "V4L2 device registered as %s\n",
 			  video_device_node_name(&vc->vdev));
 
@@ -1667,11 +1667,11 @@ static int s2255_probe_v4l(struct s2255_dev *dev)
 	pr_info("Sensoray 2255 V4L driver Revision: %s\n",
 		S2255_VERSION);
 	/* if no channels registered, return error and probe will fail*/
-	if (atomic_read(&dev->num_channels) == 0) {
+	if (refcount_read(&dev->num_channels) == 0) {
 		v4l2_device_unregister(&dev->v4l2_dev);
 		return ret;
 	}
-	if (atomic_read(&dev->num_channels) != MAX_CHANNELS)
+	if (refcount_read(&dev->num_channels) != MAX_CHANNELS)
 		pr_warn("s2255: Not all channels available.\n");
 	return 0;
 }
@@ -2220,7 +2220,7 @@ static int s2255_probe(struct usb_interface *interface,
 		goto errorFWDATA1;
 	}
 
-	atomic_set(&dev->num_channels, 0);
+	refcount_set(&dev->num_channels, 0);
 	dev->pid = id->idProduct;
 	dev->fw_data = kzalloc(sizeof(struct s2255_fw), GFP_KERNEL);
 	if (!dev->fw_data)
@@ -2340,12 +2340,12 @@ static void s2255_disconnect(struct usb_interface *interface)
 {
 	struct s2255_dev *dev = to_s2255_dev(usb_get_intfdata(interface));
 	int i;
-	int channels = atomic_read(&dev->num_channels);
+	int channels = refcount_read(&dev->num_channels);
 	mutex_lock(&dev->lock);
 	v4l2_device_disconnect(&dev->v4l2_dev);
 	mutex_unlock(&dev->lock);
 	/*see comments in the uvc_driver.c usb disconnect function */
-	atomic_inc(&dev->num_channels);
+	refcount_inc(&dev->num_channels);
 	/* unregister each video device. */
 	for (i = 0; i < channels; i++)
 		video_unregister_device(&dev->vc[i].vdev);
@@ -2358,7 +2358,7 @@ static void s2255_disconnect(struct usb_interface *interface)
 		dev->vc[i].vidstatus_ready = 1;
 		wake_up(&dev->vc[i].wait_vidstatus);
 	}
-	if (atomic_dec_and_test(&dev->num_channels))
+	if (refcount_dec_and_test(&dev->num_channels))
 		s2255_destroy(dev);
 	dev_info(&interface->dev, "%s\n", __func__);
 }
-- 
2.43.0



