Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75B603164B7;
	Thu, 28 May 2026 20:04:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998652; cv=none; b=bH3bf7TD/dzk9g6pl+YY3GO7R2cxvoRIMKX9oU1U245JRsyJ9xKrUngYk22a38H/BkbhOGPvnpWmvEH0YQ9yoRtDonuc8+mhknSFrf2JUwxq525z9/Njo+vXjgEb1gEPgxjA7lXTXS0nPwVXVToQCdTRZN4bscBD7wh+jzAj0xI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998652; c=relaxed/simple;
	bh=0UTCGh20+YnN2qFquxKguoUE0K3NRtlZ208/qtIIvKw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AE/Opv+a2lZRUHoJGfa4wjIpW7de/n8ZNmXFTkvpRNaU65fy9txF1dncnp1UIsshB8lvDeORXiPYKucv1l2Fr8xZ486Xd1H5uXvX+xgdKRIaftSADY4b14tO/o++pkt40Z3VJKWDaoMKxx1hNLO/bkNIzufSHDpz1k7oSyIfmjw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0gApYYM5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0gApYYM5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB4921F000E9;
	Thu, 28 May 2026 20:04:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998651;
	bh=Md1ZmyeajaJ6H9yiWJHXpLeJ9z8F/MpiZr8wOMQYbtA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0gApYYM5K2eGKnWXL8HjU/YctyFesqOxq6zDh4cIl8Jf69VA/Qnm3D1Orv2vyH8V9
	 tCuDHes+4jOmDq2lYkLPT7qR56SiGWmA/VCMTgUh/RDUxkGDHLR+2PqzW9hwk3IOWE
	 r8RrUrMir7YA4dY1fYKjgjjuMEbJUWqlmsma/8+0=
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
Subject: [PATCH 7.0 250/461] netfs: Fix cancellation of a DIO and single read subrequests
Date: Thu, 28 May 2026 21:46:19 +0200
Message-ID: <20260528194654.386331388@linuxfoundation.org>
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

[ Upstream commit 6f0f7ac1915abc0d202f0eb4b003a6548a5ba60d ]

When the preparation of a new subrequest for a read fails, if the
subrequest has already been added to the stream->subrequests list, it can't
simply be put and abandoned as the collector may see it.  Also, if it
hasn't been queued yet, it has two outstanding refs that both need to be
put.  Both DIO read and single-read dispatch fail at this; further, both
differ in the order they do things to the way buffered read works.

Fix cancellation of both DIO-read and single-read subrequests that failed
preparation by the following steps:

 (1) Harmonise all three reads (buffered, dio, single) to queue the subreq
     before prepping it.

 (2) Make all three call netfs_queue_read() to do the queuing.

 (3) Set NETFS_RREQ_ALL_QUEUED independently of the queuing as we don't
     know the length of the subreq at this point.

 (4) In all cases, set the error and NETFS_SREQ_FAILED flag on the subreq
     and then call netfs_read_subreq_terminated() to deal with it.  This
     will pass responsibility off to the collector for dealing with it.

Fixes: e2d46f2ec332 ("netfs: Change the read result collector to only use one work item")
Closes: https://sashiko.dev/#/patchset/20260425125426.3855807-1-dhowells%40redhat.com
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/20260512123404.719402-2-dhowells@redhat.com
cc: Paulo Alcantara <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c | 34 +++++++++++++-------------------
 fs/netfs/direct_read.c   | 42 +++++++++++++---------------------------
 fs/netfs/internal.h      |  3 +++
 fs/netfs/read_collect.c  | 11 +++++++++++
 fs/netfs/read_single.c   | 23 ++++++++++------------
 5 files changed, 50 insertions(+), 63 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index a8c0d86118c58..a27ed501b6d43 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -156,9 +156,8 @@ static void netfs_read_cache_to_pagecache(struct netfs_io_request *rreq,
 			netfs_cache_read_terminated, subreq);
 }
 
-static void netfs_queue_read(struct netfs_io_request *rreq,
-			     struct netfs_io_subrequest *subreq,
-			     bool last_subreq)
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq)
 {
 	struct netfs_io_stream *stream = &rreq->io_streams[0];
 
@@ -178,11 +177,6 @@ static void netfs_queue_read(struct netfs_io_request *rreq,
 		}
 	}
 
-	if (last_subreq) {
-		smp_wmb(); /* Write lists before ALL_QUEUED. */
-		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
-	}
-
 	spin_unlock(&rreq->lock);
 }
 
@@ -233,6 +227,8 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 		subreq->start	= start;
 		subreq->len	= size;
 
+		netfs_queue_read(rreq, subreq);
+
 		source = netfs_cache_prepare_read(rreq, subreq, rreq->i_size);
 		subreq->source = source;
 		if (source == NETFS_DOWNLOAD_FROM_SERVER) {
@@ -253,6 +249,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 				       rreq->debug_id, subreq->debug_index,
 				       subreq->len, size,
 				       subreq->start, ictx->zero_point, rreq->i_size);
+				netfs_cancel_read(subreq, ret);
 				break;
 			}
 			subreq->len = len;
@@ -261,12 +258,7 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 			if (rreq->netfs_ops->prepare_read) {
 				ret = rreq->netfs_ops->prepare_read(subreq);
 				if (ret < 0) {
-					subreq->error = ret;
-					/* Not queued - release both refs. */
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
-					netfs_put_subrequest(subreq,
-							     netfs_sreq_trace_put_cancel);
+					netfs_cancel_read(subreq, ret);
 					break;
 				}
 				trace_netfs_sreq(subreq, netfs_sreq_trace_prepare);
@@ -289,23 +281,23 @@ static void netfs_read_to_pagecache(struct netfs_io_request *rreq,
 
 		pr_err("Unexpected read source %u\n", source);
 		WARN_ON_ONCE(1);
+		netfs_cancel_read(subreq, ret);
 		break;
 
 	issue:
 		slice = netfs_prepare_read_iterator(subreq, ractl);
 		if (slice < 0) {
 			ret = slice;
-			subreq->error = ret;
-			trace_netfs_sreq(subreq, netfs_sreq_trace_cancel);
-			/* Not queued - release both refs. */
-			netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
-			netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+			netfs_cancel_read(subreq, ret);
 			break;
 		}
-		size -= slice;
 		start += slice;
+		size -= slice;
+		if (size <= 0) {
+			smp_wmb(); /* Write lists before ALL_QUEUED. */
+			set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+		}
 
-		netfs_queue_read(rreq, subreq, size <= 0);
 		netfs_issue_read(rreq, subreq);
 		cond_resched();
 	} while (size > 0);
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index f72e6da88cca7..6a8fb0d55e040 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -45,12 +45,11 @@ static void netfs_prepare_dio_read_iterator(struct netfs_io_subrequest *subreq)
  * Perform a read to a buffer from the server, slicing up the region to be read
  * according to the network rsize.
  */
-static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
+static void netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 {
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	unsigned long long start = rreq->start;
 	ssize_t size = rreq->len;
-	int ret = 0;
+	int ret;
 
 	do {
 		struct netfs_io_subrequest *subreq;
@@ -58,7 +57,10 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 
 		subreq = netfs_alloc_subrequest(rreq);
 		if (!subreq) {
-			ret = -ENOMEM;
+			/* Stash the error in the request if there's not
+			 * already an error set.
+			 */
+			cmpxchg(&rreq->error, 0, -ENOMEM);
 			break;
 		}
 
@@ -66,25 +68,13 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		subreq->start	= start;
 		subreq->len	= size;
 
-		__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-
-		spin_lock(&rreq->lock);
-		list_add_tail(&subreq->rreq_link, &stream->subrequests);
-		if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-			if (!stream->active) {
-				stream->collected_to = subreq->start;
-				/* Store list pointers before active flag */
-				smp_store_release(&stream->active, true);
-			}
-		}
-		trace_netfs_sreq(subreq, netfs_sreq_trace_added);
-		spin_unlock(&rreq->lock);
+		netfs_queue_read(rreq, subreq);
 
 		netfs_stat(&netfs_n_rh_download);
 		if (rreq->netfs_ops->prepare_read) {
 			ret = rreq->netfs_ops->prepare_read(subreq);
 			if (ret < 0) {
-				netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+				netfs_cancel_read(subreq, ret);
 				break;
 			}
 		}
@@ -113,8 +103,6 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		netfs_wake_collector(rreq);
 	}
-
-	return ret;
 }
 
 /*
@@ -137,21 +125,17 @@ static ssize_t netfs_unbuffered_read(struct netfs_io_request *rreq, bool sync)
 	// TODO: Use bounce buffer if requested
 
 	inode_dio_begin(rreq->inode);
+	netfs_dispatch_unbuffered_reads(rreq);
 
-	ret = netfs_dispatch_unbuffered_reads(rreq);
-
-	if (!rreq->submitted) {
-		netfs_put_request(rreq, netfs_rreq_trace_put_no_submit);
-		inode_dio_end(rreq->inode);
-		ret = 0;
-		goto out;
-	}
+	/* The collector will get run, even if we don't manage to submit any
+	 * subreqs, so we shouldn't call inode_dio_end() here.
+	 */
 
 	if (sync)
 		ret = netfs_wait_for_read(rreq);
 	else
 		ret = -EIOCBQUEUED;
-out:
+
 	_leave(" = %zd", ret);
 	return ret;
 }
diff --git a/fs/netfs/internal.h b/fs/netfs/internal.h
index d436e20d34185..645996ecfc803 100644
--- a/fs/netfs/internal.h
+++ b/fs/netfs/internal.h
@@ -23,6 +23,8 @@
 /*
  * buffered_read.c
  */
+void netfs_queue_read(struct netfs_io_request *rreq,
+		      struct netfs_io_subrequest *subreq);
 void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 int netfs_prefetch_for_write(struct file *file, struct folio *folio,
 			     size_t offset, size_t len);
@@ -108,6 +110,7 @@ static inline void netfs_see_subrequest(struct netfs_io_subrequest *subreq,
  */
 bool netfs_read_collection(struct netfs_io_request *rreq);
 void netfs_read_collection_worker(struct work_struct *work);
+void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error);
 void netfs_cache_read_terminated(void *priv, ssize_t transferred_or_error);
 
 /*
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index e5f6665b3341e..d2d902f466271 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -575,6 +575,17 @@ void netfs_read_subreq_terminated(struct netfs_io_subrequest *subreq)
 }
 EXPORT_SYMBOL(netfs_read_subreq_terminated);
 
+/*
+ * Cancel a read subrequest due to preparation failure.
+ */
+void netfs_cancel_read(struct netfs_io_subrequest *subreq, int error)
+{
+	trace_netfs_sreq(subreq, netfs_sreq_trace_cancel);
+	subreq->error = error;
+	__set_bit(NETFS_SREQ_FAILED, &subreq->flags);
+	netfs_read_subreq_terminated(subreq);
+}
+
 /*
  * Handle termination of a read from the cache.
  */
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index d0e23bc42445f..8833550d2eb60 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -89,7 +89,6 @@ static void netfs_single_read_cache(struct netfs_io_request *rreq,
  */
 static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 {
-	struct netfs_io_stream *stream = &rreq->io_streams[0];
 	struct netfs_io_subrequest *subreq;
 	int ret = 0;
 
@@ -102,14 +101,7 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	subreq->len	= rreq->len;
 	subreq->io_iter	= rreq->buffer.iter;
 
-	__set_bit(NETFS_SREQ_IN_PROGRESS, &subreq->flags);
-
-	spin_lock(&rreq->lock);
-	list_add_tail(&subreq->rreq_link, &stream->subrequests);
-	trace_netfs_sreq(subreq, netfs_sreq_trace_added);
-	/* Store list pointers before active flag */
-	smp_store_release(&stream->active, true);
-	spin_unlock(&rreq->lock);
+	netfs_queue_read(rreq, subreq);
 
 	netfs_single_cache_prepare_read(rreq, subreq);
 	switch (subreq->source) {
@@ -121,10 +113,14 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 				goto cancel;
 		}
 
+		smp_wmb(); /* Write lists before ALL_QUEUED. */
+		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		rreq->netfs_ops->issue_read(subreq);
 		rreq->submitted += subreq->len;
 		break;
 	case NETFS_READ_FROM_CACHE:
+		smp_wmb(); /* Write lists before ALL_QUEUED. */
+		set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 		trace_netfs_sreq(subreq, netfs_sreq_trace_submit);
 		netfs_single_read_cache(rreq, subreq);
 		rreq->submitted += subreq->len;
@@ -134,14 +130,15 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 		pr_warn("Unexpected single-read source %u\n", subreq->source);
 		WARN_ON_ONCE(true);
 		ret = -EIO;
-		break;
+		goto cancel;
 	}
 
-	smp_wmb(); /* Write lists before ALL_QUEUED. */
-	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
 	return ret;
 cancel:
-	netfs_put_subrequest(subreq, netfs_sreq_trace_put_cancel);
+	netfs_cancel_read(subreq, ret);
+	smp_wmb(); /* Write lists before ALL_QUEUED. */
+	set_bit(NETFS_RREQ_ALL_QUEUED, &rreq->flags);
+	netfs_wake_collector(rreq);
 	return ret;
 }
 
-- 
2.53.0



