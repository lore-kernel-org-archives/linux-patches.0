Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0379F158525;
	Mon, 24 Feb 2025 14:41:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408099; cv=none; b=QLNjRfUjDhVT7Gth9j1U/xgL3tBMhH4Y5JhUymmIZsJs9XqJK2iOEHZdoO4p/dLYk681uwpmLtN8yR/7FYlrzpQc7K7F9wK+2NeUj8Lz9gLoV5l4E0JF25Vlo5TFkSrAkKM5j3jeXEDFafWYIcgvYghog43dn6oDInZgqUBooUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408099; c=relaxed/simple;
	bh=4UPUhvmQfg/QdsiOflzYPKiAb7myD0ftSibYZy10n5k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=M9GfGcXQbWSNQNwarDRXh35HF2/47aJMW90ht38w6MaOYUs3PVTN3mz1QPbTh8WkiXq9khQazhnxd9H2ZMTReBIbEuVSwuNj5UEAeP250EBybqNuHYbIgNycKQua9NBBLUM+nE8BhHaudmIoxsfph/1j3EP4Hqnb/UbE3tfr9vs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=leF6vrvC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="leF6vrvC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E385EC4CED6;
	Mon, 24 Feb 2025 14:41:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408098;
	bh=4UPUhvmQfg/QdsiOflzYPKiAb7myD0ftSibYZy10n5k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=leF6vrvC+N6zY+/zwQubtJbLpjTdF52spmYj4rBO17fBzz9TkEsaUzJ/9ApYTbt6R
	 nl4HwZKVELC+3iQm46TyNSsFpfZ/SfoHY8GanFLpHjpHWFO2M6wjwojiDUnGPVpfGT
	 v5ulYYMGoxNcSU5grDQPFHLN8vpd5J/rzrDbuCbk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 067/140] powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline
Date: Mon, 24 Feb 2025 15:34:26 +0100
Message-ID: <20250224142605.644146167@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142602.998423469@linuxfoundation.org>
References: <20250224142602.998423469@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christophe Leroy <christophe.leroy@csgroup.eu>

[ Upstream commit 61bcc752d1b81fde3cae454ff20c1d3c359df500 ]

Rewrite __real_pte() and __rpte_to_hidx() as static inline in order to
avoid following warnings/errors when building with 4k page size:

	  CC      arch/powerpc/mm/book3s64/hash_tlb.o
	arch/powerpc/mm/book3s64/hash_tlb.c: In function 'hpte_need_flush':
	arch/powerpc/mm/book3s64/hash_tlb.c:49:16: error: variable 'offset' set but not used [-Werror=unused-but-set-variable]
	   49 |         int i, offset;
	      |                ^~~~~~

	  CC      arch/powerpc/mm/book3s64/hash_native.o
	arch/powerpc/mm/book3s64/hash_native.c: In function 'native_flush_hash_range':
	arch/powerpc/mm/book3s64/hash_native.c:782:29: error: variable 'index' set but not used [-Werror=unused-but-set-variable]
	  782 |         unsigned long hash, index, hidx, shift, slot;
	      |                             ^~~~~

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202501081741.AYFwybsq-lkp@intel.com/
Fixes: ff31e105464d ("powerpc/mm/hash64: Store the slot information at the right offset for hugetlb")
Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
Reviewed-by: Ritesh Harjani (IBM) <ritesh.list@gmail.com>
Signed-off-by: Madhavan Srinivasan <maddy@linux.ibm.com>
Link: https://patch.msgid.link/e0d340a5b7bd478ecbf245d826e6ab2778b74e06.1736706263.git.christophe.leroy@csgroup.eu
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/include/asm/book3s/64/hash-4k.h | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/arch/powerpc/include/asm/book3s/64/hash-4k.h b/arch/powerpc/include/asm/book3s/64/hash-4k.h
index 57ebbacf1709c..2a2649e0f91df 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -92,9 +92,17 @@ static inline int hash__hugepd_ok(hugepd_t hpd)
 /*
  * With 4K page size the real_pte machinery is all nops.
  */
-#define __real_pte(e, p, o)		((real_pte_t){(e)})
+static inline real_pte_t __real_pte(pte_t pte, pte_t *ptep, int offset)
+{
+	return (real_pte_t){pte};
+}
+
 #define __rpte_to_pte(r)	((r).pte)
-#define __rpte_to_hidx(r,index)	(pte_val(__rpte_to_pte(r)) >> H_PAGE_F_GIX_SHIFT)
+
+static inline unsigned long __rpte_to_hidx(real_pte_t rpte, unsigned long index)
+{
+	return pte_val(__rpte_to_pte(rpte)) >> H_PAGE_F_GIX_SHIFT;
+}
 
 #define pte_iterate_hashed_subpages(rpte, psize, va, index, shift)       \
 	do {							         \
-- 
2.39.5



