Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 039AC6F06C;
	Mon, 29 Jan 2024 17:14:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548460; cv=none; b=EXz6d3DAO4KjwxRvlnHk/TisucX8Uzioy1/+UeuA5KVl8ZmztKswWgEARe91zkXy97Yp73D5DO9FPJbrnVwdYGHc6vc//akDQVUTZ8Wsq7twr/U7nsWPr155VNehD+2QrZenRAtN//SvkC81mt3nB9NMWZo55dlAVSRnle6Fye0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548460; c=relaxed/simple;
	bh=9qsQz/ooNfCzjyNzwG4MeaIuQ2uw1k1l6bzqTg3Ncus=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8o/M6PK+aCU2NtCqyACGQXWG2Wu2VnrnVL87VDskNafMTT7fq1VyBYNbaOsc6cNNtbjxDlTGoKy6Q0he4wwO/vMs8weME5gLN+DBOjGb2wOAoh5OgOyCiuakyifTLqyLPb5LYG771rTPXT7jJ7C59HPi2chaDQbp3Q8eWoDjHM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xTJEIevW; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xTJEIevW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2E0BC433C7;
	Mon, 29 Jan 2024 17:14:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548459;
	bh=9qsQz/ooNfCzjyNzwG4MeaIuQ2uw1k1l6bzqTg3Ncus=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xTJEIevWxCj7fmXGmjQe1So6N3zUCdBPgQrL9vf/A77GdRmFU4mxcsyg25/mzGWO7
	 JvVDcAld6KGsl5JGCJVM1eLUWp5+Wnnu8Y4Lrs+ykCvwfxyhZkyRZ/uPI8V3uzU9qV
	 1rzOhh4eAkNk4m+mE5Bs0WOpWBvleE/hhxKUZgBk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 055/331] media: ov01a10: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:01:59 -0800
Message-ID: <20240129170016.535847376@linuxfoundation.org>
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
@@ -907,6 +907,7 @@ static void ov01a10_remove(struct i2c_cl
 	v4l2_ctrl_handler_free(sd->ctrl_handler);
 
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 }
 
 static int ov01a10_probe(struct i2c_client *client)
@@ -953,17 +954,26 @@ static int ov01a10_probe(struct i2c_clie
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
 


