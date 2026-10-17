Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337AC3AE198;
	Sat, 17 Oct 2026 16:43:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255385; cv=none; b=FcI02gr+yhcoZLfuc/mok0eSI3XAZHkRRAzKcR1sjcX03oOfR78aHWcJXhOh4X6Lymtod/OyOgsLvU6cvYlP2eC+IVJz/ubCOdr65O9jzWVD8RRs8MKyrvPwgianmwhv67uTpezdOnuv5Y69cY5t6Wk6VbtIrSB6+TB4HJyleYk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255385; c=relaxed/simple;
	bh=/Pp/vrm6PvJ9/tGy1ofgwWLBv7kvQqBAd59aHatgaUM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pZ4bKxDp2fMT0JTfKG1xYvJ/wKKVqoCB6HUxvXhWwRyM4bfhnPzmEY3kODmcMJe/6lvXMJgYijKVOPoI+jbD4k1TceXF6/ro7WZRChbZX0GVZovKQYK9bUW7BJQ/bAW1PsJdVoMDwihLlWIb5Vm7sIevX1btXUoa1qZlAJOItHg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rX5Sn5zW; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rX5Sn5zW"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2EF751F000C4;
	Sat, 17 Oct 2026 16:43:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255383;
	bh=Dio4QEA/zKQgk8gQa9+MT71xoNegO8RcoxxwbYD+RrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=rX5Sn5zWfGC18+LMqGa6PxFAg51X+qUiFSgBHnSKqzI/W353wo5CfwCbB0VDfknwp
	 mRqKpLWr/IZKg4Ugz77uhKRmmIyQWFm/0gi6xHhLtNcksiYsIJwshguesOsaal6Q/M
	 qCE+kOAqpD8gWieEY+2QyOlgV4pU8AN0ArrueDBo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Stanley Chu <yschu@nuvoton.com>,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 759/869] i3c: master: svc: Fix npcm845 FIFO empty issue
Date: Sat, 17 Oct 2026 18:00:00 +0200
Message-ID: <20261017160056.387224606@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanley Chu <yschu@nuvoton.com>

[ Upstream commit 4008a74e0f9b0ec25441028e324452933644ed2a ]

I3C HW stalls the write transfer if the transmit FIFO becomes empty,
when new data is written to FIFO, I3C HW resumes the transfer but the
first transmitted data bit may have the wrong value.
Fill the FIFO in advance to prevent FIFO from becoming empty.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Stanley Chu <yschu@nuvoton.com>
Link: https://lore.kernel.org/r/20250306075429.2265183-4-yschu@nuvoton.com
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Stable-dep-of: 1effa3adfe53 ("i3c: master: svc: Prevent IRQ storm from false SLVSTART on NPCM845")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i3c/master/svc-i3c-master.c | 71 +++++++++++++++++++++++++----
 1 file changed, 61 insertions(+), 10 deletions(-)

diff --git a/drivers/i3c/master/svc-i3c-master.c b/drivers/i3c/master/svc-i3c-master.c
index d5cc26955454a..a9107aef1eefe 100644
--- a/drivers/i3c/master/svc-i3c-master.c
+++ b/drivers/i3c/master/svc-i3c-master.c
@@ -113,6 +113,7 @@
 #define SVC_I3C_MWDATAHE     0x0BC
 #define SVC_I3C_MRDATAB      0x0C0
 #define SVC_I3C_MRDATAH      0x0C8
+#define SVC_I3C_MWDATAB1     0x0CC
 #define SVC_I3C_MWMSG_SDR    0x0D0
 #define SVC_I3C_MRMSG_SDR    0x0D4
 #define SVC_I3C_MWMSG_DDR    0x0D8
@@ -133,6 +134,16 @@
 #define SVC_I3C_EVENT_IBI	GENMASK(7, 0)
 #define SVC_I3C_EVENT_HOTJOIN	BIT(31)
 
+/*
+ * SVC_I3C_QUIRK_FIFO_EMPTY:
+ * I3C HW stalls the write transfer if the transmit FIFO becomes empty,
+ * when new data is written to FIFO, I3C HW resumes the transfer but
+ * the first transmitted data bit may have the wrong value.
+ * Workaround:
+ * Fill the FIFO in advance to prevent FIFO from becoming empty.
+ */
+#define SVC_I3C_QUIRK_FIFO_EMPTY	BIT(0)
+
 struct svc_i3c_cmd {
 	u8 addr;
 	bool rnw;
@@ -236,6 +247,11 @@ struct svc_i3c_i2c_dev_data {
 	struct i3c_generic_ibi_pool *ibi_pool;
 };
 
+static inline bool svc_has_quirk(struct svc_i3c_master *master, u32 quirk)
+{
+	return (master->drvdata->quirks & quirk);
+}
+
 static inline bool is_events_enabled(struct svc_i3c_master *master, u32 mask)
 {
 	return !!(master->enabled_events & mask);
@@ -892,7 +908,7 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 					u8 *addrs, unsigned int *count)
 {
 	u64 prov_id[SVC_I3C_MAX_DEVS] = {}, nacking_prov_id = 0;
-	unsigned int dev_nb = 0, last_addr = 0;
+	unsigned int dev_nb = 0, last_addr = 0, dyn_addr;
 	u32 reg;
 	int ret, i;
 
@@ -934,6 +950,25 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 		if (SVC_I3C_MSTATUS_RXPEND(reg)) {
 			u8 data[6];
 
+			/*
+			 * One slave sends its ID to request for address assignment,
+			 * prefilling the dynamic address can reduce SCL clock stalls
+			 * and also fix the SVC_I3C_QUIRK_FIFO_EMPTY quirk.
+			 *
+			 * Ideally, prefilling before the processDAA command is better.
+			 * However, it requires an additional check to write the dyn_addr
+			 * at the right time because the driver needs to write the processDAA
+			 * command twice for one assignment.
+			 * Prefilling here is safe and efficient because the FIFO starts
+			 * filling within a few hundred nanoseconds, which is significantly
+			 * faster compared to the 64 SCL clock cycles.
+			 */
+			dyn_addr = i3c_master_get_free_addr(&master->base, last_addr + 1);
+			if (dyn_addr < 0)
+				return -ENOSPC;
+
+			writel(dyn_addr, master->regs + SVC_I3C_MWDATAB);
+
 			/*
 			 * We only care about the 48-bit provisioned ID yet to
 			 * be sure a device does not nack an address twice.
@@ -1007,21 +1042,16 @@ static int svc_i3c_master_do_daa_locked(struct svc_i3c_master *master,
 		if (ret)
 			break;
 
-		/* Give the slave device a suitable dynamic address */
-		ret = i3c_master_get_free_addr(&master->base, last_addr + 1);
-		if (ret < 0)
-			break;
-
-		addrs[dev_nb] = ret;
+		addrs[dev_nb] = dyn_addr;
 		dev_dbg(master->dev, "DAA: device %d assigned to 0x%02x\n",
 			dev_nb, addrs[dev_nb]);
-
-		writel(addrs[dev_nb], master->regs + SVC_I3C_MWDATAB);
 		last_addr = addrs[dev_nb++];
 	}
 
 	/* Need manual issue STOP except for Complete condition */
 	svc_i3c_master_emit_stop(master);
+	svc_i3c_master_flush_fifo(master);
+
 	return ret;
 }
 
@@ -1218,6 +1248,24 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 		       SVC_I3C_MCTRL_RDTERM(*actual_len),
 		       master->regs + SVC_I3C_MCTRL);
 
+		/*
+		 * The entire transaction can consist of multiple write transfers.
+		 * Prefilling before EmitStartAddr causes the data to be emitted
+		 * immediately, becoming part of the previous transfer.
+		 * The only way to work around this hardware issue is to let the
+		 * FIFO start filling as soon as possible after EmitStartAddr.
+		 */
+		if (svc_has_quirk(master, SVC_I3C_QUIRK_FIFO_EMPTY) && !rnw && xfer_len) {
+			u32 end = xfer_len > SVC_I3C_FIFO_SIZE ? 0 : SVC_I3C_MWDATAB_END;
+			u32 len = min_t(u32, xfer_len, SVC_I3C_FIFO_SIZE);
+
+			writesb(master->regs + SVC_I3C_MWDATAB1, out, len - 1);
+			/* Mark END bit if this is the last byte */
+			writel(out[len - 1] | end, master->regs + SVC_I3C_MWDATAB);
+			xfer_len -= len;
+			out += len;
+		}
+
 		ret = readl_poll_timeout(master->regs + SVC_I3C_MSTATUS, reg,
 				 SVC_I3C_MSTATUS_MCTRLDONE(reg), 0, 1000);
 		if (ret)
@@ -1304,6 +1352,7 @@ static int svc_i3c_master_xfer(struct svc_i3c_master *master,
 emit_stop:
 	svc_i3c_master_emit_stop(master);
 	svc_i3c_master_clear_merrwarn(master);
+	svc_i3c_master_flush_fifo(master);
 
 	return ret;
 }
@@ -1958,7 +2007,9 @@ static const struct dev_pm_ops svc_i3c_pm_ops = {
 			   svc_i3c_runtime_resume, NULL)
 };
 
-static const struct svc_i3c_drvdata npcm845_drvdata = {};
+static const struct svc_i3c_drvdata npcm845_drvdata = {
+	.quirks = SVC_I3C_QUIRK_FIFO_EMPTY,
+};
 
 static const struct svc_i3c_drvdata svc_default_drvdata = {};
 
-- 
2.53.0



