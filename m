Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 841A222D4C6;
	Thu, 12 Dec 2024 16:03:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019426; cv=none; b=IatT/sgbyYjKBUaIgr4sEphy5kolbLQZIJqDq9LM2/RjdSAzQYY54glkbbaC4hQQ0Yj9GIflPD+tplbGcVtLvcQiDSe/e7cxx98vrYikx1dpbL/GWbLPaW2JNdFF8++wq6zLFAP4U9/fl8aUYtH6jhpzGoTcBMlF1vZfLuCZ/wY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019426; c=relaxed/simple;
	bh=IWfc/VT6jlPxDfI4oMW7peqnghecywtdkzmhjeFhvbQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ulGNl7AjzTHcoQjTyQiMk/0GjwCnW5SMoUCV6x0FQGIaQ+U2rUN6u7ZpyQttu7qHpYk/lKLY7sEquzWu0+BlwVWvGdHUVLRNyk6ZegShT9Yn+w4V4yULy+JsICmvaaK7cMqVc6NAqTzvqtT0rnoBF+j8wsIFIhjh7nUaz1u/nzI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=05VSn5zt; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="05VSn5zt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C4BF8C4CECE;
	Thu, 12 Dec 2024 16:03:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019426;
	bh=IWfc/VT6jlPxDfI4oMW7peqnghecywtdkzmhjeFhvbQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=05VSn5zttUzQESqyfN5lkC1lFCT9JwpXMGGPFSRByUyGINZdKYMzkh0/jiytHzsB0
	 lI0dEEI6A+nGDWv/gn90GoVJYi73RehdYBof1FwYaLrHo6HDO0Kj7/YFI6Nw98VRVE
	 EiKsFdYOCbBQAMUNR2LTD1SIJGHvjHpgCpD9WKXE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 205/772] mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race
Date: Thu, 12 Dec 2024 15:52:30 +0100
Message-ID: <20241212144358.406871900@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit 2174f9a8c9db50f74df769edd5a4ab822c73b6d2 ]

As the comment said, disable_irq() after request_irq() still has a
time gap in which interrupts can come. request_irq() with IRQF_NO_AUTOEN
flag will disable IRQ auto-enable when request IRQ.

Fixes: 72cd799544f2 ("[PATCH] I2C: add i2c driver for TPS6501x")
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://lore.kernel.org/r/20240912031530.2211654-1-ruanjinjie@huawei.com
Signed-off-by: Lee Jones <lee@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mfd/tps65010.c | 8 ++------
 1 file changed, 2 insertions(+), 6 deletions(-)

diff --git a/drivers/mfd/tps65010.c b/drivers/mfd/tps65010.c
index c2afa2e69f42f..35ddffb96ba1a 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -548,17 +548,13 @@ static int tps65010_probe(struct i2c_client *client,
 	 */
 	if (client->irq > 0) {
 		status = request_irq(client->irq, tps65010_irq,
-				     IRQF_TRIGGER_FALLING, DRIVER_NAME, tps);
+				     IRQF_TRIGGER_FALLING | IRQF_NO_AUTOEN,
+				     DRIVER_NAME, tps);
 		if (status < 0) {
 			dev_dbg(&client->dev, "can't get IRQ %d, err %d\n",
 					client->irq, status);
 			return status;
 		}
-		/* annoying race here, ideally we'd have an option
-		 * to claim the irq now and enable it later.
-		 * FIXME genirq IRQF_NOAUTOEN now solves that ...
-		 */
-		disable_irq(client->irq);
 		set_bit(FLAG_IRQ_ENABLE, &tps->flags);
 	} else
 		dev_warn(&client->dev, "IRQ not configured!\n");
-- 
2.43.0



