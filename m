Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D1272259D8;
	Tue, 12 Nov 2024 10:37:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1731407852; cv=none; b=n3woB3Xgac5vcE0tmP9E6lnCxm/+D2f/VxZAFa6dzzwR2v2S7DP64wExO/UMVMJn/LvkhAQohrh0WDfdVnLbTt92EGbqiXk19mpewZs25VCxaAXBSE+Ff8r5qTjV4whXSabeg5oi6FZuC7bRuiv5T0F8G76Deebv732pv9t8VAM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1731407852; c=relaxed/simple;
	bh=czKzXDfdfYlX/3Q3+OSUa/ZS4JGYpnoyhoFyCAgwEEE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=C5BiWW7S0gqSmKgeYB7DDRUkioahnwymCBQplWkxvmfJHxOIRzTbICYY0wO/+bRelX+kJnKsDUj9jsMYAP1qWfAdjtmnaXnjNpgZWxaH7P7NPMtso/ztk2t4RNVucstBCR+cZqUspTJdgwtd8tcWDq9Nptnpv7h7IwNjEPd/eoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lh8OGkwL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lh8OGkwL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6097C4CED6;
	Tue, 12 Nov 2024 10:37:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1731407852;
	bh=czKzXDfdfYlX/3Q3+OSUa/ZS4JGYpnoyhoFyCAgwEEE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Lh8OGkwLcA10WP3ViMSE1GctYPHc9/APV/0LtY61f4oIOhgl523ziMzqQfzzx6Szt
	 khJfoTeAYuGfLj0X+Qfir5PIj6mfE8YrfBlsHS2SpdVHiNrwEKz2ljemZxtVZgdlj0
	 WRa39lZ8DwEqGUncmjgG7WHynl+Ayvh+GxEE+K18=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiaowu Ding <xiaowu.ding@jaguarmicro.com>,
	Angus Chen <angus.chen@jaguarmicro.com>,
	Liu Peibao <loven.liu@jaguarmicro.com>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 6.6 103/119] i2c: designware: do not hold SCL low when I2C_DYNAMIC_TAR_UPDATE is not set
Date: Tue, 12 Nov 2024 11:21:51 +0100
Message-ID: <20241112101852.660783954@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241112101848.708153352@linuxfoundation.org>
References: <20241112101848.708153352@linuxfoundation.org>
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

From: Liu Peibao <loven.liu@jaguarmicro.com>

commit 8de3e97f3d3d62cd9f3067f073e8ac93261597db upstream.

When the Tx FIFO is empty and the last command has no STOP bit
set, the master holds SCL low. If I2C_DYNAMIC_TAR_UPDATE is not
set, BIT(13) MST_ON_HOLD of IC_RAW_INTR_STAT is not enabled,
causing the __i2c_dw_disable() timeout. This is quite similar to
commit 2409205acd3c ("i2c: designware: fix __i2c_dw_disable() in
case master is holding SCL low"). Also check BIT(7)
MST_HOLD_TX_FIFO_EMPTY in IC_STATUS, which is available when
IC_STAT_FOR_CLK_STRETCH is set.

Fixes: 2409205acd3c ("i2c: designware: fix __i2c_dw_disable() in case master is holding SCL low")
Co-developed-by: Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
Signed-off-by: Xiaowu Ding <xiaowu.ding@jaguarmicro.com>
Co-developed-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
Signed-off-by: Liu Peibao <loven.liu@jaguarmicro.com>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-designware-common.c |    6 ++++--
 drivers/i2c/busses/i2c-designware-core.h   |    1 +
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -442,7 +442,7 @@ err_release_lock:
 void __i2c_dw_disable(struct dw_i2c_dev *dev)
 {
 	struct i2c_timings *t = &dev->timings;
-	unsigned int raw_intr_stats;
+	unsigned int raw_intr_stats, ic_stats;
 	unsigned int enable;
 	int timeout = 100;
 	bool abort_needed;
@@ -450,9 +450,11 @@ void __i2c_dw_disable(struct dw_i2c_dev
 	int ret;
 
 	regmap_read(dev->map, DW_IC_RAW_INTR_STAT, &raw_intr_stats);
+	regmap_read(dev->map, DW_IC_STATUS, &ic_stats);
 	regmap_read(dev->map, DW_IC_ENABLE, &enable);
 
-	abort_needed = raw_intr_stats & DW_IC_INTR_MST_ON_HOLD;
+	abort_needed = (raw_intr_stats & DW_IC_INTR_MST_ON_HOLD) ||
+			(ic_stats & DW_IC_STATUS_MASTER_HOLD_TX_FIFO_EMPTY);
 	if (abort_needed) {
 		if (!(enable & DW_IC_ENABLE_ENABLE)) {
 			regmap_write(dev->map, DW_IC_ENABLE, DW_IC_ENABLE_ENABLE);
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -117,6 +117,7 @@
 #define DW_IC_STATUS_RFNE			BIT(3)
 #define DW_IC_STATUS_MASTER_ACTIVITY		BIT(5)
 #define DW_IC_STATUS_SLAVE_ACTIVITY		BIT(6)
+#define DW_IC_STATUS_MASTER_HOLD_TX_FIFO_EMPTY	BIT(7)
 
 #define DW_IC_SDA_HOLD_RX_SHIFT			16
 #define DW_IC_SDA_HOLD_RX_MASK			GENMASK(23, 16)


