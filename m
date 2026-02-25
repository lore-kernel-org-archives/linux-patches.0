Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 964EC2C17A0;
	Wed, 25 Feb 2026 06:56:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1772002602; cv=none; b=GhpDdyPt/RvnEg12IqNb1ipeUIwasTtqYBxxInhoED7REn3bHzE55d28s8GUz02Atk8Yl5njhba3K9uXNpOIgmrkBH0SzcjFKg6rD5/0Yv0CKS7AsQXmP/HjoVqKosQ/aFrPnPbc/qUyuqZYVxxnk4wrWxqpm6137oQuckZmCXw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1772002602; c=relaxed/simple;
	bh=g2YLuknNU8oXxps4acA7k/gr5hqtuQ4IfMDXKepuZ8M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D5xOXJ0BBWjVZdnSRvUIPivSe0H2RnaRdNTkKKMhqN2iEffY0mdSvW/NRM9krIV/M66R5L15T6KKeQziBGZgigUqrNIdOqkk1BzeC5AbAcp0CvhCJ4JvFrJkfbYxoWPu0ntb3o50xpeT5W73LBcEzPFTfs9hUa3/qliRjVXo1sQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tkZQBb9L; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tkZQBb9L"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6302BC116D0;
	Wed, 25 Feb 2026 06:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1772002602;
	bh=g2YLuknNU8oXxps4acA7k/gr5hqtuQ4IfMDXKepuZ8M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tkZQBb9LRFhpVS8E10Rj13KNCex3oQGyRFk2iNesVet00deNB2x3LtoKAMqiXY2IW
	 1KRNW09sX/IvYghT1ehxdm4jQ2NLbKqZkpBZe0ZMwNlZoPr3Ngy6a05bVC4rzyiASS
	 LKwRg0f7fEvenVfxLUDzXCGgnybq2V3PI8vKfXzo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Waqar Hameed <waqar.hameed@axis.com>,
	Nikita Travkin <nikita@trvn.ru>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 350/641] power: supply: pm8916_bms_vm: Fix use-after-free in power_supply_changed()
Date: Tue, 24 Feb 2026 17:21:16 -0800
Message-ID: <20260225012357.127346288@linuxfoundation.org>
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

[ Upstream commit 62914959b35e9a1e29cc0f64cb8cfc5075a5366f ]

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

Fixes: 098bce1838e0 ("power: supply: Add pm8916 VM-BMS support")
Signed-off-by: Waqar Hameed <waqar.hameed@axis.com>
Reviewed-by: Nikita Travkin <nikita@trvn.ru>
Link: https://patch.msgid.link/2749c09ff81fcac87ae48147e216135450d8c067.1766268280.git.waqar.hameed@axis.com
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/power/supply/pm8916_bms_vm.c | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/power/supply/pm8916_bms_vm.c b/drivers/power/supply/pm8916_bms_vm.c
index 5120be086e6ff..de5d571c03e21 100644
--- a/drivers/power/supply/pm8916_bms_vm.c
+++ b/drivers/power/supply/pm8916_bms_vm.c
@@ -167,15 +167,6 @@ static int pm8916_bms_vm_battery_probe(struct platform_device *pdev)
 	if (ret < 0)
 		return -EINVAL;
 
-	irq = platform_get_irq_byname(pdev, "fifo");
-	if (irq < 0)
-		return irq;
-
-	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_bms_vm_fifo_update_done_irq,
-					IRQF_ONESHOT, "pm8916_vm_bms", bat);
-	if (ret)
-		return ret;
-
 	ret = regmap_bulk_read(bat->regmap, bat->reg + PM8916_PERPH_TYPE, &tmp, 2);
 	if (ret)
 		goto comm_error;
@@ -220,6 +211,15 @@ static int pm8916_bms_vm_battery_probe(struct platform_device *pdev)
 	if (ret)
 		return dev_err_probe(dev, ret, "Unable to get battery info\n");
 
+	irq = platform_get_irq_byname(pdev, "fifo");
+	if (irq < 0)
+		return irq;
+
+	ret = devm_request_threaded_irq(dev, irq, NULL, pm8916_bms_vm_fifo_update_done_irq,
+					IRQF_ONESHOT, "pm8916_vm_bms", bat);
+	if (ret)
+		return ret;
+
 	platform_set_drvdata(pdev, bat);
 
 	return 0;
-- 
2.51.0



