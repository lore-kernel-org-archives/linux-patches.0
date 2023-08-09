Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 24A0C17AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:23:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9C908C433C8;
	Wed,  9 Aug 2023 11:23:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580229;
	bh=2LYZImLbopMz0xKePqQyMrn1X79dByrN3Yiy3TuvH3k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rhWnkhbOfXEr5zxSDoy0odmF8DDowBmPFhwH8fTJe8dN9FNY2Tl8aa/f0bXqmM3cz
	 o1YAt+oPX8rDVto62U9VqkmbA2y4pdMHEaJ26qHpq86G0s8dUPD/RjUWw9ILgYM4f8
	 RK3dfWa+rumCTlyR7Qj3Eg6QNd/w0gtgfvG/ZJeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Steven Rostedt (VMware)" <rostedt@goodmis.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 233/323] ftrace: Store the order of pages allocated in ftrace_page
Date: Wed,  9 Aug 2023 12:41:11 +0200
Message-ID: <20230809103708.751582164@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
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

[ Upstream commit db42523b4f3e83ff86b53cdda219a9767c8b047f ]

Instead of saving the size of the records field of the ftrace_page, store
the order it uses to allocate the pages, as that is what is needed to know
in order to free the pages. This simplifies the code.

Link: https://lore.kernel.org/lkml/CAHk-=whyMxheOqXAORt9a7JK9gc9eHTgCJ55Pgs4p=X3RrQubQ@mail.gmail.com/

Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
[ change log written by Steven Rostedt ]
Signed-off-by: Steven Rostedt (VMware) <rostedt@goodmis.org>
Stable-dep-of: 26efd79c4624 ("ftrace: Fix possible warning on checking all pages used in ftrace_process_locs()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/trace/ftrace.c | 35 +++++++++++++++++------------------
 1 file changed, 17 insertions(+), 18 deletions(-)

diff --git a/kernel/trace/ftrace.c b/kernel/trace/ftrace.c
index 1b92a22086f50..6b1ba7f510e2c 100644
--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1124,7 +1124,7 @@ struct ftrace_page {
 	struct ftrace_page	*next;
 	struct dyn_ftrace	*records;
 	int			index;
-	int			size;
+	int			order;
 };
 
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
@@ -3045,7 +3045,7 @@ static int ftrace_allocate_records(struct ftrace_page *pg, int count)
 	ftrace_number_of_groups++;
 
 	cnt = (PAGE_SIZE << order) / ENTRY_SIZE;
-	pg->size = cnt;
+	pg->order = order;
 
 	if (cnt > count)
 		cnt = count;
@@ -3058,7 +3058,6 @@ ftrace_allocate_pages(unsigned long num_to_init)
 {
 	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
-	int order;
 	int cnt;
 
 	if (!num_to_init)
@@ -3094,13 +3093,13 @@ ftrace_allocate_pages(unsigned long num_to_init)
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
@@ -5642,6 +5641,7 @@ static int ftrace_process_locs(struct module *mod,
 	p = start;
 	pg = start_pg;
 	while (p < end) {
+		unsigned long end_offset;
 		addr = ftrace_call_adjust(*p++);
 		/*
 		 * Some architecture linkers will pad between
@@ -5652,7 +5652,8 @@ static int ftrace_process_locs(struct module *mod,
 		if (!addr)
 			continue;
 
-		if (pg->index == pg->size) {
+		end_offset = (pg->index+1) * sizeof(pg->records[0]);
+		if (end_offset > PAGE_SIZE << pg->order) {
 			/* We should have allocated enough */
 			if (WARN_ON(!pg->next))
 				break;
@@ -5792,7 +5793,6 @@ void ftrace_release_mod(struct module *mod)
 	struct ftrace_page **last_pg;
 	struct ftrace_page *tmp_page = NULL;
 	struct ftrace_page *pg;
-	int order;
 
 	mutex_lock(&ftrace_lock);
 
@@ -5843,12 +5843,12 @@ void ftrace_release_mod(struct module *mod)
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
@@ -6155,7 +6155,6 @@ void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
 	struct ftrace_mod_map *mod_map = NULL;
 	struct ftrace_init_func *func, *func_next;
 	struct list_head clear_hash;
-	int order;
 
 	INIT_LIST_HEAD(&clear_hash);
 
@@ -6193,10 +6192,10 @@ void ftrace_free_mem(struct module *mod, void *start_ptr, void *end_ptr)
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
-- 
2.39.2



