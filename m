Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70F002FDC5C;
	Tue, 26 Aug 2025 14:45:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756219510; cv=none; b=k77MhYPWPky7OzVamZt1WSGvqaxMLeeuBIBN6iwnMx5y2EpJ2P7mRIH0TdFJDDfW5O1VN8xW4CBAQV5Td5biCBt5+POMhQTvO57Sjiensttj0queK2hkjqlkajPkCaqU2lV4U0nNyVS0px1H7AHP/d2NQWETXt6NqA0QRlvdEUI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756219510; c=relaxed/simple;
	bh=aFBnRvvV98YqgdZJRGGH8pIlFVwyIeHNlLl3Ci6HqZc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u0YFTJH60yLXTVrKWyIlLIbqZFwhJoCX2Qy6pCqV+Ad0PYDFWl9Jaqj7vLgCXZVzxNWoo5aX4I7vNFj+xw/O3sjyIb89CbgE3n9+Eqkmr/7+n9VySyNBWp6ugiQQ6/KXsJM/XCc7Dh4fNOTiC1HWtoOvEikkCkI5shhyQrsrZyE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NSXWGexB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NSXWGexB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06AD0C4CEF1;
	Tue, 26 Aug 2025 14:45:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756219510;
	bh=aFBnRvvV98YqgdZJRGGH8pIlFVwyIeHNlLl3Ci6HqZc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NSXWGexBhA4MVd6kQbL9gGHzitiUR2DtDm1wG6PeqE8ojByu1g3ktVgqmiYfZpolT
	 AKrvx8EN0gG7q3fPPZ7aiMfqSmIKGn/4rLQIrJZq2dcfsBZbtI8+4dIuyfH2PVEKQm
	 YvRDuXYS1eRG77t8+llaNvRIGpOHwmIo0SerTivQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Chanho Min <chanho.min@lge.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 392/403] NFS: Fix up commit deadlocks
Date: Tue, 26 Aug 2025 13:11:58 +0200
Message-ID: <20250826110917.863347852@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110905.607690791@linuxfoundation.org>
References: <20250826110905.607690791@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

commit 133a48abf6ecc535d7eddc6da1c3e4c972445882 upstream.

If O_DIRECT bumps the commit_info rpcs_out field, then that could lead
to fsync() hangs. The fix is to ensure that O_DIRECT calls
nfs_commit_end().

Fixes: 723c921e7dfc ("sched/wait, fs/nfs: Convert wait_on_atomic_t() usage to the new wait_var_event() API")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Chanho Min <chanho.min@lge.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c        |    2 +-
 fs/nfs/write.c         |    9 ++++++---
 include/linux/nfs_fs.h |    1 +
 3 files changed, 8 insertions(+), 4 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -700,7 +700,7 @@ static void nfs_direct_commit_complete(s
 		nfs_unlock_and_release_request(req);
 	}
 
-	if (atomic_dec_and_test(&cinfo.mds->rpcs_out))
+	if (nfs_commit_end(cinfo.mds))
 		nfs_direct_write_complete(dreq);
 }
 
--- a/fs/nfs/write.c
+++ b/fs/nfs/write.c
@@ -1658,10 +1658,13 @@ static void nfs_commit_begin(struct nfs_
 	atomic_inc(&cinfo->rpcs_out);
 }
 
-static void nfs_commit_end(struct nfs_mds_commit_info *cinfo)
+bool nfs_commit_end(struct nfs_mds_commit_info *cinfo)
 {
-	if (atomic_dec_and_test(&cinfo->rpcs_out))
+	if (atomic_dec_and_test(&cinfo->rpcs_out)) {
 		wake_up_var(&cinfo->rpcs_out);
+		return true;
+	}
+	return false;
 }
 
 void nfs_commitdata_release(struct nfs_commit_data *data)
@@ -1756,6 +1759,7 @@ void nfs_init_commit(struct nfs_commit_d
 	data->res.fattr   = &data->fattr;
 	data->res.verf    = &data->verf;
 	nfs_fattr_init(&data->fattr);
+	nfs_commit_begin(cinfo->mds);
 }
 EXPORT_SYMBOL_GPL(nfs_init_commit);
 
@@ -1801,7 +1805,6 @@ nfs_commit_list(struct inode *inode, str
 
 	/* Set up the argument struct */
 	nfs_init_commit(data, head, NULL, cinfo);
-	atomic_inc(&cinfo->mds->rpcs_out);
 	return nfs_initiate_commit(NFS_CLIENT(inode), data, NFS_PROTO(inode),
 				   data->mds_ops, how, 0);
 }
--- a/include/linux/nfs_fs.h
+++ b/include/linux/nfs_fs.h
@@ -549,6 +549,7 @@ extern int nfs_wb_page_cancel(struct ino
 extern int  nfs_commit_inode(struct inode *, int);
 extern struct nfs_commit_data *nfs_commitdata_alloc(bool never_fail);
 extern void nfs_commit_free(struct nfs_commit_data *data);
+bool nfs_commit_end(struct nfs_mds_commit_info *cinfo);
 
 static inline int
 nfs_have_writebacks(struct inode *inode)


