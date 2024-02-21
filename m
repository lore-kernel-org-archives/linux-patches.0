Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FF206995F;
	Wed, 21 Feb 2024 13:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521871; cv=none; b=drdFRhmsnDtgUr2k5W9pB6yfJq/ABmU7KQ/hOUOwC9XPbnKNofrfBBwsJW4R3XEL1WIKKD/ZHxNS78VqEDW+xUL7EhdZ/sjgjLox19aiTLBpP/HkwtLUQr+zoBuA0t/KNCACfIFtGiMNsbIxypCGFqSNzAMTNqIThdxii/jhzmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521871; c=relaxed/simple;
	bh=lB/7HI8k0uOk1vNPMgsZ03+yFC0/gdUiU8BkQYPLDzY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ANCtNmAGOfyM/bJXsQNBCPBD5P5pLLkEipEhpHduPCWvv+jp9xWUDgpWVI4rI7qCvr6pnLwICcJJ2cjXgIFAllGY/DnMLxF66KJeN1K6BPEfTMmQ/dcjbpIPuXQYDHUqqIvhx+pxi8MBgiBlJIcadlmNUEwjnQFBIjUf9aDCOd4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=As5V/D7o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="As5V/D7o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1B9DC43394;
	Wed, 21 Feb 2024 13:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521871;
	bh=lB/7HI8k0uOk1vNPMgsZ03+yFC0/gdUiU8BkQYPLDzY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=As5V/D7oXLyU3btywa4+zQoAAIyxB02zVeQXllcoo8MLaUWPKRBbNxHHYAqVdK9oE
	 nMAE2fCeIv3fju2M8RNNZZbnyuV/oz6Jl2oMh73JxRFVOhxA8iceqDFGEHJ4E2tGTS
	 BdIZX1dLlW9XFQ7hXrHPEhmWS6MWJSqzntiMFeU4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 021/476] media: ov9734: Enable runtime PM before registering async sub-device
Date: Wed, 21 Feb 2024 14:01:12 +0100
Message-ID: <20240221130008.681875731@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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
@@ -939,6 +939,7 @@ static int ov9734_remove(struct i2c_clie
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	mutex_destroy(&ov9734->mutex);
 
 	return 0;
@@ -986,13 +987,6 @@ static int ov9734_probe(struct i2c_clien
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
@@ -1001,9 +995,18 @@ static int ov9734_probe(struct i2c_clien
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


