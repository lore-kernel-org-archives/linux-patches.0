Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 611012D7BF;
	Tue,  3 Dec 2024 15:17:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733239022; cv=none; b=IvchevLHmpLdJ0Y4lz8O/9tSz+w0pRAJgJkpGI8ip7m7lm9Xm4bRubPx/3wrwoLj7VbGgDviFMZJdCuW6ivPcEGhLtYS5O0FOM/KddGRkdaMh1ZpXQIVEI2nDw2UzfpfJoaViDmPKCLiZ2/Ci1UeuBJB76HSFPZfwcazR3cus5Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733239022; c=relaxed/simple;
	bh=i+AJhq9FjJinT4BD7y6nWs2OdmTeD1BDXrHz8fLluQ4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CosQ0MRzgqdPm3DRkDMf6vBfV4aQG3RlWWIVsAe8HMhsaRKMwWr6be8u3Rx51G94Km7LkbGXgBLh1UqLOKeVNHHUVK/Gc0cDdqpGgorlKjbG2CSHBOYlTEoSw/4bw1NelBQS5i4LllC7j9iGtezxK+0h3u2+8DoWEAhgV/aDhas=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sFFx4dkn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sFFx4dkn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD16FC4CECF;
	Tue,  3 Dec 2024 15:17:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733239022;
	bh=i+AJhq9FjJinT4BD7y6nWs2OdmTeD1BDXrHz8fLluQ4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sFFx4dkn61lvPvqI0PZIMi34GfTOoOp4yylNVjxKtJDo9W6VMUCLc7Fre4UwQSI5E
	 iTPpt2RV8bV+lbMFwDwX68nRrvz13/RtSWwfiu7ZOpCRJVJCtEclrXCQ86QTxKRoYh
	 ftUArTPBrveB+cltHrFMSJuy9E9KOf4IzYTpsP1s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Sourabh Jain <sourabhjain@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 446/817] powerpc/fadump: allocate memory for additional parameters early
Date: Tue,  3 Dec 2024 15:40:18 +0100
Message-ID: <20241203144013.288446266@linuxfoundation.org>
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

From: Hari Bathini <hbathini@linux.ibm.com>

[ Upstream commit f4892c68ecc1cf45e41a78820dd2eebccc945b66 ]

Memory for passing additional parameters to fadump capture kernel
is allocated during subsys_initcall level, using memblock. But
as slab is already available by this time, allocation happens via
the buddy allocator. This may work for radix MMU but is likely to
fail in most cases for hash MMU as hash MMU needs this memory in
the first memory block for it to be accessible in real mode in the
capture kernel (second boot). So, allocate memory for additional
parameters area as soon as MMU mode is obvious.

Fixes: 683eab94da75 ("powerpc/fadump: setup additional parameters for dump capture kernel")
Reported-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Closes: https://lore.kernel.org/lkml/a70e4064-a040-447b-8556-1fd02f19383d@linux.vnet.ibm.com/T/#u
Signed-off-by: Hari Bathini <hbathini@linux.ibm.com>
Signed-off-by: Sourabh Jain <sourabhjain@linux.ibm.com>
Tested-by: Venkat Rao Bagalkote <venkat88@linux.vnet.ibm.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/20241107055817.489795-1-sourabhjain@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/fadump.h |  2 ++
 arch/powerpc/kernel/fadump.c      | 15 ++++++++++-----
 arch/powerpc/kernel/prom.c        |  3 +++
 3 files changed, 15 insertions(+), 5 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 3638f04447f59..a48f54dde4f65 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -19,6 +19,7 @@ extern int is_fadump_active(void);
 extern int should_fadump_crash(void);
 extern void crash_fadump(struct pt_regs *, const char *);
 extern void fadump_cleanup(void);
+void fadump_setup_param_area(void);
 extern void fadump_append_bootargs(void);
 
 #else	/* CONFIG_FA_DUMP */
@@ -26,6 +27,7 @@ static inline int is_fadump_active(void) { return 0; }
 static inline int should_fadump_crash(void) { return 0; }
 static inline void crash_fadump(struct pt_regs *regs, const char *str) { }
 static inline void fadump_cleanup(void) { }
+static inline void fadump_setup_param_area(void) { }
 static inline void fadump_append_bootargs(void) { }
 #endif /* !CONFIG_FA_DUMP */
 
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index ac7b4e1645e55..6ab7934d719f7 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -1577,6 +1577,12 @@ static void __init fadump_init_files(void)
 		return;
 	}
 
+	if (fw_dump.param_area) {
+		rc = sysfs_create_file(fadump_kobj, &bootargs_append_attr.attr);
+		if (rc)
+			pr_err("unable to create bootargs_append sysfs file (%d)\n", rc);
+	}
+
 	debugfs_create_file("fadump_region", 0444, arch_debugfs_dir, NULL,
 			    &fadump_region_fops);
 
@@ -1731,7 +1737,7 @@ static void __init fadump_process(void)
  * Reserve memory to store additional parameters to be passed
  * for fadump/capture kernel.
  */
-static void __init fadump_setup_param_area(void)
+void __init fadump_setup_param_area(void)
 {
 	phys_addr_t range_start, range_end;
 
@@ -1739,7 +1745,7 @@ static void __init fadump_setup_param_area(void)
 		return;
 
 	/* This memory can't be used by PFW or bootloader as it is shared across kernels */
-	if (radix_enabled()) {
+	if (early_radix_enabled()) {
 		/*
 		 * Anywhere in the upper half should be good enough as all memory
 		 * is accessible in real mode.
@@ -1767,12 +1773,12 @@ static void __init fadump_setup_param_area(void)
 						       COMMAND_LINE_SIZE,
 						       range_start,
 						       range_end);
-	if (!fw_dump.param_area || sysfs_create_file(fadump_kobj, &bootargs_append_attr.attr)) {
+	if (!fw_dump.param_area) {
 		pr_warn("WARNING: Could not setup area to pass additional parameters!\n");
 		return;
 	}
 
-	memset(phys_to_virt(fw_dump.param_area), 0, COMMAND_LINE_SIZE);
+	memset((void *)fw_dump.param_area, 0, COMMAND_LINE_SIZE);
 }
 
 /*
@@ -1798,7 +1804,6 @@ int __init setup_fadump(void)
 	}
 	/* Initialize the kernel dump memory structure and register with f/w */
 	else if (fw_dump.reserve_dump_area_size) {
-		fadump_setup_param_area();
 		fw_dump.ops->fadump_init_mem_struct(&fw_dump);
 		register_fadump();
 	}
diff --git a/arch/powerpc/kernel/prom.c b/arch/powerpc/kernel/prom.c
index 88cbe432cad59..e0059842a1c64 100644
--- a/arch/powerpc/kernel/prom.c
+++ b/arch/powerpc/kernel/prom.c
@@ -908,6 +908,9 @@ void __init early_init_devtree(void *params)
 
 	mmu_early_init_devtree();
 
+	/* Setup param area for passing additional parameters to fadump capture kernel. */
+	fadump_setup_param_area();
+
 #ifdef CONFIG_PPC_POWERNV
 	/* Scan and build the list of machine check recoverable ranges */
 	of_scan_flat_dt(early_init_dt_scan_recoverable_ranges, NULL);
-- 
2.43.0



