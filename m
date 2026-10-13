Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AFF502D7380;
	Tue, 13 Oct 2026 12:11:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791893496; cv=none; b=pOzslapJlJYTrqNT0mpcimiPbJlMm8OV3pZAEuLGojSaGUmr5titlrq66NQ6u4EPVusNFyFcY3R8Df47ZYy+RjDWyM1nqdxwx8D62cY0+O6YFqoBQZdHCkVNiIQM2BTrIZUnWX5pecBrSUw6TAYGcfOXr1EZBgk6FR07WxsO+hc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791893496; c=relaxed/simple;
	bh=eQMnab2OOoieSB0p5qIatSRH0tlcciLBfVw3HxnUWOw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FM20CiNogrKOUIQaPS/fHMHbhnV1HZCsLvjWg/Sn5YBCPJOh/LIR6cruJTjYNoiumk7x1BCDTXZ63We4uxOdh2428tDdOE7X7g2CBOu9TIkTJBPv5Vioti0uTET1MuAdWSQmSJozUNQ5+Dwd5aC0HKbGQwNlv+GDvoVOkh2sCgg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1UYDSBr8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1UYDSBr8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 179DA1F000FF;
	Tue, 13 Oct 2026 12:11:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791893495;
	bh=PCOYEHRtaNWKTX/LkTMGQatWU4GMoPX7KpBkJntQJTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1UYDSBr8CRi/dDfFpRJjzW4DKG1Ib847bB34hB9i+mNLjnRTW/wpDqlNS+OH0ix8a
	 G/sgEQsa2z+XxLCQEFySvwl6tImqCub4OrjdvsQ0Jj31ZAbdcdDVq30Bu1ZY5D+THT
	 +/8ucR+o0SLI+kpal9pYDA67AADQZxzG23px445w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Howells <dhowells@redhat.com>,
	Paulo Alcantara <pc@manguebit.org>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 243/621] netfs: Fix missing barriers when accessing stream->subrequests locklessly
Date: Tue, 13 Oct 2026 13:33:58 +0200
Message-ID: <20261013112926.624853554@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112920.855194808@linuxfoundation.org>
References: <20261013112920.855194808@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit b5782e2d462c028096f922abca46318cec890670 ]

The list of subrequests attached to stream->subrequests is accessed without
locks by netfs_collect_read_results() and netfs_collect_write_results(),
and then they access subreq->flags without taking a barrier after getting
the subreq pointer from the list.  Relatedly, the functions that build the
list don't use any sort of write barrier when constructing the list to make
sure that the NETFS_SREQ_IN_PROGRESS flag is perceived to be set first if
no lock is taken.

Fix this by:

 (1) Add a new list_add_tail_release() function that uses a release barrier
     to set the pointer to the new member of the list.

 (2) Add a new list_first_entry_or_null_acquire() function that uses an
     acquire barrier to read the pointer to the first member in a list (or
     return NULL).

 (3) Use list_add_tail_release() when adding a subreq to ->subrequests.

 (4) Use list_first_entry_or_null_acquire() when initially accessing the
     front of the list (when an item is removed, the pointer to the new
     front iterm is obtained under the same lock).

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Fixes: 288ace2f57c9 ("netfs: New writeback implementation")
Link: https://sashiko.dev/#/patchset/20260326104544.509518-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-4-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c |  3 ++-
 fs/netfs/misc.c          |  1 +
 fs/netfs/read_collect.c  |  6 ++++--
 fs/netfs/write_collect.c |  6 ++++--
 fs/netfs/write_issue.c   |  3 ++-
 include/linux/list.h     | 37 +++++++++++++++++++++++++++++++++++++
 6 files changed, 50 insertions(+), 6 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 29868dcd1ec3b..506bfbe467a9d 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -170,7 +170,8 @@ void netfs_queue_read(struct netfs_io_request *rreq,
 	 * remove entries off of the front.
 	 */
 	spin_lock(&rreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
+	/* Write IN_PROGRESS before pointer to new subreq */
+	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		if (!stream->active) {
 			stream->collected_to = subreq->start;
diff --git a/fs/netfs/misc.c b/fs/netfs/misc.c
index 628c45f53d83c..02654b5c53fe3 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -361,6 +361,7 @@ void netfs_wait_for_in_progress_stream(struct netfs_io_request *rreq,
 	DEFINE_WAIT(myself);
 
 	list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+		smp_rmb(); /* Read ->next before IN_PROGRESS. */
 		if (!netfs_check_subreq_in_progress(subreq))
 			continue;
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 8ad06678e6883..02a9ad14627a0 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -221,8 +221,10 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	 * in progress.  The issuer thread may be adding stuff to the tail
 	 * whilst we're doing this.
 	 */
-	front = list_first_entry_or_null(&stream->subrequests,
-					 struct netfs_io_subrequest, rreq_link);
+	front = list_first_entry_or_null_acquire(&stream->subrequests,
+						 struct netfs_io_subrequest, rreq_link);
+	/* Read first subreq pointer before IN_PROGRESS flag. */
+
 	while (front) {
 		size_t transferred;
 
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index b194447f4b111..7fbf50907a7fc 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -228,8 +228,10 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 		if (!smp_load_acquire(&stream->active))
 			continue;
 
-		front = list_first_entry_or_null(&stream->subrequests,
-						 struct netfs_io_subrequest, rreq_link);
+		front = list_first_entry_or_null_acquire(&stream->subrequests,
+							 struct netfs_io_subrequest, rreq_link);
+		/* Read first subreq pointer before IN_PROGRESS flag. */
+
 		while (front) {
 			trace_netfs_collect_sreq(wreq, front);
 			//_debug("sreq [%x] %llx %zx/%zx",
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index ceb1a684a758c..10315c9538116 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -206,7 +206,8 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 	 * remove entries off of the front.
 	 */
 	spin_lock(&wreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
+	/* Write IN_PROGRESS before pointer to new subreq */
+	list_add_tail_release(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
 		if (!stream->active) {
 			stream->collected_to = subreq->start;
diff --git a/include/linux/list.h b/include/linux/list.h
index 0121e2f88f890..59f8aa0905d3b 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -198,6 +198,29 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
 	__list_add(new, head->prev, head);
 }
 
+/**
+ * list_add_tail_release - add a new entry with release barrier
+ * @new: new entry to be added
+ * @head: list head to add it before
+ *
+ * Insert a new entry before the specified head, using a release barrier to set
+ * the ->next pointer that points to it.  This is useful for implementing
+ * queues, in particular one that the elements will be walked through forwards
+ * locklessly.
+ */
+static inline void list_add_tail_release(struct list_head *new,
+					 struct list_head *head)
+{
+	struct list_head *prev = head->prev;
+
+	if (__list_add_valid(new, prev, head)) {
+		new->next = head;
+		new->prev = prev;
+		head->prev = new;
+		smp_store_release(&prev->next, new);
+	}
+}
+
 /*
  * Delete a list entry by making the prev/next entries
  * point to each other.
@@ -651,6 +674,20 @@ static inline void list_splice_tail_init(struct list_head *list,
 	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
 })
 
+/**
+ * list_first_entry_or_null_acquire - get the first element from a list with barrier
+ * @ptr:	the list head to take the element from.
+ * @type:	the type of the struct this is embedded in.
+ * @member:	the name of the list_head within the struct.
+ *
+ * Note that if the list is empty, it returns NULL.
+ */
+#define list_first_entry_or_null_acquire(ptr, type, member) ({ \
+	struct list_head *head__ = (ptr); \
+	struct list_head *pos__ = smp_load_acquire(&head__->next); \
+	pos__ != head__ ? list_entry(pos__, type, member) : NULL; \
+})
+
 /**
  * list_last_entry_or_null - get the last element from a list
  * @ptr:	the list head to take the element from.
-- 
2.53.0



