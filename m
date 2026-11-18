Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795034777;
	b=BxndKBhc+O9nM4O79mE0+ASvounz/N9pWUtsviazmLtLVzoibivjRuoIwht2PBvOVWzm
	 CmtjRF98W56RQu04BwLOR9RGFhk6CyHGbu8EC4Up9hScSp8EQb57Gn866Cg1p34dBbPFU
	 9ITTBfbBj4aThwqgtU356TcoxIEnA55I4yQpJTSoQa37j0QNTRgYr8qH2raQQLVsuNQ3w
	 gdHv5/L4zxuh9pKnLFkCnp0pGal7wWzcQ8aDTcqRy6GekUzmB8txZUkG5RVA2HBcFRycl
	 Ea+B1XNe61pHS124K18j0uMM9NbmWUKxmLy2+C+DLmnYqOg5m059VegWjK1VPSrkQ7A==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795034777;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=NdsBkpfnbpnXU/3UQgskFQCtOciaUqpnckcCf7acfKw=;
	b=kH3lQIi196INzDxQcWouQ/FwWCvTjaEwIMk+yEoiE2McSzmh7IRtn90ekkf5imaglf8o
	 dn1AOQs9eFvbztZ5lb09EdrA8EHrbRwmh/Ej1/GbQ0fz6gkmnqSMuxoBUHSYbYME7nHWn
	 oXRIB6n9Ji0XduBN+0/dgRdLDYxDW2bZYG/v1ZOlgXxR5zV8OjnTksP8fPaUh9AmDsXlq
	 oleKtSlZJM2pASWjpEtSxpN6QqSH0U8bYLDQD34n4wNgAquKVHhsM4eH4bvzxlgIqLgc+
	 mw2t/89UAftTw6LuR6D8R4aQIEEuU6FiNS38Bi0aBKyw1SyLh1/ZyGdzChnYtkpCR+A==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dx+lFkmm;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60C62606A31C;
	Wed, 18 Nov 2026 20:46:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Dx+lFkmm
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B7FE71F000C4;
	Wed, 18 Nov 2026 20:46:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795034777;
	bh=NdsBkpfnbpnXU/3UQgskFQCtOciaUqpnckcCf7acfKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Dx+lFkmmnEf6XGcK/3sTfSa6v2p3N5R3FUDW8KXKReo9dE+kkPj2hasvacLvOYyv1
	 gA1Uk0KeunebVHCVI6TRwzF5FgjSRy8VFLk+JaLmXmaCbqKdp+ZnpW1zJsz6lstICg
	 keWsmsLw6twm+L//Jj8hnSfSfPcSydjJLTRKaAG0=
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
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0430/3318] mm/gup: fix always draining LRU caches in collect_longterm_unpinnable_folios()
Date: Wed, 18 Nov 2026 15:17:32 +0100
Message-ID: <20261118150329.524568290@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150313.527275416@linuxfoundation.org>
References: <20261118150313.527275416@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 078e1a0fc41a42baaf113383b52dab8874c0b967 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/gup.c | 10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

diff --git a/mm/gup.c b/mm/gup.c
index 60006de1219ee..098a837043b61 100644
--- a/mm/gup.c
+++ b/mm/gup.c
@@ -1957,6 +1957,7 @@ static unsigned long collect_longterm_unpinnable_pages(
 
 	for (i = 0; i < nr_pages; i++) {
 		struct folio *folio = page_folio(pages[i]);
+		const int pin_refs = folio_test_large(folio) ? 1 : GUP_PIN_COUNTING_BIAS;
 
 		if (folio == prev_folio)
 			continue;
@@ -1975,15 +1976,20 @@ static unsigned long collect_longterm_unpinnable_pages(
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
-- 
2.53.0



