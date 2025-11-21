Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D8A0126CE33;
	Fri, 21 Nov 2025 13:33:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763732013; cv=none; b=lT7/oYS+XdDisHjovwYySFPvK16GZ+moOzxN6cYdnBV280ejY5Ka/EHEivYdpJ9JcQ2ztwbuzpjw1t09GQuGqCtGOpz/1+QEUjsuxMgjFQ1nDKGLMBPCFtXGo6J+mODViTYyHmFY6ILH3S3tYOXongPRx8kxjn7apYlfHziz1zo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763732013; c=relaxed/simple;
	bh=NQ4twKWoVLB6Jrq6Kw4iTCP4uP8HHZK+EjF8tA62n3I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eKIEIptbXrJolR5J8WZ+qdccCt6KMUHJ5tSeuw+MZIqU0nzRO8Z0WowHrHVVnKj2H1ZwIaSHi8w0QH3/5upUwQqOLxhwfAPbtDP0Hy+jm0MNpKAm3akLPt16fSUGYm/g8YDJG02V7pbmsn62IOLHRl1b8AHnVUWatKRJgC8KlFg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i9Xd9u8b; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i9Xd9u8b"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDA43C4CEF1;
	Fri, 21 Nov 2025 13:33:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763732013;
	bh=NQ4twKWoVLB6Jrq6Kw4iTCP4uP8HHZK+EjF8tA62n3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i9Xd9u8bmIRjQe0UbF2DJz9qhkbazc4bIrLI0feeSGZmtLZmkxtX6xQMJqHXABo5F
	 gncLt7qXD8HVEVUlv90OMmTKRT/6zW/lkL5jpf9AFT4XEgH6Bbp9et2IP1jrBZ0lu9
	 x0Gxan3hICPHdkShaBIMp9OjPinQV8uFBBEtbzT8=
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
Subject: [PATCH 6.12 126/185] mm/shmem: fix THP allocation and fallback loop
Date: Fri, 21 Nov 2025 14:12:33 +0100
Message-ID: <20251121130148.422647467@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1785,6 +1785,7 @@ static struct folio *shmem_alloc_and_add
 	struct shmem_inode_info *info = SHMEM_I(inode);
 	unsigned long suitable_orders = 0;
 	struct folio *folio = NULL;
+	pgoff_t aligned_index;
 	long pages;
 	int error, order;
 
@@ -1798,10 +1799,12 @@ static struct folio *shmem_alloc_and_add
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


