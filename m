Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E123B1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:19:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60CBBC433C8;
	Tue, 25 Jul 2023 11:19:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283985;
	bh=eFcxogotjaBxsGJWRhsjGq4IDSGHQQya0eUXXdMaGyQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u5gNR5RKmLODHUPYylJiFjjtpefBA/jmrd5CI0E2oiLmO3OQ3a7CmszgNbLx+pjJ/
	 193Pk6Vrm+CxV4/waLucKPTFqHtlo9GngNTDmnp+/6m0k/IdO7KMI1tEo8ZqQq20rn
	 wVCAUOueY0S100SAZbcNCAl2gBFpSrD6yp3d2x7g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Aneesh Kumar K.V" <aneesh.kumar@linux.ibm.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>,
	Sachin Sant <sachinp@linux.ibm.commailto:sachinp@linux.ibm.com>
Subject: [PATCH 5.10 194/509] powerpc/book3s64/mm: Fix DirectMap stats in /proc/meminfo
Date: Tue, 25 Jul 2023 12:42:13 +0200
Message-ID: <20230725104602.620845300@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>

[ Upstream commit 0da90af431abc3f497a38ec9ef6e43b0d0dabe80 ]

On memory unplug reduce DirectMap page count correctly.
root@ubuntu-guest:# grep Direct /proc/meminfo
DirectMap4k:           0 kB
DirectMap64k:           0 kB
DirectMap2M:    115343360 kB
DirectMap1G:           0 kB

Before fix:
root@ubuntu-guest:# ndctl disable-namespace all
disabled 1 namespace
root@ubuntu-guest:# grep Direct /proc/meminfo
DirectMap4k:           0 kB
DirectMap64k:           0 kB
DirectMap2M:    115343360 kB
DirectMap1G:           0 kB

After fix:
root@ubuntu-guest:# ndctl disable-namespace all
disabled 1 namespace
root@ubuntu-guest:# grep Direct /proc/meminfo
DirectMap4k:           0 kB
DirectMap64k:           0 kB
DirectMap2M:    104857600 kB
DirectMap1G:           0 kB

Fixes: a2dc009afa9a ("powerpc/mm/book3s/radix: Add mapping statistics")
Signed-off-by: Aneesh Kumar K.V <aneesh.kumar@linux.ibm.com>
Tested-by: Sachin Sant <sachinp@linux.ibm.com <mailto:sachinp@linux.ibm.com>>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20230616110826.344417-4-aneesh.kumar@linux.ibm.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/mm/book3s64/radix_pgtable.c | 34 +++++++++++++++---------
 1 file changed, 22 insertions(+), 12 deletions(-)

diff --git a/arch/powerpc/mm/book3s64/radix_pgtable.c b/arch/powerpc/mm/book3s64/radix_pgtable.c
index 44239e0acf8ea..3728c17de87e9 100644
--- a/arch/powerpc/mm/book3s64/radix_pgtable.c
+++ b/arch/powerpc/mm/book3s64/radix_pgtable.c
@@ -783,9 +783,9 @@ static void free_pud_table(pud_t *pud_start, p4d_t *p4d)
 }
 
 static void remove_pte_table(pte_t *pte_start, unsigned long addr,
-			     unsigned long end)
+			     unsigned long end, bool direct)
 {
-	unsigned long next;
+	unsigned long next, pages = 0;
 	pte_t *pte;
 
 	pte = pte_start + pte_index(addr);
@@ -807,13 +807,16 @@ static void remove_pte_table(pte_t *pte_start, unsigned long addr,
 		}
 
 		pte_clear(&init_mm, addr, pte);
+		pages++;
 	}
+	if (direct)
+		update_page_count(mmu_virtual_psize, -pages);
 }
 
 static void __meminit remove_pmd_table(pmd_t *pmd_start, unsigned long addr,
-			     unsigned long end)
+				       unsigned long end, bool direct)
 {
-	unsigned long next;
+	unsigned long next, pages = 0;
 	pte_t *pte_base;
 	pmd_t *pmd;
 
@@ -831,19 +834,22 @@ static void __meminit remove_pmd_table(pmd_t *pmd_start, unsigned long addr,
 				continue;
 			}
 			pte_clear(&init_mm, addr, (pte_t *)pmd);
+			pages++;
 			continue;
 		}
 
 		pte_base = (pte_t *)pmd_page_vaddr(*pmd);
-		remove_pte_table(pte_base, addr, next);
+		remove_pte_table(pte_base, addr, next, direct);
 		free_pte_table(pte_base, pmd);
 	}
+	if (direct)
+		update_page_count(MMU_PAGE_2M, -pages);
 }
 
 static void __meminit remove_pud_table(pud_t *pud_start, unsigned long addr,
-			     unsigned long end)
+				       unsigned long end, bool direct)
 {
-	unsigned long next;
+	unsigned long next, pages = 0;
 	pmd_t *pmd_base;
 	pud_t *pud;
 
@@ -861,16 +867,20 @@ static void __meminit remove_pud_table(pud_t *pud_start, unsigned long addr,
 				continue;
 			}
 			pte_clear(&init_mm, addr, (pte_t *)pud);
+			pages++;
 			continue;
 		}
 
 		pmd_base = pud_pgtable(*pud);
-		remove_pmd_table(pmd_base, addr, next);
+		remove_pmd_table(pmd_base, addr, next, direct);
 		free_pmd_table(pmd_base, pud);
 	}
+	if (direct)
+		update_page_count(MMU_PAGE_1G, -pages);
 }
 
-static void __meminit remove_pagetable(unsigned long start, unsigned long end)
+static void __meminit remove_pagetable(unsigned long start, unsigned long end,
+				       bool direct)
 {
 	unsigned long addr, next;
 	pud_t *pud_base;
@@ -899,7 +909,7 @@ static void __meminit remove_pagetable(unsigned long start, unsigned long end)
 		}
 
 		pud_base = p4d_pgtable(*p4d);
-		remove_pud_table(pud_base, addr, next);
+		remove_pud_table(pud_base, addr, next, direct);
 		free_pud_table(pud_base, p4d);
 	}
 
@@ -922,7 +932,7 @@ int __meminit radix__create_section_mapping(unsigned long start,
 
 int __meminit radix__remove_section_mapping(unsigned long start, unsigned long end)
 {
-	remove_pagetable(start, end);
+	remove_pagetable(start, end, true);
 	return 0;
 }
 #endif /* CONFIG_MEMORY_HOTPLUG */
@@ -958,7 +968,7 @@ int __meminit radix__vmemmap_create_mapping(unsigned long start,
 #ifdef CONFIG_MEMORY_HOTPLUG
 void __meminit radix__vmemmap_remove_mapping(unsigned long start, unsigned long page_size)
 {
-	remove_pagetable(start, start + page_size);
+	remove_pagetable(start, start + page_size, false);
 }
 #endif
 #endif
-- 
2.39.2



