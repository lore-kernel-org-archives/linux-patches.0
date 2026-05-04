Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DBF9B3DE43C;
	Mon,  4 May 2026 14:17:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777904264; cv=none; b=ufYAZJy4HBuuiAPKXhbbc1x+w2YclOPVHJ6zFbPWOpKSH5pcSRPWBvC6oxR/M+Jrp+zqP0BoT8IiBXsHVBVEoxkHelZb/Fjx3UkdY0/IaBOUtOg3zcMrK3ViC1IvhyDVSXdetRG50RxuDP2R0029yBbKWdbpPZUHlDrMoKXXzEE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777904264; c=relaxed/simple;
	bh=lMfI71fBHIrrN1iOoakXayfaW3Kz5Z8DUtZtrIViK7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Rrc8x8CnWixnqTk13KC2LebCpbZtvjQef4dn+OUlkB4d5bHR9QKh4AIcTbdlyV2cSeItOOU2bcVToBvUgXPR8SXVt0wjEMeME32AtMwIPmWoqPukIIF5n80OGJBk4ct49tP7YAgWlmklp4DvTClN/IdByvbM5TUSTZxS+XyH/+4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vJxo3tyZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vJxo3tyZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 727FCC2BCC4;
	Mon,  4 May 2026 14:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777904264;
	bh=lMfI71fBHIrrN1iOoakXayfaW3Kz5Z8DUtZtrIViK7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vJxo3tyZr2li6ZkBbRT5XjBlZGOBXkiXxS9qYHMDPwhZB909hYMS6xXppgYzskAbq
	 gasdEw8CSnkKN4ImsYujSoot5Fg9dTZdYjCvYGoUowHLIim9c0tglwz81QztTEpTwL
	 ZupsW8Ysjicu2r3Fqrpx3MfpZsenwyQyQbJ59QpU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jinjiang Tu <tujinjiang@huawei.com>,
	Kevin Brodsky <kevin.brodsky@arm.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Suzuki K Poulose <suzuki.poulose@arm.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 248/275] arm64: mm: Fix rodata=full block mapping support for realm guests
Date: Mon,  4 May 2026 15:53:08 +0200
Message-ID: <20260504135152.254199061@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260504135142.929052779@linuxfoundation.org>
References: <20260504135142.929052779@linuxfoundation.org>
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

From: Ryan Roberts <ryan.roberts@arm.com>

[ Upstream commit f12b435de2f2bb09ce406467020181ada528844c ]

Commit a166563e7ec37 ("arm64: mm: support large block mapping when
rodata=full") enabled the linear map to be mapped by block/cont while
still allowing granular permission changes on BBML2_NOABORT systems by
lazily splitting the live mappings. This mechanism was intended to be
usable by realm guests since they need to dynamically share dma buffers
with the host by "decrypting" them - which for Arm CCA, means marking
them as shared in the page tables.

However, it turns out that the mechanism was failing for realm guests
because realms need to share their dma buffers (via
__set_memory_enc_dec()) much earlier during boot than
split_kernel_leaf_mapping() was able to handle. The report linked below
showed that GIC's ITS was one such user. But during the investigation I
found other callsites that could not meet the
split_kernel_leaf_mapping() constraints.

The problem is that we block map the linear map based on the boot CPU
supporting BBML2_NOABORT, then check that all the other CPUs support it
too when finalizing the caps. If they don't, then we stop_machine() and
split to ptes. For safety, split_kernel_leaf_mapping() previously
wouldn't permit splitting until after the caps were finalized. That
ensured that if any secondary cpus were running that didn't support
BBML2_NOABORT, we wouldn't risk breaking them.

I've fix this problem by reducing the black-out window where we refuse
to split; there are now 2 windows. The first is from T0 until the page
allocator is inititialized. Splitting allocates memory for the page
allocator so it must be in use. The second covers the period between
starting to online the secondary cpus until the system caps are
finalized (this is a very small window).

All of the problematic callers are calling __set_memory_enc_dec() before
the secondary cpus come online, so this solves the problem. However, one
of these callers, swiotlb_update_mem_attributes(), was trying to split
before the page allocator was initialized. So I have moved this call
from arch_mm_preinit() to mem_init(), which solves the ordering issue.

I've added warnings and return an error if any attempt is made to split
in the black-out windows.

Note there are other issues which prevent booting all the way to user
space, which will be fixed in subsequent patches.

Reported-by: Jinjiang Tu <tujinjiang@huawei.com>
Closes: https://lore.kernel.org/all/0b2a4ae5-fc51-4d77-b177-b2e9db74f11d@huawei.com/
Fixes: a166563e7ec3 ("arm64: mm: support large block mapping when rodata=full")
Cc: stable@vger.kernel.org
Reviewed-by: Kevin Brodsky <kevin.brodsky@arm.com>
Signed-off-by: Ryan Roberts <ryan.roberts@arm.com>
Reviewed-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Tested-by: Suzuki K Poulose <suzuki.poulose@arm.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
[ adjusted context to use `__ASSEMBLY__` instead of `__ASSEMBLER__` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/arm64/include/asm/mmu.h |    2 +
 arch/arm64/mm/init.c         |    9 +++++++-
 arch/arm64/mm/mmu.c          |   45 ++++++++++++++++++++++++++++++-------------
 3 files changed, 42 insertions(+), 14 deletions(-)

--- a/arch/arm64/include/asm/mmu.h
+++ b/arch/arm64/include/asm/mmu.h
@@ -112,5 +112,7 @@ void kpti_install_ng_mappings(void);
 static inline void kpti_install_ng_mappings(void) {}
 #endif
 
+extern bool page_alloc_available;
+
 #endif	/* !__ASSEMBLY__ */
 #endif
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -357,7 +357,6 @@ void __init arch_mm_preinit(void)
 	}
 
 	swiotlb_init(swiotlb, flags);
-	swiotlb_update_mem_attributes();
 
 	/*
 	 * Check boundaries twice: Some fundamental inconsistencies can be
@@ -384,6 +383,14 @@ void __init arch_mm_preinit(void)
 	}
 }
 
+bool page_alloc_available __ro_after_init;
+
+void __init mem_init(void)
+{
+	page_alloc_available = true;
+	swiotlb_update_mem_attributes();
+}
+
 void free_initmem(void)
 {
 	void *lm_init_begin = lm_alias(__init_begin);
--- a/arch/arm64/mm/mmu.c
+++ b/arch/arm64/mm/mmu.c
@@ -774,30 +774,51 @@ static inline bool force_pte_mapping(voi
 }
 
 static DEFINE_MUTEX(pgtable_split_lock);
+static bool linear_map_requires_bbml2;
 
 int split_kernel_leaf_mapping(unsigned long start, unsigned long end)
 {
 	int ret;
 
 	/*
-	 * !BBML2_NOABORT systems should not be trying to change permissions on
-	 * anything that is not pte-mapped in the first place. Just return early
-	 * and let the permission change code raise a warning if not already
-	 * pte-mapped.
-	 */
-	if (!system_supports_bbml2_noabort())
-		return 0;
-
-	/*
 	 * If the region is within a pte-mapped area, there is no need to try to
 	 * split. Additionally, CONFIG_DEBUG_PAGEALLOC and CONFIG_KFENCE may
 	 * change permissions from atomic context so for those cases (which are
 	 * always pte-mapped), we must not go any further because taking the
-	 * mutex below may sleep.
+	 * mutex below may sleep. Do not call force_pte_mapping() here because
+	 * it could return a confusing result if called from a secondary cpu
+	 * prior to finalizing caps. Instead, linear_map_requires_bbml2 gives us
+	 * what we need.
 	 */
-	if (force_pte_mapping() || is_kfence_address((void *)start))
+	if (!linear_map_requires_bbml2 || is_kfence_address((void *)start))
 		return 0;
 
+	if (!system_supports_bbml2_noabort()) {
+		/*
+		 * !BBML2_NOABORT systems should not be trying to change
+		 * permissions on anything that is not pte-mapped in the first
+		 * place. Just return early and let the permission change code
+		 * raise a warning if not already pte-mapped.
+		 */
+		if (system_capabilities_finalized())
+			return 0;
+
+		/*
+		 * Boot-time: split_kernel_leaf_mapping_locked() allocates from
+		 * page allocator. Can't split until it's available.
+		 */
+		if (WARN_ON(!page_alloc_available))
+			return -EBUSY;
+
+		/*
+		 * Boot-time: Started secondary cpus but don't know if they
+		 * support BBML2_NOABORT yet. Can't allow splitting in this
+		 * window in case they don't.
+		 */
+		if (WARN_ON(num_online_cpus() > 1))
+			return -EBUSY;
+	}
+
 	/*
 	 * Ensure start and end are at least page-aligned since this is the
 	 * finest granularity we can split to.
@@ -897,8 +918,6 @@ static int range_split_to_ptes(unsigned
 	return ret;
 }
 
-static bool linear_map_requires_bbml2 __initdata;
-
 u32 idmap_kpti_bbml2_flag;
 
 static void __init init_idmap_kpti_bbml2_flag(void)


