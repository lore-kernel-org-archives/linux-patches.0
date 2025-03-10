Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A37D623099F;
	Mon, 10 Mar 2025 17:11:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741626688; cv=none; b=qtkIFG/AcVsRaDKebmryptsjNbyCZJ0ge9hQTYNEC1EZDnltVyy/UisjWNmNAM6V5F4GARFseYj7WebWd14/NBRnvlbWNeYeJqIfHEnZVkABjBnAVZ9fm2gnHeLetpvMujJO2QxS/V0fijYH/+xeZhnqmx6gM1VWbQZfXclPCk4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741626688; c=relaxed/simple;
	bh=NgzpUcnE6G6FikSCplf6fso0d9m//EUpaN2VHXnhrEo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d9EHVflE3N87MQGLcPB8ecD1CHONAvZrDsrylklWB+vxMa3kodduH+LGYxx+0nWZFcEzKdMG6ssNRTHpyDSRu0gnnQTENTioyALyt0XoeNOO6JhG3V8xnySdk1rk/k9BUY+0QKUoRjWniyoI5bX5CotNqNZfG6VTOl7evBol0I8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tdIQFKEl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tdIQFKEl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7790C4CEED;
	Mon, 10 Mar 2025 17:11:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741626688;
	bh=NgzpUcnE6G6FikSCplf6fso0d9m//EUpaN2VHXnhrEo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tdIQFKEl9Fd8cxJy2QmO6+3CvZW6/cgK7CTFX2BkP/M7N/o+uSiiPtPIYRtHmL9bO
	 I7sX8JCsHk/ghXFViI35cdwFMQNDRB7vbzW9Kw/nHLbBTR0dUlrzzLibzBBizPOKFf
	 AgMm6sdGb3WeIGjjtBLX5TBpn+ZsHpA9xF0ed9uE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Suren Baghdasaryan <surenb@google.com>,
	Lokesh Gidra <lokeshgidra@google.com>,
	Peter Xu <peterx@redhat.com>,
	"Liam R. Howlett" <Liam.Howlett@Oracle.com>,
	Andrea Arcangeli <aarcange@redhat.com>,
	Barry Song <21cnbao@gmail.com>,
	Barry Song <v-songbaohua@oppo.com>,
	David Hildenbrand <david@redhat.com>,
	Hugh Dickins <hughd@google.com>,
	Jann Horn <jannh@google.com>,
	Kalesh Singh <kaleshsingh@google.com>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	"Matthew Wilcow (Oracle)" <willy@infradead.org>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.13 071/207] userfaultfd: do not block on locking a large folio with raised refcount
Date: Mon, 10 Mar 2025 18:04:24 +0100
Message-ID: <20250310170450.586248018@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170447.729440535@linuxfoundation.org>
References: <20250310170447.729440535@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Suren Baghdasaryan <surenb@google.com>

commit 37b338eed10581784e854d4262da05c8d960c748 upstream.

Lokesh recently raised an issue about UFFDIO_MOVE getting into a deadlock
state when it goes into split_folio() with raised folio refcount.
split_folio() expects the reference count to be exactly mapcount +
num_pages_in_folio + 1 (see can_split_folio()) and fails with EAGAIN
otherwise.

If multiple processes are trying to move the same large folio, they raise
the refcount (all tasks succeed in that) then one of them succeeds in
locking the folio, while others will block in folio_lock() while keeping
the refcount raised.  The winner of this race will proceed with calling
split_folio() and will fail returning EAGAIN to the caller and unlocking
the folio.  The next competing process will get the folio locked and will
go through the same flow.  In the meantime the original winner will be
retried and will block in folio_lock(), getting into the queue of waiting
processes only to repeat the same path.  All this results in a livelock.

An easy fix would be to avoid waiting for the folio lock while holding
folio refcount, similar to madvise_free_huge_pmd() where folio lock is
acquired before raising the folio refcount.  Since we lock and take a
refcount of the folio while holding the PTE lock, changing the order of
these operations should not break anything.

Modify move_pages_pte() to try locking the folio first and if that fails
and the folio is large then return EAGAIN without touching the folio
refcount.  If the folio is single-page then split_folio() is not called,
so we don't have this issue.  Lokesh has a reproducer [1] and I verified
that this change fixes the issue.

[1] https://github.com/lokeshgidra/uffd_move_ioctl_deadlock

[akpm@linux-foundation.org: reflow comment to 80 cols, s/end/end up/]
Link: https://lkml.kernel.org/r/20250226185510.2732648-2-surenb@google.com
Fixes: adef440691ba ("userfaultfd: UFFDIO_MOVE uABI")
Signed-off-by: Suren Baghdasaryan <surenb@google.com>
Reported-by: Lokesh Gidra <lokeshgidra@google.com>
Reviewed-by: Peter Xu <peterx@redhat.com>
Acked-by: Liam R. Howlett <Liam.Howlett@Oracle.com>
Cc: Andrea Arcangeli <aarcange@redhat.com>
Cc: Barry Song <21cnbao@gmail.com>
Cc: Barry Song <v-songbaohua@oppo.com>
Cc: David Hildenbrand <david@redhat.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Jann Horn <jannh@google.com>
Cc: Kalesh Singh <kaleshsingh@google.com>
Cc: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Matthew Wilcow (Oracle) <willy@infradead.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/userfaultfd.c |   17 ++++++++++++++++-
 1 file changed, 16 insertions(+), 1 deletion(-)

--- a/mm/userfaultfd.c
+++ b/mm/userfaultfd.c
@@ -1224,6 +1224,7 @@ retry:
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			bool locked;
 
 			/*
 			 * Pin the page while holding the lock to be sure the
@@ -1243,12 +1244,26 @@ retry:
 				goto out;
 			}
 
+			locked = folio_trylock(folio);
+			/*
+			 * We avoid waiting for folio lock with a raised
+			 * refcount for large folios because extra refcounts
+			 * will result in split_folio() failing later and
+			 * retrying.  If multiple tasks are trying to move a
+			 * large folio we can end up livelocking.
+			 */
+			if (!locked && folio_test_large(folio)) {
+				spin_unlock(src_ptl);
+				err = -EAGAIN;
+				goto out;
+			}
+
 			folio_get(folio);
 			src_folio = folio;
 			src_folio_pte = orig_src_pte;
 			spin_unlock(src_ptl);
 
-			if (!folio_trylock(src_folio)) {
+			if (!locked) {
 				pte_unmap(&orig_src_pte);
 				pte_unmap(&orig_dst_pte);
 				src_pte = dst_pte = NULL;


