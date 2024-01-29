Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 94D5215703E;
	Mon, 29 Jan 2024 17:07:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548053; cv=none; b=fuFAUqR1Z7gXZx7xxGNB7VFA+NrVcLhT4czjeTe9j8OjGNun9lleTCMiSgycp74U0rYbP1FYARCRturSX5rjJFt/JMu0TKLJw5XwlI4QhzIoCxsg/xV5V6VMIsHvApIvywoiYquXG6iWKfH0GeqWC820DFPdNjtQpjQ2SH3A0D8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548053; c=relaxed/simple;
	bh=1z8v97DKmKS1opn7kkQadrBXw5+80/nLwQlAneo2ob4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jAA/tsVNJ+UWqumlC1fBp7Lh496V1lCPpQT1nmrrz1tYBw2BWUCM9MUYtmJoL28P8HuJ1ygBtxJoZkiHWa+YJY1QsvlmMbP+GZKyWYRK5MmDm1/CoM9h0c8AjsE5DNVuAmHIgYY01bxos0J16eH2Na96oJjRoA+9nA0SiZfvmAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MAyciiB0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MAyciiB0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1B23C433C7;
	Mon, 29 Jan 2024 17:07:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548053;
	bh=1z8v97DKmKS1opn7kkQadrBXw5+80/nLwQlAneo2ob4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MAyciiB0ZXvPHG9SQYKmgIcKd68sya8griKJEa6ZaMyfEpTnovso/YEGh/10qf+vo
	 x/wyPi+IoHEtNHqu85xBvPHuF2ZTsPVFTqMoS3m5kel5CuiRYu5ZiR/cB/aobPhzeR
	 6QX5SD9EylHB6vyQxV0fGsfJ78iswpvaOxyDAnJw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.7 031/346] media: ov13b10: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:01:02 -0800
Message-ID: <20240129170017.296378459@linuxfoundation.org>
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
@@ -1556,24 +1556,27 @@ static int ov13b10_probe(struct i2c_clie
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
@@ -1596,6 +1599,7 @@ static void ov13b10_remove(struct i2c_cl
 	ov13b10_free_controls(ov13b);
 
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 }
 
 static DEFINE_RUNTIME_DEV_PM_OPS(ov13b10_pm_ops, ov13b10_suspend,


