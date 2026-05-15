Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C83AB3F58CD;
	Fri, 15 May 2026 16:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862497; cv=none; b=MEOL185GYV89Uiqokyy9yELIvkl/ebp0sgU1dl0Ow2bXyFyrALypbAhvW+NOc9WHXBGXiePqdpSoMJkvnhXpI4EHoW0fUhWryfaX/vHDgW+zqgL2e8vqAhEBBM38TSUAFnxd5u3EC56narIWMJirBkcwSbPD6Wk4xHjDJOrB5AE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862497; c=relaxed/simple;
	bh=Iv3aE4PDFcj6+GVRYDGqCX22qKWW8qN49Jxj7MZhv5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q0wWYRwUjMWhZ9O0E4G+cNC5wqOJjNzkBAF88TDhBVCwYpLWjidUwgz2KYDPXF95JKIRTvOcI10DRAnFeTCymbuSlw9aQ0zZP/FfSW7QGHwZsOyCzmUXRifZd9IEiovGw82htLtKASLS69GF/wKmT6GOTbLEHG9LuiE8fOpzm74=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z+QpFIOY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z+QpFIOY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D8AFC2BCB3;
	Fri, 15 May 2026 16:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862497;
	bh=Iv3aE4PDFcj6+GVRYDGqCX22qKWW8qN49Jxj7MZhv5s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z+QpFIOYVbvR0t8ohaM0ra+zAsVNF18Ua8Qm1U96gxcJOZftiD3d3EQe3EOIJp1rj
	 K8tA0MlzYWbgIXwfY81c6z4YxlGQ9KMUbAb3zsBAEFezVbc3TQve08HEl+dQNOpzXH
	 tPIP9z/dcJnz5h+WrGpkbVjmZcewtuOR7vEelZpQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Zabel <p.zabel@pengutronix.de>,
	Matthias Fend <matthias.fend@emfend.at>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil+cisco@kernel.org>
Subject: [PATCH 7.0 070/201] media: i2c: ov08d10: fix runtime PM handling in probe
Date: Fri, 15 May 2026 17:48:08 +0200
Message-ID: <20260515154700.049422769@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthias Fend <matthias.fend@emfend.at>

commit 35c7046be2be5e60be8128facb359a47f39e99cd upstream.

Set the device's runtime PM status and enable runtime PM before registering
the async sub-device. This is needed to avoid the case where the device is
runtime PM resumed while runtime PM has not been enabled yet.

Remove the related, non-driver-specific comment while at it.

Fixes: 7be91e02ed57 ("media: i2c: Add ov08d10 camera sensor driver")
Cc: stable@vger.kernel.org
Reviewed-by: Philipp Zabel <p.zabel@pengutronix.de>
Signed-off-by: Matthias Fend <matthias.fend@emfend.at>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil+cisco@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov08d10.c |   11 +++++------
 1 file changed, 5 insertions(+), 6 deletions(-)

--- a/drivers/media/i2c/ov08d10.c
+++ b/drivers/media/i2c/ov08d10.c
@@ -1430,6 +1430,9 @@ static int ov08d10_probe(struct i2c_clie
 		goto probe_error_v4l2_ctrl_handler_free;
 	}
 
+	pm_runtime_set_active(ov08d10->dev);
+	pm_runtime_enable(ov08d10->dev);
+
 	ret = v4l2_async_register_subdev_sensor(&ov08d10->sd);
 	if (ret < 0) {
 		dev_err(ov08d10->dev, "failed to register V4L2 subdev: %d",
@@ -1437,17 +1440,13 @@ static int ov08d10_probe(struct i2c_clie
 		goto probe_error_media_entity_cleanup;
 	}
 
-	/*
-	 * Device is already turned on by i2c-core with ACPI domain PM.
-	 * Enable runtime PM and turn off the device.
-	 */
-	pm_runtime_set_active(ov08d10->dev);
-	pm_runtime_enable(ov08d10->dev);
 	pm_runtime_idle(ov08d10->dev);
 
 	return 0;
 
 probe_error_media_entity_cleanup:
+	pm_runtime_disable(ov08d10->dev);
+	pm_runtime_set_suspended(ov08d10->dev);
 	media_entity_cleanup(&ov08d10->sd.entity);
 
 probe_error_v4l2_ctrl_handler_free:


