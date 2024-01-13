Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E63EC5;
	Sat, 13 Jan 2024 09:56:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o9wzHdKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE0E4C43390;
	Sat, 13 Jan 2024 09:56:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139786;
	bh=KhEH+g8ExSeecwpEINSqzJ9WmQK4HhFJFuMdFQNEKGM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o9wzHdKGi0vVzw/LanCwRTPjHlCWWOGyxz3zuwaMxgv+53GnfhyM84EH9XCNsy/v+
	 IZv0CyoRLNVp+Tcy8Z53G81ysJltrfx4IN+DUZ7eJTjzNGsBsd3mgs5EtY/oQkjdf1
	 ae/vpktyPbgTiDUPpXRP7Zk+o9MXrFXKXjHpqHCw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rakesh Pillai <pillair@codeaurora.org>,
	Douglas Anderson <dianders@chromium.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 29/38] ath10k: Add interrupt summary based CE processing
Date: Sat, 13 Jan 2024 10:50:05 +0100
Message-ID: <20240113094207.349744576@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240113094206.455533180@linuxfoundation.org>
References: <20240113094206.455533180@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rakesh Pillai <pillair@codeaurora.org>

[ Upstream commit b92aba35d39d10d8a6bdf2495172fd490c598b4a ]

Currently the NAPI processing loops through all
the copy engines and processes a particular copy
engine is the copy completion is set for that copy
engine. The host driver is not supposed to access
any copy engine register after clearing the interrupt
status register.

This might result in kernel crash like the one below
[ 1159.220143] Call trace:
[ 1159.220170]  ath10k_snoc_read32+0x20/0x40 [ath10k_snoc]
[ 1159.220193]  ath10k_ce_per_engine_service_any+0x78/0x130 [ath10k_core]
[ 1159.220203]  ath10k_snoc_napi_poll+0x38/0x8c [ath10k_snoc]
[ 1159.220270]  net_rx_action+0x100/0x3b0
[ 1159.220312]  __do_softirq+0x164/0x30c
[ 1159.220345]  run_ksoftirqd+0x2c/0x64
[ 1159.220380]  smpboot_thread_fn+0x1b0/0x288
[ 1159.220405]  kthread+0x11c/0x12c
[ 1159.220423]  ret_from_fork+0x10/0x18

To avoid such a scenario, we generate an interrupt
summary by reading the copy completion for all the
copy engine before actually processing any of them.
This will avoid reading the interrupt status register
for any CE after the interrupt status is cleared.

Tested-on: WCN3990 hw1.0 SNOC WLAN.HL.3.1-01040-QCAHLSWMTPLZ-1

Signed-off-by: Rakesh Pillai <pillair@codeaurora.org>
Reviewed-by: Douglas Anderson <dianders@chromium.org>
Tested-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/1593193967-29897-1-git-send-email-pillair@codeaurora.org
Stable-dep-of: 170c75d43a77 ("ath10k: Don't touch the CE interrupt registers after power up")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/ce.c |   63 +++++++++++++++++++++--------------
 drivers/net/wireless/ath/ath10k/ce.h |    5 +-
 2 files changed, 42 insertions(+), 26 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -481,15 +481,38 @@ static inline void ath10k_ce_engine_int_
 	ath10k_ce_write32(ar, ce_ctrl_addr + wm_regs->addr, mask);
 }
 
-static inline bool ath10k_ce_engine_int_status_check(struct ath10k *ar,
-						     u32 ce_ctrl_addr,
-						     unsigned int mask)
+static bool ath10k_ce_engine_int_status_check(struct ath10k *ar, u32 ce_ctrl_addr,
+					      unsigned int mask)
 {
 	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
 
 	return ath10k_ce_read32(ar, ce_ctrl_addr + wm_regs->addr) & mask;
 }
 
+u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar)
+{
+	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
+	struct ath10k_ce_pipe *ce_state;
+	struct ath10k_ce *ce;
+	u32 irq_summary = 0;
+	u32 ctrl_addr;
+	u32 ce_id;
+
+	ce = ath10k_ce_priv(ar);
+
+	for (ce_id = 0; ce_id < CE_COUNT; ce_id++) {
+		ce_state = &ce->ce_states[ce_id];
+		ctrl_addr = ce_state->ctrl_addr;
+		if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
+						      wm_regs->cc_mask)) {
+			irq_summary |= BIT(ce_id);
+		}
+	}
+
+	return irq_summary;
+}
+EXPORT_SYMBOL(ath10k_ce_gen_interrupt_summary);
+
 /*
  * Guts of ath10k_ce_send.
  * The caller takes responsibility for any needed locking.
@@ -1308,32 +1331,24 @@ void ath10k_ce_per_engine_service(struct
 	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
 	u32 ctrl_addr = ce_state->ctrl_addr;
 
-	spin_lock_bh(&ce->ce_lock);
-
-	if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
-					      wm_regs->cc_mask)) {
-		/* Clear before handling */
-		ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
-						  wm_regs->cc_mask);
-
-		spin_unlock_bh(&ce->ce_lock);
-
-		if (ce_state->recv_cb)
-			ce_state->recv_cb(ce_state);
-
-		if (ce_state->send_cb)
-			ce_state->send_cb(ce_state);
-
-		spin_lock_bh(&ce->ce_lock);
-	}
-
 	/*
+	 * Clear before handling
+	 *
 	 * Misc CE interrupts are not being handled, but still need
 	 * to be cleared.
+	 *
+	 * NOTE: When the last copy engine interrupt is cleared the
+	 * hardware will go to sleep.  Once this happens any access to
+	 * the CE registers can cause a hardware fault.
 	 */
-	ath10k_ce_engine_int_status_clear(ar, ctrl_addr, wm_regs->wm_mask);
+	ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
+					  wm_regs->cc_mask | wm_regs->wm_mask);
 
-	spin_unlock_bh(&ce->ce_lock);
+	if (ce_state->recv_cb)
+		ce_state->recv_cb(ce_state);
+
+	if (ce_state->send_cb)
+		ce_state->send_cb(ce_state);
 }
 EXPORT_SYMBOL(ath10k_ce_per_engine_service);
 
--- a/drivers/net/wireless/ath/ath10k/ce.h
+++ b/drivers/net/wireless/ath/ath10k/ce.h
@@ -259,6 +259,8 @@ int ath10k_ce_disable_interrupts(struct
 void ath10k_ce_enable_interrupts(struct ath10k *ar);
 void ath10k_ce_dump_registers(struct ath10k *ar,
 			      struct ath10k_fw_crash_data *crash_data);
+
+u32 ath10k_ce_gen_interrupt_summary(struct ath10k *ar);
 void ath10k_ce_alloc_rri(struct ath10k *ar);
 void ath10k_ce_free_rri(struct ath10k *ar);
 
@@ -369,7 +371,6 @@ static inline u32 ath10k_ce_base_address
 	(((x) & CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_MASK) >> \
 		CE_WRAPPER_INTERRUPT_SUMMARY_HOST_MSI_LSB)
 #define CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS			0x0000
-#define CE_INTERRUPT_SUMMARY		(GENMASK(CE_COUNT_MAX - 1, 0))
 
 static inline u32 ath10k_ce_interrupt_summary(struct ath10k *ar)
 {
@@ -380,7 +381,7 @@ static inline u32 ath10k_ce_interrupt_su
 			ce->bus_ops->read32((ar), CE_WRAPPER_BASE_ADDRESS +
 			CE_WRAPPER_INTERRUPT_SUMMARY_ADDRESS));
 	else
-		return CE_INTERRUPT_SUMMARY;
+		return ath10k_ce_gen_interrupt_summary(ar);
 }
 
 /* Host software's Copy Engine configuration. */


