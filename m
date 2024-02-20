Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3DD7514A4E6;
	Tue, 20 Feb 2024 21:21:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464062; cv=none; b=OoXJO7lRXvljwxZ9ojBEdLDiuOCMc0PXu/ZvvFBrmHdbTG7MLjNA9WmLXDzN181OKIKk/hFU/rdrhkin75aq0N2TN0m9b+ZxA88HqsCRkGhcIeNkFY+d8Mirf50ONN01+8twyOvbqCmVXDCOpi1y1y/mJNvhlIz42sjHfE06VlY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464062; c=relaxed/simple;
	bh=oEV0x9kWUkporNzPDB1gQyuS3bBcclo/jCKSG8tWr9k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EHMqDB26et5YhxQ79sTplfQwNGKqeTaGV0+4tAa9vpmoGP5n0Azs5zXl30oVSwInuTN5e91FUqqSM1j01dQEeJObQCwCv9P+OlTC0eXGxub6Wv3A0SI9i0SdCD5/8I1RuN8IC9kMapd4s3B0nHPV3tOjoL/9nvowgCXxAGnKiQQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=f9Gk4xKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="f9Gk4xKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 597BDC433F1;
	Tue, 20 Feb 2024 21:21:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464061;
	bh=oEV0x9kWUkporNzPDB1gQyuS3bBcclo/jCKSG8tWr9k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f9Gk4xKAJsuaQmCMD3niYCkE618ky+ZR+jgotBMB4mEoBNbmMOSIN+DuQWHwC7iV8
	 CLrldJkcRAXOEqZvRSXxrmgQxdqev1InAhROg1sOnq2CGMa4aECwPZoaanW14cAgI6
	 mbaz2byP+cIr5vDw5hfR612jRhzkB+trOQR1C240=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.6 212/331] irqchip/gic-v3-its: Fix GICv4.1 VPE affinity update
Date: Tue, 20 Feb 2024 21:55:28 +0100
Message-ID: <20240220205644.376811084@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Marc Zyngier <maz@kernel.org>

commit af9acbfc2c4b72c378d0b9a2ee023ed01055d3e2 upstream.

When updating the affinity of a VPE, the VMOVP command is currently skipped
if the two CPUs are part of the same VPE affinity.

But this is wrong, as the doorbell corresponding to this VPE is still
delivered on the 'old' CPU, which screws up the balancing.  Furthermore,
offlining that 'old' CPU results in doorbell interrupts generated for this
VPE being discarded.

The harsh reality is that VMOVP cannot be elided when a set_affinity()
request occurs. It needs to be obeyed, and if an optimisation is to be
made, it is at the point where the affinity change request is made (such as
in KVM).

Drop the VMOVP elision altogether, and only use the vpe_table_mask
to try and stay within the same ITS affinity group if at all possible.

Fixes: dd3f050a216e (irqchip/gic-v4.1: Implement the v4.1 flavour of VMOVP)
Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20240213101206.2137483-4-maz@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |   22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -3826,8 +3826,9 @@ static int its_vpe_set_affinity(struct i
 				bool force)
 {
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
-	int from, cpu = cpumask_first(mask_val);
+	struct cpumask common, *table_mask;
 	unsigned long flags;
+	int from, cpu;
 
 	/*
 	 * Changing affinity is mega expensive, so let's be as lazy as
@@ -3843,19 +3844,22 @@ static int its_vpe_set_affinity(struct i
 	 * taken on any vLPI handling path that evaluates vpe->col_idx.
 	 */
 	from = vpe_to_cpuid_lock(vpe, &flags);
-	if (from == cpu)
-		goto out;
-
-	vpe->col_idx = cpu;
+	table_mask = gic_data_rdist_cpu(from)->vpe_table_mask;
 
 	/*
-	 * GICv4.1 allows us to skip VMOVP if moving to a cpu whose RD
-	 * is sharing its VPE table with the current one.
+	 * If we are offered another CPU in the same GICv4.1 ITS
+	 * affinity, pick this one. Otherwise, any CPU will do.
 	 */
-	if (gic_data_rdist_cpu(cpu)->vpe_table_mask &&
-	    cpumask_test_cpu(from, gic_data_rdist_cpu(cpu)->vpe_table_mask))
+	if (table_mask && cpumask_and(&common, mask_val, table_mask))
+		cpu = cpumask_test_cpu(from, &common) ? from : cpumask_first(&common);
+	else
+		cpu = cpumask_first(mask_val);
+
+	if (from == cpu)
 		goto out;
 
+	vpe->col_idx = cpu;
+
 	its_send_vmovp(vpe);
 	its_vpe_db_proxy_move(vpe, from, cpu);
 


