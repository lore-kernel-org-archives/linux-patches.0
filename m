Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15B5F309F1F;
	Wed, 28 Jan 2026 16:01:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769616114; cv=none; b=lnTpc1R8CSNm9dVezUnOnr92+Se2ujQJXMq/QzsuJ/a9mrFdFcxFrjOOuT/cOEgmSX1nRPZUp4M2xn1OVRpUCy5s6t9IJXe7cNONooeCwA3Al+K7222Z3LViHTJ2HMuQzTEToC3e958O9JxJRjTdfNvTkCR5Ao3VucM30w8/5Mg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769616114; c=relaxed/simple;
	bh=S1YtUIadwpAAD7eeqt7bJ/f5ZsM2OnRn6bjhgJ58/kQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NukqCmwmKJG853fKljS3Vbq5fuLKGcq+kAzfYgHgDe4hP0kWSdgD7875YdJ/wMaK8KAID+CsOs/Z58z0y0hiD72Cc/O+DesfqPB4tCVAhRIC946mcots6Z8nxKeHH9qcOApWyvfEI7H9FMBtwGya+O/neswM5Syxvh95SltksOI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZjTDCci; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZjTDCci"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 793A5C4CEF7;
	Wed, 28 Jan 2026 16:01:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769616114;
	bh=S1YtUIadwpAAD7eeqt7bJ/f5ZsM2OnRn6bjhgJ58/kQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZjTDCcidHc1xIcepwSDdPFR+L0dNSpC5mXMpY00c1ALlvPQUdLonQjb7+Z5N1J4q
	 VkKpu5vJoo0SKX9dg+JDIODNEqfOS9oxvt7RqIKbz0CKiY3YR4ZDSnaBnVB5ffxf43
	 JM/Byz0FYvQ0C+1fXc1itthOFQXDl3hMvuH5ckaQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Arnd Bergmann <arnd@arndb.de>,
	Thomas Gleixner <tglx@kernel.org>,
	Marc Zyngier <maz@kernel.org>
Subject: [PATCH 6.18 203/227] irqchip/gic-v3-its: Avoid truncating memory addresses
Date: Wed, 28 Jan 2026 16:24:08 +0100
Message-ID: <20260128145351.744724659@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -709,7 +709,7 @@ static struct its_collection *its_build_
 						 struct its_cmd_block *cmd,
 						 struct its_cmd_desc *desc)
 {
-	unsigned long itt_addr;
+	phys_addr_t itt_addr;
 	u8 size = ilog2(desc->its_mapd_cmd.dev->nr_ites);
 
 	itt_addr = virt_to_phys(desc->its_mapd_cmd.dev->itt);
@@ -879,7 +879,7 @@ static struct its_vpe *its_build_vmapp_c
 					   struct its_cmd_desc *desc)
 {
 	struct its_vpe *vpe = valid_vpe(its, desc->its_vmapp_cmd.vpe);
-	unsigned long vpt_addr, vconf_addr;
+	phys_addr_t vpt_addr, vconf_addr;
 	u64 target;
 	bool alloc;
 
@@ -2477,10 +2477,10 @@ retry_baser:
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
 


