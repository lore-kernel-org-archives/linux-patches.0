Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BC09720B3E;
	Tue, 23 Apr 2024 21:42:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908542; cv=none; b=itppx+QSLjoi32CgstTcvs1GlDegn4r0c3zmU7fA1nnyLqorS7lYYjB9D3eg6av2AF/v5XoagXAH+GmWwG0Bu/OBtArXyNAqkTIY2MEuXoZURTCag/fywXrQm6An9tr6ek2g3YlbPuik+1eh3H83P/lbTElociNw9pD1mxkV+SM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908542; c=relaxed/simple;
	bh=BYEu/r/H0/N+1ey6NsGYvPFQE3Yh0u/Y1awCYUowuHI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=c1hYWcD2Ii0gOW6COfVTmqlWC0V6l12QCG8FaF0v6UV7MZrwBFNcrURQpJCMqJQPUvzR/+AhCgOiUZ8SEFNM4xtYHorE5iYZ+7Et+velB3vjdIumKKbtdMhgT/ahL3LGzblxZqqOlCwukSTDwh4/trHY/GhA1E3ZfQFCBAlaxkw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FlMYY2yA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FlMYY2yA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90302C116B1;
	Tue, 23 Apr 2024 21:42:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908542;
	bh=BYEu/r/H0/N+1ey6NsGYvPFQE3Yh0u/Y1awCYUowuHI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FlMYY2yABPfcA/kbe7bhi5TzedvbxsT0Cw5tEp2DJsjednpQyY8AJsUgQtPqG7Hm4
	 s66qi6NKgNGsur9dCbFIUwWOcusdGOMQ3HhMrbpY0ak0MHHfesRLidryjJBY89Srzy
	 gjJz4paeaPkecJwyj/7kZa7kdnxN30hf/P4e1cG8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	David Hildenbrand <david@redhat.com>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Hugh Dickins <hughd@google.com>,
	Ilya Leoshkevich <iii@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 138/158] mm/shmem: inline shmem_is_huge() for disabled transparent hugepages
Date: Tue, 23 Apr 2024 14:39:20 -0700
Message-ID: <20240423213900.355862439@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.824778126@linuxfoundation.org>
References: <20240423213855.824778126@linuxfoundation.org>
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

6.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sumanth Korikkar <sumanthk@linux.ibm.com>

commit 1f737846aa3c45f07a06fa0d018b39e1afb8084a upstream.

In order to  minimize code size (CONFIG_CC_OPTIMIZE_FOR_SIZE=y),
compiler might choose to make a regular function call (out-of-line) for
shmem_is_huge() instead of inlining it. When transparent hugepages are
disabled (CONFIG_TRANSPARENT_HUGEPAGE=n), it can cause compilation
error.

mm/shmem.c: In function `shmem_getattr':
./include/linux/huge_mm.h:383:27: note: in expansion of macro `BUILD_BUG'
  383 | #define HPAGE_PMD_SIZE ({ BUILD_BUG(); 0; })
      |                           ^~~~~~~~~
mm/shmem.c:1148:33: note: in expansion of macro `HPAGE_PMD_SIZE'
 1148 |                 stat->blksize = HPAGE_PMD_SIZE;

To prevent the possible error, always inline shmem_is_huge() when
transparent hugepages are disabled.

Link: https://lkml.kernel.org/r/20240409155407.2322714-1-sumanthk@linux.ibm.com
Signed-off-by: Sumanth Korikkar <sumanthk@linux.ibm.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Ilya Leoshkevich <iii@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/shmem_fs.h |    9 +++++++++
 mm/shmem.c               |    6 ------
 2 files changed, 9 insertions(+), 6 deletions(-)

--- a/include/linux/shmem_fs.h
+++ b/include/linux/shmem_fs.h
@@ -114,8 +114,17 @@ extern struct page *shmem_read_mapping_p
 extern void shmem_truncate_range(struct inode *inode, loff_t start, loff_t end);
 int shmem_unuse(unsigned int type);
 
+#ifdef CONFIG_TRANSPARENT_HUGEPAGE
 extern bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
 			  struct mm_struct *mm, unsigned long vm_flags);
+#else
+static __always_inline bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
+					  struct mm_struct *mm, unsigned long vm_flags)
+{
+	return false;
+}
+#endif
+
 #ifdef CONFIG_SHMEM
 extern unsigned long shmem_swap_usage(struct vm_area_struct *vma);
 #else
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -742,12 +742,6 @@ static long shmem_unused_huge_count(stru
 
 #define shmem_huge SHMEM_HUGE_DENY
 
-bool shmem_is_huge(struct inode *inode, pgoff_t index, bool shmem_huge_force,
-		   struct mm_struct *mm, unsigned long vm_flags)
-{
-	return false;
-}
-
 static unsigned long shmem_unused_huge_shrink(struct shmem_sb_info *sbinfo,
 		struct shrink_control *sc, unsigned long nr_to_split)
 {


