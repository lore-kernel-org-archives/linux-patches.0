Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3C51747CA9D;
	Sat, 12 Sep 2026 12:49:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789217344; cv=none; b=B0Nt3BtUPbP3w6eKu36vSo+EjxWsc8VmHocCcXyBf5elAtTQvdrzabxTCQByKa+fn+NI7DxhKnPvW7AqemRrourYH1Ioj5D0BkUu9FPOA8BR21OcIUxfZj1llqx6V9aaP2+XR+nYQ+sZxlleMEH5+Xt0HPSp4ZtwktSRSodre28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789217344; c=relaxed/simple;
	bh=aSA9/adKvUePSyWXLHtojmnEDpPKvXQuk/ZapDlsg5o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hDo7CajJKSsldFes5Eumxq9fxdU7Mx9aMVVLHmdANCt+xs2dCd7MkGcURB60Q41bRiQ2rWJEz+sYa9eSGYeoBKhcZup5Oe01yOp09KOao1O6uPGtRwAIfoXBLvl7vTJbJctwJSQHkJS4rYv4RLhwdHzdSixUw3NqJlJMwoIp5+w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XB5WEP1g; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XB5WEP1g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 167281F000FF;
	Sat, 12 Sep 2026 12:48:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789217341;
	bh=lIIFemAGLc2JS9QAOsF4KO8BuOnWQiYXOe7JLElGSmw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XB5WEP1gOZaM9ieZS05YpKwOWnvlI2s/SS/WKo1PBKGbOU5cMuURwWwaGAdJNuXXx
	 pwFxuDWBjnwhZYVz/zzrZVdQez6KDbjNYi0T+vEUKx2lYJ5wd5XiXvrqyUlFkn40/c
	 DLZ9RjC/nPGGsEw6HaeCrGZ55uUywJuGW3PTUcZ0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bastien Curutchet <bastien.curutchet@bootlin.com>,
	Rodolfo Giometti <giometti@enneenne.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0884/1376] pps: clients: gpio: Bypass edges direction check when not needed
Date: Sat, 12 Sep 2026 08:55:10 +0200
Message-ID: <20260912065627.265785956@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065607.535295758@linuxfoundation.org>
References: <20260912065607.535295758@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 1412f8af15f27..027759e2d563c 100644
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



