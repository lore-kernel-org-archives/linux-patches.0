Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DD7BF1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:34:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60FC3C433C7;
	Tue, 25 Jul 2023 11:34:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284860;
	bh=nFF++ixhHHV/4D1GpKIugpJ9MNKMgHz3YXbr6CN3qn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=us3CxV+LAqgPmPtpcJTeR5Ax+R+y4tq1Odw42tM4ihdydnm6KjK18R8HjY4hnE12Q
	 QB1dlEjrkVaxIt9eFu2SMdAXG6eqSRk7ISEBxPB/jzALpg+8XYAMql+rejupFMWnj1
	 yA/LDqZLNkM9nu70BifpD5trMZmQbaapkECbaezk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 5.10 508/509] ftrace: Store the order of pages allocated in ftrace_page
Date: Tue, 25 Jul 2023 12:47:27 +0200
Message-ID: <20230725104616.979249367@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104553.588743331@linuxfoundation.org>
References: <20230725104553.588743331@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Linus Torvalds <torvalds@linux-foundation.org>

commit db42523b4f3e83ff86b53cdda219a9767c8b047f upstream.

Instead of saving the size of the records field of the ftrace_page, store
the order it uses to allocate the pages, as that is what is needed to know
in order to free the pages. This simplifies the code.

Link: https://lore.kernel.org/lkml/CAHk-=whyMxheOqXAORt9a7JK9gc9eHTgCJ55Pgs4p=X3RrQubQ@mail.gmail.com/

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ change log written by Steven Rostedt ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1091,7 +1091,7 @@ struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
 	int			index;
-	int			size;
+	int			order;
 };
 
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
@@ -3188,7 +3188,7 @@ static int ftrace_allocate_records(struc
 	ftrace_number_of_groups++;
 
 	cnt = (PAGE_SIZE << order) / ENTRY_SIZE;
-	pg->size = cnt;
+	pg->order = order;
 
 	if (cnt > count)
 		cnt = count;
@@ -3201,7 +3201,6 @@ ftrace_allocate_pages(unsigned long num_
 {
 	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
-	int order;
 	int cnt;
 
 	if (!num_to_init)
@@ -3237,13 +3236,13 @@ ftrace_allocate_pages(unsigned long num_
  free_pages:
 	pg = start_pg;
 	while (pg) {
-		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		if (order >= 0)
-			free_pages((unsigned long)pg->records, order);
+		if (pg->records) {
+			free_pages((unsigned long)pg->records, pg->order);
+			ftrace_number_of_pages -= 1 << pg->order;
+		}
 		start_pg = pg->next;
 		kfree(pg);
 		pg = start_pg;
-		ftrace_number_of_pages -= 1 << order;
 		ftrace_number_of_groups--;
 	}
 	pr_info("ftrace: FAILED to allocate memory for functions\n");
@@ -6239,6 +6238,7 @@ static int ftrace_process_locs(struct mo
 	p = start;
 	pg = start_pg;
 	while (p < end) {
+		unsigned long end_offset;
 		addr = ftrace_call_adjust(*p++);
 		/*
 		 * Some architecture linkers will pad between
@@ -6249,7 +6249,8 @@ static int ftrace_process_locs(struct mo
 		if (!addr)
 			continue;
 
-		if (pg->index == pg->size) {
+		end_offset = (pg->index+1) * sizeof(pg->records[0]);
+		if (end_offset > PAGE_SIZE << pg->order) {
 			/* We should have allocated enough */
 			if (WARN_ON(!pg->next))
 				break;
@@ -6418,7 +6419,6 @@ void ftrace_release_mod(struct module *m
 	struct ftrace_page **last_pg;
 	struct ftrace_page *tmp_page = NULL;
 	struct ftrace_page *pg;
-	int order;
 
 	mutex_lock(&ftrace_lock);
 
@@ -6469,12 +6469,12 @@ void ftrace_release_mod(struct module *m
 		/* Needs to be called outside of ftrace_lock */
 		clear_mod_from_hashes(pg);
 
-		order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-		if (order >= 0)
-			free_pages((unsigned long)pg->records, order);
+		if (pg->records) {
+			free_pages((unsigned long)pg->records, pg->order);
+			ftrace_number_of_pages -= 1 << pg->order;
+		}
 		tmp_page = pg->next;
 		kfree(pg);
-		ftrace_number_of_pages -= 1 << order;
 		ftrace_number_of_groups--;
 	}
 }
@@ -6792,7 +6792,6 @@ void ftrace_free_mem(struct module *mod,
 	struct ftrace_mod_map *mod_map = NULL;
 	struct ftrace_init_func *func, *func_next;
 	struct list_head clear_hash;
-	int order;
 
 	INIT_LIST_HEAD(&clear_hash);
 
@@ -6830,10 +6829,10 @@ void ftrace_free_mem(struct module *mod,
 		ftrace_update_tot_cnt--;
 		if (!pg->index) {
 			*last_pg = pg->next;
-			order = get_count_order(pg->size / ENTRIES_PER_PAGE);
-			if (order >= 0)
-				free_pages((unsigned long)pg->records, order);
-			ftrace_number_of_pages -= 1 << order;
+			if (pg->records) {
+				free_pages((unsigned long)pg->records, pg->order);
+				ftrace_number_of_pages -= 1 << pg->order;
+			}
 			ftrace_number_of_groups--;
 			kfree(pg);
 			pg = container_of(last_pg, struct ftrace_page, next);


