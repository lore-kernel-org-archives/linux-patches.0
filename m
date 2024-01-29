Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EC75C159580;
	Mon, 29 Jan 2024 17:10:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548208; cv=none; b=N95WpYzDZ+6hYwjOH1cWZKgWymcGTausiLuxBNTfgUExfsM0h0TDwn63FvUht0W1sIMUN+EN6lOxovBA55TEz+cszNgNQVvXmuUxZ4aXAZllU3bFBAPl89l5QxB2dckrOvCOq4Gd/NeYy0L7JJeP88tNMAYzXhhX+xYFfl0mteQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548208; c=relaxed/simple;
	bh=d7cGkZS+1ZynxOdKL6antyxHIY9gM71QKmJrOh6GVF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DVG5YZbalW1Y7vthG/gSzjUAwZG7e3Vsjsao5iviAx+R4rvm2HZ6rHbZylaOvWuL/Kz/7I9bN7n9eIhhwIEKS6FXja1/itGWaG2pvSZoamuofMRmbhbks+MZKLZifMRTIOWRO/A+MFZ+d1VL3YOqADGW27+ejKXq51Dg1gIDEnM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mdnhomZp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mdnhomZp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B348EC433C7;
	Mon, 29 Jan 2024 17:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548207;
	bh=d7cGkZS+1ZynxOdKL6antyxHIY9gM71QKmJrOh6GVF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mdnhomZp4wdFq5AIswHzJeOVTsNukY96t6ikuMUOG3bNTA+UEwTgOHt6v8boo6ppa
	 tcgOWfdgup5nsKhJerAI1Xvgo3+RXjmSFzDCmRCiGpX+SE+XWnk2HlBrXz3QpQIsIP
	 Vnn35Ts+OBpQmrvJI3TQ9Z5F2hGcE6Kb9qza+oDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 019/185] media: ov9734: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:03:39 -0800
Message-ID: <20240129165959.216541822@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit e242e9c144050ed120cf666642ba96b7c4462a4c upstream.

As the sensor device maybe accessible right after its async sub-device is
registered, such as ipu-bridge will try to power up sensor by sensor's
client device's runtime PM from the async notifier callback, if runtime PM
is not enabled, it will fail.

So runtime PM should be ready before its async sub-device is registered
and accessible by others.

Fixes: d3f863a63fe4 ("media: i2c: Add ov9734 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov9734.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

--- a/drivers/media/i2c/ov9734.c
+++ b/drivers/media/i2c/ov9734.c
@@ -939,6 +939,7 @@ static void ov9734_remove(struct i2c_cli
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	mutex_destroy(&ov9734->mutex);
 }
 
@@ -984,13 +985,6 @@ static int ov9734_probe(struct i2c_clien
 		goto probe_error_v4l2_ctrl_handler_free;
 	}
 
-	ret = v4l2_async_register_subdev_sensor(&ov9734->sd);
-	if (ret < 0) {
-		dev_err(&client->dev, "failed to register V4L2 subdev: %d",
-			ret);
-		goto probe_error_media_entity_cleanup;
-	}
-
 	/*
 	 * Device is already turned on by i2c-core with ACPI domain PM.
 	 * Enable runtime PM and turn off the device.
@@ -999,9 +993,18 @@ static int ov9734_probe(struct i2c_clien
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
+	ret = v4l2_async_register_subdev_sensor(&ov9734->sd);
+	if (ret < 0) {
+		dev_err(&client->dev, "failed to register V4L2 subdev: %d",
+			ret);
+		goto probe_error_media_entity_cleanup_pm;
+	}
+
 	return 0;
 
-probe_error_media_entity_cleanup:
+probe_error_media_entity_cleanup_pm:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	media_entity_cleanup(&ov9734->sd.entity);
 
 probe_error_v4l2_ctrl_handler_free:


