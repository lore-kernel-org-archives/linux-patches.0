Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69FA729E0F8;
	Wed, 28 Jan 2026 16:02:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616142; cv=none; b=lhbMO6tSHmqtSyamTraCfjxpuVJsCx2UKYxnV3FyEnYeOxKIASDEWchMcdwsz71nKWpd8PbyShdaWJLTyKuMiBVsSogKYYcRhf4tOmO+rFuICFJvzCwJq1ZWhQ9nGgp15yUtGn1M5fRrPeVroBzLZxdbhoHhP+Cf0PKNOxTDmH0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616142; c=relaxed/simple;
	bh=iH+UFCDBsuOq2CKh8zcMTPp9qQBC6JEhVl3BMA06Qf4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Mx+VkXjsMLkSM+J1/Zqk5T3TEf67ryC9fx0qOOE+E5gN04TgNhiNhrx9zwHnCjBGDMoqJ+gJ2NgUhXAOhorqzsq1/VXPn177HLfsD9UH2eBRQ1xx+86swi4yexuTV3dkaQ4tI1+196yy2sLFy4eFNja5XO6g1beWzzhwAH1M5Ao=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XmL8Bye5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XmL8Bye5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1C21C4CEF1;
	Wed, 28 Jan 2026 16:02:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616142;
	bh=iH+UFCDBsuOq2CKh8zcMTPp9qQBC6JEhVl3BMA06Qf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XmL8Bye5b/OdBOOnPbzW+mp677WceTO/vOhSrTkUaQtGloGuW4xjsl9xnl6EQO0Mn
	 Yvp/K5XVz1VINgKB9W86T7ZFq8WTsNm6HUHfmwJqPPGv+5fc2K4liBYMDbTRTaK5Hn
	 6W8JjYQeDIdtH9OhE9a5yWDdIyIr2SPL5a4t1dIg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ravindra <ravindra@intel.com>,
	Kiran K <kiran.k@intel.com>,
	Luiz Augusto von Dentz <luiz.von.dentz@intel.com>,
	Mariappan Ramasamy <mail@nappairam.dev>
Subject: [PATCH 6.18 219/227] Bluetooth: btintel_pcie: Support for S4 (Hibernate)
Date: Wed, 28 Jan 2026 16:24:24 +0100
Message-ID: <20260128145352.312679196@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

From: Ravindra <ravindra@intel.com>

commit 1fb0d830dab89d0dc99bb84a7087b0ceca63d2d8 upstream.

During S4 (hibernate), the Bluetooth device loses power. Upon resume,
the driver performs the following actions:

1. Unregisters hdev
2. Calls function level reset
3. Registers hdev

Test case:
- run command sudo rtcwake -m disk -s 60

Signed-off-by: Ravindra <ravindra@intel.com>
Signed-off-by: Kiran K <kiran.k@intel.com>
Signed-off-by: Luiz Augusto von Dentz <luiz.von.dentz@intel.com>
Cc: Mariappan Ramasamy <mail@nappairam.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/bluetooth/btintel_pcie.c |   41 +++++++++++++++++++++++++++++++++++++++
 drivers/bluetooth/btintel_pcie.h |    2 +
 2 files changed, 43 insertions(+)

--- a/drivers/bluetooth/btintel_pcie.c
+++ b/drivers/bluetooth/btintel_pcie.c
@@ -825,6 +825,11 @@ static inline bool btintel_pcie_in_d0(st
 	return !(data->boot_stage_cache & BTINTEL_PCIE_CSR_BOOT_STAGE_D3_STATE_READY);
 }
 
+static inline bool btintel_pcie_in_device_halt(struct btintel_pcie_data *data)
+{
+	return data->boot_stage_cache & BTINTEL_PCIE_CSR_BOOT_STAGE_DEVICE_HALTED;
+}
+
 static void btintel_pcie_wr_sleep_cntrl(struct btintel_pcie_data *data,
 					u32 dxstate)
 {
@@ -2532,6 +2537,8 @@ static int btintel_pcie_suspend_late(str
 	dxstate = (mesg.event == PM_EVENT_SUSPEND ?
 		   BTINTEL_PCIE_STATE_D3_HOT : BTINTEL_PCIE_STATE_D3_COLD);
 
+	data->pm_sx_event = mesg.event;
+
 	data->gp0_received = false;
 
 	start = ktime_get();
@@ -2581,6 +2588,20 @@ static int btintel_pcie_resume(struct de
 
 	start = ktime_get();
 
+	/* When the system enters S4 (hibernate) mode, bluetooth device loses
+	 * power, which results in the erasure of its loaded firmware.
+	 * Consequently, function level reset (flr) is required on system
+	 * resume to bring the controller back into an operational state by
+	 * initiating a new firmware download.
+	 */
+
+	if (data->pm_sx_event == PM_EVENT_FREEZE ||
+	    data->pm_sx_event == PM_EVENT_HIBERNATE) {
+		set_bit(BTINTEL_PCIE_CORE_HALTED, &data->flags);
+		btintel_pcie_reset(data->hdev);
+		return 0;
+	}
+
 	/* Refer: 6.4.11.7 -> Platform power management */
 	btintel_pcie_wr_sleep_cntrl(data, BTINTEL_PCIE_STATE_D0);
 	err = wait_event_timeout(data->gp0_wait_q, data->gp0_received,
@@ -2589,6 +2610,26 @@ static int btintel_pcie_resume(struct de
 		bt_dev_err(data->hdev,
 			   "Timeout (%u ms) on alive interrupt for D0 entry",
 			   BTINTEL_DEFAULT_INTR_TIMEOUT_MS);
+
+		/* Trigger function level reset if the controller is in error
+		 * state during resume() to bring back the controller to
+		 * operational mode
+		 */
+
+		data->boot_stage_cache = btintel_pcie_rd_reg32(data,
+				BTINTEL_PCIE_CSR_BOOT_STAGE_REG);
+		if (btintel_pcie_in_error(data) ||
+				btintel_pcie_in_device_halt(data)) {
+			bt_dev_err(data->hdev, "Controller in error state for D0 entry");
+			if (!test_and_set_bit(BTINTEL_PCIE_COREDUMP_INPROGRESS,
+					      &data->flags)) {
+				data->dmp_hdr.trigger_reason =
+					BTINTEL_PCIE_TRIGGER_REASON_FW_ASSERT;
+				queue_work(data->workqueue, &data->rx_work);
+			}
+			set_bit(BTINTEL_PCIE_CORE_HALTED, &data->flags);
+			btintel_pcie_reset(data->hdev);
+		}
 		return -EBUSY;
 	}
 
--- a/drivers/bluetooth/btintel_pcie.h
+++ b/drivers/bluetooth/btintel_pcie.h
@@ -464,6 +464,7 @@ struct btintel_pcie_dump_header {
  * @txq: TX Queue struct
  * @rxq: RX Queue struct
  * @alive_intr_ctxt: Alive interrupt context
+ * @pm_sx_event: PM event on which system got suspended
  */
 struct btintel_pcie_data {
 	struct pci_dev	*pdev;
@@ -513,6 +514,7 @@ struct btintel_pcie_data {
 	u32	alive_intr_ctxt;
 	struct btintel_pcie_dbgc	dbgc;
 	struct btintel_pcie_dump_header dmp_hdr;
+	u8	pm_sx_event;
 };
 
 static inline u32 btintel_pcie_rd_reg32(struct btintel_pcie_data *data,


