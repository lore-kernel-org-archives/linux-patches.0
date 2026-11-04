Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793831462;
	b=cnB3BDF/oN5Dvyup7rrD2B1m5V7t7XQdnWrh3u3FZ/LUohpl3/8PYTttB0eKyj8nch6a
	 OwLUcauDH4/O5yGeq1XuJrnVjJj1T4XOYS61ZK7hWxl5feq43N+F6mzbswPv+nDn003/+
	 HMp9kTSlX6/RU4Cq97Poi33M4uQAMeCZGiH0Ff5beAVrMYGzel6UjrFxDk/ygb/BMpl0M
	 I+PZpWm7iFw/EaebGJlxmhaNQEKgGA1iHeUcg7fkMg2E7krhiBI0dzKWF7s2Hmy00XNgm
	 9Ts5PVKfxhR6DESyc0COlXnmTSVFJ/bXuDxjbDKxFRN2PlDD2S3Hg3tlLmlJepaEfUA==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793831462;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=nzE9Ojf9HlWbuLpPd6Yu1v7wJBLw/jgqNygUWkZCF7s=;
	b=1Qgj/f9wKeYuiTKfFIBSCgLjZR+4FH5O/6pQcKz8RkkSAoE6Mbv1ZjAOwa0kbmAZ5o65
	 8FdaqOcFdsRlWkriCrfnXLsNdF787gDMzVHP1S205iPcnH3dpk0IG/bNaFq0va8FveeQr
	 FXSAJFJjy7gJsLfMY3JzPSZB8QzwuC3vqSut50qdR6z4zPb+IuT15btx6xlvx5MPagKly
	 SYPmI8KFWeigjuq5EyiyDBrFUjuPgICxlygGGoIAB2fE6HC6OWW8YkTTyUIEQQkW1iHhO
	 5hkw+niVcOefWe2K/H8tnD/17Y8NNid5uqr0lxsjXo0GgERqb2DAXWDsM1h9Q7qqoUA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JttlHI+a;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DDC1D606A335;
	Wed,  4 Nov 2026 22:31:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=JttlHI+a
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 63E3D1F00919;
	Wed,  4 Nov 2026 22:31:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793831461;
	bh=nzE9Ojf9HlWbuLpPd6Yu1v7wJBLw/jgqNygUWkZCF7s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=JttlHI+aj1lsYUHlMnPvNawtSngMhHBm07NpJOxSoTzBG32nGCqAofeplRniFAPvm
	 51wmedT4jFoAIz2q52is0dNMECA86+VP1bMz4v+lBUgYPga7n2M0Zd08C3IH/jc/e3
	 K0us045Ogceukb1MRGctaTn0cqI5IivugGnbzN4A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"David Hildenbrand (Arm)" <david@kernel.org>,
	Andrew Morton <akpm@linux-foundation.org>,
	"Lorenzo Stoakes (ARM)" <ljs@kernel.org>,
	Muchun Song <muchun.song@linux.dev>,
	Lance Yang <lance.yang@linux.dev>,
	"Liam R. Howlett" <liam@infradead.org>,
	Vlastimil Babka <vbabka@kernel.org>,
	Jann Horn <jannh@google.com>,
	Pedro Falcato <pfalcato@suse.de>,
	Oscar Salvador <osalvador@suse.de>,
	Miaohe Lin <linmiaohe@huawei.com>,
	Naoya Horiguchi <nao.horiguchi@gmail.com>,
	Adam Litke <agl@us.ibm.com>,
	Mel Gorman <mgorman@techsingularity.net>,
	Rik van Riel <riel@surriel.com>,
	Peter Xu <peterx@redhat.com>,
	Kiryl Shutsemau <kas@kernel.org>,
	Mike Rapoport <rppt@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>
Subject: [PATCH 6.18 0678/1005] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed,  4 Nov 2026 16:06:51 -0500
Message-ID: <20261104211102.626589584@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211043.516122098@linuxfoundation.org>
References: <20261104211043.516122098@linuxfoundation.org>
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

commit d8a9cd7fd2fb01211430c933932da58839b8ca65 upstream.

Let's fix another instance where we use a folio after dropping the PTL,
where someone else could e.g., MADV_DONTNEED it once we drop the PTL,
making us trigger a use-after-free on the folio.

Link: https://lore.kernel.org/20261015-urgent_fixes-v1-3-42796911043b@kernel.org
Fixes: cb6acd01e2e4 ("hugetlbfs: fix races and page leaks during migration")
Fixes: 1c9e8def43a3 ("userfaultfd: hugetlbfs: add UFFDIO_COPY support for shared mappings")
Signed-off-by: David Hildenbrand (Arm) <david@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Reported-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Reviewed-by: Lorenzo Stoakes (ARM) <ljs@kernel.org>
Acked-by: Muchun Song <muchun.song@linux.dev>
Reviewed-by: Lance Yang <lance.yang@linux.dev>
Cc: Liam R. Howlett <liam@infradead.org>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: Jann Horn <jannh@google.com>
Cc: Pedro Falcato <pfalcato@suse.de>
Cc: Oscar Salvador <osalvador@suse.de>
Cc: Miaohe Lin <linmiaohe@huawei.com>
Cc: Naoya Horiguchi <nao.horiguchi@gmail.com>
Cc: Adam Litke <agl@us.ibm.com>
Cc: Mel Gorman <mgorman@techsingularity.net>
Cc: Rik van Riel <riel@surriel.com>
Cc: Peter Xu <peterx@redhat.com>
Cc: Kiryl Shutsemau <kas@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Josef Bacik <josef@toxicpanda.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/hugetlb.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/mm/hugetlb.c
+++ b/mm/hugetlb.c
@@ -7106,11 +7106,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
 	/* No need to invalidate - it was non-present before */
 	update_mmu_cache(dst_vma, dst_addr, dst_pte);
 
-	spin_unlock(ptl);
 	if (!is_continue)
 		folio_set_hugetlb_migratable(folio);
 	if (vm_shared || is_continue)
 		folio_unlock(folio);
+
+	/*
+	 * Hold the PTL until we're done with the folio: the page table owns the
+	 * folio reference now.
+	 */
+	spin_unlock(ptl);
 	ret = 0;
 out:
 	return ret;


