Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2C6CC611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:37:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE4C6C433EF;
	Sun, 28 May 2023 19:37:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302678;
	bh=NzSuCDquSRyGSL/9He700VpgzWy155VEdg4950KBWAo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UMTVYnoczksHtoFWfIwAS5OJWkl4AEh3mxbWVaijizODPq21Fuwkx0wfpLaMudm90
	 bbCPbKNkI8k8qS9u/gyNcZMO/WUv+Yz1v5XzEXUVlLjcQRqILV4JjKrqlYRbPRkkmc
	 ndRU6KBm1kSgxJQ1+Rtz1DDUs84UuT7DcOLpk4BY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 6.1 073/119] power: supply: leds: Fix blink to LED on transition
Date: Sun, 28 May 2023 20:11:13 +0100
Message-Id: <20230528190837.947941349@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190835.386670951@linuxfoundation.org>
References: <20230528190835.386670951@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hans de Goede <hdegoede@redhat.com>

commit e4484643991e0f6b89060092563f0dbab9450cbb upstream.

When a battery's status changes from charging to full then
the charging-blink-full-solid trigger tries to change
the LED from blinking to solid/on.

As is documented in include/linux/leds.h to deactivate blinking /
to make the LED solid a LED_OFF must be send:

"""
         * Deactivate blinking again when the brightness is set to LED_OFF
         * via the brightness_set() callback.
"""

led_set_brighness() calls with a brightness value other then 0 / LED_OFF
merely change the brightness of the LED in its on state while it is
blinking.

So power_supply_update_bat_leds() must first send a LED_OFF event
before the LED_FULL to disable blinking.

Fixes: 6501f728c56f ("power_supply: Add new LED trigger charging-blink-solid-full")
Signed-off-by: Hans de Goede <hdegoede@redhat.com>
Reviewed-by: Vasily Khoruzhick <anarsoul@gmail.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/power/supply/power_supply_leds.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/power/supply/power_supply_leds.c
+++ b/drivers/power/supply/power_supply_leds.c
@@ -34,8 +34,9 @@ static void power_supply_update_bat_leds
 		led_trigger_event(psy->charging_full_trig, LED_FULL);
 		led_trigger_event(psy->charging_trig, LED_OFF);
 		led_trigger_event(psy->full_trig, LED_FULL);
-		led_trigger_event(psy->charging_blink_full_solid_trig,
-			LED_FULL);
+		/* Going from blink to LED on requires a LED_OFF event to stop blink */
+		led_trigger_event(psy->charging_blink_full_solid_trig, LED_OFF);
+		led_trigger_event(psy->charging_blink_full_solid_trig, LED_FULL);
 		break;
 	case POWER_SUPPLY_STATUS_CHARGING:
 		led_trigger_event(psy->charging_full_trig, LED_FULL);


