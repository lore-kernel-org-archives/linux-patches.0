Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 557A222FAE3;
	Thu, 12 Dec 2024 16:04:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734019458; cv=none; b=I9gS/ae15rbbbKU4XMdjHRiwlQGGkKWOh4UG2PP6EJTJg436qbtZeAaNdaQ9wjT5edsJoq+Aj+Utj2NpTT3xcO5KKdf9dNPT2MjTu5KDUKAJr0bzQtSxqy7vW/jS9l+X7o/HzwcV+xbUljJpblDUar81r+LrR/QnJCaNBvriCNM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734019458; c=relaxed/simple;
	bh=32SZObhAS1txUapU5caEYY/z8whYjq77rsYIgth1CJA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=RBYtz1Zwg+hwb7SomB4sj2zSDwUOpiNFX9XlKKLpcACg5If68YO2MvfSJ9ivXM7M8R5xPHGpER0fZ+lxzBjUYvHDSJOLHQLf08OebZpfaJs8a/Vh4pStVP5BXUmtvYtFOBUEuMCRFk5Zz2hB/i85R5kGTF9hWHFt6C8TYkqabIQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DAYr1zx+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DAYr1zx+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9FC6FC4CECE;
	Thu, 12 Dec 2024 16:04:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734019458;
	bh=32SZObhAS1txUapU5caEYY/z8whYjq77rsYIgth1CJA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DAYr1zx+7VwrdTJRLzrDxLBxFNSrCt8vn0dNuvV6LU3QZHgSRDTb1l0Qk3B2BgULm
	 X+0Vus9q84i7rRRggETcYbaeSD5H/O15jlDIKjaiY+9gRrjjBI2x+fq2ZlvHQ4STqn
	 DGu90HH0JIsbY0QAoePiAtMXLpe+rZVGfaGBCqkc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Hildenbrand <david@redhat.com>,
	Sachin P Bappalige <sachinpb@linux.ibm.com>,
	Hari Bathini <hbathini@linux.ibm.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 212/772] powerpc/fadump: Move fadump_cma_init to setup_arch() after initmem_init()
Date: Thu, 12 Dec 2024 15:52:37 +0100
Message-ID: <20241212144358.682186329@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144349.797589255@linuxfoundation.org>
References: <20241212144349.797589255@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ritesh Harjani (IBM) <ritesh.list@gmail.com>

[ Upstream commit 05b94cae1c47f94588c3e7096963c1007c4d9c1d ]

During early init CMA_MIN_ALIGNMENT_BYTES can be PAGE_SIZE,
since pageblock_order is still zero and it gets initialized
later during initmem_init() e.g.
setup_arch() -> initmem_init() -> sparse_init() -> set_pageblock_order()

One such use case where this causes issue is -
early_setup() -> early_init_devtree() -> fadump_reserve_mem() -> fadump_cma_init()

This causes CMA memory alignment check to be bypassed in
cma_init_reserved_mem(). Then later cma_activate_area() can hit
a VM_BUG_ON_PAGE(pfn & ((1 << order) - 1)) if the reserved memory
area was not pageblock_order aligned.

Fix it by moving the fadump_cma_init() after initmem_init(),
where other such cma reservations also gets called.

<stack trace>
==============
page: refcount:0 mapcount:0 mapping:0000000000000000 index:0x0 pfn:0x10010
flags: 0x13ffff800000000(node=1|zone=0|lastcpupid=0x7ffff) CMA
raw: 013ffff800000000 5deadbeef0000100 5deadbeef0000122 0000000000000000
raw: 0000000000000000 0000000000000000 00000000ffffffff 0000000000000000
page dumped because: VM_BUG_ON_PAGE(pfn & ((1 << order) - 1))
------------[ cut here ]------------
kernel BUG at mm/page_alloc.c:778!

Call Trace:
__free_one_page+0x57c/0x7b0 (unreliable)
free_pcppages_bulk+0x1a8/0x2c8
free_unref_page_commit+0x3d4/0x4e4
free_unref_page+0x458/0x6d0
init_cma_reserved_pageblock+0x114/0x198
cma_init_reserved_areas+0x270/0x3e0
do_one_initcall+0x80/0x2f8
kernel_init_freeable+0x33c/0x530
kernel_init+0x34/0x26c
ret_from_kernel_user_thread+0x14/0x1c

Fixes: 11ac3e87ce09 ("mm: cma: use pageblock_order as the single alignment")
Suggested-by: David Hildenbrand <david@redhat.com>
Reported-by: Sachin P Bappalige <sachinpb@linux.ibm.com>
Acked-by: Hari Bathini <hbathini@linux.ibm.com>
Reviewed-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Signed-off-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://patch.msgid.link/3ae208e48c0d9cefe53d2dc4f593388067405b7d.1729146153.git.ritesh.list@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/fadump.h  | 7 +++++++
 arch/powerpc/kernel/fadump.c       | 6 +-----
 arch/powerpc/kernel/setup-common.c | 6 ++++--
 3 files changed, 12 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/include/asm/fadump.h b/arch/powerpc/include/asm/fadump.h
index 526a6a6473128..daa44b2ef35ad 100644
--- a/arch/powerpc/include/asm/fadump.h
+++ b/arch/powerpc/include/asm/fadump.h
@@ -32,4 +32,11 @@ extern int early_init_dt_scan_fw_dump(unsigned long node, const char *uname,
 				      int depth, void *data);
 extern int fadump_reserve_mem(void);
 #endif
+
+#if defined(CONFIG_FA_DUMP) && defined(CONFIG_CMA)
+void fadump_cma_init(void);
+#else
+static inline void fadump_cma_init(void) { }
+#endif
+
 #endif /* _ASM_POWERPC_FADUMP_H */
diff --git a/arch/powerpc/kernel/fadump.c b/arch/powerpc/kernel/fadump.c
index 4722a9e606e61..1866bac234000 100644
--- a/arch/powerpc/kernel/fadump.c
+++ b/arch/powerpc/kernel/fadump.c
@@ -80,7 +80,7 @@ static struct cma *fadump_cma;
  * But for some reason even if it fails we still have the memory reservation
  * with us and we can still continue doing fadump.
  */
-static void __init fadump_cma_init(void)
+void __init fadump_cma_init(void)
 {
 	unsigned long long base, size;
 	int rc;
@@ -124,8 +124,6 @@ static void __init fadump_cma_init(void)
 		(unsigned long)cma_get_base(fadump_cma) >> 20,
 		fw_dump.reserve_dump_area_size);
 }
-#else
-static void __init fadump_cma_init(void) { }
 #endif /* CONFIG_CMA */
 
 /* Scan the Firmware Assisted dump configuration details. */
@@ -642,8 +640,6 @@ int __init fadump_reserve_mem(void)
 
 		pr_info("Reserved %lldMB of memory at %#016llx (System RAM: %lldMB)\n",
 			(size >> 20), base, (memblock_phys_mem_size() >> 20));
-
-		fadump_cma_init();
 	}
 
 	return ret;
diff --git a/arch/powerpc/kernel/setup-common.c b/arch/powerpc/kernel/setup-common.c
index 56f6b958926d7..41c03c8e41b41 100644
--- a/arch/powerpc/kernel/setup-common.c
+++ b/arch/powerpc/kernel/setup-common.c
@@ -982,9 +982,11 @@ void __init setup_arch(char **cmdline_p)
 	initmem_init();
 
 	/*
-	 * Reserve large chunks of memory for use by CMA for KVM and hugetlb. These must
-	 * be called after initmem_init(), so that pageblock_order is initialised.
+	 * Reserve large chunks of memory for use by CMA for fadump, KVM and
+	 * hugetlb. These must be called after initmem_init(), so that
+	 * pageblock_order is initialised.
 	 */
+	fadump_cma_init();
 	kvm_cma_reserve();
 	gigantic_hugetlb_cma_reserve();
 
-- 
2.43.0



