Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793827048;
	b=dlJljxDEeAInB2poK4GP5M1DoH7YZgqhr9T9O0ZMJmsjHx7nRnjVCuvn/hVg3T4Sc0kJ
	 rTxnKYl2gd9hFERYuwmmsZlFpPimwDWdUAJjYPwzdizaFjSYcafdi5C9uYf6OWDunPshy
	 oNpceErT8tacnRLFEPljmwe9csEIZ7nkFdYRkG28N0pWq0BQ15OvfN2XJMFDAXQvesTIm
	 RJFzMkQqloM5Sk5pxVAq44hDwjh4JDcOzgWKzbuekE+SMv3veisPN+foCAyvwnE4vjMN0
	 QPeOiPxjUL8cw8cCE1EDQGzu2dgqI4I/o3M10MUWEXouemy7nXdNLfC0jT0hsPPfDaQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793827048;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=0M+zF3s5K2k9ZAUnAkn/HIt9MFvu9njUzeqdneQx41Q=;
	b=LABzqaj5MvACm21sS3cBb4o43tyUQtFaQn9giQy+ydks6T4BipCfyyD/g15aQdg0Jq/y
	 /ULUZtpGcmMXu2KX36DfuPAhHro93FxD0KWlVwWZNUE4tEkxuqUqH88sUtCrDR4tugEf0
	 IZp5BdY/0xOF4Pd/RDopSpLe2J1GZIY5drTly0N72gpBLbLwSP73usOI/na6WJQBnsw3f
	 DYISkiKqjGJ9E6MPxPVhq0+SRk/rj10LqwwSl2Rs4ZX009VwowOogPRop5kMzwx4XyPFp
	 P17jP308oSNRlmCig6YQhMsdY9gAEwXgPWWzPssuMT25Wfx7tRKDDcNSU/hlzOTLCnw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b="n/BnisxA";
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E1D6606A863;
	Wed,  4 Nov 2026 21:17:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=n/BnisxA
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EBF31F000C1;
	Wed,  4 Nov 2026 21:17:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793827048;
	bh=0M+zF3s5K2k9ZAUnAkn/HIt9MFvu9njUzeqdneQx41Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=n/BnisxAsx/vDV+x7uPPjUI52jYkxKSArJlsyDSwtIq6mHX7sQmNCPEbp4yquKG+y
	 Mr9MR+2wJwpsb5adEx2RvipKKB10ztyKZ8C+Vgel/xR1JJ2WJ1zjTqa6Lf+fhZtLI/
	 9+3QfB+0dXJd9e8nnq3UMpr3y4pm0LSfdbxuKwc0=
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
Subject: [PATCH 7.3 163/547] mm/hugetlb: fix use-after-free in hugetlb_mfill_atomic_pte()
Date: Wed,  4 Nov 2026 16:05:47 -0500
Message-ID: <20261104211042.786332437@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261104211038.406938024@linuxfoundation.org>
References: <20261104211038.406938024@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
@@ -6474,11 +6474,16 @@ int hugetlb_mfill_atomic_pte(pte_t *dst_
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


