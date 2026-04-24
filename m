Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2F4093D5236;
	Fri, 24 Apr 2026 13:43:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1777038205; cv=none; b=nzQzR3epr9wuEwsPKqeeXD6Q8psmngtLKpGG81D3yLKRj80hMY36aA173wn+53zqSjizrDDK2TAtRe7aB2q/1/4UrSQpQk4R7tyiiSXsif3lgqIG736MmTpw5nPTtqjn0kGulm3qTPEPeyQ9tq6IhqoHhCGYEKJBo6RJYekOOz0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1777038205; c=relaxed/simple;
	bh=JqWf3n5DOkjUppmwa6nB5QjUHYWR1c6cInaOfcLnG1A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u5e0hTuts5batsEe/sMBGdHTYmGCBYb6NqaZzinMD+iLoieCo4zr5N3N1vaapxzOsSEN7gZz+orAiFX+eKoYtGm+sb/3WvUnPiGpARrDvOaB9NDJp9IRD7ajlhv8CEmdmV8Z4dG+b5NjRtAefvCuaLNdoI/KiXORW9VtbK0jFi4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tXxwMkF6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tXxwMkF6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92080C19425;
	Fri, 24 Apr 2026 13:43:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1777038205;
	bh=JqWf3n5DOkjUppmwa6nB5QjUHYWR1c6cInaOfcLnG1A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tXxwMkF6tEgtPdi4xIA7jcM0IOe/aZpQVp3/SUi6P4pZl8Ep6rCH+ojK9gWK/eDco
	 jD1dFhWeAlaIMzt3qTytuU+l6+/99lhydsQxuiCsnNhe6ihSBGcwpbEn+6x/8AvV65
	 ESYLRbf3K5lSCqWYMbQ8tS2lcH+ppC6lBAg5j/Y0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianhui Zhou <jianhuizzzzz@gmail.com>,
	syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com,
	SeongJae Park <sj@kernel.org>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Jane Chu <jane.chu@oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	JonasZhou <JonasZhou@zhaoxin.com>,
	Muchun Song <muchun.song@linux.dev>,
	Oscar Salvador <osalvador@suse.de>,
	Peter Xu <peterx@redhat.com>,
	Sidhartha Kumar <sidhartha.kumar@oracle.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 01/35] mm/userfaultfd: fix hugetlb fault mutex hash calculation
Date: Fri, 24 Apr 2026 15:31:08 +0200
Message-ID: <20260424132411.766378415@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260424132411.427029259@linuxfoundation.org>
References: <20260424132411.427029259@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianhui Zhou <jianhuizzzzz@gmail.com>

[ Upstream commit 0217c7fb4de4a40cee667eb21901f3204effe5ac ]

In mfill_atomic_hugetlb(), linear_page_index() is used to calculate the
page index for hugetlb_fault_mutex_hash().  However, linear_page_index()
returns the index in PAGE_SIZE units, while hugetlb_fault_mutex_hash()
expects the index in huge page units.  This mismatch means that different
addresses within the same huge page can produce different hash values,
leading to the use of different mutexes for the same huge page.  This can
cause races between faulting threads, which can corrupt the reservation
map and trigger the BUG_ON in resv_map_release().

Fix this by introducing hugetlb_linear_page_index(), which returns the
page index in huge page granularity, and using it in place of
linear_page_index().

Link: https://lkml.kernel.org/r/20260310110526.335749-1-jianhuizzzzz@gmail.com
Fixes: a08c7193e4f1 ("mm/filemap: remove hugetlb special casing in filemap.c")
Signed-off-by: Jianhui Zhou <jianhuizzzzz@gmail.com>
Reported-by: syzbot+f525fd79634858f478e7@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=f525fd79634858f478e7
Acked-by: SeongJae Park <sj@kernel.org>
Reviewed-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Jane Chu <jane.chu@oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: JonasZhou <JonasZhou@zhaoxin.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Peter Xu <peterx@redhat.com>
Cc: SeongJae Park <sj@kernel.org>
Cc: Sidhartha Kumar <sidhartha.kumar@oracle.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
[ placed new `hugetlb_linear_page_index()` before `hstate_is_gigantic()` ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/hugetlb.h | 17 +++++++++++++++++
 mm/userfaultfd.c        |  2 +-
 2 files changed, 18 insertions(+), 1 deletion(-)

diff --git a/include/linux/hugetlb.h b/include/linux/hugetlb.h
index 81b69287ab3b0..32c9bc8c750c5 100644
--- a/include/linux/hugetlb.h
+++ b/include/linux/hugetlb.h
@@ -783,6 +783,23 @@ static inline unsigned huge_page_shift(struct hstate *h)
 	return h->order + PAGE_SHIFT;
 }
 
+/**
+ * hugetlb_linear_page_index() - linear_page_index() but in hugetlb
+ *				 page size granularity.
+ * @vma: the hugetlb VMA
+ * @address: the virtual address within the VMA
+ *
+ * Return: the page offset within the mapping in huge page units.
+ */
+static inline pgoff_t hugetlb_linear_page_index(struct vm_area_struct *vma,
+		unsigned long address)
+{
+	struct hstate *h = hstate_vma(vma);
+
+	return ((address - vma->vm_start) >> huge_page_shift(h)) +
+		(vma->vm_pgoff >> huge_page_order(h));
+}
+
 static inline bool hstate_is_gigantic(struct hstate *h)
 {
 	return huge_page_order(h) > MAX_PAGE_ORDER;
diff --git a/mm/userfaultfd.c b/mm/userfaultfd.c
index 904095f69a6e3..9951b4f42c65a 100644
--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -573,7 +573,7 @@ static __always_inline ssize_t mfill_atomic_hugetlb(
 		 * in the case of shared pmds.  fault mutex prevents
 		 * races with other faulting threads.
 		 */
-		idx = linear_page_index(dst_vma, dst_addr);
+		idx = hugetlb_linear_page_index(dst_vma, dst_addr);
 		mapping = dst_vma->vm_file->f_mapping;
 		hash = hugetlb_fault_mutex_hash(mapping, idx);
 		mutex_lock(&hugetlb_fault_mutex_table[hash]);
-- 
2.53.0



