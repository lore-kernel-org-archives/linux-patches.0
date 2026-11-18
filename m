Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795046642;
	b=bzLq4fknZpSQPtMIlokIGpcHWVAIqoNAq+8DsDzi3qIIATa5ajtKswoLaOA5IPGkc4f2
	 NygfJ6SfK94Ybq2hcFLzw7zriJxZQZ8zKXdvSWUtTo/mYR8z2FjohyHyamRLMi1KewjTX
	 C1/mCEDjh2LahUUJVjmRuH4JfGRPb3YloDen7wm0gO0fRLtMul3XnYjcghZ/dizwWGTdD
	 u4/UmVbBe4Dyiv+QnkE6fMVKWB9OtZ73gC0+MXiQOKvUZuUFCpvSy10TnSYeQ2QhHeVSi
	 tuZCmkDq//8bPwuBiVYTcuzjzrUqPqWljmFDe9O59al+BuhO+/mwB8F7bWYh03M+NAQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795046642;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=yoS8J/Muoik7FeOzI1f/H970B08jIuG70tv49jq2Elw=;
	b=hi2vgJNuMlC0po2dY//Ofnw57jGBRM3c/zUN3zxJBjOu9zK+I+BKnPnFEm1lTyJyifgH
	 mntjtpLi0saw9tRFFebRPOr7mqgpjWbacnFjKnWVVLju9nYC+Z2QYHX+WSHQ49c4kp4Ic
	 h1hvXE/0DCOYKfkE84VXL6cTG3U9WX9sHKX55cygioh/a1GetvXd2ReNSG97FVDnMwvua
	 n0fL6gmdOCUworv+9FnnBb7+0lWMA6HSxBheXIhFYRpVofNbHQ/aHp7tY19xaJ2jiyhtM
	 t0Z9YMHqbQ5u5+TAd4KOM0Q+6OIYcgw3u2ceiHWiMc/OBJeiqEWiHsYk3JTinFJz1fA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbhHuXFZ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 289D1606A320;
	Thu, 19 Nov 2026 00:04:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tbhHuXFZ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 816A51F000C4;
	Thu, 19 Nov 2026 00:04:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795046642;
	bh=yoS8J/Muoik7FeOzI1f/H970B08jIuG70tv49jq2Elw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tbhHuXFZlFcRWVj6WsIK6wkzhYcxHvOsOndeZNseuU9nyjzvToMB0TBeYbGzToyKo
	 JlmWdNeMHNRXxedBxi9WsuOsIM+TfiY4Ts+Ax0X01Kg8hx9hEVGGPuqDVeV/ZNFI9O
	 y9H19AxVDGURGvqcIxXi9PnHs8vla3suCfUeoLyc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eugen Hristev <ehristev@kernel.org>,
	Balakrishnan Sambath <balakrishnan.s@microchip.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1354/2857] media: microchip-isc: fix awb_mutex and lock lifecycle
Date: Wed, 18 Nov 2026 15:39:48 +0100
Message-ID: <20261118150250.162330776@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Balakrishnan Sambath <balakrishnan.s@microchip.com>

[ Upstream commit 5540b48c0702f6a1389db3d473d7fd0db930422a ]

isc->lock and awb_mutex were initialised in isc_async_complete() and
destroyed in isc_async_unbind(), tying their lifetime to the subdev
bind/unbind cycle instead of the device:

 - isc_async_unbind() destroyed awb_mutex before cancel_work_sync(),
   which takes it;
 - a failed .complete() left them initialised, and isc->lock was
   destroyed only on the .complete() error path, so the normal unbind
   path leaked it;
 - a rebind runs .complete() again and reinitialises a live mutex.

Initialise both with devm_mutex_init() at probe so they live for the
whole device lifetime and are freed at remove, and drop the init and
destroy from the .complete()/.unbind() callbacks.

isc_async_complete_err then only returned ret, so drop the label and
return directly at each error site.

Fixes: 314c96e5203d ("media: atmel: atmel-isc-base: use mutex to lock awb workq from streaming")
Cc: stable@vger.kernel.org
Reviewed-by: Eugen Hristev <ehristev@kernel.org>
Signed-off-by: Balakrishnan Sambath <balakrishnan.s@microchip.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
[ sashal: Changed the additional isc_formats_init() failure path to return directly after removal of the obsolete mutex cleanup label. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/platform/atmel/atmel-isc-base.c  | 18 +++++-------------
 .../media/platform/atmel/atmel-sama5d2-isc.c   |  9 +++++++++
 .../media/platform/atmel/atmel-sama7g5-isc.c   |  9 +++++++++
 3 files changed, 23 insertions(+), 13 deletions(-)

diff --git a/drivers/media/platform/atmel/atmel-isc-base.c b/drivers/media/platform/atmel/atmel-isc-base.c
index 9e91e4d948a24..a2e5030f0d597 100644
--- a/drivers/media/platform/atmel/atmel-isc-base.c
+++ b/drivers/media/platform/atmel/atmel-isc-base.c
@@ -1754,7 +1754,6 @@ static void isc_async_unbind(struct v4l2_async_notifier *notifier,
 {
 	struct isc_device *isc = container_of(notifier->v4l2_dev,
 					      struct isc_device, v4l2_dev);
-	mutex_destroy(&isc->awb_mutex);
 	cancel_work_sync(&isc->awb_work);
 	video_unregister_device(&isc->video_dev);
 	v4l2_ctrl_handler_free(&isc->ctrls.handler);
@@ -1863,8 +1862,6 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 
 	isc->current_subdev = container_of(notifier,
 					   struct isc_subdev_entity, notifier);
-	mutex_init(&isc->lock);
-	mutex_init(&isc->awb_mutex);
 
 	init_completion(&isc->comp);
 
@@ -1884,7 +1881,7 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev,
 			 "vb2_queue_init() failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Init video dma queues */
@@ -1896,19 +1893,19 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev,
 			 "Init format failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_set_default_fmt(isc);
 	if (ret) {
 		v4l2_err(&isc->v4l2_dev, "Could not set default format\n");
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	ret = isc_ctrl_init(isc);
 	if (ret) {
 		v4l2_err(&isc->v4l2_dev, "Init isc ctrols failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	/* Register video device */
@@ -1928,15 +1925,10 @@ static int isc_async_complete(struct v4l2_async_notifier *notifier)
 	if (ret < 0) {
 		v4l2_err(&isc->v4l2_dev,
 			 "video_register_device failed: %d\n", ret);
-		goto isc_async_complete_err;
+		return ret;
 	}
 
 	return 0;
-
-isc_async_complete_err:
-	mutex_destroy(&isc->awb_mutex);
-	mutex_destroy(&isc->lock);
-	return ret;
 }
 
 const struct v4l2_async_notifier_operations isc_async_ops = {
diff --git a/drivers/media/platform/atmel/atmel-sama5d2-isc.c b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
index ea3e8b86a7f31..629bb9ada4698 100644
--- a/drivers/media/platform/atmel/atmel-sama5d2-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama5d2-isc.c
@@ -30,6 +30,7 @@
 #include <linux/interrupt.h>
 #include <linux/math64.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -405,6 +406,14 @@ static int atmel_isc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isc);
 	isc->dev = dev;
 
+	ret = devm_mutex_init(dev, &isc->lock);
+	if (ret)
+		return ret;
+
+	ret = devm_mutex_init(dev, &isc->awb_mutex);
+	if (ret)
+		return ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	io_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(io_base))
diff --git a/drivers/media/platform/atmel/atmel-sama7g5-isc.c b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
index 4bc2f5c7f2f7d..2da0f7282d015 100644
--- a/drivers/media/platform/atmel/atmel-sama7g5-isc.c
+++ b/drivers/media/platform/atmel/atmel-sama7g5-isc.c
@@ -33,6 +33,7 @@
 #include <linux/interrupt.h>
 #include <linux/math64.h>
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/of.h>
 #include <linux/of_graph.h>
 #include <linux/platform_device.h>
@@ -394,6 +395,14 @@ static int microchip_xisc_probe(struct platform_device *pdev)
 	platform_set_drvdata(pdev, isc);
 	isc->dev = dev;
 
+	ret = devm_mutex_init(dev, &isc->lock);
+	if (ret)
+		return ret;
+
+	ret = devm_mutex_init(dev, &isc->awb_mutex);
+	if (ret)
+		return ret;
+
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	io_base = devm_ioremap_resource(dev, res);
 	if (IS_ERR(io_base))
-- 
2.53.0



