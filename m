Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6C327344D9A
	for <patches@lists.linux.dev>; Sat, 28 Feb 2026 18:03:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772301833; cv=none; b=p+AVvG+UKojACBDs+P5qfyk3X00GBL4kSToHY+5740YnTwxF7XS3RSw6PGCga32IgQnynuN1mzd7pXQX7828e6X3dktG5yHcntPr3JfEJP9eUo7/FJLFcz0Kc7BmL0/S/we/N+5KwJ74vm233g8MaQwlF+LFhkVTu09uC2fEg2k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772301833; c=relaxed/simple;
	bh=r4u2AXCUttS2OPXyrbE0lR+nhVlG5qpDTYhYpp7jquk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JbMsUqviQmfT5GUP+dSiISvl7lslvO72urXGkYzdsjpQj7oBPt7julziQg6hVBGeg0L5FOJmTj+l9vJuTItNOKNhxqKyB/obhOwYXdIgpnlodMVCqPt35luAnu5/4e0aekbLp004AW8iCwl1CsDmnX+ndiKlAZzUB5GeE5S907M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZwJuL/V1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZwJuL/V1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BA3AAC19423;
	Sat, 28 Feb 2026 18:03:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1772301833;
	bh=r4u2AXCUttS2OPXyrbE0lR+nhVlG5qpDTYhYpp7jquk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwJuL/V1i3IeeDssuTVZDrJn+OihGWQPXZP7eW61q3OgFgev4c5fnXfOWfp1fDdVD
	 y0Zmnl/FlpgUrdYUgTzHnDSrtnkZqrd1mznf8DaRgy/RoGlcpl3cWr0cfZqH1+XALD
	 xff2lIhXPOtLMmJRxj5f7o8tzaNS8GA8uJFYXhaliP9MGkiwQu5r5PH1+QisPhkNGd
	 YH87Fwkybdkv2f4JHOOaXkUaXqIZ0zbEm2pvX+chdTsRF4VX4gXFR8VPYefEoc2/HD
	 OeTjXly9kRWJ2ibfHgzezynT0RBpArQzp/XFd9oVrbspzrlTU6Y5WDy4OZ8sXpncGr
	 m8xoUANjt07Qg==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev
Cc: Waqar Hameed <waqar.hameed@axis.com>,
	Linus Walleij <linusw@kernel.org>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 250/385] power: supply: ab8500: Fix use-after-free in power_supply_changed()
Date: Sat, 28 Feb 2026 12:57:52 -0500
Message-ID: <20260228180011.1568201-250-sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20260228180011.1568201-1-sashal@kernel.org>
References: <20260228180011.1568201-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit c4af8a98bb52825a5331ae1d0604c0ea6956ba4b ]

Using the `devm_` variant for requesting IRQ _before_ the `devm_`
variant for allocating/registering the `power_supply` handle, means that
the `power_supply` handle will be deallocated/unregistered _before_ the
interrupt handler (since `devm_` naturally deallocates in reverse
allocation order). This means that during removal, there is a race
condition where an interrupt can fire just _after_ the `power_supply`
handle has been freed, *but* just _before_ the corresponding
unregistration of the IRQ handler has run.

This will lead to the IRQ handler calling `power_supply_changed()` with
a freed `power_supply` handle. Which usually crashes the system or
otherwise silently corrupts the memory...

Note that there is a similar situation which can also happen during
`probe()`; the possibility of an interrupt firing _before_ registering
the `power_supply` handle. This would then lead to the nasty situation
of using the `power_supply` handle *uninitialized* in
`power_supply_changed()`.

Commit 1c1f13a006ed ("power: supply: ab8500: Move to componentized
binding") introduced this issue during a refactorization. Fix this racy
use-after-free by making sure the IRQ is requested _after_ the
registration of the `power_supply` handle.

Fixes: 1c1f13a006ed ("power: supply: ab8500: Move to componentized binding")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/ccf83a09942cb8dda3dff70b2682f2c2e9cb97f2.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/ab8500_charger.c | 40 +++++++++++++--------------
 1 file changed, 20 insertions(+), 20 deletions(-)

diff --git a/drivers/power/supply/ab8500_charger.c b/drivers/power/supply/ab8500_charger.c
index 93181ebfb3247..5da3b12d9f0bb 100644
--- a/drivers/power/supply/ab8500_charger.c
+++ b/drivers/power/supply/ab8500_charger.c
@@ -3467,26 +3467,6 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		return ret;
 	}
 
-	/* Request interrupts */
-	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
-		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
-		if (irq < 0)
-			return irq;
-
-		ret = devm_request_threaded_irq(dev,
-			irq, NULL, ab8500_charger_irq[i].isr,
-			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
-			ab8500_charger_irq[i].name, di);
-
-		if (ret != 0) {
-			dev_err(dev, "failed to request %s IRQ %d: %d\n"
-				, ab8500_charger_irq[i].name, irq, ret);
-			return ret;
-		}
-		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
-			ab8500_charger_irq[i].name, irq, ret);
-	}
-
 	/* initialize lock */
 	spin_lock_init(&di->usb_state.usb_lock);
 	mutex_init(&di->usb_ipt_crnt_lock);
@@ -3615,6 +3595,26 @@ static int ab8500_charger_probe(struct platform_device *pdev)
 		return PTR_ERR(di->usb_chg.psy);
 	}
 
+	/* Request interrupts */
+	for (i = 0; i < ARRAY_SIZE(ab8500_charger_irq); i++) {
+		irq = platform_get_irq_byname(pdev, ab8500_charger_irq[i].name);
+		if (irq < 0)
+			return irq;
+
+		ret = devm_request_threaded_irq(dev,
+			irq, NULL, ab8500_charger_irq[i].isr,
+			IRQF_SHARED | IRQF_NO_SUSPEND | IRQF_ONESHOT,
+			ab8500_charger_irq[i].name, di);
+
+		if (ret != 0) {
+			dev_err(dev, "failed to request %s IRQ %d: %d\n"
+				, ab8500_charger_irq[i].name, irq, ret);
+			return ret;
+		}
+		dev_dbg(dev, "Requested %s IRQ %d: %d\n",
+			ab8500_charger_irq[i].name, irq, ret);
+	}
+
 	/*
 	 * Check what battery we have, since we always have the USB
 	 * psy, use that as a handle.
-- 
2.51.0

