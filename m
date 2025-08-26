Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5EB9C3376BD;
	Tue, 26 Aug 2025 14:43:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219435; cv=none; b=TpvhbxenWASbZ4f2ZZYKU2in+QPkvG/bytd0wcc+0hJW4+/xNySge6zRdzrNfwybkoyOGPA9lsSkqtAnIVm2106r0MDo8S+DGsGOnMh+Rxo5MEcgUaa9Sd1IoeXx+lfG323SlfE7sHe+ZUz2rzpEulw5SP0n5NY7GptQA4fYZMM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219435; c=relaxed/simple;
	bh=9Ushf+NgKBvN0uNP6ljNqtv8uixSpOnVPMajbY67JhE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mAunHAkigyqRhJlMMjkh7aeAjLsACdH4P4xb+VQlUwMP27WgWATq3FiZn7CqQMP62S/jYfnB5OO2x5BdHPW8V4kT3z+a4SUl5AceUIaRNfT+bDtZsOHl9Kglp/6aJh/KeXkrRDxnkN9wx4YOXwheVWzBM4eKzqBsgvTd+ot+a+M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wrzC2RsT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wrzC2RsT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3C52C4CEF1;
	Tue, 26 Aug 2025 14:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219435;
	bh=9Ushf+NgKBvN0uNP6ljNqtv8uixSpOnVPMajbY67JhE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wrzC2RsT7qypRXN6fpWWFUJjW53BxBZbnIQBk7OqPGVsHLCYb6YlbgzqVLJQD/DYM
	 JkhiaonVK/QPBggaZSbqXpM76V+qOC0jdLIbJpAo+FPQLoR607s6G4xuuPh6MOiuwd
	 wZePXn2ShfgPF+Crxncq+6mvmd5owUwlpVQ+C4PA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lorenzo Stoakes <lstoakes@gmail.com>,
	Jan Kara <jack@suse.cz>,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Andy Lutomirski <luto@kernel.org>,
	Christian Brauner <brauner@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Isaac J. Manjarres" <isaacmanjarres@google.com>
Subject: [PATCH 5.4 380/403] mm: update memfd seal write check to include F_SEAL_WRITE
Date: Tue, 26 Aug 2025 13:11:46 +0200
Message-ID: <20250826110917.515769429@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
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

From: Lorenzo Stoakes <lstoakes@gmail.com>

[ Upstream commit 28464bbb2ddc199433383994bcb9600c8034afa1 ]

The seal_check_future_write() function is called by shmem_mmap() or
hugetlbfs_file_mmap() to disallow any future writable mappings of an memfd
sealed this way.

The F_SEAL_WRITE flag is not checked here, as that is handled via the
mapping->i_mmap_writable mechanism and so any attempt at a mapping would
fail before this could be run.

However we intend to change this, meaning this check can be performed for
F_SEAL_WRITE mappings also.

The logic here is equally applicable to both flags, so update this
function to accommodate both and rename it accordingly.

Link: https://lkml.kernel.org/r/913628168ce6cce77df7d13a63970bae06a526e0.1697116581.git.lstoakes@gmail.com
Signed-off-by: Lorenzo Stoakes <lstoakes@gmail.com>
Reviewed-by: Jan Kara <jack@suse.cz>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>
Cc: Andy Lutomirski <luto@kernel.org>
Cc: Christian Brauner <brauner@kernel.org>
Cc: Hugh Dickins <hughd@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Muchun Song <muchun.song@linux.dev>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org
Signed-off-by: Isaac J. Manjarres <isaacmanjarres@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/hugetlbfs/inode.c |    2 +-
 include/linux/mm.h   |   15 ++++++++-------
 mm/shmem.c           |    2 +-
 3 files changed, 10 insertions(+), 9 deletions(-)

--- a/fs/hugetlbfs/inode.c
+++ b/fs/hugetlbfs/inode.c
@@ -152,7 +152,7 @@ static int hugetlbfs_file_mmap(struct fi
 	vma->vm_flags |= VM_HUGETLB | VM_DONTEXPAND;
 	vma->vm_ops = &hugetlb_vm_ops;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 
--- a/include/linux/mm.h
+++ b/include/linux/mm.h
@@ -2946,25 +2946,26 @@ static inline int pages_identical(struct
 }
 
 /**
- * seal_check_future_write - Check for F_SEAL_FUTURE_WRITE flag and handle it
+ * seal_check_write - Check for F_SEAL_WRITE or F_SEAL_FUTURE_WRITE flags and
+ *                    handle them.
  * @seals: the seals to check
  * @vma: the vma to operate on
  *
- * Check whether F_SEAL_FUTURE_WRITE is set; if so, do proper check/handling on
- * the vma flags.  Return 0 if check pass, or <0 for errors.
+ * Check whether F_SEAL_WRITE or F_SEAL_FUTURE_WRITE are set; if so, do proper
+ * check/handling on the vma flags.  Return 0 if check pass, or <0 for errors.
  */
-static inline int seal_check_future_write(int seals, struct vm_area_struct *vma)
+static inline int seal_check_write(int seals, struct vm_area_struct *vma)
 {
-	if (seals & F_SEAL_FUTURE_WRITE) {
+	if (seals & (F_SEAL_WRITE | F_SEAL_FUTURE_WRITE)) {
 		/*
 		 * New PROT_WRITE and MAP_SHARED mmaps are not allowed when
-		 * "future write" seal active.
+		 * write seals are active.
 		 */
 		if ((vma->vm_flags & VM_SHARED) && (vma->vm_flags & VM_WRITE))
 			return -EPERM;
 
 		/*
-		 * Since an F_SEAL_FUTURE_WRITE sealed memfd can be mapped as
+		 * Since an F_SEAL_[FUTURE_]WRITE sealed memfd can be mapped as
 		 * MAP_SHARED and read-only, take care to not allow mprotect to
 		 * revert protections on such mappings. Do this only for shared
 		 * mappings. For private mappings, don't need to mask
--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -2215,7 +2215,7 @@ static int shmem_mmap(struct file *file,
 	struct shmem_inode_info *info = SHMEM_I(file_inode(file));
 	int ret;
 
-	ret = seal_check_future_write(info->seals, vma);
+	ret = seal_check_write(info->seals, vma);
 	if (ret)
 		return ret;
 


