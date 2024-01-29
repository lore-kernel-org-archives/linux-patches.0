Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3575F15957C;
	Mon, 29 Jan 2024 17:14:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548452; cv=none; b=KEEL6bOhrVPUx/PJg11yb5abjUINNaJXKEJunBa5brdqJ6DGjZNsDDIuRMZ1RbU6SAbDtnoXbxno2jl51IXHn6P5bw1GmnxWBnmmEe7YI7d4Oa0xlIhRVaMmbZkduZbFu/x1ZsgCw9sHyrIz5qG63QqIHMyGRh4jWpwzfT8pJB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548452; c=relaxed/simple;
	bh=UwQM2fS/jZ9KKTgf1QyYTZSj5OXueqaNzoSTKfGkz6Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m2V1H+VjfZc+nRpXt3Tpss85DGFbqcREfb0JeT4538fK462NDt2nlHW0lg/pLKT1521EcOs2AB3BLUbmyXftxzteD3C2HIJxORgkixrpgNCffaCt3DoLfy0IL2mrro9VxqqKC+VD8d0otcxih1twyE4Mo9fre3IR2piU7gnCr70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zGfQNWAQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zGfQNWAQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CB5C43390;
	Mon, 29 Jan 2024 17:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548452;
	bh=UwQM2fS/jZ9KKTgf1QyYTZSj5OXueqaNzoSTKfGkz6Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zGfQNWAQpij8bmOWXo1sOAfOp78/G1r7lspMtfW87ZMHuAwtTDG9lIGyJZ+7q5QWQ
	 uFJRtyxyJL+uEyZfOgIh8TioYPsJXL1iEXsM5ruGmVoWsMGTvrw1dnsCKgdIYuSWlo
	 nRGx2EeDaoKz9Mfr0FUGn0LVLjg1LoSDWyS3N1Ok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 054/331] media: ov13b10: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:01:58 -0800
Message-ID: <20240129170016.511353416@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bingbu Cao <bingbu.cao@intel.com>

commit 7b0454cfd8edb3509619407c3b9f78a6d0dee1a5 upstream.

As the sensor device maybe accessible right after its async sub-device is
registered, such as ipu-bridge will try to power up sensor by sensor's
client device's runtime PM from the async notifier callback, if runtime PM
is not enabled, it will fail.

So runtime PM should be ready before its async sub-device is registered
and accessible by others.

Fixes: 7ee850546822 ("media: Add sensor driver support for the ov13b10 camera.")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/ov13b10.c |   14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/ov13b10.c
+++ b/drivers/media/i2c/ov13b10.c
@@ -1536,24 +1536,27 @@ static int ov13b10_probe(struct i2c_clie
 		goto error_handler_free;
 	}
 
-	ret = v4l2_async_register_subdev_sensor(&ov13b->sd);
-	if (ret < 0)
-		goto error_media_entity;
 
 	/*
 	 * Device is already turned on by i2c-core with ACPI domain PM.
 	 * Enable runtime PM and turn off the device.
 	 */
-
 	/* Set the device's state to active if it's in D0 state. */
 	if (full_power)
 		pm_runtime_set_active(&client->dev);
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
+	ret = v4l2_async_register_subdev_sensor(&ov13b->sd);
+	if (ret < 0)
+		goto error_media_entity_runtime_pm;
+
 	return 0;
 
-error_media_entity:
+error_media_entity_runtime_pm:
+	pm_runtime_disable(&client->dev);
+	if (full_power)
+		pm_runtime_set_suspended(&client->dev);
 	media_entity_cleanup(&ov13b->sd.entity);
 
 error_handler_free:
@@ -1576,6 +1579,7 @@ static void ov13b10_remove(struct i2c_cl
 	ov13b10_free_controls(ov13b);
 
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(ov13b10_pm_ops, ov13b10_suspend,


