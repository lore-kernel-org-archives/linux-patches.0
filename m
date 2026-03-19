Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B9AF3C3435;
	Thu, 19 Mar 2026 11:13:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918821; cv=none; b=KoZN4ovkqBcQ4Gi/DthomKeT7zdvJKSrAo3acqf+Ccd1TG4AOB1f6yYgHIzqWzTDZVUSJVlUakrcxhBRej57HQAEjlFYSCiU4XIdmmz2ZTDjsSG3qyYWHPqD/CnmgpUSqPjbc1j+yenYOHiq64FE0oMQ5GYcwSHOOJCUG3ZNbVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918821; c=relaxed/simple;
	bh=YwrASxq4OZiJA+ktROA3JKTU69qKDMWRLAkbNnUYta8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=MxhF6sWOsD2LXEggiKsiuO8lPHP0wZiCNWu8/wAephvxYZRiWNzwrpMiCUYavGLx3cbtbZ8bUDGfi4FmWjHInbFDFGyvvMmRnpg+ONbq7X9P3szaBmh5ikQkZk+E8q1gkKduDYHaNSFaavihaeeYVlwis8hcrHacO2rgRoJ9+K8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=U1ZNUmym; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="U1ZNUmym"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57D3FC2BCB4;
	Thu, 19 Mar 2026 11:13:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773918820;
	bh=YwrASxq4OZiJA+ktROA3JKTU69qKDMWRLAkbNnUYta8=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=U1ZNUmym737qlYd1YRt8/2tC8buh1mnNd1uk+ls0c1AMPjKG6PflkeLdriSHBFO0I
	 f/P4VouKbC3F/arsnjGS7g4bOhb8ls1/jUxQs4Xzo1Ld4YgsrDRrLRfGJ6lef+DULv
	 XikzBH5Agz/3V0HoBhpFEpArmyLX4XA6IkGTXZDo=
Subject: Patch "nfs: pass explicit offset/count to trace events" has been added to the 6.6-stable tree
To: 1468888505@139.com,Anna.Schumaker@Netapp.com,anna@kernel.org,chuck.lever@oracle.com,gregkh@linuxfoundation.org,hch@lst.de,patches@lists.linux.dev,trond.myklebust@hammerspace.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 12:12:52 +0100
In-Reply-To: <20260224070058.2933695-1-1468888505@139.com>
Message-ID: <2026031952-ergonomic-uncheck-d1e5@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    nfs: pass explicit offset/count to trace events

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     nfs-pass-explicit-offset-count-to-trace-events.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-217866-greg=kroah.com@vger.kernel.org Tue Feb 24 08:01:20 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 24 Feb 2026 15:00:58 +0800
Subject: nfs: pass explicit offset/count to trace events
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, hch@lst.de
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, trond.myklebust@hammerspace.com, anna@kernel.org, linux-nfs@vger.kernel.org, chuck.lever@oracle.com, Anna.Schumaker@Netapp.com
Message-ID: <20260224070058.2933695-1-1468888505@139.com>

From: Christoph Hellwig <hch@lst.de>

[ Upstream commit fada32ed6dbc748f447c8d050a961b75d946055a ]

nfs_folio_length is unsafe to use without having the folio locked and a
check for a NULL ->f_mapping that protects against truncations and can
lead to kernel crashes.  E.g. when running xfstests generic/065 with
all nfs trace points enabled.

Follow the model of the XFS trace points and pass in an explіcit offset
and length.  This has the additional benefit that these values can
be more accurate as some of the users touch partial folio ranges.

Fixes: eb5654b3b89d ("NFS: Enable tracing of nfs_invalidate_folio() and nfs_launder_folio()")
Reported-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/file.c     |    5 +++--
 fs/nfs/nfstrace.h |   36 ++++++++++++++++++++----------------
 fs/nfs/read.c     |    8 +++++---
 fs/nfs/write.c    |   10 +++++-----
 4 files changed, 33 insertions(+), 26 deletions(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -441,7 +441,7 @@ static void nfs_invalidate_folio(struct
 	/* Cancel any unstarted writes on this page */
 	nfs_wb_folio_cancel(inode, folio);
 	folio_wait_fscache(folio);
-	trace_nfs_invalidate_folio(inode, folio);
+	trace_nfs_invalidate_folio(inode, folio_pos(folio) + offset, length);
 }
 
 /*
@@ -509,7 +509,8 @@ static int nfs_launder_folio(struct foli
 
 	folio_wait_fscache(folio);
 	ret = nfs_wb_folio(inode, folio);
-	trace_nfs_launder_folio_done(inode, folio, ret);
+	trace_nfs_launder_folio_done(inode, folio_pos(folio),
+			folio_size(folio), ret);
 	return ret;
 }
 
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -933,10 +933,11 @@ TRACE_EVENT(nfs_sillyrename_unlink,
 DECLARE_EVENT_CLASS(nfs_folio_event,
 		TP_PROTO(
 			const struct inode *inode,
-			struct folio *folio
+			loff_t offset,
+			size_t count
 		),
 
-		TP_ARGS(inode, folio),
+		TP_ARGS(inode, offset, count),
 
 		TP_STRUCT__entry(
 			__field(dev_t, dev)
@@ -944,7 +945,7 @@ DECLARE_EVENT_CLASS(nfs_folio_event,
 			__field(u64, fileid)
 			__field(u64, version)
 			__field(loff_t, offset)
-			__field(u32, count)
+			__field(size_t, count)
 		),
 
 		TP_fast_assign(
@@ -954,13 +955,13 @@ DECLARE_EVENT_CLASS(nfs_folio_event,
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->version = inode_peek_iversion_raw(inode);
-			__entry->offset = folio_file_pos(folio);
-			__entry->count = nfs_folio_length(folio);
+			__entry->offset = offset,
+			__entry->count = count;
 		),
 
 		TP_printk(
 			"fileid=%02x:%02x:%llu fhandle=0x%08x version=%llu "
-			"offset=%lld count=%u",
+			"offset=%lld count=%zu",
 			MAJOR(__entry->dev), MINOR(__entry->dev),
 			(unsigned long long)__entry->fileid,
 			__entry->fhandle, __entry->version,
@@ -972,18 +973,20 @@ DECLARE_EVENT_CLASS(nfs_folio_event,
 	DEFINE_EVENT(nfs_folio_event, name, \
 			TP_PROTO( \
 				const struct inode *inode, \
-				struct folio *folio \
+				loff_t offset, \
+				size_t count \
 			), \
-			TP_ARGS(inode, folio))
+			TP_ARGS(inode, offset, count))
 
 DECLARE_EVENT_CLASS(nfs_folio_event_done,
 		TP_PROTO(
 			const struct inode *inode,
-			struct folio *folio,
+			loff_t offset,
+			size_t count,
 			int ret
 		),
 
-		TP_ARGS(inode, folio, ret),
+		TP_ARGS(inode, offset, count, ret),
 
 		TP_STRUCT__entry(
 			__field(dev_t, dev)
@@ -992,7 +995,7 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 			__field(u64, fileid)
 			__field(u64, version)
 			__field(loff_t, offset)
-			__field(u32, count)
+			__field(size_t, count)
 		),
 
 		TP_fast_assign(
@@ -1002,14 +1005,14 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 			__entry->fileid = nfsi->fileid;
 			__entry->fhandle = nfs_fhandle_hash(&nfsi->fh);
 			__entry->version = inode_peek_iversion_raw(inode);
-			__entry->offset = folio_file_pos(folio);
-			__entry->count = nfs_folio_length(folio);
+			__entry->offset = offset,
+			__entry->count = count,
 			__entry->ret = ret;
 		),
 
 		TP_printk(
 			"fileid=%02x:%02x:%llu fhandle=0x%08x version=%llu "
-			"offset=%lld count=%u ret=%d",
+			"offset=%lld count=%zu ret=%d",
 			MAJOR(__entry->dev), MINOR(__entry->dev),
 			(unsigned long long)__entry->fileid,
 			__entry->fhandle, __entry->version,
@@ -1021,10 +1024,11 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 	DEFINE_EVENT(nfs_folio_event_done, name, \
 			TP_PROTO( \
 				const struct inode *inode, \
-				struct folio *folio, \
+				loff_t offset, \
+				size_t count, \
 				int ret \
 			), \
-			TP_ARGS(inode, folio, ret))
+			TP_ARGS(inode, offset, count, ret))
 
 DEFINE_NFS_FOLIO_EVENT(nfs_aop_readpage);
 DEFINE_NFS_FOLIO_EVENT_DONE(nfs_aop_readpage_done);
--- a/fs/nfs/read.c
+++ b/fs/nfs/read.c
@@ -333,13 +333,15 @@ out:
 int nfs_read_folio(struct file *file, struct folio *folio)
 {
 	struct inode *inode = file_inode(file);
+	loff_t pos = folio_pos(folio);
+	size_t len = folio_size(folio);
 	struct nfs_pageio_descriptor pgio;
 	struct nfs_open_context *ctx;
 	int ret;
 
-	trace_nfs_aop_readpage(inode, folio);
+	trace_nfs_aop_readpage(inode, pos, len);
 	nfs_inc_stats(inode, NFSIOS_VFSREADPAGE);
-	task_io_account_read(folio_size(folio));
+	task_io_account_read(len);
 
 	/*
 	 * Try to flush any pending writes to the file..
@@ -382,7 +384,7 @@ int nfs_read_folio(struct file *file, st
 out_put:
 	put_nfs_open_context(ctx);
 out:
-	trace_nfs_aop_readpage_done(inode, folio, ret);
+	trace_nfs_aop_readpage_done(inode, pos, len, ret);
 	return ret;
 out_unlock:
 	folio_unlock(folio);
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2131,17 +2131,17 @@ int nfs_wb_folio_cancel(struct inode *in
  */
 int nfs_wb_folio(struct inode *inode, struct folio *folio)
 {
-	loff_t range_start = folio_file_pos(folio);
-	loff_t range_end = range_start + (loff_t)folio_size(folio) - 1;
+	loff_t range_start = folio_pos(folio);
+	size_t len = folio_size(folio);
 	struct writeback_control wbc = {
 		.sync_mode = WB_SYNC_ALL,
 		.nr_to_write = 0,
 		.range_start = range_start,
-		.range_end = range_end,
+		.range_end = range_start + len - 1,
 	};
 	int ret;
 
-	trace_nfs_writeback_folio(inode, folio);
+	trace_nfs_writeback_folio(inode, range_start, len);
 
 	for (;;) {
 		folio_wait_writeback(folio);
@@ -2159,7 +2159,7 @@ int nfs_wb_folio(struct inode *inode, st
 			goto out_error;
 	}
 out_error:
-	trace_nfs_writeback_folio_done(inode, folio, ret);
+	trace_nfs_writeback_folio_done(inode, range_start, len, ret);
 	return ret;
 }
 


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
queue-6.6/nfs-pass-explicit-offset-count-to-trace-events.patch
queue-6.6/nfs-fix-a-deadlock-involving-nfs_release_folio.patch
