Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 901E5233703;
	Mon, 10 Mar 2025 17:24:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627449; cv=none; b=Ad+W8j3L0tni29CQuW/gifR0i0gsC8QV24QL6RoM2d/1YuvpRASVEfvF2DHeaDkRbrgeno1w2Z/m+cTR+eX6ILbB6BVS7XRvugNCOaoyIkfnT7IDoWs1EF3P6qjk3Btr/ANIlYYA5TUvj0pYmkBfR/iaVkivxIJ2b6cOhfo45IY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627449; c=relaxed/simple;
	bh=TE+B16w/JHhzVa2u4j2BAkL954vKgTZYLdBgvza3r18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PTiiO0UDqx3IDa7DXQ7xyBWHFHCPmgMmR503OoTxA9DqOCMcMjLLEMY8m1KYDxbGAG+Rmccy23tvgMDFH6q8Nzr87xWGoFlkRo6Ncp9bAc7ttzltGXdMlzGSpUz+pBqS0L79SAo2E4W7nj1SRPFs2jg+8XlQbpsfa5qrhtaHs2E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=aT+1vjH9; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="aT+1vjH9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011C1C4CEF0;
	Mon, 10 Mar 2025 17:24:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627449;
	bh=TE+B16w/JHhzVa2u4j2BAkL954vKgTZYLdBgvza3r18=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=aT+1vjH95oBUGul9Gp5pY/pCYL2aRK9DrbQfRLXHQRhbJRO39egPdCd3EKvJ18OnO
	 DOO5O+Ev0GLrCZPzNtHGbYidPMkJIwZtQurjIF94YobbguHszGxuNJGh6at2xYcHT9
	 Xoq1feHuPN0rV++QR/TWeJKaRGzm/LZOP53jRcBU=
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
Subject: [PATCH 6.12 132/269] userfaultfd: do not block on locking a large folio with raised refcount
Date: Mon, 10 Mar 2025 18:04:45 +0100
Message-ID: <20250310170502.985226760@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1215,6 +1215,7 @@ retry:
 		 */
 		if (!src_folio) {
 			struct folio *folio;
+			bool locked;
 
 			/*
 			 * Pin the page while holding the lock to be sure the
@@ -1234,12 +1235,26 @@ retry:
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


