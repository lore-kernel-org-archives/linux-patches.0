Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00D5B28FFDE;
	Wed, 23 Apr 2025 15:10:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421013; cv=none; b=gz54btkvSPcj+Qfcf5Lkp5t/NkiW02DPwY65/345R4PJStPVaJQXArVq3U+fB5GhQw5PAbpkPVhj+n2yjMNadSPgiljFBbr1o8SJsBZm8oXyjOpdvYi/Vqpx7DWrsz4gDhE21ateAjRg4YDtH29kMx1xQoLigqHL6FcX7iL8Yno=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421013; c=relaxed/simple;
	bh=v8NPUE3eU5BKPHVbb11VDZFIa5qcaL2VnJTAu0vwqbc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=qDAAhBoa1U9oXTaelOIgD4ei4xLKSvubV19Eaj2YcAFxRzKLL5akidX2Rm8Vq6vXPvmLcYaEWLlDROs91yLxWf/6+wclQYodg/SJPk0tt1h6pbQqch4peijZ+TQBGbhIPvGXNN91KiouHpI0pEj3H9bBCNusf+sHLlohzyOcFWY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UTH0OLO6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UTH0OLO6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC34C4CEE3;
	Wed, 23 Apr 2025 15:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421012;
	bh=v8NPUE3eU5BKPHVbb11VDZFIa5qcaL2VnJTAu0vwqbc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UTH0OLO6udVj6w7l/ZYqON1SnOUVoa94Y4OFr9rCu9C/b1nehNJk8XVhNJhovQkH8
	 6zp2gmzaZFfavZUIovcLkw9Wv9/KIOlhy+WwbZN7JVGpn4KpSoYrlB4nynv+dl1G6W
	 ErHujNgvJQDAxgXZadrYUM1E83UQrxugUl8Nh7uQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Matthew Auld <matthew.auld@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@intel.com>,
	Matthew Brost <matthew.brost@intel.com>,
	=?UTF-8?q?Thomas=20Hellstr=C3=B6m?= <thomas.hellstrom@linux.intel.com>,
	Lucas De Marchi <lucas.demarchi@intel.com>
Subject: [PATCH 6.12 182/223] drm/xe/userptr: fix notifier vs folio deadlock
Date: Wed, 23 Apr 2025 16:44:14 +0200
Message-ID: <20250423142624.584259682@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matthew Auld <matthew.auld@intel.com>

commit 2577b202458cddff85cc154b1fe7f313e0d1f418 upstream.

User is reporting what smells like notifier vs folio deadlock, where
migrate_pages_batch() on core kernel side is holding folio lock(s) and
then interacting with the mappings of it, however those mappings are
tied to some userptr, which means calling into the notifier callback and
grabbing the notifier lock. With perfect timing it looks possible that
the pages we pulled from the hmm fault can get sniped by
migrate_pages_batch() at the same time that we are holding the notifier
lock to mark the pages as accessed/dirty, but at this point we also want
to grab the folio locks(s) to mark them as dirty, but if they are
contended from notifier/migrate_pages_batch side then we deadlock since
folio lock won't be dropped until we drop the notifier lock.

Fortunately the mark_page_accessed/dirty is not really needed in the
first place it seems and should have already been done by hmm fault, so
just remove it.

Link: https://gitlab.freedesktop.org/drm/xe/kernel/-/issues/4765
Fixes: 0a98219bcc96 ("drm/xe/hmm: Don't dereference struct page pointers without notifier lock")
Signed-off-by: Matthew Auld <matthew.auld@intel.com>
Cc: Thomas Hellström <thomas.hellstrom@intel.com>
Cc: Matthew Brost <matthew.brost@intel.com>
Cc: <stable@vger.kernel.org> # v6.10+
Reviewed-by: Thomas Hellström <thomas.hellstrom@linux.intel.com>
Reviewed-by: Matthew Brost <matthew.brost@intel.com>
Link: https://lore.kernel.org/r/20250414132539.26654-2-matthew.auld@intel.com
(cherry picked from commit bd7c0cb695e87c0e43247be8196b4919edbe0e85)
Signed-off-by: Lucas De Marchi <lucas.demarchi@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/xe/xe_hmm.c |   24 ------------------------
 1 file changed, 24 deletions(-)

--- a/drivers/gpu/drm/xe/xe_hmm.c
+++ b/drivers/gpu/drm/xe/xe_hmm.c
@@ -19,29 +19,6 @@ static u64 xe_npages_in_range(unsigned l
 	return (end - start) >> PAGE_SHIFT;
 }
 
-/**
- * xe_mark_range_accessed() - mark a range is accessed, so core mm
- * have such information for memory eviction or write back to
- * hard disk
- * @range: the range to mark
- * @write: if write to this range, we mark pages in this range
- * as dirty
- */
-static void xe_mark_range_accessed(struct hmm_range *range, bool write)
-{
-	struct page *page;
-	u64 i, npages;
-
-	npages = xe_npages_in_range(range->start, range->end);
-	for (i = 0; i < npages; i++) {
-		page = hmm_pfn_to_page(range->hmm_pfns[i]);
-		if (write)
-			set_page_dirty_lock(page);
-
-		mark_page_accessed(page);
-	}
-}
-
 static int xe_alloc_sg(struct xe_device *xe, struct sg_table *st,
 		       struct hmm_range *range, struct rw_semaphore *notifier_sem)
 {
@@ -331,7 +308,6 @@ int xe_hmm_userptr_populate_range(struct
 	if (ret)
 		goto out_unlock;
 
-	xe_mark_range_accessed(&hmm_range, write);
 	userptr->sg = &userptr->sgt;
 	xe_hmm_userptr_set_mapped(uvma);
 	userptr->notifier_seq = hmm_range.notifier_seq;


