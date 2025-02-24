Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06425254846;
	Mon, 24 Feb 2025 14:54:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1740408873; cv=none; b=GUqI9X4RIWLFvF25K7K1dWYmCX5Yyd8vJLnWc6BvUGWE+BUJ3jVqL1P4p18u54B7+5wXK6xAEiJgfT+G1KVccD/x6Am3N+poAw8jbgyCfSx3H2CFz4HLn352gGU65ZAZjkHBlnLO4heypzTX59QNbSj9zuTvCGkq5SXzE+EFxds=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1740408873; c=relaxed/simple;
	bh=hG0YSGFoQ9zoDGMvh+8zWtjGVgXyBitDIjjot95GPHY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dlyOYNGU/Mwye60bBTyacuWtTiy/6q70AJJLOmYh0E16T3RhWCLNmEz+81VwxKEpjeOwMWpxChuRcLvy7faFTUzIqMv6at9tc63UVWJ+UfmF7z0YWdKkgTRWP+EzOppT6YPLHJmPSnKmRZPpe8bWkAQsuf91saqw9SziAq4kApc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KqAm6n8K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KqAm6n8K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0DA60C4CED6;
	Mon, 24 Feb 2025 14:54:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1740408872;
	bh=hG0YSGFoQ9zoDGMvh+8zWtjGVgXyBitDIjjot95GPHY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KqAm6n8K7PrQrvVUKn56/kB5bNXbqqydkbVRcl5r9ETmYHrgzHngzJ4GQq26WEj+1
	 9WB3GcYgP/zvC1N9/mZk3QNrPR9gTFKXi8QJ0lPW9BTaCdif7YGXfE3qS20vd7ke49
	 yTbItfFZDZDri2NrR3I5k4RjVaw2YzeuF8yhXy+A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 023/138] powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline
Date: Mon, 24 Feb 2025 15:34:13 +0100
Message-ID: <20250224142605.381111853@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250224142604.442289573@linuxfoundation.org>
References: <20250224142604.442289573@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

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
index c3efacab4b941..aa90a048f319a 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -77,9 +77,17 @@
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



