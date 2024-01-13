Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62A431848;
	Sat, 13 Jan 2024 09:56:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ogrMAFf3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D1148C433F1;
	Sat, 13 Jan 2024 09:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705139783;
	bh=zPFQ9Gs91xdsM9xrHU/ngR1EE6KY8HGmJtB8NyS838E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ogrMAFf3pD3VZJd+c/dbU4wCiQJMvJN4bOa616PTqchRA6r/6YblCx/ZW5pJqGMDb
	 ozy7yH7y+vvcUdwGNAeVCIfn4CJ5VKb2W9qWH1M9gmX7wnCJKzvOyEc7++CU5lBcnk
	 a2l40GL2KuP58x7FNYytmjEeULJDDgx/IFhXYx0I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Douglas Anderson <dianders@chromium.org>,
	Kalle Valo <kvalo@codeaurora.org>,
	Amit Pundir <amit.pundir@linaro.org>
Subject: [PATCH 5.4 28/38] ath10k: Wait until copy complete is actually done before completing
Date: Sat, 13 Jan 2024 10:50:04 +0100
Message-ID: <20240113094207.316101222@linuxfoundation.org>
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

From: Douglas Anderson <dianders@chromium.org>

[ Upstream commit 8f9ed93d09a97444733d492a3bbf66bcb786a777 ]

On wcn3990 we have "per_ce_irq = true".  That makes the
ath10k_ce_interrupt_summary() function always return 0xfff. The
ath10k_ce_per_engine_service_any() function will see this and think
that _all_ copy engines have an interrupt.  Without checking, the
ath10k_ce_per_engine_service() assumes that if it's called that the
"copy complete" (cc) interrupt fired.  This combination seems bad.

Let's add a check to make sure that the "copy complete" interrupt
actually fired in ath10k_ce_per_engine_service().

This might fix a hard-to-reproduce failure where it appears that the
copy complete handlers run before the copy is really complete.
Specifically a symptom was that we were seeing this on a Qualcomm
sc7180 board:
  arm-smmu 15000000.iommu: Unhandled context fault:
  fsr=0x402, iova=0x7fdd45780, fsynr=0x30003, cbfrsynra=0xc1, cb=10

Even on platforms that don't have wcn3990 this still seems like it
would be a sane thing to do.  Specifically the current IRQ handler
comments indicate that there might be other misc interrupt sources
firing that need to be cleared.  If one of those sources was the one
that caused the IRQ handler to be called it would also be important to
double-check that the interrupt we cared about actually fired.

Tested-on: WCN3990 SNOC WLAN.HL.3.2.2-00490-QCAHLSWMTPL-1

Signed-off-by: Douglas Anderson <dianders@chromium.org>
Signed-off-by: Kalle Valo <kvalo@codeaurora.org>
Link: https://lore.kernel.org/r/20200609082015.1.Ife398994e5a0a6830e4d4a16306ef36e0144e7ba@changeid
Stable-dep-of: 170c75d43a77 ("ath10k: Don't touch the CE interrupt registers after power up")
Signed-off-by: Amit Pundir <amit.pundir@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/ath/ath10k/ce.c |   30 +++++++++++++++++++++---------
 1 file changed, 21 insertions(+), 9 deletions(-)

--- a/drivers/net/wireless/ath/ath10k/ce.c
+++ b/drivers/net/wireless/ath/ath10k/ce.c
@@ -481,6 +481,15 @@ static inline void ath10k_ce_engine_int_
 	ath10k_ce_write32(ar, ce_ctrl_addr + wm_regs->addr, mask);
 }
 
+static inline bool ath10k_ce_engine_int_status_check(struct ath10k *ar,
+						     u32 ce_ctrl_addr,
+						     unsigned int mask)
+{
+	struct ath10k_hw_ce_host_wm_regs *wm_regs = ar->hw_ce_regs->wm_regs;
+
+	return ath10k_ce_read32(ar, ce_ctrl_addr + wm_regs->addr) & mask;
+}
+
 /*
  * Guts of ath10k_ce_send.
  * The caller takes responsibility for any needed locking.
@@ -1301,19 +1310,22 @@ void ath10k_ce_per_engine_service(struct
 
 	spin_lock_bh(&ce->ce_lock);
 
-	/* Clear the copy-complete interrupts that will be handled here. */
-	ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
-					  wm_regs->cc_mask);
+	if (ath10k_ce_engine_int_status_check(ar, ctrl_addr,
+					      wm_regs->cc_mask)) {
+		/* Clear before handling */
+		ath10k_ce_engine_int_status_clear(ar, ctrl_addr,
+						  wm_regs->cc_mask);
 
-	spin_unlock_bh(&ce->ce_lock);
+		spin_unlock_bh(&ce->ce_lock);
 
-	if (ce_state->recv_cb)
-		ce_state->recv_cb(ce_state);
+		if (ce_state->recv_cb)
+			ce_state->recv_cb(ce_state);
 
-	if (ce_state->send_cb)
-		ce_state->send_cb(ce_state);
+		if (ce_state->send_cb)
+			ce_state->send_cb(ce_state);
 
-	spin_lock_bh(&ce->ce_lock);
+		spin_lock_bh(&ce->ce_lock);
+	}
 
 	/*
 	 * Misc CE interrupts are not being handled, but still need


