Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95B1B2586EC;
	Thu, 17 Apr 2025 18:50:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915837; cv=none; b=tTaeDr6zjgl2P10z4/s8g1vK79Y6nwAOBifL3r4XD9+D0kmSYPntQyPYoVDqrwJSKKMLSgaThIyVxqNHJrpuk6lTqky2RgkUv3XhvdZjOnarF9MI9CdFScjH/nfgGvIVLXf4ansfAzpBwqGGm+QRi/LNDZaOgdzcy4qNGbtwZoQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915837; c=relaxed/simple;
	bh=R8zSC7fPvg9NWYhQEcqCjtkDHmSCjotqSI7x9EGcLTY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SZ8tXdm0+ywjlDNri48QtMTFw5y4N3ItqoW/k5VkPtKCYwdtJsNiOfi61OoiKydGdrG4u13xd/UafDBDoWYkh/4Zuawr0q7XP2k1qKtWJ0QpY/L5T0xd6NNs1ymDWPS7ZUpNxXwjhvJhUL7h/j31R1J0gi86CbVj3j687L3r/m4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UzXHymW6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UzXHymW6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20DE4C4CEE4;
	Thu, 17 Apr 2025 18:50:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915837;
	bh=R8zSC7fPvg9NWYhQEcqCjtkDHmSCjotqSI7x9EGcLTY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UzXHymW6KZnfjnEYkfbR9vpTCuudPhEyJe0iQqLdTK7Q8wefhuFdh5jyYcbQaLy6+
	 Q+p78yWxD4tusIFrBdf9P4enoQIq3dkXvri0hx4Zkel1jAuNwRiZ+nOSer22oOLb7S
	 +Dil/2HSLK6z7ziiEihTrPUfrIZ8N6ISTBTw6lW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.12 227/393] media: i2c: imx219: Rectify runtime PM handling in probe and remove
Date: Thu, 17 Apr 2025 19:50:36 +0200
Message-ID: <20250417175116.718256671@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1231,6 +1231,9 @@ static int imx219_probe(struct i2c_clien
 		goto error_media_entity;
 	}
 
+	pm_runtime_set_active(dev);
+	pm_runtime_enable(dev);
+
 	ret = v4l2_async_register_subdev_sensor(&imx219->sd);
 	if (ret < 0) {
 		dev_err_probe(dev, ret,
@@ -1238,15 +1241,14 @@ static int imx219_probe(struct i2c_clien
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
@@ -1271,9 +1273,10 @@ static void imx219_remove(struct i2c_cli
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


