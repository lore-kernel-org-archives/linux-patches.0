Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D520B612D7;
	Tue, 20 Feb 2024 21:40:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708465252; cv=none; b=vC3j8hpx7Nrk8wiV1eAISgK88oTd6a+CzZH0vM5rOisFytP06NucgM5x+8XkyVC/u6O+98nfQmO4yQiuDqsUp6YaCfS6IjXj5e1QiH+7zd5PtgGmAyS2oX0UUyzflTB3sMZ8cCiiygTuArMys+g3v02gnBIESQ5BT8u2yc5IWuM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708465252; c=relaxed/simple;
	bh=crHv8g8o/EKZpl0axOOnCyTury+bvruTXq7WgY5Fa9E=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mK9UMYP6tiY6azlosYJk3llq63LzgYySkPErf/Bsqx98AbfDUCuoYfXQSsmJaTu7DkbahDh8v/hp6+mtrXsVUDkvu2r/Fg3nd8rp2CEyEdLzPcwai+ppnAAXUH9Q6kouPrObID7y0f9CRtOtO0W+vmUdxbHh5pT3UpjJPTEd74E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pIVIZPGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pIVIZPGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52D2BC433F1;
	Tue, 20 Feb 2024 21:40:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708465252;
	bh=crHv8g8o/EKZpl0axOOnCyTury+bvruTXq7WgY5Fa9E=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pIVIZPGD8RA0oXdaDjr0m1Kimr0R05WUBTSiS7jan7tHsX4MO6gHZMZA1ssyEtHaZ
	 qo+eTBpj3IKCM6B2+ZrBh9ulRl2xbVyO4lu4i4z0+2BaWFE02qoJWt5S76cxHuxjHJ
	 49Iz/gfdc0BnO3D0GjQvNYx27AQPLYXIZBvE943w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Thomas Gleixner <tglx@linutronix.de>
Subject: [PATCH 6.7 257/309] irqchip/gic-v3-its: Fix GICv4.1 VPE affinity update
Date: Tue, 20 Feb 2024 21:56:56 +0100
Message-ID: <20240220205641.198542631@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

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
 


