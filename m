Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 99E383C73F9;
	Thu, 19 Mar 2026 11:13:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773918817; cv=none; b=ujPswF/HojjuzWQS7WW/rBnf25DWAxbAzntAMpyQ5yUnVfwV9zMV1cC9y7NxAHQtheIjZvAm0MKiHFPFzVWl1a2pFKDFDBEy4HvfA+HJJtddrnFH3acH99+iTj8Krim1pExIiQ05zBsacIEk0IwZ7p1iDeYeg4IYsDwn7kH4SSQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773918817; c=relaxed/simple;
	bh=6beKDERkuTDR2mjmfUbAvd+YsuHGYv8cQ3gCS0jJuWQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:Message-ID:MIME-Version:
	 Content-Type; b=oCBuXxGqFLPDPDrKfRc4MVifN0EDSVbiGM/YfzlZsGU6chM4vWZ6n3D0pr/QUAOmcHNzjnBbTO/T+8VfN9A5qjHo+2iMRH+qq+Df2pQnM7NgtQWh+ef7DscyBOkDj1iilbhau/Xpq3i7jVxgV6TQvW0e0c/TNFsyf8ZpOu1YF9M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zRWHzgf7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zRWHzgf7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 94169C19424;
	Thu, 19 Mar 2026 11:13:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773918817;
	bh=6beKDERkuTDR2mjmfUbAvd+YsuHGYv8cQ3gCS0jJuWQ=;
	h=Subject:To:Cc:From:Date:In-Reply-To:From;
	b=zRWHzgf75n6GiFCdgVQie8ogfZPRiRopmr2AChlOwFAEUb3QY7jioPRIDLjlaVsgq
	 RR6HfWH2mIHI8kCp6hYxmdYYGh4uMcugLeF7as54z3SPLFHRux/4H9931Fz6Fe7UGO
	 s5Ci7p8NUlkGalEei6yrhmnAEkrL8l9A2efhrvo0=
Subject: Patch "NFS: Fix a deadlock involving nfs_release_folio()" has been added to the 6.6-stable tree
To: 1468888505@139.com,anna@kernel.org,gregkh@linuxfoundation.org,patches@lists.linux.dev,trond.myklebust@hammerspace.com,wangzhaolong@huaweicloud.com
Cc: <stable-commits@vger.kernel.org>
From: <gregkh@linuxfoundation.org>
Date: Thu, 19 Mar 2026 12:12:52 +0100
In-Reply-To: <20260224070237.2933965-1-1468888505@139.com>
Message-ID: <2026031952-erupt-scoff-c087@gregkh>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=ANSI_X3.4-1968
Content-Transfer-Encoding: 8bit
X-stable: commit
X-Patchwork-Hint: ignore 


This is a note to let you know that I've just added the patch titled

    NFS: Fix a deadlock involving nfs_release_folio()

to the 6.6-stable tree which can be found at:
    http://www.kernel.org/git/?p=linux/kernel/git/stable/stable-queue.git;a=summary

The filename of the patch is:
     nfs-fix-a-deadlock-involving-nfs_release_folio.patch
and it can be found in the queue-6.6 subdirectory.

If you, or anyone else, feels it should not be added to the stable tree,
please let <stable@vger.kernel.org> know about it.


From stable+bounces-217867-greg=kroah.com@vger.kernel.org Tue Feb 24 08:02:54 2026
From: Li hongliang <1468888505@139.com>
Date: Tue, 24 Feb 2026 15:02:37 +0800
Subject: NFS: Fix a deadlock involving nfs_release_folio()
To: gregkh@linuxfoundation.org, stable@vger.kernel.org, trond.myklebust@hammerspace.com
Cc: patches@lists.linux.dev, linux-kernel@vger.kernel.org, anna@kernel.org, linux-nfs@vger.kernel.org, wangzhaolong@huaweicloud.com
Message-ID: <20260224070237.2933965-1-1468888505@139.com>

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit cce0be6eb4971456b703aaeafd571650d314bcca ]

Wang Zhaolong reports a deadlock involving NFSv4.1 state recovery
waiting on kthreadd, which is attempting to reclaim memory by calling
nfs_release_folio(). The latter cannot make progress due to state
recovery being needed.

It seems that the only safe thing to do here is to kick off a writeback
of the folio, without waiting for completion, or else kicking off an
asynchronous commit.

Reported-by: Wang Zhaolong <wangzhaolong@huaweicloud.com>
Fixes: 96780ca55e3c ("NFS: fix up nfs_release_folio() to try to release the page")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
[ Minor conflict resolved. ]
Signed-off-by: Li hongliang <1468888505@139.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/file.c          |    3 ++-
 fs/nfs/nfstrace.h      |    3 +++
 fs/nfs/write.c         |   33 +++++++++++++++++++++++++++++++++
 include/linux/nfs_fs.h |    1 +
 4 files changed, 39 insertions(+), 1 deletion(-)

--- a/fs/nfs/file.c
+++ b/fs/nfs/file.c
@@ -459,7 +459,8 @@ static bool nfs_release_folio(struct fol
 		if ((current_gfp_context(gfp) & GFP_KERNEL) != GFP_KERNEL ||
 		    current_is_kswapd() || current_is_kcompactd())
 			return false;
-		if (nfs_wb_folio(folio_file_mapping(folio)->host, folio) < 0)
+		if (nfs_wb_folio_reclaim(folio_file_mapping(folio)->host, folio) < 0 ||
+		    folio_test_private(folio))
 			return false;
 	}
 	return nfs_fscache_release_folio(folio, gfp);
--- a/fs/nfs/nfstrace.h
+++ b/fs/nfs/nfstrace.h
@@ -1033,6 +1033,9 @@ DECLARE_EVENT_CLASS(nfs_folio_event_done
 DEFINE_NFS_FOLIO_EVENT(nfs_aop_readpage);
 DEFINE_NFS_FOLIO_EVENT_DONE(nfs_aop_readpage_done);
 
+DEFINE_NFS_FOLIO_EVENT(nfs_writeback_folio_reclaim);
+DEFINE_NFS_FOLIO_EVENT_DONE(nfs_writeback_folio_reclaim_done);
+
 DEFINE_NFS_FOLIO_EVENT(nfs_writeback_folio);
 DEFINE_NFS_FOLIO_EVENT_DONE(nfs_writeback_folio_done);
 
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -2122,6 +2122,39 @@ int nfs_wb_folio_cancel(struct inode *in
 }
 
 /**
+ * nfs_wb_folio_reclaim - Write back all requests on one page
+ * @inode: pointer to page
+ * @folio: pointer to folio
+ *
+ * Assumes that the folio has been locked by the caller
+ */
+int nfs_wb_folio_reclaim(struct inode *inode, struct folio *folio)
+{
+	loff_t range_start = folio_pos(folio);
+	size_t len = folio_size(folio);
+	struct writeback_control wbc = {
+		.sync_mode = WB_SYNC_ALL,
+		.nr_to_write = 0,
+		.range_start = range_start,
+		.range_end = range_start + len - 1,
+		.for_sync = 1,
+	};
+	int ret;
+
+	if (folio_test_writeback(folio))
+		return -EBUSY;
+	if (folio_clear_dirty_for_io(folio)) {
+		trace_nfs_writeback_folio_reclaim(inode, range_start, len);
+		ret = nfs_writepage_locked(folio, &wbc);
+		trace_nfs_writeback_folio_reclaim_done(inode, range_start, len,
+						       ret);
+		return ret;
+	}
+	nfs_commit_inode(inode, 0);
+	return 0;
+}
+
+/**
  * nfs_wb_folio - Write back all requests on one page
  * @inode: pointer to page
  * @folio: pointer to folio
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -608,6 +608,7 @@ extern int  nfs_update_folio(struct file
 extern int nfs_sync_inode(struct inode *inode);
 extern int nfs_wb_all(struct inode *inode);
 extern int nfs_wb_folio(struct inode *inode, struct folio *folio);
+extern int nfs_wb_folio_reclaim(struct inode *inode, struct folio *folio);
 int nfs_wb_folio_cancel(struct inode *inode, struct folio *folio);
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_commit_data *nfs_commitdata_alloc(void);


Patches currently in stable-queue which might be from 1468888505@139.com are

queue-6.6/pnfs-fix-a-deadlock-when-returning-a-delegation-during-open.patch
queue-6.6/nfs-pass-explicit-offset-count-to-trace-events.patch
queue-6.6/nfs-fix-a-deadlock-involving-nfs_release_folio.patch
