Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 232291FB7
	for <patches@lists.linux.dev>; Fri, 25 Mar 2022 01:09:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C606CC340EE;
	Fri, 25 Mar 2022 01:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linux-foundation.org;
	s=korg; t=1648170554;
	bh=T/QhIXGZA5VSUF/4RnuDzp+8eXKhoSwVd9XJvRG7tso=;
	h=Date:To:From:In-Reply-To:Subject:From;
	b=Y+vgRHansBpnaZ0EaZVDPlHe5MmpPBPM/JSpKeUAbDMqG/ff8MLJb0L9avL0SpnsO
	 f6PAl1URnClT302mjGz54k65x90BzEH3FNRXZakocjXV4hLsX9cFEr6Tio0xe2ksnp
	 Bxjbv4m7Lafj36O0+eiM3tRzuxM1+9cgoprJdgOw=
Date: Thu, 24 Mar 2022 18:09:14 -0700
To: longman@redhat.com,aquini@redhat.com,caoyixuan2019@email.szu.edu.cn,akpm@linux-foundation.org,patches@lists.linux.dev,linux-mm@kvack.org,mm-commits@vger.kernel.org,torvalds@linux-foundation.org,akpm@linux-foundation.org
From: Andrew Morton <akpm@linux-foundation.org>
In-Reply-To: <20220324180758.96b1ac7e17675d6bc474485e@linux-foundation.org>
Subject: [patch 013/114] mm/page_owner.c: record tgid
Message-Id: <20220325010914.C606CC340EE@smtp.kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>

From: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Subject: mm/page_owner.c: record tgid

In a single-threaded process, the pid in kernel task_struct is the same as
the tgid, which can mark the process of page allocation.  But in a
multithreaded process, only the task_struct of the thread leader has the
same pid as tgid, and the pids of other threads are different from tgid. 
Therefore, tgid is recorded to provide effective information for debugging
and data statistics of multithreaded programs.

This can also be achieved by observing the task name (executable file
name) for a specific process.  However, when the same program is started
multiple times, the task name is the same and the tgid is different. 
Therefore, in the debugging of multi-threaded programs, combined with the
task name and tgid, more accurate runtime information of a certain run of
the program can be obtained.

Link: https://lkml.kernel.org/r/20220219180450.2399-1-caoyixuan2019@email.szu.edu.cn
Signed-off-by: Yixuan Cao <caoyixuan2019@email.szu.edu.cn>
Cc: Waiman Long <longman@redhat.com>
Cc: Rafael Aquini <aquini@redhat.com>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
---

 mm/page_owner.c |   16 ++++++++++------
 1 file changed, 10 insertions(+), 6 deletions(-)

--- a/mm/page_owner.c~mm-page_ownerc-record-tgid
+++ a/mm/page_owner.c
@@ -31,6 +31,7 @@ struct page_owner {
 	u64 free_ts_nsec;
 	char comm[TASK_COMM_LEN];
 	pid_t pid;
+	pid_t tgid;
 };
 
 static bool page_owner_enabled = false;
@@ -165,6 +166,7 @@ static inline void __set_page_owner_hand
 		page_owner->gfp_mask = gfp_mask;
 		page_owner->last_migrate_reason = -1;
 		page_owner->pid = current->pid;
+		page_owner->tgid = current->tgid;
 		page_owner->ts_nsec = local_clock();
 		strlcpy(page_owner->comm, current->comm,
 			sizeof(page_owner->comm));
@@ -233,6 +235,7 @@ void __folio_copy_owner(struct folio *ne
 		old_page_owner->last_migrate_reason;
 	new_page_owner->handle = old_page_owner->handle;
 	new_page_owner->pid = old_page_owner->pid;
+	new_page_owner->tgid = old_page_owner->tgid;
 	new_page_owner->ts_nsec = old_page_owner->ts_nsec;
 	new_page_owner->free_ts_nsec = old_page_owner->ts_nsec;
 	strcpy(new_page_owner->comm, old_page_owner->comm);
@@ -383,11 +386,11 @@ print_page_owner(char __user *buf, size_
 		return -ENOMEM;
 
 	ret = scnprintf(kbuf, count,
-			"Page allocated via order %u, mask %#x(%pGg), pid %d (%s), ts %llu ns, free_ts %llu ns\n",
+			"Page allocated via order %u, mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu ns, free_ts %llu ns\n",
 			page_owner->order, page_owner->gfp_mask,
 			&page_owner->gfp_mask, page_owner->pid,
-			page_owner->comm, page_owner->ts_nsec,
-			page_owner->free_ts_nsec);
+			page_owner->tgid, page_owner->comm,
+			page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	/* Print information relevant to grouping pages by mobility */
 	pageblock_mt = get_pageblock_migratetype(page);
@@ -454,10 +457,10 @@ void __dump_page_owner(const struct page
 	else
 		pr_alert("page_owner tracks the page as freed\n");
 
-	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d (%s), ts %llu, free_ts %llu\n",
+	pr_alert("page last allocated via order %u, migratetype %s, gfp_mask %#x(%pGg), pid %d, tgid %d (%s), ts %llu, free_ts %llu\n",
 		 page_owner->order, migratetype_names[mt], gfp_mask, &gfp_mask,
-		 page_owner->pid, page_owner->comm, page_owner->ts_nsec,
-		 page_owner->free_ts_nsec);
+		 page_owner->pid, page_owner->tgid, page_owner->comm,
+		 page_owner->ts_nsec, page_owner->free_ts_nsec);
 
 	handle = READ_ONCE(page_owner->handle);
 	if (!handle)
@@ -669,3 +672,4 @@ static int __init pageowner_init(void)
 	return 0;
 }
 late_initcall(pageowner_init)
+
_
