Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 38348399CEE;
	Thu,  2 Jul 2026 16:39:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783010355; cv=none; b=Iu02ZNPt/yJaK7y3bWkmq3KxPqa4IUAS5KldUaMO9vwjQsOMKt/gN6OvUo4+5A9rLCUudDqU7K4SLWy6Nx0oVCAF5xap74qb2TrELAjWZf8RfEuwTo7rxHO5TKjTX/nzYJ3L+9OwV9cIuk543gIKrDUh3DJP9SuyotbPhN6ErlM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783010355; c=relaxed/simple;
	bh=TXlwlWXbhYWLzhzFaFaHv/5Fw4fKKXCXEmFkxeolxvU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PCK+r+gX7sLjjeHT8cqYFJmEt2qXI/BgjY1qxRbw48aHitfzqDzfcQQ8qBHXU3riJGruskmC0FkVAhZz6D/tqPLgODWZIRW5bOdLmoW6TdkJyKCBNvfL5xD3VrsTlyuOb3T6j4br5BVmf4BB0amLOVeetcoXso07/gDyGbG1fQw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eKodFgOP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eKodFgOP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622871F000E9;
	Thu,  2 Jul 2026 16:39:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783010353;
	bh=lbsEqmqGmBZ0TDwFIhL7jWOgeV5eqkp+uOmgPebegPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eKodFgOP8T+osnBDuofwCqGHgS2ktFyCpCd049hB/xhMZgg2db7E8MdgrT+gD0K9V
	 LxCwWNDAk+hN/Et4V7wR5fyG9li3cTU83qh0GeckfcB3Dih4TrfRu+mL3ggnkfqAq1
	 yPHUpzTiK1og6wGK0gf1CUXPj3iZ3G37ObI/54z8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Guenter Roeck <linux@roeck-us.net>,
	"Steven Rostedt (Google)" <rostedt@goodmis.org>,
	Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Subject: [PATCH 6.12 078/204] ftrace: Do not over-allocate ftrace memory
Date: Thu,  2 Jul 2026 18:18:55 +0200
Message-ID: <20260702155120.303532668@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155118.667618796@linuxfoundation.org>
References: <20260702155118.667618796@linuxfoundation.org>
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

From: Guenter Roeck <linux@roeck-us.net>

[ Upstream commit be55257fab181b93af38f8c4b1b3cb453a78d742 ]

The pg_remaining calculation in ftrace_process_locs() assumes that
ENTRIES_PER_PAGE multiplied by 2^order equals the actual capacity of the
allocated page group. However, ENTRIES_PER_PAGE is PAGE_SIZE / ENTRY_SIZE
(integer division). When PAGE_SIZE is not a multiple of ENTRY_SIZE (e.g.
4096 / 24 = 170 with remainder 16), high-order allocations (like 256 pages)
have significantly more capacity than 256 * 170. This leads to pg_remaining
being underestimated, which in turn makes skip (derived from skipped -
pg_remaining) larger than expected, causing the WARN(skip != remaining)
to trigger.

Extra allocated pages for ftrace: 2 with 654 skipped
WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:7295 ftrace_process_locs+0x5bf/0x5e0

A similar problem in ftrace_allocate_records() can result in allocating
too many pages. This can trigger the second warning in
ftrace_process_locs().

Extra allocated pages for ftrace
WARNING: CPU: 0 PID: 0 at kernel/trace/ftrace.c:7276 ftrace_process_locs+0x548/0x580

Use the actual capacity of a page group to determine the number of pages
to allocate. Have ftrace_allocate_pages() return the number of allocated
pages to avoid having to calculate it. Use the actual page group capacity
when validating the number of unused pages due to skipped entries.
Drop the definition of ENTRIES_PER_PAGE since it is no longer used.

Cc: stable@vger.kernel.org
Fixes: 4a3efc6baff93 ("ftrace: Update the mcount_loc check of skipped entries")
Link: https://patch.msgid.link/20260113152243.3557219-1-linux@roeck-us.net
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Steven Rostedt (Google) <rostedt@goodmis.org>
Signed-off-by: Andrey Grodzovsky <andrey.grodzovsky@crowdstrike.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/trace/ftrace.c |   29 +++++++++++++++--------------
 1 file changed, 15 insertions(+), 14 deletions(-)

--- a/kernel/trace/ftrace.c
+++ b/kernel/trace/ftrace.c
@@ -1122,7 +1122,6 @@ struct ftrace_page {
 };
 
 #define ENTRY_SIZE sizeof(struct dyn_ftrace)
-#define ENTRIES_PER_PAGE (PAGE_SIZE / ENTRY_SIZE)
 
 static struct ftrace_page	*ftrace_pages_start;
 static struct ftrace_page	*ftrace_pages;
@@ -3754,7 +3753,8 @@ static int ftrace_update_code(struct mod
 	return 0;
 }
 
-static int ftrace_allocate_records(struct ftrace_page *pg, int count)
+static int ftrace_allocate_records(struct ftrace_page *pg, int count,
+				   unsigned long *num_pages)
 {
 	int order;
 	int pages;
@@ -3764,7 +3764,7 @@ static int ftrace_allocate_records(struc
 		return -EINVAL;
 
 	/* We want to fill as much as possible, with no empty pages */
-	pages = DIV_ROUND_UP(count, ENTRIES_PER_PAGE);
+	pages = DIV_ROUND_UP(count * ENTRY_SIZE, PAGE_SIZE);
 	order = fls(pages) - 1;
 
  again:
@@ -3779,6 +3779,7 @@ static int ftrace_allocate_records(struc
 	}
 
 	ftrace_number_of_pages += 1 << order;
+	*num_pages += 1 << order;
 	ftrace_number_of_groups++;
 
 	cnt = (PAGE_SIZE << order) / ENTRY_SIZE;
@@ -3807,12 +3808,14 @@ static void ftrace_free_pages(struct ftr
 }
 
 static struct ftrace_page *
-ftrace_allocate_pages(unsigned long num_to_init)
+ftrace_allocate_pages(unsigned long num_to_init, unsigned long *num_pages)
 {
 	struct ftrace_page *start_pg;
 	struct ftrace_page *pg;
 	int cnt;
 
+	*num_pages = 0;
+
 	if (!num_to_init)
 		return NULL;
 
@@ -3826,7 +3829,7 @@ ftrace_allocate_pages(unsigned long num_
 	 * waste as little space as possible.
 	 */
 	for (;;) {
-		cnt = ftrace_allocate_records(pg, num_to_init);
+		cnt = ftrace_allocate_records(pg, num_to_init, num_pages);
 		if (cnt < 0)
 			goto free_pages;
 
@@ -7058,8 +7061,6 @@ static int ftrace_process_locs(struct mo
 	if (!count)
 		return 0;
 
-	pages = DIV_ROUND_UP(count, ENTRIES_PER_PAGE);
-
 	/*
 	 * Sorting mcount in vmlinux at build time depend on
 	 * CONFIG_BUILDTIME_MCOUNT_SORT, while mcount loc in
@@ -7072,7 +7073,7 @@ static int ftrace_process_locs(struct mo
 		test_is_sorted(start, count);
 	}
 
-	start_pg = ftrace_allocate_pages(count);
+	start_pg = ftrace_allocate_pages(count, &pages);
 	if (!start_pg)
 		return -ENOMEM;
 
@@ -7159,27 +7160,27 @@ static int ftrace_process_locs(struct mo
 	/* We should have used all pages unless we skipped some */
 	if (pg_unuse) {
 		unsigned long pg_remaining, remaining = 0;
-		unsigned long skip;
+		long skip;
 
 		/* Count the number of entries unused and compare it to skipped. */
-		pg_remaining = (ENTRIES_PER_PAGE << pg->order) - pg->index;
+		pg_remaining = (PAGE_SIZE << pg->order) / ENTRY_SIZE - pg->index;
 
 		if (!WARN(skipped < pg_remaining, "Extra allocated pages for ftrace")) {
 
 			skip = skipped - pg_remaining;
 
-			for (pg = pg_unuse; pg; pg = pg->next)
+			for (pg = pg_unuse; pg && skip > 0; pg = pg->next) {
 				remaining += 1 << pg->order;
+				skip -= (PAGE_SIZE << pg->order) / ENTRY_SIZE;
+			}
 
 			pages -= remaining;
 
-			skip = DIV_ROUND_UP(skip, ENTRIES_PER_PAGE);
-
 			/*
 			 * Check to see if the number of pages remaining would
 			 * just fit the number of entries skipped.
 			 */
-			WARN(skip != remaining, "Extra allocated pages for ftrace: %lu with %lu skipped",
+			WARN(pg || skip > 0, "Extra allocated pages for ftrace: %lu with %lu skipped",
 			     remaining, skipped);
 		}
 		/* Need to synchronize with ftrace_location_range() */


