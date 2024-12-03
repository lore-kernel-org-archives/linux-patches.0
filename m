Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BBFCA1F7094;
	Tue,  3 Dec 2024 14:54:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733237690; cv=none; b=ui5/J36SIWEskPUfFtJj10+f+rBtI7Ri6NEnqSktFY2HR5YBMlR6BYcgHY0TM5dOqIBzv8WWVBOOa8to8cgVGDx0pkgQCpBV2VFaUV5B5k4BKKCAetXBjlT3WsdsBVm415scupoqVS81OpvCJqDbOHj20IMOByMpdel9jwUMSOM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733237690; c=relaxed/simple;
	bh=bojYfjp+KdETvWfBWarpk326ou1s1B3V//LBni3s8ZM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OjLgOryRo/ZlGsUp5N2eHRwi9Jg5nlUybwklq66slC3/51Sb8gjst31qKqu8x8jj7fz/icuL6dekVZFPoXjvQPuZX1onSF6nPyh3j42msq3xE2zZKN3bdcwMYuB30NcnpkQGsX/5sNFLqD0NhGf6seAXY69y19okOfLQyturZSw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZiY5O4tf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZiY5O4tf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DFC39C4CECF;
	Tue,  3 Dec 2024 14:54:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733237690;
	bh=bojYfjp+KdETvWfBWarpk326ou1s1B3V//LBni3s8ZM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZiY5O4tfiMnnz4PLgNaJXIoQ8vEbhWpgmf/7xbcbu6T6Iemuo4Zd3Z/DfzmanGKXF
	 tMS5Yz/oZx3tOL1efmE4FMOVPa3DgpRUhcVGNQB2sJtqe5DxbqJ6aBDfgh+HbhsJAu
	 FCpJxGWI9L24Q0dXI+rzm3FDacrTyz4JjaRw0mfc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harith George <harith.g@alifsemi.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	"Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 043/817] ARM: 9420/1: smp: Fix SMP for xip kernels
Date: Tue,  3 Dec 2024 15:33:35 +0100
Message-ID: <20241203143957.341230731@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203143955.605130076@linuxfoundation.org>
References: <20241203143955.605130076@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Harith G <harith.g@alifsemi.com>

[ Upstream commit 9e9b0cf9319b4db143014477b0bc4b39894248f1 ]

Fix the physical address calculation of the following to get smp working
on xip kernels.
- secondary_data needed for secondary cpu bootup.
- secondary_startup address passed through psci.
- identity mapped code region needed for enabling mmu for secondary cpus.

Signed-off-by: Harith George <harith.g@alifsemi.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm/kernel/head.S     | 4 ++++
 arch/arm/kernel/psci_smp.c | 7 +++++++
 arch/arm/mm/idmap.c        | 7 +++++++
 3 files changed, 18 insertions(+)

diff --git a/arch/arm/kernel/head.S b/arch/arm/kernel/head.S
index 28873cda464f5..f22c50d4bd417 100644
--- a/arch/arm/kernel/head.S
+++ b/arch/arm/kernel/head.S
@@ -411,7 +411,11 @@ ENTRY(secondary_startup)
 	/*
 	 * Use the page tables supplied from  __cpu_up.
 	 */
+#ifdef CONFIG_XIP_KERNEL
+	ldr	r3, =(secondary_data + PLAT_PHYS_OFFSET - PAGE_OFFSET)
+#else
 	adr_l	r3, secondary_data
+#endif
 	mov_l	r12, __secondary_switched
 	ldrd	r4, r5, [r3, #0]		@ get secondary_data.pgdir
 ARM_BE8(eor	r4, r4, r5)			@ Swap r5 and r4 in BE:
diff --git a/arch/arm/kernel/psci_smp.c b/arch/arm/kernel/psci_smp.c
index d4392e1774848..3bb0c4dcfc5c9 100644
--- a/arch/arm/kernel/psci_smp.c
+++ b/arch/arm/kernel/psci_smp.c
@@ -45,8 +45,15 @@ extern void secondary_startup(void);
 static int psci_boot_secondary(unsigned int cpu, struct task_struct *idle)
 {
 	if (psci_ops.cpu_on)
+#ifdef CONFIG_XIP_KERNEL
+		return psci_ops.cpu_on(cpu_logical_map(cpu),
+			((phys_addr_t)(&secondary_startup)
+			- XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR)
+			+ CONFIG_XIP_PHYS_ADDR));
+#else
 		return psci_ops.cpu_on(cpu_logical_map(cpu),
 					virt_to_idmap(&secondary_startup));
+#endif
 	return -ENODEV;
 }
 
diff --git a/arch/arm/mm/idmap.c b/arch/arm/mm/idmap.c
index 448e57c6f6534..4a833e89782aa 100644
--- a/arch/arm/mm/idmap.c
+++ b/arch/arm/mm/idmap.c
@@ -84,8 +84,15 @@ static void identity_mapping_add(pgd_t *pgd, const char *text_start,
 	unsigned long addr, end;
 	unsigned long next;
 
+#ifdef CONFIG_XIP_KERNEL
+	addr = (phys_addr_t)(text_start) - XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR)
+		+ CONFIG_XIP_PHYS_ADDR;
+	end = (phys_addr_t)(text_end) - XIP_VIRT_ADDR(CONFIG_XIP_PHYS_ADDR)
+		+ CONFIG_XIP_PHYS_ADDR;
+#else
 	addr = virt_to_idmap(text_start);
 	end = virt_to_idmap(text_end);
+#endif
 	pr_info("Setting up static identity map for 0x%lx - 0x%lx\n", addr, end);
 
 	prot |= PMD_TYPE_SECT | PMD_SECT_AP_WRITE | PMD_SECT_AF;
-- 
2.43.0



