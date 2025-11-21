Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9DD61F09B3;
	Fri, 21 Nov 2025 13:22:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731378; cv=none; b=hvxA6DKDLZLmcHx0L9omWWJCdWEj8X/8936lLloObMcNfO0qwWgQIzSwcvshLiAS/fdpEDSu02rckDXJB/vg7NQJWOihCBv6peLZcGSXAjCcHZy6cv3U2fZZKApYYpso5SK5KKiJg1Cn5TbZkS69Nf9lCug6nX+iAqOX8aaev/s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731378; c=relaxed/simple;
	bh=NeU+gv/RKV2M4SxXzQxnZhl3e7Y46iwVSD0ettK9neg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U/CpEH0of1foTpwWrgu+7GxoQ0xsHxZDRi0d25OIPbDGbGxj/f4I0HEmrXeVbtP3uex++BUP7s4DNnP0OqKEaEjQVNPKB3nXwXL6cPtL3pfu1raoRaiz7xLswarDDFo+a/94PsYy1YDyRNKqYNzB1UyXaw77VF4eleq9pbwV5QY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NbTlLc/R; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NbTlLc/R"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDF97C4CEF1;
	Fri, 21 Nov 2025 13:22:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731378;
	bh=NeU+gv/RKV2M4SxXzQxnZhl3e7Y46iwVSD0ettK9neg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NbTlLc/R3JQ9caq1lrHb+PPpYylVfhwm76G+CcTiKNVI/LwBhqEsn1abMCbeO7dfL
	 L9Jxid17hy0WF3vs5LBg6zKHoswkgu2nOVnkHIEARkqC0RfPCvTZRGf5HEJCvEUNLA
	 3IvhUZ+hunafGBWvS3f0LL65/DuSfiMViU2QXpIw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kairui Song <kasong@tencent.com>,
	David Hildenbrand <david@redhat.com>,
	Zi Yan <ziy@nvidia.com>,
	Baolin Wang <baolin.wang@linux.alibaba.com>,
	Barry Song <baohua@kernel.org>,
	Lorenzo Stoakes <lorenzo.stoakes@oracle.com>,
	Dev Jain <dev.jain@arm.com>,
	Hugh Dickins <hughd@google.com>,
	Liam Howlett <liam.howlett@oracle.com>,
	"Matthew Wilcox (Oracle)" <willy@infradead.org>,
	Nico Pache <npache@redhat.com>,
	Ryan Roberts <ryan.roberts@arm.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.17 186/247] mm/shmem: fix THP allocation and fallback loop
Date: Fri, 21 Nov 2025 14:12:13 +0100
Message-ID: <20251121130201.399038407@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130154.587656062@linuxfoundation.org>
References: <20251121130154.587656062@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kairui Song <kasong@tencent.com>

commit fc745ff317566ec299e16346ebb9eacc8fe5b9d2 upstream.

The order check and fallback loop is updating the index value on every
loop.  This will cause the index to be wrongly aligned by a larger value
while the loop shrinks the order.

This may result in inserting and returning a folio of the wrong index and
cause data corruption with some userspace workloads [1].

[kasong@tencent.com: introduce a temporary variable to improve code]
  Link: https://lkml.kernel.org/r/20251023065913.36925-1-ryncsn@gmail.com
  Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Link: https://lkml.kernel.org/r/20251022105719.18321-1-ryncsn@gmail.com
Link: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/ [1]
Fixes: e7a2ab7b3bb5 ("mm: shmem: add mTHP support for anonymous shmem")
Closes: https://lore.kernel.org/linux-mm/CAMgjq7DqgAmj25nDUwwu1U2cSGSn8n4-Hqpgottedy0S6YYeUw@mail.gmail.com/
Signed-off-by: Kairui Song <kasong@tencent.com>
Acked-by: David Hildenbrand <david@redhat.com>
Acked-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Baolin Wang <baolin.wang@linux.alibaba.com>
Reviewed-by: Barry Song <baohua@kernel.org>
Reviewed-by: Lorenzo Stoakes <lorenzo.stoakes@oracle.com>
Cc: Dev Jain <dev.jain@arm.com>
Cc: Hugh Dickins <hughd@google.com>
Cc: Liam Howlett <liam.howlett@oracle.com>
Cc: Matthew Wilcox (Oracle) <willy@infradead.org>
Cc: Nico Pache <npache@redhat.com>
Cc: Ryan Roberts <ryan.roberts@arm.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/shmem.c |    9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

--- a/mm/shmem.c
+++ b/mm/shmem.c
@@ -1919,6 +1919,7 @@ static struct folio *shmem_alloc_and_add
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
+	pgoff_t aligned_index;
 	long pages;
 	int error, order;
 
@@ -1932,10 +1933,12 @@ static struct folio *shmem_alloc_and_add
 		order = highest_order(suitable_orders);
 		while (suitable_orders) {
 			pages = 1UL << order;
-			index = round_down(index, pages);
-			folio = shmem_alloc_folio(gfp, order, info, index);
-			if (folio)
+			aligned_index = round_down(index, pages);
+			folio = shmem_alloc_folio(gfp, order, info, aligned_index);
+			if (folio) {
+				index = aligned_index;
 				goto allocated;
+			}
 
 			if (pages == HPAGE_PMD_NR)
 				count_vm_event(THP_FILE_FALLBACK);


