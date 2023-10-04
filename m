Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32E4A1D68D
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:22:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="V+TtX+8g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33A1C433C7;
	Wed,  4 Oct 2023 18:22:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443755;
	bh=jcxNQ1plkWsy9x84sXn858tyghzck7/RWCbO365Cf2Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=V+TtX+8ggy7d1jJHZVtKax1HXvTfUdISKLZ1iQGn2CxTL/MeZRL6G8gdqG21JD7nl
	 Ly1BVHtrk1bEzeYEZd96SVD+JC5Yej4Ng+1Igc6pqvqXDjlL9utkQ/qXHAXq8JTRd8
	 LTafDNqrTsiMDNNH/hw9gnhBDZO1mOvlUANgdP1k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 001/321] NFS: Fix error handling for O_DIRECT write scheduling
Date: Wed,  4 Oct 2023 19:52:26 +0200
Message-ID: <20231004175229.288366501@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231004175229.211487444@linuxfoundation.org>
References: <20231004175229.211487444@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

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
index 47d892a1d363d..ee88f0a6e7b81 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -528,10 +528,9 @@ nfs_direct_write_scan_commit_list(struct inode *inode,
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
@@ -549,27 +548,36 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
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
@@ -794,9 +802,11 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
+	struct nfs_commit_info cinfo;
 	ssize_t result = 0;
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
+	bool defer = false;
 
 	trace_nfs_direct_write_schedule_iovec(dreq);
 
@@ -837,17 +847,37 @@ static ssize_t nfs_direct_write_schedule_iovec(struct nfs_direct_req *dreq,
 				break;
 			}
 
-			nfs_lock_request(req);
-			if (!nfs_pageio_add_request(&desc, req)) {
-				result = desc.pg_error;
-				nfs_unlock_and_release_request(req);
-				break;
-			}
 			pgbase = 0;
 			bytes -= req_len;
 			requested_bytes += req_len;
 			pos += req_len;
 			dreq->bytes_left -= req_len;
+
+			if (defer) {
+				nfs_mark_request_commit(req, NULL, &cinfo, 0);
+				continue;
+			}
+
+			nfs_lock_request(req);
+			if (nfs_pageio_add_request(&desc, req))
+				continue;
+
+			/* Exit on hard errors */
+			if (desc.pg_error < 0 && desc.pg_error != -EAGAIN) {
+				result = desc.pg_error;
+				nfs_unlock_and_release_request(req);
+				break;
+			}
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



