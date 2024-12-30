Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A5762AE68;
	Mon, 30 Dec 2024 15:49:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573770; cv=none; b=s0k86r+QXbw2ieiVvyrVr/4TRlflv276eBZUFwlhkDY/VIB5SdP2/alcaKLsGC3YjyrKTeGchV3gmbCG6IxTTx0BqVpKE8EB3j5t02Dj5saKRxA6WSQL6CTUVwyky52Ayk/1Op4TL8FbfBNxXScHXpm5qy6u9PNf4joCZL10sL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573770; c=relaxed/simple;
	bh=9xedS9lfiRd8MCux7JJzvrdmxTHh9pbW5311ahOp5mA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jLhWkjMWs2gDwbyiMb+Ex6Pp7TUNtLLb/6jbXOJuz/aT/fdiS3VezPKVpYy6fTT6kKnmJkJJizExrXDoT6Ks9WiWXw+rVyg2udxaf0LKUtxtXUar6vt+JFdP7LFKQFAMnaZXAO/YHydj11HaiMDvXUQ8LchTxeE4r+q6RQYHR0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JfehfIOx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JfehfIOx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8B61C4CED0;
	Mon, 30 Dec 2024 15:49:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573770;
	bh=9xedS9lfiRd8MCux7JJzvrdmxTHh9pbW5311ahOp5mA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JfehfIOxEoB3/N4vROD1EPy3j2gtYvo25j/N3PIDzA7dEVBeSIRVLT73q0tfsPLzr
	 ZQVPtknKWokjdQtMznJxgwBGLBsSTaDvpiiS57a29rKO6tWDIhkUw2jm9clcv9SDAM
	 0Hig6Pp9Qy6lQ8YIknGenD5ScWXFt4rC2GQKyK7Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 03/86] ceph: fix memory leak in ceph_direct_read_write()
Date: Mon, 30 Dec 2024 16:42:11 +0100
Message-ID: <20241230154211.846130942@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241230154211.711515682@linuxfoundation.org>
References: <20241230154211.711515682@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

[ Upstream commit 66e0c4f91461d17d48071695271c824620bed4ef ]

The bvecs array which is allocated in iter_get_bvecs_alloc() is leaked
and pages remain pinned if ceph_alloc_sparse_ext_map() fails.

There is no need to delay the allocation of sparse_ext map until after
the bvecs array is set up, so fix this by moving sparse_ext allocation
a bit earlier.  Also, make a similar adjustment in __ceph_sync_read()
for consistency (a leak of the same kind in __ceph_sync_read() has been
addressed differently).

Cc: stable@vger.kernel.org
Fixes: 03bc06c7b0bd ("ceph: add new mount option to enable sparse reads")
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Alex Markuze <amarkuze@redhat.com>
Stable-dep-of: 18d44c5d062b ("ceph: allocate sparse_ext map only for sparse reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/file.c | 43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 23dcfb916298..5233bbab8a76 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1026,6 +1026,16 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 			len = read_off + read_len - off;
 		more = len < iov_iter_count(to);
 
+		op = &req->r_ops[0];
+		if (sparse) {
+			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
+
 		num_pages = calc_pages_for(read_off, read_len);
 		page_off = offset_in_page(off);
 		pages = ceph_alloc_page_vector(num_pages, GFP_KERNEL);
@@ -1039,16 +1049,6 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 						 offset_in_page(read_off),
 						 false, true);
 
-		op = &req->r_ops[0];
-		if (sparse) {
-			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
-			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
-			if (ret) {
-				ceph_osdc_put_request(req);
-				break;
-			}
-		}
-
 		ceph_osdc_start_request(osdc, req);
 		ret = ceph_osdc_wait_request(osdc, req);
 
@@ -1454,6 +1454,16 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			break;
 		}
 
+		op = &req->r_ops[0];
+		if (sparse) {
+			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
+			if (ret) {
+				ceph_osdc_put_request(req);
+				break;
+			}
+		}
+
 		len = iter_get_bvecs_alloc(iter, size, &bvecs, &num_pages);
 		if (len < 0) {
 			ceph_osdc_put_request(req);
@@ -1463,6 +1473,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		if (len != size)
 			osd_req_op_extent_update(req, 0, len);
 
+		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
+
 		/*
 		 * To simplify error handling, allow AIO when IO within i_size
 		 * or IO can be satisfied by single OSD request.
@@ -1494,17 +1506,6 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 			req->r_mtime = mtime;
 		}
 
-		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
-		op = &req->r_ops[0];
-		if (sparse) {
-			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
-			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
-			if (ret) {
-				ceph_osdc_put_request(req);
-				break;
-			}
-		}
-
 		if (aio_req) {
 			aio_req->total_len += len;
 			aio_req->num_reqs++;
-- 
2.39.5



