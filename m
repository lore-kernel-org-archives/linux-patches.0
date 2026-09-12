Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 927F3312834;
	Sat, 12 Sep 2026 09:20:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789204829; cv=none; b=CYwz17cPKLDMNyy+wAa1+sZWMxc6G8/eqpDx0UvJB8ybZvKTsE/j4pRME3TLNyD6m4DMee0KtjPnTnqOmbTgIP4cxWAnvIF0zf2M7w3rbHmDO/Yo7Jv0DHTZ8ote/LkztFHdOx8czAD2lwugziY0uG4n85uEtdElDkaYSmKyUFU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789204829; c=relaxed/simple;
	bh=a7AIceGFZ9yBt9VWE39e5B8dm7R3PZ3MEfb0qqYVZaA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nbXl+8EqBFtqR8MZM6S0876pzlMQig1PKvLzYlXTdEsSEiJo96snhX0LFbeP1h/lZOIS1zl+ayNnlgq+mBBOT0UsHKWwlBstJGL0DmZZ0cxQ/x3cFvidbW3YLUjMvEUeXZ1xbBiByOg6mXuW+nENpygN29/Cke8KUSVyHdqoyZc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qxMhH8D8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qxMhH8D8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 23AFB1F000FF;
	Sat, 12 Sep 2026 09:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789204828;
	bh=ElONuB6wmalYW3scaQVpenn4+tDaJQ/vamoS7QuV7uM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qxMhH8D8FG8kM+pBaQ65KdOdT+zTaISVQX0VK377ABsXBYdRxfg9EIk/4x5HbTf/R
	 dKBzaav7+pOeMCyMV6YOn+KVNseIqwiOD3C8rGtZZNf0JO0gfE7iBSO8yAlHhcEqEv
	 lZrisBbwGHCXRdfnbzn4JVnwUagYkcacntZyRIZY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Pieralisi <lpieralisi@kernel.org>,
	Thomas Gleixner <tglx@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 1650/1815] irqchip/gic-v5: Release IRS iomem region on driver init failure
Date: Sat, 12 Sep 2026 08:56:40 +0200
Message-ID: <20260912065727.730868781@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065648.999753832@linuxfoundation.org>
References: <20260912065648.999753832@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Lorenzo Pieralisi <lpieralisi@kernel.org>

[ Upstream commit dc2eae1620bdb4562aa43f1c34c8427308ab4436 ]

In gicv5_irs_of_init(), an IRS is set-up using of_io_request_and_map() to
request its memory region (corresponding to the configuration frame) and
map the IRS configuration frame.

On gicv5_irs_of_init() failure, the driver unmaps the IRS iomem region but
does not release the requested memory region leaving it allocated in the
iomem resource tree.

Fix it by releasing the iomem region on gicv5_irs_of_init() probe failure.

Likewise, on both OF and ACPI driver init failure, IRS iomem regions are
requested but never released in gicv5_irs_remove().

Stash a copy of the IRS iomem region in a struct resource in
struct gicv5_irs_chip_data and use it to release the requested region in
gicv5_irs_remove() if the driver probe fails.

Fixes: 5cb1b6dab2de ("irqchip/gic-v5: Add GICv5 IRS/SPI support")
Fixes: 35866efa52fe ("irqchip/gic-v5: Add ACPI IRS probing")
Signed-off-by: Lorenzo Pieralisi <lpieralisi@kernel.org>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Link: https://sashiko.dev/#/message/20260810104747.E5CE71F000E9%40smtp.kernel.org
Link: https://patch.msgid.link/20260812-gicv5-7-2-fixes-v1-5-3743e82c69a4@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/irqchip/irq-gic-v5-irs.c   | 10 ++++++++++
 include/linux/irqchip/arm-gic-v5.h |  2 ++
 2 files changed, 12 insertions(+)

diff --git a/drivers/irqchip/irq-gic-v5-irs.c b/drivers/irqchip/irq-gic-v5-irs.c
index 9d25ce8bfd8c9..86da9f82a7b0c 100644
--- a/drivers/irqchip/irq-gic-v5-irs.c
+++ b/drivers/irqchip/irq-gic-v5-irs.c
@@ -740,6 +740,7 @@ static int __init gicv5_irs_init(struct gicv5_irs_chip_data *irs_data)
 static int __init gicv5_irs_of_init(struct device_node *node)
 {
 	struct gicv5_irs_chip_data *irs_data;
+	struct resource res;
 	void __iomem *irs_base;
 	u8 iaffid_bits;
 	u32 idr;
@@ -757,6 +758,11 @@ static int __init gicv5_irs_of_init(struct device_node *node)
 		goto out_err;
 	}
 
+	if (of_address_to_resource(node, ret, &res)) {
+		ret = -EINVAL;
+		goto out_err;
+	}
+
 	irs_base = of_io_request_and_map(node, ret, of_node_full_name(node));
 	if (IS_ERR(irs_base)) {
 		pr_err("%pOF: unable to map GICv5 IRS registers\n", node);
@@ -765,6 +771,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
 	}
 
 	irs_data->fwnode = of_fwnode_handle(node);
+	irs_data->res = res;
 	gicv5_irs_init_bases(irs_data, irs_base, of_property_read_bool(node, "dma-noncoherent"));
 
 	idr = irs_readl_relaxed(irs_data, GICV5_IRS_IDR1);
@@ -794,6 +801,7 @@ static int __init gicv5_irs_of_init(struct device_node *node)
 	gicv5_irs_clear_affinity(irs_data);
 	gicv5_irs_disable(irs_data);
 	iounmap(irs_base);
+	release_mem_region(res.start, resource_size(&res));
 out_err:
 	kfree(irs_data);
 	return ret;
@@ -810,6 +818,7 @@ void __init gicv5_irs_remove(void)
 		gicv5_irs_clear_affinity(irs_data);
 		gicv5_irs_disable(irs_data);
 		iounmap(irs_data->irs_base);
+		release_mem_region(irs_data->res.start, resource_size(&irs_data->res));
 		list_del(&irs_data->entry);
 		kfree(irs_data);
 	}
@@ -958,6 +967,7 @@ static int __init gic_acpi_parse_madt_irs(union acpi_subtable_headers *header,
 	}
 
 	gicv5_irs_init_bases(irs_data, irs_base, irs->flags & ACPI_MADT_IRS_NON_COHERENT);
+	irs_data->res = *r;
 
 	gicv5_irs_acpi_init_affinity(irs->irs_id, irs_data);
 
diff --git a/include/linux/irqchip/arm-gic-v5.h b/include/linux/irqchip/arm-gic-v5.h
index f78787e654f4c..2c2fb39f049c3 100644
--- a/include/linux/irqchip/arm-gic-v5.h
+++ b/include/linux/irqchip/arm-gic-v5.h
@@ -6,6 +6,7 @@
 #define __LINUX_IRQCHIP_ARM_GIC_V5_H
 
 #include <linux/iopoll.h>
+#include <linux/ioport.h>
 
 #include <asm/cacheflush.h>
 #include <asm/smp.h>
@@ -324,6 +325,7 @@ struct gicv5_irs_chip_data {
 	struct list_head	entry;
 	struct fwnode_handle	*fwnode;
 	void __iomem		*irs_base;
+	struct resource		res;
 	u32			flags;
 	u32			spi_min;
 	u32			spi_range;
-- 
2.53.0



