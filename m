Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07561255E20;
	Thu, 17 Apr 2025 18:28:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914514; cv=none; b=bN2ykPG5PiiaRUrWt4i8fdsoLlT65V08V+Z7dN4OriP60MDC7+vio24fLToE0FKokZnycPvjByQilf8Nvyq4MNQh91v3oRuzlM2W8c6QXZggDCgbKlmMgDvYyG4R8kb0v3z5YmPSosbbE422BA9ojfE2G3Ws72hsjDXEXPiIXCc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914514; c=relaxed/simple;
	bh=6Da2r0PdnAMI75EtRa6yjobM5YCC8esAvIm7uD1EDy8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FryhqBTKbRIQrpHhZWBZl8ZIpivBQEnF6EOWI/5U3d69Te+FxWOEwBKP7bfyqGHKsYpx8IpwbXjqRNGgbw3YJ1QlKEqOgUkYX88CBVDPq/Hhy8rXN6LK1fo9z8h0JqhNDffIgTEZY2UrmysHvbPLn0jUJPpPqbF/z2i+Si9hWS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=L5PQ0Vvn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="L5PQ0Vvn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72B90C4CEE4;
	Thu, 17 Apr 2025 18:28:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914513;
	bh=6Da2r0PdnAMI75EtRa6yjobM5YCC8esAvIm7uD1EDy8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=L5PQ0VvnVFt22U8wMx44rJOfbwc319U9h3la/nCoyGmAVH9c/AkjOFy+IgFvoquYa
	 qXGMZUGZ79BaWQpwiEiZT7qd11tcCvkcTbpwS7Pnu1wgWZNcJal5lbSKrQdLUeXEdM
	 npsvFhM2yKeL+GIJLJsmUfCT2en1MysbUhpjLzek=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.13 239/414] media: i2c: imx219: Rectify runtime PM handling in probe and remove
Date: Thu, 17 Apr 2025 19:49:57 +0200
Message-ID: <20250417175121.037608101@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sakari Ailus <sakari.ailus@linux.intel.com>

commit 42eceae9793566d0df53d509be3e416465c347f5 upstream.

Set the device's runtime PM status and enable runtime PM before
registering the async sub-device. This is needed to avoid the case where
the device is runtime PM resumed while runtime PM has not been enabled
yet.

Also set the device's runtime PM status to suspended in remove only if it
wasn't so already.

Fixes: 1283b3b8f82b ("media: i2c: Add driver for Sony IMX219 sensor")
Cc: stable@vger.kernel.org # for >= v6.6
Reviewed-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx219.c |   13 ++++++++-----
 1 file changed, 8 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/imx219.c
+++ b/drivers/media/i2c/imx219.c
@@ -1223,6 +1223,9 @@ static int imx219_probe(struct i2c_clien
 		goto error_media_entity;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	ret = v4l2_async_register_subdev_sensor(&imx219->sd);
 	if (ret < 0) {
 		dev_err_probe(dev, ret,
@@ -1230,15 +1233,14 @@ static int imx219_probe(struct i2c_clien
 		goto error_subdev_cleanup;
 	}
 
-	/* Enable runtime PM and turn off the device */
-	pm_runtime_set_active(dev);
-	pm_runtime_enable(dev);
 	pm_runtime_idle(dev);
 
 	return 0;
 
 error_subdev_cleanup:
 	v4l2_subdev_cleanup(&imx219->sd);
+	pm_runtime_disable(dev);
+	pm_runtime_set_suspended(dev);
 
 error_media_entity:
 	media_entity_cleanup(&imx219->sd.entity);
@@ -1263,9 +1265,10 @@ static void imx219_remove(struct i2c_cli
 	imx219_free_controls(imx219);
 
 	pm_runtime_disable(&client->dev);
-	if (!pm_runtime_status_suspended(&client->dev))
+	if (!pm_runtime_status_suspended(&client->dev)) {
 		imx219_power_off(&client->dev);
-	pm_runtime_set_suspended(&client->dev);
+		pm_runtime_set_suspended(&client->dev);
+	}
 }
 
 static const struct of_device_id imx219_dt_ids[] = {


