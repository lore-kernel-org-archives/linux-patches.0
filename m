Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C10108F70
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 19:54:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 487D3C433C8;
	Sun, 16 Jul 2023 19:54:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689537286;
	bh=VKojzvPKOdH4bD4SmkMve47cM1W0DZqlmLROJVaUQug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yRYF4txWtw2R9tbtYSPD0xLgI20KQX1rqhd0BFDWfs0Rg/uuw8fMeUmCN7IVbdcC+
	 O/T/mWJ7X2y7YdcnulqkwXT8cctd/CmYZE295XxOucauLwX36HVznPwSdL42ALTEw3
	 9lskTYP6PXzlXWoHeZ9bYAqOJKs2aKrVqDEc1G5w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tom Lendacky <thomas.lendacky@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 024/800] x86/sev: Fix calculation of end address based on number of pages
Date: Sun, 16 Jul 2023 21:37:57 +0200
Message-ID: <20230716194949.663283418@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194949.099592437@linuxfoundation.org>
References: <20230716194949.099592437@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Tom Lendacky <thomas.lendacky@amd.com>

[ Upstream commit 5dee19b6b2b194216919b99a1f5af2949a754016 ]

When calculating an end address based on an unsigned int number of pages,
any value greater than or equal to 0x100000 that is shift PAGE_SHIFT bits
results in a 0 value, resulting in an invalid end address. Change the
number of pages variable in various routines from an unsigned int to an
unsigned long to calculate the end address correctly.

Fixes: 5e5ccff60a29 ("x86/sev: Add helper for validating pages in early enc attribute changes")
Fixes: dc3f3d2474b8 ("x86/mm: Validate memory when changing the C-bit")
Signed-off-by: Tom Lendacky <thomas.lendacky@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://lore.kernel.org/r/6a6e4eea0e1414402bac747744984fa4e9c01bb6.1686063086.git.thomas.lendacky@amd.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/x86/include/asm/sev.h | 16 ++++++++--------
 arch/x86/kernel/sev.c      | 14 +++++++-------
 2 files changed, 15 insertions(+), 15 deletions(-)

diff --git a/arch/x86/include/asm/sev.h b/arch/x86/include/asm/sev.h
index 13dc2a9d23c1e..7ca5c9ec8b52e 100644
--- a/arch/x86/include/asm/sev.h
+++ b/arch/x86/include/asm/sev.h
@@ -192,12 +192,12 @@ struct snp_guest_request_ioctl;
 
 void setup_ghcb(void);
 void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
-					 unsigned int npages);
+					 unsigned long npages);
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
-					unsigned int npages);
+					unsigned long npages);
 void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op);
-void snp_set_memory_shared(unsigned long vaddr, unsigned int npages);
-void snp_set_memory_private(unsigned long vaddr, unsigned int npages);
+void snp_set_memory_shared(unsigned long vaddr, unsigned long npages);
+void snp_set_memory_private(unsigned long vaddr, unsigned long npages);
 void snp_set_wakeup_secondary_cpu(void);
 bool snp_init(struct boot_params *bp);
 void __init __noreturn snp_abort(void);
@@ -212,12 +212,12 @@ static inline int pvalidate(unsigned long vaddr, bool rmp_psize, bool validate)
 static inline int rmpadjust(unsigned long vaddr, bool rmp_psize, unsigned long attrs) { return 0; }
 static inline void setup_ghcb(void) { }
 static inline void __init
-early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr, unsigned int npages) { }
+early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr, unsigned long npages) { }
 static inline void __init
-early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned int npages) { }
+early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr, unsigned long npages) { }
 static inline void __init snp_prep_memory(unsigned long paddr, unsigned int sz, enum psc_op op) { }
-static inline void snp_set_memory_shared(unsigned long vaddr, unsigned int npages) { }
-static inline void snp_set_memory_private(unsigned long vaddr, unsigned int npages) { }
+static inline void snp_set_memory_shared(unsigned long vaddr, unsigned long npages) { }
+static inline void snp_set_memory_private(unsigned long vaddr, unsigned long npages) { }
 static inline void snp_set_wakeup_secondary_cpu(void) { }
 static inline bool snp_init(struct boot_params *bp) { return false; }
 static inline void snp_abort(void) { }
diff --git a/arch/x86/kernel/sev.c b/arch/x86/kernel/sev.c
index b031244d6d2df..108bbae59c35a 100644
--- a/arch/x86/kernel/sev.c
+++ b/arch/x86/kernel/sev.c
@@ -645,7 +645,7 @@ static u64 __init get_jump_table_addr(void)
 	return ret;
 }
 
-static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool validate)
+static void pvalidate_pages(unsigned long vaddr, unsigned long npages, bool validate)
 {
 	unsigned long vaddr_end;
 	int rc;
@@ -662,7 +662,7 @@ static void pvalidate_pages(unsigned long vaddr, unsigned int npages, bool valid
 	}
 }
 
-static void __init early_set_pages_state(unsigned long paddr, unsigned int npages, enum psc_op op)
+static void __init early_set_pages_state(unsigned long paddr, unsigned long npages, enum psc_op op)
 {
 	unsigned long paddr_end;
 	u64 val;
@@ -701,7 +701,7 @@ static void __init early_set_pages_state(unsigned long paddr, unsigned int npage
 }
 
 void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long paddr,
-					 unsigned int npages)
+					 unsigned long npages)
 {
 	/*
 	 * This can be invoked in early boot while running identity mapped, so
@@ -723,7 +723,7 @@ void __init early_snp_set_memory_private(unsigned long vaddr, unsigned long padd
 }
 
 void __init early_snp_set_memory_shared(unsigned long vaddr, unsigned long paddr,
-					unsigned int npages)
+					unsigned long npages)
 {
 	/*
 	 * This can be invoked in early boot while running identity mapped, so
@@ -879,7 +879,7 @@ static void __set_pages_state(struct snp_psc_desc *data, unsigned long vaddr,
 		sev_es_terminate(SEV_TERM_SET_LINUX, GHCB_TERM_PSC);
 }
 
-static void set_pages_state(unsigned long vaddr, unsigned int npages, int op)
+static void set_pages_state(unsigned long vaddr, unsigned long npages, int op)
 {
 	unsigned long vaddr_end, next_vaddr;
 	struct snp_psc_desc *desc;
@@ -904,7 +904,7 @@ static void set_pages_state(unsigned long vaddr, unsigned int npages, int op)
 	kfree(desc);
 }
 
-void snp_set_memory_shared(unsigned long vaddr, unsigned int npages)
+void snp_set_memory_shared(unsigned long vaddr, unsigned long npages)
 {
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return;
@@ -914,7 +914,7 @@ void snp_set_memory_shared(unsigned long vaddr, unsigned int npages)
 	set_pages_state(vaddr, npages, SNP_PAGE_STATE_SHARED);
 }
 
-void snp_set_memory_private(unsigned long vaddr, unsigned int npages)
+void snp_set_memory_private(unsigned long vaddr, unsigned long npages)
 {
 	if (!cc_platform_has(CC_ATTR_GUEST_SEV_SNP))
 		return;
-- 
2.39.2



