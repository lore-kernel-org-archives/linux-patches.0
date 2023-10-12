Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5D855347CD
	for <patches@lists.linux.dev>; Thu, 12 Oct 2023 18:01:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="b4KhDyD9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8197C433C9;
	Thu, 12 Oct 2023 18:01:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1697133670;
	bh=PXRW/arEEH/uggsXObpOk86t1O/RFD3qShClYbAwxYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b4KhDyD9kvJpCzIgLLX/Kv8ioL6IEg2zumF9NVp58pWxXD8AZ4OgfC930oNqbYjo+
	 /0AU5xXsGqPEO4T74/XWJGFTSS08kgJYZzpSH6DdvvSw+jcuKxF+sPB4e+KLvF+OUk
	 Qet+nfrrGH8sFj3hfcGcTwInOdHm+VGAu8lOjg8A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	poester <poester@internetbrands.com>,
	=?UTF-8?q?Daniel=20D=C3=ADaz?= <daniel.diaz@linaro.org>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Anna Schumaker <Anna.Schumaker@Netapp.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 5/6] Revert "NFS: Fix error handling for O_DIRECT write scheduling"
Date: Thu, 12 Oct 2023 20:00:47 +0200
Message-ID: <20231012180030.258223662@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231012180030.112560642@linuxfoundation.org>
References: <20231012180030.112560642@linuxfoundation.org>
User-Agent: quilt/0.67
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

This reverts commit f16fd0b11f0f4d41846b5102b1656ea1fc9ac7a0 which is
commit 954998b60caa8f2a3bf3abe490de6f08d283687a upstream.

There are reported NFS problems in the 6.1.56 release, so revert a set
of NFS patches to hopefully resolve the issue.

Reported-by: poester <poester@internetbrands.com>
Link: https://lore.kernel.org/r/20231012165439.137237-2-kernel@linuxace.com
Reported-by: Daniel Díaz <daniel.diaz@linaro.org>
Link: https://lore.kernel.org/r/2023100755-livestock-barcode-fe41@gregkh
Cc: Trond Myklebust <trond.myklebust@hammerspace.com>
Cc: Anna Schumaker <Anna.Schumaker@Netapp.com>
Cc: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/nfs/direct.c |   62 ++++++++++++++------------------------------------------
 1 file changed, 16 insertions(+), 46 deletions(-)

--- a/fs/nfs/direct.c
+++ b/fs/nfs/direct.c
@@ -530,9 +530,10 @@ nfs_direct_write_scan_commit_list(struct
 static void nfs_direct_write_reschedule(struct nfs_direct_req *dreq)
 {
 	struct nfs_pageio_descriptor desc;
-	struct nfs_page *req;
+	struct nfs_page *req, *tmp;
 	LIST_HEAD(reqs);
 	struct nfs_commit_info cinfo;
+	LIST_HEAD(failed);
 
 	nfs_init_cinfo_from_dreq(&cinfo, dreq);
 	nfs_direct_write_scan_commit_list(dreq->inode, &reqs, &cinfo);
@@ -550,36 +551,27 @@ static void nfs_direct_write_reschedule(
 			      &nfs_direct_write_completion_ops);
 	desc.pg_dreq = dreq;
 
-	while (!list_empty(&reqs)) {
-		req = nfs_list_entry(reqs.next);
+	list_for_each_entry_safe(req, tmp, &reqs, wb_list) {
 		/* Bump the transmission count */
 		req->wb_nio++;
 		if (!nfs_pageio_add_request(&desc, req)) {
+			nfs_list_move_request(req, &failed);
 			spin_lock(&cinfo.inode->i_lock);
-			if (dreq->error < 0) {
-				desc.pg_error = dreq->error;
-			} else if (desc.pg_error != -EAGAIN) {
-				dreq->flags = 0;
-				if (!desc.pg_error)
-					desc.pg_error = -EIO;
+			dreq->flags = 0;
+			if (desc.pg_error < 0)
 				dreq->error = desc.pg_error;
-			} else
-				dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
+			else
+				dreq->error = -EIO;
 			spin_unlock(&cinfo.inode->i_lock);
-			break;
 		}
 		nfs_release_request(req);
 	}
 	nfs_pageio_complete(&desc);
 
-	while (!list_empty(&reqs)) {
-		req = nfs_list_entry(reqs.next);
+	while (!list_empty(&failed)) {
+		req = nfs_list_entry(failed.next);
 		nfs_list_remove_request(req);
 		nfs_unlock_and_release_request(req);
-		if (desc.pg_error == -EAGAIN)
-			nfs_mark_request_commit(req, NULL, &cinfo, 0);
-		else
-			nfs_release_request(req);
 	}
 
 	if (put_dreq(dreq))
@@ -804,11 +796,9 @@ static ssize_t nfs_direct_write_schedule
 {
 	struct nfs_pageio_descriptor desc;
 	struct inode *inode = dreq->inode;
-	struct nfs_commit_info cinfo;
 	ssize_t result = 0;
 	size_t requested_bytes = 0;
 	size_t wsize = max_t(size_t, NFS_SERVER(inode)->wsize, PAGE_SIZE);
-	bool defer = false;
 
 	trace_nfs_direct_write_schedule_iovec(dreq);
 
@@ -849,39 +839,19 @@ static ssize_t nfs_direct_write_schedule
 				break;
 			}
 
-			pgbase = 0;
-			bytes -= req_len;
-			requested_bytes += req_len;
-			pos += req_len;
-			dreq->bytes_left -= req_len;
-
-			if (defer) {
-				nfs_mark_request_commit(req, NULL, &cinfo, 0);
-				continue;
-			}
-
 			nfs_lock_request(req);
 			req->wb_index = pos >> PAGE_SHIFT;
 			req->wb_offset = pos & ~PAGE_MASK;
-			if (nfs_pageio_add_request(&desc, req))
-				continue;
-
-			/* Exit on hard errors */
-			if (desc.pg_error < 0 && desc.pg_error != -EAGAIN) {
+			if (!nfs_pageio_add_request(&desc, req)) {
 				result = desc.pg_error;
 				nfs_unlock_and_release_request(req);
 				break;
 			}
-
-			/* If the error is soft, defer remaining requests */
-			nfs_init_cinfo_from_dreq(&cinfo, dreq);
-			spin_lock(&cinfo.inode->i_lock);
-			dreq->flags = NFS_ODIRECT_RESCHED_WRITES;
-			spin_unlock(&cinfo.inode->i_lock);
-			nfs_unlock_request(req);
-			nfs_mark_request_commit(req, NULL, &cinfo, 0);
-			desc.pg_error = 0;
-			defer = true;
+			pgbase = 0;
+			bytes -= req_len;
+			requested_bytes += req_len;
+			pos += req_len;
+			dreq->bytes_left -= req_len;
 		}
 		nfs_direct_release_pages(pagevec, npages);
 		kvfree(pagevec);


