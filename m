Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C07DC1ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:34:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C437C433C8;
	Tue, 25 Jul 2023 11:34:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690284863;
	bh=coAbf52WCRWqzTFA4dObFQZO+GMaXUyMy2H8GfOyIYI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Vfw8WJMKzCtizZBrP8PPB4hMi/JXOi9FleF2VWk5Vs3Vbove7RpsEewNGMs0wv724
	 IibdDHs56jcQEKJut/UIAFj1K1ZPMcHnrcE9Ouk0erb5u3FmpHqNFFYVNwOZlvqT9r
	 QvheHzLRMWJ6eLeHDVOhCGVzorIZADTq+hbf5LOA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Steven Rostedt <rostedt@goodmis.org>,
	Zheng Yejian <zhengyejian1@huawei.com>
Subject: [PATCH 5.10 509/509] ftrace: Fix possible warning on checking all pages used in ftrace_process_locs()
Date: Tue, 25 Jul 2023 12:47:28 +0200
Message-ID: <20230725104617.032266049@linuxfoundation.org>
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

From: Zheng Yejian <zhengyejian1@huawei.com>

commit 26efd79c4624294e553aeaa3439c646729bad084 upstream.

As comments in ftrace_process_locs(), there may be NULL pointers in
mcount_loc section:
 > Some architecture linkers will pad between
 > the different mcount_loc sections of different
 > object files to satisfy alignments.
 > Skip any NULL pointers.

After commit 20e5227e9f55 ("ftrace: allow NULL pointers in mcount_loc"),
NULL pointers will be accounted when allocating ftrace pages but skipped
before adding into ftrace pages, this may result in some pages not being
used. Then after commit 706c81f87f84 ("ftrace: Remove extra helper
functions"), warning may occur at:
  WARN_ON(pg->next);

To fix it, only warn for case that no pointers skipped but pages not used
up, then free those unused pages after releasing ftrace_lock.

Link: https://lore.kernel.org/linux-trace-kernel/20230712060452.3175675-1-zhengyejian1@huawei.com

Cc: stable@vger.kernel.org
Fixes: 706c81f87f84 ("ftrace: Remove extra helper functions")
Suggested-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   45 +++++++++++++++++++++++++++++++--------------
 1 file changed, 31 insertions(+), 14 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -3196,6 +3196,22 @@ static int ftrace_allocate_records(struc
 	return cnt;
 }
 
+static void ftrace_free_pages(struct ftrace_page *pages)
+{
+	struct ftrace_page *pg = pages;
+
+	while (pg) {
+		if (pg->records) {
+			free_pages((unsigned long)pg->records, pg->order);
+			ftrace_number_of_pages -= 1 << pg->order;
+		}
+		pages = pg->next;
+		kfree(pg);
+		pg = pages;
+		ftrace_number_of_groups--;
+	}
+}
+
 static struct ftrace_page *
 ftrace_allocate_pages(unsigned long num_to_init)
 {
@@ -3234,17 +3250,7 @@ ftrace_allocate_pages(unsigned long num_
 	return start_pg;
 
  free_pages:
-	pg = start_pg;
-	while (pg) {
-		if (pg->records) {
-			free_pages((unsigned long)pg->records, pg->order);
-			ftrace_number_of_pages -= 1 << pg->order;
-		}
-		start_pg = pg->next;
-		kfree(pg);
-		pg = start_pg;
-		ftrace_number_of_groups--;
-	}
+	ftrace_free_pages(start_pg);
 	pr_info("ftrace: FAILED to allocate memory for functions\n");
 	return NULL;
 }
@@ -6190,9 +6196,11 @@ static int ftrace_process_locs(struct mo
 			       unsigned long *start,
 			       unsigned long *end)
 {
+	struct ftrace_page *pg_unuse = NULL;
 	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
 	struct dyn_ftrace *rec;
+	unsigned long skipped = 0;
 	unsigned long count;
 	unsigned long *p;
 	unsigned long addr;
@@ -6246,8 +6254,10 @@ static int ftrace_process_locs(struct mo
 		 * object files to satisfy alignments.
 		 * Skip any NULL pointers.
 		 */
-		if (!addr)
+		if (!addr) {
+			skipped++;
 			continue;
+		}
 
 		end_offset = (pg->index+1) * sizeof(pg->records[0]);
 		if (end_offset > PAGE_SIZE << pg->order) {
@@ -6261,8 +6271,10 @@ static int ftrace_process_locs(struct mo
 		rec->ip = addr;
 	}
 
-	/* We should have used all pages */
-	WARN_ON(pg->next);
+	if (pg->next) {
+		pg_unuse = pg->next;
+		pg->next = NULL;
+	}
 
 	/* Assign the last page to ftrace_pages */
 	ftrace_pages = pg;
@@ -6284,6 +6296,11 @@ static int ftrace_process_locs(struct mo
  out:
 	mutex_unlock(&ftrace_lock);
 
+	/* We should have used all pages unless we skipped some */
+	if (pg_unuse) {
+		WARN_ON(!skipped);
+		ftrace_free_pages(pg_unuse);
+	}
 	return ret;
 }
 


