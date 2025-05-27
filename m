Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0244926868E;
	Tue, 27 May 2025 17:06:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365593; cv=none; b=YTNUNApzt79vWLvlV1ylnqSrzR3CnwugjUm82QzNoa3ftHGmMe14Pkqhmfv8aYcyvu3I5zYR70tYpTsPJjM8oWyk9DYVgUPI9L3i1LBXR2dwq9JTSYSn8EpCOyD+SL0naydQOuoFBANW31ZjWa7fW3b6E6KsCFBG15ZejUJXWrQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365593; c=relaxed/simple;
	bh=Bhj1B2vZSNPOf4Tjj9ZiiG9LTJG+Ze3/AhRI8eHGqFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jSz4nH0hMjjpt+e3m21lXlbRlGBhEu8SIcQVg7eEdbjPPy+eUfIYYvy9JX+GCOVKoS59efODNoop691oSQTxRDo0iqrEeWkDs6V0ykRDsnKcDsXaJruuJluEtyiZxsHZej/+W5ILllcMk2tC9Ng1wLbOJrsMVzy+QCYwO+nO34M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GQxcTgKY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GQxcTgKY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57A62C4CEE9;
	Tue, 27 May 2025 17:06:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365592;
	bh=Bhj1B2vZSNPOf4Tjj9ZiiG9LTJG+Ze3/AhRI8eHGqFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GQxcTgKYgzvGBXkqTgwTfjdD1/mUwI9zoSjWMcZToqPEZE/4gRTIABOrRoyZ71s78
	 yT3W/9h15pneHa+2V/aul6zKSq+VBquEpx601aAqnEMTp1YzaoC3jICt2K9NRfnkFX
	 jAa6XZ+4cDuFFV9fG1/wqsQvg1kxkC1F8QD3hFGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marek Vasut <marex@denx.de>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 427/626] leds: trigger: netdev: Configure LED blink interval for HW offload
Date: Tue, 27 May 2025 18:25:20 +0200
Message-ID: <20250527162502.362964645@linuxfoundation.org>
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

From: Marek Vasut <marex@denx.de>

[ Upstream commit c629c972b310af41e9e072febb6dae9a299edde6 ]

In case a PHY LED implements .blink_set callback to set LED blink
interval, call it even if .hw_control is already set, as that LED
blink interval likely controls the blink rate of that HW offloaded
LED. For PHY LEDs, that can be their activity blinking interval.

The software blinking is not affected by this change.

With this change, the LED interval setting looks something like this:
$ echo netdev > /sys/class/leds/led:green:lan/trigger
$ echo 1 > /sys/class/leds/led:green:lan/brightness
$ echo 250 > /sys/class/leds/led:green:lan/interval

Signed-off-by: Marek Vasut <marex@denx.de>
Link: https://lore.kernel.org/r/20250120113740.91807-1-marex@denx.de
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/leds/trigger/ledtrig-netdev.c | 16 +++++++++++++---
 1 file changed, 13 insertions(+), 3 deletions(-)

diff --git a/drivers/leds/trigger/ledtrig-netdev.c b/drivers/leds/trigger/ledtrig-netdev.c
index 4b0863db901a9..356a55ced2c28 100644
--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -68,6 +68,7 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
+	unsigned long blink_delay;
 	int link_speed;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_link_modes);
 	u8 duplex;
@@ -86,6 +87,10 @@ static void set_baseline_state(struct led_netdev_data *trigger_data)
 	/* Already validated, hw control is possible with the requested mode */
 	if (trigger_data->hw_control) {
 		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
+		if (led_cdev->blink_set) {
+			led_cdev->blink_set(led_cdev, &trigger_data->blink_delay,
+					    &trigger_data->blink_delay);
+		}
 
 		return;
 	}
@@ -454,10 +459,11 @@ static ssize_t interval_store(struct device *dev,
 			      size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
+	struct led_classdev *led_cdev = trigger_data->led_cdev;
 	unsigned long value;
 	int ret;
 
-	if (trigger_data->hw_control)
+	if (trigger_data->hw_control && !led_cdev->blink_set)
 		return -EINVAL;
 
 	ret = kstrtoul(buf, 0, &value);
@@ -466,9 +472,13 @@ static ssize_t interval_store(struct device *dev,
 
 	/* impose some basic bounds on the timer interval */
 	if (value >= 5 && value <= 10000) {
-		cancel_delayed_work_sync(&trigger_data->work);
+		if (trigger_data->hw_control) {
+			trigger_data->blink_delay = value;
+		} else {
+			cancel_delayed_work_sync(&trigger_data->work);
 
-		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
+			atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
+		}
 		set_baseline_state(trigger_data);	/* resets timer */
 	}
 
-- 
2.39.5



