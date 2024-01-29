Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8CECE15956D;
	Mon, 29 Jan 2024 17:13:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548393; cv=none; b=mo9UoQ4xOCBBm8ksBpHwAYfaG9pdBpBE0/nKogIYWxD092ndhME/aMZNIuTtXIhynzJlXB3H2NbBmuw8iLuQV19jSTWXdwTvxi+FnVLoVozq/NiEW3HWw7WsyECq0USr+Rfw4OOCNItx2FhSBY7pCibeAXE2XMMd9T5gZKx47mU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548393; c=relaxed/simple;
	bh=kAmGcrJJARJ5MfOWKV7UJy0WlVsn2cHCbZu8mzNFdew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J2HGhjodHVRiEkqIHIHOmuMUfZ9VnaBylnwCpumBaSwvYdyzdGsV8OWrj/M+3zPnqyEmlcjunNRpQ0/6YZZwbtVPRjs1nCmexXmy5JxK/orvTT8d1KaJMw3ZokNbyRfyhLC9CnjP8QGjiHfN/qm81GTOl2Igqg1s1/7Q+6RrW9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oyXj/KWy; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oyXj/KWy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AB35C433A6;
	Mon, 29 Jan 2024 17:13:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548393;
	bh=kAmGcrJJARJ5MfOWKV7UJy0WlVsn2cHCbZu8mzNFdew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oyXj/KWyKPkGwSds+bFK4IM38Fr9QXX81G0BRNzC4BXAM2Sow2RatdL4Rl4KNG4v7
	 8s9EMwvvYPSY/ObRjilasuyiZLM7Ms1uMw925thM/a8amn6cwPCOK2Ly5wM49t4Kmv
	 Vsd14MPIMtEUZm+nGPaY/6VOem8GVJb5ze7ifJxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bingbu Cao <bingbu.cao@intel.com>,
	Sakari Ailus <sakari.ailus@linux.intel.com>,
	Hans Verkuil <hverkuil-cisco@xs4all.nl>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 144/185] media: ov13b10: Enable runtime PM before registering async sub-device
Date: Mon, 29 Jan 2024 09:05:44 -0800
Message-ID: <20240129170003.213698233@linuxfoundation.org>
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

[ Upstream commit 7b0454cfd8edb3509619407c3b9f78a6d0dee1a5 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/media/i2c/ov13b10.c | 14 +++++++++-----
 1 file changed, 9 insertions(+), 5 deletions(-)

diff --git a/drivers/media/i2c/ov13b10.c b/drivers/media/i2c/ov13b10.c
index 722f490f9db4..368a3c2bfe34 100644
--- a/drivers/media/i2c/ov13b10.c
+++ b/drivers/media/i2c/ov13b10.c
@@ -1439,24 +1439,27 @@ static int ov13b10_probe(struct i2c_client *client)
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
@@ -1476,6 +1479,7 @@ static void ov13b10_remove(struct i2c_client *client)
 	ov13b10_free_controls(ov13b);
 
 	pm_runtime_disable(&client->dev);
+	pm_runtime_set_suspended(&client->dev);
 }
 
 static const struct dev_pm_ops ov13b10_pm_ops = {
-- 
2.43.0



