Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CD68F34250E;
	Sat, 12 Sep 2026 18:59:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789239564; cv=none; b=Hi/VBG/Zk+E9v2l3I8Mpn/OwcWsyFb6n+DAMAEV3WnIJy/yDrrHqF59UJq+n1gCtgSN/ZBUWHh2Ybre9EhsJc9LsyTeoWklWWH3hgU6aaNN9NnTq/W907428lLgCZzjYWSmC1PqD/TJ1fy9tTt4zJoTQkcZl0VaAArgOgvFPV5k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789239564; c=relaxed/simple;
	bh=SIOO1+e5wk4g/8i+e7/Eg7lbXjAapIeEpF0QW04TTBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S8RXA8DpYVsjqvZniKs3CF2da4PARYcY/Ma6bdqEGukCHVbF8BcJeckaZf22xmKOCBp+Akivnbt0oN+xh4shFx+IlQaiOg4FiWgKRVvtathdIn5Ckn0X+IIEo4jXex2Szm0gMyHA2uR9tjlEHtYJ/68MLMl0KLdznCyOFdGcKfA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UXsvxmP1; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UXsvxmP1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 888FE1F000FF;
	Sat, 12 Sep 2026 18:59:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789239563;
	bh=uylMfDVjwzsTtSyCeyik97TmChZOJCM5LvoYQq6A0Dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UXsvxmP13ha2Cjrb6Q9jtNjx9lhknvfi85py2lliWgWJdO3oEJLREfK29VcryDAPT
	 L123jdQJbAEsyirFaVt27e9tT59OwLm3HbdSfV4CxGHECoxpOj8dYJ/7WIN/yd7qSl
	 0CaYgSdho/0HVsMl4MDtKVV9tdIJRQTKNB/FqURE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 691/935] pps: clients: gpio: Bypass edges direction check when not needed
Date: Sat, 12 Sep 2026 09:02:01 +0200
Message-ID: <20260912065542.689336078@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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



