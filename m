Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EAE333594D;
	Thu, 17 Apr 2025 18:52:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915959; cv=none; b=bVwdcFzazBrsDO+sNqknPQusvC/Lc1SeIRxexID0VKT7ok4qQ+wSME1kWaUUPkZeTCt1P2hA55oQunm2OSUXIor+2lHEwioOLUBUAvEuzzsKigCVbokrdAs8zpkT2uo0WULL5EpNzgbzLWHKi08OyeMqCCUAyJa67HOQ0scj2pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915959; c=relaxed/simple;
	bh=5V/PnGc9wUgSP9/OPj5CvNHtJyF/+0PL9lYdI+3xGDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HeUf+rn2yZNc48z4KcGUOg2EMgKxoxoNXKW89JtAZHurDzIQNXkkwhIzsp0hMhjE+hay54MNlM0BMA2aVivU2pMg6SArfZ3QiW8cpDOhPVkhQcseIoD39vJJBUrDPSazR/zQslW+y/tRAOVQdtlV6qG8+pVi1IOHE5GwKhkKD9g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZwmrxXRu; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZwmrxXRu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 772A7C4CEE7;
	Thu, 17 Apr 2025 18:52:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915958;
	bh=5V/PnGc9wUgSP9/OPj5CvNHtJyF/+0PL9lYdI+3xGDo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZwmrxXRuBmIa9RQthBeozln9ZJ/3K0/etQ9OL+Fye3iqKEIpc/eFYCFM34+lmTPKn
	 JYqudTxwybnErgeMwMotcowXY4GyeP21YKB7MPydHWT9tC13tjNwnKGTIakHfBp/jl
	 8hAgS7yb4gy3w5pBANUuSvheQaoR3s9oIwfz+SV0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.12 297/393] iommu/vt-d: Dont clobber posted vCPU IRTE when host IRQ affinity changes
Date: Thu, 17 Apr 2025 19:51:46 +0200
Message-ID: <20250417175119.561592788@linuxfoundation.org>
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

commit 688124cc541f60d26a7547f45637b23dada4e527 upstream.

Don't overwrite an IRTE that is posting IRQs to a vCPU with a posted MSI
entry if the host IRQ affinity happens to change.  If/when the IRTE is
reverted back to "host mode", it will be reconfigured as a posted MSI or
remapped entry as appropriate.

Drop the "mode" field, which doesn't differentiate between posted MSIs and
posted vCPUs, in favor of a dedicated posted_vcpu flag.  Note!  The two
posted_{msi,vcpu} flags are intentionally not mutually exclusive; an IRTE
can transition between posted MSI and posted vCPU.

Fixes: ed1e48ea4370 ("iommu/vt-d: Enable posted mode for device MSIs")
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250315025135.2365846-3-seanjc@google.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/irq_remapping.c |   25 +++++++++++++++----------
 1 file changed, 15 insertions(+), 10 deletions(-)

--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -26,11 +26,6 @@
 #include "../iommu-pages.h"
 #include "cap_audit.h"
 
-enum irq_mode {
-	IRQ_REMAPPING,
-	IRQ_POSTING,
-};
-
 struct ioapic_scope {
 	struct intel_iommu *iommu;
 	unsigned int id;
@@ -50,8 +45,8 @@ struct irq_2_iommu {
 	u16 irte_index;
 	u16 sub_handle;
 	u8  irte_mask;
-	enum irq_mode mode;
 	bool posted_msi;
+	bool posted_vcpu;
 };
 
 struct intel_ir_data {
@@ -139,7 +134,6 @@ static int alloc_irte(struct intel_iommu
 		irq_iommu->irte_index =  index;
 		irq_iommu->sub_handle = 0;
 		irq_iommu->irte_mask = mask;
-		irq_iommu->mode = IRQ_REMAPPING;
 	}
 	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
@@ -194,8 +188,6 @@ static int modify_irte(struct irq_2_iomm
 
 	rc = qi_flush_iec(iommu, index, 0);
 
-	/* Update iommu mode according to the IRTE mode */
-	irq_iommu->mode = irte->pst ? IRQ_POSTING : IRQ_REMAPPING;
 	raw_spin_unlock_irqrestore(&irq_2_ir_lock, flags);
 
 	return rc;
@@ -1177,9 +1169,18 @@ static void __intel_ir_reconfigure_irte(
 {
 	struct intel_ir_data *ir_data = irqd->chip_data;
 
+	/*
+	 * Don't modify IRTEs for IRQs that are being posted to vCPUs if the
+	 * host CPU affinity changes.
+	 */
+	if (ir_data->irq_2_iommu.posted_vcpu && !force_host)
+		return;
+
+	ir_data->irq_2_iommu.posted_vcpu = false;
+
 	if (ir_data->irq_2_iommu.posted_msi)
 		intel_ir_reconfigure_irte_posted(irqd);
-	else if (force_host || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
+	else
 		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
 }
 
@@ -1274,6 +1275,7 @@ static int intel_ir_set_vcpu_affinity(st
 		irte_pi.pda_h = (vcpu_pi_info->pi_desc_addr >> 32) &
 				~(-1UL << PDA_HIGH_BIT);
 
+		ir_data->irq_2_iommu.posted_vcpu = true;
 		modify_irte(&ir_data->irq_2_iommu, &irte_pi);
 	}
 
@@ -1501,6 +1503,9 @@ static void intel_irq_remapping_deactiva
 	struct intel_ir_data *data = irq_data->chip_data;
 	struct irte entry;
 
+	WARN_ON_ONCE(data->irq_2_iommu.posted_vcpu);
+	data->irq_2_iommu.posted_vcpu = false;
+
 	memset(&entry, 0, sizeof(entry));
 	modify_irte(&data->irq_2_iommu, &entry);
 }


