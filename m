Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FA3C21356
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:33:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PjLhdNf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0359BC433C8;
	Wed,  4 Oct 2023 18:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696444391;
	bh=ie8HpCjJq/Qos7BcUA/bDkgofWHFL2lQb9w3aHe2Rvg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PjLhdNf3voRm3WhBPkL39hmqFUvm50CKsDY5Sb5KeK5oKJAN3xwfdEMdHhUllnI6e
	 Bf9S8XAnCvvgbOzu2wRqhbDmShceMuBLXnZcjas4ApY2UZpaT7Kb+D9fJP+7iYQOjp
	 J2NlE2lCHJhhX0WKVtbR5qQVZGUllg10ylxyHJuM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Borne <jborne@kalray.eu>,
	Yann Sionneau <ysionneau@kalray.eu>,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 233/321] i2c: designware: fix __i2c_dw_disable() in case master is holding SCL low
Date: Wed,  4 Oct 2023 19:56:18 +0200
Message-ID: <20231004175240.026955392@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yann Sionneau <ysionneau@kalray.eu>

[ Upstream commit 2409205acd3c7c877f3d0080cac6a5feb3358f83 ]

The DesignWare IP can be synthesized with the IC_EMPTYFIFO_HOLD_MASTER_EN
parameter.
In this case, when the TX FIFO gets empty and the last command didn't have
the STOP bit (IC_DATA_CMD[9]), the controller will hold SCL low until
a new command is pushed into the TX FIFO or the transfer is aborted.

When the controller is holding SCL low, it cannot be disabled.
The transfer must first be aborted.
Also, the bus recovery won't work because SCL is held low by the master.

Check if the master is holding SCL low in __i2c_dw_disable() before trying
to disable the controller. If SCL is held low, an abort is initiated.
When the abort is done, then proceed with disabling the controller.

This whole situation can happen for instance during SMBus read data block
if the slave just responds with "byte count == 0".
This puts the driver in an unrecoverable state, because the controller is
holding SCL low and the current __i2c_dw_disable() procedure is not
working. In this situation only a SoC reset can fix the i2c bus.

Co-developed-by: Jonathan Borne <jborne@kalray.eu>
Signed-off-by: Jonathan Borne <jborne@kalray.eu>
Signed-off-by: Yann Sionneau <ysionneau@kalray.eu>
Acked-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-common.c | 17 +++++++++++++++++
 drivers/i2c/busses/i2c-designware-core.h   |  3 +++
 2 files changed, 20 insertions(+)

diff --git a/drivers/i2c/busses/i2c-designware-common.c b/drivers/i2c/busses/i2c-designware-common.c
index cdd8c67d91298..affcfb243f0f5 100644
--- a/drivers/i2c/busses/i2c-designware-common.c
+++ b/drivers/i2c/busses/i2c-designware-common.c
@@ -441,8 +441,25 @@ int i2c_dw_set_sda_hold(struct dw_i2c_dev *dev)
 
 void __i2c_dw_disable(struct dw_i2c_dev *dev)
 {
+	unsigned int raw_intr_stats;
+	unsigned int enable;
 	int timeout = 100;
+	bool abort_needed;
 	unsigned int status;
+	int ret;
+
+	regmap_read(dev->map, DW_IC_RAW_INTR_STAT, &raw_intr_stats);
+	regmap_read(dev->map, DW_IC_ENABLE, &enable);
+
+	abort_needed = raw_intr_stats & DW_IC_INTR_MST_ON_HOLD;
+	if (abort_needed) {
+		regmap_write(dev->map, DW_IC_ENABLE, enable | DW_IC_ENABLE_ABORT);
+		ret = regmap_read_poll_timeout(dev->map, DW_IC_ENABLE, enable,
+					       !(enable & DW_IC_ENABLE_ABORT), 10,
+					       100);
+		if (ret)
+			dev_err(dev->dev, "timeout while trying to abort current transfer\n");
+	}
 
 	do {
 		__i2c_dw_disable_nowait(dev);
diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index cf4f684f53566..a7f6f3eafad7d 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -98,6 +98,7 @@
 #define DW_IC_INTR_START_DET			BIT(10)
 #define DW_IC_INTR_GEN_CALL			BIT(11)
 #define DW_IC_INTR_RESTART_DET			BIT(12)
+#define DW_IC_INTR_MST_ON_HOLD			BIT(13)
 
 #define DW_IC_INTR_DEFAULT_MASK			(DW_IC_INTR_RX_FULL | \
 						 DW_IC_INTR_TX_ABRT | \
@@ -108,6 +109,8 @@
 						 DW_IC_INTR_RX_UNDER | \
 						 DW_IC_INTR_RD_REQ)
 
+#define DW_IC_ENABLE_ABORT			BIT(1)
+
 #define DW_IC_STATUS_ACTIVITY			BIT(0)
 #define DW_IC_STATUS_TFE			BIT(2)
 #define DW_IC_STATUS_RFNE			BIT(3)
-- 
2.40.1



