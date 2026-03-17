Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEDD537C106;
	Tue, 17 Mar 2026 17:15:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773767729; cv=none; b=LYOjqrnA62cHebKeTv4aIxpcfo+Tx0ZoRktGSswsM+Vh9diFK30Yk+K0xN+U9yeul3ssnXjUiRkPbA9IDDe0gENPWVgM5xUuIeqVwCckjsX0j94vML2V4OXaESDBa3s/jIlAWe3kMUlw5vXLluy7K5mfP8QpanQMoX/1T6lymfo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773767729; c=relaxed/simple;
	bh=Q3MIFg26rnUGD3bXVkpjtp7xP6zgZj86bRClnAAxSTQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rhL1EwIxThqhZl/GzW+NNrBYgWj9TTZVQDReTAn5xMm3slq91ALAe/WWDL5DGVgSHNEIESkgsnuIEAKQ0qKEGaGPSTJFBjJdSYmYE7D4Zj14MVjm/z+RgCAEOS+x162KIkODZ8Enjz+2y7d8f0jeKlBVR30ygA2RnppRCuwIg3A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fStJv1OX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fStJv1OX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 04E2CC2BCC9;
	Tue, 17 Mar 2026 17:15:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773767729;
	bh=Q3MIFg26rnUGD3bXVkpjtp7xP6zgZj86bRClnAAxSTQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fStJv1OXX5wPCqfM1MTdzlHn3qkVxuI5vlr+gMYmw6zdhmgwppjTG+yRPcl7vh8QC
	 HiHWSW+Vj9TTwHdwiYjvvVOkMI0oAGA4VWexoENpq+XzfOQ8j+R11kYGFj+qClynw9
	 GEHTPQUfhNwLou1V0BTK+zOLTpbosp70MwVz9PJE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreas Kemnade <andreas@kemnade.info>,
	Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 102/333] iio: imu: inv-mpu9150: fix irq ack preventing irq storms
Date: Tue, 17 Mar 2026 17:32:11 +0100
Message-ID: <20260317163003.152886652@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260317162959.345812316@linuxfoundation.org>
References: <20260317162959.345812316@linuxfoundation.org>
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

From: Andreas Kemnade <andreas@kemnade.info>

[ Upstream commit d23d763e00ace4e9c59f8d33e0713d401133ba88 ]

IRQ needs to be acked. for some odd reasons, reading from irq status does
not reliable help, enable acking from any register to be on the safe side
and read the irq status register. Comments in the code indicate a known
unreliability with that register.
The blamed commit was tested with mpu6050 in lg,p895 and lg,p880 according
to Tested-bys. But with the MPU9150 in the Epson Moverio BT-200 this leads
to irq storms without properly acking the irq.

Fixes: 0a3b517c8089 ("iio: imu: inv_mpu6050: fix interrupt status read for old buggy chips")
Signed-off-by: Andreas Kemnade <andreas@kemnade.info>
Acked-by: Jean-Baptiste Maneyrol <jean-baptiste.maneyrol@tdk.com>
Signed-off-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/iio/imu/inv_mpu6050/inv_mpu_core.c    | 8 ++++++++
 drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h     | 2 ++
 drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c | 5 ++++-
 3 files changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
index b2fa1f4957a5b..5796896d54cd8 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_core.c
@@ -1943,6 +1943,14 @@ int inv_mpu_core_probe(struct regmap *regmap, int irq, const char *name,
 			irq_type);
 		return -EINVAL;
 	}
+
+	/*
+	 * Acking interrupts by status register does not work reliably
+	 * but seem to work when this bit is set.
+	 */
+	if (st->chip_type == INV_MPU9150)
+		st->irq_mask |= INV_MPU6050_INT_RD_CLEAR;
+
 	device_set_wakeup_capable(dev, true);
 
 	st->vdd_supply = devm_regulator_get(dev, "vdd");
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
index 211901f8b8eb6..6239b1a803f77 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_iio.h
@@ -390,6 +390,8 @@ struct inv_mpu6050_state {
 /* enable level triggering */
 #define INV_MPU6050_LATCH_INT_EN	0x20
 #define INV_MPU6050_BIT_BYPASS_EN	0x2
+/* allow acking interrupts by any register read */
+#define INV_MPU6050_INT_RD_CLEAR	0x10
 
 /* Allowed timestamp period jitter in percent */
 #define INV_MPU6050_TS_PERIOD_JITTER	4
diff --git a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
index 10a4733420759..22c1ce66f99ee 100644
--- a/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
+++ b/drivers/iio/imu/inv_mpu6050/inv_mpu_trigger.c
@@ -248,7 +248,6 @@ static irqreturn_t inv_mpu6050_interrupt_handle(int irq, void *p)
 	switch (st->chip_type) {
 	case INV_MPU6000:
 	case INV_MPU6050:
-	case INV_MPU9150:
 		/*
 		 * WoM is not supported and interrupt status read seems to be broken for
 		 * some chips. Since data ready is the only interrupt, bypass interrupt
@@ -257,6 +256,10 @@ static irqreturn_t inv_mpu6050_interrupt_handle(int irq, void *p)
 		wom_bits = 0;
 		int_status = INV_MPU6050_BIT_RAW_DATA_RDY_INT;
 		goto data_ready_interrupt;
+	case INV_MPU9150:
+		/* IRQ needs to be acked */
+		wom_bits = 0;
+		break;
 	case INV_MPU6500:
 	case INV_MPU6515:
 	case INV_MPU6880:
-- 
2.51.0



