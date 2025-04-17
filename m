Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58C2E25525C;
	Thu, 17 Apr 2025 18:32:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914752; cv=none; b=u4SVUI9KjgHvy04Gfzhh4/3VKQXluLfrb1i5GhfGjRL0z0ba0jlf+KI4Xgw4w6RmnU4rLaw2da1k4ZgqH+DHmcmLM3oIzD70c6cVuj1kgjFWgpixF20p6VbpkuGpCs7/7EL9LYcxUPydzs7WH96j2COaqAFAbJT/G+RGoLnQvmI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914752; c=relaxed/simple;
	bh=wjVNWGcP6kPMj8V76jpyN565OYxiE1Hf0bTjo5TfN54=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IQBwRpQLqC1JS5NQDu77sKYy0ZUiSxSVX103Nlcf5ru6/aEQwbvGiuBaK83ci2t5r7XyfjhHJ6Nxei6KKWCoILakm5cFjzI1rYvh64JG3EaEjFqP8YmyuHfJlJscSZmv17RS9u7tw82LbFNp+zqqJz3h0YAY8dN+ZkVKVql1e7Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OefrME2x; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OefrME2x"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C868EC4CEE4;
	Thu, 17 Apr 2025 18:32:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914752;
	bh=wjVNWGcP6kPMj8V76jpyN565OYxiE1Hf0bTjo5TfN54=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OefrME2xqjfA2KzQFgC/PPP2QRAywRa0a34E5X4g3s6xmkSi9QFzHUXyeRymV2Bcx
	 +5uy0kXyxwcUJQ7ouGmC6K1UL95t2txvRmlYFzbplRB+FqGGaLf5dPp4xvoVWvp5v/
	 Iime1dqimxshwtW+YXw30CmcwnukDSHH3mJ1+3N4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.13 319/414] iommu/vt-d: Dont clobber posted vCPU IRTE when host IRQ affinity changes
Date: Thu, 17 Apr 2025 19:51:17 +0200
Message-ID: <20250417175124.264315604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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


