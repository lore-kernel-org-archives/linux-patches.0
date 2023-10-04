Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47A721D546
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF565C433C7;
	Wed,  4 Oct 2023 18:10:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443023;
	bh=DFzt/MZiUBY14IDkdINSUzVti9Y3ZiQLVt+OCgeP7/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bWcBjZwmv9IWMgxyuyFkYsJ+Lo9LV+ZuUOk3GIytzgjbiP5ZtJTl2qp14sdrJMWan
	 n9CPiMPzR79rhdbY7rqRH4PD3LXPqtaumTlgjv3wKuzWFUPCNLhHK/mnWFYkfGZgRc
	 5f3uZ1voftwF2QMNjFoDbt55OBkg4V8c047GiQhU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 001/259] NFS: Fix error handling for O_DIRECT write scheduling
Date: Wed,  4 Oct 2023 19:52:54 +0200
Message-ID: <20231004175217.488223658@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175217.404851126@linuxfoundation.org>
References: <20231004175217.404851126@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Trond Myklebust <trond.myklebust@hammerspace.com>

[ Upstream commit 954998b60caa8f2a3bf3abe490de6f08d283687a ]

If we fail to schedule a request for transmission, there are 2
possibilities:
1) Either we hit a fatal error, and we just want to drop the remaining
   requests on the floor.
2) We were asked to try again, in which case we should allow the
   outstanding RPC calls to complete, so that we can recoalesce requests
   and try again.

Fixes: d600ad1f2bdb ("NFS41: pop some layoutget errors to application")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 62 ++++++++++++++++++++++++++++++++++++-------------
 1 file changed, 46 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index 3bb530d4bb5ce..d71762f32b6c4 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -530,10 +530,9 @@ nfs_direct_write_scan_commit_list(struct inode *inode,
 static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 {
 	struct nfs_pageio_descriptor desc;
-	struct nfs_page *req, *tmp;
+	struct nfs_page *req;
 	LIST_HEAD(reqs);
 	struct nfs_commit_info cinfo;
-	LIST_HEAD(failed);
 
 	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 	nfs_direct_write_scan_commit_list(dreq->inode, &reqs, &cinfo);
@@ -551,27 +550,36 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 			      &nfs_direct_write_completion_ops);
 	desc.pg_dreq = dreq;
 
-	list_for_each_entry_safe(req, tmp, &reqs, wb_list) {
+	while (!list_empty(&reqs)) {
+		req = nfs_list_entry(reqs.next);
 		/* Bump the transmission count */
 		req->wb_nio++;
 		if (!nfs_pageio_add_request(&desc, req)) {
-			nfs_list_move_request(req, &failed);
 			spin_lock(&cinfo.inode->i_lock);
-			dreq->flags = 0;
-			if (desc.pg_error < 0)
+			if (dreq->error < 0) {
+				desc.pg_error = dreq->error;
+			} else if (desc.pg_error != -EAGAIN) {
+				dreq->flags = 0;
+				if (!desc.pg_error)
+					desc.pg_error = -EIO;
 				dreq->error = desc.pg_error;
-			else
-				dreq->error = -EIO;
+			} else
+				dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
 			spin_unlock(&cinfo.inode->i_lock);
+			break;
 		}
 		nfs_release_request(req);
 	}
 	nfs_pageio_complete(&desc);
 
-	while (!list_empty(&failed)) {
-		req = nfs_list_entry(failed.next);
+	while (!list_empty(&reqs)) {
+		req = nfs_list_entry(reqs.next);
 		nfs_list_remove_request(req);
 		nfs_unlock_and_release_request(req);
+		if (desc.pg_error == -EAGAIN)
+			nfs_mark_request_commit(req, NULL, &cinfo, 0);
+		else
+			nfs_release_request(req);
 	}
 
 	if (put_dreq(dreq))
@@ -796,9 +804,11 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
+	struct nfs_commit_info cinfo;
 	ssize_t result = 0;
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
+	bool defer = false;
 
 	trace_nfs_direct_write_schedule_iovec(dreq);
 
@@ -839,19 +849,39 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 				break;
 			}
 
+			pgbase = 0;
+			bytes -= req_len;
+			requested_bytes += req_len;
+			pos += req_len;
+			dreq->bytes_left -= req_len;
+
+			if (defer) {
+				nfs_mark_request_commit(req, NULL, &cinfo, 0);
+				continue;
+			}
+
 			nfs_lock_request(req);
 			req->wb_index = pos >> PAGE_SHIFT;
 			req->wb_offset = pos & ~PAGE_MASK;
-			if (!nfs_pageio_add_request(&desc, req)) {
+			if (nfs_pageio_add_request(&desc, req))
+				continue;
+
+			/* Exit on hard errors */
+			if (desc.pg_error < 0 && desc.pg_error != -EAGAIN) {
 				result = desc.pg_error;
 				nfs_unlock_and_release_request(req);
 				break;
 			}
-			pgbase = 0;
-			bytes -= req_len;
-			requested_bytes += req_len;
-			pos += req_len;
-			dreq->bytes_left -= req_len;
+
+			/* If the error is soft, defer remaining requests */
+			nfs_init_cinfo_from_dreq(&cinfo, dreq);
+			spin_lock(&cinfo.inode->i_lock);
+			dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
+			spin_unlock(&cinfo.inode->i_lock);
+			nfs_unlock_request(req);
+			nfs_mark_request_commit(req, NULL, &cinfo, 0);
+			desc.pg_error = 0;
+			defer = true;
 		}
 		nfs_direct_release_pages(pagevec, npages);
 		kvfree(pagevec);
-- 
2.40.1



