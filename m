Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B2E82031C
	for <patches@lists.linux.dev>; Tue, 31 Oct 2023 17:03:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HoQ1CD86"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBF88C433C7;
	Tue, 31 Oct 2023 17:03:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698771800;
	bh=SQvd8uJV6bEhLME/aPVVaUibD8UyQsMHCPL1ba469v4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HoQ1CD86v4O8nulZRAgUbTgZBKKafTYX3OMYfR+NpoweleQXS3EctFNqakP4VbWrK
	 7Vs+T2z8bXmD5AB/fVMLMl/ZLNrGcgLXqLV/l9gt+W/s78TqHYtydep9ZDEkPjYNuL
	 QQ4BkIcl4xQQrSXL25wS0S8lJMcZa1///ugc3m6A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rik van Riel <riel@surriel.com>,
	Mike Kravetz <mike.kravetz@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.1 24/86] hugetlbfs: extend hugetlb_vma_lock to private VMAs
Date: Tue, 31 Oct 2023 18:00:49 +0100
Message-ID: <20231031165919.364477734@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231031165918.608547597@linuxfoundation.org>
References: <20231031165918.608547597@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rik van Riel <riel@surriel.com>

commit bf4916922c60f43efaa329744b3eef539aa6a2b2 upstream.

Extend the locking scheme used to protect shared hugetlb mappings from
truncate vs page fault races, in order to protect private hugetlb mappings
(with resv_map) against MADV_DONTNEED.

Add a read-write semaphore to the resv_map data structure, and use that
from the hugetlb_vma_(un)lock_* functions, in preparation for closing the
race between MADV_DONTNEED and page faults.

Link: https://lkml.kernel.org/r/20231006040020.3677377-3-riel@surriel.com
Fixes: 04ada095dcfc ("hugetlb: don't delete vma_lock in hugetlb MADV_DONTNEED processing")
Signed-off-by: Rik van Riel <riel@surriel.com>
Reviewed-by: Mike Kravetz <mike.kravetz@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/hugetlb.h |    6 ++++++
 mm/hugetlb.c            |   41 +++++++++++++++++++++++++++++++++++++----
 2 files changed, 43 insertions(+), 4 deletions(-)

--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -70,6 +70,7 @@ struct resv_map {
 	long adds_in_progress;
 	struct list_head region_cache;
 	long region_cache_count;
+	struct rw_semaphore rw_sema;
 #ifdef CONFIG_CGROUP_HUGETLB
 	/*
 	 * On private mappings, the counter to uncharge reservations is stored
@@ -879,6 +880,11 @@ static inline bool hugepage_migration_su
 	return arch_hugetlb_migration_supported(h);
 }
 
+static inline bool __vma_private_lock(struct vm_area_struct *vma)
+{
+	return (!(vma->vm_flags & VM_MAYSHARE)) && vma->vm_private_data;
+}
+
 /*
  * Movability check is different as compared to migration check.
  * It determines whether or not a huge page should be placed on
--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -96,6 +96,7 @@ static void hugetlb_vma_lock_alloc(struc
 static void __hugetlb_vma_unlock_write_free(struct vm_area_struct *vma);
 static void hugetlb_unshare_pmds(struct vm_area_struct *vma,
 		unsigned long start, unsigned long end);
+static struct resv_map *vma_resv_map(struct vm_area_struct *vma);
 
 static inline bool subpool_is_free(struct hugepage_subpool *spool)
 {
@@ -272,6 +273,10 @@ void hugetlb_vma_lock_read(struct vm_are
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		down_read(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		down_read(&resv_map->rw_sema);
 	}
 }
 
@@ -281,6 +286,10 @@ void hugetlb_vma_unlock_read(struct vm_a
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		up_read(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		up_read(&resv_map->rw_sema);
 	}
 }
 
@@ -290,6 +299,10 @@ void hugetlb_vma_lock_write(struct vm_ar
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		down_write(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		down_write(&resv_map->rw_sema);
 	}
 }
 
@@ -299,17 +312,27 @@ void hugetlb_vma_unlock_write(struct vm_
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		up_write(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		up_write(&resv_map->rw_sema);
 	}
 }
 
 int hugetlb_vma_trylock_write(struct vm_area_struct *vma)
 {
-	struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
-	if (!__vma_shareable_lock(vma))
-		return 1;
+	if (__vma_shareable_lock(vma)) {
+		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
-	return down_write_trylock(&vma_lock->rw_sema);
+		return down_write_trylock(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		return down_write_trylock(&resv_map->rw_sema);
+	}
+
+	return 1;
 }
 
 void hugetlb_vma_assert_locked(struct vm_area_struct *vma)
@@ -318,6 +341,10 @@ void hugetlb_vma_assert_locked(struct vm
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		lockdep_assert_held(&vma_lock->rw_sema);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		lockdep_assert_held(&resv_map->rw_sema);
 	}
 }
 
@@ -350,6 +377,11 @@ static void __hugetlb_vma_unlock_write_f
 		struct hugetlb_vma_lock *vma_lock = vma->vm_private_data;
 
 		__hugetlb_vma_unlock_write_put(vma_lock);
+	} else if (__vma_private_lock(vma)) {
+		struct resv_map *resv_map = vma_resv_map(vma);
+
+		/* no free for anon vmas, but still need to unlock */
+		up_write(&resv_map->rw_sema);
 	}
 }
 
@@ -1068,6 +1100,7 @@ struct resv_map *resv_map_alloc(void)
 	kref_init(&resv_map->refs);
 	spin_lock_init(&resv_map->lock);
 	INIT_LIST_HEAD(&resv_map->regions);
+	init_rwsem(&resv_map->rw_sema);
 
 	resv_map->adds_in_progress = 0;
 	/*


