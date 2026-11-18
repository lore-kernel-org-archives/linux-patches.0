Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047625;
	b=hPItxIQdBTGFaE8oC/nVZY9KSGUzCYsZ0zXjo2TJCGsz9hokiQuFg/BB5OAZMaD3BGtI
	 gws63eVFMD/x3lwoHPYqfU2ciNkdfuJLOKjQrCaMro5blfAR7LlSloZH/piFATUNz2R8X
	 Swxayrau/mIjw5xVmrig1JDNrLc2jsrFNSuV2E1sGBnx35gPscUzC+Vnq1CjKFzkf5Vqg
	 YJmNlnHOMlAL8LDNbXjqkzkIvio7ESUTJtC75uaPB5SbPWdByXa0dmLn24zYWGNUyquyp
	 zZkJ/FdVlOiT2xmt71izwVxDkVsfNqNvI3onAnnbcjWLcLia5nMqABgkykMDOlvbJrw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047625;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=tpqkz/y9h2dupSahLde0iT07rNs9eJJvU8JScVf5p/s=;
	b=UfNxuBtsSk5W5P4gDh6kPgltpV0Y2ER5opCVCZ3LITKDb+tmMSu4wz/tVVoZdvLCqPkM
	 XBS9L00/ugha6G5hknOS8CxhyMRLTj/PzMmdgnpK+cCT5u7VVXyCUTfnjSM6/NpmnWTpR
	 USv2EGZAzGcVfrtPf7iw4wpdnEeiJouIE1yzmDsB3TfSPcs8BkdRjl3g/rfelVGHTMFqW
	 LhCoQHs+uTF2/4FQn4PJPlW8p2F+xx7nof+sRXrN4/S8bo85k5WZ807wJx2d8g0o/vASk
	 BOx3A1pJihcnF++vgRnxKq47XC13FjCNlmV07JSRBCOmbWp6Vl4NSLcuchDa9Kbwrhw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqpVqEuj;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86436606A31C;
	Thu, 19 Nov 2026 00:20:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tqpVqEuj
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D57B31F000C4;
	Thu, 19 Nov 2026 00:20:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047625;
	bh=tpqkz/y9h2dupSahLde0iT07rNs9eJJvU8JScVf5p/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tqpVqEujyDN7FwSILLGYD1oN2wsyZx62f0YLvpcBXTRNHSfVo8OnBF+ZHBOuB/BrV
	 6qL7pqsTXmiIL6Jn1f/KRzEppJZdHl9B8sDE/WtU8gGYVJ2/EIrSuP53wH5/PtJfzQ
	 hmt7QWWOVYq5EpmPJZjiwJg82KbUt8Se4LIkbt3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1705/2857] mm/filemap: finish fault cleanup before dropping the fault lock
Date: Wed, 18 Nov 2026 15:45:39 +0100
Message-ID: <20261118150302.722942612@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: Replaced release_fault_lock(vmf) with mmap_read_unlock(vmf->vma->vm_mm) for mmap-only fault locking. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 36 +++++++++++++-----------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 61581b59d0ff3..08bdf85a97c09 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3078,11 +3078,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
  * @folio - the folio to lock.
  * @fpin - the pointer to the file we may pin (or is already pinned).
  *
- * This works similar to lock_folio_or_retry in that it can drop the
- * mmap_lock.  It differs in that it actually returns the folio locked
- * if it returns 1 and 0 if it couldn't lock the folio.  If we did have
- * to drop the mmap_lock then fpin will point to the pinned file and
- * needs to be fput()'ed at a later point.
+ * Returns 1 with the folio locked, or 0 if locking failed.
+ *
+ * On both entry and return, a non-NULL *fpin means the fault lock has
+ * already been dropped and the caller must eventually fput() the file.
+ * Otherwise the fault lock is still held, including on failure.
  */
 static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 				     struct file **fpin)
@@ -3099,20 +3099,9 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__folio_lock_killable(folio)) {
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
-		__folio_lock(folio);
+	if (vmf->flags & FAULT_FLAG_KILLABLE)
+		return !__folio_lock_killable(folio);
+	__folio_lock(folio);
 
 	return 1;
 }
@@ -3231,7 +3220,7 @@ static struct file *do_async_mmap_readahead(struct vm_fault *vmf,
  * vma->vm_mm->mmap_lock must be held on entry.
  *
  * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().
+ * may be dropped before doing I/O or when aborting an interrupted wait.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3374,9 +3363,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 
 out_retry:
 	/*
-	 * We dropped the mmap_lock, we need to return to the fault handler to
-	 * re-find the vma and come back and find our hopefully still populated
-	 * page.
+	 * With fpin set, the fault lock was already dropped. Otherwise it is
+	 * still held. Release invalidate_lock before dropping either protection.
 	 */
 	if (folio)
 		folio_put(folio);
@@ -3384,6 +3372,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
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



