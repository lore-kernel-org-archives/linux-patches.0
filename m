Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14A481448F1;
	Tue, 23 Apr 2024 21:41:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908491; cv=none; b=MCw1ZXvd/tdbrvILV2HfZ+A9Az8f+PQIcQXjtyqEjQL39gmG0VbPvC0V7WVBFLhHobzIDBTS/zqJXQSWVZLV4QMts5gHfRCIhgNX5hRnXneVt/K59zkXVe+vVJNl8S9X0kASKyBZY5KM1UOJYiDQKoy3o1NWXPNoOYF7la68Vn8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908491; c=relaxed/simple;
	bh=82a8pXAkIzByzUtzYOQ7vGVgDBRNhiGXE0YoIkdQBnA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NnoKExi+ZhIiFH+9I1GbdHLm1KeHsP4XJ7YKcAoYu/ptfBoiF9c7pFW7TpoIW0ZFKt3zWhjnSwVvhD4ZMbtWtLjuPfTjwDRcNvoG5DZOcHZ27iuaoUnpbGfgjOl09iHh56vOe8MKARqMjNlL1+QoQt7kypIzvPOR3xm3+N3mL2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XYMOvFoh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XYMOvFoh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D5FA2C3277B;
	Tue, 23 Apr 2024 21:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908491;
	bh=82a8pXAkIzByzUtzYOQ7vGVgDBRNhiGXE0YoIkdQBnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XYMOvFoh41oNAJ5a+OBNUuOwQ7EhZHUpZOZmJE1M78Tbr4jUu0vreF3vKbZqwCNbC
	 XfVxJy5KCZDmhacE1h2lIrBcaNan3OtWGufZHGJvjByMgvenmH15ON7BHYem6VcRBa
	 Xm9REgvmQaBph9wizEkq7YkFYcyxgs76TNeJDAns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lokesh Gidra <lokeshgidra@google.com>,
	David Hildenbrand <david@redhat.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Nicolas Geoffray <ngeoffray@google.com>,
	Peter Xu <peterx@redhat.com>,
	Qi Zheng <zhengqi.arch@bytedance.com>,
	Matthew Wilcox <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.8 066/158] userfaultfd: change src_folio after ensuring its unpinned in UFFDIO_MOVE
Date: Tue, 23 Apr 2024 14:38:08 -0700
Message-ID: <20240423213858.104342461@linuxfoundation.org>
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

From: Lokesh Gidra <lokeshgidra@google.com>

commit c0205eaf3af9f5db14d4b5ee4abacf4a583c3c50 upstream.

Commit d7a08838ab74 ("mm: userfaultfd: fix unexpected change to src_folio
when UFFDIO_MOVE fails") moved the src_folio->{mapping, index} changing to
after clearing the page-table and ensuring that it's not pinned.  This
avoids failure of swapout+migration and possibly memory corruption.

However, the commit missed fixing it in the huge-page case.

Link: https://lkml.kernel.org/r/20240404171726.2302435-1-lokeshgidra@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Acked-by: David Hildenbrand <david@redhat.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lokesh Gidra <lokeshgidra@google.com>
Cc: Nicolas Geoffray <ngeoffray@google.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Qi Zheng <zhengqi.arch@bytedance.com>
Cc: Matthew Wilcox <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Lokesh Gidra <lokeshgidra@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/huge_memory.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/mm/huge_memory.c
+++ b/mm/huge_memory.c
@@ -2244,9 +2244,6 @@ int move_pages_huge_pmd(struct mm_struct
 		goto unlock_ptls;
 	}
 
-	folio_move_anon_rmap(src_folio, dst_vma);
-	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
-
 	src_pmdval = pmdp_huge_clear_flush(src_vma, src_addr, src_pmd);
 	/* Folio got pinned from under us. Put it back and fail the move. */
 	if (folio_maybe_dma_pinned(src_folio)) {
@@ -2255,6 +2252,9 @@ int move_pages_huge_pmd(struct mm_struct
 		goto unlock_ptls;
 	}
 
+	folio_move_anon_rmap(src_folio, dst_vma);
+	WRITE_ONCE(src_folio->index, linear_page_index(dst_vma, dst_addr));
+
 	_dst_pmd = mk_huge_pmd(&src_folio->page, dst_vma->vm_page_prot);
 	/* Follow mremap() behavior and treat the entry dirty after the move */
 	_dst_pmd = pmd_mkwrite(pmd_mkdirty(_dst_pmd), dst_vma);


