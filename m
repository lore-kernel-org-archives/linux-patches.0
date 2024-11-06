Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 687471DE2CF;
	Wed,  6 Nov 2024 13:22:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730899324; cv=none; b=Ec8WVUkqBRaoM/zN0MfjmzKe7009ujGAkj3gL53NWfTH5QD1qvcZx99uZgnIQdzq8FW1J9jtd5086VmwZQhj2gmV6wa1pYpTOAHOLEmkpz+C1SQM2twO1U6b/U0JiLSfuqLxb8ieQmXMvjbODDpaPOGXww0UXZqwuzgwBEEzrB4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730899324; c=relaxed/simple;
	bh=RiZle8LVp0NQvNPFc0OEtxIE/rPTdQk4RzRFNruzVDQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XLAya8fIuF6gW6v2d+V9CjO6Rv6Eg3TXG6c4+VmQ6rP3hl0AQYMhCWnGyx3gY9mzTdqVRE6Ew47bLEmDUMsxwvuU7e+z6BVom9Ba1ZJByC/Sjlyc5QzbJXA/A/S0MIimF/RaK7NULgvu3e3vUD912a8scOy8FNv11bvLQXMBsos=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfFDpRg1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfFDpRg1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E42FFC4CECD;
	Wed,  6 Nov 2024 13:22:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730899324;
	bh=RiZle8LVp0NQvNPFc0OEtxIE/rPTdQk4RzRFNruzVDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfFDpRg1JHYdineVkW6nUmvQt+cEoxX2x1Dn98hLmjdmGIdaiXYuVAuUJWaJcIBvI
	 S+LlZAs+bkOdaZfx7X3wz95vtlebSzG12gX22r/MR0xeG27KR/jS5qER43CYAg9hj7
	 nq23rxhtgOuE6/NRt0jEZ4BWCw2+NDQI3DEe6fhE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wonhyuk Yang <vvghjk1234@gmail.com>,
	Mel Gorman <mgorman@suse.de>,
	Baik Song An <bsahn@etri.re.kr>,
	Hong Yeon Kim <kimhy@etri.re.kr>,
	Taeung Song <taeung@reallinux.co.kr>,
	linuxgeek@linuxgeek.io,
	Steven Rostedt <rostedt@goodmis.org>,
	Ingo Molnar <mingo@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 57/73] mm/page_alloc: fix tracepoint mm_page_alloc_zone_locked()
Date: Wed,  6 Nov 2024 13:06:01 +0100
Message-ID: <20241106120301.658501070@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120259.955073160@linuxfoundation.org>
References: <20241106120259.955073160@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wonhyuk Yang <vvghjk1234@gmail.com>

[ Upstream commit 10e0f7530205799e7e971aba699a7cb3a47456de ]

Currently, trace point mm_page_alloc_zone_locked() doesn't show correct
information.

First, when alloc_flag has ALLOC_HARDER/ALLOC_CMA, page can be allocated
from MIGRATE_HIGHATOMIC/MIGRATE_CMA.  Nevertheless, tracepoint use
requested migration type not MIGRATE_HIGHATOMIC and MIGRATE_CMA.

Second, after commit 44042b4498728 ("mm/page_alloc: allow high-order pages
to be stored on the per-cpu lists") percpu-list can store high order
pages.  But trace point determine whether it is a refiil of percpu-list by
comparing requested order and 0.

To handle these problems, make mm_page_alloc_zone_locked() only be called
by __rmqueue_smallest with correct migration type.  With a new argument
called percpu_refill, it can show roughly whether it is a refill of
percpu-list.

Link: https://lkml.kernel.org/r/20220512025307.57924-1-vvghjk1234@gmail.com
Signed-off-by: Wonhyuk Yang <vvghjk1234@gmail.com>
Acked-by: Mel Gorman <mgorman@suse.de>
Cc: Baik Song An <bsahn@etri.re.kr>
Cc: Hong Yeon Kim <kimhy@etri.re.kr>
Cc: Taeung Song <taeung@reallinux.co.kr>
Cc: <linuxgeek@linuxgeek.io>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Ingo Molnar <mingo@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Stable-dep-of: 281dd25c1a01 ("mm/page_alloc: let GFP_ATOMIC order-0 allocs access highatomic reserves")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/trace/events/kmem.h | 14 +++++++++-----
 mm/page_alloc.c             | 13 +++++--------
 2 files changed, 14 insertions(+), 13 deletions(-)

diff --git a/include/trace/events/kmem.h b/include/trace/events/kmem.h
index ddc8c944f417a..f89fb3afcd46a 100644
--- a/include/trace/events/kmem.h
+++ b/include/trace/events/kmem.h
@@ -229,20 +229,23 @@ TRACE_EVENT(mm_page_alloc,
 
 DECLARE_EVENT_CLASS(mm_page,
 
-	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype,
+		 int percpu_refill),
 
-	TP_ARGS(page, order, migratetype),
+	TP_ARGS(page, order, migratetype, percpu_refill),
 
 	TP_STRUCT__entry(
 		__field(	unsigned long,	pfn		)
 		__field(	unsigned int,	order		)
 		__field(	int,		migratetype	)
+		__field(	int,		percpu_refill	)
 	),
 
 	TP_fast_assign(
 		__entry->pfn		= page ? page_to_pfn(page) : -1UL;
 		__entry->order		= order;
 		__entry->migratetype	= migratetype;
+		__entry->percpu_refill	= percpu_refill;
 	),
 
 	TP_printk("page=%p pfn=0x%lx order=%u migratetype=%d percpu_refill=%d",
@@ -250,14 +253,15 @@ DECLARE_EVENT_CLASS(mm_page,
 		__entry->pfn != -1UL ? __entry->pfn : 0,
 		__entry->order,
 		__entry->migratetype,
-		__entry->order == 0)
+		__entry->percpu_refill)
 );
 
 DEFINE_EVENT(mm_page, mm_page_alloc_zone_locked,
 
-	TP_PROTO(struct page *page, unsigned int order, int migratetype),
+	TP_PROTO(struct page *page, unsigned int order, int migratetype,
+		 int percpu_refill),
 
-	TP_ARGS(page, order, migratetype)
+	TP_ARGS(page, order, migratetype, percpu_refill)
 );
 
 TRACE_EVENT(mm_page_pcpu_drain,
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 474150584ba48..264cb1914ab5b 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2461,6 +2461,9 @@ struct page *__rmqueue_smallest(struct zone *zone, unsigned int order,
 		del_page_from_free_list(page, zone, current_order);
 		expand(zone, page, order, current_order, migratetype);
 		set_pcppage_migratetype(page, migratetype);
+		trace_mm_page_alloc_zone_locked(page, order, migratetype,
+				pcp_allowed_order(order) &&
+				migratetype < MIGRATE_PCPTYPES);
 		return page;
 	}
 
@@ -2988,7 +2991,7 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 		    zone_page_state(zone, NR_FREE_PAGES) / 2) {
 			page = __rmqueue_cma_fallback(zone, order);
 			if (page)
-				goto out;
+				return page;
 		}
 	}
 retry:
@@ -3001,9 +3004,6 @@ __rmqueue(struct zone *zone, unsigned int order, int migratetype,
 								alloc_flags))
 			goto retry;
 	}
-out:
-	if (page)
-		trace_mm_page_alloc_zone_locked(page, order, migratetype);
 	return page;
 }
 
@@ -3708,11 +3708,8 @@ struct page *rmqueue(struct zone *preferred_zone,
 		 * reserved for high-order atomic allocation, so order-0
 		 * request should skip it.
 		 */
-		if (order > 0 && alloc_flags & ALLOC_HARDER) {
+		if (order > 0 && alloc_flags & ALLOC_HARDER)
 			page = __rmqueue_smallest(zone, order, MIGRATE_HIGHATOMIC);
-			if (page)
-				trace_mm_page_alloc_zone_locked(page, order, migratetype);
-		}
 		if (!page) {
 			page = __rmqueue(zone, order, migratetype, alloc_flags);
 			if (!page)
-- 
2.43.0



