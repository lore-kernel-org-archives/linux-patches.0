Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24DD7298CB0;
	Wed, 23 Apr 2025 15:23:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421801; cv=none; b=lS77d4FdBHvSj80IXZXKrAJfzgF62GoprBX7i2QgcwqOm9rT9ny7J0e4DxStfXpI2Hk8O+ziCEeuu9kuVqpSzes2lFq6v0kgoPZlvu0ZSQH+W35DWFdJbFuyOAVX5ltL9I8ub4AWRq+m0tRkVf9wHmHrzLxFtQKxnzMgUDIduBk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421801; c=relaxed/simple;
	bh=YF9hJuCkZRtdpax4VgOAoN479O3l001IO7mKNj1nQ1Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=T/w+RA+I+A0rqtwwjrI2eIkbsHJ4nLqstNNG8TPGarlRdrF1RrrNsH5qXEVPXyBZCkyOTT0JuUx2lXMHA3QXUltZnCiB/MkwgWJsKjyIsSi/uKo8rmOJO8Bfbzl7WXMbrTMEy/GmdMcYLcravKAwTMbNZLOW9ZXkx6LcasrBztg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WnwqcWXB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WnwqcWXB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C21AC4CEE2;
	Wed, 23 Apr 2025 15:23:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421799;
	bh=YF9hJuCkZRtdpax4VgOAoN479O3l001IO7mKNj1nQ1Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WnwqcWXBSo+8qel4AJHCoiGyGeQJcmQJg04oeSiGiGR2Dxzae0GUPjAjYT1y5EIyy
	 E8gbnaQTGbmS98VDRuy2KssgFVeGZke+JtFGBhKe7NpXctmUeBmJIZBuMHjqxUJ2pU
	 BxT9ioJBPhl1baS8UIryHpY/xcqbTgzTqNUFkG3w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Mor Bar-Gabay <morx.bar.gabay@intel.com>,
	Avigail Dahan <avigailx.dahan@intel.com>,
	Christopher S M Hall <christopher.s.hall@intel.com>,
	Corinna Vinschen <vinschen@redhat.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Vinicius Costa Gomes <vinicius.gomes@intel.com>,
	Tony Nguyen <anthony.l.nguyen@intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 180/291] igc: fix PTM cycle trigger logic
Date: Wed, 23 Apr 2025 16:42:49 +0200
Message-ID: <20250423142631.736431278@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142624.409452181@linuxfoundation.org>
References: <20250423142624.409452181@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christopher S M Hall <christopher.s.hall@intel.com>

[ Upstream commit 8e404ad95d2c10c261e2ef6992c7c12dde03df0e ]

Writing to clear the PTM status 'valid' bit while the PTM cycle is
triggered results in unreliable PTM operation. To fix this, clear the
PTM 'trigger' and status after each PTM transaction.

The issue can be reproduced with the following:

$ sudo phc2sys -R 1000 -O 0 -i tsn0 -m

Note: 1000 Hz (-R 1000) is unrealistically large, but provides a way to
quickly reproduce the issue.

PHC2SYS exits with:

"ioctl PTP_OFFSET_PRECISE: Connection timed out" when the PTM transaction
  fails

This patch also fixes a hang in igc_probe() when loading the igc
driver in the kdump kernel on systems supporting PTM.

The igc driver running in the base kernel enables PTM trigger in
igc_probe().  Therefore the driver is always in PTM trigger mode,
except in brief periods when manually triggering a PTM cycle.

When a crash occurs, the NIC is reset while PTM trigger is enabled.
Due to a hardware problem, the NIC is subsequently in a bad busmaster
state and doesn't handle register reads/writes.  When running
igc_probe() in the kdump kernel, the first register access to a NIC
register hangs driver probing and ultimately breaks kdump.

With this patch, igc has PTM trigger disabled most of the time,
and the trigger is only enabled for very brief (10 - 100 us) periods
when manually triggering a PTM cycle.  Chances that a crash occurs
during a PTM trigger are not 0, but extremely reduced.

Fixes: a90ec8483732 ("igc: Add support for PTP getcrosststamp()")
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Tested-by: Mor Bar-Gabay <morx.bar.gabay@intel.com>
Tested-by: Avigail Dahan <avigailx.dahan@intel.com>
Signed-off-by: Christopher S M Hall <christopher.s.hall@intel.com>
Reviewed-by: Corinna Vinschen <vinschen@redhat.com>
Signed-off-by: Jacob Keller <jacob.e.keller@intel.com>
Tested-by: Corinna Vinschen <vinschen@redhat.com>
Acked-by: Vinicius Costa Gomes <vinicius.gomes@intel.com>
Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/intel/igc/igc_defines.h |  1 +
 drivers/net/ethernet/intel/igc/igc_ptp.c     | 70 ++++++++++++--------
 2 files changed, 42 insertions(+), 29 deletions(-)

diff --git a/drivers/net/ethernet/intel/igc/igc_defines.h b/drivers/net/ethernet/intel/igc/igc_defines.h
index 8187a658dcbd5..17a7e3c875ccb 100644
--- a/drivers/net/ethernet/intel/igc/igc_defines.h
+++ b/drivers/net/ethernet/intel/igc/igc_defines.h
@@ -574,6 +574,7 @@
 #define IGC_PTM_STAT_T4M1_OVFL		BIT(3) /* T4 minus T1 overflow */
 #define IGC_PTM_STAT_ADJUST_1ST		BIT(4) /* 1588 timer adjusted during 1st PTM cycle */
 #define IGC_PTM_STAT_ADJUST_CYC		BIT(5) /* 1588 timer adjusted during non-1st PTM cycle */
+#define IGC_PTM_STAT_ALL		GENMASK(5, 0) /* Used to clear all status */
 
 /* PCIe PTM Cycle Control */
 #define IGC_PTM_CYCLE_CTRL_CYC_TIME(msec)	((msec) & 0x3ff) /* PTM Cycle Time (msec) */
diff --git a/drivers/net/ethernet/intel/igc/igc_ptp.c b/drivers/net/ethernet/intel/igc/igc_ptp.c
index 14cd7f995280d..b4720545191ff 100644
--- a/drivers/net/ethernet/intel/igc/igc_ptp.c
+++ b/drivers/net/ethernet/intel/igc/igc_ptp.c
@@ -844,13 +844,40 @@ static void igc_ptm_log_error(struct igc_adapter *adapter, u32 ptm_stat)
 	}
 }
 
+static void igc_ptm_trigger(struct igc_hw *hw)
+{
+	u32 ctrl;
+
+	/* To "manually" start the PTM cycle we need to set the
+	 * trigger (TRIG) bit
+	 */
+	ctrl = rd32(IGC_PTM_CTRL);
+	ctrl |= IGC_PTM_CTRL_TRIG;
+	wr32(IGC_PTM_CTRL, ctrl);
+	/* Perform flush after write to CTRL register otherwise
+	 * transaction may not start
+	 */
+	wrfl();
+}
+
+static void igc_ptm_reset(struct igc_hw *hw)
+{
+	u32 ctrl;
+
+	ctrl = rd32(IGC_PTM_CTRL);
+	ctrl &= ~IGC_PTM_CTRL_TRIG;
+	wr32(IGC_PTM_CTRL, ctrl);
+	/* Write to clear all status */
+	wr32(IGC_PTM_STAT, IGC_PTM_STAT_ALL);
+}
+
 static int igc_phc_get_syncdevicetime(ktime_t *device,
 				      struct system_counterval_t *system,
 				      void *ctx)
 {
-	u32 stat, t2_curr_h, t2_curr_l, ctrl;
 	struct igc_adapter *adapter = ctx;
 	struct igc_hw *hw = &adapter->hw;
+	u32 stat, t2_curr_h, t2_curr_l;
 	int err, count = 100;
 	ktime_t t1, t2_curr;
 
@@ -864,25 +891,13 @@ static int igc_phc_get_syncdevicetime(ktime_t *device,
 		 * are transitory. Repeating the process returns valid
 		 * data eventually.
 		 */
-
-		/* To "manually" start the PTM cycle we need to clear and
-		 * then set again the TRIG bit.
-		 */
-		ctrl = rd32(IGC_PTM_CTRL);
-		ctrl &= ~IGC_PTM_CTRL_TRIG;
-		wr32(IGC_PTM_CTRL, ctrl);
-		ctrl |= IGC_PTM_CTRL_TRIG;
-		wr32(IGC_PTM_CTRL, ctrl);
-
-		/* The cycle only starts "for real" when software notifies
-		 * that it has read the registers, this is done by setting
-		 * VALID bit.
-		 */
-		wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+		igc_ptm_trigger(hw);
 
 		err = readx_poll_timeout(rd32, IGC_PTM_STAT, stat,
 					 stat, IGC_PTM_STAT_SLEEP,
 					 IGC_PTM_STAT_TIMEOUT);
+		igc_ptm_reset(hw);
+
 		if (err < 0) {
 			netdev_err(adapter->netdev, "Timeout reading IGC_PTM_STAT register\n");
 			return err;
@@ -891,15 +906,7 @@ static int igc_phc_get_syncdevicetime(ktime_t *device,
 		if ((stat & IGC_PTM_STAT_VALID) == IGC_PTM_STAT_VALID)
 			break;
 
-		if (stat & ~IGC_PTM_STAT_VALID) {
-			/* An error occurred, log it. */
-			igc_ptm_log_error(adapter, stat);
-			/* The STAT register is write-1-to-clear (W1C),
-			 * so write the previous error status to clear it.
-			 */
-			wr32(IGC_PTM_STAT, stat);
-			continue;
-		}
+		igc_ptm_log_error(adapter, stat);
 	} while (--count);
 
 	if (!count) {
@@ -1081,7 +1088,7 @@ void igc_ptp_stop(struct igc_adapter *adapter)
 void igc_ptp_reset(struct igc_adapter *adapter)
 {
 	struct igc_hw *hw = &adapter->hw;
-	u32 cycle_ctrl, ctrl;
+	u32 cycle_ctrl, ctrl, stat;
 	unsigned long flags;
 	u32 timadj;
 
@@ -1116,14 +1123,19 @@ void igc_ptp_reset(struct igc_adapter *adapter)
 		ctrl = IGC_PTM_CTRL_EN |
 			IGC_PTM_CTRL_START_NOW |
 			IGC_PTM_CTRL_SHRT_CYC(IGC_PTM_SHORT_CYC_DEFAULT) |
-			IGC_PTM_CTRL_PTM_TO(IGC_PTM_TIMEOUT_DEFAULT) |
-			IGC_PTM_CTRL_TRIG;
+			IGC_PTM_CTRL_PTM_TO(IGC_PTM_TIMEOUT_DEFAULT);
 
 		wr32(IGC_PTM_CTRL, ctrl);
 
 		/* Force the first cycle to run. */
-		wr32(IGC_PTM_STAT, IGC_PTM_STAT_VALID);
+		igc_ptm_trigger(hw);
+
+		if (readx_poll_timeout_atomic(rd32, IGC_PTM_STAT, stat,
+					      stat, IGC_PTM_STAT_SLEEP,
+					      IGC_PTM_STAT_TIMEOUT))
+			netdev_err(adapter->netdev, "Timeout reading IGC_PTM_STAT register\n");
 
+		igc_ptm_reset(hw);
 		break;
 	default:
 		/* No work to do. */
-- 
2.39.5



