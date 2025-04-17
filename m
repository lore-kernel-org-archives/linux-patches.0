Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B1408256C97;
	Thu, 17 Apr 2025 18:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913469; cv=none; b=DQnPYAmpl8PAzdSm1mhi2x5HaJDSHJbomMNZlhmi6f6jRKv4rk/0WjwDR4AihYIbebhDFok1s8LE9UPNUbRaYMygUftHzE0OuJs7WpLYmfPTYhtYFoJV1vxJ6ZBmdp2PU7GPwz23gGRagR8DEcV8/ecuXuKla/Oa23Q2/RiRNp8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913469; c=relaxed/simple;
	bh=R/DLT8OOVeDQ67qPSzew2I2c7OsrUUUyLSKHSSOgkdw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WYbfA9lDqVF9sJvPhvSd0hdmlcCXAGVFuonfaa0WTnwBArmuvShMNyB+DOZuuxqAu/Ha4oVXKXsDsXKNyPDzBZoPqTYJaLPM/ODhV+LoOrkdKSlvZlDJH6pRFbN9ZXvguPlIgVa9VChJYijqoLWYD/Pak1BUscTwxFNGC+hPipc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ks/fyWhg; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ks/fyWhg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 43594C4CEE7;
	Thu, 17 Apr 2025 18:11:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913469;
	bh=R/DLT8OOVeDQ67qPSzew2I2c7OsrUUUyLSKHSSOgkdw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ks/fyWhgGTzti4k2nz/D4jZBF9kRp7vAICBOskByBn5190qY3bTVpfnfMsciK3VKC
	 eeVJ/8STswf7ebNRDdoLJpD0is3etjvEaSYqzdt8t5fp3sJ5DunrBv3l85Z9QFPRLC
	 mGDVvBDrwfQ2NMdOdFEqvGD/B44KeX9vILbYOwvQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Gleixner <tglx@linutronix.de>,
	Jacob Pan <jacob.jun.pan@linux.intel.com>,
	Sean Christopherson <seanjc@google.com>,
	Lu Baolu <baolu.lu@linux.intel.com>,
	Joerg Roedel <jroedel@suse.de>
Subject: [PATCH 6.14 349/449] iommu/vt-d: Put IRTE back into posted MSI mode if vCPU posting is disabled
Date: Thu, 17 Apr 2025 19:50:37 +0200
Message-ID: <20250417175132.270921836@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sean Christopherson <seanjc@google.com>

commit 2454823e97a63d85a6b215905f71e5a06324eab7 upstream.

Add a helper to take care of reconfiguring an IRTE to deliver IRQs to the
host, i.e. not to a vCPU, and use the helper when an IRTE's vCPU affinity
is nullified, i.e. when KVM puts an IRTE back into "host" mode.  Because
posted MSIs use an ephemeral IRTE, using modify_irte() puts the IRTE into
full remapped mode, i.e. unintentionally disables posted MSIs on the IRQ.

Fixes: ed1e48ea4370 ("iommu/vt-d: Enable posted mode for device MSIs")
Cc: stable@vger.kernel.org
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Signed-off-by: Sean Christopherson <seanjc@google.com>
Link: https://lore.kernel.org/r/20250315025135.2365846-2-seanjc@google.com
Signed-off-by: Lu Baolu <baolu.lu@linux.intel.com>
Signed-off-by: Joerg Roedel <jroedel@suse.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/iommu/intel/irq_remapping.c |   19 +++++++++++++------
 1 file changed, 13 insertions(+), 6 deletions(-)

--- a/drivers/iommu/intel/irq_remapping.c
+++ b/drivers/iommu/intel/irq_remapping.c
@@ -1169,7 +1169,17 @@ static void intel_ir_reconfigure_irte_po
 static inline void intel_ir_reconfigure_irte_posted(struct irq_data *irqd) {}
 #endif
 
-static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force)
+static void __intel_ir_reconfigure_irte(struct irq_data *irqd, bool force_host)
+{
+	struct intel_ir_data *ir_data = irqd->chip_data;
+
+	if (ir_data->irq_2_iommu.posted_msi)
+		intel_ir_reconfigure_irte_posted(irqd);
+	else if (force_host || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
+		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
+}
+
+static void intel_ir_reconfigure_irte(struct irq_data *irqd, bool force_host)
 {
 	struct intel_ir_data *ir_data = irqd->chip_data;
 	struct irte *irte = &ir_data->irte_entry;
@@ -1182,10 +1192,7 @@ static void intel_ir_reconfigure_irte(st
 	irte->vector = cfg->vector;
 	irte->dest_id = IRTE_DEST(cfg->dest_apicid);
 
-	if (ir_data->irq_2_iommu.posted_msi)
-		intel_ir_reconfigure_irte_posted(irqd);
-	else if (force || ir_data->irq_2_iommu.mode == IRQ_REMAPPING)
-		modify_irte(&ir_data->irq_2_iommu, irte);
+	__intel_ir_reconfigure_irte(irqd, force_host);
 }
 
 /*
@@ -1240,7 +1247,7 @@ static int intel_ir_set_vcpu_affinity(st
 
 	/* stop posting interrupts, back to the default mode */
 	if (!vcpu_pi_info) {
-		modify_irte(&ir_data->irq_2_iommu, &ir_data->irte_entry);
+		__intel_ir_reconfigure_irte(data, true);
 	} else {
 		struct irte irte_pi;
 


