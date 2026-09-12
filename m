Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E3231FBEA6;
	Sat, 12 Sep 2026 16:32:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230749; cv=none; b=StOiB4oQw/tHesqu6CDyOv3nW3OV61eKKzXZ5FJc6+b+G8GhVGWwxLEYgDbFsX02hm0ouZDuwaT7OOiKK8Qd3EqByeE4T5IgAxWVOW5ZFp7QjSmhIHXRhM+0UZsaN8qRuF9qBzG3iJZCiRjsUI6g81HZo2u84JQ31tMGBzOZJAo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230749; c=relaxed/simple;
	bh=TYEP6PVnF33yCvF8ov4mVDYBKYKc6Liuh78BP9zEfz0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oM2dcWoxfW32/e8PuM4GpGNJ/+p2ApBJYct7fvYnf7xRjHJEPfh/DjNsqqkJj1ipGph5iAe8ENcPD22NyshBnt4yxn299byGHxgIyvw0wwg75aMXVGJGHbvhTZBE/qKN7XIRjxoND0EQOI9CSm6HBDqT1s4pDRN6rgEW7nUYLWg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qGBKfAme; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qGBKfAme"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6177E1F000FF;
	Sat, 12 Sep 2026 16:32:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230748;
	bh=iLFOF1dGPLwtdxP5lF+1fZjqvuyE75rTRKUGwJ7RqHQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qGBKfAmeYOm3g741+YutiJL000MlbWWJhS9ObIWZyVd0GplfEiqWMvq7WP1vSR4/C
	 IhUJaERRAEx6hhmIN+Vt/bySc3qXJXxjB0e4cIFdKSQrGJH08YdLBoFzhxhy+FImrX
	 VcRy+hD00++MSNZEA7l4UVAzpSIou6st5/vfS12M=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0857/1191] pps: clients: gpio: Bypass edges direction check when not needed
Date: Sat, 12 Sep 2026 08:59:45 +0200
Message-ID: <20260912065607.499475828@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Bastien Curutchet <bastien.curutchet@bootlin.com>

[ Upstream commit a01f6287c244f35eeec11ca932d09061181eed8c ]

In the IRQ handler, the GPIO's state is read to verify the direction of
the edge that triggered the interruption before generating the PPS event.
If a pulse is too short, the GPIO line can reach back its original state
before this verification and the PPS event is lost.

This check is needed when info->capture_clear is set because it needs
interruptions on both rising and falling edges. When info->capture_clear
is not set, interruption is triggered by one edge only so this check can
be omitted.

Add a warning if irq_handler is left without triggering any PPS event.
Bypass the edge's direction verification when info->capture_clear is not
set.

Signed-off-by: Bastien Curutchet <bastien.curutchet@bootlin.com>
Acked-by: Rodolfo Giometti <giometti@enneenne.com>
Link: https://lore.kernel.org/r/20250108153012.514925-1-bastien.curutchet@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: b899e0279f90 ("pps-gpio: remove dead capture_clear code")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pps/clients/pps-gpio.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/pps/clients/pps-gpio.c b/drivers/pps/clients/pps-gpio.c
index 41e1fdbcda165..dbe598d092099 100644
--- a/drivers/pps/clients/pps-gpio.c
+++ b/drivers/pps/clients/pps-gpio.c
@@ -52,7 +52,9 @@ static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
 
 	info = data;
 
-	rising_edge = gpiod_get_value(info->gpio_pin);
+	/* Small trick to bypass the check on edge's direction when capture_clear is unset */
+	rising_edge = info->capture_clear ?
+		      gpiod_get_value(info->gpio_pin) : !info->assert_falling_edge;
 	if ((rising_edge && !info->assert_falling_edge) ||
 			(!rising_edge && info->assert_falling_edge))
 		pps_event(info->pps, &ts, PPS_CAPTUREASSERT, data);
@@ -60,6 +62,8 @@ static irqreturn_t pps_gpio_irq_handler(int irq, void *data)
 			((rising_edge && info->assert_falling_edge) ||
 			(!rising_edge && !info->assert_falling_edge)))
 		pps_event(info->pps, &ts, PPS_CAPTURECLEAR, data);
+	else
+		dev_warn_ratelimited(&info->pps->dev, "IRQ did not trigger any PPS event\n");
 
 	return IRQ_HANDLED;
 }
-- 
2.53.0



