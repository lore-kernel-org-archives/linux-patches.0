Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D5BD412294;
	Fri,  4 Sep 2026 05:41:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500491; cv=none; b=dM/TcwUF1unVwRr6FaS6HscRzZdaJ6braF5u47E6JUM0gxnOn95fMe0Tnsc4wNxQ6MHhoxp1sdp9z0ugP1qxj2LOULHZ2YsWhcUNUKuT/QV4NyOQGe1X4CPPjcLhXK2e2J7MKAX3iej1kwCa1i+teK9dvwFKeBULmWg2F3xLEXQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500491; c=relaxed/simple;
	bh=QuNirz4/XC6+a25Yg1KVojc5zp/413TZmfI/1VP37DI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=keZo+IJvlEsiyp6u9VLM32GJ3nbwiJYHAydHuSd3rt9ON+8/ENs3oou5/QzNMKN/XRQUUs3F6UNbDz4gFmJbZZZrCfdnPRtKuQL/oADbs81KOAw/ltmIqEm5BLWcICh3gWaQB2ddtQN3qMqqTlTqghWw3dlGK86H1pOCx1rBC7E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OtKZkXWD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OtKZkXWD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AE8951F00A3D;
	Fri,  4 Sep 2026 05:41:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500490;
	bh=UrWM/61rQqwoylZTNLrgjr+VYEjwdvrqTl74hZKCsOA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OtKZkXWDTzYj2zwyRwXw96WPbM298Jn2BB97j9W1R7fNs5fd6UghdRGVjKM4HpIHD
	 RKlRrWsye8YNUibTU7ko5qNdnEQPKc0Jn39ikOcqk/bTj7y8K8fzo0BfKkckvZ+xqQ
	 V0X1kuELrxYaWk7MjfkrVatc05FY3gtDu/whJ/5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Hugh Dickins <hughd@google.com>,
	Ackerley Tng <ackerleytng@google.com>,
	Jason Gunthorpe <jgg@ziepe.ca>,
	John Hubbard <jhubbard@nvidia.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Peter Xu <peterx@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 032/552] mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
Date: Fri,  4 Sep 2026 06:53:09 +0200
Message-ID: <20260904045748.556909049@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

commit 078e1a0fc41a42baaf113383b52dab8874c0b967 upstream.

folio_may_be_lru_cached() is currently only true for small folios, and
for small folios FOLL_PIN adds GUP_PIN_COUNTING_BIAS references instead
of 1 in try_grab_folio()/try_grab_folio_fast().

Consequently, our

	folio_ref_count(folio) != folio_expected_ref_count(folio) + 1

check in collect_longterm_unpinnable_folios() will currently always
identify "reference mismatch" and first drain the local LRU cache to then
drain the LRU cache on all CPUs, as collect_longterm_unpinnable_folios()
is really called after pinning the folios with FOLL_PIN.

Add a comment because the current code is not quite intuitive: we used to
drain only to make sure the folio_isolate_lru() would succeed. But then we
also started draining to make later migration more reliable.

We'll refactor that code soon a bit, to also make it usable in other
context where we really want to remove any references from LRU caches.

Let's add CC stable, because having an easy way for excessive LRU cache
draining on all CPUs does not sound right. In common scenarios we
don't expect to ever have to drain.

Link: https://lore.kernel.org/20260731-check_and_migrate_movable_folios-v1-1-e0002d7b791e@kernel.org
Fixes: 98c6d259319e ("mm/gup: check ref_count instead of lru before migration")
Fixes: a09a8a1fbb37 ("mm/gup: local lru_add_drain() to avoid lru_add_drain_all()")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Acked-by: Hugh Dickins <hughd@google.com>
Cc: Ackerley Tng <ackerleytng@google.com>
Cc: Jason Gunthorpe <jgg@ziepe.ca>
Cc: John Hubbard <jhubbard@nvidia.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Peter Xu <peterx@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/gup.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/mm/gup.c
+++ b/mm/gup.c
@@ -2273,6 +2273,7 @@ static unsigned long collect_longterm_un
 
 	for (folio = pofs_get_folio(pofs, i); folio;
 	     folio = pofs_next_folio(folio, pofs, &i)) {
+		const int pin_refs = folio_has_pincount(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio_is_longterm_pinnable(folio))
 			continue;
@@ -2287,15 +2288,20 @@ static unsigned long collect_longterm_un
 			continue;
 		}
 
+		/*
+		 * We drain not only to make the folio_isolate_lru() succeed,
+		 * but also to remove any other folio references from LRU
+		 * caches.
+		 */
 		if (drained == 0 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain();
 			drained = 1;
 		}
 		if (drained == 1 && folio_may_be_lru_cached(folio) &&
 				folio_ref_count(folio) !=
-				folio_expected_ref_count(folio) + 1) {
+				folio_expected_ref_count(folio) + pin_refs) {
 			lru_add_drain_all();
 			drained = 2;
 		}


