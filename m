Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ADE41A76D9;
	Tue, 30 Jul 2024 17:26:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360376; cv=none; b=aIP/T7oVUN6yOyj/VlnR3kLautleis69KHCctJXahMA5e7Wf1wa5ktS7S4QHpkxfu1rOuId1BPbXGv27DVyTaYObAMe8Hhy+jGkCT13k7irbkcGpWrmD8Y/jtcpoDjX0V8T2tdZi4fx1RoYUvx1QwxIgfhA7VHxnvWA1DBVl6Ao=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360376; c=relaxed/simple;
	bh=oA+YatxUXbhLJvWofNM7r0CYIHz8p/WnJIPwKVw05z4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qe1LA5rLVDVtbTENVhGiC6rVTLNZKbMTS0PsKN2xZ3udspQgbPsTSzf9wayYsn1qEJMBWvcfMd8D3WSHtJy3RLOxljJTS/TXVzwdUTu7W5VZ2+oL0VQciKH0xJTwtZavMlGUEygN3Gr2t/NR1vyLQJGkiHO/OnNDx0fnr75yrMY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WvvkY8kK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WvvkY8kK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F216C32782;
	Tue, 30 Jul 2024 17:26:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360375;
	bh=oA+YatxUXbhLJvWofNM7r0CYIHz8p/WnJIPwKVw05z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WvvkY8kKhD5WuAba6mjMeY8QP00XvuJSLayUyK81ULyvMfUPFtAKfc1tyO9SwQbhM
	 4le2WJcB45zr6decMk56wZEYfWPqFJIIc+6x3dsYqrPgG8YpypSibIHAe1wbJiWryN
	 aN4TLeWM2wjGoLY6Ij57MR0C6yiQi2fCvKBwjgKE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shenwei Wang <shenwei.wang@nxp.com>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.10 679/809] irqchip/imx-irqsteer: Handle runtime power management correctly
Date: Tue, 30 Jul 2024 17:49:15 +0200
Message-ID: <20240730151751.724366470@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shenwei Wang <shenwei.wang@nxp.com>

commit 33b1c47d1fc0b5f06a393bb915db85baacba18ea upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-imx-irqsteer.c |   24 +++++++++++++++++++++---
 1 file changed, 21 insertions(+), 3 deletions(-)

--- a/drivers/irqchip/irq-imx-irqsteer.c
+++ b/drivers/irqchip/irq-imx-irqsteer.c
@@ -36,6 +36,7 @@ struct irqsteer_data {
 	int			channel;
 	struct irq_domain	*domain;
 	u32			*saved_reg;
+	struct device		*dev;
 };
 
 static int imx_irqsteer_get_reg_index(struct irqsteer_data *data,
@@ -72,10 +73,26 @@ static void imx_irqsteer_irq_mask(struct
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
@@ -150,6 +167,7 @@ static int imx_irqsteer_probe(struct pla
 	if (!data)
 		return -ENOMEM;
 
+	data->dev = &pdev->dev;
 	data->regs = devm_platform_ioremap_resource(pdev, 0);
 	if (IS_ERR(data->regs)) {
 		dev_err(&pdev->dev, "failed to initialize reg\n");


