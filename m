Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7A3A3EF0A2;
	Tue, 31 Mar 2026 16:45:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975544; cv=none; b=pinoR3Jgzk+MS2psgqypR7PEzfqKxAeBI6+icxpi3K7K0lv3lqDWdhMDq2bOa8JccoTavqVbrX0KPHiDAaRom+ZhZ97N++hWntW2FoL6UZkEXQDTK7M7DGyHaqMWEUe2DzXXcQkxeLW7m4pCt/HMykD9eySjrsu57/Cu+n45T4E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975544; c=relaxed/simple;
	bh=LZIeec4gnJBrIAABOjwLV/gUJmKAVKPFNlacbvf/EuM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SWKkD8NiSgNAa4n+RTtxoexSOFY3KWayoMAio1bBxBSzpkdd1ihlflj6tGxccHPdDK6dSgbSI+7g8OJqK8RyNd5j1es4MipNYEwbp1/qOPrvGMEjjIrNeI35pbdWg3oj0XMh7QKAgiKShaiGBL4w6bfnmCVa1G4pD/CZ5Fp+eic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AGVsQd+O; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AGVsQd+O"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 521FCC19423;
	Tue, 31 Mar 2026 16:45:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975544;
	bh=LZIeec4gnJBrIAABOjwLV/gUJmKAVKPFNlacbvf/EuM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AGVsQd+Okfd+l4pQmMJIdLwTwOr/2NI6YEKyv7EA1+0BqJwtWUbQGmN15q3GG5iCR
	 AI+xZUtLL/vmc1YRk0SKNtrmJ08PmG+G/6m8BiAF8+Dn7+wEYUl7Uz0qfFWNlIPr+w
	 CmtqwUADdyjz433eKKM7jVlb1FDxMQPNrTQXkdsA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Paulo Alcantara <pc@manguebit.org>,
	David Howells <dhowells@redhat.com>,
	netfs@lists.linux.dev,
	linux-fsdevel@vger.kernel.org,
	Christian Brauner <brauner@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 335/342] netfs: Fix the handling of stream->front by removing it
Date: Tue, 31 Mar 2026 18:22:48 +0200
Message-ID: <20260331161811.229757268@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161758.909578033@linuxfoundation.org>
References: <20260331161758.909578033@linuxfoundation.org>
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

6.19-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Howells <dhowells@redhat.com>

[ Upstream commit 0e764b9d46071668969410ec5429be0e2f38c6d3 ]

The netfs_io_stream::front member is meant to point to the subrequest
currently being collected on a stream, but it isn't actually used this way
by direct write (which mostly ignores it).  However, there's a tracepoint
which looks at it.  Further, stream->front is actually redundant with
stream->subrequests.next.

Fix the potential problem in the direct code by just removing the member
and using stream->subrequests.next instead, thereby also simplifying the
code.

Fixes: a0b4c7a49137 ("netfs: Fix unbuffered/DIO writes to dispatch subrequests in strict sequence")
Reported-by: Paulo Alcantara <pc@manguebit.org>
Signed-off-by: David Howells <dhowells@redhat.com>
Link: https://patch.msgid.link/4158599.1774426817@warthog.procyon.org.uk
Reviewed-by: Paulo Alcantara (Red Hat) <pc@manguebit.org>
cc: netfs@lists.linux.dev
cc: linux-fsdevel@vger.kernel.org
Signed-off-by: Christian Brauner <brauner@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/netfs/buffered_read.c     | 3 +--
 fs/netfs/direct_read.c       | 3 +--
 fs/netfs/direct_write.c      | 1 -
 fs/netfs/read_collect.c      | 4 ++--
 fs/netfs/read_single.c       | 1 -
 fs/netfs/write_collect.c     | 4 ++--
 fs/netfs/write_issue.c       | 3 +--
 include/linux/netfs.h        | 1 -
 include/trace/events/netfs.h | 8 ++++----
 9 files changed, 11 insertions(+), 17 deletions(-)

diff --git a/fs/netfs/buffered_read.c b/fs/netfs/buffered_read.c
index 37ab6f28b5ad0..88361e8c70961 100644
--- a/fs/netfs/buffered_read.c
+++ b/fs/netfs/buffered_read.c
@@ -171,9 +171,8 @@ static void netfs_queue_read(struct netfs_io_request *rreq,
 	spin_lock(&rreq->lock);
 	list_add_tail(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-		stream->front = subreq;
 		if (!stream->active) {
-			stream->collected_to = stream->front->start;
+			stream->collected_to = subreq->start;
 			/* Store list pointers before active flag */
 			smp_store_release(&stream->active, true);
 		}
diff --git a/fs/netfs/direct_read.c b/fs/netfs/direct_read.c
index a498ee8d66745..f72e6da88cca7 100644
--- a/fs/netfs/direct_read.c
+++ b/fs/netfs/direct_read.c
@@ -71,9 +71,8 @@ static int netfs_dispatch_unbuffered_reads(struct netfs_io_request *rreq)
 		spin_lock(&rreq->lock);
 		list_add_tail(&subreq->rreq_link, &stream->subrequests);
 		if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-			stream->front = subreq;
 			if (!stream->active) {
-				stream->collected_to = stream->front->start;
+				stream->collected_to = subreq->start;
 				/* Store list pointers before active flag */
 				smp_store_release(&stream->active, true);
 			}
diff --git a/fs/netfs/direct_write.c b/fs/netfs/direct_write.c
index 4d9760e36c119..f9ab69de3e298 100644
--- a/fs/netfs/direct_write.c
+++ b/fs/netfs/direct_write.c
@@ -111,7 +111,6 @@ static int netfs_unbuffered_write(struct netfs_io_request *wreq)
 			netfs_prepare_write(wreq, stream, wreq->start + wreq->transferred);
 			subreq = stream->construct;
 			stream->construct = NULL;
-			stream->front = NULL;
 		}
 
 		/* Check if (re-)preparation failed. */
diff --git a/fs/netfs/read_collect.c b/fs/netfs/read_collect.c
index 137f0e28a44c5..e5f6665b3341e 100644
--- a/fs/netfs/read_collect.c
+++ b/fs/netfs/read_collect.c
@@ -205,7 +205,8 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 	 * in progress.  The issuer thread may be adding stuff to the tail
 	 * whilst we're doing this.
 	 */
-	front = READ_ONCE(stream->front);
+	front = list_first_entry_or_null(&stream->subrequests,
+					 struct netfs_io_subrequest, rreq_link);
 	while (front) {
 		size_t transferred;
 
@@ -301,7 +302,6 @@ static void netfs_collect_read_results(struct netfs_io_request *rreq)
 		list_del_init(&front->rreq_link);
 		front = list_first_entry_or_null(&stream->subrequests,
 						 struct netfs_io_subrequest, rreq_link);
-		stream->front = front;
 		spin_unlock(&rreq->lock);
 		netfs_put_subrequest(remove,
 				     notes & ABANDON_SREQ ?
diff --git a/fs/netfs/read_single.c b/fs/netfs/read_single.c
index 8e6264f62a8f3..d0e23bc42445f 100644
--- a/fs/netfs/read_single.c
+++ b/fs/netfs/read_single.c
@@ -107,7 +107,6 @@ static int netfs_single_dispatch_read(struct netfs_io_request *rreq)
 	spin_lock(&rreq->lock);
 	list_add_tail(&subreq->rreq_link, &stream->subrequests);
 	trace_netfs_sreq(subreq, netfs_sreq_trace_added);
-	stream->front = subreq;
 	/* Store list pointers before active flag */
 	smp_store_release(&stream->active, true);
 	spin_unlock(&rreq->lock);
diff --git a/fs/netfs/write_collect.c b/fs/netfs/write_collect.c
index 83eb3dc1adf8a..b194447f4b111 100644
--- a/fs/netfs/write_collect.c
+++ b/fs/netfs/write_collect.c
@@ -228,7 +228,8 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 		if (!smp_load_acquire(&stream->active))
 			continue;
 
-		front = stream->front;
+		front = list_first_entry_or_null(&stream->subrequests,
+						 struct netfs_io_subrequest, rreq_link);
 		while (front) {
 			trace_netfs_collect_sreq(wreq, front);
 			//_debug("sreq [%x] %llx %zx/%zx",
@@ -279,7 +280,6 @@ static void netfs_collect_write_results(struct netfs_io_request *wreq)
 			list_del_init(&front->rreq_link);
 			front = list_first_entry_or_null(&stream->subrequests,
 							 struct netfs_io_subrequest, rreq_link);
-			stream->front = front;
 			spin_unlock(&wreq->lock);
 			netfs_put_subrequest(remove,
 					     notes & SAW_FAILURE ?
diff --git a/fs/netfs/write_issue.c b/fs/netfs/write_issue.c
index 437268f656409..2db688f941251 100644
--- a/fs/netfs/write_issue.c
+++ b/fs/netfs/write_issue.c
@@ -206,9 +206,8 @@ void netfs_prepare_write(struct netfs_io_request *wreq,
 	spin_lock(&wreq->lock);
 	list_add_tail(&subreq->rreq_link, &stream->subrequests);
 	if (list_is_first(&subreq->rreq_link, &stream->subrequests)) {
-		stream->front = subreq;
 		if (!stream->active) {
-			stream->collected_to = stream->front->start;
+			stream->collected_to = subreq->start;
 			/* Write list pointers before active flag */
 			smp_store_release(&stream->active, true);
 		}
diff --git a/include/linux/netfs.h b/include/linux/netfs.h
index 72ee7d210a744..ba17ac5bf356a 100644
--- a/include/linux/netfs.h
+++ b/include/linux/netfs.h
@@ -140,7 +140,6 @@ struct netfs_io_stream {
 	void (*issue_write)(struct netfs_io_subrequest *subreq);
 	/* Collection tracking */
 	struct list_head	subrequests;	/* Contributory I/O operations */
-	struct netfs_io_subrequest *front;	/* Op being collected */
 	unsigned long long	collected_to;	/* Position we've collected results to */
 	size_t			transferred;	/* The amount transferred from this stream */
 	unsigned short		error;		/* Aggregate error for the stream */
diff --git a/include/trace/events/netfs.h b/include/trace/events/netfs.h
index 2d366be46a1c3..cbe28211106c5 100644
--- a/include/trace/events/netfs.h
+++ b/include/trace/events/netfs.h
@@ -740,19 +740,19 @@ TRACE_EVENT(netfs_collect_stream,
 		    __field(unsigned int,	wreq)
 		    __field(unsigned char,	stream)
 		    __field(unsigned long long,	collected_to)
-		    __field(unsigned long long,	front)
+		    __field(unsigned long long,	issued_to)
 			     ),
 
 	    TP_fast_assign(
 		    __entry->wreq	= wreq->debug_id;
 		    __entry->stream	= stream->stream_nr;
 		    __entry->collected_to = stream->collected_to;
-		    __entry->front	= stream->front ? stream->front->start : UINT_MAX;
+		    __entry->issued_to	= atomic64_read(&wreq->issued_to);
 			   ),
 
-	    TP_printk("R=%08x[%x:] cto=%llx frn=%llx",
+	    TP_printk("R=%08x[%x:] cto=%llx ito=%llx",
 		      __entry->wreq, __entry->stream,
-		      __entry->collected_to, __entry->front)
+		      __entry->collected_to, __entry->issued_to)
 	    );
 
 TRACE_EVENT(netfs_folioq,
-- 
2.53.0



