Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C88DA63D5;
	Thu, 15 Aug 2024 14:34:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723732468; cv=none; b=QxfaLP/9Lhvs0yGhUTIseKRZMKQzPRTfwPorYzdApO7neBl5Tl0ybea+GZIi1IAXEKJVOXgYnZIZd51vcHAWeQ1M0TPPhxX1dfYB+Y7JZ88fbmen/JTAhzkaeAoWGOp4awqziXsT0ozEOfIhw2dquvyZEY1d5d1e3T6OTOcOjBM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723732468; c=relaxed/simple;
	bh=O/XHCHRIPHZ+4zf7W7ybWQ0qYRqv2m+Cw3fDWxmKbgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f/Mu0XpKRQhvYcRPCecFEF5wzwlQJKaq+wagANrbvqkgjJg4Ex8GBJ9VFDgvPgXxKv4bAxwSAfAZG//aDFPxVAmxKR9+pJgN55aUMDn9Pf1B1+zOcnW0WzWnitg5bm6VBpifq9PmcunCvA+6KLxvL1W7JmvklL2t1PBM5ZIsdok=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=afj9Xa5u; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="afj9Xa5u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F28AC32786;
	Thu, 15 Aug 2024 14:34:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723732468;
	bh=O/XHCHRIPHZ+4zf7W7ybWQ0qYRqv2m+Cw3fDWxmKbgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=afj9Xa5ubzCVZo+hoJVC2SpwDCZJf9eiC8bB2cvnmDCAAyEx4jba0w1lqXa85UmDJ
	 Iq904oB6eNXDGfsWW5qjm3S7LLbRa1dUukVo57igmIYAW1LHdwrUOoKHSOO6sxMNXf
	 636kPscEVxU/ruc57dDtN7diaetgmI6h5LDr85GQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ilya Dryomov <idryomov@gmail.com>,
	Dongsheng Yang <dongsheng.yang@easystack.cn>
Subject: [PATCH 5.10 181/352] rbd: rename RBD_LOCK_STATE_RELEASING and releasing_wait
Date: Thu, 15 Aug 2024 15:24:07 +0200
Message-ID: <20240815131926.273559757@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240815131919.196120297@linuxfoundation.org>
References: <20240815131919.196120297@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilya Dryomov <idryomov@gmail.com>

commit f5c466a0fdb2d9f3650d2e3911b0735f17ba00cf upstream.

... to RBD_LOCK_STATE_QUIESCING and quiescing_wait to recognize that
this state and the associated completion are backing rbd_quiesce_lock(),
which isn't specific to releasing the lock.

While exclusive lock does get quiesced before it's released, it also
gets quiesced before an attempt to update the cookie is made and there
the lock is not released as long as ceph_cls_set_cookie() succeeds.

Signed-off-by: Ilya Dryomov <idryomov@gmail.com>
Reviewed-by: Dongsheng Yang <dongsheng.yang@easystack.cn>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/block/rbd.c |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

--- a/drivers/block/rbd.c
+++ b/drivers/block/rbd.c
@@ -362,7 +362,7 @@ enum rbd_watch_state {
 enum rbd_lock_state {
 	RBD_LOCK_STATE_UNLOCKED,
 	RBD_LOCK_STATE_LOCKED,
-	RBD_LOCK_STATE_RELEASING,
+	RBD_LOCK_STATE_QUIESCING,
 };
 
 /* WatchNotify::ClientId */
@@ -422,7 +422,7 @@ struct rbd_device {
 	struct list_head	running_list;
 	struct completion	acquire_wait;
 	int			acquire_err;
-	struct completion	releasing_wait;
+	struct completion	quiescing_wait;
 
 	spinlock_t		object_map_lock;
 	u8			*object_map;
@@ -525,7 +525,7 @@ static bool __rbd_is_lock_owner(struct r
 	lockdep_assert_held(&rbd_dev->lock_rwsem);
 
 	return rbd_dev->lock_state == RBD_LOCK_STATE_LOCKED ||
-	       rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING;
+	       rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING;
 }
 
 static bool rbd_is_lock_owner(struct rbd_device *rbd_dev)
@@ -3523,12 +3523,12 @@ static void rbd_lock_del_request(struct
 	spin_lock(&rbd_dev->lock_lists_lock);
 	if (!list_empty(&img_req->lock_item)) {
 		list_del_init(&img_req->lock_item);
-		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_RELEASING &&
+		need_wakeup = (rbd_dev->lock_state == RBD_LOCK_STATE_QUIESCING &&
 			       list_empty(&rbd_dev->running_list));
 	}
 	spin_unlock(&rbd_dev->lock_lists_lock);
 	if (need_wakeup)
-		complete(&rbd_dev->releasing_wait);
+		complete(&rbd_dev->quiescing_wait);
 }
 
 static int rbd_img_exclusive_lock(struct rbd_img_request *img_req)
@@ -4237,16 +4237,16 @@ static bool rbd_quiesce_lock(struct rbd_
 	/*
 	 * Ensure that all in-flight IO is flushed.
 	 */
-	rbd_dev->lock_state = RBD_LOCK_STATE_RELEASING;
-	rbd_assert(!completion_done(&rbd_dev->releasing_wait));
+	rbd_dev->lock_state = RBD_LOCK_STATE_QUIESCING;
+	rbd_assert(!completion_done(&rbd_dev->quiescing_wait));
 	if (list_empty(&rbd_dev->running_list))
 		return true;
 
 	up_write(&rbd_dev->lock_rwsem);
-	wait_for_completion(&rbd_dev->releasing_wait);
+	wait_for_completion(&rbd_dev->quiescing_wait);
 
 	down_write(&rbd_dev->lock_rwsem);
-	if (rbd_dev->lock_state != RBD_LOCK_STATE_RELEASING)
+	if (rbd_dev->lock_state != RBD_LOCK_STATE_QUIESCING)
 		return false;
 
 	rbd_assert(list_empty(&rbd_dev->running_list));
@@ -5455,7 +5455,7 @@ static struct rbd_device *__rbd_dev_crea
 	INIT_LIST_HEAD(&rbd_dev->acquiring_list);
 	INIT_LIST_HEAD(&rbd_dev->running_list);
 	init_completion(&rbd_dev->acquire_wait);
-	init_completion(&rbd_dev->releasing_wait);
+	init_completion(&rbd_dev->quiescing_wait);
 
 	spin_lock_init(&rbd_dev->object_map_lock);
 


