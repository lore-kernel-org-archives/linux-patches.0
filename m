Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A7A351EB5E1;
	Wed, 25 Feb 2026 01:35:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1771983318; cv=none; b=rwh2j1xWyz9MBPofGiLKe2PmRlB/WKflyRbwMPJmkIv/efYHRmpQ/cn1JgphgQplvfYpFI5hJfP/4FQrX9xfoDYVRxYu3kdOgacHpd35LnSEHgH1hxkbrQ5PUpcjttq97bLMCG4YLmlrdKpaVKhy/VgLBV4fZ6t9TNfO5wYGUeY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1771983318; c=relaxed/simple;
	bh=OfyRoqfDS/sxscnmccv39VAuTeBHy9dhbPNEKRn0ru8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X6OKnMUBxx/u74PX5bmmBjuFtlvH8uvBSGLy6+tpTxjDPhSQ7p+d3PnNlQiImUycllhwmC4d7LmkB+osfhyxOAYZf27SaMCWOSvq8BDBuQCyKgAR34E6QsxsZ1eh0EYopnlK/nljLlUvAer8sNAionfFDIwBIJtjmKchf37Knds=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fNydXfJx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fNydXfJx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6BE81C116D0;
	Wed, 25 Feb 2026 01:35:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1771983318;
	bh=OfyRoqfDS/sxscnmccv39VAuTeBHy9dhbPNEKRn0ru8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fNydXfJxA3jqLefFvj+FYtUvValsrpTtF+ALaIQSGD+vjUnfDd2ZABaeEg76A5U+9
	 8v7OI+xGhj639dbUhC3O8i5X8Cmq757WOzx+kyjCO5glGnyTFrotl+pvDoNd4mUyGl
	 ct/WttGJGd8Z2h6YanjlAT1m7KAZuFxHmrPMpLUQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 452/781] power: supply: goldfish: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:19:21 -0800
Message-ID: <20260225012410.799147835@linuxfoundation.org>
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

[ Upstream commit b2ce982e2e0c888dc55c888ad0e20ea04daf2e6b ]

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

Fixes: 84d7b7687489 ("power: Add battery driver for goldfish emulator")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Link: https://patch.msgid.link/500a606bb6fb6f2bb8d797e19a00cea9dd7b03c1.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/goldfish_battery.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/power/supply/goldfish_battery.c b/drivers/power/supply/goldfish_battery.c
index 479195e35d734..5aa24e4dc4455 100644
--- a/drivers/power/supply/goldfish_battery.c
+++ b/drivers/power/supply/goldfish_battery.c
@@ -224,12 +224,6 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 	if (data->irq < 0)
 		return -ENODEV;
 
-	ret = devm_request_irq(&pdev->dev, data->irq,
-			       goldfish_battery_interrupt,
-			       IRQF_SHARED, pdev->name, data);
-	if (ret)
-		return ret;
-
 	psy_cfg.drv_data = data;
 
 	data->ac = devm_power_supply_register(&pdev->dev,
@@ -244,6 +238,12 @@ static int goldfish_battery_probe(struct platform_device *pdev)
 	if (IS_ERR(data->battery))
 		return PTR_ERR(data->battery);
 
+	ret = devm_request_irq(&pdev->dev, data->irq,
+			       goldfish_battery_interrupt,
+			       IRQF_SHARED, pdev->name, data);
+	if (ret)
+		return ret;
+
 	GOLDFISH_BATTERY_WRITE(data, BATTERY_INT_ENABLE, BATTERY_INT_MASK);
 	return 0;
 }
-- 
2.51.0



