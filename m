Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F032DFBF8
	for <patches@lists.linux.dev>; Mon, 15 May 2023 17:14:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3559FC433D2;
	Mon, 15 May 2023 17:14:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684170846;
	bh=eV07xSRNLhte9c73M6SfOKOpux8alZZFXYqdV0ZCBDw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rAw/CbEl9UhMiJQaZNGMtwTWcDqsY55vjyAtqKNdGaXgduCGQWMKxnkvPr/i5+BIL
	 m4jDiRra5HWPuePoxhzwsIMfN2wQxUXyfT2T5fTkulIAJW+jbnQC2l6an/CQ4smsc1
	 Sw5XRb9/wGycRMhjjkUkjn7o+r03h4ePvBV0im8I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bob Pearson <rpearsonhpe@gmail.com>,
	Devesh Sharma <devesh.s.sharma@oracle.com>,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 020/242] RDMA/rxe: Remove rxe_alloc()
Date: Mon, 15 May 2023 18:25:46 +0200
Message-Id: <20230515161722.539186970@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230515161721.802179972@linuxfoundation.org>
References: <20230515161721.802179972@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Bob Pearson <rpearsonhpe@gmail.com>

[ Upstream commit 72a03627443d5bc7032ab98bd784740cd8a76f8a ]

Currently all the object types in the rxe driver are allocated in
rdma-core except for MRs. By moving tha kzalloc() call outside of
the pool code the rxe_alloc() subroutine can be eliminated and code
checking for MR as a special case can be removed.

This patch moves the kzalloc() and kfree_rcu() calls into the mr
registration and destruction verbs. It removes that code from
rxe_pool.c including the rxe_alloc() subroutine which is no longer
used.

Link: https://lore.kernel.org/r/20230213225551.12437-1-rpearsonhpe@gmail.com
Signed-off-by: Bob Pearson <rpearsonhpe@gmail.com>
Reviewed-by: Devesh Sharma <devesh.s.sharma@oracle.com>
Reviewed-by: Devesh Sharma <devesh.s.sharma@oracle.com>
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Stable-dep-of: 78b26a335310 ("RDMA/rxe: Remove tasklet call from rxe_cq.c")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_mr.c    |  2 +-
 drivers/infiniband/sw/rxe/rxe_pool.c  | 46 ---------------------
 drivers/infiniband/sw/rxe/rxe_pool.h  |  3 --
 drivers/infiniband/sw/rxe/rxe_verbs.c | 59 +++++++++++++++++++--------
 4 files changed, 44 insertions(+), 66 deletions(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_mr.c b/drivers/infiniband/sw/rxe/rxe_mr.c
index 5e9a03831bf9f..b10aa1580a644 100644
--- a/drivers/infiniband/sw/rxe/rxe_mr.c
+++ b/drivers/infiniband/sw/rxe/rxe_mr.c
@@ -731,7 +731,7 @@ int rxe_dereg_mr(struct ib_mr *ibmr, struct ib_udata *udata)
 		return -EINVAL;
 
 	rxe_cleanup(mr);
-
+	kfree_rcu(mr);
 	return 0;
 }
 
diff --git a/drivers/infiniband/sw/rxe/rxe_pool.c b/drivers/infiniband/sw/rxe/rxe_pool.c
index 1151c0b5cceab..6215c6de3a840 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.c
+++ b/drivers/infiniband/sw/rxe/rxe_pool.c
@@ -116,55 +116,12 @@ void rxe_pool_cleanup(struct rxe_pool *pool)
 	WARN_ON(!xa_empty(&pool->xa));
 }
 
-void *rxe_alloc(struct rxe_pool *pool)
-{
-	struct rxe_pool_elem *elem;
-	void *obj;
-	int err;
-
-	if (WARN_ON(!(pool->type == RXE_TYPE_MR)))
-		return NULL;
-
-	if (atomic_inc_return(&pool->num_elem) > pool->max_elem)
-		goto err_cnt;
-
-	obj = kzalloc(pool->elem_size, GFP_KERNEL);
-	if (!obj)
-		goto err_cnt;
-
-	elem = (struct rxe_pool_elem *)((u8 *)obj + pool->elem_offset);
-
-	elem->pool = pool;
-	elem->obj = obj;
-	kref_init(&elem->ref_cnt);
-	init_completion(&elem->complete);
-
-	/* allocate index in array but leave pointer as NULL so it
-	 * can't be looked up until rxe_finalize() is called
-	 */
-	err = xa_alloc_cyclic(&pool->xa, &elem->index, NULL, pool->limit,
-			      &pool->next, GFP_KERNEL);
-	if (err < 0)
-		goto err_free;
-
-	return obj;
-
-err_free:
-	kfree(obj);
-err_cnt:
-	atomic_dec(&pool->num_elem);
-	return NULL;
-}
-
 int __rxe_add_to_pool(struct rxe_pool *pool, struct rxe_pool_elem *elem,
 				bool sleepable)
 {
 	int err;
 	gfp_t gfp_flags;
 
-	if (WARN_ON(pool->type == RXE_TYPE_MR))
-		return -EINVAL;
-
 	if (atomic_inc_return(&pool->num_elem) > pool->max_elem)
 		goto err_cnt;
 
@@ -275,9 +232,6 @@ int __rxe_cleanup(struct rxe_pool_elem *elem, bool sleepable)
 	if (pool->cleanup)
 		pool->cleanup(elem);
 
-	if (pool->type == RXE_TYPE_MR)
-		kfree_rcu(elem->obj);
-
 	atomic_dec(&pool->num_elem);
 
 	return err;
diff --git a/drivers/infiniband/sw/rxe/rxe_pool.h b/drivers/infiniband/sw/rxe/rxe_pool.h
index 9d83cb32092ff..b42e26427a702 100644
--- a/drivers/infiniband/sw/rxe/rxe_pool.h
+++ b/drivers/infiniband/sw/rxe/rxe_pool.h
@@ -54,9 +54,6 @@ void rxe_pool_init(struct rxe_dev *rxe, struct rxe_pool *pool,
 /* free resources from object pool */
 void rxe_pool_cleanup(struct rxe_pool *pool);
 
-/* allocate an object from pool */
-void *rxe_alloc(struct rxe_pool *pool);
-
 /* connect already allocated object to pool */
 int __rxe_add_to_pool(struct rxe_pool *pool, struct rxe_pool_elem *elem,
 				bool sleepable);
diff --git a/drivers/infiniband/sw/rxe/rxe_verbs.c b/drivers/infiniband/sw/rxe/rxe_verbs.c
index 9ae7cf93365c7..6803ac76ae572 100644
--- a/drivers/infiniband/sw/rxe/rxe_verbs.c
+++ b/drivers/infiniband/sw/rxe/rxe_verbs.c
@@ -867,10 +867,17 @@ static struct ib_mr *rxe_get_dma_mr(struct ib_pd *ibpd, int access)
 	struct rxe_dev *rxe = to_rdev(ibpd->device);
 	struct rxe_pd *pd = to_rpd(ibpd);
 	struct rxe_mr *mr;
+	int err;
 
-	mr = rxe_alloc(&rxe->mr_pool);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	err = rxe_add_to_pool(&rxe->mr_pool, mr);
+	if (err)
+		goto err_free;
 
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
@@ -878,8 +885,12 @@ static struct ib_mr *rxe_get_dma_mr(struct ib_pd *ibpd, int access)
 
 	rxe_mr_init_dma(access, mr);
 	rxe_finalize(mr);
-
 	return &mr->ibmr;
+
+err_free:
+	kfree(mr);
+err_out:
+	return ERR_PTR(err);
 }
 
 static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
@@ -893,9 +904,15 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 	struct rxe_pd *pd = to_rpd(ibpd);
 	struct rxe_mr *mr;
 
-	mr = rxe_alloc(&rxe->mr_pool);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	err = rxe_add_to_pool(&rxe->mr_pool, mr);
+	if (err)
+		goto err_free;
 
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
@@ -903,14 +920,16 @@ static struct ib_mr *rxe_reg_user_mr(struct ib_pd *ibpd,
 
 	err = rxe_mr_init_user(rxe, start, length, iova, access, mr);
 	if (err)
-		goto err1;
+		goto err_cleanup;
 
 	rxe_finalize(mr);
-
 	return &mr->ibmr;
 
-err1:
+err_cleanup:
 	rxe_cleanup(mr);
+err_free:
+	kfree(mr);
+err_out:
 	return ERR_PTR(err);
 }
 
@@ -925,9 +944,15 @@ static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
 	if (mr_type != IB_MR_TYPE_MEM_REG)
 		return ERR_PTR(-EINVAL);
 
-	mr = rxe_alloc(&rxe->mr_pool);
-	if (!mr)
-		return ERR_PTR(-ENOMEM);
+	mr = kzalloc(sizeof(*mr), GFP_KERNEL);
+	if (!mr) {
+		err = -ENOMEM;
+		goto err_out;
+	}
+
+	err = rxe_add_to_pool(&rxe->mr_pool, mr);
+	if (err)
+		goto err_free;
 
 	rxe_get(pd);
 	mr->ibmr.pd = ibpd;
@@ -935,14 +960,16 @@ static struct ib_mr *rxe_alloc_mr(struct ib_pd *ibpd, enum ib_mr_type mr_type,
 
 	err = rxe_mr_init_fast(max_num_sg, mr);
 	if (err)
-		goto err1;
+		goto err_cleanup;
 
 	rxe_finalize(mr);
-
 	return &mr->ibmr;
 
-err1:
+err_cleanup:
 	rxe_cleanup(mr);
+err_free:
+	kfree(mr);
+err_out:
 	return ERR_PTR(err);
 }
 
-- 
2.39.2



