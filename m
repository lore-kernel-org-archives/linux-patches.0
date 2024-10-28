Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEF31190056;
	Mon, 28 Oct 2024 06:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730098001; cv=none; b=TmLhnu7YE/pHw60281piX2uvMIf3JLCSdF8N5OEd+r8FdXCTiKD4sJv551c07ulzYpS+IrI8pqUaPvCu2O8xd++8KbxLsjGfEOkYzaBk5bfIu0dxYCpnuf6s5TD3yiJlCK4CoX+hu33zckFTpEo8ZQZIpn14hEFdBFd46aTCgK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730098001; c=relaxed/simple;
	bh=jYIZAwP9Tyv0trArJqb662ABP4owD5KQ/CZ5fnTEgWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OSCRBGkXS3GanRB02tlHemZAMBVhZlLI6vyf/+6VBBVWLQbDS8Svv2bZBVjCaCznfrX0oM1QkGZb4eNvgzxF/7bV/aza2wlWSnvP69UFgtca9VVQGBc456WP4sti43/fzWoPq3PRF6A2Wvr5M0+tkfHPLlqjPd2o4QzD4QT4pEY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BTTa5prL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BTTa5prL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 451C3C4CECD;
	Mon, 28 Oct 2024 06:46:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730098000;
	bh=jYIZAwP9Tyv0trArJqb662ABP4owD5KQ/CZ5fnTEgWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BTTa5prLNFkl68etH6+1DUkt59qhGWiOkbJLvkThXOP8ahpa3b3XO2+J/1Y89YbFK
	 VnYsxZFLI29YgWoSRl/QjG6/3u3byrmYokhyWjnC39FqKJUWvXFDtNBh6vW+nxfdMl
	 i+4+T+xGDpDx9tnGLYDoQ6HNa7fGvhjj3z1TKH/c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shinichiro Kawasaki <shinichiro.kawasaki@wdc.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Bart Van Assche <bvanassche@acm.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 034/261] RDMA/srpt: Make slab cache names unique
Date: Mon, 28 Oct 2024 07:22:56 +0100
Message-ID: <20241028062312.866888939@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241028062312.001273460@linuxfoundation.org>
References: <20241028062312.001273460@linuxfoundation.org>
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

6.11-stable review patch.  If anyone has any objections, please let me know.

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
index 9632afbd727b6..5dfb4644446ba 100644
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



