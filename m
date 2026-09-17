Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D362D5208B2;
	Thu, 17 Sep 2026 17:44:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789667061; cv=none; b=XJB1G7jm5c2D3AX7ejBsUKFQuDFvddyABHIko4/DwzfyS4Amw7HI31MAIVgGZYrqcPTzZwxPBqa2KY22E8moRYbpKAn96hG3mKJ4eSV/+JUKZ9ORbqGUk1dWArqBj5RZpxdqQQ0QgyAvruS6e1wc44hpuBfPbeaSecYiqV77Q2M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789667061; c=relaxed/simple;
	bh=CBqhfnRqSbrFPwsCEXdekL8pZAh8RoqWjBwwREgtNXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t7vHuRM1U8S9Sf3hp+2+1E8pyaaajWUbuDSUiP2+N7fD5txKLZ+JHPCQIWdXQJPoHbsefnju3iFv1IzuksybHNecyX62t+55v9FQau7OYGGxQUJKPBjysciPG+huy9HuJav2fvaMGC8s0SRA9ZgHbTf7z+WMvKUvvsQP2M9cOMU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wRUwYwYF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wRUwYwYF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 252E81F000FF;
	Thu, 17 Sep 2026 17:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789667059;
	bh=NVZVNVANX6UhlwZKL9EL4fwN4oXhIIkUAfKKxfSuyGY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wRUwYwYF27iJbNr6IsqqgnFtvHS3dvshxxnuXuYlBihdSzaj8nvdWb3nDNW3fQctt
	 vtMRCtpr11c5ZuHaB/3vA06MteDhSBXDdeHYhGzov2JJqX4IdB0BLqkxodH0yiiMHO
	 66ZKxbN1cOnnbCLJeTcR0gRvR2Wy1imWBi8gfTMM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Rodrigo Vivi <rodrigo.vivi@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1188/1250] drm/xe/i2c: Keep the i2c controller always enabled
Date: Thu, 17 Sep 2026 16:16:23 +0100
Message-ID: <20260917151624.484413444@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Heikki Krogerus <heikki.krogerus@linux.intel.com>

[ Upstream commit 244abef7f280a6a84297bfab5fd2e77147bc419a ]

Some platforms make an assumption that the i2c controller's
enabled state indicates also the power state of the
controller. This can create a problem when the controller is
in disabled state, because the hardware may assume
incorrectly that it is then also in low-power state.

To fix this, the controller is kept enabled by taking over
the IC_ENABLE register. The controller has to be disabled
when the configuration is updated and when the target
address or the slave address are assigned, so disabling it
when IC_CON, IC_TAR or IC_SAR registers are programmed, and
then re-enabling it again.

Fixes: f0e53aadd702 ("drm/xe: Support for I2C attached MCUs")
Cc: stable@vger.kernel.org
Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Link: https://patch.msgid.link/20260811121008.1493015-4-heikki.krogerus@linux.intel.com
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
(cherry picked from commit 76cc14e2faed1adae20f4ee144ead0e3a7566c49)
Signed-off-by: Rodrigo Vivi <rodrigo.vivi@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_i2c.c |   49 +++++++++++++++++++++++++++++++++++++++++++-
 drivers/gpu/drm/xe/xe_i2c.h |    1 
 2 files changed, 49 insertions(+), 1 deletion(-)

--- a/drivers/gpu/drm/xe/xe_i2c.c
+++ b/drivers/gpu/drm/xe/xe_i2c.c
@@ -8,6 +8,7 @@
 #include <linux/array_size.h>
 #include <linux/bitfield.h>
 #include <linux/container_of.h>
+#include <linux/delay.h>
 #include <linux/device.h>
 #include <linux/err.h>
 #include <linux/i2c.h>
@@ -220,11 +221,40 @@ static void xe_i2c_remove_irq(struct xe_
 	irq_domain_remove(i2c->irqdomain);
 }
 
+/* See "Disabling DW_apb_i2c" in the DesignWare DW_abp_i2c databook. */
+static void xe_i2c_disable(struct xe_i2c *i2c)
+{
+	int timeout = 100;
+	u32 status;
+
+	xe_mmio_rmw32(i2c->mmio, I2C_REG(DW_IC_ENABLE), DW_IC_ENABLE_ENABLE, 0);
+
+	do {
+		status = xe_mmio_read32(i2c->mmio, I2C_REG(DW_IC_ENABLE_STATUS));
+		if (!(status & DW_IC_ENABLE_ENABLE))
+			return;
+		/* Can't sleep here. */
+		udelay(25);
+	} while (timeout--);
+
+	dev_warn(i2c->drm_dev, "timeout in disabling i2c adapter\n");
+}
+
 static int xe_i2c_read(void *context, unsigned int reg, unsigned int *val)
 {
 	struct xe_i2c *i2c = context;
 
-	*val = xe_mmio_read32(i2c->mmio, XE_REG(reg + I2C_MEM_SPACE_OFFSET));
+	*val = xe_mmio_read32(i2c->mmio, I2C_REG(reg));
+
+	switch (reg) {
+	case DW_IC_ENABLE:
+	case DW_IC_ENABLE_STATUS:
+		FIELD_MODIFY(DW_IC_ENABLE_ENABLE, val,
+			     i2c->ic_enable & DW_IC_ENABLE_ENABLE);
+		break;
+	default:
+		break;
+	}
 
 	return 0;
 }
@@ -234,6 +264,23 @@ static int xe_i2c_write(void *context, u
 	struct xe_i2c *i2c = context;
 
 	switch (reg) {
+	case DW_IC_CON:
+	case DW_IC_TAR:
+	case DW_IC_SAR:
+		/* Disable the controller. */
+		xe_i2c_disable(i2c);
+
+		/* Write the register. */
+		xe_mmio_write32(i2c->mmio, I2C_REG(reg), val);
+
+		/* Enable the controller. */
+		xe_mmio_rmw32(i2c->mmio, I2C_REG(DW_IC_ENABLE), 0, DW_IC_ENABLE_ENABLE);
+		return 0;
+	case DW_IC_ENABLE:
+		i2c->ic_enable = val;
+		/* Other fields can be updated except the enable bit. */
+		val |= DW_IC_ENABLE_ENABLE;
+		break;
 	case DW_IC_SMBUS_INTR_MASK:
 		/* Preserve the interrupt mask requested by the adapter driver. */
 		break;
--- a/drivers/gpu/drm/xe/xe_i2c.h
+++ b/drivers/gpu/drm/xe/xe_i2c.h
@@ -34,6 +34,7 @@ struct xe_i2c {
 	struct platform_device *pdev;
 	struct i2c_adapter *adapter;
 	struct i2c_client *client[XE_I2C_MAX_CLIENTS];
+	unsigned int ic_enable;
 
 	struct notifier_block bus_notifier;
 	struct work_struct work;


