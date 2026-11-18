Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795060061;
	b=gTaIVIYG+euy/XqBaXWcIv9QOQZVtOlGle907qfqUBPhYd3p40HxwUpCgM65X7BEeaW6
	 yZ+O0iAuumFQnAVoOVXNp7q1QIScH6NQY69oXj0wWw9Un3aylCdHcqCUnLviZGKeGPCzK
	 r+DjScTqHvPRBbs0+GDovfc38OyuvrpSSTqewOxfM0EhZ1GWZnOTH78i8rSLKbZOeyEk4
	 m+pm2NGVdsnXGKgEgLyIdqBRXkUCUKITHw6Ucxk/YNK5z0Zi4l6UwpWkNrmYN8o8k8Idz
	 Dch6wLpQjk9L0X/xcyAFAPU/ZnVFi9DH/IubQvez9Jb/cMcJlDyh+Ozbss4Fef9UdlQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795060061;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=JK6Lmro5OmI7/u+8Hot0br2ge6wHWc5fo2ONXDlVe4w=;
	b=vZ7fstnr0MGQVuc1FT8tHwd0M068uBX0HYIPD1hPtH9Xk8hm9LjYaqCUXO7tyXFrAMZA
	 OzVNXl25DrnmK1c3dySP1KDmxPZfNPpMcaaw1QxqFNnLdOzVhk9GkEuAEY+iB2S63GW2R
	 3gD8teHhjDSzydhNHIMTvF2TbTXh6wNXfJxhIQ3wGQzFni4ulF4kqbtAumkqNY4IlQxAL
	 yt2qtf9gkbcvpSHTdWZ6WMAFaCHP68Sk9zSBUfFFVbJxt5CO0pGP5u7hniIexqm0ZYCGp
	 jJqztZJLxR9ogd+DlYyijO0EBT+R2MBXW3ijxuVhDzbG+7HCYZHz2+zl25g9rT9W5lw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tDNUTqc;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 40A97606A320;
	Thu, 19 Nov 2026 03:47:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1tDNUTqc
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91CB91F000C4;
	Thu, 19 Nov 2026 03:47:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795060061;
	bh=JK6Lmro5OmI7/u+8Hot0br2ge6wHWc5fo2ONXDlVe4w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1tDNUTqcylTzhGQzVS7+9JN95r54T1msTxgIlypNJ4arbQrjuqtNc2k4k5MhjdVgN
	 YLP2peVywnDt8TxnFIWUZEiZaOObFENsgnDqXZnLpIiG98+Z/1bRZPvlzQoj/8oUB7
	 W22rNOA+oB4MOdpthA64Pwitc9z+IKwrjqW0uIHE=
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
Subject: [PATCH 5.10 1023/1848] mm/ksm: fix use of a freed anon_vma at swap-in
Date: Wed, 18 Nov 2026 15:51:01 +0100
Message-ID: <20261118150000.025643715@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inlined the folio compatibility helper into ksm_might_need_to_copy() using page-based APIs ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c  | 16 +++++++++++++---
 mm/util.c | 13 +++++++++++++
 2 files changed, 26 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index bc097bb03c1c2..649fd1326d3d1 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2671,6 +2671,7 @@ struct page *ksm_might_need_to_copy(struct page *page,
 			struct vm_area_struct *vma, unsigned long address)
 {
 	struct anon_vma *anon_vma = page_anon_vma(page);
+	struct anon_vma_chain *avc;
 	struct page *new_page;
 
 	if (PageKsm(page)) {
@@ -2679,9 +2680,18 @@ struct page *ksm_might_need_to_copy(struct page *page,
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (anon_vma->root == vma->anon_vma->root &&
-		 page->index == linear_page_index(vma, address)) {
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
index 9e0c86555adf0..52ea9aa638294 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -766,6 +766,19 @@ bool page_mapped(struct page *page)
 }
 EXPORT_SYMBOL(page_mapped);
 
+/**
+ * page_anon_vma - Get a page's raw anon_vma pointer.
+ * @page: The page.
+ *
+ * The returned pointer may be stale for an unmapped page. The caller
+ * must ensure the anon_vma stays alive before dereferencing it. A page
+ * reference or lock alone is insufficient; use page_get_anon_vma() when
+ * the anon_vma's lifetime is not otherwise protected. Note that
+ * page_get_anon_vma() is only useful for pages that are still mapped.
+ *
+ * Return: The raw anon_vma pointer for an anonymous, non-KSM page, or
+ * %NULL otherwise.
+ */
 struct anon_vma *page_anon_vma(struct page *page)
 {
 	unsigned long mapping;
-- 
2.53.0



