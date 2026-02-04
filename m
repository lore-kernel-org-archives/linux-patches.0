Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83D6B27FD56;
	Wed,  4 Feb 2026 14:48:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216500; cv=none; b=QfR0BHkAOGQE9qAjeV3HtcODkmia1cHxkoXICd3mdBRJPRHZYHHXxr+oy3NQePYXJo6K13eHm2x4TKDpmPtCw45VGWMnuHZygkw3bSe7ud2d76IL2NL5QBvnS76DaT5aQi4CMdK3HGGMTT4xOyPzl6zm7mD5JtfCuBEBTy7Aleg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216500; c=relaxed/simple;
	bh=OUHYiHeXnW9ieoTYq0TCyXTUnqAJwadtPLUffGMQ8A8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvw82oWKxt966ty19USPy3aUmXWASdFt9z+ZY7eTU9wRFNXCGXJkvKzRDgz7D7ZWBcGWk4bo0clkssIz/4M54JdKyo/48Y+dQtZPTfMRODHZLYUpC+CBEQSBLMR+HSoHgcHwET6NG85ladOynwWoelHxFLBYl8lTsoBQj1I+ZS8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qMizNWZm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qMizNWZm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE5B5C116C6;
	Wed,  4 Feb 2026 14:48:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216500;
	bh=OUHYiHeXnW9ieoTYq0TCyXTUnqAJwadtPLUffGMQ8A8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qMizNWZmGeeGxXKY7W9TtrqtmvbWc+zQbfE8gzU+hNpOF6bPgzY4O5R1+irNboiEx
	 Rpx7Qsp5wDNeq26jt94Eb6XrbQa5MK5hIp41AYw/3Vjf95o6ZJiaXvXAPn99wfqxq8
	 +4wItBwl3bcEAhUX9EqWjPVHFBaZDjn8X83CNAQw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 5.10 107/161] irqchip/gic-v3-its: Avoid truncating memory addresses
Date: Wed,  4 Feb 2026 15:39:30 +0100
Message-ID: <20260204143855.595223646@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143851.755002596@linuxfoundation.org>
References: <20260204143851.755002596@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Arnd Bergmann <arnd@arndb.de>

commit 8d76a7d89c12d08382b66e2f21f20d0627d14859 upstream.

On 32-bit machines with CONFIG_ARM_LPAE, it is possible for lowmem
allocations to be backed by addresses physical memory above the 32-bit
address limit, as found while experimenting with larger VMSPLIT
configurations.

This caused the qemu virt model to crash in the GICv3 driver, which
allocates the 'itt' object using GFP_KERNEL. Since all memory below
the 4GB physical address limit is in ZONE_DMA in this configuration,
kmalloc() defaults to higher addresses for ZONE_NORMAL, and the
ITS driver stores the physical address in a 32-bit 'unsigned long'
variable.

Change the itt_addr variable to the correct phys_addr_t type instead,
along with all other variables in this driver that hold a physical
address.

The gicv5 driver correctly uses u64 variables, while all other irqchip
drivers don't call virt_to_phys or similar interfaces. It's expected that
other device drivers have similar issues, but fixing this one is
sufficient for booting a virtio based guest.

Fixes: cc2d3216f53c ("irqchip: GICv3: ITS command queue")
Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Thomas Gleixner <tglx@kernel.org>
Reviewed-by: Marc Zyngier <maz@kernel.org>
Cc: stable@vger.kernel.org
Link: https://patch.msgid.link/20260119201603.2713066-1-arnd@kernel.org
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/irqchip/irq-gic-v3-its.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

--- a/drivers/irqchip/irq-gic-v3-its.c
+++ b/drivers/irqchip/irq-gic-v3-its.c
@@ -609,7 +609,7 @@ static struct its_collection *its_build_
 						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
-	unsigned long itt_addr;
+	phys_addr_t itt_addr;
 	u8 size = ilog2(desc->its_mapd_cmd.dev->nr_ites);
 
 	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
@@ -780,7 +780,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_desc *desc)
 {
 	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
-	unsigned long vpt_addr, vconf_addr;
+	phys_addr_t vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
 
@@ -2408,10 +2408,10 @@ retry_baser:
 	baser->psz = psz;
 	tmp = indirect ? GITS_LVL1_ENTRY_SIZE : esz;
 
-	pr_info("ITS@%pa: allocated %d %s @%lx (%s, esz %d, psz %dK, shr %d)\n",
+	pr_info("ITS@%pa: allocated %d %s @%llx (%s, esz %d, psz %dK, shr %d)\n",
 		&its->phys_base, (int)(PAGE_ORDER_TO_SIZE(order) / (int)tmp),
 		its_base_type_string[type],
-		(unsigned long)virt_to_phys(base),
+		(u64)virt_to_phys(base),
 		indirect ? "indirect" : "flat", (int)esz,
 		psz / SZ_1K, (int)shr >> GITS_BASER_SHAREABILITY_SHIFT);
 


