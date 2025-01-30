Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE15D1E571B;
	Thu, 30 Jan 2025 14:01:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738245705; cv=none; b=ahagfXwbINglP2c3Vpre1eNgkpXct/dNbZFWUnGqrrnyNr//dS4w9h7TM3BdREA0OoScQM0LnN2FPauvSabzxmNi1cH5jIInllyx4ftuB0kkM/zwjDU/pv6FrYH8J24uh90L3Hx8SMio5OznQZBANFoW4y6LZtsNuUCVdNJOrjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738245705; c=relaxed/simple;
	bh=T7y4KmHOywGts9kAK9w0T+anEluJq1CjmqIgEeFVZzo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LFjQnrpliPSJUCnBa7WWe8LYukKZq5t6Y20WVgw6Z9kAicKJFtGZDaNkPNdv/mNd+4I5YQtJRl/RkslE1kwGkU0/+m9ylPvvR7jn6C5vrViDd0h5h/xgBItlloNTOOBAH4jQsZJg+cFNBPfyklD3u/2jdxJ5y7JdxDQRDK0CBcM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kl+4XlxQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kl+4XlxQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 337B7C4CED2;
	Thu, 30 Jan 2025 14:01:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738245705;
	bh=T7y4KmHOywGts9kAK9w0T+anEluJq1CjmqIgEeFVZzo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kl+4XlxQROfHPBaAlwpHyj87MuHF8GEv9TTpdpDgjhyiX6Up5EQbVi9rS7Dr5ybhw
	 oML5DNhy4ohPt7T66qSP+kKxqZwoMSFR98bvaPPLpnKAJ1j6AKF+e3wlggNl5kOHAb
	 OcNr6EHZIwXJRnzHk/EJ6DyQuTAUeZoOIG1RUhuA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jason Gerecke <jason.gerecke@wacom.com>,
	Jiri Kosina <jkosina@suse.com>
Subject: [PATCH 6.12 33/40] HID: wacom: Initialize brightness of LED trigger
Date: Thu, 30 Jan 2025 14:59:33 +0100
Message-ID: <20250130133501.030376782@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130133459.700273275@linuxfoundation.org>
References: <20250130133459.700273275@linuxfoundation.org>
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

From: Jason Gerecke <jason.gerecke@wacom.com>

commit 88006b8eca63467cf1b28fed839f4954c578eeff upstream.

If an LED has a default_trigger set prior to being registered with
the subsystem, that trigger will be executed with a brightness value
defined by `trigger->brightness`. Our driver was not setting this
value, which was causing problems. It would cause the selected LED
to be turned off, as well as corrupt the hlv/llv values assigned to
other LEDs (since calling `wacom_led_brightness_set` will overite
these values).

This patch sets the value of `trigger->brightness` to an appropriate
value. We use `wacom_leds_brightness_get` to transform the llv/hlv
values into a brightness that is understood by the rest of the LED
subsystem.

Fixes: 822c91e72eac ("leds: trigger: Store brightness set by led_trigger_event()")
Cc: stable@vger.kernel.org # v6.10+
Signed-off-by: Jason Gerecke <jason.gerecke@wacom.com>
Signed-off-by: Jiri Kosina <jkosina@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/hid/wacom_sys.c | 24 +++++++++++++-----------
 1 file changed, 13 insertions(+), 11 deletions(-)

diff --git a/drivers/hid/wacom_sys.c b/drivers/hid/wacom_sys.c
index 9843b52bd017..34428349fa31 100644
--- a/drivers/hid/wacom_sys.c
+++ b/drivers/hid/wacom_sys.c
@@ -1370,17 +1370,6 @@ static int wacom_led_register_one(struct device *dev, struct wacom *wacom,
 	if (!name)
 		return -ENOMEM;
 
-	if (!read_only) {
-		led->trigger.name = name;
-		error = devm_led_trigger_register(dev, &led->trigger);
-		if (error) {
-			hid_err(wacom->hdev,
-				"failed to register LED trigger %s: %d\n",
-				led->cdev.name, error);
-			return error;
-		}
-	}
-
 	led->group = group;
 	led->id = id;
 	led->wacom = wacom;
@@ -1397,6 +1386,19 @@ static int wacom_led_register_one(struct device *dev, struct wacom *wacom,
 		led->cdev.brightness_set = wacom_led_readonly_brightness_set;
 	}
 
+	if (!read_only) {
+		led->trigger.name = name;
+		if (id == wacom->led.groups[group].select)
+			led->trigger.brightness = wacom_leds_brightness_get(led);
+		error = devm_led_trigger_register(dev, &led->trigger);
+		if (error) {
+			hid_err(wacom->hdev,
+				"failed to register LED trigger %s: %d\n",
+				led->cdev.name, error);
+			return error;
+		}
+	}
+
 	error = devm_led_classdev_register(dev, &led->cdev);
 	if (error) {
 		hid_err(wacom->hdev,
-- 
2.48.1



