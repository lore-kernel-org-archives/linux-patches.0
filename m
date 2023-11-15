Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1B8328369
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 20:51:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zG1/f4PP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54630C4E67F;
	Wed, 15 Nov 2023 20:51:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700081466;
	bh=kKzLY8JNtX19yg7LKFus0C4qzH6jfDlb6xamgCTRT/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zG1/f4PPC9hgNDXmzRj4VJj6u3VBi92ryP+P0+5HYujP5jxb1zuWp93QYyFLPLBIN
	 7cMXTgyZ7VI6Tjfo+lOEUmPAOeFzXEiwjhNHBp1UqiDHMjn/SCs0ivpZdpNNW3LujH
	 qZ9qsgM+8ISDQCtXRyVdBFd8F1SsnBPdixzKrbdk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Marek=20Beh=C3=BAn?= <kabel@kernel.org>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 163/244] leds: turris-omnia: Drop unnecessary mutex locking
Date: Wed, 15 Nov 2023 15:35:55 -0500
Message-ID: <20231115203558.129012240@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115203548.387164783@linuxfoundation.org>
References: <20231115203548.387164783@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marek Behún <kabel@kernel.org>

[ Upstream commit 760b6b7925bf09491aafa4727eef74fc6bf738b0 ]

Do not lock driver mutex in the global LED panel brightness sysfs
accessors brightness_show() and brightness_store().

The mutex locking is unnecessary here. The I2C transfers are guarded by
I2C core locking mechanism, and the LED commands itself do not interfere
with other commands.

Fixes: 089381b27abe ("leds: initial support for Turris Omnia LEDs")
Signed-off-by: Marek Behún <kabel@kernel.org>
Reviewed-by: Lee Jones <lee@kernel.org>
Link: https://lore.kernel.org/r/20230802160748.11208-2-kabel@kernel.org
Signed-off-by: Lee Jones <lee@kernel.org>
Stable-dep-of: 6de283b96b31 ("leds: turris-omnia: Do not use SMBUS calls")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/leds-turris-omnia.c | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/drivers/leds/leds-turris-omnia.c b/drivers/leds/leds-turris-omnia.c
index 1adfed1c0619b..c9e7c467e5acd 100644
--- a/drivers/leds/leds-turris-omnia.c
+++ b/drivers/leds/leds-turris-omnia.c
@@ -156,12 +156,9 @@ static ssize_t brightness_show(struct device *dev, struct device_attribute *a,
 			       char *buf)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct omnia_leds *leds = i2c_get_clientdata(client);
 	int ret;
 
-	mutex_lock(&leds->lock);
 	ret = i2c_smbus_read_byte_data(client, CMD_LED_GET_BRIGHTNESS);
-	mutex_unlock(&leds->lock);
 
 	if (ret < 0)
 		return ret;
@@ -173,7 +170,6 @@ static ssize_t brightness_store(struct device *dev, struct device_attribute *a,
 				const char *buf, size_t count)
 {
 	struct i2c_client *client = to_i2c_client(dev);
-	struct omnia_leds *leds = i2c_get_clientdata(client);
 	unsigned long brightness;
 	int ret;
 
@@ -183,15 +179,10 @@ static ssize_t brightness_store(struct device *dev, struct device_attribute *a,
 	if (brightness > 100)
 		return -EINVAL;
 
-	mutex_lock(&leds->lock);
 	ret = i2c_smbus_write_byte_data(client, CMD_LED_SET_BRIGHTNESS,
 					(u8)brightness);
-	mutex_unlock(&leds->lock);
-
-	if (ret < 0)
-		return ret;
 
-	return count;
+	return ret < 0 ? ret : count;
 }
 static DEVICE_ATTR_RW(brightness);
 
-- 
2.42.0



