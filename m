Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794590428;
	b=d9Wt+fpJ31nQ1DGETLtNB8KVKjvesj8aPtMgQ5UAOErY997gL3ysdyayEuQ+4dxP+kBp
	 3FR3BhjyRxZtqnIxPfJh3Rh2dybTt/va3bvmObj+V6/dk4if/TO7nEhB0B4aUB/dxUnGw
	 xBl8toZEdKg3OPMlGQ21+Qtt+F5PguCI7wfb88K5YawNUmzb6T9YYk0Ty25IDyfGFJYcS
	 8cDUGATbi+TMiHAMVEWXPob2Lxv+IYsNKSOegG44EFesk1GsEt1s/RZgpZ41WALeaZV9C
	 TWOFE3xOW7JTGPrK5aV25d2w252m+46QHWt/My977HCeNDRxWxkl/bo/kycc3ybrtQg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794590428;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=rdP7EnrArV3jIcvY34aC6ocSNCg5lV1HByrzwuHVAnA=;
	b=Xb/UrPbc7NOcGpH/oMVIElYxeF3puD+EZYWuhZGKnZ/UTlDqZ2KothsJu4PQzVxOXmfI
	 bdyBSs8pv3QoUS8s7YRzn9aYoQRU4LTEx67McpLKSjtNmzurHewA1RZQnPoEM4Y+tLQ23
	 fFUqqT53mOdEzFdPePvyYVkskcuDs3GOYvHVaiBswxrdlgcXMnmTvy/rOoXqmppkB4/Z7
	 P5dHBk7jhIYBJ8n5SsCUDoGFIzCvE0/MILm0rHgPqfKlM4WbYGGwBgGEPrYQzcH77oneG
	 2dUft4jcPNn//NfW6iaLpNncR7Mekt0Ggrj6r1lVdeeXGPIJo9PeU5HjMmW0Q/CKP2w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="Zwnb0+/m";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39F69606F734;
	Fri, 13 Nov 2026 17:20:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Zwnb0+/m
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 996201F000C6;
	Fri, 13 Nov 2026 17:20:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794590427;
	bh=rdP7EnrArV3jIcvY34aC6ocSNCg5lV1HByrzwuHVAnA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Zwnb0+/mGCncWKodAAgw4sKmg5L+/in4u7SauSrC5g6YZNb+CMF6kAIBj3tQrlNGX
	 ZmZlRD5lgYq2Eo9IERVU3W9MVvsnMw/zf4UILQ7i4cSNAd99sWltCX9PHWw+Oj96qW
	 88YwxKYDM2dY08WOQzbA64yeuLqsJtq+RW5Yjiiw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Lutomirski <luto@amacapital.net>,
	Samiullah Khawaja <skhawaja@google.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 390/686] mm/gup: check folio->mapping under folio lock in memfd_pin_folios()
Date: Fri, 13 Nov 2026 10:48:43 -0500
Message-ID: <20261113153834.222748121@linuxfoundation.org>
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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 29 +++++++++++++++++++++--------
 1 file changed, 21 insertions(+), 8 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 9ce5c8ef72fad..c345bca01e3af 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -3463,7 +3463,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 {
 	unsigned int flags, nr_folios, nr_found;
 	unsigned int i, pgshift = PAGE_SHIFT;
-	pgoff_t start_idx, end_idx;
+	pgoff_t start_idx, end_idx, retry_idx;
 	struct folio *folio = NULL;
 	struct folio_batch fbatch;
 	struct hstate *h;
@@ -3504,6 +3504,7 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			 * reason, we try to allocate them and add them to the
 			 * page cache.
 			 */
+			retry_idx = start_idx;
 			nr_found = filemap_get_folios_contig(memfd->f_mapping,
 							     &start_idx,
 							     end_idx,
@@ -3516,7 +3517,21 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
 			for (i = 0; i < nr_found; i++) {
 				folio = fbatch.folios[i];
 
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
@@ -3527,14 +3542,12 @@ long memfd_pin_folios(struct file *memfd, loff_t start, loff_t end,
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



