Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A3FE79DAB;
	Wed, 21 Feb 2024 13:24:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708521857; cv=none; b=DiGV3UvhAtXQ5WTaxv+S01z7w+Urh7cXAK5WnpHRkQXGeHx1E9LlrH+2cDSsSEHoZozIEBXFs59lcU85mhEgGGbZPHs8PQAA19k8he0KCHcWmsvcAkOU0ZnC0so8/QqOCNxfRGK3rn8KXxGddrKHbKuS2UBfu+rl8ov5TIlnKoY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708521857; c=relaxed/simple;
	bh=Zv35uSbxV0yHRBvDXbJKNhGf2eQUJbGe+om2jjtYTn8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sewn01PtUX0nBwPvlk99T68RNmm+YTsa6FOebt7hjDnJ7ezB/pDI5oKS8cblbLTTB3e8YsFPTxnILm6xv93Dl8LbFZhU1qqIy/uaMixyKwgDgfiBKpXk8zOUppcIW2RnWJd/nP5T/Xxl6Q0kUzJIkDVuWbWci4cfZ41hgbe1dZE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lKjG0ZpM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lKjG0ZpM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 69A48C43399;
	Wed, 21 Feb 2024 13:24:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708521856;
	bh=Zv35uSbxV0yHRBvDXbJKNhGf2eQUJbGe+om2jjtYTn8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lKjG0ZpMPWSAM9EhePyF6HktwOlTxOLG0zYbrAmYGsr37QhKtc0zbiCYn1/r7o81y
	 SMD84Yb8RYYoA+DcUIz3eiBvv/QRM0mUNtuY1R4krfY5VV0nCMccb14j8sMIOsSl1E
	 ARTfQ2gXYt5gZdrPUbasuuqVoZNHSTjuVHvwg/F4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>
Subject: [PATCH 5.15 019/476] media: imx355: Enable runtime PM before registering async sub-device
Date: Wed, 21 Feb 2024 14:01:10 +0100
Message-ID: <20240221130008.609825089@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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


