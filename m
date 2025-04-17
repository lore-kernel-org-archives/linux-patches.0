Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF16B25742C;
	Thu, 17 Apr 2025 18:52:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915964; cv=none; b=KV75r5oLOFNsW5PN6oJUIc/bkaieaFBRCdcyFmFYFMC1bhg+BwQD/dBwl0jR7hcT96Ts+ax78qXxSWFidHO9ojXtHbswiGioNez+GUswfmz0wIBOcpiiDsR13nhMyuPXn8p+vqzjA0wfqpnR1Y42fe+lARzcpDgnyNNZI+Xn20U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915964; c=relaxed/simple;
	bh=hm5osy8C38ZyqBJe6fOS4VWIpZm9R1Dizxy7D+lQ5O8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=lQ+u0biAa9JSpAXjYVUEeAYUN6cVo2ELvDyzOvPjOcYcrIRlCay+Oxsaxz2XWpfv3pG0i1h9DVgzNTGkTi91p2mcg+efiaTqswUTdL/RNq+p2r3xr0FQTrNNGSvhLuSnWOUYzjqYf0ZXH9/63dS4I9isS4tetYNyMD9rThbDDqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XG979p5b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XG979p5b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57094C4CEE4;
	Thu, 17 Apr 2025 18:52:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915964;
	bh=hm5osy8C38ZyqBJe6fOS4VWIpZm9R1Dizxy7D+lQ5O8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XG979p5bYSBgPmi/o7DgEb+rfblRCLrVmyMV/NF5/AoyFg9NxRyS7cBcaPVRHxCyi
	 75FDVt4Ukmdw7bxcWEtIOWKOamJpLUAphLCFvoPerXysqtN4lqcdVFiLl2WDmJS+SG
	 +hai44rq0dAWnVUv9wYZLsWTlaOpge7PiSUFxnW8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Robert Lippert <rlippert@google.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Wentao Yang <wentaoyang@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 299/393] iommu/vt-d: Wire up irq_ack() to irq_move_irq() for posted MSIs
Date: Thu, 17 Apr 2025 19:51:48 +0200
Message-ID: <20250417175119.639014255@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 548183ea388c12b6d76d6982f3d72df3887af0da upstream.

Set the posted MSI irq_chip's irq_ack() hook to irq_move_irq() instead of
a dummy/empty callback so that posted MSIs process pending changes to the
IRQ's SMP affinity.  Failure to honor a pending set-affinity results in
userspace being unable to change the effective affinity of the IRQ, as
IRQD_SETAFFINITY_PENDING is never cleared and so irq_set_affinity_locked()
always defers moving the IRQ.

The issue is most easily reproducible by setting /proc/irq/xx/smp_affinity
multiple times in quick succession, as only the first update is likely to
be handled in process context.

Fixes: ed1e48ea4370 ("iommu/vt-d: Enable posted mode for device MSIs")
Cc: Robert Lippert <rlippert@google.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
Reported-by: Wentao Yang <wentaoyang@google.com>
Cc: stable@vger.kernel.org
Signed-off-by: Sean Christopherson <seanjc@google.com>
Reviewed-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/r/20250321194249.1217961-1-seanjc@google.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/irq_remapping.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1291,43 +1291,44 @@ static struct irq_chip intel_ir_chip = {
 };
 
 /*
- * With posted MSIs, all vectors are multiplexed into a single notification
- * vector. Devices MSIs are then dispatched in a demux loop where
- * EOIs can be coalesced as well.
+ * With posted MSIs, the MSI vectors are multiplexed into a single notification
+ * vector, and only the notification vector is sent to the APIC IRR.  Device
+ * MSIs are then dispatched in a demux loop that harvests the MSIs from the
+ * CPU's Posted Interrupt Request bitmap.  I.e. Posted MSIs never get sent to
+ * the APIC IRR, and thus do not need an EOI.  The notification handler instead
+ * performs a single EOI after processing the PIR.
  *
- * "INTEL-IR-POST" IRQ chip does not do EOI on ACK, thus the dummy irq_ack()
- * function. Instead EOI is performed by the posted interrupt notification
- * handler.
+ * Note!  Pending SMP/CPU affinity changes, which are per MSI, must still be
+ * honored, only the APIC EOI is omitted.
  *
  * For the example below, 3 MSIs are coalesced into one CPU notification. Only
- * one apic_eoi() is needed.
+ * one apic_eoi() is needed, but each MSI needs to process pending changes to
+ * its CPU affinity.
  *
  * __sysvec_posted_msi_notification()
  *	irq_enter();
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				dummy(); // No EOI
+ *				irq_move_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				dummy(); // No EOI
+ *				irq_move_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *		handle_edge_irq()
  *			irq_chip_ack_parent()
- *				dummy(); // No EOI
+ *				irq_move_irq(); // No EOI
  *			handle_irq_event()
  *				driver_handler()
  *	apic_eoi()
  *	irq_exit()
+ *
  */
-
-static void dummy_ack(struct irq_data *d) { }
-
 static struct irq_chip intel_ir_chip_post_msi = {
 	.name			= "INTEL-IR-POST",
-	.irq_ack		= dummy_ack,
+	.irq_ack		= irq_move_irq,
 	.irq_set_affinity	= intel_ir_set_affinity,
 	.irq_compose_msi_msg	= intel_ir_compose_msi_msg,
 	.irq_set_vcpu_affinity	= intel_ir_set_vcpu_affinity,


