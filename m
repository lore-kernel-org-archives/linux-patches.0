Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E60FB1420C9;
	Tue, 27 Feb 2024 14:22:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1709043733; cv=none; b=S9zLnoHEOAwQHKvRy2LllY/5gkcF56b/lnC5wFZmDNzVBl/aR5Jo9E2JrqqdEqi4zC3EnLzRBPasMO17PR61gppVHDCymh2+qGs4x9Y8rmSWMSPdo3X9bA/P1+Vm0GtmMAPKGOrzY7ehl5xHsTh7LZO5fX30FEChrKJFeKndFHU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1709043733; c=relaxed/simple;
	bh=bLKLefOrwXLoiuYQAO48K7CLs/cwGYhYZHX0aZuy3Yk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IBnC9Vf3fyJd6TE8LPHWKdtFFSLM33BkkIxtrv0I4nLZLYZeJpqUKVznSvNju8YRsPu1jdnCZqgTw6Z7NnenRk5Jn3Etr4MSvnxXhjtKGkKKsygtbTxy3HsTMGUWBYmp4Yz7aIlXNrtimpF2gltzWtceMYhXgb8i2rLbrHVy6uY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AqHF/vqr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AqHF/vqr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E5A77C433C7;
	Tue, 27 Feb 2024 14:22:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1709043732;
	bh=bLKLefOrwXLoiuYQAO48K7CLs/cwGYhYZHX0aZuy3Yk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AqHF/vqretN/d7gdtNY/hRoHEEefGgAbVYeZpQx71xIgLolK3f+61olLLLTCFCjuT
	 AVwhMfRdqlQ6ddy+RpEwvXwB/uhlYb3mYwRPXBJjjaAxUmX+EDBVM3nMnUqiZG2vde
	 Wjazx+lrm0d7EkqtcEQYe4J0qemBl92yvfsP0WPE=
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
Subject: [PATCH 5.4 09/84] userfaultfd: fix mmap_changing checking in mfill_atomic_hugetlb
Date: Tue, 27 Feb 2024 14:26:36 +0100
Message-ID: <20240227131553.174485142@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240227131552.864701583@linuxfoundation.org>
References: <20240227131552.864701583@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Mike Rapoport (IBM) <rppt@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -177,6 +177,7 @@ static __always_inline ssize_t __mcopy_a
 					      unsigned long dst_start,
 					      unsigned long src_start,
 					      unsigned long len,
+					      bool *mmap_changing,
 					      bool zeropage)
 {
 	int vm_alloc_shared = dst_vma->vm_flags & VM_SHARED;
@@ -308,6 +309,15 @@ retry:
 				goto out;
 			}
 			down_read(&dst_mm->mmap_sem);
+			/*
+			 * If memory mappings are changing because of non-cooperative
+			 * operation (e.g. mremap) running in parallel, bail out and
+			 * request the user to retry later
+			 */
+			if (mmap_changing && READ_ONCE(*mmap_changing)) {
+				err = -EAGAIN;
+				break;
+			}
 
 			dst_vma = NULL;
 			goto retry;
@@ -389,6 +399,7 @@ extern ssize_t __mcopy_atomic_hugetlb(st
 				      unsigned long dst_start,
 				      unsigned long src_start,
 				      unsigned long len,
+				      bool *mmap_changing,
 				      bool zeropage);
 #endif /* CONFIG_HUGETLB_PAGE */
 
@@ -506,7 +517,8 @@ retry:
 	 */
 	if (is_vm_hugetlb_page(dst_vma))
 		return  __mcopy_atomic_hugetlb(dst_mm, dst_vma, dst_start,
-						src_start, len, zeropage);
+					       src_start, len, mmap_changing,
+					       zeropage);
 
 	if (!vma_is_anonymous(dst_vma) && !vma_is_shmem(dst_vma))
 		goto out_unlock;


