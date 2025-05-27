Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 984303C01;
	Tue, 27 May 2025 17:35:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748367314; cv=none; b=lUPu3d+wJ/YcTN+UNiZu7GuozHXwoVlu4WW8WPT35676m2Lqx6xmHHdh3HRk3WG5L63kVAMCR3Vd0T7SSqXT+8fES5b2uW+vYeiiUXfhXFqafdeXEvyaF9VkszkAOe216cMEdPhNvXcQrAKp7++xQ7FqMShweeP1K7LBnAXn7gs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748367314; c=relaxed/simple;
	bh=Fv7ApyDZW9+qACUCUIMROkshDmcJj+TxmjZr8dkehDI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BFco0C3a46IkXXr9xNR3laiwhezqcaC5rK2EX4cRwy5IqbvNTzks0hnmsQSAmmheYWM69tQxx0RBdgpbe6wGQhda/1oiwRyLFwLO1GkAiriTBE39ZeJBh8BlavI2hGm+ZNAUFreIfpmKPSSZCqwxOQePI0cMhXWwS4jhkmXsXRI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WfABeZux; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WfABeZux"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 07E0AC4CEE9;
	Tue, 27 May 2025 17:35:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748367314;
	bh=Fv7ApyDZW9+qACUCUIMROkshDmcJj+TxmjZr8dkehDI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WfABeZux4jbahLFXv1BaIXMT9Y7+BIxvxNLFfoASABixLvSy/iPnvGMc/U9d7XNyE
	 tCSgvKg9i6rKpuJb13fTVi8HtrTrfoquVyuvaJEQH+K4nJBzC5oE04W5cppNsPcbCX
	 aVmVFTlRSjkTSoLio/ZLeEAt9Tau59x41AYsDNPY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 317/783] hwmon: (gpio-fan) Add missing mutex locks
Date: Tue, 27 May 2025 18:21:54 +0200
Message-ID: <20250527162525.973682634@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



