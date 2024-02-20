Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9A7A133987;
	Tue, 20 Feb 2024 21:12:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708463564; cv=none; b=OcLYVhhZWRX0ZZZxcKf/3cT7EaEZkYq0ZBKgqvx/2lnyp6Q8nE4D9l7RpagaTg8FkYO/cAaaqXk3i8I2GWMZ0hfBXaQu2BjP1KzAWHqNeDcAeBn7nQMomS02ZyuLU6aYeRfUPs6hIKooMLbOqmM7soQA2Y7CK/sAGTpymhaBuZ4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708463564; c=relaxed/simple;
	bh=kjoHjK0USZu0tNWEtYkwKe0JMoTWQE2vKsgcaQUfRrI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bI/5Bmgu/40iqvDdLPlYGe/nxdzh78dtOml8Slh48T/NyRuIdYUdOwTCI9xxjmJTvlsTq6htngot1iGCUZRf1LILaFgHOAfrnjncC3M+d73mZOD44fjbqWbBbCh0y0uXHx4OvFiTjH7nqaMfMT6AxgVQaHXw+poofgp+AY5Wops=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Hv9DoSr7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Hv9DoSr7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D8CA2C433C7;
	Tue, 20 Feb 2024 21:12:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708463564;
	bh=kjoHjK0USZu0tNWEtYkwKe0JMoTWQE2vKsgcaQUfRrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hv9DoSr7SZD9W01DKW46pPyY/KmrK3G4bw4I9skcnfykFDe2av+y5s4PKDTo9G25T
	 J2Kqk4wdqODYKhlEl3+Uv4QlPaGqFX818IDDt3O3XQa4QfRCsa6bvwGzujuwmQy/Hj
	 ZWzykOvWS774GiK+bwTGwUzrIbOpXQlvY4NtUPTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lokesh Gidra <lokeshgidra@google.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Mike Rapoport <rppt@kernel.org>,
	Axel Rasmussen <axelrasmussen@google.com>,
	Brian Geffon <bgeffon@google.com>,
	David Hildenbrand <david@redhat.com>,
	Jann Horn <jannh@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nicolas Geoffray <ngeoffray@google.com>,
	Peter Xu <peterx@redhat.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.6 055/331] userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
Date: Tue, 20 Feb 2024 21:52:51 +0100
Message-ID: <20240220205639.316922458@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205637.572693592@linuxfoundation.org>
References: <20240220205637.572693592@linuxfoundation.org>
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

From: Lokesh Gidra <lokeshgidra@google.com>

commit 67695f18d55924b2013534ef3bdc363bc9e14605 upstream.

In mfill_atomic_hugetlb(), mmap_changing isn't being checked
again if we drop mmap_lock and reacquire it. When the lock is not held,
mmap_changing could have been incremented. This is also inconsistent
with the behavior in mfill_atomic().

Link: https://lkml.kernel.org/r/20240117223729.1444522-1-lokeshgidra@google.com
Fixes: df2cc96e77011 ("userfaultfd: prevent non-cooperative events vs mcopy_atomic races")
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Axel Rasmussen <axelrasmussen@google.com>
Cc: Brian Geffon <bgeffon@google.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   15 +++++++++++++--
 1 file changed, 13 insertions(+), 2 deletions(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -357,6 +357,7 @@ static __always_inline ssize_t mfill_ato
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
+					      atomic_t *mmap_changing,
 					      uffd_flags_t flags)
 {
 	struct mm_struct *dst_mm = dst_vma->vm_mm;
@@ -472,6 +473,15 @@ retry:
 				goto out;
 			}
 			mmap_read_lock(dst_mm);
+			/*
+			 * If memory mappings are changing because of non-cooperative
+			 * operation (e.g. mremap) running in parallel, bail out and
+			 * request the user to retry later
+			 */
+			if (mmap_changing && atomic_read(mmap_changing)) {
+				err = -EAGAIN;
+				break;
+			}
 
 			dst_vma = NULL;
 			goto retry;
@@ -506,6 +516,7 @@ extern ssize_t mfill_atomic_hugetlb(stru
 				    unsigned long dst_start,
 				    unsigned long src_start,
 				    unsigned long len,
+				    atomic_t *mmap_changing,
 				    uffd_flags_t flags);
 #endif /* CONFIG_HUGETLB_PAGE */
 
@@ -622,8 +633,8 @@ retry:
 	 * If this is a HUGETLB vma, pass off to appropriate routine
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
-		return  mfill_atomic_hugetlb(dst_vma, dst_start,
-					     src_start, len, flags);
+		return  mfill_atomic_hugetlb(dst_vma, dst_start, src_start,
+					     len, mmap_changing, flags);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;


