Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 20544256C6D;
	Thu, 17 Apr 2025 18:07:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913225; cv=none; b=MCz1UXxGNK/3Jhne3ci6YDXnryq3Sz8HS/+BsGClan+Qr/tRTZdq+6NhqONvx+CljXw+H8yBDTCPOzi8eFAlDN/6/s6T0ts8Oz1Q6SRBCXB5fcgB7WTL8EkDaUEpiQgRbU/vNuWLlFp1v1QltZo9NwDGS6mN0x+aYcVgwwP7PEk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913225; c=relaxed/simple;
	bh=If4JdUCG7UcGR/XNpf9V0Cf4j6kFGIRW9N2h1ZvmEIo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BS+nZ4I3K8GqvaksHaEgPho+2F9WhZCQuJdxqOsFNuvjONVjRdnVjdeZkHWMKylYQOiDJ/LLEq0K8uCAzFupEVHbTPeS/Zw3jynsOqzM6WyAooKQ77fZr3R4MZUfD+aYdaL3rpYRRLvZKA55aC7o9k9kprWYlsMMwzzEJM/iC1o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CnNI34MF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CnNI34MF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9E505C4CEE4;
	Thu, 17 Apr 2025 18:07:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913225;
	bh=If4JdUCG7UcGR/XNpf9V0Cf4j6kFGIRW9N2h1ZvmEIo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CnNI34MFTjzBI2/+bTxwHSDBYYENeMnHibXPMY+IcpGm/bE1QkXTCj8K4upMmo+8Y
	 eAOhxEkwL02RnqON62p73GAR+vf1cSopXbexWhf9K9yg1m1Zz3BUGccexoHV2HY+Xu
	 0giS7Gd1UruCXyw4LNL/IGo7IrzN41krqzM3sNu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil@xs4all.nl>
Subject: [PATCH 6.14 261/449] media: i2c: imx219: Rectify runtime PM handling in probe and remove
Date: Thu, 17 Apr 2025 19:49:09 +0200
Message-ID: <20250417175128.517483336@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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


