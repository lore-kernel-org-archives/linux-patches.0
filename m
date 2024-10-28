Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 37CE018C03D;
	Mon, 28 Oct 2024 06:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730097181; cv=none; b=hMdNFHoy/Fxjf1N4fU9GQ0fsZA8jU4o5ktwutzfnMTFiZe/3A5aYrUdf5IkIS+OTcSBKUt7MiBxB75tiTS+lWCSi5F2gMF3//aGFo/+GcWeimvBP3//vrHH48W+sFjZ6sBGIdnano9f0l/UH4YSb8HGWnFWcv2MjIkXnAE8xXyw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730097181; c=relaxed/simple;
	bh=aTE1cGUchub11pMeFjhg4r7cJ89LS2VNJuDP8a3WJLM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aoU/QCcC8kwkFFMR4Pkms1/RtQKIQW1021YiKYoBmEOE3DCyqXG3kF1t2YgZy6LN7OevMpdjTuK0Fff0QCiyjMuIU8uGrXu9NWBzBwsV2armiUMgmSQ41v3+jlp5l46yGLdHx5peIThfxwMNG4AX6lDi6mNYtWYLTvvr/ULbs0M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bFN8eAvP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bFN8eAvP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CB6B6C4CEC7;
	Mon, 28 Oct 2024 06:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730097181;
	bh=aTE1cGUchub11pMeFjhg4r7cJ89LS2VNJuDP8a3WJLM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bFN8eAvP49wXBkHzoGf4tWnHG1Z7syKrCnzvB8TSXfhYea/wa5cs2f+T3vVQHmAW6
	 4I2M0LvS73BuNB8FE1phb32X3Bt2J70RM3g3D1XGIWx7M6t0KzLOEre3X2OLSLxfge
	 vcHNTCoWx76QMDLQOCNDot7rYuE89hTRpOaiZkLE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 019/137] RDMA/srpt: Make slab cache names unique
Date: Mon, 28 Oct 2024 07:24:16 +0100
Message-ID: <20241028062259.259143998@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062258.708872330@linuxfoundation.org>
References: <20241028062258.708872330@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bart Van Assche <bvanassche@acm.org>

[ Upstream commit 4d784c042d164f10fc809e2338457036cd7c653d ]

Since commit 4c39529663b9 ("slab: Warn on duplicate cache names when
DEBUG_VM=y"), slab complains about duplicate cache names. Hence this
patch. The approach is as follows:
- Maintain an xarray with the slab size as index and a reference count
  and a kmem_cache pointer as contents. Use srpt-${slab_size} as kmem
  cache name.
- Use 512-byte alignment for all slabs instead of only for some of the
  slabs.
- Increment the reference count instead of calling kmem_cache_create().
- Decrement the reference count instead of calling kmem_cache_destroy().

Fixes: 5dabcd0456d7 ("RDMA/srpt: Add support for immediate data")
Link: https://patch.msgid.link/r/20241009210048.4122518-1-bvanassche@acm.org
Reported-by: Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Closes: https://lore.kernel.org/linux-block/xpe6bea7rakpyoyfvspvin2dsozjmjtjktpph7rep3h25tv7fb@ooz4cu5z6bq6/
Suggested-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Bart Van Assche <bvanassche@acm.org>
Tested-by: Shin'ichiro Kawasaki <shinichiro.kawasaki@wdc.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/srpt/ib_srpt.c | 80 +++++++++++++++++++++++----
 1 file changed, 68 insertions(+), 12 deletions(-)

diff --git a/drivers/infiniband/ulp/srpt/ib_srpt.c b/drivers/infiniband/ulp/srpt/ib_srpt.c
index fd6c260d5857d..33c099e5efc5e 100644
--- a/drivers/infiniband/ulp/srpt/ib_srpt.c
+++ b/drivers/infiniband/ulp/srpt/ib_srpt.c
@@ -68,6 +68,8 @@ MODULE_LICENSE("Dual BSD/GPL");
 static u64 srpt_service_guid;
 static DEFINE_SPINLOCK(srpt_dev_lock);	/* Protects srpt_dev_list. */
 static LIST_HEAD(srpt_dev_list);	/* List of srpt_device structures. */
+static DEFINE_MUTEX(srpt_mc_mutex);	/* Protects srpt_memory_caches. */
+static DEFINE_XARRAY(srpt_memory_caches); /* See also srpt_memory_cache_entry */
 
 static unsigned srp_max_req_size = DEFAULT_MAX_REQ_SIZE;
 module_param(srp_max_req_size, int, 0444);
@@ -105,6 +107,63 @@ static void srpt_recv_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_send_done(struct ib_cq *cq, struct ib_wc *wc);
 static void srpt_process_wait_list(struct srpt_rdma_ch *ch);
 
+/* Type of the entries in srpt_memory_caches. */
+struct srpt_memory_cache_entry {
+	refcount_t ref;
+	struct kmem_cache *c;
+};
+
+static struct kmem_cache *srpt_cache_get(unsigned int object_size)
+{
+	struct srpt_memory_cache_entry *e;
+	char name[32];
+	void *res;
+
+	guard(mutex)(&srpt_mc_mutex);
+	e = xa_load(&srpt_memory_caches, object_size);
+	if (e) {
+		refcount_inc(&e->ref);
+		return e->c;
+	}
+	snprintf(name, sizeof(name), "srpt-%u", object_size);
+	e = kmalloc(sizeof(*e), GFP_KERNEL);
+	if (!e)
+		return NULL;
+	refcount_set(&e->ref, 1);
+	e->c = kmem_cache_create(name, object_size, /*align=*/512, 0, NULL);
+	if (!e->c)
+		goto free_entry;
+	res = xa_store(&srpt_memory_caches, object_size, e, GFP_KERNEL);
+	if (xa_is_err(res))
+		goto destroy_cache;
+	return e->c;
+
+destroy_cache:
+	kmem_cache_destroy(e->c);
+
+free_entry:
+	kfree(e);
+	return NULL;
+}
+
+static void srpt_cache_put(struct kmem_cache *c)
+{
+	struct srpt_memory_cache_entry *e = NULL;
+	unsigned long object_size;
+
+	guard(mutex)(&srpt_mc_mutex);
+	xa_for_each(&srpt_memory_caches, object_size, e)
+		if (e->c == c)
+			break;
+	if (WARN_ON_ONCE(!e))
+		return;
+	if (!refcount_dec_and_test(&e->ref))
+		return;
+	WARN_ON_ONCE(xa_erase(&srpt_memory_caches, object_size) != e);
+	kmem_cache_destroy(e->c);
+	kfree(e);
+}
+
 /*
  * The only allowed channel state changes are those that change the channel
  * state into a state with a higher numerical value. Hence the new > prev test.
@@ -2119,13 +2178,13 @@ static void srpt_release_channel_work(struct work_struct *w)
 			     ch->sport->sdev, ch->rq_size,
 			     ch->rsp_buf_cache, DMA_TO_DEVICE);
 
-	kmem_cache_destroy(ch->rsp_buf_cache);
+	srpt_cache_put(ch->rsp_buf_cache);
 
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_recv_ring,
 			     sdev, ch->rq_size,
 			     ch->req_buf_cache, DMA_FROM_DEVICE);
 
-	kmem_cache_destroy(ch->req_buf_cache);
+	srpt_cache_put(ch->req_buf_cache);
 
 	kref_put(&ch->kref, srpt_free_ch);
 }
@@ -2245,8 +2304,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 	INIT_LIST_HEAD(&ch->cmd_wait_list);
 	ch->max_rsp_size = ch->sport->port_attrib.srp_max_rsp_size;
 
-	ch->rsp_buf_cache = kmem_cache_create("srpt-rsp-buf", ch->max_rsp_size,
-					      512, 0, NULL);
+	ch->rsp_buf_cache = srpt_cache_get(ch->max_rsp_size);
 	if (!ch->rsp_buf_cache)
 		goto free_ch;
 
@@ -2280,8 +2338,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 		alignment_offset = round_up(imm_data_offset, 512) -
 			imm_data_offset;
 		req_sz = alignment_offset + imm_data_offset + srp_max_req_size;
-		ch->req_buf_cache = kmem_cache_create("srpt-req-buf", req_sz,
-						      512, 0, NULL);
+		ch->req_buf_cache = srpt_cache_get(req_sz);
 		if (!ch->req_buf_cache)
 			goto free_rsp_ring;
 
@@ -2478,7 +2535,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			     ch->req_buf_cache, DMA_FROM_DEVICE);
 
 free_recv_cache:
-	kmem_cache_destroy(ch->req_buf_cache);
+	srpt_cache_put(ch->req_buf_cache);
 
 free_rsp_ring:
 	srpt_free_ioctx_ring((struct srpt_ioctx **)ch->ioctx_ring,
@@ -2486,7 +2543,7 @@ static int srpt_cm_req_recv(struct srpt_device *const sdev,
 			     ch->rsp_buf_cache, DMA_TO_DEVICE);
 
 free_rsp_cache:
-	kmem_cache_destroy(ch->rsp_buf_cache);
+	srpt_cache_put(ch->rsp_buf_cache);
 
 free_ch:
 	if (rdma_cm_id)
@@ -3055,7 +3112,7 @@ static void srpt_free_srq(struct srpt_device *sdev)
 	srpt_free_ioctx_ring((struct srpt_ioctx **)sdev->ioctx_ring, sdev,
 			     sdev->srq_size, sdev->req_buf_cache,
 			     DMA_FROM_DEVICE);
-	kmem_cache_destroy(sdev->req_buf_cache);
+	srpt_cache_put(sdev->req_buf_cache);
 	sdev->srq = NULL;
 }
 
@@ -3082,8 +3139,7 @@ static int srpt_alloc_srq(struct srpt_device *sdev)
 	pr_debug("create SRQ #wr= %d max_allow=%d dev= %s\n", sdev->srq_size,
 		 sdev->device->attrs.max_srq_wr, dev_name(&device->dev));
 
-	sdev->req_buf_cache = kmem_cache_create("srpt-srq-req-buf",
-						srp_max_req_size, 0, 0, NULL);
+	sdev->req_buf_cache = srpt_cache_get(srp_max_req_size);
 	if (!sdev->req_buf_cache)
 		goto free_srq;
 
@@ -3105,7 +3161,7 @@ static int srpt_alloc_srq(struct srpt_device *sdev)
 	return 0;
 
 free_cache:
-	kmem_cache_destroy(sdev->req_buf_cache);
+	srpt_cache_put(sdev->req_buf_cache);
 
 free_srq:
 	ib_destroy_srq(srq);
-- 
2.43.0



