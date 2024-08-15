Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 299C91A01BF;
	Thu, 15 Aug 2024 14:21:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723731669; cv=none; b=HB89pR0vWqpcURnUlS8R6ac2BzOvcxghcuxBlZrVSweUQ9pcuMOORiGaWxcvahnFot/heROyRpc2VqC1EZVMUnN+UcC5zEOHYnjpMBsEyml4Dxl3rEd7KoisqqKilJdrlIEh9zTiVGAvoX9ENp55SZFXX1VB7khp22MTARO7eLI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723731669; c=relaxed/simple;
	bh=Og9SKjd21m0C+uLSpU4aF9ZHRH0Nri6nVj25uKhxApE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jRnqd3SPrc9CiS4a6+l0dZ3cs03RX6JV+6RC1AwI9JTdijdNqVgDGKl4WsNAAX3KSnivH+Xj+Gk3mHCaqQ0yWGUTnACjqWo0875X66znCQ+fCNEq8c7rwQchboB7YcE8WV6pE6kZKZ8Wg1cVptAIkOKIQnMmNL4N4IkvF42knxA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YHaPjV53; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YHaPjV53"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A14FC4AF0D;
	Thu, 15 Aug 2024 14:21:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723731669;
	bh=Og9SKjd21m0C+uLSpU4aF9ZHRH0Nri6nVj25uKhxApE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YHaPjV53zHInJ1PCLK/393F5Atkxxb7Uz5ko/IP9V/2tKl5cLwC5Hkxg3oV99Iv3s
	 1sniAcZUvqdBn23jI3NtwRvMcWRNcYHvRvpqx2Tdw3mVgDeIP/1n2eWCtEJr6fAMtM
	 Cw3usrw7pYE264mzoX4XCvtPnoVchuvpwKd88Wxk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 169/259] irqchip/imx-irqsteer: Handle runtime power management correctly
Date: Thu, 15 Aug 2024 15:25:02 +0200
Message-ID: <20240815131909.307613626@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131902.779125794@linuxfoundation.org>
References: <20240815131902.779125794@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

[ Upstream commit 33b1c47d1fc0b5f06a393bb915db85baacba18ea ]

The power domain is automatically activated from clk_prepare(). However, on
certain platforms like i.MX8QM and i.MX8QXP, the power-on handling invokes
sleeping functions, which triggers the 'scheduling while atomic' bug in the
context switch path during device probing:

 BUG: scheduling while atomic: kworker/u13:1/48/0x00000002
 Call trace:
  __schedule_bug+0x54/0x6c
  __schedule+0x7f0/0xa94
  schedule+0x5c/0xc4
  schedule_preempt_disabled+0x24/0x40
  __mutex_lock.constprop.0+0x2c0/0x540
  __mutex_lock_slowpath+0x14/0x20
  mutex_lock+0x48/0x54
  clk_prepare_lock+0x44/0xa0
  clk_prepare+0x20/0x44
  imx_irqsteer_resume+0x28/0xe0
  pm_generic_runtime_resume+0x2c/0x44
  __genpd_runtime_resume+0x30/0x80
  genpd_runtime_resume+0xc8/0x2c0
  __rpm_callback+0x48/0x1d8
  rpm_callback+0x6c/0x78
  rpm_resume+0x490/0x6b4
  __pm_runtime_resume+0x50/0x94
  irq_chip_pm_get+0x2c/0xa0
  __irq_do_set_handler+0x178/0x24c
  irq_set_chained_handler_and_data+0x60/0xa4
  mxc_gpio_probe+0x160/0x4b0

Cure this by implementing the irq_bus_lock/sync_unlock() interrupt chip
callbacks and handle power management in them as they are invoked from
non-atomic context.

[ tglx: Rewrote change log, added Fixes tag ]

Fixes: 0136afa08967 ("irqchip: Add driver for imx-irqsteer controller")
Signed-off-by: Shenwei Wang <shenwei.wang@nxp.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240703163250.47887-1-shenwei.wang@nxp.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-imx-irqsteer.c | 24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

diff --git a/drivers/irqchip/irq-imx-irqsteer.c b/drivers/irqchip/irq-imx-irqsteer.c
index e622dbd614638..23aafc52768c7 100644
--- a/drivers/irqchip/irq-imx-irqsteer.c
+++ b/drivers/irqchip/irq-imx-irqsteer.c
@@ -35,6 +35,7 @@ struct irqsteer_data {
 	int			channel;
 	struct irq_domain	*domain;
 	u32			*saved_reg;
+	struct device		*dev;
 };
 
 static int imx_irqsteer_get_reg_index(struct irqsteer_data *data,
@@ -71,10 +72,26 @@ static void imx_irqsteer_irq_mask(struct irq_data *d)
 	raw_spin_unlock_irqrestore(&data->lock, flags);
 }
 
+static void imx_irqsteer_irq_bus_lock(struct irq_data *d)
+{
+	struct irqsteer_data *data = d->chip_data;
+
+	pm_runtime_get_sync(data->dev);
+}
+
+static void imx_irqsteer_irq_bus_sync_unlock(struct irq_data *d)
+{
+	struct irqsteer_data *data = d->chip_data;
+
+	pm_runtime_put_autosuspend(data->dev);
+}
+
 static const struct irq_chip imx_irqsteer_irq_chip = {
-	.name		= "irqsteer",
-	.irq_mask	= imx_irqsteer_irq_mask,
-	.irq_unmask	= imx_irqsteer_irq_unmask,
+	.name			= "irqsteer",
+	.irq_mask		= imx_irqsteer_irq_mask,
+	.irq_unmask		= imx_irqsteer_irq_unmask,
+	.irq_bus_lock		= imx_irqsteer_irq_bus_lock,
+	.irq_bus_sync_unlock	= imx_irqsteer_irq_bus_sync_unlock,
 };
 
 static int imx_irqsteer_irq_map(struct irq_domain *h, unsigned int irq,
@@ -152,6 +169,7 @@ static int imx_irqsteer_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	data->dev = &pdev->dev;
 	data->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->regs)) {
 		dev_err(&pdev->dev, "failed to initialize reg\n");
-- 
2.43.0



