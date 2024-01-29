Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1932B3F9E7;
	Mon, 29 Jan 2024 17:14:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548445; cv=none; b=Du8z8JUOgyF+QMLbU2ex2TxNNCfjMxOA3J4AKXVVTfEEyfvqZLn/fmtxrI426QX/Zi4pAJru8JJK6UUdLx7PPJOQYPoi4Z/If/sAvC11eMSJdwTgAx7mI1epF9dkZd1PR7l82YNsQJhoAxSLN2kCfnwpjiJ90gSlBYAOtz0CNqc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548445; c=relaxed/simple;
	bh=9Cdx1thBw7NyqIzPK97ZDEMPZxYC1efRmFKahtpzLm8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MPUJD0o7ccwI43JGwebg0A3YgvEQQLM4oLq18hrqc5EruVaFsouOxzV8XuzZvxBmeMsa25O0JRbaPMdSnR1xLMvLTlnFUyXKoxbBKJeNXFxtWdSE++GKRZIYwOrPKDt6AATGmPpCezFHd2DKQIgjufmeAy5phjVC0dJ4GdfAVZ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=dDdBjHZY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="dDdBjHZY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D47C2C433F1;
	Mon, 29 Jan 2024 17:14:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548444;
	bh=9Cdx1thBw7NyqIzPK97ZDEMPZxYC1efRmFKahtpzLm8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=dDdBjHZY0h9l8jS86lY0D01dgupI/uVQEiyqVQcQA8P+cFNQLAyUgoFHzD4qYZ7Nn
	 4DE6xmhYVLsXEUwTQPXgPXjNC2J5ORCzQj8t+h0i8+Mf3K1BGNCVwD7UlaCTn+wYZ6
	 gMUwhFWRJGg/BX1dFxWxTWNZ5Ds1AGxMb8q6WFmw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.6 051/331] media: imx355: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:01:55 -0800
Message-ID: <20240129170016.429401648@linuxfoundation.org>
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

commit efa5fe19c0a9199f49e36e1f5242ed5c88da617d upstream.

As the sensor device maybe accessible right after its async sub-device is
registered, such as ipu-bridge will try to power up sensor by sensor's
client device's runtime PM from the async notifier callback, if runtime PM
is not enabled, it will fail.

So runtime PM should be ready before its async sub-device is registered
and accessible by others.

Fixes: df0b5c4a7ddd ("media: add imx355 camera sensor driver")
Cc: stable@vger.kernel.org
Signed-off-by: Bingbu Cao <bingbu.cao@intel.com>
Signed-off-by: Sakari Ailus <sakari.ailus@linux.intel.com>
Signed-off-by: Hans Verkuil <hverkuil-cisco@xs4all.nl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/media/i2c/imx355.c |   12 +++++++-----
 1 file changed, 7 insertions(+), 5 deletions(-)

--- a/drivers/media/i2c/imx355.c
+++ b/drivers/media/i2c/imx355.c
@@ -1788,10 +1788,6 @@ static int imx355_probe(struct i2c_clien
 		goto error_handler_free;
 	}
 
-	ret = v4l2_async_register_subdev_sensor(&imx355->sd);
-	if (ret < 0)
-		goto error_media_entity;
-
 	/*
 	 * Device is already turned on by i2c-core with ACPI domain PM.
 	 * Enable runtime PM and turn off the device.
@@ -1800,9 +1796,15 @@ static int imx355_probe(struct i2c_clien
 	pm_runtime_enable(&client->dev);
 	pm_runtime_idle(&client->dev);
 
+	ret = v4l2_async_register_subdev_sensor(&imx355->sd);
+	if (ret < 0)
+		goto error_media_entity_runtime_pm;
+
 	return 0;
 
-error_media_entity:
+error_media_entity_runtime_pm:
+	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 	media_entity_cleanup(&imx355->sd.entity);
 
 error_handler_free:


