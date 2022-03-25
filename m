Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17B8F1FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D531DC340ED;
	Fri, 25 Mar 2022 01:09:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170551;
	bh=UKh0e02Rcyjz8mPR3OrTSiPGi5iSzsujvyZNy46XUG4=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=0d9WPI6IDtaHv1oJwJI0hsuBei/1jSdvIEZ8IUA3fNmLZTvtIOrTBjITV19c7aN1l
	 vXkR2DRUB0xjB2pWkJsQbxpS6IFCRkaNElFfC7o9e9uBaXsk8bON6hhrH8KeisIjz1
	 EkevZCRTRj+//KDyqV1/J5CTaAZOIi+TTjmNMB20=
Date: Thu, 24 Mar 2022 18:09:11 -0700
To: vdavydov.dev@gmail.com,senozhatsky@chromium.org,rppt@kernel.org,rostedt@goodmis.org,roman.gushchin@linux.dev,rientjes@google.com,pmladek@suse.com,mhocko@kernel.org,linux@rasmusvillemoes.dk,ira.weiny@intel.com,hannes@cmpxchg.org,aquini@redhat.com,andriy.shevchenko@linux.intel.com,longman@redhat.com,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 012/114] mm/page_owner: record task command name
Message-Id: <20220325010911.D531DC340ED@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Waiman Long <longman@redhat.com>
Subject: mm/page_owner: record task command name

The page_owner information currently includes the pid of the calling task.
That is useful as long as the task is still running.  Otherwise, the
number is meaningless.  To have more information about the allocating
tasks that had exited by the time the page_owner information is retrieved,
we need to store the command name of the task.

Add a new comm field into page_owner structure to store the command name
and display it when the page_owner information is retrieved.

Link: https://lkml.kernel.org/r/20220202203036.744010-5-longman@redhat.com
Signed-off-by: Waiman Long <longman@redhat.com>
Acked-by: Rafael Aquini <aquini@redhat.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc: David Rientjes <rientjes@google.com>
Cc: Ira Weiny <ira.weiny@intel.com>
Cc: Johannes Weiner <hannes@cmpxchg.org>
Cc: Michal Hocko <mhocko@kernel.org>
Cc: Mike Rapoport <rppt@kernel.org>
Cc: Petr Mladek <pmladek@suse.com>
Cc: Rasmus Villemoes <linux@rasmusvillemoes.dk>
Cc: Roman Gushchin <roman.gushchin@linux.dev>
Cc: Sergey Senozhatsky <senozhatsky@chromium.org>
Cc: Steven Rostedt (Google) <rostedt@goodmis.org>
Cc: Vladimir Davydov <vdavydov.dev@gmail.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/mm/page_owner.c~mm-page_owner-record-task-command-name
+++ a/mm/page_owner.c
@@ -29,6 +29,7 @@ struct page_owner {
 	depot_stack_handle_t free_handle;
 	u64 ts_nsec;
 	u64 free_ts_nsec;
+	char comm[TASK_COMM_LEN];
 	pid_t pid;
 };
 
@@ -165,6 +166,8 @@ static inline void __set_page_owner_hand
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
 		page_owner->ts_nsec = local_clock();
+		strlcpy(page_owner->comm, current->comm,
+			sizeof(page_owner->comm));
 		__set_bit(PAGE_EXT_OWNER, &page_ext->flags);
 		__set_bit(PAGE_EXT_OWNER_ALLOCATED, &page_ext->flags);
 
@@ -232,6 +235,7 @@ void __folio_copy_owner(struct folio *ne
 	new_page_owner->pid = old_page_owner->pid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
+	strcpy(new_page_owner->comm, old_page_owner->comm);
 
 	/*
 	 * We don't clear the bit on the old folio as it's going to be freed
@@ -379,10 +383,11 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d, ts %llu ns, free_ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d (%s), ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
-			page_owner->ts_nsec, page_owner->free_ts_nsec);
+			page_owner->comm, page_owner->ts_nsec,
+			page_owner->free_ts_nsec);
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
@@ -449,9 +454,10 @@ void __dump_page_owner(const struct page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d (%s), ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
-		 page_owner->pid, page_owner->ts_nsec, page_owner->free_ts_nsec);
+		 page_owner->pid, page_owner->comm, page_owner->ts_nsec,
+		 page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
_
