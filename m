Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590267;
	b=WVYXZRDnUCKWvxhVpUGWVIVMwU6iJZrAlMIfbHs4z/+035RCe856zr93RmI3pwp7O0uw
	 zb3fAZjKReSv6E8TtSqT/6Yx2PzYCYoZ5bTdrTLRRm3BEKld4QTdvI4H58ZJ+iR8/yR3F
	 4jjnUGtrJNU+6FDgYXAJc2FoyZ9VN8Nn9d+ChxXuEM2deUbDAkvZsepFMyEc/vAVwwHh5
	 EgxxjXW2Zv1nO3MipMMXa4xmAIuuN0pGrL+OCMWYYBS5MjylXCbZua9avmyf7sY21G2P7
	 Qx+9kve7vAfC6wxOa2EGTETJgR8DTiRtJk/Op5N/yNvHN3TErJVgBIPJaJIErpSb1fA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590267;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=trizjgQY4urcsz6BGZ5b5Fs9bEVk+Z7SnDpTRxEfUvQ=;
	b=ouVw+N9LSWawKqhRZ0NYwaOsmyqw1I1szV/wKGXxlwtLWmMiG1ijnHUrRF/Zm/i/EFB5
	 FzPNux1COuVjYJL8WjMiJcNwwy0JZ6GT5xwydQzK1ZX5himHhFGl2rmBf62/hO8VR7gb8
	 WLW5XjwDV4YhwtC/40EBYx2jQQ53UI6PJ4B67JMLne7mt2f85ORc+7QF/esF6r1Fe0O+W
	 8W0iMp4fzfJJdT4gI/PPtVLXlcvLfHKDR6lyhLVPmVPNm845k2n+eOl8OJCnBMYARJd6Y
	 SpLlj/G0gwtcLrCgi6/O7vPpQAX4OWB+QkumzOI4W421Ix6d8MqKtFd5ZZLEz6q599A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMka2UIJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8CE760A3834;
	Fri, 13 Nov 2026 17:17:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=NMka2UIJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 846D61F000C7;
	Fri, 13 Nov 2026 17:17:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590267;
	bh=trizjgQY4urcsz6BGZ5b5Fs9bEVk+Z7SnDpTRxEfUvQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=NMka2UIJ2+utuWzAscFwV/EUyt6ugHp0ZMC8hw/e5550g68rAGnKp93bOoRiONumS
	 ZlFrh7MKxspWTiBZVlF6wrP3UWZk7B1wKvFMgR6hGxmEIhOUugjIo2rZIq4plMRSAH
	 PhUnblE00xUObSanzJr9A6nTjSirrcQLjizJ3LAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	Thadeu Lima de Souza Cascardo <cascardo@igalia.com>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 259/686] mm/filemap: finish fault cleanup before dropping the fault lock
Date: Fri, 13 Nov 2026 10:46:32 -0500
Message-ID: <20261113153829.805651540@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153820.902362109@linuxfoundation.org>
References: <20261113153820.902362109@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/filemap.c | 37 +++++++++++++------------------------
 1 file changed, 13 insertions(+), 24 deletions(-)

diff --git a/mm/filemap.c b/mm/filemap.c
index 7a8528d1daf79..cd7af384cff26 100644
--- a/mm/filemap.c
+++ b/mm/filemap.c
@@ -3222,11 +3222,11 @@ loff_t mapping_seek_hole_data(struct address_space *mapping, loff_t start,
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
@@ -3243,21 +3243,9 @@ static int lock_folio_maybe_drop_mmap(struct vm_fault *vmf, struct folio *folio,
 		return 0;
 
 	*fpin = maybe_unlock_mmap_for_io(vmf, *fpin);
-	if (vmf->flags & FAULT_FLAG_KILLABLE) {
-		if (__folio_lock_killable(folio)) {
-			/*
-			 * We didn't have the right flags to drop the
-			 * fault lock, but all fault_handlers only check
-			 * for fatal signals if we return VM_FAULT_RETRY,
-			 * so we need to drop the fault lock here and
-			 * return 0 if we don't have a fpin.
-			 */
-			if (*fpin == NULL)
-				release_fault_lock(vmf);
-			return 0;
-		}
-	} else
-		__folio_lock(folio);
+	if (vmf->flags & FAULT_FLAG_KILLABLE)
+		return !__folio_lock_killable(folio);
+	__folio_lock(folio);
 
 	return 1;
 }
@@ -3459,7 +3447,7 @@ static vm_fault_t filemap_fault_recheck_pte_none(struct vm_fault *vmf)
  * vma->vm_mm->mmap_lock must be held on entry.
  *
  * If our return value has VM_FAULT_RETRY set, it's because the mmap_lock
- * may be dropped before doing I/O or by lock_folio_maybe_drop_mmap().
+ * may be dropped before doing I/O or when aborting an interrupted wait.
  *
  * If our return value does not have VM_FAULT_RETRY set, the mmap_lock
  * has not been released.
@@ -3615,9 +3603,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 
 out_retry:
 	/*
-	 * We dropped the mmap_lock, we need to return to the fault handler to
-	 * re-find the vma and come back and find our hopefully still populated
-	 * page.
+	 * With fpin set, the fault lock was already dropped. Otherwise it is
+	 * still held. Release invalidate_lock before dropping either protection.
 	 */
 	if (!IS_ERR(folio))
 		folio_put(folio);
@@ -3625,6 +3612,8 @@ vm_fault_t filemap_fault(struct vm_fault *vmf)
 		filemap_invalidate_unlock_shared(mapping);
 	if (fpin)
 		fput(fpin);
+	else if (!(vmf->flags & FAULT_FLAG_RETRY_NOWAIT))
+		release_fault_lock(vmf);
 	return ret | VM_FAULT_RETRY;
 }
 EXPORT_SYMBOL(filemap_fault);
-- 
2.53.0



