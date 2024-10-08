Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3F8DA1DEFC8;
	Tue,  8 Oct 2024 13:20:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728393639; cv=none; b=KRQBkgCdSS1pWzuHQec65tSGlXQPfo1kbqg08rLw5Wb1P8wSD/ZejhW8A3kgxj7E9PIIS7FjVrKYvv7t85qiy3at8zogQ2vr5P9aoSc1mAuM4Eg5Ka1tUEjLda34BkSshP9guULWimcE3x0LX2YMG/e9jW6ijA5Bzk28cqaw0U4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728393639; c=relaxed/simple;
	bh=+T+cuuNS64dSEUtvPIrBIkT2AwGPhtIwV02yVF7r1Xk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KOvtguDvJyP4/3nTO5rJWE0X4Y3GENWPw4LHeuYINckJ0dQsHgY+S7nraVYoyAJug2HXLuJmlQJ7R4Mnaxq961MhXNkU4oFOhTSTX+udlc498Z6hjRPrBje1rHuauj9DeJPoDeX2lgdKPdM1lLheO5nnUiN5EOOaE/1715x1kGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MMOrTPil; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MMOrTPil"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A11CCC4CEC7;
	Tue,  8 Oct 2024 13:20:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728393639;
	bh=+T+cuuNS64dSEUtvPIrBIkT2AwGPhtIwV02yVF7r1Xk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MMOrTPil/1o5C93//23MTYEDpuC9E4fwCC1tgoWDGzIkv/rQjIb39MbnqQ67rSIuD
	 zVZeKE2372okBKYXFq/HiBIM3QRYWqXCI3LJETtNAYgZvmgBHUdjKWgo4x3gdIJUW4
	 HimcodHUTu7ifP3kn25fhbqhaXep2PU3f2uMZ4U8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kimriver Liu <kimriver.liu@siengine.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andy Shevchenko <andy@kernel.org>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 211/386] i2c: designware: fix controller is holding SCL low while ENABLE bit is disabled
Date: Tue,  8 Oct 2024 14:07:36 +0200
Message-ID: <20241008115637.710085163@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241008115629.309157387@linuxfoundation.org>
References: <20241008115629.309157387@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kimriver Liu <kimriver.liu@siengine.com>

commit 5d69d5a00f80488ddcb4dee7d1374a0709398178 upstream.

It was observed that issuing the ABORT bit (IC_ENABLE[1]) will not
work when IC_ENABLE is already disabled.

Check if the ENABLE bit (IC_ENABLE[0]) is disabled when the controller
is holding SCL low. If the ENABLE bit is disabled, the software needs
to enable it before trying to issue the ABORT bit. otherwise,
the controller ignores any write to ABORT bit.

These kernel logs show up whenever an I2C transaction is
attempted after this failure.
i2c_designware e95e0000.i2c: timeout waiting for bus ready
i2c_designware e95e0000.i2c: timeout in disabling adapter

The patch fixes the issue where the controller cannot be disabled
while SCL is held low if the ENABLE bit is already disabled.

Fixes: 2409205acd3c ("i2c: designware: fix __i2c_dw_disable() in case master is holding SCL low")
Signed-off-by: Kimriver Liu <kimriver.liu@siengine.com>
Cc: <stable@vger.kernel.org> # v6.6+
Reviewed-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Reviewed-by: Andy Shevchenko <andy@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-common.c |   14 ++++++++++
 drivers/i2c/busses/i2c-designware-core.h   |    1 
 drivers/i2c/busses/i2c-designware-master.c |   38 +++++++++++++++++++++++++++++
 3 files changed, 53 insertions(+)

--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -441,6 +441,7 @@ err_release_lock:
 
 void __i2c_dw_disable(struct dw_i2c_dev *dev)
 {
+	struct i2c_timings *t = &dev->timings;
 	unsigned int raw_intr_stats;
 	unsigned int enable;
 	int timeout = 100;
@@ -453,6 +454,19 @@ void __i2c_dw_disable(struct dw_i2c_dev
 
 	abort_needed = raw_intr_stats & DW_IC_INTR_MST_ON_HOLD;
 	if (abort_needed) {
+		if (!(enable & DW_IC_ENABLE_ENABLE)) {
+			regmap_write(dev->map, DW_IC_ENABLE, DW_IC_ENABLE_ENABLE);
+			/*
+			 * Wait 10 times the signaling period of the highest I2C
+			 * transfer supported by the driver (for 400KHz this is
+			 * 25us) to ensure the I2C ENABLE bit is already set
+			 * as described in the DesignWare I2C databook.
+			 */
+			fsleep(DIV_ROUND_CLOSEST_ULL(10 * MICRO, t->bus_freq_hz));
+			/* Set ENABLE bit before setting ABORT */
+			enable |= DW_IC_ENABLE_ENABLE;
+		}
+
 		regmap_write(dev->map, DW_IC_ENABLE, enable | DW_IC_ENABLE_ABORT);
 		ret = regmap_read_poll_timeout(dev->map, DW_IC_ENABLE, enable,
 					       !(enable & DW_IC_ENABLE_ABORT), 10,
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -109,6 +109,7 @@
 						 DW_IC_INTR_RX_UNDER | \
 						 DW_IC_INTR_RD_REQ)
 
+#define DW_IC_ENABLE_ENABLE			BIT(0)
 #define DW_IC_ENABLE_ABORT			BIT(1)
 
 #define DW_IC_STATUS_ACTIVITY			BIT(0)
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -253,6 +253,34 @@ static void i2c_dw_xfer_init(struct dw_i
 	regmap_write(dev->map, DW_IC_INTR_MASK, DW_IC_INTR_MASTER_MASK);
 }
 
+/*
+ * This function waits for the controller to be idle before disabling I2C
+ * When the controller is not in the IDLE state, the MST_ACTIVITY bit
+ * (IC_STATUS[5]) is set.
+ *
+ * Values:
+ * 0x1 (ACTIVE): Controller not idle
+ * 0x0 (IDLE): Controller is idle
+ *
+ * The function is called after completing the current transfer.
+ *
+ * Returns:
+ * False when the controller is in the IDLE state.
+ * True when the controller is in the ACTIVE state.
+ */
+static bool i2c_dw_is_controller_active(struct dw_i2c_dev *dev)
+{
+	u32 status;
+
+	regmap_read(dev->map, DW_IC_STATUS, &status);
+	if (!(status & DW_IC_STATUS_MASTER_ACTIVITY))
+		return false;
+
+	return regmap_read_poll_timeout(dev->map, DW_IC_STATUS, status,
+				       !(status & DW_IC_STATUS_MASTER_ACTIVITY),
+				       1100, 20000) != 0;
+}
+
 static int i2c_dw_check_stopbit(struct dw_i2c_dev *dev)
 {
 	u32 val;
@@ -695,6 +723,16 @@ i2c_dw_xfer(struct i2c_adapter *adap, st
 	}
 
 	/*
+	 * This happens rarely (~1:500) and is hard to reproduce. Debug trace
+	 * showed that IC_STATUS had value of 0x23 when STOP_DET occurred,
+	 * if disable IC_ENABLE.ENABLE immediately that can result in
+	 * IC_RAW_INTR_STAT.MASTER_ON_HOLD holding SCL low. Check if
+	 * controller is still ACTIVE before disabling I2C.
+	 */
+	if (i2c_dw_is_controller_active(dev))
+		dev_err(dev->dev, "controller active\n");
+
+	/*
 	 * We must disable the adapter before returning and signaling the end
 	 * of the current transfer. Otherwise the hardware might continue
 	 * generating interrupts which in turn causes a race condition with


