Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC2A0611A
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:21:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 577C5C433EF;
	Sun, 28 May 2023 19:21:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685301714;
	bh=fZUjUDUwl+0wf6fiTBhQogCacXsy0ba9RJ4QepBYLbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JXvkKCTtR/OblTN/1H6v5Up/mGCQYc7dQi56LZ6fbldw6GfDTEiMT60M4Curm7fCY
	 7bR2e1hazNAPlElqK3BAAF/LT2ozur1rFqBh9r1TuoqklYafwo1vWzlkPqP3KwXyqe
	 fK4z0yymqRwqy54ZJ1qNZKF+t3emKqRJku3aMTGQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hans de Goede <hdegoede@redhat.com>,
	Vasily Khoruzhick <anarsoul@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>
Subject: [PATCH 4.19 122/132] power: supply: leds: Fix blink to LED on transition
Date: Sun, 28 May 2023 20:11:01 +0100
Message-Id: <20230528190837.573382493@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190833.565872088@linuxfoundation.org>
References: <20230528190833.565872088@linuxfoundation.org>
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
@@ -35,8 +35,9 @@ static void power_supply_update_bat_leds
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


