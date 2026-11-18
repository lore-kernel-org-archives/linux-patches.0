Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795047377;
	b=opIYhyLb8ZaFnf7kezG+Mt75t9DAhTXCl4VTkYWIfagdQ8uDOkTwzFLQQP/OJkNGv2Hg
	 sb8R0UxpuOd1Vq7JAFoMGETGx/bagPsql0LFTCvsjLUx5wZC3LgB1Jprq5zmaegCGq9RC
	 C6BOn0keRecTA4EfAApfqmHNEoItkyOu2pbHzcv+lDGSK5PwTGMcpZpw+m/hc8D9mzSU/
	 8uXYfqyZqLaTItAU3tvgRkDh4KPx/Tt12NpOqaRDsJhtD9FuPKvuI1nTb7qTLVg+Uv219
	 fgeMLOyE211tKd63FeaDGM8WPm3F4lsvWyVxSEUbod6UrMnAcCwkM1LbNCvDRM8V5FA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795047377;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=WWqK7Ko5KChjjLgKEhY6n6CYdvrJETCM8mtFQ1IpbMI=;
	b=tBesz1Kfzc6+bXbCKpkwU8pcFJ8dqrxX6v07d9po54tdAd2UBuOAv18yEJU7EmZRVJ0J
	 PEtuaLHdU/aWgD5idhDqiHr/l87v6oK325rqV+nKaFk7KPKhWkHbRWJuDt+EOEumKZosc
	 HbjOuGA6piF5UdrJaYcV+moZRw8Px1l4vCM2KVkjHiOVyhwpOFVE8PK1M1C+ayjYEqM6B
	 ENB47HgV6ZowxerSO7oNtsWX99m2YeidtJvVKD7JdzehUBSo6XYlHYKvdDqkdjfop5yX8
	 DZPVRHa7c1qSSAIeAL7ymNFCxpt+q+eFBBjIb00dYWjNFl37GvRRrlpN+FRTqz4yVMg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZKXojFE;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B365B606A33F;
	Thu, 19 Nov 2026 00:16:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=2ZKXojFE
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 164321F000C4;
	Thu, 19 Nov 2026 00:16:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795047377;
	bh=WWqK7Ko5KChjjLgKEhY6n6CYdvrJETCM8mtFQ1IpbMI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=2ZKXojFEn6zSr7DPBOuhUIMTQjCsFhzYJEa3jVjqOktvgntZY+QnuPFhVjNnp2Znh
	 9uwUgskPe6V8dCb5Y9bhvFGUEakKvoKgoHg1nR6PNoqLR5E2MXYI87fjSQGP3U2n63
	 203azXx9H5nsrWg7IjaD6QA4wemJE+Xhewesx2x4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <mason@kernel.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Xu Xin <xu.xin@linux.dev>,
	Muhammad Usama Anjum <usama.anjum@arm.com>,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1617/2857] mm/ksm: fix use of a freed anon_vma at swap-in
Date: Wed, 18 Nov 2026 15:44:11 +0100
Message-ID: <20261118150259.571861638@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Hildenbrand (Arm) <david@kernel.org>

[ Upstream commit 4c2dec1dce368ad9e9b1814307cb5ef3832fa07e ]

A folio read from a swap slot previously shared by KSM can remain in the
swap cache after the process that first mapped it exits. Its anon_vma
can then be freed, so ksm_might_need_to_copy() must not dereference it
to compare roots.

Doing so can result in some false-positives, resulting in the reverse
mapping missing the new folio mapping, preventing migration and reclaim.

SLAB_TYPESAFE_BY_RCU allows individual anon_vma objects to be reused
immediately after freeing. A stale pointer can then refer to another
anon_vma whose root matches, even though the target VMA is not linked
to that anon_vma.

Move the anonymous rmap compatibility checks into
folio_anon_rmap_compatible(). Keep the page-index check and compare the
folio's anon_vma pointer against the VMA's own anon_vma and root first.

If neither matches, bite the bullet and walk the VMA's anon_vma_chain.
The VMA keeps these anon_vmas alive, and finding a match guarantees that
reverse mapping can find the new mapping.

Lorenzo Stoakes says in a private discussion:

  "This isn't quite equivalent to the existing check.

  Every anon_vma in an anon_vma_chain shares the same root, but if you
  split a VMA then fork both of them like this:

                  VMA A
               /        \         <split>
            VMA B      VMA C
               \        /
        root <- anon_vma 1
               ----^ ^----        <fork>
              /   parent  \
        anon_vma 2   anon_vma 3
             |            |
           VMA D        VMA E

  VMA's D and E both get their own new
  anon_vma's such that:

  VMA D: anon_vma 2 -> anon_vma 1 -> root
  VMA E: anon_vma 3 -> anon_vma 1 -> root

  And if you found a folio referencing anon_vma 2, the existing check:

	anon_vma->root == vma->anon-vma->root

  Would be true for VMA's B, C, D & E.

  However after your change it'd be true for VMA D only, as it's the only
  one with anon_vma 2 in its anon_vma_chain.

  Whether or not that could actually happen in practice... 🙂 I don't
  know.

  [...] after your change it'd be true for VMA D only, as it's the only
  one with anon_vma 2 in its anon_vma_chain. [...] I would [...] say that
  you are making the test stricter but more correct.
"

If this affects performance when KSM was never even involved, we could
just track whether KSM ever merged anything and just skip these checks.

There isn't really a lot we can do otherwise: for mapped folios we might
be able to use folio_get_anon_vma(), but for unmapped folios there really
is no easy way to see if the anon_vma is still valid.

Document the (confusing) lifetime requirements of folio_anon_vma().

Fixes: ba6f0ff3981e ("ksm: fix ksm swapin time optimization")
Cc: stable@vger.kernel.org
Reported-by: Chris Mason <mason@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Xu Xin <xu.xin@linux.dev>
Tested-by: Muhammad Usama Anjum <usama.anjum@arm.com>
Link: https://patch.msgid.link/20261031-fixes_core-v3-40-d6437171ecc3@kernel.org
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
[ sashal: inlined folio_anon_rmap_compatible() logic using the existing page interface and page index checks ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c  | 16 +++++++++++++---
 mm/util.c | 13 +++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index c976e41f853b0..1ef4d5bf8077a 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2692,6 +2692,7 @@ struct page *ksm_might_need_to_copy(struct page *page,
 {
 	struct folio *folio = page_folio(page);
 	struct anon_vma *anon_vma = folio_anon_vma(folio);
+	struct anon_vma_chain *avc;
 	struct page *new_page;
 
 	if (PageKsm(page)) {
@@ -2700,9 +2701,18 @@ struct page *ksm_might_need_to_copy(struct page *page,
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (page->index == linear_page_index(vma, address) &&
-			anon_vma->root == vma->anon_vma->root) {
-		return page;		/* still no need to copy it */
+	} else if (page->index == linear_page_index(vma, address)) {
+		/*
+		 * Careful: anon_vma might have been freed, so we cannot safely
+		 * dereference it. Add a fast path before we walk the anon_vma chain.
+		 */
+		if (anon_vma == vma->anon_vma || anon_vma == vma->anon_vma->root)
+			return page;	/* still no need to copy it */
+
+		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+			if (avc->anon_vma == anon_vma)
+				return page;
+		}
 	}
 	if (!PageUptodate(page))
 		return page;		/* let do_swap_page report the error */
diff --git a/mm/util.c b/mm/util.c
index d3a2877c176f9..2187074f4ca6c 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -743,6 +743,19 @@ bool folio_mapped(struct folio *folio)
 }
 EXPORT_SYMBOL(folio_mapped);
 
+/**
+ * folio_anon_vma - Get a folio's raw anon_vma pointer.
+ * @folio: The folio.
+ *
+ * The returned pointer may be stale for an unmapped folio. The caller
+ * must ensure the anon_vma stays alive before dereferencing it. A folio
+ * reference or lock alone is insufficient; use folio_get_anon_vma() when
+ * the anon_vma's lifetime is not otherwise protected. Note that
+ * folio_get_anon_vma() is only useful for folios that are still mapped.
+ *
+ * Return: The raw anon_vma pointer for an anonymous, non-KSM folio, or
+ * %NULL otherwise.
+ */
 struct anon_vma *folio_anon_vma(struct folio *folio)
 {
 	unsigned long mapping = (unsigned long)folio->mapping;
-- 
2.53.0



