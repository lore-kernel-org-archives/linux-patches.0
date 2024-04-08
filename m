Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A48436A342;
	Mon,  8 Apr 2024 13:50:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712584212; cv=none; b=SvDZZgqyJA0Rpt1gP9TX7xL8rWIEo2rihQUkOR7DvhE2NKaTZuoNtUGxq5Qw8hlApQDVT0tdckX9mneRLUGr3zU8d6PLcw/T/T5ea8SlUEDpvTW0YT6GupHKWWK6w/W/HYXsfwKEf9T/vJuWcVlXUTRqFck6EVuvLbIixZkPbwQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712584212; c=relaxed/simple;
	bh=+4OGfzdQiXqz29xXLBRzDFOsoC3P3Xdg3u0OWeTxvAU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PbGexN5KReVphxjMQuPD2b7d3uxofXGJ0bBERxo66OaF+4uXxZs7Bc0h8iStoYv43V/9cnXdugXmW0IAQ0s/ptOThSxXXwC9aQrSpnFhJd8siT8uyUzZpvZM9woego0uKQh0D1yPW18rk/SNJyK+ncWt9dEAIH4HANlRg9PnoQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rXqQ/1UK; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rXqQ/1UK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2AF26C433C7;
	Mon,  8 Apr 2024 13:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712584212;
	bh=+4OGfzdQiXqz29xXLBRzDFOsoC3P3Xdg3u0OWeTxvAU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rXqQ/1UKhaavEpb+9KHJEkrFZNa3MizSXmQmbXiFt45EtsIUIrs7McrSlBeV2xqtM
	 93xxmZKz3Kb9IyG5+BxMzpWaHPk7hSuZ7e359LiR6K8JvfD5BZjrBAz1YgqdZsSpcD
	 9CpQqRv+rgxhsd0oy5ACPM4B2vtKz1iVM0UZMsQA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jeff Layton <jlayton@kernel.org>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 5.15 362/690] NFSD: No longer record nf_hashval in the trace log
Date: Mon,  8 Apr 2024 14:53:48 +0200
Message-ID: <20240408125412.695342891@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240408125359.506372836@linuxfoundation.org>
References: <20240408125359.506372836@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chuck Lever <chuck.lever@oracle.com>

[ Upstream commit 54f7df7094b329ca35d9f9808692bb16c48b13e9 ]

I'm about to replace nfsd_file_hashtbl with an rhashtable. The
individual hash values will no longer be visible or relevant, so
remove them from the tracepoints.

Reviewed-by: Jeff Layton <jlayton@kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
---
 fs/nfsd/filecache.c | 15 ++++++++-------
 fs/nfsd/trace.h     | 45 +++++++++++++++++++++------------------------
 2 files changed, 29 insertions(+), 31 deletions(-)

diff --git a/fs/nfsd/filecache.c b/fs/nfsd/filecache.c
index 7a02ff11b9ec1..2d013a88e3565 100644
--- a/fs/nfsd/filecache.c
+++ b/fs/nfsd/filecache.c
@@ -588,7 +588,7 @@ nfsd_file_close_inode_sync(struct inode *inode)
 	LIST_HEAD(dispose);
 
 	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode_sync(inode, hashval, !list_empty(&dispose));
+	trace_nfsd_file_close_inode_sync(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_sync(&dispose);
 }
 
@@ -608,7 +608,7 @@ nfsd_file_close_inode(struct inode *inode)
 	LIST_HEAD(dispose);
 
 	__nfsd_file_close_inode(inode, hashval, &dispose);
-	trace_nfsd_file_close_inode(inode, hashval, !list_empty(&dispose));
+	trace_nfsd_file_close_inode(inode, !list_empty(&dispose));
 	nfsd_file_dispose_list_delayed(&dispose);
 }
 
@@ -962,7 +962,7 @@ nfsd_file_is_cached(struct inode *inode)
 		}
 	}
 	rcu_read_unlock();
-	trace_nfsd_file_is_cached(inode, hashval, (int)ret);
+	trace_nfsd_file_is_cached(inode, (int)ret);
 	return ret;
 }
 
@@ -994,9 +994,8 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 
 	new = nfsd_file_alloc(inode, may_flags, hashval, net);
 	if (!new) {
-		trace_nfsd_file_acquire(rqstp, hashval, inode, may_flags,
-					NULL, nfserr_jukebox);
-		return nfserr_jukebox;
+		status = nfserr_jukebox;
+		goto out_status;
 	}
 
 	spin_lock(&nfsd_file_hashtbl[hashval].nfb_lock);
@@ -1034,8 +1033,10 @@ nfsd_do_file_acquire(struct svc_rqst *rqstp, struct svc_fh *fhp,
 		nf = NULL;
 	}
 
-	trace_nfsd_file_acquire(rqstp, hashval, inode, may_flags, nf, status);
+out_status:
+	trace_nfsd_file_acquire(rqstp, inode, may_flags, nf, status);
 	return status;
+
 open_file:
 	nf = new;
 	/* Take reference for the hashtable */
diff --git a/fs/nfsd/trace.h b/fs/nfsd/trace.h
index cc55a2b32e8cd..655b56c87600b 100644
--- a/fs/nfsd/trace.h
+++ b/fs/nfsd/trace.h
@@ -747,7 +747,6 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 	TP_PROTO(struct nfsd_file *nf),
 	TP_ARGS(nf),
 	TP_STRUCT__entry(
-		__field(unsigned int, nf_hashval)
 		__field(void *, nf_inode)
 		__field(int, nf_ref)
 		__field(unsigned long, nf_flags)
@@ -755,15 +754,13 @@ DECLARE_EVENT_CLASS(nfsd_file_class,
 		__field(struct file *, nf_file)
 	),
 	TP_fast_assign(
-		__entry->nf_hashval = nf->nf_hashval;
 		__entry->nf_inode = nf->nf_inode;
 		__entry->nf_ref = refcount_read(&nf->nf_ref);
 		__entry->nf_flags = nf->nf_flags;
 		__entry->nf_may = nf->nf_may;
 		__entry->nf_file = nf->nf_file;
 	),
-	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
-		__entry->nf_hashval,
+	TP_printk("inode=%p ref=%d flags=%s may=%s nf_file=%p",
 		__entry->nf_inode,
 		__entry->nf_ref,
 		show_nf_flags(__entry->nf_flags),
@@ -783,15 +780,18 @@ DEFINE_NFSD_FILE_EVENT(nfsd_file_put);
 DEFINE_NFSD_FILE_EVENT(nfsd_file_unhash_and_release_locked);
 
 TRACE_EVENT(nfsd_file_acquire,
-	TP_PROTO(struct svc_rqst *rqstp, unsigned int hash,
-		 struct inode *inode, unsigned int may_flags,
-		 struct nfsd_file *nf, __be32 status),
+	TP_PROTO(
+		struct svc_rqst *rqstp,
+		struct inode *inode,
+		unsigned int may_flags,
+		struct nfsd_file *nf,
+		__be32 status
+	),
 
-	TP_ARGS(rqstp, hash, inode, may_flags, nf, status),
+	TP_ARGS(rqstp, inode, may_flags, nf, status),
 
 	TP_STRUCT__entry(
 		__field(u32, xid)
-		__field(unsigned int, hash)
 		__field(void *, inode)
 		__field(unsigned long, may_flags)
 		__field(int, nf_ref)
@@ -803,7 +803,6 @@ TRACE_EVENT(nfsd_file_acquire,
 
 	TP_fast_assign(
 		__entry->xid = be32_to_cpu(rqstp->rq_xid);
-		__entry->hash = hash;
 		__entry->inode = inode;
 		__entry->may_flags = may_flags;
 		__entry->nf_ref = nf ? refcount_read(&nf->nf_ref) : 0;
@@ -813,8 +812,8 @@ TRACE_EVENT(nfsd_file_acquire,
 		__entry->status = be32_to_cpu(status);
 	),
 
-	TP_printk("xid=0x%x hash=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
-			__entry->xid, __entry->hash, __entry->inode,
+	TP_printk("xid=0x%x inode=%p may_flags=%s ref=%d nf_flags=%s nf_may=%s nf_file=%p status=%u",
+			__entry->xid, __entry->inode,
 			show_nfsd_may_flags(__entry->may_flags),
 			__entry->nf_ref, show_nf_flags(__entry->nf_flags),
 			show_nfsd_may_flags(__entry->nf_may),
@@ -825,7 +824,6 @@ TRACE_EVENT(nfsd_file_open,
 	TP_PROTO(struct nfsd_file *nf, __be32 status),
 	TP_ARGS(nf, status),
 	TP_STRUCT__entry(
-		__field(unsigned int, nf_hashval)
 		__field(void *, nf_inode)	/* cannot be dereferenced */
 		__field(int, nf_ref)
 		__field(unsigned long, nf_flags)
@@ -833,15 +831,13 @@ TRACE_EVENT(nfsd_file_open,
 		__field(void *, nf_file)	/* cannot be dereferenced */
 	),
 	TP_fast_assign(
-		__entry->nf_hashval = nf->nf_hashval;
 		__entry->nf_inode = nf->nf_inode;
 		__entry->nf_ref = refcount_read(&nf->nf_ref);
 		__entry->nf_flags = nf->nf_flags;
 		__entry->nf_may = nf->nf_may;
 		__entry->nf_file = nf->nf_file;
 	),
-	TP_printk("hash=0x%x inode=%p ref=%d flags=%s may=%s file=%p",
-		__entry->nf_hashval,
+	TP_printk("inode=%p ref=%d flags=%s may=%s file=%p",
 		__entry->nf_inode,
 		__entry->nf_ref,
 		show_nf_flags(__entry->nf_flags),
@@ -850,26 +846,27 @@ TRACE_EVENT(nfsd_file_open,
 )
 
 DECLARE_EVENT_CLASS(nfsd_file_search_class,
-	TP_PROTO(struct inode *inode, unsigned int hash, int found),
-	TP_ARGS(inode, hash, found),
+	TP_PROTO(
+		struct inode *inode,
+		int found
+	),
+	TP_ARGS(inode, found),
 	TP_STRUCT__entry(
 		__field(struct inode *, inode)
-		__field(unsigned int, hash)
 		__field(int, found)
 	),
 	TP_fast_assign(
 		__entry->inode = inode;
-		__entry->hash = hash;
 		__entry->found = found;
 	),
-	TP_printk("hash=0x%x inode=%p found=%d", __entry->hash,
-			__entry->inode, __entry->found)
+	TP_printk("inode=%p found=%d",
+		__entry->inode, __entry->found)
 );
 
 #define DEFINE_NFSD_FILE_SEARCH_EVENT(name)				\
 DEFINE_EVENT(nfsd_file_search_class, name,				\
-	TP_PROTO(struct inode *inode, unsigned int hash, int found),	\
-	TP_ARGS(inode, hash, found))
+	TP_PROTO(struct inode *inode, int found),			\
+	TP_ARGS(inode, found))
 
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode_sync);
 DEFINE_NFSD_FILE_SEARCH_EVENT(nfsd_file_close_inode);
-- 
2.43.0



