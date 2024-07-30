Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B7291A76A1;
	Tue, 30 Jul 2024 17:24:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722360271; cv=none; b=SC1NliF7p56bfKR8O4+I6rUrtMv2qg4oSWlmKlY8PBVrB5kQ6Nwldd6SZeQfF9yLAPoGB7z+Ni1w3V+jGUG43ayF4vIZ5xE6HHbPiDDWBwrqZLnQ2WJ8fxkTqBu9vr8miVEbcFED0KRKAam1K3vn4wgOcUCMGfuhusu0DIyBGT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722360271; c=relaxed/simple;
	bh=vRfJ9OYSSWWq676kr3lTH57GYgCj0qGOVaSmdzzT0ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k0ZSBR7SOtRaBK1WaaWUf9fth49SYDz0Zo+lA6SdTQwXTUcJKxhXo8XkO9PH57cxQO5o6oQ8mOa3HERYfYsnKZJihI30OxNEQX6N0E3oj41gZdHeOQlnYOP9WxZSEoOwRTFc/eJRFgM6FN/wjFYlNVje2tYwU7RQvyIwj3bS98M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AbjNlOtE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AbjNlOtE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92688C32782;
	Tue, 30 Jul 2024 17:24:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722360271;
	bh=vRfJ9OYSSWWq676kr3lTH57GYgCj0qGOVaSmdzzT0ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AbjNlOtEyLbv+DP/FGH+FJM88ZX4ypeOb2htBSNuG8dfn603n9uaK8o43Kayo75Lr
	 EsEt/Sn6SswQ9xY7yBuCm0Y+aYDidOzWjAwXmHeyryvJ0zAN6954V/u4779Lq8Z9/Y
	 bQmj4MJbyjHNmZhYgsOPCC06O5AOMghCkkpe7IJk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Li Zhijian <lizhijian@fujitsu.com>,
	Yao Xingtao <yaoxt.fnst@fujitsu.com>,
	Vlastimil Babka <vbabka@suse.cz>,
	David Hildenbrand <david@redhat.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.10 648/809] mm/page_alloc: fix pcp->count race between drain_pages_zone() vs __rmqueue_pcplist()
Date: Tue, 30 Jul 2024 17:48:44 +0200
Message-ID: <20240730151750.467990238@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Li Zhijian <lizhijian@fujitsu.com>

commit 66eca1021a42856d6af2a9802c99e160278aed91 upstream.

It's expected that no page should be left in pcp_list after calling
zone_pcp_disable() in offline_pages().  Previously, it's observed that
offline_pages() gets stuck [1] due to some pages remaining in pcp_list.

Cause:
There is a race condition between drain_pages_zone() and __rmqueue_pcplist()
involving the pcp->count variable. See below scenario:

         CPU0                              CPU1
    ----------------                    ---------------
                                      spin_lock(&pcp->lock);
                                      __rmqueue_pcplist() {
zone_pcp_disable() {
                                        /* list is empty */
                                        if (list_empty(list)) {
                                          /* add pages to pcp_list */
                                          alloced = rmqueue_bulk()
  mutex_lock(&pcp_batch_high_lock)
  ...
  __drain_all_pages() {
    drain_pages_zone() {
      /* read pcp->count, it's 0 here */
      count = READ_ONCE(pcp->count)
      /* 0 means nothing to drain */
                                          /* update pcp->count */
                                          pcp->count += alloced << order;
      ...
                                      ...
                                      spin_unlock(&pcp->lock);

In this case, after calling zone_pcp_disable() though, there are still some
pages in pcp_list. And these pages in pcp_list are neither movable nor
isolated, offline_pages() gets stuck as a result.

Solution:
Expand the scope of the pcp->lock to also protect pcp->count in
drain_pages_zone(), to ensure no pages are left in the pcp list after
zone_pcp_disable()

[1] https://lore.kernel.org/linux-mm/6a07125f-e720-404c-b2f9-e55f3f166e85@fujitsu.com/

Link: https://lkml.kernel.org/r/20240723064428.1179519-1-lizhijian@fujitsu.com
Fixes: 4b23a68f9536 ("mm/page_alloc: protect PCP lists with a spinlock")
Signed-off-by: Li Zhijian <lizhijian@fujitsu.com>
Reported-by: Yao Xingtao <yaoxt.fnst@fujitsu.com>
Reviewed-by: Vlastimil Babka <vbabka@suse.cz>
Cc: David Hildenbrand <david@redhat.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 mm/page_alloc.c |   18 +++++++++++-------
 1 file changed, 11 insertions(+), 7 deletions(-)

--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2323,16 +2323,20 @@ void drain_zone_pages(struct zone *zone,
 static void drain_pages_zone(unsigned int cpu, struct zone *zone)
 {
 	struct per_cpu_pages *pcp = per_cpu_ptr(zone->per_cpu_pageset, cpu);
-	int count = READ_ONCE(pcp->count);
-
-	while (count) {
-		int to_drain = min(count, pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
-		count -= to_drain;
+	int count;
 
+	do {
 		spin_lock(&pcp->lock);
-		free_pcppages_bulk(zone, to_drain, pcp, 0);
+		count = pcp->count;
+		if (count) {
+			int to_drain = min(count,
+				pcp->batch << CONFIG_PCP_BATCH_SCALE_MAX);
+
+			free_pcppages_bulk(zone, to_drain, pcp, 0);
+			count -= to_drain;
+		}
 		spin_unlock(&pcp->lock);
-	}
+	} while (count);
 }
 
 /*


