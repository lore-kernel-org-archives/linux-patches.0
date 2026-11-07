Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794064452;
	b=oSN/0oRv8uW/wWXMilqzsglqp3R76PCnSxS3goB4h1FCjKp/y+eht3IDBiaBmJ6e/CtF
	 5CYoRqaY8Vpg3GAXw5EdW+c76gFn21QwGmIvqAnkXIY6fYq9UMO+AHQ31ZHjvJnkR0L+u
	 IPRrbJ9cJISFhGpoNvJSjJdyf8eM/yWB4whjMIU8dlFaAswNCmfz/Dch5hKRUmjrtk4rV
	 hD7xTj8ze+zzF4WJE+JLfQxUlDDG15gWRaAsPgkF7D27oVtqitVLH5/acgoP8P6vuqr5q
	 HEF0AEjxL8tL+QMZe9hXXBYoR8Wvd6A8zr23MpO4474SY2iXlD7ac+Uo3aRlJ3lhraw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794064452;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=KHfWLVZuEZ9tbL1pFZX84Ol3km1Fjoh2YY4JKMp48R0=;
	b=tDhrr4zQ1Hwx9G7UWT1j/ChhvsUsoiZchKU6EIcV7bzoVZWTd6DnsaKAS3ivqVe6LXCu
	 1/fp603linx5eTmzSA8caPcBbDWPsAsEIXlfPz6nPPeAfLX1GwvJGJbXT5bqqkkU1gwLz
	 0irohiwPmUIvjfjz9ZRo8crbtF0d4M7iOOPCf/mVCOTqOb7ZNZ2MrHLRbJWDHjnuchVVZ
	 VYL2T2vrRzLmb1Zj8WWEEDSpTdhAfho+H/WSqyWdogo8XpZjaU/leW3MMoUGg98KB8sfy
	 1eqBQbpGkhfRWASDkW8oBSyqBOVWhYkQksFd1EbJkKOFUfMAo2encUkFLZ+VX0CbDjA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImKZtGCI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A4968606EEB5;
	Sat,  7 Nov 2026 15:14:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=ImKZtGCI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 55E951F008AB;
	Sat,  7 Nov 2026 15:14:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794064451;
	bh=KHfWLVZuEZ9tbL1pFZX84Ol3km1Fjoh2YY4JKMp48R0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ImKZtGCIXKcedhwTAKjsLAZXHaqZ3kbLxhxQfyUyg/vVpG58goxOXjhoRllkxldwi
	 BD0cXsA9IpbMpTLkWV+8YE+LfMZzHm6z6twqk74b6h/TiSq+TGfuzgPWcGSNPa+MmC
	 yGoWO+GxWGhDXWmadVTrxKws4mwWDuZprjry61x0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qi Xi <xiqi2@huawei.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Zi Yan <ziy@nvidia.com>,
	Brendan Jackman <brendan.jackman@linux.dev>,
	Johannes Weiner <hannes@cmpxchg.org>,
	Kefeng Wang <wangkefeng.wang@huawei.com>,
	Michal Hocko <mhocko@suse.com>,
	Nanyong Sun <sunnanyong@huawei.com>,
	Suren Baghdasaryan <surenb@google.com>,
	Vlastimil Babka <vbabka@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 0494/1257] mm/page_isolation: guard compound_order() against racing
Date: Sat,  7 Nov 2026 08:46:30 -0500
Message-ID: <20261107134953.081927084@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

From: Qi Xi <xiqi2@huawei.com>

[ Upstream commit 4c767c5dd9bc3521fed11e6fe1d52621fe5abf7b ]

The PageCompound branch reads compound_head() without holding a reference.
A racing split or free can cause compound_head() to return a stale
pointer, and compound_nr() reads the order from that stale head, leading
to out-of-range shifts and making the skip distance meaningless.

Read the order explicitly with compound_order() and validate it is within
MAX_FOLIO_ORDER before shifting.  Also verify the derived head_pfn against
the legitimate pfn: the head must not be past pfn, must be aligned to
nr_pages, and pfn must fall within the compound page.  Bail out with
-EBUSY if any check fails.

Link: https://lore.kernel.org/20260825120549.966271-3-xiqi2@huawei.com
Fixes: b2c9e2fbba32 ("mm: make alloc_contig_range work at pageblock granularity")
Signed-off-by: Qi Xi <xiqi2@huawei.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Suggested-by: Zi Yan <ziy@nvidia.com>
Reviewed-by: Zi Yan <ziy@nvidia.com>
Cc: Brendan Jackman <brendan.jackman@linux.dev>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Kefeng Wang <wangkefeng.wang@huawei.com>
Cc: Michal Hocko <mhocko@suse.com>
Cc: Nanyong Sun <sunnanyong@huawei.com>
Cc: Suren Baghdasaryan <surenb@google.com>
Cc: Vlastimil Babka <vbabka@kernel.org>
Cc: <stable@vger.kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 mm/page_isolation.c | 22 ++++++++++++++++++++--
 1 file changed, 20 insertions(+), 2 deletions(-)

diff --git a/mm/page_isolation.c b/mm/page_isolation.c
index e4ee998c00f3b..5aaad037384e4 100644
--- a/mm/page_isolation.c
+++ b/mm/page_isolation.c
@@ -419,10 +419,28 @@ static int isolate_single_pageblock(unsigned long boundary_pfn,
 		if (PageCompound(page)) {
 			struct page *head = compound_head(page);
 			unsigned long head_pfn = page_to_pfn(head);
-			unsigned long nr_pages = compound_nr(head);
+			unsigned int order = compound_order(head);
+			unsigned long nr_pages;
+
+			/* compound_order() is racy. Cap it at MAX_FOLIO_ORDER. */
+			if (order > MAX_FOLIO_ORDER)
+				goto failed;
+
+			nr_pages = 1UL << order;
+
+			/*
+			 * compound_head() is also racy, so the derived head_pfn
+			 * needs additional checks to make sure it is valid.
+			 * Otherwise, just fail the check. pfn comes from
+			 * __first_valid_page() as a legitimate PFN, so use it to
+			 * check head_pfn.
+			 */
+			if (head_pfn > pfn || !IS_ALIGNED(head_pfn, nr_pages) ||
+			    pfn - head_pfn >= nr_pages)
+				goto failed;
 
 			if (head_pfn + nr_pages <= boundary_pfn ||
-			    PageHuge(page)) {
+			    PageHuge(head)) {
 				pfn = head_pfn + nr_pages;
 				continue;
 			}
-- 
2.53.0



