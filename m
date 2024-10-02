Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FD251D0793;
	Wed,  2 Oct 2024 13:52:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1727877177; cv=none; b=E940WE+jJrqFPTLbFuB2MNlLW+dT2FJhDGE1ink2WBWT72qzj5cnU7FeNfoPQq5lsMxLZyBh8mAgVl9IfQt1MYJ2Ts1XcwVvJy9WYYf3CunGfjoDjL3bO8t6cbVsbDwabpq1yymOw9qBkVddOE5L7I9PbzPg8B4JWvj/6kxwIUQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1727877177; c=relaxed/simple;
	bh=/x+qNTvSclFh6rk6LisAAsoWdvrsJG5CUiyX5ZlmssQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dei8wkv2+xxe4+yWWULSWZE9Y9sso/1U+okK4UoUnj2P2/ukYS99Cz9UXJ45frt+8c5avLaRia2zRFettBbJphFGTxSXjbw3Tq7uj8NTSV0yrCYEinE2zw3MjBVTh9O0pBqmSa+gzDF1h4LtJAH+AtiGq4fnkcuLJ6OY0q8UqrY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xzFo9cD3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xzFo9cD3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DE56AC4CEC5;
	Wed,  2 Oct 2024 13:52:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1727877177;
	bh=/x+qNTvSclFh6rk6LisAAsoWdvrsJG5CUiyX5ZlmssQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xzFo9cD3+i5NkcZ4+5ok91wL3LzxZYVXU3WTVmqX6NQDgiZTREy6ciXCKy9pIbG0s
	 pUEMJvWXDijEFchUnA1itj5OPtY1JKN5k/gcKe9VoQcxatTRsDrJ9GF8W4rqmVrues
	 jHzob+fsbZhgdrId3L5/92GO1DVzTFxh3OB+fEBg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com,
	"Vishal Moola (Oracle)" <vishal.moola@gmail.com>,
	Muchun Song <muchun.song@linux.dev>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.11 689/695] mm: change vmf_anon_prepare() to __vmf_anon_prepare()
Date: Wed,  2 Oct 2024 15:01:27 +0200
Message-ID: <20241002125850.021854420@linuxfoundation.org>
X-Mailer: git-send-email 2.46.2
In-Reply-To: <20241002125822.467776898@linuxfoundation.org>
References: <20241002125822.467776898@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vishal Moola (Oracle) <vishal.moola@gmail.com>

commit 2a058ab3286d6475b2082b90c2d2182d2fea4b39 upstream.

Some callers of vmf_anon_prepare() may not want us to release the per-VMA
lock ourselves.  Rename vmf_anon_prepare() to __vmf_anon_prepare() and let
the callers drop the lock when desired.

Also, make vmf_anon_prepare() a wrapper that releases the per-VMA lock
itself for any callers that don't care.

This is in preparation to fix this bug reported by syzbot:
https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/

Link: https://lkml.kernel.org/r/20240914194243.245-1-vishal.moola@gmail.com
Fixes: 9acad7ba3e25 ("hugetlb: use vmf_anon_prepare() instead of anon_vma_prepare()")
Reported-by: syzbot+2dab93857ee95f2eeb08@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/linux-mm/00000000000067c20b06219fbc26@google.com/
Signed-off-by: Vishal Moola (Oracle) <vishal.moola@gmail.com>
Cc: Muchun Song <muchun.song@linux.dev>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/internal.h |   11 ++++++++++-
 mm/memory.c   |    8 +++-----
 2 files changed, 13 insertions(+), 6 deletions(-)

--- a/mm/internal.h
+++ b/mm/internal.h
@@ -310,7 +310,16 @@ static inline void wake_throttle_isolate
 		wake_up(wqh);
 }
 
-vm_fault_t vmf_anon_prepare(struct vm_fault *vmf);
+vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf);
+static inline vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+{
+	vm_fault_t ret = __vmf_anon_prepare(vmf);
+
+	if (unlikely(ret & VM_FAULT_RETRY))
+		vma_end_read(vmf->vma);
+	return ret;
+}
+
 vm_fault_t do_swap_page(struct vm_fault *vmf);
 void folio_rotate_reclaimable(struct folio *folio);
 bool __folio_end_writeback(struct folio *folio);
--- a/mm/memory.c
+++ b/mm/memory.c
@@ -3276,7 +3276,7 @@ static inline vm_fault_t vmf_can_call_fa
 }
 
 /**
- * vmf_anon_prepare - Prepare to handle an anonymous fault.
+ * __vmf_anon_prepare - Prepare to handle an anonymous fault.
  * @vmf: The vm_fault descriptor passed from the fault handler.
  *
  * When preparing to insert an anonymous page into a VMA from a
@@ -3290,7 +3290,7 @@ static inline vm_fault_t vmf_can_call_fa
  * Return: 0 if fault handling can proceed.  Any other value should be
  * returned to the caller.
  */
-vm_fault_t vmf_anon_prepare(struct vm_fault *vmf)
+vm_fault_t __vmf_anon_prepare(struct vm_fault *vmf)
 {
 	struct vm_area_struct *vma = vmf->vma;
 	vm_fault_t ret = 0;
@@ -3298,10 +3298,8 @@ vm_fault_t vmf_anon_prepare(struct vm_fa
 	if (likely(vma->anon_vma))
 		return 0;
 	if (vmf->flags & FAULT_FLAG_VMA_LOCK) {
-		if (!mmap_read_trylock(vma->vm_mm)) {
-			vma_end_read(vma);
+		if (!mmap_read_trylock(vma->vm_mm))
 			return VM_FAULT_RETRY;
-		}
 	}
 	if (__anon_vma_prepare(vma))
 		ret = VM_FAULT_OOM;


