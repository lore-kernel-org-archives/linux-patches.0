Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA82B1CF94
	for <patches@lists.linux.dev>; Wed,  4 Oct 2023 18:23:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WngmIX/h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38F12C433C8;
	Wed,  4 Oct 2023 18:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696443794;
	bh=pN85DW/3TyxJhsAMUcMxkc64hZl0byNWRgT2SxUgCSI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WngmIX/h8BLWzBqkx7XWbPEdaLxqQh8jo2OsZBP5UqVKAqG8sXu8AOYBMd3ooEYcD
	 gZDbH+Ta+mEoLktOd5QYYIB6tM0TvsL0KBQZ739kPeCYOtQNgLLLNTJ1S3bICrafpd
	 UCv1mvODE8D7fao8S1e9Ovs1yBuLkZiJ4z9/F4Cw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 003/321] NFS: More O_DIRECT accounting fixes for error paths
Date: Wed,  4 Oct 2023 19:52:28 +0200
Message-ID: <20231004175229.372040360@linuxfoundation.org>
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

[ Upstream commit 8982f7aff39fb526aba4441fff2525fcedd5e1a3 ]

If we hit a fatal error when retransmitting, we do need to record the
removal of the request from the count of written bytes.

Fixes: 031d73ed768a ("NFS: Fix O_DIRECT accounting of number of bytes read/written")
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Anna Schumaker <Anna.Schumaker@Netapp.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/nfs/direct.c | 47 +++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/fs/nfs/direct.c b/fs/nfs/direct.c
index e8a1645857dd6..a53e501234993 100644
--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -93,12 +93,10 @@ nfs_direct_handle_truncated(struct nfs_direct_req *dreq,
 		dreq->max_count = dreq_len;
 		if (dreq->count > dreq_len)
 			dreq->count = dreq_len;
-
-		if (test_bit(NFS_IOHDR_ERROR, &hdr->flags))
-			dreq->error = hdr->error;
-		else /* Clear outstanding error if this is EOF */
-			dreq->error = 0;
 	}
+
+	if (test_bit(NFS_IOHDR_ERROR, &hdr->flags) && !dreq->error)
+		dreq->error = hdr->error;
 }
 
 static void
@@ -120,6 +118,18 @@ nfs_direct_count_bytes(struct nfs_direct_req *dreq,
 		dreq->count = dreq_len;
 }
 
+static void nfs_direct_truncate_request(struct nfs_direct_req *dreq,
+					struct nfs_page *req)
+{
+	loff_t offs = req_offset(req);
+	size_t req_start = (size_t)(offs - dreq->io_start);
+
+	if (req_start < dreq->max_count)
+		dreq->max_count = req_start;
+	if (req_start < dreq->count)
+		dreq->count = req_start;
+}
+
 /**
  * nfs_swap_rw - NFS address space operation for swap I/O
  * @iocb: target I/O control block
@@ -537,10 +547,6 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 
 	nfs_direct_join_group(&reqs, dreq->inode);
 
-	dreq->count = 0;
-	dreq->max_count = 0;
-	list_for_each_entry(req, &reqs, wb_list)
-		dreq->max_count += req->wb_bytes;
 	nfs_clear_pnfs_ds_commit_verifiers(&dreq->ds_cinfo);
 	get_dreq(dreq);
 
@@ -574,10 +580,14 @@ static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 		req = nfs_list_entry(reqs.next);
 		nfs_list_remove_request(req);
 		nfs_unlock_and_release_request(req);
-		if (desc.pg_error == -EAGAIN)
+		if (desc.pg_error == -EAGAIN) {
 			nfs_mark_request_commit(req, NULL, &cinfo, 0);
-		else
+		} else {
+			spin_lock(&dreq->lock);
+			nfs_direct_truncate_request(dreq, req);
+			spin_unlock(&dreq->lock);
 			nfs_release_request(req);
+		}
 	}
 
 	if (put_dreq(dreq))
@@ -597,8 +607,6 @@ static void nfs_direct_commit_complete(struct nfs_commit_data *data)
 	if (status < 0) {
 		/* Errors in commit are fatal */
 		dreq->error = status;
-		dreq->max_count = 0;
-		dreq->count = 0;
 		dreq->flags = NFS_ODIRECT_DONE;
 	} else {
 		status = dreq->error;
@@ -609,7 +617,12 @@ static void nfs_direct_commit_complete(struct nfs_commit_data *data)
 	while (!list_empty(&data->pages)) {
 		req = nfs_list_entry(data->pages.next);
 		nfs_list_remove_request(req);
-		if (status >= 0 && !nfs_write_match_verf(verf, req)) {
+		if (status < 0) {
+			spin_lock(&dreq->lock);
+			nfs_direct_truncate_request(dreq, req);
+			spin_unlock(&dreq->lock);
+			nfs_release_request(req);
+		} else if (!nfs_write_match_verf(verf, req)) {
 			dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
 			/*
 			 * Despite the reboot, the write was successful,
@@ -617,7 +630,7 @@ static void nfs_direct_commit_complete(struct nfs_commit_data *data)
 			 */
 			req->wb_nio = 0;
 			nfs_mark_request_commit(req, NULL, &cinfo, 0);
-		} else /* Error or match */
+		} else
 			nfs_release_request(req);
 		nfs_unlock_and_release_request(req);
 	}
@@ -670,6 +683,7 @@ static void nfs_direct_write_clear_reqs(struct nfs_direct_req *dreq)
 	while (!list_empty(&reqs)) {
 		req = nfs_list_entry(reqs.next);
 		nfs_list_remove_request(req);
+		nfs_direct_truncate_request(dreq, req);
 		nfs_release_request(req);
 		nfs_unlock_and_release_request(req);
 	}
@@ -719,7 +733,8 @@ static void nfs_direct_write_completion(struct nfs_pgio_header *hdr)
 	}
 
 	nfs_direct_count_bytes(dreq, hdr);
-	if (test_bit(NFS_IOHDR_UNSTABLE_WRITES, &hdr->flags)) {
+	if (test_bit(NFS_IOHDR_UNSTABLE_WRITES, &hdr->flags) &&
+	    !test_bit(NFS_IOHDR_ERROR, &hdr->flags)) {
 		if (!dreq->flags)
 			dreq->flags = NFS_ODIRECT_DO_COMMIT;
 		flags = dreq->flags;
-- 
2.40.1



