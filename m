Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C4534168AC
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:32:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D16EC433EF;
	Mon, 12 Jun 2023 10:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565920;
	bh=Y3JJV7iZ6bxeIZWOce+3p8siBpLwWjccP3XuzHRjDrI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qcSxplBFsaVG1OGTwVJJK8Wr/62PgilpukETkU1ZIo5voqiw2kJmhhPW6/hZt4k57
	 oil28FNG28YnrQWylzkfVrZb52HZO50M0QK7VwpMwzV327OEQboVZb/C0WmLKWmtoa
	 UiiGSN66stIK1Ij/Puczzsl3h9aeCPYCs9qVAlaM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.4 41/45] rbd: get snapshot context after exclusive lock is ensured to be held
Date: Mon, 12 Jun 2023 12:26:35 +0200
Message-ID: <20230612101656.310461607@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilya Dryomov <idryomov@gmail.com>

commit 870611e4877eff1e8413c3fb92a585e45d5291f6 upstream.

Move capturing the snapshot context into the image request state
machine, after exclusive lock is ensured to be held for the duration of
dealing with the image request.  This is needed to ensure correctness
of fast-diff states (OBJECT_EXISTS vs OBJECT_EXISTS_CLEAN) and object
deltas computed based off of them.  Otherwise the object map that is
forked for the snapshot isn't guaranteed to accurately reflect the
contents of the snapshot when the snapshot is taken under I/O.  This
breaks differential backup and snapshot-based mirroring use cases with
fast-diff enabled: since some object deltas may be incomplete, the
destination image may get corrupted.

Cc: stable@vger.kernel.org
Link: https://tracker.ceph.com/issues/61472
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
[idryomov@gmail.com: backport to 5.4: no rbd_img_capture_header(),
 img_request not embedded in blk-mq pdu]
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   41 ++++++++++++++++++++++++-----------------
 1 file changed, 24 insertions(+), 17 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -1495,6 +1495,8 @@ static bool rbd_obj_is_tail(struct rbd_o
  */
 static void rbd_obj_set_copyup_enabled(struct rbd_obj_request *obj_req)
 {
+	rbd_assert(obj_req->img_request->snapc);
+
 	if (obj_req->img_request->op_type == OBJ_OP_DISCARD) {
 		dout("%s %p objno %llu discard\n", __func__, obj_req,
 		     obj_req->ex.oe_objno);
@@ -1613,6 +1615,7 @@ __rbd_obj_add_osd_request(struct rbd_obj
 static struct ceph_osd_request *
 rbd_obj_add_osd_request(struct rbd_obj_request *obj_req, int num_ops)
 {
+	rbd_assert(obj_req->img_request->snapc);
 	return __rbd_obj_add_osd_request(obj_req, obj_req->img_request->snapc,
 					 num_ops);
 }
@@ -1741,11 +1744,14 @@ static bool rbd_dev_parent_get(struct rb
  * Caller is responsible for filling in the list of object requests
  * that comprises the image request, and the Linux request pointer
  * (if there is one).
+ *
+ * Only snap_id is captured here, for reads.  For writes, snapshot
+ * context is captured in rbd_img_object_requests() after exclusive
+ * lock is ensured to be held.
  */
 static struct rbd_img_request *rbd_img_request_create(
 					struct rbd_device *rbd_dev,
-					enum obj_operation_type op_type,
-					struct ceph_snap_context *snapc)
+					enum obj_operation_type op_type)
 {
 	struct rbd_img_request *img_request;
 
@@ -1757,8 +1763,6 @@ static struct rbd_img_request *rbd_img_r
 	img_request->op_type = op_type;
 	if (!rbd_img_is_write(img_request))
 		img_request->snap_id = rbd_dev->spec->snap_id;
-	else
-		img_request->snapc = snapc;
 
 	if (rbd_dev_parent_get(rbd_dev))
 		img_request_layered_set(img_request);
@@ -2944,7 +2948,7 @@ static int rbd_obj_read_from_parent(stru
 	int ret;
 
 	child_img_req = rbd_img_request_create(img_req->rbd_dev->parent,
-					       OBJ_OP_READ, NULL);
+					       OBJ_OP_READ);
 	if (!child_img_req)
 		return -ENOMEM;
 
@@ -3635,9 +3639,19 @@ static int rbd_img_exclusive_lock(struct
 
 static void rbd_img_object_requests(struct rbd_img_request *img_req)
 {
+	struct rbd_device *rbd_dev = img_req->rbd_dev;
 	struct rbd_obj_request *obj_req;
 
 	rbd_assert(!img_req->pending.result && !img_req->pending.num_pending);
+	rbd_assert(!need_exclusive_lock(img_req) ||
+		   __rbd_is_lock_owner(rbd_dev));
+
+	if (rbd_img_is_write(img_req)) {
+		rbd_assert(!img_req->snapc);
+		down_read(&rbd_dev->header_rwsem);
+		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
+		up_read(&rbd_dev->header_rwsem);
+	}
 
 	for_each_obj_request(img_req, obj_req) {
 		int result = 0;
@@ -3655,7 +3669,6 @@ static void rbd_img_object_requests(stru
 
 static bool rbd_img_advance(struct rbd_img_request *img_req, int *result)
 {
-	struct rbd_device *rbd_dev = img_req->rbd_dev;
 	int ret;
 
 again:
@@ -3676,9 +3689,6 @@ again:
 		if (*result)
 			return true;
 
-		rbd_assert(!need_exclusive_lock(img_req) ||
-			   __rbd_is_lock_owner(rbd_dev));
-
 		rbd_img_object_requests(img_req);
 		if (!img_req->pending.num_pending) {
 			*result = img_req->pending.result;
@@ -4140,6 +4150,10 @@ static int rbd_post_acquire_action(struc
 {
 	int ret;
 
+	ret = rbd_dev_refresh(rbd_dev);
+	if (ret)
+		return ret;
+
 	if (rbd_dev->header.features & RBD_FEATURE_OBJECT_MAP) {
 		ret = rbd_object_map_open(rbd_dev);
 		if (ret)
@@ -4798,7 +4812,6 @@ static void rbd_queue_workfn(struct work
 	struct request *rq = blk_mq_rq_from_pdu(work);
 	struct rbd_device *rbd_dev = rq->q->queuedata;
 	struct rbd_img_request *img_request;
-	struct ceph_snap_context *snapc = NULL;
 	u64 offset = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
 	u64 length = blk_rq_bytes(rq);
 	enum obj_operation_type op_type;
@@ -4863,10 +4876,6 @@ static void rbd_queue_workfn(struct work
 
 	down_read(&rbd_dev->header_rwsem);
 	mapping_size = rbd_dev->mapping.size;
-	if (op_type != OBJ_OP_READ) {
-		snapc = rbd_dev->header.snapc;
-		ceph_get_snap_context(snapc);
-	}
 	up_read(&rbd_dev->header_rwsem);
 
 	if (offset + length > mapping_size) {
@@ -4876,13 +4885,12 @@ static void rbd_queue_workfn(struct work
 		goto err_rq;
 	}
 
-	img_request = rbd_img_request_create(rbd_dev, op_type, snapc);
+	img_request = rbd_img_request_create(rbd_dev, op_type);
 	if (!img_request) {
 		result = -ENOMEM;
 		goto err_rq;
 	}
 	img_request->rq = rq;
-	snapc = NULL; /* img_request consumes a ref */
 
 	dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,
 	     img_request, obj_op_name(op_type), offset, length);
@@ -4904,7 +4912,6 @@ err_rq:
 	if (result)
 		rbd_warn(rbd_dev, "%s %llx at %llx result %d",
 			 obj_op_name(op_type), length, offset, result);
-	ceph_put_snap_context(snapc);
 err:
 	blk_mq_end_request(rq, errno_to_blk_status(result));
 }


