Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 639573612DE;
	Tue,  6 Jan 2026 17:50:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767721817; cv=none; b=ZHLiz/ea5Cr20cRZ4ZVw/VoC2gN5oFEkipz+iH+Xp/IE8y1FGKNnu/QXhlJRVDBQhGlAtRKE017fQxxWnkfn4HHG/l2keniP/ydItMDA7GeEeHkPF+qWNVSG80/qlA84EvObKO/cQAFgFt7CB8XsWyAcg5Lwlu3RXQSQdNQAhII=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767721817; c=relaxed/simple;
	bh=Ruq1Mm1Ex1xsM+Le6sf7/8QRIzX3WjdsAX/3zdlrXvc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bIJToXgHre8qxfuXFfsc4Q3z1QTzOMBP23miFYM8XmEhUE66RFCKOiVO49G+sfs0fZDZKw7cJaiMeAZfkCjPTBfhEYmn9Ac5gzec3tyZSLp3ubKUfYkEqqq9yR871Xy53HsuuelZZt2w0sNj+sPXYg5LL+f85FxNwj10rQXjBe0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sg0O4WVE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sg0O4WVE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 70D56C116C6;
	Tue,  6 Jan 2026 17:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767721816;
	bh=Ruq1Mm1Ex1xsM+Le6sf7/8QRIzX3WjdsAX/3zdlrXvc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sg0O4WVEbY8iei+gcoQze1xfkeMuL35kJhWUnTVc3a7swSKnApSZhRb5bZDhDnyCR
	 9HxbsIBkOMdqsnr7DH8PaP7KmaF2r+PTQmRQDw6anlNNTNZMXEaOZC82oaSy/rX+oo
	 8PwKnTtkjnkl2GeeMH6aS6XWBUCF3Dly3zmjna2I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Caleb Sander Mateos <csander@purestorage.com>,
	Ming Lei <ming.lei@redhat.com>,
	Jens Axboe <axboe@kernel.dk>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 080/312] ublk: implement NUMA-aware memory allocation
Date: Tue,  6 Jan 2026 18:02:34 +0100
Message-ID: <20260106170550.734129844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260106170547.832845344@linuxfoundation.org>
References: <20260106170547.832845344@linuxfoundation.org>
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

From: Ming Lei <ming.lei@redhat.com>

[ Upstream commit 529d4d6327880e5c60f4e0def39b3faaa7954e54 ]

Implement NUMA-friendly memory allocation for ublk driver to improve
performance on multi-socket systems.

This commit includes the following changes:

1. Rename __queues to queues, dropping the __ prefix since the field is
   now accessed directly throughout the codebase rather than only through
   the ublk_get_queue() helper.

2. Remove the queue_size field from struct ublk_device as it is no longer
   needed.

3. Move queue allocation and deallocation into ublk_init_queue() and
   ublk_deinit_queue() respectively, improving encapsulation. This
   simplifies ublk_init_queues() and ublk_deinit_queues() to just
   iterate and call the per-queue functions.

4. Add ublk_get_queue_numa_node() helper function to determine the
   appropriate NUMA node for a queue by finding the first CPU mapped
   to that queue via tag_set.map[HCTX_TYPE_DEFAULT].mq_map[] and
   converting it to a NUMA node using cpu_to_node(). This function is
   called internally by ublk_init_queue() to determine the allocation
   node.

5. Allocate each queue structure on its local NUMA node using
   kvzalloc_node() in ublk_init_queue().

6. Allocate the I/O command buffer on the same NUMA node using
   alloc_pages_node().

This reduces memory access latency on multi-socket NUMA systems by
ensuring each queue's data structures are local to the CPUs that
access them.

Reviewed-by: Caleb Sander Mateos <csander@purestorage.com>
Signed-off-by: Ming Lei <ming.lei@redhat.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Stable-dep-of: 7fc4da6a304b ("ublk: scan partition in async way")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/block/ublk_drv.c | 84 +++++++++++++++++++++++++---------------
 1 file changed, 53 insertions(+), 31 deletions(-)

diff --git a/drivers/block/ublk_drv.c b/drivers/block/ublk_drv.c
index d8079ea8f8ca..796035891888 100644
--- a/drivers/block/ublk_drv.c
+++ b/drivers/block/ublk_drv.c
@@ -210,9 +210,6 @@ struct ublk_queue {
 struct ublk_device {
 	struct gendisk		*ub_disk;
 
-	char	*__queues;
-
-	unsigned int	queue_size;
 	struct ublksrv_ctrl_dev_info	dev_info;
 
 	struct blk_mq_tag_set	tag_set;
@@ -240,6 +237,8 @@ struct ublk_device {
 	bool canceling;
 	pid_t 	ublksrv_tgid;
 	struct delayed_work	exit_work;
+
+	struct ublk_queue       *queues[];
 };
 
 /* header of ublk_params */
@@ -782,7 +781,7 @@ static noinline void ublk_put_device(struct ublk_device *ub)
 static inline struct ublk_queue *ublk_get_queue(struct ublk_device *dev,
 		int qid)
 {
-       return (struct ublk_queue *)&(dev->__queues[qid * dev->queue_size]);
+	return dev->queues[qid];
 }
 
 static inline bool ublk_rq_has_data(const struct request *rq)
@@ -2713,9 +2712,13 @@ static const struct file_operations ublk_ch_fops = {
 
 static void ublk_deinit_queue(struct ublk_device *ub, int q_id)
 {
-	int size = ublk_queue_cmd_buf_size(ub);
-	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
-	int i;
+	struct ublk_queue *ubq = ub->queues[q_id];
+	int size, i;
+
+	if (!ubq)
+		return;
+
+	size = ublk_queue_cmd_buf_size(ub);
 
 	for (i = 0; i < ubq->q_depth; i++) {
 		struct ublk_io *io = &ubq->ios[i];
@@ -2727,57 +2730,76 @@ static void ublk_deinit_queue(struct ublk_device *ub, int q_id)
 
 	if (ubq->io_cmd_buf)
 		free_pages((unsigned long)ubq->io_cmd_buf, get_order(size));
+
+	kvfree(ubq);
+	ub->queues[q_id] = NULL;
+}
+
+static int ublk_get_queue_numa_node(struct ublk_device *ub, int q_id)
+{
+	unsigned int cpu;
+
+	/* Find first CPU mapped to this queue */
+	for_each_possible_cpu(cpu) {
+		if (ub->tag_set.map[HCTX_TYPE_DEFAULT].mq_map[cpu] == q_id)
+			return cpu_to_node(cpu);
+	}
+
+	return NUMA_NO_NODE;
 }
 
 static int ublk_init_queue(struct ublk_device *ub, int q_id)
 {
-	struct ublk_queue *ubq = ublk_get_queue(ub, q_id);
+	int depth = ub->dev_info.queue_depth;
+	int ubq_size = sizeof(struct ublk_queue) + depth * sizeof(struct ublk_io);
 	gfp_t gfp_flags = GFP_KERNEL | __GFP_ZERO;
-	void *ptr;
+	struct ublk_queue *ubq;
+	struct page *page;
+	int numa_node;
 	int size;
 
+	/* Determine NUMA node based on queue's CPU affinity */
+	numa_node = ublk_get_queue_numa_node(ub, q_id);
+
+	/* Allocate queue structure on local NUMA node */
+	ubq = kvzalloc_node(ubq_size, GFP_KERNEL, numa_node);
+	if (!ubq)
+		return -ENOMEM;
+
 	spin_lock_init(&ubq->cancel_lock);
 	ubq->flags = ub->dev_info.flags;
 	ubq->q_id = q_id;
-	ubq->q_depth = ub->dev_info.queue_depth;
+	ubq->q_depth = depth;
 	size = ublk_queue_cmd_buf_size(ub);
 
-	ptr = (void *) __get_free_pages(gfp_flags, get_order(size));
-	if (!ptr)
+	/* Allocate I/O command buffer on local NUMA node */
+	page = alloc_pages_node(numa_node, gfp_flags, get_order(size));
+	if (!page) {
+		kvfree(ubq);
 		return -ENOMEM;
+	}
+	ubq->io_cmd_buf = page_address(page);
 
-	ubq->io_cmd_buf = ptr;
+	ub->queues[q_id] = ubq;
 	ubq->dev = ub;
 	return 0;
 }
 
 static void ublk_deinit_queues(struct ublk_device *ub)
 {
-	int nr_queues = ub->dev_info.nr_hw_queues;
 	int i;
 
-	if (!ub->__queues)
-		return;
-
-	for (i = 0; i < nr_queues; i++)
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++)
 		ublk_deinit_queue(ub, i);
-	kvfree(ub->__queues);
 }
 
 static int ublk_init_queues(struct ublk_device *ub)
 {
-	int nr_queues = ub->dev_info.nr_hw_queues;
-	int depth = ub->dev_info.queue_depth;
-	int ubq_size = sizeof(struct ublk_queue) + depth * sizeof(struct ublk_io);
-	int i, ret = -ENOMEM;
+	int i, ret;
 
-	ub->queue_size = ubq_size;
-	ub->__queues = kvcalloc(nr_queues, ubq_size, GFP_KERNEL);
-	if (!ub->__queues)
-		return ret;
-
-	for (i = 0; i < nr_queues; i++) {
-		if (ublk_init_queue(ub, i))
+	for (i = 0; i < ub->dev_info.nr_hw_queues; i++) {
+		ret = ublk_init_queue(ub, i);
+		if (ret)
 			goto fail;
 	}
 
@@ -3179,7 +3201,7 @@ static int ublk_ctrl_add_dev(const struct ublksrv_ctrl_cmd *header)
 		goto out_unlock;
 
 	ret = -ENOMEM;
-	ub = kzalloc(sizeof(*ub), GFP_KERNEL);
+	ub = kzalloc(struct_size(ub, queues, info.nr_hw_queues), GFP_KERNEL);
 	if (!ub)
 		goto out_unlock;
 	mutex_init(&ub->mutex);
-- 
2.51.0



