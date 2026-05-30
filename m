Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7B8B733FE15;
	Sat, 30 May 2026 17:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780161909; cv=none; b=ExpUgMmXlWhteuT4T4eHCmSaEqm2mFmWKFo0KTqMEh9ejewdEScxorPCU0GdJouI8+bjDZbl7VU4ogIJS3lJzm5UuBDwFFCFXDz0oDk3fmyOXXBq2/N2WczYGBZqrC7n2eCbzV4T6hI2X3Je+4R7AY4/HPJ+c+iZtf3IBxgfp+k=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780161909; c=relaxed/simple;
	bh=3haIF6qSn2woW6nO2qlNCrbVncTdcHzSqDnjhaYslWU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wxtsjy7WDHIPSORQATwjfftVnTY3adlDncKAOYUKoNvSowWnI0FMmuzNx5r1a63I7lQ+N65gSxwQ0IqARLFHi6mwkOKi+PLIleSCj/XVi/Xeyj35wT1ZM313wBX2go0SuXIKZM+O0t68jSiYyLlltdOmpLr7zKtbsy3BfjGqxAo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ta7nFxMb; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ta7nFxMb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C07301F00893;
	Sat, 30 May 2026 17:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780161905;
	bh=gBMWAhK7Of+o5dRqqSbHAckkq666qe8U/KWqZkKGTQg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ta7nFxMbUQPwOXzvDIzSuEGMo/FhEtX3ToGW/PICyZLnGZ6uGx80BFvpD0i1nw1+d
	 7B9TlX+1+nm/OHd0GzA82XDcHhD7DbYS6SexPyfoiT0e7TX0ceQnZWOi/gA7iXjfNi
	 xjqewIPhE7rGeWsG5wMkOfv7fAnx4fxzFOfLHgOc=
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
Subject: [PATCH 6.1 733/969] nvmet-tcp: propagate nvmet_tcp_build_pdu_iovec() errors to its callers
Date: Sat, 30 May 2026 18:04:17 +0200
Message-ID: <20260530160320.785864307@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160300.485627683@linuxfoundation.org>
References: <20260530160300.485627683@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index a46c9f5110838..01d685499b97d 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -308,7 +308,7 @@ static void nvmet_tcp_free_cmd_buffers(struct nvmet_tcp_cmd *cmd)
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue);
 
-static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
+static int nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 {
 	struct bio_vec *iov = cmd->iov;
 	struct scatterlist *sg;
@@ -321,22 +321,19 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
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
@@ -351,6 +348,7 @@ static void nvmet_tcp_build_pdu_iovec(struct nvmet_tcp_cmd *cmd)
 
 	iov_iter_bvec(&cmd->recv_msg.msg_iter, ITER_DEST, cmd->iov,
 		      nr_pages, cmd->pdu_len);
+	return 0;
 }
 
 static void nvmet_tcp_fatal_error(struct nvmet_tcp_queue *queue)
@@ -906,7 +904,7 @@ static int nvmet_tcp_handle_icreq(struct nvmet_tcp_queue *queue)
 	return 0;
 }
 
-static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
+static int nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
 		struct nvmet_tcp_cmd *cmd, struct nvmet_req *req)
 {
 	size_t data_len = le32_to_cpu(req->cmd->common.dptr.sgl.length);
@@ -922,19 +920,23 @@ static void nvmet_tcp_handle_req_failure(struct nvmet_tcp_queue *queue,
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
@@ -986,7 +988,10 @@ static int nvmet_tcp_handle_h2c_data_pdu(struct nvmet_tcp_queue *queue)
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
 
@@ -1049,8 +1054,7 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
 			req->cmd->common.opcode,
 			le32_to_cpu(req->cmd->common.dptr.sgl.length));
 
-		nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
-		return 0;
+		return nvmet_tcp_handle_req_failure(queue, queue->cmd, req);
 	}
 
 	ret = nvmet_tcp_map_data(queue->cmd);
@@ -1067,8 +1071,11 @@ static int nvmet_tcp_done_recv_pdu(struct nvmet_tcp_queue *queue)
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



