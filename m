Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B29815E8B;
	Mon, 30 Dec 2024 15:48:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1735573733; cv=none; b=WWQBMQR2QHo1xkig7YA/h0yo0xHuHh8AsZQjBxpDUpaOpKmhEHLQxmpmI6j4BaSOk7eIVfTOhbM60azzNtUXp3PgGglA1WSsSOIebGz8hmFS4pGeQm5FFjTrmOhGcivY+3DYg5OpWO0DeV99KW0VVsCPzbSxDQMAUFI1TPShYeo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1735573733; c=relaxed/simple;
	bh=Uzqfcmq7mcN0NRemkHoINVj0R0XYQhoRq6Nq3nhhdFQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PWJ1bXqDQiXLGFTp4TY71Oh+Wi5C/93AGVqb6/mMBV+08Kis5e857e37yNdbHb4A+FGnQt8kpQs9SLd7KZAlDzdsR3D+KWs/KpLNitDpY1hvfwSpz47mJszYzGj3SxZDfHQggwytorgqNSuE+eT49gJk5+FrhgCRYRg9QVYtydI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqMLR/u6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqMLR/u6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBC38C4CED0;
	Mon, 30 Dec 2024 15:48:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1735573733;
	bh=Uzqfcmq7mcN0NRemkHoINVj0R0XYQhoRq6Nq3nhhdFQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqMLR/u68vpmraUKplqxw+6DyTgwFIOKQJYmmy+eKeBuGwGherTNXq1g22jl9fvE5
	 afLffFkOx5dbVTz3dgB5rgoXTkbuw2DRRAwXeTNpXaGdTlexgVW5tmof8x3tTwdcum
	 CTTzotk30cJHUe7CRApTBduP5LRFXDrv8gNhFiFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiubo Li <xiubli@redhat.com>,
	Ilya Dryomov <idryomov@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 02/86] ceph: try to allocate a smaller extent map for sparse read
Date: Mon, 30 Dec 2024 16:42:10 +0100
Message-ID: <20241230154211.809365861@linuxfoundation.org>
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

From: Xiubo Li <xiubli@redhat.com>

[ Upstream commit aaefabc4a5f7ae48682c4d2d5d10faaf95c08eb9 ]

In fscrypt case and for a smaller read length we can predict the
max count of the extent map. And for small read length use cases
this could save some memories.

[ idryomov: squash into a single patch to avoid build break, drop
  redundant variable in ceph_alloc_sparse_ext_map() ]

Signed-off-by: Xiubo Li <xiubli@redhat.com>
Reviewed-by: Ilya Dryomov <idryomov@gmail.com>
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Stable-dep-of: 18d44c5d062b ("ceph: allocate sparse_ext map only for sparse reads")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 fs/ceph/addr.c                  |  4 +++-
 fs/ceph/file.c                  |  8 ++++++--
 fs/ceph/super.h                 | 14 ++++++++++++++
 include/linux/ceph/osd_client.h |  7 +++++--
 4 files changed, 28 insertions(+), 5 deletions(-)

diff --git a/fs/ceph/addr.c b/fs/ceph/addr.c
index 1a2776025e98..2c92de964c5a 100644
--- a/fs/ceph/addr.c
+++ b/fs/ceph/addr.c
@@ -355,6 +355,7 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	u64 len = subreq->len;
 	bool sparse = IS_ENCRYPTED(inode) || ceph_test_mount_opt(fsc, SPARSEREAD);
 	u64 off = subreq->start;
+	int extent_cnt;
 
 	if (ceph_inode_is_shutdown(inode)) {
 		err = -EIO;
@@ -377,7 +378,8 @@ static void ceph_netfs_issue_read(struct netfs_io_subrequest *subreq)
 	}
 
 	if (sparse) {
-		err = ceph_alloc_sparse_ext_map(&req->r_ops[0]);
+		extent_cnt = __ceph_sparse_read_ext_count(inode, len);
+		err = ceph_alloc_sparse_ext_map(&req->r_ops[0], extent_cnt);
 		if (err)
 			goto out;
 	}
diff --git a/fs/ceph/file.c b/fs/ceph/file.c
index 813974244a9d..23dcfb916298 100644
--- a/fs/ceph/file.c
+++ b/fs/ceph/file.c
@@ -1001,6 +1001,7 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 		struct ceph_osd_req_op *op;
 		u64 read_off = off;
 		u64 read_len = len;
+		int extent_cnt;
 
 		/* determine new offset/length if encrypted */
 		ceph_fscrypt_adjust_off_and_len(inode, &read_off, &read_len);
@@ -1040,7 +1041,8 @@ ssize_t __ceph_sync_read(struct inode *inode, loff_t *ki_pos,
 
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op);
+			extent_cnt = __ceph_sparse_read_ext_count(inode, read_len);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
@@ -1431,6 +1433,7 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		ssize_t len;
 		struct ceph_osd_req_op *op;
 		int readop = sparse ? CEPH_OSD_OP_SPARSE_READ : CEPH_OSD_OP_READ;
+		int extent_cnt;
 
 		if (write)
 			size = min_t(u64, size, fsc->mount_options->wsize);
@@ -1494,7 +1497,8 @@ ceph_direct_read_write(struct kiocb *iocb, struct iov_iter *iter,
 		osd_req_op_extent_osd_data_bvecs(req, 0, bvecs, num_pages, len);
 		op = &req->r_ops[0];
 		if (sparse) {
-			ret = ceph_alloc_sparse_ext_map(op);
+			extent_cnt = __ceph_sparse_read_ext_count(inode, size);
+			ret = ceph_alloc_sparse_ext_map(op, extent_cnt);
 			if (ret) {
 				ceph_osdc_put_request(req);
 				break;
diff --git a/fs/ceph/super.h b/fs/ceph/super.h
index 8efd4ba60774..5903e3fb6d75 100644
--- a/fs/ceph/super.h
+++ b/fs/ceph/super.h
@@ -3,6 +3,7 @@
 #define _FS_CEPH_SUPER_H
 
 #include <linux/ceph/ceph_debug.h>
+#include <linux/ceph/osd_client.h>
 
 #include <asm/unaligned.h>
 #include <linux/backing-dev.h>
@@ -1401,6 +1402,19 @@ static inline void __ceph_update_quota(struct ceph_inode_info *ci,
 		ceph_adjust_quota_realms_count(&ci->netfs.inode, has_quota);
 }
 
+static inline int __ceph_sparse_read_ext_count(struct inode *inode, u64 len)
+{
+	int cnt = 0;
+
+	if (IS_ENCRYPTED(inode)) {
+		cnt = len >> CEPH_FSCRYPT_BLOCK_SHIFT;
+		if (cnt > CEPH_SPARSE_EXT_ARRAY_INITIAL)
+			cnt = 0;
+	}
+
+	return cnt;
+}
+
 extern void ceph_handle_quota(struct ceph_mds_client *mdsc,
 			      struct ceph_mds_session *session,
 			      struct ceph_msg *msg);
diff --git a/include/linux/ceph/osd_client.h b/include/linux/ceph/osd_client.h
index f703fb8030de..50e409e84466 100644
--- a/include/linux/ceph/osd_client.h
+++ b/include/linux/ceph/osd_client.h
@@ -573,9 +573,12 @@ int __ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt);
  */
 #define CEPH_SPARSE_EXT_ARRAY_INITIAL  16
 
-static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op)
+static inline int ceph_alloc_sparse_ext_map(struct ceph_osd_req_op *op, int cnt)
 {
-	return __ceph_alloc_sparse_ext_map(op, CEPH_SPARSE_EXT_ARRAY_INITIAL);
+	if (!cnt)
+		cnt = CEPH_SPARSE_EXT_ARRAY_INITIAL;
+
+	return __ceph_alloc_sparse_ext_map(op, cnt);
 }
 
 extern void ceph_osdc_get_request(struct ceph_osd_request *req);
-- 
2.39.5



