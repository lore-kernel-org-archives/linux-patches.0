Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B418A12CDA5;
	Tue, 26 Aug 2025 12:49:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756212548; cv=none; b=OxtR7s7rrWfvrT/g6F64SD5LzH8H4+1mzG0m3U5kK6q1Dutk5gr8t+f7RFiwVpuTXvbPkjC7MQBJ8vSXHmsk0+24AZnYqPFoRi8awArJ+ucyuLm9zOgTufF4HlNSi34HeQ2xmj+ucrrrdkyB8y/MkhUrv+hrWaMuiZSZYMnYqr4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756212548; c=relaxed/simple;
	bh=Ztn/ro1daLm7898MIOY774CGr9vPCgAgUGU1GpPpzYk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=G3VNpVK2C6yAAZAvqvsuXxU7WcevcMsvLjgtCzAdPyP6hHRtBdmI34QvareeVT2xQ0t4+s0Oy64/6APnFscQFgbs67ntAjeGHkJilgNFU+PJPrW8I2IKoGoLN5OCN462k1k4pxsGXsc/KrbByKjBssN6G7vUMWKWqa5N+v7kr6o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tLp/1Bv7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tLp/1Bv7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E09BAC113CF;
	Tue, 26 Aug 2025 12:49:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756212548;
	bh=Ztn/ro1daLm7898MIOY774CGr9vPCgAgUGU1GpPpzYk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tLp/1Bv7kLO0PxAyt1iOUQ5OMs7NhWl2sj6DQZxUj6mlGC7dn5m/F68eAlCY6phWj
	 sewmvqYpVYxoPcQvSDDVeu7LDg0O33nzKjv3zdv1bdNU+QDVpYLLs699YQU1gbUu2V
	 qpMVg/N59LEoC4RQ4H8QxlWojCnAl6UXsIFUtvp0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Daniel Golle <daniel@makrotopia.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.6 012/587] Revert "leds: trigger: netdev: Configure LED blink interval for HW offload"
Date: Tue, 26 Aug 2025 13:02:41 +0200
Message-ID: <20250826110953.264887760@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Golle <daniel@makrotopia.org>

commit 26f732791f2bcab18f59c61915bbe35225f30136 upstream.

This reverts commit c629c972b310af41e9e072febb6dae9a299edde6.

While .led_blink_set() would previously put an LED into an unconditional
permanently blinking state, the offending commit now uses same operation
to (also?) set the blink timing of the netdev trigger when offloading.

This breaks many if not all of the existing PHY drivers which offer
offloading LED operations, as those drivers would just put the LED into
blinking state after .led_blink_set() has been called.

Unfortunately the change even made it into stable kernels for unknown
reasons, so it should be reverted there as well.

Fixes: c629c972b310a ("leds: trigger: netdev: Configure LED blink interval for HW offload")
Link: https://lore.kernel.org/linux-leds/c6134e26-2e45-4121-aa15-58aaef327201@lunn.ch/T/#m9d6fe81bbcb273e59f12bbedbd633edd32118387
Suggested-by: Andrew Lunn <andrew@lunn.ch>
Cc: stable@vger.kernel.org
Signed-off-by: Daniel Golle <daniel@makrotopia.org>
Reviewed-by: Andrew Lunn <andrew@lunn.ch>
Link: https://lore.kernel.org/r/6dcc77ee1c9676891d6250d8994850f521426a0f.1752334655.git.daniel@makrotopia.org
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/leds/trigger/ledtrig-netdev.c |   16 +++-------------
 1 file changed, 3 insertions(+), 13 deletions(-)

--- a/drivers/leds/trigger/ledtrig-netdev.c
+++ b/drivers/leds/trigger/ledtrig-netdev.c
@@ -54,7 +54,6 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
-	unsigned long blink_delay;
 	int link_speed;
 	u8 duplex;
 
@@ -70,10 +69,6 @@ static void set_baseline_state(struct le
 	/* Already validated, hw control is possible with the requested mode */
 	if (trigger_data->hw_control) {
 		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
-		if (led_cdev->blink_set) {
-			led_cdev->blink_set(led_cdev, &trigger_data->blink_delay,
-					    &trigger_data->blink_delay);
-		}
 
 		return;
 	}
@@ -391,11 +386,10 @@ static ssize_t interval_store(struct dev
 			      size_t size)
 {
 	struct led_netdev_data *trigger_data = led_trigger_get_drvdata(dev);
-	struct led_classdev *led_cdev = trigger_data->led_cdev;
 	unsigned long value;
 	int ret;
 
-	if (trigger_data->hw_control && !led_cdev->blink_set)
+	if (trigger_data->hw_control)
 		return -EINVAL;
 
 	ret = kstrtoul(buf, 0, &value);
@@ -404,13 +398,9 @@ static ssize_t interval_store(struct dev
 
 	/* impose some basic bounds on the timer interval */
 	if (value >= 5 && value <= 10000) {
-		if (trigger_data->hw_control) {
-			trigger_data->blink_delay = value;
-		} else {
-			cancel_delayed_work_sync(&trigger_data->work);
+		cancel_delayed_work_sync(&trigger_data->work);
 
-			atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
-		}
+		atomic_set(&trigger_data->interval, msecs_to_jiffies(value));
 		set_baseline_state(trigger_data);	/* resets timer */
 	}
 


