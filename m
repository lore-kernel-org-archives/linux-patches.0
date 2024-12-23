Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 44FF613BC0C;
	Mon, 23 Dec 2024 16:08:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734970132; cv=none; b=ofYnt7B3AvMdaBF+c7Otx6trJoOW9jCVwXVyKaWL4lGdrMlaoQlZfUDfpBLGnh09vTP9gdHcMPS9hGNqrD7aDt7Wq7r0w0d4u+ACdU6iMPRBKee2Pah+SF6qgpmRT/dHk4K56Uqr4J9wnZowGy7+adsLyPQC8r1ge14+z/ZWqCY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734970132; c=relaxed/simple;
	bh=VwPfrVcEePlL6nSJAsOo+XyzbiQwtkybrvArzW1AB/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gkVFxgnTUUYJFWGr4LTOc/GqSFBQ5KHAADVMKqi/ShU/zUSaW/v7hStDKtarbEjsLoP/HIytcPjiLzbrHUvVDYqCQ6DLuit6OpXxG8Rrxon3M7fzUTu+HtS4c87rWgGnHLrM1EWI8wvkEEy5Zoh6pqxO9vtJ/VDcoOwa7aJbbPI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=l9WGx4nc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="l9WGx4nc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6185DC4CED3;
	Mon, 23 Dec 2024 16:08:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734970131;
	bh=VwPfrVcEePlL6nSJAsOo+XyzbiQwtkybrvArzW1AB/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=l9WGx4ncwFyNYkAUkoMez9NYRk9wa893h5VmWvlWp/1zRv8tnjuhwOD7h1ykPO1MC
	 Xl/Xu2IDW0qhGjDmQCZysS7RK+3+hrYKOAp6bP6jAWtroFqQEBS22g00256rguTAyj
	 GKyngcVP/dLqa8NuMe0ufaU8kYgyeVskpchgCtHk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Alex Markuze <amarkuze@redhat.com>
Subject: [PATCH 6.12 155/160] ceph: fix memory leak in ceph_direct_read_write()
Date: Mon, 23 Dec 2024 16:59:26 +0100
Message-ID: <20241223155414.806006311@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241223155408.598780301@linuxfoundation.org>
References: <20241223155408.598780301@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit 66e0c4f91461d17d48071695271c824620bed4ef upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ceph/file.c |   43 ++++++++++++++++++++++---------------------
 1 file changed, 22 insertions(+), 21 deletions(-)

--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1116,6 +1116,16 @@ ssize_t __ceph_sync_read(struct inode *i
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
@@ -1129,16 +1139,6 @@ ssize_t __ceph_sync_read(struct inode *i
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
 
@@ -1551,6 +1551,16 @@ ceph_direct_read_write(struct kiocb *ioc
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
@@ -1560,6 +1570,8 @@ ceph_direct_read_write(struct kiocb *ioc
 		if (len != size)
 			osd_req_op_extent_update(req, 0, len);
 
+		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
+
 		/*
 		 * To simplify error handling, allow AIO when IO within i_size
 		 * or IO can be satisfied by single OSD request.
@@ -1591,17 +1603,6 @@ ceph_direct_read_write(struct kiocb *ioc
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


