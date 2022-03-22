Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E2A6453
	for <patches@lists.linux.dev>; Tue, 22 Mar 2022 21:43:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FFC5C340EC;
	Tue, 22 Mar 2022 21:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1647985419;
	bh=1sREwPqsoklvKO9TTinMABRXKUs84U+dTlddvMWZ4Sk=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=QgJAwkajMt1MxK3aqVK3NEFE90p6sL9qzBbvM9GDkcTpawj0lNzhzfO5AinhNevqW
	 fgfQZVTMDrLnaDNl94FS025UuK4e4fFuWd9TDPdnE+8Uxi5CZLJtRk8KjXQZL0z6OH
	 7Lj1YDWcH3zGN2IFMh5234CxObWx+W8Axopzg0xI=
Date: Tue, 22 Mar 2022 14:43:38 -0700
To: vbabka@suse.cz,mhocko@kernel.org,dave.hansen@linux.intel.com,brouer@redhat.com,aaron.lu@intel.com,mgorman@techsingularity.net,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220322143803.04a5e59a07e48284f196a2f9@linux-foundation.org>
Subject: [patch 101/227] mm/page_alloc: drain the requested list first during bulk free
Message-Id: <20220322214339.8FFC5C340EC@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Mel Gorman <mgorman@techsingularity.net>
Subject: mm/page_alloc: drain the requested list first during bulk free

Prior to the series, pindex 0 (order-0 MIGRATE_UNMOVABLE) was always
skipped first and the precise reason is forgotten.  A potential reason may
have been to artificially preserve MIGRATE_UNMOVABLE but there is no
reason why that would be optimal as it depends on the workload.  The more
likely reason is that it was less complicated to do a pre-increment
instead of a post-increment in terms of overall code flow.  As
free_pcppages_bulk() now typically receives the pindex of the PCP list
that exceeded high, always start draining that list.

Link: https://lkml.kernel.org/r/20220217002227.5739-5-mgorman@techsingularity.net
Signed-off-by: Mel Gorman <mgorman@techsingularity.net>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Tested-by: Aaron Lu <aaron.lu@intel.com>
Cc: Dave Hansen <dave.hansen@linux.intel.com>
Cc: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: Michal Hocko <mhocko@kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_alloc.c |    4 ++++
 1 file changed, 4 insertions(+)

--- a/mm/page_alloc.c~mm-page_alloc-drain-the-requested-list-first-during-bulk-free
+++ a/mm/page_alloc.c
@@ -1460,6 +1460,10 @@ static void free_pcppages_bulk(struct zo
 	 * below while (list_empty(list)) loop.
 	 */
 	count = min(pcp->count, count);
+
+	/* Ensure requested pindex is drained first. */
+	pindex = pindex - 1;
+
 	while (count > 0) {
 		struct list_head *list;
 		int nr_pages;
_
