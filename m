Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795038781;
	b=Cto5o04VQz7VOAeZDYw/t3jWfPgMet6Xx7HOeihZSii/51rBanI4J4xMJpaT0YSRYCvY
	 LxLugpsnF6Or7eQg0lnrVv+wHM6KAQnrhxUU1cuWC5Dq61bCIex31jH9LeAT3qR71QKi2
	 9pHMyJqLAfn3RCubF3JkubeoVpCFyhOKrW8oMAnsZCymf7n1sW4qb1b3P1zk5PWoxNmoa
	 YM8w1+XnqNANT9V62y3HYxEA+8HQIOjvQN6REfvwgsb4x7Bmsr0K903a2cjn/5daji+KO
	 lNpDUTLsY9sLRz8EHSJv/vNiSGchipvl4IK7kN2deh26diaCMIS4OBOolSTCoq9KL8Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795038781;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=6isSHENsp5cPY0Tm1URaegVljNsW6krbNhJF5xzK/8g=;
	b=uX6RIyFNRtOHHuOwvc571/RFpnb0PWT8zAdROIWIF99ajla1KRhBLD6noYdeMZbWKhGW
	 r3M5OXXqSOoldlQPr1MEdSK0yaGlzifeb9xUuXRLS7FVP/TTaOX6GInKc9WliAFe1dthl
	 yUk/qNmjuHgj/j2nm6G1czk5DW9Nzypw1kXbPgigcVStRKw+M1QeZgFbcbj2PrCFGsXAI
	 KHzGroIVXdnmv9ZS2kl0bEJiK9dyLgltSe9Gx9Dvx96oKzyMV9a/zZp5l/dks0SDWjQkp
	 leve/L15B5JnBOT+wreJ/RgFxVrJORz3aXsYN1PMDq3e8lcyRaYt4D5aaiGdbJLeZvw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUDns67u;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE913606A331;
	Wed, 18 Nov 2026 21:53:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=CUDns67u
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D2D61F000C4;
	Wed, 18 Nov 2026 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795038781;
	bh=6isSHENsp5cPY0Tm1URaegVljNsW6krbNhJF5xzK/8g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=CUDns67u5+j5JMjtYRO/Wd4n72/6sUOcpGXVUee3muweTXS46sqL0Vm0ulj2+JRZy
	 IERN8J4t0NnT0cEpURh10gxKh6NhXT9lNenZ9VuSKfoXskSuRxGEEByfoJgbMcHP/H
	 udqXCfRiraCe2J/1pFlpNAEG8iuVd+w13XqIqogY=
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
Subject: [PATCH 6.6 1864/3318] mm/ksm: fix use of a freed anon_vma at swap-in
Date: Wed, 18 Nov 2026 15:41:26 +0100
Message-ID: <20261118150417.842001061@linuxfoundation.org>
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
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ sashal: inlined folio_anon_rmap_compatible() checks into the existing page-based ksm_might_need_to_copy() routine ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/ksm.c  | 17 ++++++++++++++---
 mm/util.c | 13 +++++++++++++
 2 files changed, 27 insertions(+), 3 deletions(-)

diff --git a/mm/ksm.c b/mm/ksm.c
index fa4229a224060..902258abee418 100644
--- a/mm/ksm.c
+++ b/mm/ksm.c
@@ -2919,9 +2919,20 @@ struct page *ksm_might_need_to_copy(struct page *page,
 			return page;	/* no need to copy it */
 	} else if (!anon_vma) {
 		return page;		/* no need to copy it */
-	} else if (page->index == linear_page_index(vma, address) &&
-			anon_vma->root == vma->anon_vma->root) {
-		return page;		/* still no need to copy it */
+	} else if (page->index == linear_page_index(vma, address)) {
+		struct anon_vma_chain *avc;
+
+		/*
+		 * Careful: anon_vma might have been freed, so we cannot safely
+		 * dereference it. Add a fast path before we walk the anon_vma chain.
+		 */
+		if (anon_vma == vma->anon_vma || anon_vma == vma->anon_vma->root)
+			return page;
+
+		list_for_each_entry(avc, &vma->anon_vma_chain, same_vma) {
+			if (avc->anon_vma == anon_vma)
+				return page;
+		}
 	}
 	if (PageHWPoison(page))
 		return ERR_PTR(-EHWPOISON);
diff --git a/mm/util.c b/mm/util.c
index b8a7ec4471922..67b3d4014e235 100644
--- a/mm/util.c
+++ b/mm/util.c
@@ -764,6 +764,19 @@ void *vcalloc(size_t n, size_t size)
 }
 EXPORT_SYMBOL(vcalloc);
 
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



