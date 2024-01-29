Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D51F515B0F0;
	Mon, 29 Jan 2024 17:10:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548204; cv=none; b=MRgbEnSn+hdK58l2U/0uUd1/skBMBX1bgxWqaK0vWlHQ6D2Nc3PECFEsHSdnvkwteant8htQxaaCgKhwOhJl18NbvlgjvCBvNpZH31x2OPh0zYUm2KKAOfzpii2GXcylg5h7TM8LAYXIWp1MOxzz4nIaRQ6Phy4XkF/Ql70Xs2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548204; c=relaxed/simple;
	bh=sr2CI6IWQ7ZZdwyF5CjTRWip9R8YIVilkNtZfSDlSOM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b0Y7+XmJTAf4ejVbgwU916HuJZccuub49gUnGiZzb5BDP38l8ifm/b1K5hkSBcE/2vu8vX7OHxoy9Gw+LAM9eNEuWdFDdyYv5w0yDfZ7iIzTd4Qdoo+Yy+Opj4V6UmdOXUsVqV8Ia7+osrX/yPxjR6tqhXDubmdnf+zFaHfjnoc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wTyUuYom; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wTyUuYom"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D590C433C7;
	Mon, 29 Jan 2024 17:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548204;
	bh=sr2CI6IWQ7ZZdwyF5CjTRWip9R8YIVilkNtZfSDlSOM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wTyUuYomd4BsOLEd6EfjPUFynKzb6UG/ZWbT1YE++6CH3v49ACwFAHRCbDBMiBJ18
	 SduFReSdhAgADEAvAbDzylOP0XhHv7kbYAl8f2ZPJuQw2NSMHLHmsq3DWnkXepbO6U
	 RtEdXUgjxFP5Hts85s+oqmDKmI33VOH4riYWSPig=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 6.1 017/185] media: imx355: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:03:37 -0800
Message-ID: <20240129165959.153829372@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129165958.589924174@linuxfoundation.org>
References: <20240129165958.589924174@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1784,10 +1784,6 @@ static int imx355_probe(struct i2c_clien
 		goto error_handler_free;
 	}
 
-	ret = v4l2_async_register_subdev_sensor(&imx355->sd);
-	if (ret < 0)
-		goto error_media_entity;
-
 	/*
 	 * Device is already turned on by i2c-core with ACPI domain PM.
 	 * Enable runtime PM and turn off the device.
@@ -1796,9 +1792,15 @@ static int imx355_probe(struct i2c_clien
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


