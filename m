Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6A14B2C17A0;
	Wed, 25 Feb 2026 06:56:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002603; cv=none; b=KCZvyBQn2aeXqE4AiMf8/3PWmTwPmPYsXj/BWvIdmPfN9/zQPuB06Tz/Y1nd59Pd40bY0ghVDBllEaZiwb7ezPlMMHdttmdLpB/QrprwJCi+wzUKgiXrnJB7yxDnVY1Xm1rK+RlUMl7+cK6oUDWju5USVzd0WlYCA7CAnr23Aek=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002603; c=relaxed/simple;
	bh=57g8DXMXuRH7tBfzTzfZ7TtxduUxRL7tmPrw4wFLky0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rG7w+uiE4Ygm639KSDu21SQjI0rU2TOmYV6y18oHqGmyw1rR71YfSqZCelvi4UXiZ758Ep69NnpG0m5uXZT1fdzg4m+Whm4VbQS9I/444251sv9ySQqdTUJ3XHlsrjLAmH6xPZEQQueGUuVdfActsrgpVa7/muCdn9tmuQBk1Xo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UeWAoDuh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UeWAoDuh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 05B1EC116D0;
	Wed, 25 Feb 2026 06:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002603;
	bh=57g8DXMXuRH7tBfzTzfZ7TtxduUxRL7tmPrw4wFLky0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UeWAoDuhPCGpEYGlMdkZos0esr8ErTSKlbC9XMMA3WjAbPb/krZPadiP8PBBG9LYF
	 HbldLlBQ16aBX2p4qzCPf2UVDXinYrAnUwAnKxF+4yAmgT+nzYIASh7FRJjyM/MR3p
	 P4j1CVeimLSc/HggY98fJ3BpEbiraq5IPlEO4prg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 351/641] power: supply: pm8916_lbc: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:17 -0800
Message-ID: <20260225012357.149611774@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260225012348.915798704@linuxfoundation.org>
References: <20260225012348.915798704@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Waqar Hameed <waqar.hameed@axis.com>

[ Upstream commit b7508129978ae1e2ed9b0410396abc05def9c4eb ]

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

Fixes: f8d7a3d21160 ("power: supply: Add driver for pm8916 lbc")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://patch.msgid.link/64d8dd3675a4e59fa32c3e0ef451f12d1f7ed18f.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pm8916_lbc.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/pm8916_lbc.c b/drivers/power/supply/pm8916_lbc.c
index c74b75b1b2676..3ca717d84aade 100644
--- a/drivers/power/supply/pm8916_lbc.c
+++ b/drivers/power/supply/pm8916_lbc.c
@@ -274,15 +274,6 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 		return dev_err_probe(dev, -EINVAL,
 				     "Wrong amount of reg values: %d (4 expected)\n", len);
 
-	irq = platform_get_irq_byname(pdev, "usb_vbus");
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
-					IRQF_ONESHOT, "pm8916_lbc", chg);
-	if (ret)
-		return ret;
-
 	ret = device_property_read_u32_array(dev, "reg", chg->reg, len);
 	if (ret)
 		return ret;
@@ -332,6 +323,15 @@ static int pm8916_lbc_charger_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to get battery info\n");
 
+	irq = platform_get_irq_byname(pdev, "usb_vbus");
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_lbc_charger_state_changed_irq,
+					IRQF_ONESHOT, "pm8916_lbc", chg);
+	if (ret)
+		return ret;
+
 	chg->edev = devm_extcon_dev_allocate(dev, pm8916_lbc_charger_cable);
 	if (IS_ERR(chg->edev))
 		return PTR_ERR(chg->edev);
-- 
2.51.0



