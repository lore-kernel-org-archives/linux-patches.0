Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A60812153DD;
	Thu, 12 Dec 2024 17:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734024035; cv=none; b=s1LDFDkkahkXchVwtmFJUQGPAPAS4IP373PlN0V4CFmY+J3cuy89E3kGsYVH7BHOhvdn/JueJSr/zdm+5cHizvF+8XvbQ/1KKY1lTDi0UuqpIXPbYIurs2ZKK2m0DFPyLQnprZ1oYiGL8BJ9XF/R3GmsOf77cAG7bPBNcbmgl1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734024035; c=relaxed/simple;
	bh=mwCEz/lV8XrkF3dOzMCjURwd/0db7u4CVe1n17Fm8+k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=D0YToYS2GDsAPMVfrMkZZ2ESrU09VA29NP/2yS4Qr2ec8tnO3ObZTgtQ4w6kksToB8dcg6U/mlRcVzEP69CzK5/N4ZoaBEyFEE6iKUbUZpNL0j4Tpf5dTB7usxHiKbzq8TT8+uFZq+NzHYSTXUlCWcJQDtLSTCRG77XYUeCpncA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l0KlXI/+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l0KlXI/+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2461C4CECE;
	Thu, 12 Dec 2024 17:20:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734024035;
	bh=mwCEz/lV8XrkF3dOzMCjURwd/0db7u4CVe1n17Fm8+k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l0KlXI/+3iinXgKM3KPPvuQWJcIht0AkLP2eb69bvCaGZTuk4hxCk69IFpAXejt/2
	 L2Ca45RggNjurITtgNrXTkcyp+Uvm5a5GWZppoYKhXBPtRoLj/kloy8ZT5c0fWjKrR
	 mOemAFD+AjF9Qs/sT5v53R7OSvRImmUXstGUtMJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Lee Jones <lee@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 165/459] mfd: tps65010: Use IRQF_NO_AUTOEN flag in request_irq() to fix race
Date: Thu, 12 Dec 2024 15:58:23 +0100
Message-ID: <20241212144300.033866955@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144253.511169641@linuxfoundation.org>
References: <20241212144253.511169641@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 7e7dbee58ca90..744a68f3c359c 100644
--- a/drivers/mfd/tps65010.c
+++ b/drivers/mfd/tps65010.c
@@ -549,17 +549,13 @@ static int tps65010_probe(struct i2c_client *client,
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



