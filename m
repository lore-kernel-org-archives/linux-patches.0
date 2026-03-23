Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5193E242D70;
	Mon, 23 Mar 2026 15:12:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774278753; cv=none; b=TZeK71CK73bGwsayGu3FEhrIkFaxUAaGe6VWOjbPBvhuKl8sEOgW4aoBsDpNSC3QvdZ1g3gKxIR3IeWFJwh62I1CQkPMheh8D3vCGJO3xChVYPWKmquokh3CtyQvydQjDy7P6xZrSY+n50sPHXcNUJijCSe+CHi3T7u288JEfiQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774278753; c=relaxed/simple;
	bh=Y9B+dvlLesEZ5Et/m9ns622rVVr1P585n+kKitBa6ic=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=RBsdOBHyOVfZCgLKwZvn4uE116mC4BPpaya+WLR3prIMlEHSycj15mUN6VZZqPWIazVhz432PtgJp1OvyH3lK5FMzuOI0UmPkl0qJfH7iKLHxkEeydp7ZwafJCv1Vwcke/nKYSBjkPT/pYqJ6ZoZi2EcCXqifEaV3c2/jHIiDFk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SgINRqHC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SgINRqHC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D62D1C4CEF7;
	Mon, 23 Mar 2026 15:12:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774278753;
	bh=Y9B+dvlLesEZ5Et/m9ns622rVVr1P585n+kKitBa6ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SgINRqHC6mBVMZAnvWd19jria4myONCbNh1mIKR4NHRxva8teVx1jNrJOoCV57gV1
	 0YqtHSa4S+Ame8mRqTUMIHT0zL1X3aNSoCUK52QWl8bZRaXuy6tDjNeFkw6UIW3vVY
	 OhdCQP5MNMe2Cgw294QkL9uJBLEXpVd6L3cqrLhs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuck Lever <chuck.lever@oracle.com>,
	Christoph Hellwig <hch@lst.de>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Li hongliang <1468888505@139.com>
Subject: [PATCH 6.6 407/567] nfs: pass explicit offset/count to trace events
Date: Mon, 23 Mar 2026 14:45:27 +0100
Message-ID: <20260323134543.948170383@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134533.749096647@linuxfoundation.org>
References: <20260323134533.749096647@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

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
 


