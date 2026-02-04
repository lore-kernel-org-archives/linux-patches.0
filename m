Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 892CC421F1C;
	Wed,  4 Feb 2026 15:13:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770217987; cv=none; b=hgZj4m6/S119s4lzXMQmQLxnrKl6PQI8vg98lKAro00TBuOROFuaRHlCA7RwQy1YkZOGdDw2LQuZBio7P5z8Ej57vgNs1FKCOyz76LQThGUsXOrLx/Z0GM24RDYCRhCazEapegTT+ur6wyEXHC/WuoZHDjHsh75tsrhx5oqiAv4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770217987; c=relaxed/simple;
	bh=Q+rHH/9Tnr3clgeCoH8qd5Nybdnr+EHvod1ljTYYWcM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=nI8TFI7tVYDra8KWp4R2r3nDBidBo1/zqtJwULTqa7KA069mLEwpm5X24IDLzq1x2ZjEd8uNdkYHhA9VTg8KhOYAmZ4F86x4mesq+t1C//Xv3hLWvNWXYzLcrFrLetZn7I0G+jE7BawAmEM92Czr8fW6+RXn1T8wlD+BcImdahU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFuclH7W; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFuclH7W"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AA3A4C4CEF7;
	Wed,  4 Feb 2026 15:13:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770217987;
	bh=Q+rHH/9Tnr3clgeCoH8qd5Nybdnr+EHvod1ljTYYWcM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RFuclH7WT4v2gXpn1lT52kg27zFjHgFicnv8n9QCFEH86A8Ip3XU/cJJvfJl89uK2
	 SliEOsRqPLHcTI1fFULJ6xXd2TTYnN5GOc6+ejWFvP/UiXwL70Wh0WL8ichnWi1bgN
	 QNNX+PlHY1R9iKfOklPylSUSN4IrI9QwNFv+FZgI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.1 178/280] irqchip/gic-v3-its: Avoid truncating memory addresses
Date: Wed,  4 Feb 2026 15:39:12 +0100
Message-ID: <20260204143916.024042739@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143909.614719725@linuxfoundation.org>
References: <20260204143909.614719725@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -613,7 +613,7 @@ static struct its_collection *its_build_
 						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
-	unsigned long itt_addr;
+	phys_addr_t itt_addr;
 	u8 size = ilog2(desc->its_mapd_cmd.dev->nr_ites);
 
 	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
@@ -784,7 +784,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_desc *desc)
 {
 	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
-	unsigned long vpt_addr, vconf_addr;
+	phys_addr_t vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
 
@@ -2399,10 +2399,10 @@ retry_baser:
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
 


