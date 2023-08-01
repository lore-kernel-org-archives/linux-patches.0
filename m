Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F6051FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:48:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A89CBC433C9;
	Tue,  1 Aug 2023 09:48:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883327;
	bh=nQlEQo4qsrd1a1vUMAGJmEzkahXsVkQFIIy5/cYKUdU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XJHl7p5Cnj+BNFhYZUtjaUZW93ryAHPSHmIOxnaS3dPQdKRF0mTHUmT+V/26lEwbH
	 xxD3gn0RrwseNp9fCpqU7nPHy8sPJ2f/AAFPId54WSPfZ372hiag0qBc/SbmtR2bY4
	 1UASZoYOAoXRzShy6ctzHHXK3HYDESJtIbhkzOqc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kunkun Jiang <jiangkunkun@huawei.com>,
	Marc Zyngier <maz@kernel.org>,
	Zenghui Yu <yuzenghui@huawei.com>,
	wanghaibin.wang@huawei.com,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 197/239] irqchip/gic-v4.1: Properly lock VPEs when doing a directLPI invalidation
Date: Tue,  1 Aug 2023 11:21:01 +0200
Message-ID: <20230801091932.852133818@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marc Zyngier <maz@kernel.org>

[ Upstream commit 926846a703cbf5d0635cc06e67d34b228746554b ]

We normally rely on the irq_to_cpuid_[un]lock() primitives to make
sure nothing will change col->idx while performing a LPI invalidation.

However, these primitives do not cover VPE doorbells, and we have
some open-coded locking for that. Unfortunately, this locking is
pretty bogus.

Instead, extend the above primitives to cover VPE doorbells and
convert the whole thing to it.

Fixes: f3a059219bc7 ("irqchip/gic-v4.1: Ensure mutual exclusion between vPE affinity change and RD access")
Reported-by: Kunkun Jiang <jiangkunkun@huawei.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Cc: Zenghui Yu <yuzenghui@huawei.com>
Cc: wanghaibin.wang@huawei.com
Tested-by: Kunkun Jiang <jiangkunkun@huawei.com>
Reviewed-by: Zenghui Yu <yuzenghui@huawei.com>
Link: https://lore.kernel.org/r/20230617073242.3199746-1-maz@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c | 75 ++++++++++++++++++++------------
 1 file changed, 46 insertions(+), 29 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 0ec2b1e1df75b..c5cb2830e8537 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -273,13 +273,23 @@ static void vpe_to_cpuid_unlock(struct its_vpe *vpe, unsigned long flags)
 	raw_spin_unlock_irqrestore(&vpe->vpe_lock, flags);
 }
 
+static struct irq_chip its_vpe_irq_chip;
+
 static int irq_to_cpuid_lock(struct irq_data *d, unsigned long *flags)
 {
-	struct its_vlpi_map *map = get_vlpi_map(d);
+	struct its_vpe *vpe = NULL;
 	int cpu;
 
-	if (map) {
-		cpu = vpe_to_cpuid_lock(map->vpe, flags);
+	if (d->chip == &its_vpe_irq_chip) {
+		vpe = irq_data_get_irq_chip_data(d);
+	} else {
+		struct its_vlpi_map *map = get_vlpi_map(d);
+		if (map)
+			vpe = map->vpe;
+	}
+
+	if (vpe) {
+		cpu = vpe_to_cpuid_lock(vpe, flags);
 	} else {
 		/* Physical LPIs are already locked via the irq_desc lock */
 		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
@@ -293,10 +303,18 @@ static int irq_to_cpuid_lock(struct irq_data *d, unsigned long *flags)
 
 static void irq_to_cpuid_unlock(struct irq_data *d, unsigned long flags)
 {
-	struct its_vlpi_map *map = get_vlpi_map(d);
+	struct its_vpe *vpe = NULL;
+
+	if (d->chip == &its_vpe_irq_chip) {
+		vpe = irq_data_get_irq_chip_data(d);
+	} else {
+		struct its_vlpi_map *map = get_vlpi_map(d);
+		if (map)
+			vpe = map->vpe;
+	}
 
-	if (map)
-		vpe_to_cpuid_unlock(map->vpe, flags);
+	if (vpe)
+		vpe_to_cpuid_unlock(vpe, flags);
 }
 
 static struct its_collection *valid_col(struct its_collection *col)
@@ -1433,14 +1451,29 @@ static void wait_for_syncr(void __iomem *rdbase)
 		cpu_relax();
 }
 
-static void direct_lpi_inv(struct irq_data *d)
+static void __direct_lpi_inv(struct irq_data *d, u64 val)
 {
-	struct its_vlpi_map *map = get_vlpi_map(d);
 	void __iomem *rdbase;
 	unsigned long flags;
-	u64 val;
 	int cpu;
 
+	/* Target the redistributor this LPI is currently routed to */
+	cpu = irq_to_cpuid_lock(d, &flags);
+	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
+
+	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
+	gic_write_lpir(val, rdbase + GICR_INVLPIR);
+	wait_for_syncr(rdbase);
+
+	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
+	irq_to_cpuid_unlock(d, flags);
+}
+
+static void direct_lpi_inv(struct irq_data *d)
+{
+	struct its_vlpi_map *map = get_vlpi_map(d);
+	u64 val;
+
 	if (map) {
 		struct its_device *its_dev = irq_data_get_irq_chip_data(d);
 
@@ -1453,15 +1486,7 @@ static void direct_lpi_inv(struct irq_data *d)
 		val = d->hwirq;
 	}
 
-	/* Target the redistributor this LPI is currently routed to */
-	cpu = irq_to_cpuid_lock(d, &flags);
-	raw_spin_lock(&gic_data_rdist_cpu(cpu)->rd_lock);
-	rdbase = per_cpu_ptr(gic_rdists->rdist, cpu)->rd_base;
-	gic_write_lpir(val, rdbase + GICR_INVLPIR);
-
-	wait_for_syncr(rdbase);
-	raw_spin_unlock(&gic_data_rdist_cpu(cpu)->rd_lock);
-	irq_to_cpuid_unlock(d, flags);
+	__direct_lpi_inv(d, val);
 }
 
 static void lpi_update_config(struct irq_data *d, u8 clr, u8 set)
@@ -3952,18 +3977,10 @@ static void its_vpe_send_inv(struct irq_data *d)
 {
 	struct its_vpe *vpe = irq_data_get_irq_chip_data(d);
 
-	if (gic_rdists->has_direct_lpi) {
-		void __iomem *rdbase;
-
-		/* Target the redistributor this VPE is currently known on */
-		raw_spin_lock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
-		rdbase = per_cpu_ptr(gic_rdists->rdist, vpe->col_idx)->rd_base;
-		gic_write_lpir(d->parent_data->hwirq, rdbase + GICR_INVLPIR);
-		wait_for_syncr(rdbase);
-		raw_spin_unlock(&gic_data_rdist_cpu(vpe->col_idx)->rd_lock);
-	} else {
+	if (gic_rdists->has_direct_lpi)
+		__direct_lpi_inv(d, d->parent_data->hwirq);
+	else
 		its_vpe_send_cmd(vpe, its_send_inv);
-	}
 }
 
 static void its_vpe_mask_irq(struct irq_data *d)
-- 
2.40.1



