Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3482C235C;
	Mon, 18 Aug 2025 13:44:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755524650; cv=none; b=NqVMrnDXCov1z2YfY30ik2oc46qWy4ZGHeSpx6gpxd4PTMDEfh6Jl4yMIHNQyQpiteJcRtAV40BTJWRd35NQKP+Z1W9Mdk3cyd+TyZZzNFYgXtCTnGjJj3ME4+dfOouG8yto83IhYcrifaZw1NZlxj4oqPRGy5pGS2PkvUEM9kA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755524650; c=relaxed/simple;
	bh=nDnncTnffQOWOAhvcuHSG7KXhKIpZu1ihgN8b+I3oE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mClJgtBY51fR657gZ+9ccMT4afW7TK/VhvSFq0qRpSvnKFpAI+QgNHge4T+fdM6zFChqzHVj1y79G3MzNf7TTrmM/wMekwKVoj+waPO597P4pbsF4IqZUpvhCeKTLndjkUg8srQhM7NZaoyYWwUex5C9PEh8X38PfTG/DvAZKEo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KesXLr3J; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KesXLr3J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57E2C4CEEB;
	Mon, 18 Aug 2025 13:44:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755524650;
	bh=nDnncTnffQOWOAhvcuHSG7KXhKIpZu1ihgN8b+I3oE8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KesXLr3JxbjGR8yC2UWnSsr4J4zFoAx9RVWKnBEJ5JvYHQJa0+MPes9eiuA78PlA3
	 lM8m81wp7XC6I5hLX/rZ+at9JuM18aLItP1t0nXxfe4//wZRDAS34fJigftU7CgkQF
	 1K7JiAbuEyJxAfTTf7vI0Axdx/X08Z7jKLwXTGok=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Lunn <andrew@lunn.ch>,
	Daniel Golle <daniel@makrotopia.org>,
	Lee Jones <lee@kernel.org>
Subject: [PATCH 6.16 020/570] Revert "leds: trigger: netdev: Configure LED blink interval for HW offload"
Date: Mon, 18 Aug 2025 14:40:07 +0200
Message-ID: <20250818124506.576029706@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124505.781598737@linuxfoundation.org>
References: <20250818124505.781598737@linuxfoundation.org>
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

6.16-stable review patch.  If anyone has any objections, please let me know.

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
@@ -68,7 +68,6 @@ struct led_netdev_data {
 	unsigned int last_activity;
 
 	unsigned long mode;
-	unsigned long blink_delay;
 	int link_speed;
 	__ETHTOOL_DECLARE_LINK_MODE_MASK(supported_link_modes);
 	u8 duplex;
@@ -87,10 +86,6 @@ static void set_baseline_state(struct le
 	/* Already validated, hw control is possible with the requested mode */
 	if (trigger_data->hw_control) {
 		led_cdev->hw_control_set(led_cdev, trigger_data->mode);
-		if (led_cdev->blink_set) {
-			led_cdev->blink_set(led_cdev, &trigger_data->blink_delay,
-					    &trigger_data->blink_delay);
-		}
 
 		return;
 	}
@@ -459,11 +454,10 @@ static ssize_t interval_store(struct dev
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
@@ -472,13 +466,9 @@ static ssize_t interval_store(struct dev
 
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
 


