Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C837D3D75C7;
	Wed, 20 May 2026 18:06:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779300362; cv=none; b=MQhO/pj1zz5oX4kp7p+IVdOzp4f1LV0dYIEHndwV5hxEbyjVIh3ZtgGyzrI5TZZE7nvEu/0MU7EdFNRBkuo6rnUV6yeJi/AW6rByhbY0Ja18rn8UoFia7EnAQZegFEfz13yqhzG8Mzx1hkVxKHi3tSamAdCF327vQHv0eh8lT0I=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779300362; c=relaxed/simple;
	bh=hENAOVdnkYatGjpt9OQjrkM2+c3o6vl+emL1fZsq03o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZHuPvJJVHV7ogr4q16xcEiX45FYkp901pbBLoYhO+qiBwmL2KPr0UPwdATtZs/LXRSBgZACa2HhABdY8S2qnhq4aaXoa+Uok6S63hoafrqoy21d8dO+n33d1yvQFMHzBHXioop9qh/I6LWb3TPGggMU1nxiF/cRzDfb9YeImavM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tOBrIxPA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tOBrIxPA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A9B71F000E9;
	Wed, 20 May 2026 18:06:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779300361;
	bh=rRn445rCQNsSwHNhtYA2AlFdmJjWAHH8W1cYJ75PxPU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tOBrIxPArgZAMOKmt1mV9zr6dTK+WX41jDRhVR4+OPoFjrfPi+vYG9OLpL9Li5HFY
	 3QyweyzKOCssK5W3fJcM2hwjnp4OQOfWbfjsdl1CLYCGSqyuQgaugaeQPb+xRmziRD
	 ZtQuwUeaB+2Eb3cy8jUW/aAvxXK7NawewjlkxW2Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 146/666] media: i2c: og01a1b: Fix V4L2 subdevice data initialization on probe
Date: Wed, 20 May 2026 18:15:57 +0200
Message-ID: <20260520162114.371714797@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162111.222830634@linuxfoundation.org>
References: <20260520162111.222830634@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>

[ Upstream commit 535b7f106991c7d8f0e5b8e1769bfb8b1ce9d3d6 ]

It's necessary to finalize the camera sensor subdevice initialization on
driver probe and clean V4L2 subdevice data up on error paths and driver
removal.

The change fixes a previously reported by v4l2-compliance issue of
the failed VIDIOC_(UN)SUBSCRIBE_EVENT/DQEVENT test:

  fail: v4l2-test-controls.cpp(1104): subscribe event for control 'User Controls' failed

Fixes: 472377febf84 ("media: Add a driver for the og01a1b camera sensor")
Signed-off-by: Vladimir Zapolskiy <vladimir.zapolskiy@linaro.org>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/og01a1b.c | 13 ++++++++++++-
 1 file changed, 12 insertions(+), 1 deletion(-)

diff --git a/drivers/media/i2c/og01a1b.c b/drivers/media/i2c/og01a1b.c
index a9baf8095d4f3..68573122cd6ee 100644
--- a/drivers/media/i2c/og01a1b.c
+++ b/drivers/media/i2c/og01a1b.c
@@ -1058,6 +1058,7 @@ static void og01a1b_remove(struct i2c_client *client)
 	struct og01a1b *og01a1b = to_og01a1b(sd);
 
 	v4l2_async_unregister_subdev(sd);
+	v4l2_subdev_cleanup(&og01a1b->sd);
 	media_entity_cleanup(&sd->entity);
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 	pm_runtime_disable(og01a1b->dev);
@@ -1164,11 +1165,18 @@ static int og01a1b_probe(struct i2c_client *client)
 		goto probe_error_v4l2_ctrl_handler_free;
 	}
 
+	ret = v4l2_subdev_init_finalize(&og01a1b->sd);
+	if (ret < 0) {
+		dev_err_probe(og01a1b->dev, ret,
+			      "failed to finalize subdevice init\n");
+		goto probe_error_media_entity_cleanup;
+	}
+
 	ret = v4l2_async_register_subdev_sensor(&og01a1b->sd);
 	if (ret < 0) {
 		dev_err(og01a1b->dev, "failed to register V4L2 subdev: %d",
 			ret);
-		goto probe_error_media_entity_cleanup;
+		goto probe_error_v4l2_subdev_cleanup;
 	}
 
 	/* Enable runtime PM and turn off the device */
@@ -1178,6 +1186,9 @@ static int og01a1b_probe(struct i2c_client *client)
 
 	return 0;
 
+probe_error_v4l2_subdev_cleanup:
+	v4l2_subdev_cleanup(&og01a1b->sd);
+
 probe_error_media_entity_cleanup:
 	media_entity_cleanup(&og01a1b->sd.entity);
 
-- 
2.53.0



