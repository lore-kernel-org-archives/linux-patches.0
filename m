Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14ADB37756C;
	Mon,  9 Feb 2026 14:26:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770647212; cv=none; b=pYB7MA6zkj4TnjYyq7ww7WMEgYpeal9RRbWkHnAvfyfQXxsHZStQ0pqUA23btwBOLJYgweJr86E9WmHcIBKKi5Yoof1DkobSXE2dFPqDKLD1+fN2jLThT6hiWvzo35JlJBlWE1LmGnvprJXVFa0L2JLvFo81FWVrU+4wOk1udAs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770647212; c=relaxed/simple;
	bh=TzSKviIfkuPnrqjDxguw9syUkTUIO7uDu83exmnDYAQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tuG/iDVZxkKk+b742ra6tnxYiZajzqecRHU+6KpiZnnish8u+bpku8vbMRG2BwvN8C08do01nmZTYfRpu02EWvVS3lTQJxKMlBbaAFaCiL/YySMPoGjCp6Rv3XEx203kao688KisM5rUKqmVrxxU67fqnuRya/thEEcxd4p4Kt0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Em2Ng2/q; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Em2Ng2/q"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3AF24C116C6;
	Mon,  9 Feb 2026 14:26:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770647211;
	bh=TzSKviIfkuPnrqjDxguw9syUkTUIO7uDu83exmnDYAQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Em2Ng2/q/pUKGu4rHB8XsPER7k1WZZA7+gX0TS5gBmCGHUIjmLBnHIHaLUUm3259S
	 oLrn+RO1gLRwNPr8s+a64SFVKZ3UYKxEAo3fo5u6+x+1Zoc+qsFTpLgsuIPUL2hG1A
	 33vRhARqrDzICXmtXSjmnfXGAb6K4ONV1iz/kDvY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@linux.dev>
Subject: [PATCH 6.18 015/175] rbd: check for EOD after exclusive lock is ensured to be held
Date: Mon,  9 Feb 2026 15:21:28 +0100
Message-ID: <20260209142321.024890762@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260209142320.474120190@linuxfoundation.org>
References: <20260209142320.474120190@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit bd3884a204c3b507e6baa9a4091aa927f9af5404 upstream.

Similar to commit 870611e4877e ("rbd: get snapshot context after
exclusive lock is ensured to be held"), move the "beyond EOD" check
into the image request state machine so that it's performed after
exclusive lock is ensured to be held.  This avoids various race
conditions which can arise when the image is shrunk under I/O (in
practice, mostly readahead).  In one such scenario

    rbd_assert(objno < rbd_dev->object_map_size);

can be triggered if a close-to-EOD read gets queued right before the
shrink is initiated and the EOD check is performed against an outdated
mapping_size.  After the resize is done on the server side and exclusive
lock is (re)acquired bringing along the new (now shrunk) object map, the
read starts going through the state machine and rbd_obj_may_exist() gets
invoked on an object that is out of bounds of rbd_dev->object_map array.

Cc: stable@vger.kernel.org
Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@linux.dev>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -3495,11 +3495,29 @@ static void rbd_img_object_requests(stru
 	rbd_assert(!need_exclusive_lock(img_req) ||
 		   __rbd_is_lock_owner(rbd_dev));
 
-	if (rbd_img_is_write(img_req)) {
-		rbd_assert(!img_req->snapc);
+	if (test_bit(IMG_REQ_CHILD, &img_req->flags)) {
+		rbd_assert(!rbd_img_is_write(img_req));
+	} else {
+		struct request *rq = blk_mq_rq_from_pdu(img_req);
+		u64 off = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
+		u64 len = blk_rq_bytes(rq);
+		u64 mapping_size;
+
 		down_read(&rbd_dev->header_rwsem);
-		img_req->snapc = ceph_get_snap_context(rbd_dev->header.snapc);
+		mapping_size = rbd_dev->mapping.size;
+		if (rbd_img_is_write(img_req)) {
+			rbd_assert(!img_req->snapc);
+			img_req->snapc =
+			    ceph_get_snap_context(rbd_dev->header.snapc);
+		}
 		up_read(&rbd_dev->header_rwsem);
+
+		if (unlikely(off + len > mapping_size)) {
+			rbd_warn(rbd_dev, "beyond EOD (%llu~%llu > %llu)",
+				 off, len, mapping_size);
+			img_req->pending.result = -EIO;
+			return;
+		}
 	}
 
 	for_each_obj_request(img_req, obj_req) {
@@ -4725,7 +4743,6 @@ static void rbd_queue_workfn(struct work
 	struct request *rq = blk_mq_rq_from_pdu(img_request);
 	u64 offset = (u64)blk_rq_pos(rq) << SECTOR_SHIFT;
 	u64 length = blk_rq_bytes(rq);
-	u64 mapping_size;
 	int result;
 
 	/* Ignore/skip any zero-length requests */
@@ -4738,17 +4755,9 @@ static void rbd_queue_workfn(struct work
 	blk_mq_start_request(rq);
 
 	down_read(&rbd_dev->header_rwsem);
-	mapping_size = rbd_dev->mapping.size;
 	rbd_img_capture_header(img_request);
 	up_read(&rbd_dev->header_rwsem);
 
-	if (offset + length > mapping_size) {
-		rbd_warn(rbd_dev, "beyond EOD (%llu~%llu > %llu)", offset,
-			 length, mapping_size);
-		result = -EIO;
-		goto err_img_request;
-	}
-
 	dout("%s rbd_dev %p img_req %p %s %llu~%llu\n", __func__, rbd_dev,
 	     img_request, obj_op_name(op_type), offset, length);
 


