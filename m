Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C21771EB5E1;
	Wed, 25 Feb 2026 01:35:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983319; cv=none; b=IMHGf8/NaOyh32o38fGIcOG8OL0U6lLZWL6IY/a9EZR0/usKoe95G3SZLmrXxkhRB/OJHycnVe78nBH/c/eBqz28vk8bCxQAeFNlGSI5hZ55uwsmj33vKHdz2E4h+hifVCHZLKUOVQh9wc9yTV3dBlRI6QMViDc4sJApKczGn90=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983319; c=relaxed/simple;
	bh=5nSwxOX9O9n3ndDs/LRarRFtlGacyFucEw+joj5xAVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=q/fE8gl3kf85oC4781Dk8vyjSUS/Z8GxSKxCOgBAf2VU57SqRIhnuOw7O9/89wIcd4DKjlBMZIdTIBmldKJaUt5ohOxdGHsYaumN3183OIPaMqOLdAqyjV0tJWLA2yOJz1sR8omjNskoRBLnazZd4Rn+Of0uZkmiVqY/85xde4k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kVWcYD/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kVWcYD/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81877C116D0;
	Wed, 25 Feb 2026 01:35:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983319;
	bh=5nSwxOX9O9n3ndDs/LRarRFtlGacyFucEw+joj5xAVc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kVWcYD/icdWq6Y2FA+J+9p7iHOlIklc/Cp0Vl8wznoK1jTZSAgtl8lohisKj+Bd1t
	 ed02cx3Ay0/lV7xp5yXTdVFfbTqjckOaHRcr09oLFl154d/cCQgGtsEc23JOJrwsov
	 99AqePO9552R1DO+iGew8fb/lH6IyuN+7Fu2dJK8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Samuel Kayode <samkay014@gmail.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 453/781] power: supply: pf1550: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:22 -0800
Message-ID: <20260225012410.823290446@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012359.695468795@linuxfoundation.org>
References: <20260225012359.695468795@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit 838767f5074700552d3f006d867caed65edc7328 ]

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

Fix this racy use-after-free by making sure the IRQ is requested _after_
the registration of the `power_supply` handle.

Fixes: 4b6b6433a97d ("power: supply: pf1550: add battery charger support")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Samuel Kayode <samkay014@gmail.com>
Link: https://patch.msgid.link/ae5a71b7e4dd2967d8fdcc531065cc71b17c86f5.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pf1550-charger.c | 32 +++++++++++++--------------
 1 file changed, 16 insertions(+), 16 deletions(-)

diff --git a/drivers/power/supply/pf1550-charger.c b/drivers/power/supply/pf1550-charger.c
index 98f1ee8eca3bc..a457862ef4610 100644
--- a/drivers/power/supply/pf1550-charger.c
+++ b/drivers/power/supply/pf1550-charger.c
@@ -584,22 +584,6 @@ static int pf1550_charger_probe(struct platform_device *pdev)
 		return dev_err_probe(chg->dev, ret,
 				     "failed to add battery sense work\n");
 
-	for (i = 0; i < PF1550_CHARGER_IRQ_NR; i++) {
-		irq = platform_get_irq(pdev, i);
-		if (irq < 0)
-			return irq;
-
-		chg->virqs[i] = irq;
-
-		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
-						pf1550_charger_irq_handler,
-						IRQF_NO_SUSPEND,
-						"pf1550-charger", chg);
-		if (ret)
-			return dev_err_probe(&pdev->dev, ret,
-					     "failed irq request\n");
-	}
-
 	psy_cfg.drv_data = chg;
 
 	chg->charger = devm_power_supply_register(&pdev->dev,
@@ -616,6 +600,22 @@ static int pf1550_charger_probe(struct platform_device *pdev)
 		return dev_err_probe(&pdev->dev, PTR_ERR(chg->battery),
 				     "failed: power supply register\n");
 
+	for (i = 0; i < PF1550_CHARGER_IRQ_NR; i++) {
+		irq = platform_get_irq(pdev, i);
+		if (irq < 0)
+			return irq;
+
+		chg->virqs[i] = irq;
+
+		ret = devm_request_threaded_irq(&pdev->dev, irq, NULL,
+						pf1550_charger_irq_handler,
+						IRQF_NO_SUSPEND,
+						"pf1550-charger", chg);
+		if (ret)
+			return dev_err_probe(&pdev->dev, ret,
+					     "failed irq request\n");
+	}
+
 	pf1550_dt_parse_dev_info(chg);
 
 	return pf1550_reg_init(chg);
-- 
2.51.0



