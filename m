Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054610;
	b=EidGY5mb9o7CnUwvxrslkWXk5Eisjllt1vAnExYlyDjYFBhl4gzs1ImvCxeBwGO6uSeI
	 STdqZAhdLS30ymLNmJzDRn7v6B6l6vbpixjoTs6BvW0lyHExGvXO8GDcBytfX3ktZ5YF+
	 A2XrfzjrnAKcfsonyRUs5rTAqTl1Fc76G9YVXwtai2cDo3Bwrd75Mz6IA1hBieyJ3BgXs
	 nO/3cK/ha8K89y18p3T606HVbQA5D4xEXIT6qSLqw6xFJcwj5BBfRyyJLjctMBmHGu914
	 SD3Wsy2YXaT+7q+mWIy4VkzDbRIJxjNfWp9h/EWaJcYd9Op2vPFimWDb/z7cj3PHPnQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054610;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=+cckoNewQhIHW1SYaOMSAS1dfa0PKBsidcdELdDpu/g=;
	b=oQYNdvEF3iRnMKxRtW5p0NCVAWFvksOsBjxAr6/uuPtqyfd5Bq7Vr5My2dJQ4gBnh0eN
	 VthwePkakcOdwc3MoDIEIuacRMi/gx3BQhO0M4Vejo31sAVRLCFlfFOiPrTCbkLJc08sZ
	 a/9ppVXfs9nMFLSxK7nK4JqpQw2LPRmF290z/fhQE0/tRTtKGaZNt/Zl4MCVu1hWINcwQ
	 hu3KxPhePw/1his3n65gpL//mMvzR8e/J+ns+LUzISYe7b7jzGMnHMWKN79bTGyr+9qZG
	 +SRdbgEyRpDXY57602vBT0+B/ymTXzLc579Gs0y/Agwy3nQbMUNChbkxO+HrqTx3RZQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnvCfHM0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D289E606A339;
	Thu, 19 Nov 2026 02:16:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HnvCfHM0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E39B1F000C5;
	Thu, 19 Nov 2026 02:16:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054610;
	bh=+cckoNewQhIHW1SYaOMSAS1dfa0PKBsidcdELdDpu/g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HnvCfHM0QNJGk/+hl9+l8x9UKhlTOnJ0VskPkr3y6xC6zCxlh97lFMJ6sSbvoqiHi
	 4b69Px242fkqCPlAqdir40LKKSiTublV7ugNyWH/rU/L2ZDeOxs2uP4//7O0vt4IsY
	 B+uWr8SzxPia+BCd/fbKJ6oSmeXycyPs6T2J2xs8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1296/2214] mm/filemap: finish fault cleanup before dropping the fault lock
Date: Wed, 18 Nov 2026 15:49:32 +0100
Message-ID: <20261118150103.379633188@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 97156a6c355c21f7122421915f05461bd11699a4 ]

On a retried fault, a fatal signal interrupting the folio lock wait
makes lock_folio_maybe_drop_mmap() drop the fault lock without pinning
the file. However, filemap_fault() may still need to release
mapping->invalidate_lock. A concurrent munmap() can release the last
file reference and free the mapping before that unlock.

Defer dropping the fault lock to filemap_fault()'s retry cleanup, after
releasing invalidate_lock. If the fault lock was already dropped for
I/O, release the existing file reference instead. Keep the fault lock
held for FAULT_FLAG_RETRY_NOWAIT as before.

Fixes: 730633f0b7f9 ("mm: Protect operations adding pages to page cache with invalidate_lock")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Thadeu Lima de Souza Cascardo <cascardo@igalia.com>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-8-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: adapted folio-based fault handling to page-based APIs using mmap_read_unlock() instead of release_fault_lock() ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index eccc5318b6644..b0d046f0d3b27 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -2911,10 +2911,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
  * @page - the page to lock.
  * @fpin - the pointer to the file we may pin (or is already pinned).
  *
- * This works similar to lock_page_or_retry in that it can drop the mmap_lock.
- * It differs in that it actually returns the page locked if it returns 1 and 0
- * if it couldn't lock the page.  If we did have to drop the mmap_lock then fpin
- * will point to the pinned file and needs to be fput()'ed at a later point.
+ * Returns 1 with the page locked, or 0 if locking failed.
+ *
+ * On both entry and return, a non-NULL *fpin means the fault lock has
+ * already been dropped and the caller must eventually fput() the file.
+ * Otherwise the fault lock is still held, including on failure.
  */
 static int lock_page_maybe_drop_mmap(struct vm_fault *vmf, struct page *page,
 				     struct file **fpin)
@@ -2931,20 +2932,10 @@ static int lock_page_maybe_drop_mmap(struct vm_fault *vmf, struct page *page,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__lock_page_killable(page)) {
-			/*
-			 * We didn't have the right flags to drop the mmap_lock,
-			 * but all fault_handlers only check for fatal signals
-			 * if we return VM_FAULT_RETRY, so we need to drop the
-			 * mmap_lock here and return 0 if we don't have a fpin.
-			 */
-			if (*fpin == NULL)
-				mmap_read_unlock(vmf->vma->vm_mm);
-			return 0;
-		}
-	} else
-		__lock_page(page);
+	if (vmf->flags & FAULT_FLAG_KILLABLE)
+		return !__lock_page_killable(page);
+	__lock_page(page);
+
 	return 1;
 }
 
@@ -3044,7 +3035,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
  * vma->vm_mm->mmap_lock must be held on entry.
  *
  * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_page_maybe_drop_mmap().
+ * may be dropped before doing I/O or when aborting an interrupted wait.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3188,9 +3179,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 
 out_retry:
 	/*
-	 * We dropped the mmap_lock, we need to return to the fault handler to
-	 * re-find the vma and come back and find our hopefully still populated
-	 * page.
+	 * With fpin set, the fault lock was already dropped. Otherwise it is
+	 * still held. Release invalidate_lock before dropping either protection.
 	 */
 	if (page)
 		put_page(page);
@@ -3198,6 +3188,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
+	else if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+		mmap_read_unlock(vmf->vma->vm_mm);
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);
-- 
2.53.0



