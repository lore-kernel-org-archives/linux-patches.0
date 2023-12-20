Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E49094A99A;
	Wed, 20 Dec 2023 16:12:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="om9+fXxa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0F13CC433C8;
	Wed, 20 Dec 2023 16:12:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703088727;
	bh=4tO9JCX4Bv8UzIYwOcDQ6bvF/Xy+Poe9RgeayFhGtMU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=om9+fXxabT1yZt1upZ7+40ZC5ckL3cael5gS0KQLlH6kFCt6M56nl82Ck63iryUeL
	 4xrkmj1PkIMF89mt6oclZaSFKWjVFFogjYhXU3INTLOVanpqkhOngGiKN8yCdBeNeY
	 Malc9kGr7h2IDhAV3udgc/mHbO7DNDLqP1672cJU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hyunchul Lee <hyc.lee@gmail.com>,
	Namjae Jeon <linkinjeon@kernel.org>,
	Steve French <stfrench@microsoft.com>
Subject: [PATCH 5.15 037/159] ksmbd: smbd: handle multiple Buffer descriptors
Date: Wed, 20 Dec 2023 17:08:22 +0100
Message-ID: <20231220160933.022859978@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231220160931.251686445@linuxfoundation.org>
References: <20231220160931.251686445@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Hyunchul Lee <hyc.lee@gmail.com>

[ Upstream commit ee1b0558965909872775183dc237cdf9f8eddaba ]

Make ksmbd handle multiple buffer descriptors
when reading and writing files using SMB direct:
Post the work requests of rdma_rw_ctx for
RDMA read/write in smb_direct_rdma_xmit(), and
the work request for the READ/WRITE response
with a remote invalidation in smb_direct_writev().

Signed-off-by: Hyunchul Lee <hyc.lee@gmail.com>
Acked-by: Namjae Jeon <linkinjeon@kernel.org>
Signed-off-by: Steve French <stfrench@microsoft.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 fs/ksmbd/smb2pdu.c        |    5 -
 fs/ksmbd/transport_rdma.c |  164 +++++++++++++++++++++++++++++-----------------
 2 files changed, 107 insertions(+), 62 deletions(-)

--- a/fs/ksmbd/smb2pdu.c
+++ b/fs/ksmbd/smb2pdu.c
@@ -6210,11 +6210,8 @@ static int smb2_set_remote_key_for_rdma(
 				le32_to_cpu(desc[i].length));
 		}
 	}
-	if (ch_count != 1) {
-		ksmbd_debug(RDMA, "RDMA multiple buffer descriptors %d are not supported yet\n",
-			    ch_count);
+	if (!ch_count)
 		return -EINVAL;
-	}
 
 	work->need_invalidate_rkey =
 		(Channel == SMB2_CHANNEL_RDMA_V1_INVALIDATE);
--- a/fs/ksmbd/transport_rdma.c
+++ b/fs/ksmbd/transport_rdma.c
@@ -206,7 +206,9 @@ struct smb_direct_recvmsg {
 struct smb_direct_rdma_rw_msg {
 	struct smb_direct_transport	*t;
 	struct ib_cqe		cqe;
+	int			status;
 	struct completion	*completion;
+	struct list_head	list;
 	struct rdma_rw_ctx	rw_ctx;
 	struct sg_table		sgt;
 	struct scatterlist	sg_list[0];
@@ -1317,6 +1319,16 @@ done:
 	return ret;
 }
 
+static void smb_direct_free_rdma_rw_msg(struct smb_direct_transport *t,
+					struct smb_direct_rdma_rw_msg *msg,
+					enum dma_data_direction dir)
+{
+	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
+			    msg->sgt.sgl, msg->sgt.nents, dir);
+	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+	kfree(msg);
+}
+
 static void read_write_done(struct ib_cq *cq, struct ib_wc *wc,
 			    enum dma_data_direction dir)
 {
@@ -1325,19 +1337,14 @@ static void read_write_done(struct ib_cq
 	struct smb_direct_transport *t = msg->t;
 
 	if (wc->status != IB_WC_SUCCESS) {
+		msg->status = -EIO;
 		pr_err("read/write error. opcode = %d, status = %s(%d)\n",
 		       wc->opcode, ib_wc_status_msg(wc->status), wc->status);
-		smb_direct_disconnect_rdma_connection(t);
+		if (wc->status != IB_WC_WR_FLUSH_ERR)
+			smb_direct_disconnect_rdma_connection(t);
 	}
 
-	if (atomic_inc_return(&t->rw_credits) > 0)
-		wake_up(&t->wait_rw_credits);
-
-	rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
-			    msg->sg_list, msg->sgt.nents, dir);
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
 	complete(msg->completion);
-	kfree(msg);
 }
 
 static void read_done(struct ib_cq *cq, struct ib_wc *wc)
@@ -1356,75 +1363,116 @@ static int smb_direct_rdma_xmit(struct s
 				unsigned int desc_len,
 				bool is_read)
 {
-	struct smb_direct_rdma_rw_msg *msg;
-	int ret;
+	struct smb_direct_rdma_rw_msg *msg, *next_msg;
+	int i, ret;
 	DECLARE_COMPLETION_ONSTACK(completion);
-	struct ib_send_wr *first_wr = NULL;
-	u32 remote_key = le32_to_cpu(desc[0].token);
-	u64 remote_offset = le64_to_cpu(desc[0].offset);
+	struct ib_send_wr *first_wr;
+	LIST_HEAD(msg_list);
+	char *desc_buf;
 	int credits_needed;
+	unsigned int desc_buf_len;
+	size_t total_length = 0;
+
+	if (t->status != SMB_DIRECT_CS_CONNECTED)
+		return -ENOTCONN;
+
+	/* calculate needed credits */
+	credits_needed = 0;
+	desc_buf = buf;
+	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		desc_buf_len = le32_to_cpu(desc[i].length);
+
+		credits_needed += calc_rw_credits(t, desc_buf, desc_buf_len);
+		desc_buf += desc_buf_len;
+		total_length += desc_buf_len;
+		if (desc_buf_len == 0 || total_length > buf_len ||
+		    total_length > t->max_rdma_rw_size)
+			return -EINVAL;
+	}
+
+	ksmbd_debug(RDMA, "RDMA %s, len %#x, needed credits %#x\n",
+		    is_read ? "read" : "write", buf_len, credits_needed);
 
-	credits_needed = calc_rw_credits(t, buf, buf_len);
 	ret = wait_for_rw_credits(t, credits_needed);
 	if (ret < 0)
 		return ret;
 
-	/* TODO: mempool */
-	msg = kmalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
-		      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
-	if (!msg) {
-		atomic_add(credits_needed, &t->rw_credits);
-		return -ENOMEM;
-	}
+	/* build rdma_rw_ctx for each descriptor */
+	desc_buf = buf;
+	for (i = 0; i < desc_len / sizeof(*desc); i++) {
+		msg = kzalloc(offsetof(struct smb_direct_rdma_rw_msg, sg_list) +
+			      sizeof(struct scatterlist) * SG_CHUNK_SIZE, GFP_KERNEL);
+		if (!msg) {
+			ret = -ENOMEM;
+			goto out;
+		}
 
-	msg->sgt.sgl = &msg->sg_list[0];
-	ret = sg_alloc_table_chained(&msg->sgt,
-				     get_buf_page_count(buf, buf_len),
-				     msg->sg_list, SG_CHUNK_SIZE);
-	if (ret) {
-		atomic_add(credits_needed, &t->rw_credits);
-		kfree(msg);
-		return -ENOMEM;
-	}
+		desc_buf_len = le32_to_cpu(desc[i].length);
 
-	ret = get_sg_list(buf, buf_len, msg->sgt.sgl, msg->sgt.orig_nents);
-	if (ret <= 0) {
-		pr_err("failed to get pages\n");
-		goto err;
-	}
+		msg->t = t;
+		msg->cqe.done = is_read ? read_done : write_done;
+		msg->completion = &completion;
+
+		msg->sgt.sgl = &msg->sg_list[0];
+		ret = sg_alloc_table_chained(&msg->sgt,
+					     get_buf_page_count(desc_buf, desc_buf_len),
+					     msg->sg_list, SG_CHUNK_SIZE);
+		if (ret) {
+			kfree(msg);
+			ret = -ENOMEM;
+			goto out;
+		}
 
-	ret = rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
-			       msg->sg_list, get_buf_page_count(buf, buf_len),
-			       0, remote_offset, remote_key,
-			       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	if (ret < 0) {
-		pr_err("failed to init rdma_rw_ctx: %d\n", ret);
-		goto err;
+		ret = get_sg_list(desc_buf, desc_buf_len,
+				  msg->sgt.sgl, msg->sgt.orig_nents);
+		if (ret < 0) {
+			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+			kfree(msg);
+			goto out;
+		}
+
+		ret = rdma_rw_ctx_init(&msg->rw_ctx, t->qp, t->qp->port,
+				       msg->sgt.sgl,
+				       get_buf_page_count(desc_buf, desc_buf_len),
+				       0,
+				       le64_to_cpu(desc[i].offset),
+				       le32_to_cpu(desc[i].token),
+				       is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+		if (ret < 0) {
+			pr_err("failed to init rdma_rw_ctx: %d\n", ret);
+			sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
+			kfree(msg);
+			goto out;
+		}
+
+		list_add_tail(&msg->list, &msg_list);
+		desc_buf += desc_buf_len;
 	}
 
-	msg->t = t;
-	msg->cqe.done = is_read ? read_done : write_done;
-	msg->completion = &completion;
-	first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
-				   &msg->cqe, NULL);
+	/* concatenate work requests of rdma_rw_ctxs */
+	first_wr = NULL;
+	list_for_each_entry_reverse(msg, &msg_list, list) {
+		first_wr = rdma_rw_ctx_wrs(&msg->rw_ctx, t->qp, t->qp->port,
+					   &msg->cqe, first_wr);
+	}
 
 	ret = ib_post_send(t->qp, first_wr, NULL);
 	if (ret) {
-		pr_err("failed to post send wr: %d\n", ret);
-		goto err;
+		pr_err("failed to post send wr for RDMA R/W: %d\n", ret);
+		goto out;
 	}
 
+	msg = list_last_entry(&msg_list, struct smb_direct_rdma_rw_msg, list);
 	wait_for_completion(&completion);
-	return 0;
-
-err:
+	ret = msg->status;
+out:
+	list_for_each_entry_safe(msg, next_msg, &msg_list, list) {
+		list_del(&msg->list);
+		smb_direct_free_rdma_rw_msg(t, msg,
+					    is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
+	}
 	atomic_add(credits_needed, &t->rw_credits);
-	if (first_wr)
-		rdma_rw_ctx_destroy(&msg->rw_ctx, t->qp, t->qp->port,
-				    msg->sg_list, msg->sgt.nents,
-				    is_read ? DMA_FROM_DEVICE : DMA_TO_DEVICE);
-	sg_free_table_chained(&msg->sgt, SG_CHUNK_SIZE);
-	kfree(msg);
+	wake_up(&t->wait_rw_credits);
 	return ret;
 }
 


