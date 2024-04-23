Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 09294143C45;
	Tue, 23 Apr 2024 21:44:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908668; cv=none; b=nBVdE+VWB5HgwJnXc4T36btEX4vgDq7Wo9D7ff+m7WfWUdSGc2e/G7/OGiI19D+fpLjT4afQr9ckSSyKrIlmtgYvI21DXdgrDVyK+j1LMcL0QryfwUM8N+8nepNTGnz/1KhaRNt52b3Zyxs0CGifFjX8R3ZWIzXfCEsNnwsNeE4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908668; c=relaxed/simple;
	bh=Qc99/znq5HposHo8rzUzGGvgxZPpzM0dJcUDCLPkaDY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LACmqdQxH1BMjtCrRvHO6vivX0V09uC5jNtm/WiqV1Iq4nsLD0D+DOMk8s9C95MOReM29QvvSiiUs8NYrfVlQ/JO/3BN5jHFg9sezBYf0h7g0vn7au0bbzSdgeCbxdb3p0WAhdhpUzLpMTaPJZ5Sn5VR7rJmgXozCd1Lr7wodjM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c7qpvYiq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c7qpvYiq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CA205C116B1;
	Tue, 23 Apr 2024 21:44:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908667;
	bh=Qc99/znq5HposHo8rzUzGGvgxZPpzM0dJcUDCLPkaDY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c7qpvYiqS5mrTWlMVTjsMYQGmxGND7g8F74CmI4ADsGI21PfuVqU7ApqwFLNQ6JjS
	 Iz2QDl5RTysiXFE0diaQ62rC407d3dQS2DOiGkgkPKWW8Y2oxzj6Cwxj7vtVmT1VxD
	 SxsxNmmuOdSD7XeK2Qylv/Lo0xzMwtOQIsV/GeYo=
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
Subject: [PATCH 6.6 139/158] mm/shmem: inline shmem_is_huge() for disabled transparent hugepages
Date: Tue, 23 Apr 2024 14:39:36 -0700
Message-ID: <20240423213900.218680796@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213855.696477232@linuxfoundation.org>
References: <20240423213855.696477232@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
@@ -110,8 +110,17 @@ extern struct page *shmem_read_mapping_p
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


