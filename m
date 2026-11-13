Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794591287;
	b=yGI8XM62W3jxyWeVZw5rP5FjQawFQSLv4e6p0RqjlpoK0NdGVrNsQ8p/6BspZS5Upztu
	 PqIipC9kTpdhy3lf1rUPnbEg7yeCWfUzclvT/4IQNMMVmc9dVzJ8Nu30U1BT872HE7MtT
	 fON8JnaCy3teQvUMNV81Pt5gVq4qrwWmlNa7gxL0Cg+0fZU2A12GunLl7TNz9g3qIJO7b
	 T83K/YZL/wFBtPQzmrm/F8I3froUsDJ7I068DYV8EyCHRXAA5VgMawtQZSZUy0FJKLh9S
	 f7KoBSZnLjhpEgQz8ydsZiqAjys8dYxXbUKLCfWPBKC8aUuFayZmtdNVWxktyk+skKw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794591287;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=31AqpP3iCAbbdMVqpFCTCZ1U9GwQ88xM2XZe9CsTB24=;
	b=M21YqGCP4cOUEJZX8mWyzmHKMGh0F8s4bgERzqx97rFnBv9qBQ7ZxI6rx3Wdoi8LFyw+
	 +VMtZZlQkoZQO3aFoGStPrEfTQawBQRfseCFYWtbkA9lX1vEVGzqb0limN+sr6G26ymUm
	 OIu7YWQS8BzHFrOeU3Ifeq3HbtoeqT9xjJxqCjRU5xKPhRZb8096lh/9rui2Jz1WCvWPn
	 1hLiw4KN/6n0Ymtriq4ztSqnVtP1rZibcwQbRIjn+PGVeOg/MnluIWKOxWEI3pLryWIuK
	 SBrMFyVmf7q6ZUr424j4gz3fEYUtJL2VUROnaizVqAMOq4V7H1RnrR3/KOELOy2y00Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDV1Rg0t;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F26C60776C2;
	Fri, 13 Nov 2026 17:34:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=HDV1Rg0t
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B5651F000C5;
	Fri, 13 Nov 2026 17:34:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794591287;
	bh=31AqpP3iCAbbdMVqpFCTCZ1U9GwQ88xM2XZe9CsTB24=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HDV1Rg0tlik04NPupTFfBQOzOkZe1rJglqAPeph2k2a3LWT/gJ3I+fJSLKXm/WrC6
	 8p4dOS11dMOyGfpIZGLQK77pznfw3HN6LN3g7LkrtAVSPbJ8tBdttAq0tvxwM6fRwD
	 Kt2w0/9Dk/rVFOjIhCLDhOqJ289ZbJsgprswaODE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Samiullah Khawaja <skhawaja@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 406/670] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
Date: Fri, 13 Nov 2026 10:49:30 -0500
Message-ID: <20261113153825.511978574@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261113153811.177190860@linuxfoundation.org>
References: <20261113153811.177190860@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Samiullah Khawaja <skhawaja@google.com>

[ Upstream commit 71555ae8c7572fd99158013ca2e29187c5d2508d ]

memfd_pin_folios() pins folios from the page cache without taking the
folio lock. khugepaged or MADV_COLLAPSE can therefore replace a folio
after checking its refcount while memfd_pin_folios() still pins the old
folio. The caller then receives a folio which is no longer part of the
memfd.

For udmabuf and iommufd, this can cause data corruption: DMA accesses
the detached folio rather than the live memfd contents. DMA reads can
return stale data, while DMA writes update the detached copy and are
lost from the live memfd. The detached folio remains pinned, so these
accesses do not constitute a use-after-free or target another
application's memory. For memfd live update, the stale contents can
reappear in the memfd after handover.

Lock the folio and recheck folio->mapping before pinning it, like other
page cache users do. If the folio was removed, retry the folio lookup
from the index that was removed.

Fixes: 89c1905d9c14 ("mm/gup: introduce memfd_pin_folios() for pinning memfd folios")
Reported-by: Andy Lutomirski <luto@amacapital.net>
Closes: https://lore.kernel.org/all/CALCETrV5eqg6d9=+BQhCpRwBNe3aCQiut8vxPBs8b7PToqjaHg@mail.gmail.com/
Cc: stable@vger.kernel.org
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Reviewed-by: Andy Lutomirski <luto@amacapital.net>
Link: https://patch.msgid.link/20261031203540.2282507-1-skhawaja@google.com
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ skhawaja: resolve conflict with the existing next_idx variable in 6.12 ]
Signed-off-by: Samiullah Khawaja <skhawaja@google.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 0e1a0c6c5f213..d9107eb461a02 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3706,7 +3706,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx, next_idx;
+	pgoff_t start_idx, end_idx, next_idx, retry_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3747,6 +3747,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
+			retry_idx = start_idx;
 			nr_found = filemap_get_folios_contig(memfd->f_mapping,
 							     &start_idx,
 							     end_idx,
@@ -3771,7 +3772,21 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 
 				folio = page_folio(&fbatch.folios[i]->page);
 
+				/*
+				 * The folio might have been removed from the
+				 * page cache (e.g., truncated or collapsed)
+				 * after the lookup. Recheck under the folio
+				 * lock.
+				 */
+				folio_lock(folio);
+				if (unlikely(folio->mapping != memfd->f_mapping)) {
+					folio_unlock(folio);
+					start_idx = retry_idx;
+					break;
+				}
+
 				if (try_grab_folio(folio, 1, FOLL_PIN)) {
+					folio_unlock(folio);
 					folio_batch_release(&fbatch);
 					ret = -EINVAL;
 					goto err;
@@ -3782,14 +3797,12 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 				 * page cache that were never cleared.
 				 */
 				if (!folio_test_uptodate(folio)) {
-					folio_lock(folio);
-					if (!folio_test_uptodate(folio)) {
-						folio_zero_range(folio, 0, folio_size(folio));
-						flush_dcache_folio(folio);
-						folio_mark_uptodate(folio);
-					}
-					folio_unlock(folio);
+					folio_zero_range(folio, 0, folio_size(folio));
+					flush_dcache_folio(folio);
+					folio_mark_uptodate(folio);
 				}
+				retry_idx = folio_next_index(folio);
+				folio_unlock(folio);
 
 				if (nr_folios == 0)
 					*offset = offset_in_folio(folio, start);
-- 
2.53.0



