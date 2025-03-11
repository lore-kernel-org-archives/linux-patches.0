Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73F3925C715;
	Tue, 11 Mar 2025 15:13:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741706038; cv=none; b=uA95bh1wBCpTDV6NA3YHgf0MGknrPEZLFhwoI9DrSE9vFznY825khGZiua8+LTq52WDbSSxLXecr8aummKbwFBDlmEdtpuULbmKdRphHDVBWfuJXWrWXBFvkcGG52Xn7qJ6FpdHrncBUglb8rbGh6KAhVPpnNVQarikpF3pk6zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741706038; c=relaxed/simple;
	bh=mlN2l8qC/EwaCzKTXyYqQZC4rBqDksbEYmDohEuznjM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b1PWKJt+ZwlY9IgWCuWEK3W8OcqRNKS47+ouPrfKcwbcejFzJhN/iXo/C/EojmDGGasPFGqZBoUfbpWUVlOUqsVNyiLTOH4gaYrt+QWIJQt3URetrwJ4I0VFBq2rjlL6cZcuXh3LBG7guIvvp5gUnYKa8Y2xZhfBRyHg5DTzbrs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lCmgaA3w; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lCmgaA3w"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF656C4CEE9;
	Tue, 11 Mar 2025 15:13:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741706038;
	bh=mlN2l8qC/EwaCzKTXyYqQZC4rBqDksbEYmDohEuznjM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lCmgaA3wItaj5f3JN/kCCnTSintVQPlZiVScfGFLtV/ijZsshzkOKLidRY7MSfZ5L
	 1NfNO27gXoKdAwTPsK+c83vKRb/L6t4tX7tRvzs+bPgR7nC8ZV5s6935C0jxSx6Sq9
	 e3tEkW2T8VpXa6Wugwugxl7K5QKaAKW0zah8xF34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Christophe Leroy <christophe.leroy@csgroup.eu>,
	"Ritesh Harjani (IBM)" <ritesh.list@gmail.com>,
	Madhavan Srinivasan <maddy@linux.ibm.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 241/328] powerpc/64s: Rewrite __real_pte() and __rpte_to_hidx() as static inline
Date: Tue, 11 Mar 2025 16:00:11 +0100
Message-ID: <20250311145724.493171707@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145714.865727435@linuxfoundation.org>
References: <20250311145714.865727435@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
index 3e35a7d7dfbaf..864743b46f45a 100644
--- a/arch/powerpc/include/asm/book3s/64/hash-4k.h
+++ b/arch/powerpc/include/asm/book3s/64/hash-4k.h
@@ -86,9 +86,17 @@ static inline int hash__hugepd_ok(hugepd_t hpd)
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



