Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795061747;
	b=tjS9/qE5TJgisBcW7UqIJV2ip6Usaqo9dz+/3+5dyqJRF/AdGTysQ27V8lLvj7hhdMAE
	 uNX762uhu+roRr6W3Z0b647/b4/Cyjz5It4KIi/jEDTgdlt1HbivIoGbdlrG2UKB2KW8l
	 qAVBYtR0cbEtOFIY2LS5XnIc6f+O1b0OWOQxIyToI35IZ8ZIbeekA3EeZuepuDKESxa6X
	 l/EzQ3KdIyUvZTWvtw6lkNOaeUd/PG+1SRi/0LJ0VQvjqG6zo2bmremwIauG9V51csGV7
	 kqw9lnh5TacPQQf4SwG6whRTU+X3E12We6JJUc7j+29g1V/w6evDNbrJj0fOox+RMdA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795061747;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=AH+jMMJ0tFFq+cCOtguh+O6TGr8WAcE3KV3EiIwVFs4=;
	b=iZ9xVIxPbosUgVYUi6EHmokjSxBK9zfEjBRYn0cE0I+AWMbqZBBqmV9sHKHNE7P5Vgs4
	 XsdTvNUzQPsRGpDCdvj6g20NNGytfiBwUYxki9p18fmIGnR2zzEqkTauFU6TngjktHsIX
	 KoCOPFOZwmCtnAp7KqZqvIOSRRZdBRLs09wFaEcyeMFND1UBwDglEAAifnJ1CNYb5LgOC
	 y/9Es9I/x5Iyh8HN+c8a8pIVok+0BjoSoFQhDYF4bKNJsw/DQGPNSKcQTOPzMtlJgempE
	 Ro3EXRriJH0ZVLBU6dmDXj5o4UZJmPWLnNFhUK95uRH9L3c+QPx5BL6Ld7Pk19tJ1Ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xktKifTn;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 59DC2606A32C;
	Thu, 19 Nov 2026 04:15:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=xktKifTn
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB6D21F000C4;
	Thu, 19 Nov 2026 04:15:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795061747;
	bh=AH+jMMJ0tFFq+cCOtguh+O6TGr8WAcE3KV3EiIwVFs4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=xktKifTnQ6QmkYWGePesPp0v7xcDkxxhOK0WR2u21TZlaCFoHos8KNdnTw9TO0kDl
	 VD6pU5BV/K0HvrkV7QFq1HWQWau7eLMTHlsJoVniiCAXv7LF/QWxkcoe53I2MEJvha
	 1UgdqP4Yl8FN/RI9Lj/+rT6XkdI5fn0udi+3Nmmo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Valentin Schneider <valentin.schneider@arm.com>,
	Marc Zyngier <maz@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1663/1848] irqchip/gic-v3-its: Postpone LPI pending table freeing and memreserve
Date: Wed, 18 Nov 2026 16:01:41 +0100
Message-ID: <20261118150029.417602203@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Valentin Schneider <valentin.schneider@arm.com>

[ Upstream commit d23bc2bc1d634658d7fa96395419c1c553a784f0 ]

Memory used by the LPI tables have to be made persistent for kexec to have
a chance to work, as explained in [1]. If they have been made persistent
and we are booting into a kexec'd kernel, we also need to free the pages
that were preemptively allocated by the new kernel for those tables.

Both of those operations currently happen during its_cpu_init(), which
happens in a _STARTING (IOW atomic) cpuhp callback for secondary
CPUs. efi_mem_reserve_iomem() issues a GFP_ATOMIC allocation, which
unfortunately doesn't work under PREEMPT_RT (this ends up grabbing a
non-raw spinlock, which can sleep under PREEMPT_RT). Similarly, freeing the
pages ends up grabbing a sleepable spinlock.

Since the memreserve is only required by kexec, it doesn't have to be done
so early in the secondary boot process. Issue the reservation in a new
CPUHP_AP_ONLINE_DYN cpuhp callback, and piggy-back the page freeing on top
of it. A CPU gets to run the body of this new callback exactly once.

As kexec issues a machine_shutdown() prior to machine_kexec(), it will be
serialized vs a CPU being plugged to life by the hotplug machinery - either
the CPU will have been brought up and have had its redistributor's pending
table memreserved, or it never went online and will have its table
allocated by the new kernel.

[1]: https://lore.kernel.org/lkml/20180921195954.21574-1-marc.zyngier@arm.com/

Signed-off-by: Valentin Schneider <valentin.schneider@arm.com>
Signed-off-by: Marc Zyngier <maz@kernel.org>
Link: https://lore.kernel.org/r/20211027151506.2085066-3-valentin.schneider@arm.com
Stable-dep-of: 32e056cc1d15 ("irqchip/gic-v3-its: Don't free a vPE table shared with another ITS")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v3-its.c   | 58 +++++++++++++++++++++++++++---
 drivers/irqchip/irq-gic-v3.c       |  1 +
 include/linux/irqchip/arm-gic-v3.h |  1 +
 3 files changed, 56 insertions(+), 4 deletions(-)

diff --git a/drivers/irqchip/irq-gic-v3-its.c b/drivers/irqchip/irq-gic-v3-its.c
index 805e023a66e4c..1d6aa8d66630d 100644
--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -47,6 +47,8 @@
 #define RDIST_FLAGS_RD_TABLES_PREALLOCATED	(1 << 1)
 
 #define RD_LOCAL_LPI_ENABLED                    BIT(0)
+#define RD_LOCAL_PENDTABLE_PREALLOCATED         BIT(1)
+#define RD_LOCAL_MEMRESERVE_DONE                BIT(2)
 
 static u32 lpi_id_bits;
 
@@ -3092,15 +3094,13 @@ static void its_cpu_init_lpis(void)
 		paddr &= GENMASK_ULL(51, 16);
 
 		WARN_ON(!gic_check_reserved_range(paddr, LPI_PENDBASE_SZ));
-		its_free_pending_table(gic_data_rdist()->pend_page);
-		gic_data_rdist()->pend_page = NULL;
+		gic_data_rdist()->flags |= RD_LOCAL_PENDTABLE_PREALLOCATED;
 
 		goto out;
 	}
 
 	pend_page = gic_data_rdist()->pend_page;
 	paddr = page_to_phys(pend_page);
-	WARN_ON(gic_reserve_range(paddr, LPI_PENDBASE_SZ));
 
 	/* set PROPBASE */
 	val = (gic_rdists->prop_table_pa |
@@ -3190,7 +3190,8 @@ static void its_cpu_init_lpis(void)
 	gic_data_rdist()->flags |= RD_LOCAL_LPI_ENABLED;
 	pr_info("GICv3: CPU%d: using %s LPI pending table @%pa\n",
 		smp_processor_id(),
-		gic_data_rdist()->pend_page ? "allocated" : "reserved",
+		gic_data_rdist()->flags & RD_LOCAL_PENDTABLE_PREALLOCATED ?
+		"reserved" : "allocated",
 		&paddr);
 }
 
@@ -5226,6 +5227,38 @@ int its_cpu_init(void)
 	return 0;
 }
 
+static int its_cpu_memreserve_lpi(unsigned int cpu)
+{
+	struct page *pend_page;
+	int ret = 0;
+
+	/* This gets to run exactly once per CPU */
+	if (gic_data_rdist()->flags & RD_LOCAL_MEMRESERVE_DONE)
+		return 0;
+
+	pend_page = gic_data_rdist()->pend_page;
+	if (WARN_ON(!pend_page)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	/*
+	 * If the pending table was pre-programmed, free the memory we
+	 * preemptively allocated. Otherwise, reserve that memory for
+	 * later kexecs.
+	 */
+	if (gic_data_rdist()->flags & RD_LOCAL_PENDTABLE_PREALLOCATED) {
+		its_free_pending_table(pend_page);
+		gic_data_rdist()->pend_page = NULL;
+	} else {
+		phys_addr_t paddr = page_to_phys(pend_page);
+		WARN_ON(gic_reserve_range(paddr, LPI_PENDBASE_SZ));
+	}
+
+out:
+	gic_data_rdist()->flags |= RD_LOCAL_MEMRESERVE_DONE;
+	return ret;
+}
+
 static const struct of_device_id its_device_id[] = {
 	{	.compatible	= "arm,gic-v3-its",	},
 	{},
@@ -5411,6 +5444,23 @@ static void __init its_acpi_probe(void)
 static void __init its_acpi_probe(void) { }
 #endif
 
+int __init its_lpi_memreserve_init(void)
+{
+	int state;
+
+	if (!efi_enabled(EFI_CONFIG_TABLES))
+		return 0;
+
+	state = cpuhp_setup_state(CPUHP_AP_ONLINE_DYN,
+				  "irqchip/arm/gicv3/memreserve:online",
+				  its_cpu_memreserve_lpi,
+				  NULL);
+	if (state < 0)
+		return state;
+
+	return 0;
+}
+
 int __init its_init(struct fwnode_handle *handle, struct rdists *rdists,
 		    struct irq_domain *parent_domain)
 {
diff --git a/drivers/irqchip/irq-gic-v3.c b/drivers/irqchip/irq-gic-v3.c
index 7728fca12a8d9..c6183c47181fd 100644
--- a/drivers/irqchip/irq-gic-v3.c
+++ b/drivers/irqchip/irq-gic-v3.c
@@ -1818,6 +1818,7 @@ static int __init gic_init_bases(void __iomem *dist_base,
 	if (gic_dist_supports_lpis()) {
 		its_init(handle, &gic_data.rdists, gic_data.domain);
 		its_cpu_init();
+		its_lpi_memreserve_init();
 	} else {
 		if (IS_ENABLED(CONFIG_ARM_GIC_V2M))
 			gicv2m_init(handle, gic_data.domain);
diff --git a/include/linux/irqchip/arm-gic-v3.h b/include/linux/irqchip/arm-gic-v3.h
index 6c68836f486a2..aaae715ae0bbe 100644
--- a/include/linux/irqchip/arm-gic-v3.h
+++ b/include/linux/irqchip/arm-gic-v3.h
@@ -689,6 +689,7 @@ struct rdists {
 
 struct irq_domain;
 struct fwnode_handle;
+int __init its_lpi_memreserve_init(void);
 int its_cpu_init(void);
 int its_init(struct fwnode_handle *handle, struct rdists *rdists,
 	     struct irq_domain *domain);
-- 
2.53.0



