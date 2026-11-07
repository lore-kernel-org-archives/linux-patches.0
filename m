Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794062622;
	b=YTU6WNDCqBGSWYBCRS5vRhEuN6X+74DkoxCN0ofdwx/q92VttywuyaoyV1pnN9z0Lz3N
	 084E1baSN21lyTjdKdp5o1vWDbf1MGP0fFCvD0B87+D3/WrYt13OrzH59Km7/gXaQZzol
	 WJTBoJd4B5DigF5Q3VRkbJ34xlue7XajW7X+c/iXD/BIHYYQVfcbWs4eRiJr39fTzjFaa
	 hnkZ+QZJpopajT4iohRKfOzxcCA6UwefdSZq1oiKbF5rl3FPuZLYFBQ8NK8X5kbGc8Pb4
	 yU856IrcqFrU/Ond2z1+q9oD6CDJ8UTvaV98cJ3saqJHrIPvHtsDeMNH7rPTvty3s8A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794062622;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=C+uL7+GW3eupOLmL1NWuazW8iKCi6lsWUixHM0aDxCo=;
	b=PfoplJqg4sipcLvfkCiuUJcjgCWoULjVKkcDDw9Dw6sBfu1uz09bJ4L228gh8y0rkgkW
	 DFKu6/SZgPLql2kz41VQxcpvcY7nUSW1uayImKLO7eiKcG3TWRxwJbDrwZdL4QkQmUUro
	 d1Mn18/mRJ1lFCdPyTqwbOXcKWjxd6yrHFkldY/h4B+8ngMbpChk4YaTuFKMW9ozJUgYQ
	 90ud7ME1HCMF9WBuy+chVQuGY2B9Is3MqnXCBhNY4/mqx9dWnlx4aL7IJZujUAQn/z962
	 4oUWCVWKnOlC/ygo/TLGQ8N5rjRi40OYThAZB0fNxSEk3eybqSmOxaLhAihBbMPckKw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPgBBQfb;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8234A606A655;
	Sat,  7 Nov 2026 14:43:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=TPgBBQfb
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E88A1F0089F;
	Sat,  7 Nov 2026 14:43:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794062622;
	bh=C+uL7+GW3eupOLmL1NWuazW8iKCi6lsWUixHM0aDxCo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TPgBBQfbZmPbR57sJLFs/YLR4i2AKOITWF5WW9KHOusxAMrSONWgGixFUaOFeCSCS
	 +Vx3uWP8HJs8tW7qbzf7tqzcdX0KXUdgAL1e4SLmsyynFSaJdujEYgQtirQStm8gvf
	 PbO/SIS/b3hpo1q7qnt1zkAc5kMxjvWQ/Dw195bI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Lance Yang <lance.yang@linux.dev>,
	Zhao Gongyi <zhaogongyi@bytedance.com>,
	Catalin Marinas <catalin.marinas@arm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 1494/1536] arm64/mm: restrict transparent contpte mappings to valid PTEs
Date: Sat,  7 Nov 2026 08:58:30 -0500
Message-ID: <20261107135039.822768750@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134957.653319350@linuxfoundation.org>
References: <20261107134957.653319350@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhao Gongyi <zhaogongyi@bytedance.com>

[ Upstream commit 486d396b19e93f6e56e0a0ba96c14a9ccc1a5977 ]

The transparent contpte layer treats PTE_CONT as software grouping state.
When a valid PTE has PTE_CONT set, the contpte helpers may align an
operation to a CONT_PTE_SIZE block and operate on the whole block. The
current single-PTE helpers use pte_valid_cont() to identify such groups;
this is a helper contract, not an architectural restriction on using
PTE_CONT with present-invalid descriptors. Explicit users such as hugetlb
manage their contiguous encodings separately.

contpte_set_ptes() currently sets PTE_CONT from alignment alone. Batched
set_ptes() users can therefore install present-invalid PTEs with
PTE_CONT set, for example mprotect(PROT_NONE), NUMA hinting through
modify_prot_commit_ptes(), fork() copying a PROT_NONE large folio, or a
PMD split installing PAGE_NONE PTEs.

This is not a hardware programming problem: invalid descriptors are not
translated, so the hardware ignores descriptor bits such as PTE_CONT. It
is a software-state problem. Some arm64 fast paths, such as
test_and_clear_young_ptes(), test pte_cont() directly instead of
pte_valid_cont().

In the observed failure, mprotect(PROT_NONE) installed a full
CONT_PTE_SIZE range of present-invalid PTEs with PTE_CONT set.
MADV_GUARD_INSTALL then zapped one PTE. The nr == 1 clear_full_ptes()
path only unfolds pte_valid_cont() entries, so the neighbouring
present-invalid entries kept PTE_CONT while the target entry became a
guard marker.

clear_refs_pte_range() then reached the marker through:

  ptep_test_and_clear_young()
  test_and_clear_young_ptes()
  contpte_test_and_clear_young_ptes()
  contpte_align_addr_ptep()
  __ptep_test_and_clear_young()

The marker changed from old_pte=0x00000000000047c0 to
new_pte=0x00000000000043c0 by clearing PTE_AF. For swap PTEs, bit 10 is
part of the swap type field, bits 6-10: 0x47c0 is SWP_PTE_MARKER with
offset 4, while 0x43c0 has type 15 and is decoded as an ordinary swap
entry. Zap later warned in swap_put_entries_direct() with a bad swap
entry.

Present-invalid PTEs could retain PTE_CONT as software grouping state,
but their single-PTE modification paths would then need to recognize
and unfold those groups consistently. Since current helpers mostly use
pte_valid_cont() for membership, avoid creating present-invalid
transparent contpte groups in contpte_set_ptes(). They bring no hardware
benefit while invalid, and eligible valid ranges can be grouped again
when they are installed.

The public set_ptes() wrapper already clears PTE_CONT before calling
contpte_set_ptes(). Return invalid PTEs through __set_ptes() directly,
and warn if a future direct caller unexpectedly passes an invalid PTE
with PTE_CONT set.

This is triggerable by a user process against its own address space. On
systems running with panic_on_warn, the warning becomes a denial of
service.

Fixes: 4602e5757bcc ("arm64/mm: wire up PTE_CONT for user mappings")
Cc: stable@vger.kernel.org
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Tested-by: Lance Yang <lance.yang@linux.dev>
Signed-off-by: Zhao Gongyi <zhaogongyi@bytedance.com>
Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arm64/include/asm/pgtable.h | 3 +++
 arch/arm64/mm/contpte.c          | 4 +++-
 2 files changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/arm64/include/asm/pgtable.h b/arch/arm64/include/asm/pgtable.h
index a66a474949c86..2356678be4daf 100644
--- a/arch/arm64/include/asm/pgtable.h
+++ b/arch/arm64/include/asm/pgtable.h
@@ -1541,6 +1541,9 @@ extern void ptep_modify_prot_commit(struct vm_area_struct *vma,
  * The contpte APIs are used to transparently manage the contiguous bit in ptes
  * where it is possible and makes sense to do so. The PTE_CONT bit is considered
  * a private implementation detail of the public ptep API (see below).
+ * Single-PTE transparent contpte helpers use pte_valid_cont() to identify
+ * grouped PTEs; explicit contiguous-encoding users such as hugetlb manage
+ * their entries separately.
  */
 extern void __contpte_try_fold(struct mm_struct *mm, unsigned long addr,
 				pte_t *ptep, pte_t pte);
diff --git a/arch/arm64/mm/contpte.c b/arch/arm64/mm/contpte.c
index 726c56aa2dfcc..03c3f01765910 100644
--- a/arch/arm64/mm/contpte.c
+++ b/arch/arm64/mm/contpte.c
@@ -253,8 +253,10 @@ void contpte_set_ptes(struct mm_struct *mm, unsigned long addr,
 	 */
 	VM_WARN_ON(nr == 1);
 
-	if (!mm_is_user(mm))
+	if (!mm_is_user(mm) || !pte_valid(pte)) {
+		VM_WARN_ON_ONCE(!pte_valid(pte) && pte_cont(pte));
 		return __set_ptes(mm, addr, ptep, pte, nr);
+	}
 
 	end = addr + (nr << PAGE_SHIFT);
 	pfn = pte_pfn(pte);
-- 
2.53.0



