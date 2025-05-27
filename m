Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B0025A323;
	Tue, 27 May 2025 17:04:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365459; cv=none; b=Yes87ywy7p+iovIrwwh6gVEwsMcptzw8Mr8EPAhnf6XfBNC77tCr1yXQoWx+kdb67FQgoj1TAek9QcAl+0X3dD8aB+ZTaLhhy46VszSDLxCCR15gjAvM+HHDlqI8R6UvfHattHuDu/VRb5n1LukZN/IpAktd/BYPXhW+gDODJtg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365459; c=relaxed/simple;
	bh=D6wFk69aPsPllk1jNlIGTeohMon9JbGTqbAOn+Uz6NU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Em7JrrgLHq1+qgayEtEZyz30L7HgRDYJIE7Di6qYW5fk+Uu3/m5NzcebYzYrS8uINqYAuXHyXiG68Mh9CjuAi++uYLvdmWF3M1kbdrJ4Xj0O1FB0mPQH+IZyYGJU24ArQgVDcujoQXoKGS10X7x8O3akAsFktA0HwTD9k6FzzII=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oRAz/BPd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oRAz/BPd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 21DE5C4CEE9;
	Tue, 27 May 2025 17:04:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365455;
	bh=D6wFk69aPsPllk1jNlIGTeohMon9JbGTqbAOn+Uz6NU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=oRAz/BPd36A4VjZCkEJHoCuYpuSjXc5ryrXy1/sdxUyBIO9gqpdo6VC45vVgGWOLq
	 nzq8tncp79cYJQ3mTuEgnLFuc0CpH8/wfsKVbTTt50QJ4LG9Bs2guvi/AWINvuqaat
	 4EprkJFR+n5paG8wmThwbBDPOvj8Ez6y16xE1Rag=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrew Jones <ajones@ventanamicro.com>,
	Anup Patel <apatel@ventanamicro.com>,
	Thomas Gleixner <tglx@linutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 351/626] irqchip/riscv-imsic: Set irq_set_affinity() for IMSIC base
Date: Tue, 27 May 2025 18:24:04 +0200
Message-ID: <20250527162459.280599711@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Andrew Jones <ajones@ventanamicro.com>

[ Upstream commit 999f458c1771354371ba367dd84f55f9a62a4233 ]

The IMSIC driver assigns the IMSIC domain specific imsic_irq_set_affinity()
callback to the per device leaf MSI domain. That's a layering violation as
it is called with the leaf domain data and not with the IMSIC domain
data. This prevents moving the IMSIC driver to the common MSI library which
uses the generic msi_domain_set_affinity() callback for device MSI domains.

Instead of using imsic_irq_set_affinity() for leaf MSI domains, use
imsic_irq_set_affinity() for the non-leaf IMSIC base domain and use
irq_chip_set_affinity_parent() for leaf MSI domains.

[ tglx: Massaged change log ]

Signed-off-by: Andrew Jones <ajones@ventanamicro.com>
Signed-off-by: Anup Patel <apatel@ventanamicro.com>
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Link: https://lore.kernel.org/all/20250217085657.789309-2-apatel@ventanamicro.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-riscv-imsic-platform.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/irqchip/irq-riscv-imsic-platform.c b/drivers/irqchip/irq-riscv-imsic-platform.c
index c708780e8760f..5d7c30ad8855b 100644
--- a/drivers/irqchip/irq-riscv-imsic-platform.c
+++ b/drivers/irqchip/irq-riscv-imsic-platform.c
@@ -96,9 +96,8 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
 				  bool force)
 {
 	struct imsic_vector *old_vec, *new_vec;
-	struct irq_data *pd = d->parent_data;
 
-	old_vec = irq_data_get_irq_chip_data(pd);
+	old_vec = irq_data_get_irq_chip_data(d);
 	if (WARN_ON(!old_vec))
 		return -ENOENT;
 
@@ -116,13 +115,13 @@ static int imsic_irq_set_affinity(struct irq_data *d, const struct cpumask *mask
 		return -ENOSPC;
 
 	/* Point device to the new vector */
-	imsic_msi_update_msg(d, new_vec);
+	imsic_msi_update_msg(irq_get_irq_data(d->irq), new_vec);
 
 	/* Update irq descriptors with the new vector */
-	pd->chip_data = new_vec;
+	d->chip_data = new_vec;
 
-	/* Update effective affinity of parent irq data */
-	irq_data_update_effective_affinity(pd, cpumask_of(new_vec->cpu));
+	/* Update effective affinity */
+	irq_data_update_effective_affinity(d, cpumask_of(new_vec->cpu));
 
 	/* Move state of the old vector to the new vector */
 	imsic_vector_move(old_vec, new_vec);
@@ -135,6 +134,9 @@ static struct irq_chip imsic_irq_base_chip = {
 	.name			= "IMSIC",
 	.irq_mask		= imsic_irq_mask,
 	.irq_unmask		= imsic_irq_unmask,
+#ifdef CONFIG_SMP
+	.irq_set_affinity	= imsic_irq_set_affinity,
+#endif
 	.irq_retrigger		= imsic_irq_retrigger,
 	.irq_compose_msi_msg	= imsic_irq_compose_msg,
 	.flags			= IRQCHIP_SKIP_SET_WAKE |
@@ -245,7 +247,7 @@ static bool imsic_init_dev_msi_info(struct device *dev,
 		if (WARN_ON_ONCE(domain != real_parent))
 			return false;
 #ifdef CONFIG_SMP
-		info->chip->irq_set_affinity = imsic_irq_set_affinity;
+		info->chip->irq_set_affinity = irq_chip_set_affinity_parent;
 #endif
 		break;
 	default:
-- 
2.39.5



