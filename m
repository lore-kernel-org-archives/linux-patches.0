Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F931335566;
	Thu, 28 May 2026 20:04:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998658; cv=none; b=h81eZ3EVLrp+7uFV09H4dQRqB16nF2M0E3x2WlKs3sQHGiGuwpejBeGVa1LkI6/9koq5isEVZU39FMn6RhKzhrGq5zDoiNicd61bTZwsmQPh1UgC4eHsGkZ3/AeaU1o9kbu+vkotOlAfjwM3Igvipw+1R4srL9py8zt5EDly3uQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998658; c=relaxed/simple;
	bh=W++f5BUHnZ7cjTs9mnaVStQ5oYDQsPUHKIiEVw33Nqg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d06YthvnSvs8ZlE1b20MXdy/h9hRQbW7+jYHuSoK9l7sM4coYxSvRIKvaH3wlNTGPovPzJUGOL1aFSd+6ZStDICOiLL7giv1ONwwyuZ7vtOO7mW2nGZ8wRbh5344iQpLvaO7AkKOoisLdqjgycG5qQOF7vwTUaApoc121xofIjU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=wDW/eJ1d; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="wDW/eJ1d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 732A61F000E9;
	Thu, 28 May 2026 20:04:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998657;
	bh=CZAixekPlzeDBBm5nFfRCWx6wCR1cjoH/mTZOa3khqk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=wDW/eJ1dXTQtuwJuiJkfDyllRA0ehQxgi14Q6g7kFIg3o4Y+jwVboPVoYEO4lcsKq
	 r7FITGfPsONn1jaLd35i1bk0OSACF6glFiwZLsILJ0n6nlDvH1kAKnmBedB/7ojanT
	 jVeLD3p77sMhmxDAwW+WVKcVhB4/Hs8BFcDVnDZU=
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
Subject: [PATCH 7.0 252/461] netfs: Fix missing barriers when accessing stream->subrequests locklessly
Date: Thu, 28 May 2026 21:46:21 +0200
Message-ID: <20260528194654.443850227@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
index a27ed501b6d43..15d73026ff643 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -168,7 +168,8 @@ void netfs_queue_read(struct netfs_io_request *rreq,
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
index 6df89c92b10b0..21357907b7eee 100644
--- a/fs/netfs/misc.c
+++ b/fs/netfs/misc.c
@@ -356,6 +356,7 @@ void netfs_wait_for_in_progress_stream(struct netfs_io_request *rreq,
 	DEFINE_WAIT(myself);
 
 	list_for_each_entry(subreq, &stream->subrequests, rreq_link) {
+		smp_rmb(); /* Read ->next before IN_PROGRESS. */
 		if (!netfs_check_subreq_in_progress(subreq))
 			continue;
 
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index d2d902f466271..3c9b847885c2a 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -205,8 +205,10 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
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
index 2db688f941251..b0e9690bb90ce 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -204,7 +204,8 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
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
index 00ea8e5fb88b0..09d979976b3b8 100644
--- a/include/linux/list.h
+++ b/include/linux/list.h
@@ -191,6 +191,29 @@ static inline void list_add_tail(struct list_head *new, struct list_head *head)
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
@@ -644,6 +667,20 @@ static inline void list_splice_tail_init(struct list_head *list,
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



