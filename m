Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2756159598;
	Mon, 29 Jan 2024 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548054; cv=none; b=OT5Y2XOnPUc+2e8kAxTXqaaBQxzp0ET6oy8nXGzMbh7QQrSElTRHrryAyf11og1JbVLHjO3B7aXArhI6JtR+aDBIaTawaPmGPQ70H1mjvUW2UV3HQnGqOztJY3IHq0sw12AMWMh537SDE5phQ54gjFzRmqaRiHLbZ7Dgkg5AYUk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548054; c=relaxed/simple;
	bh=hwhAoR6m1/6YuhTJ4cz6xNg4Em5WGKeSeOxC1LieaNg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Q61N79npiSPjClxXi9YVcf1AN/BAZluu7XrdRIW39zIus9ozu3mLutlp+I6gVT4owuoPPg9qRf5o1lPP3dM/ewzKFvUPlHSA0CQnkBXfGRTo5Y0zbuESPC1PEYff2tO+zQ+sXKnsWg1VIM5ydtbGgeGSHtYvmlET6ys/bcBlI28=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eWaIrdJ+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eWaIrdJ+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9965C433C7;
	Mon, 29 Jan 2024 17:07:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548053;
	bh=hwhAoR6m1/6YuhTJ4cz6xNg4Em5WGKeSeOxC1LieaNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eWaIrdJ+Zw5Md/JuhIIK2aqeSEp5fMmwNCtX8nP+M1i6lnviH1AwqliBsQE43lZEs
	 j2C8A871puHZvud100ka+W1ymNUoB8ul0ksXUnxC8AOsfbjbuE++93f3i8KXUYaG0J
	 o4OB9ytdvo6lg7HobcIon8RJp7Gr5Dg6IJRcVwmE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.7 032/346] media: ov01a10: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:01:03 -0800
Message-ID: <20240129170017.329228978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 47a78052db51b16e8045524fbf33373b58f1323b upstream.

As the sensor device maybe accessible right after its async sub-device is
registered, such as ipu-bridge will try to power up sensor by sensor's
client device's runtime PM from the async notifier callback, if runtime PM
is not enabled, it will fail.

So runtime PM should be ready before its async sub-device is registered
and accessible by others.

It also sets the runtime PM status to active as the sensor was turned
on by i2c-core.

Fixes: 0827b58dabff ("media: i2c: add ov01a10 image sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov01a10.c |   18 ++++++++++++++----
 1 file changed, 14 insertions(+), 4 deletions(-)

--- a/drivers/media/i2c/ov01a10.c
+++ b/drivers/media/i2c/ov01a10.c
@@ -859,6 +859,7 @@ static void ov01a10_remove(struct i2c_cl
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 }
 
 static int ov01a10_probe(struct i2c_client *client)
@@ -905,17 +906,26 @@ static int ov01a10_probe(struct i2c_clie
 		goto err_media_entity_cleanup;
 	}
 
+	/*
+	 * Device is already turned on by i2c-core with ACPI domain PM.
+	 * Enable runtime PM and turn off the device.
+	 */
+	pm_runtime_set_active(&client->dev);
+	pm_runtime_enable(dev);
+	pm_runtime_idle(dev);
+
 	ret = v4l2_async_register_subdev_sensor(&ov01a10->sd);
 	if (ret < 0) {
 		dev_err(dev, "Failed to register subdev: %d\n", ret);
-		goto err_media_entity_cleanup;
+		goto err_pm_disable;
 	}
 
-	pm_runtime_enable(dev);
-	pm_runtime_idle(dev);
-
 	return 0;
 
+err_pm_disable:
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(&client->dev);
+
 err_media_entity_cleanup:
 	media_entity_cleanup(&ov01a10->sd.entity);
 


