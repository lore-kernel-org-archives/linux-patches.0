Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 34DD515442C;
	Thu,  3 Jul 2025 15:00:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751554809; cv=none; b=YUoDe65tV66nx85xdtcqdH6weL5Zmop+DoOv81y+mUWKSVGafE5K+zmFqXPd60Q2Rqut8TGFCnWtxzPLuTv6MkB7qe8bwmTFFOpEDIvo4Sg+AKO2+yATYLX6Sg+dcsvAFBAxrqNarqVmWG+8sjMRtukDPLXKMO9NslEOD4epwVw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751554809; c=relaxed/simple;
	bh=ZcXkUUcuLa1FkWtBb+W9Vs/KeP/svbp0coBaIuolI0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q3OhXCVUyoYq0H/nF5RlNnvG/CNnAS1R8hk0QCiNvv7Tm20TdEE5tGFm5/hefnRTWMRARrLer3s5dfMp9riEk1w2cvi53SZ75DlbJF4GkRheIZ5CTdm/Yg+QCQJ/hzR6ywgasLEgnfHBXDbkfI2XX6haeI1eBfaM0rIAzo8fj/w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=att/DdX1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="att/DdX1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98F2CC4CEE3;
	Thu,  3 Jul 2025 15:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751554809;
	bh=ZcXkUUcuLa1FkWtBb+W9Vs/KeP/svbp0coBaIuolI0A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=att/DdX1NNOYElz8tUHKgpryllKjv7lENsNH8pEsqclsIhLGEunKCurIuoKNZhSpP
	 Wz0eyuSaVCY7p2hr455tl1+e9hXl2NOKKJGP3mUnoQkG8nIOFdpC6/j/W99JVIDM6l
	 qmWKQ0CcmA9W9jTogwHr3Lhw7zVjcqfg3E51bK4s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Ricardo Ribalda <ribalda@chromium.org>,
	Hans Verkuil <hverkuil@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 085/263] media: uvcvideo: Create uvc_pm_(get|put) functions
Date: Thu,  3 Jul 2025 16:40:05 +0200
Message-ID: <20250703144007.712146932@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250703144004.276210867@linuxfoundation.org>
References: <20250703144004.276210867@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ricardo Ribalda <ribalda@chromium.org>

[ Upstream commit 2f101572c0a3ae4630f2a57c8033b78ee84ac5a6 ]

Most of the times that we have to call uvc_status_(get|put) we need to
call the usb_autopm_ functions.

Create a new pair of functions that automate this for us. This
simplifies the current code and future PM changes in the driver.

Reviewed-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Ricardo Ribalda <ribalda@chromium.org>
Message-ID: <20250327-uvc-granpower-ng-v6-2-35a2357ff348@chromium.org>
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Stable-dep-of: a70705d3c020 ("media: uvcvideo: Rollback non processed entities on error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/usb/uvc/uvc_v4l2.c | 36 +++++++++++++++++++++-----------
 drivers/media/usb/uvc/uvcvideo.h |  4 ++++
 2 files changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/media/usb/uvc/uvc_v4l2.c b/drivers/media/usb/uvc/uvc_v4l2.c
index 22886b47d81c2..1d5be045d04ec 100644
--- a/drivers/media/usb/uvc/uvc_v4l2.c
+++ b/drivers/media/usb/uvc/uvc_v4l2.c
@@ -26,6 +26,27 @@
 
 #include "uvcvideo.h"
 
+int uvc_pm_get(struct uvc_device *dev)
+{
+	int ret;
+
+	ret = usb_autopm_get_interface(dev->intf);
+	if (ret)
+		return ret;
+
+	ret = uvc_status_get(dev);
+	if (ret)
+		usb_autopm_put_interface(dev->intf);
+
+	return ret;
+}
+
+void uvc_pm_put(struct uvc_device *dev)
+{
+	uvc_status_put(dev);
+	usb_autopm_put_interface(dev->intf);
+}
+
 static int uvc_acquire_privileges(struct uvc_fh *handle);
 
 static int uvc_control_add_xu_mapping(struct uvc_video_chain *chain,
@@ -642,20 +663,13 @@ static int uvc_v4l2_open(struct file *file)
 	stream = video_drvdata(file);
 	uvc_dbg(stream->dev, CALLS, "%s\n", __func__);
 
-	ret = usb_autopm_get_interface(stream->dev->intf);
-	if (ret < 0)
-		return ret;
-
 	/* Create the device handle. */
 	handle = kzalloc(sizeof(*handle), GFP_KERNEL);
-	if (handle == NULL) {
-		usb_autopm_put_interface(stream->dev->intf);
+	if (!handle)
 		return -ENOMEM;
-	}
 
-	ret = uvc_status_get(stream->dev);
+	ret = uvc_pm_get(stream->dev);
 	if (ret) {
-		usb_autopm_put_interface(stream->dev->intf);
 		kfree(handle);
 		return ret;
 	}
@@ -690,9 +704,7 @@ static int uvc_v4l2_release(struct file *file)
 	kfree(handle);
 	file->private_data = NULL;
 
-	uvc_status_put(stream->dev);
-
-	usb_autopm_put_interface(stream->dev->intf);
+	uvc_pm_put(stream->dev);
 	return 0;
 }
 
diff --git a/drivers/media/usb/uvc/uvcvideo.h b/drivers/media/usb/uvc/uvcvideo.h
index 5ceb01e7831a8..b9f8eb62ba1d8 100644
--- a/drivers/media/usb/uvc/uvcvideo.h
+++ b/drivers/media/usb/uvc/uvcvideo.h
@@ -768,6 +768,10 @@ void uvc_status_suspend(struct uvc_device *dev);
 int uvc_status_get(struct uvc_device *dev);
 void uvc_status_put(struct uvc_device *dev);
 
+/* PM */
+int uvc_pm_get(struct uvc_device *dev);
+void uvc_pm_put(struct uvc_device *dev);
+
 /* Controls */
 extern const struct v4l2_subscribed_event_ops uvc_ctrl_sub_ev_ops;
 
-- 
2.39.5



