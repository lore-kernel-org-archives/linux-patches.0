Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A98C8634E;
	Wed,  5 Feb 2025 14:25:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738765505; cv=none; b=AdCkZ5Y+K22yjJC9FDgmJyAkuuEGUxGgNXNX/050VbXEa9ifnC/VfwlHul0OwDZHqrGw1cvVH44KG1Laj5+dTffTQQ5YgCjfoCq90id5IfW53n9aIV6z+tJhK0skUS0xBUmysJeBxA/rh62F9FhPHG96FDrwhjoCUic1Sx3SbbE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738765505; c=relaxed/simple;
	bh=IZ9zoCULoGVSwbZ77lLNvlC/4Z67gieLSAfnvP2+taU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=S/S64bmXSthrwCYRM1n396baibuSWbCVjB/CBP8Abz8IMnrX6W4pAS3mfONd5N1mt1dafzYhCzUgrxf3hqX4Od+idalfMIxi24jwzE5z4A15CW5s4tMB+6BAJCBy7FnlcB1VGOtTxZDEUFbsfCKveKeCeP6UWVmES1PY35k3wnk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0If+Zbz3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0If+Zbz3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2661C4CED1;
	Wed,  5 Feb 2025 14:25:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738765504;
	bh=IZ9zoCULoGVSwbZ77lLNvlC/4Z67gieLSAfnvP2+taU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0If+Zbz3/6UuU+4yUfQiOIOJ3s0Croo8YYBFiqDelshDCDNtcyn/iVVKJ1vqCfB5P
	 Kx3iW+kIbPPJ9GMiT1qXxgvGF3vmL01Ybm9FiY9YJzwgOa8NlWIYojWNKe15E+B/RJ
	 WPbmMhTW24kq2m4NeTnl7sSYp/DwGI3cYBLWCatk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Billy Tsai <billy_tsai@aspeedtech.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 273/393] i3c: dw: Add hot-join support.
Date: Wed,  5 Feb 2025 14:43:12 +0100
Message-ID: <20250205134430.757488335@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250205134420.279368572@linuxfoundation.org>
References: <20250205134420.279368572@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Billy Tsai <billy_tsai@aspeedtech.com>

[ Upstream commit 1d08326020fba690cbb7b8f1b38ab4eab6745969 ]

Add hot-join support for dw i3c master controller.
By default, the hot-join acknowledgment is disabled, and the hardware will
automatically send the DISEC CCC when it receives the hot-join request.
Users can use the sys entry to enable it.

Signed-off-by: Billy Tsai <billy_tsai@aspeedtech.com>
Link: https://lore.kernel.org/r/20240429073624.256830-1-billy_tsai@aspeedtech.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: b75439c945b9 ("i3c: dw: Fix use-after-free in dw_i3c_master driver due to race condition")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/dw-i3c-master.c | 67 ++++++++++++++++++++++++------
 drivers/i3c/master/dw-i3c-master.h |  2 +
 2 files changed, 56 insertions(+), 13 deletions(-)

diff --git a/drivers/i3c/master/dw-i3c-master.c b/drivers/i3c/master/dw-i3c-master.c
index 235235613c1b9..93e9d307e40ef 100644
--- a/drivers/i3c/master/dw-i3c-master.c
+++ b/drivers/i3c/master/dw-i3c-master.c
@@ -1136,6 +1136,23 @@ static void dw_i3c_master_free_ibi(struct i3c_dev_desc *dev)
 	data->ibi_pool = NULL;
 }
 
+static void dw_i3c_master_enable_sir_signal(struct dw_i3c_master *master, bool enable)
+{
+	u32 reg;
+
+	reg = readl(master->regs + INTR_STATUS_EN);
+	reg &= ~INTR_IBI_THLD_STAT;
+	if (enable)
+		reg |= INTR_IBI_THLD_STAT;
+	writel(reg, master->regs + INTR_STATUS_EN);
+
+	reg = readl(master->regs + INTR_SIGNAL_EN);
+	reg &= ~INTR_IBI_THLD_STAT;
+	if (enable)
+		reg |= INTR_IBI_THLD_STAT;
+	writel(reg, master->regs + INTR_SIGNAL_EN);
+}
+
 static void dw_i3c_master_set_sir_enabled(struct dw_i3c_master *master,
 					  struct i3c_dev_desc *dev,
 					  u8 idx, bool enable)
@@ -1170,23 +1187,34 @@ static void dw_i3c_master_set_sir_enabled(struct dw_i3c_master *master,
 	}
 	writel(reg, master->regs + IBI_SIR_REQ_REJECT);
 
-	if (global) {
-		reg = readl(master->regs + INTR_STATUS_EN);
-		reg &= ~INTR_IBI_THLD_STAT;
-		if (enable)
-			reg |= INTR_IBI_THLD_STAT;
-		writel(reg, master->regs + INTR_STATUS_EN);
-
-		reg = readl(master->regs + INTR_SIGNAL_EN);
-		reg &= ~INTR_IBI_THLD_STAT;
-		if (enable)
-			reg |= INTR_IBI_THLD_STAT;
-		writel(reg, master->regs + INTR_SIGNAL_EN);
-	}
+	if (global)
+		dw_i3c_master_enable_sir_signal(master, enable);
+
 
 	spin_unlock_irqrestore(&master->devs_lock, flags);
 }
 
+static int dw_i3c_master_enable_hotjoin(struct i3c_master_controller *m)
+{
+	struct dw_i3c_master *master = to_dw_i3c_master(m);
+
+	dw_i3c_master_enable_sir_signal(master, true);
+	writel(readl(master->regs + DEVICE_CTRL) & ~DEV_CTRL_HOT_JOIN_NACK,
+	       master->regs + DEVICE_CTRL);
+
+	return 0;
+}
+
+static int dw_i3c_master_disable_hotjoin(struct i3c_master_controller *m)
+{
+	struct dw_i3c_master *master = to_dw_i3c_master(m);
+
+	writel(readl(master->regs + DEVICE_CTRL) | DEV_CTRL_HOT_JOIN_NACK,
+	       master->regs + DEVICE_CTRL);
+
+	return 0;
+}
+
 static int dw_i3c_master_enable_ibi(struct i3c_dev_desc *dev)
 {
 	struct dw_i3c_i2c_dev_data *data = i3c_dev_get_master_data(dev);
@@ -1326,6 +1354,8 @@ static void dw_i3c_master_irq_handle_ibis(struct dw_i3c_master *master)
 
 		if (IBI_TYPE_SIRQ(reg)) {
 			dw_i3c_master_handle_ibi_sir(master, reg);
+		} else if (IBI_TYPE_HJ(reg)) {
+			queue_work(master->base.wq, &master->hj_work);
 		} else {
 			len = IBI_QUEUE_STATUS_DATA_LEN(reg);
 			dev_info(&master->base.dev,
@@ -1393,6 +1423,8 @@ static const struct i3c_master_controller_ops dw_mipi_i3c_ibi_ops = {
 	.enable_ibi = dw_i3c_master_enable_ibi,
 	.disable_ibi = dw_i3c_master_disable_ibi,
 	.recycle_ibi_slot = dw_i3c_master_recycle_ibi_slot,
+	.enable_hotjoin = dw_i3c_master_enable_hotjoin,
+	.disable_hotjoin = dw_i3c_master_disable_hotjoin,
 };
 
 /* default platform ops implementations */
@@ -1412,6 +1444,14 @@ static const struct dw_i3c_platform_ops dw_i3c_platform_ops_default = {
 	.set_dat_ibi = dw_i3c_platform_set_dat_ibi_nop,
 };
 
+static void dw_i3c_hj_work(struct work_struct *work)
+{
+	struct dw_i3c_master *master =
+		container_of(work, typeof(*master), hj_work);
+
+	i3c_master_do_daa(&master->base);
+}
+
 int dw_i3c_common_probe(struct dw_i3c_master *master,
 			struct platform_device *pdev)
 {
@@ -1469,6 +1509,7 @@ int dw_i3c_common_probe(struct dw_i3c_master *master,
 	if (master->ibi_capable)
 		ops = &dw_mipi_i3c_ibi_ops;
 
+	INIT_WORK(&master->hj_work, dw_i3c_hj_work);
 	ret = i3c_master_register(&master->base, &pdev->dev, ops, false);
 	if (ret)
 		goto err_assert_rst;
diff --git a/drivers/i3c/master/dw-i3c-master.h b/drivers/i3c/master/dw-i3c-master.h
index ab862c5d15fe7..4ab94aa72252e 100644
--- a/drivers/i3c/master/dw-i3c-master.h
+++ b/drivers/i3c/master/dw-i3c-master.h
@@ -57,6 +57,8 @@ struct dw_i3c_master {
 
 	/* platform-specific data */
 	const struct dw_i3c_platform_ops *platform_ops;
+
+	struct work_struct hj_work;
 };
 
 struct dw_i3c_platform_ops {
-- 
2.39.5



