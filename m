Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2FB7828DC4;
	Wed, 20 May 2026 17:04:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779296692; cv=none; b=KnwFmxmkR0tMwXyOg75/LkS/ol+pX+QzihRAsSnFmTZDgb1s+jR9DWamtMivbv4jJ1ouNMvZAHK6BzIxZs7x4eeDuooruJuDCUm2wq2TuZmbjVp9HiKbTR4UKGGOuc+mIiUYhQA0tGoNs7MhaUP9lTCVzbFptzaTFT3lIVkLbMc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779296692; c=relaxed/simple;
	bh=KRvhk81l1RhaXXOCN2OBjMEOcMfDa8i0QgYe8xBNWzE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YaEUnhcDg3NlYCQnx+qA4MT8QpegQH3chDwCj5nRpfHYA9g0A0DU0BHUHKzknbXKav7QI8VMJor9jzhNIpPl8KiyxPq4BSh7xkGUHSEhQFLdkZ/EoS+rSSGOS8gWA9GXvLBKDieHKA8WE5yD1RQ9Kqee/8m3zDK1GIvrA3GYVKE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=We8RtHI5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="We8RtHI5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BD511F000E9;
	Wed, 20 May 2026 17:04:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779296688;
	bh=+53VKXuqinZ0Eg1KXy9GPCQEGIPiTrfJj2rG+W9SqME=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=We8RtHI5aVdam4yD6/NefrpCHX5Da6R7n4sTyqW2zLvErzgzw5aCtoBRFg5qWHK5S
	 ujerQHwzp7ni5vGqdOar6kBgoOWQWRv/I2R2TfRGfXxL2EahjR9nB2bqW3Q1W4QBhE
	 jgaNK0/87BJ2gAmSiL0RCzv5nTkz4BAE3r5ciWcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@suse.de>,
	Yunje Shin <ioerts@kookmin.ac.kr>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Maurizio Lombardi <mlombard@redhat.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 0894/1146] nvmet-tcp: propagate nvmet_tcp_build_pdu_iovec() errors to its callers
Date: Wed, 20 May 2026 18:19:04 +0200
Message-ID: <20260520162208.468953416@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162148.390695140@linuxfoundation.org>
References: <20260520162148.390695140@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit ea8e356acb165cb1fd75537a52e1f66e5e76c538 ]

Currently, when nvmet_tcp_build_pdu_iovec() detects an out-of-bounds
PDU length or offset, it triggers nvmet_tcp_fatal_error(cmd->queue)
and returns early. However, because the function returns void, the
callers are entirely unaware that a fatal error has occurred and
that the cmd->recv_msg.msg_iter was left uninitialized.

Callers such as nvmet_tcp_handle_h2c_data_pdu() proceed to blindly
overwrite the queue state with queue->rcv_state = NVMET_TCP_RECV_DATA
Consequently, the socket receiving loop may attempt to read incoming
network data into the uninitialized iterator.

Fix this by shifting the error handling responsibility to the callers.

Fixes: 52a0a9854934 ("nvmet-tcp: add bounds checks in nvmet_tcp_build_pdu_iovec")
Reviewed-by: Hannes Reinecke <hare@suse.de>
Reviewed-by: Yunje Shin <ioerts@kookmin.ac.kr>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 51 ++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 22 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index 255ebd948dfe1..dc65894696ad9 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -351,7 +351,7 @@ static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd)
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue);
 
-static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
+static int nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
@@ -364,22 +364,19 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 	offset = cmd->rbytes_done;
 	cmd->sg_idx = offset / PAGE_SIZE;
 	sg_offset = offset % PAGE_SIZE;
-	if (!cmd->req.sg_cnt || cmd->sg_idx >= cmd->req.sg_cnt) {
-		nvmet_tcp_fatal_error(cmd->queue);
-		return;
-	}
+	if (!cmd->req.sg_cnt || cmd->sg_idx >= cmd->req.sg_cnt)
+		return -EPROTO;
+
 	sg = &cmd->req.sg[cmd->sg_idx];
 	sg_remaining = cmd->req.sg_cnt - cmd->sg_idx;
 
 	while (length) {
-		if (!sg_remaining) {
-			nvmet_tcp_fatal_error(cmd->queue);
-			return;
-		}
-		if (!sg->length || sg->length <= sg_offset) {
-			nvmet_tcp_fatal_error(cmd->queue);
-			return;
-		}
+		if (!sg_remaining)
+			return -EPROTO;
+
+		if (!sg->length || sg->length <= sg_offset)
+			return -EPROTO;
+
 		u32 iov_len = min_t(u32, length, sg->length - sg_offset);
 
 		bvec_set_page(iov, sg_page(sg), iov_len,
@@ -394,6 +391,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 
 	iov_iter_bvec(&cmd->recv_msg.msg_iter, ITER_DEST, cmd->iov,
 		      nr_pages, cmd->pdu_len);
+	return 0;
 }
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue)
@@ -957,7 +955,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 	return 0;
 }
 
-static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
+static int nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
 		struct nvmet_tcp_cmd *cmd, struct nvmet_req *req)
 {
 	size_t data_len = le32_to_cpu(req->cmd->common.dptr.sgl.length);
@@ -973,19 +971,23 @@ static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
 	if (!nvme_is_write(cmd->req.cmd) || !data_len ||
 	    data_len > cmd->req.port->inline_data_size) {
 		nvmet_prepare_receive_pdu(queue);
-		return;
+		return 0;
 	}
 
 	ret = nvmet_tcp_map_data(cmd);
 	if (unlikely(ret)) {
 		pr_err("queue %d: failed to map data\n", queue->idx);
 		nvmet_tcp_fatal_error(queue);
-		return;
+		return -EPROTO;
 	}
 
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
-	nvmet_tcp_build_pdu_iovec(cmd);
 	cmd->flags |= NVMET_TCP_F_INIT_FAILED;
+	ret = nvmet_tcp_build_pdu_iovec(cmd);
+	if (unlikely(ret))
+		pr_err("queue %d: failed to build PDU iovec\n", queue->idx);
+
+	return ret;
 }
 
 static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
@@ -1037,7 +1039,10 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
 		goto err_proto;
 	}
 	cmd->pdu_recv = 0;
-	nvmet_tcp_build_pdu_iovec(cmd);
+	if (unlikely(nvmet_tcp_build_pdu_iovec(cmd))) {
+		pr_err("queue %d: failed to build PDU iovec\n", queue->idx);
+		goto err_proto;
+	}
 	queue->cmd = cmd;
 	queue->rcv_state = NVMET_TCP_RECV_DATA;
 
@@ -1100,8 +1105,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 			le32_to_cpu(req->cmd->common.dptr.sgl.length),
 			le16_to_cpu(req->cqe->status));
 
-		nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
-		return 0;
+		return nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
 	}
 
 	ret = nvmet_tcp_map_data(queue->cmd);
@@ -1118,8 +1122,11 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 	if (nvmet_tcp_need_data_in(queue->cmd)) {
 		if (nvmet_tcp_has_inline_data(queue->cmd)) {
 			queue->rcv_state = NVMET_TCP_RECV_DATA;
-			nvmet_tcp_build_pdu_iovec(queue->cmd);
-			return 0;
+			ret = nvmet_tcp_build_pdu_iovec(queue->cmd);
+			if (unlikely(ret))
+				pr_err("queue %d: failed to build PDU iovec\n",
+					queue->idx);
+			return ret;
 		}
 		/* send back R2T */
 		nvmet_tcp_queue_response(&queue->cmd->req);
-- 
2.53.0



