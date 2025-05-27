Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 547C5194A67;
	Tue, 27 May 2025 16:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365075; cv=none; b=tvWEcMYolYEC++KeE8wVn+XvRn6xUnUxroWyG3FPH/NrhSgJIbLRdYTN012cwhNJkCNmkYn+yKXZv5yDYAwwyQYMFkSpz6+rSIADhwNSPxnzXcJY8/hP64IPIxmIOqxpDW+tU4iHdj+d9nK9Ef3R6SwUCVvGpADwfMqRsgy1Pak=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365075; c=relaxed/simple;
	bh=gkoKrlpKCKe2AkWFXSpeardISNvA2tHxITcDMkadICM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oluXoLUDBjrbe+S06cUKZVV2OS+BdStiPfP33aIvLh4ae3lF0AxW1XiCxPLo35M4Wk/XAx/FMO6pqptac7dLsL40+JOfBqHxKG54GXfkPKu5pLq2smzNAQIEeY+BFpg16uKxVL5Q820McPKa5VPSvlFPlG9Fl2erYPvIpz8mvJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LGBWxt8N; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LGBWxt8N"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8927C4CEE9;
	Tue, 27 May 2025 16:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365075;
	bh=gkoKrlpKCKe2AkWFXSpeardISNvA2tHxITcDMkadICM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LGBWxt8Nd4QpTIalFQgx+xLMoIiHbgF2Pr5LoMTwpaDYp2DFKJW/4e9CEJuhY1W9N
	 hrYtY31Zwimc0nhSfmmlavNaeBs5FSsqzMqFliRi6Bvv1RmOtXXUoThvSIVKrB24f6
	 M1xgu2WJsmXnLBCWQ9Cz2uRLJJB2x9HjEme0nkQo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 260/626] hwmon: (gpio-fan) Add missing mutex locks
Date: Tue, 27 May 2025 18:22:33 +0200
Message-ID: <20250527162455.575926939@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 9fee7d19bab635f89223cc40dfd2c8797fdc4988 ]

set_fan_speed() is expected to be called with fan_data->lock being locked.
Add locking for proper synchronization.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Link: https://lore.kernel.org/r/20250210145934.761280-3-alexander.stein@ew.tq-group.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/gpio-fan.c | 16 +++++++++++++++-
 1 file changed, 15 insertions(+), 1 deletion(-)

diff --git a/drivers/hwmon/gpio-fan.c b/drivers/hwmon/gpio-fan.c
index d92c536be9af7..b779240328d59 100644
--- a/drivers/hwmon/gpio-fan.c
+++ b/drivers/hwmon/gpio-fan.c
@@ -393,7 +393,12 @@ static int gpio_fan_set_cur_state(struct thermal_cooling_device *cdev,
 	if (state >= fan_data->num_speed)
 		return -EINVAL;
 
+	mutex_lock(&fan_data->lock);
+
 	set_fan_speed(fan_data, state);
+
+	mutex_unlock(&fan_data->lock);
+
 	return 0;
 }
 
@@ -489,7 +494,11 @@ MODULE_DEVICE_TABLE(of, of_gpio_fan_match);
 
 static void gpio_fan_stop(void *data)
 {
+	struct gpio_fan_data *fan_data = data;
+
+	mutex_lock(&fan_data->lock);
 	set_fan_speed(data, 0);
+	mutex_unlock(&fan_data->lock);
 }
 
 static int gpio_fan_probe(struct platform_device *pdev)
@@ -562,7 +571,9 @@ static int gpio_fan_suspend(struct device *dev)
 
 	if (fan_data->gpios) {
 		fan_data->resume_speed = fan_data->speed_index;
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, 0);
+		mutex_unlock(&fan_data->lock);
 	}
 
 	return 0;
@@ -572,8 +583,11 @@ static int gpio_fan_resume(struct device *dev)
 {
 	struct gpio_fan_data *fan_data = dev_get_drvdata(dev);
 
-	if (fan_data->gpios)
+	if (fan_data->gpios) {
+		mutex_lock(&fan_data->lock);
 		set_fan_speed(fan_data, fan_data->resume_speed);
+		mutex_unlock(&fan_data->lock);
+	}
 
 	return 0;
 }
-- 
2.39.5



