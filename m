Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F2A80423A66;
	Fri,  4 Sep 2026 06:16:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788502606; cv=none; b=mgRT9sTMNfqNx+3WQF21GDP0QXzCVHZV/LSRaYS2bpvV42oe5lozxug6ADni/hOTcx13u5dftAeBU4rB377IzINxSnbMMI7Q0CnFCSOY9ew2aYiaTyv0XhJBV5a1BBkrMONWmu7WOD/sBfCGYe92XVnSJVzK1saCsaX3fveL9cQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788502606; c=relaxed/simple;
	bh=k1Jbd6Ys4nFd+LIyBVIa0JNnLEdxP+0fI7bJH+I32Zg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dcQN0q/sdvtD7xfVZ22Y2bBCLOZ/cqUtqX3BY8bb+dw1YY/DpKtOojcPaR/Ub1UiWJPSjGLbTeqH+dp0KdCdYHdNpVFPNrRmBOg60jZOjZXKEw/7HQ8RvP4gNaJTBhcZSsuwEcCZoxdhcRNdlvq1gBHidGp3xKCCR4vrJMOi5YI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MTQyUN8u; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MTQyUN8u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5966A1F00A3D;
	Fri,  4 Sep 2026 06:16:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788502604;
	bh=KWKCnotoo7HOU/JlhQHoWd0EPyo7yIV+J5C41ivJviI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MTQyUN8uRXxEB7je242n/0utr2l1hjcMJ3ft1QkAwLmBnMQd9UicAGEOkl2YVX9lC
	 CJTE4wXK3WWEBtJkHg15Krh042xa3+Mevu+ASuyqyzVTkK+zyUFcq1PP4zLvTNGl4n
	 E5SL+mECy5SY9wq/k+TWoaIkNPmkce2/ed72qMQs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>
Subject: [PATCH 6.12 264/403] nvme-tcp: reject a read that transferred too few bytes
Date: Fri,  4 Sep 2026 07:01:07 +0200
Message-ID: <20260904045740.864686864@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

commit 7fa3f73f6c8ddc5f0425b50fb2a626a782ef7d12 upstream.

nvme_tcp_recv_data() completes a request once the current C2HData PDU
has been consumed. Nothing compares the total bytes received against
the length the command asked for: struct nvme_tcp_request has no
receive-side counter, queue->data_remaining is per queue, and
blk_mq_end_request() completes for blk_rq_bytes(rq) unconditionally
with no residual concept anywhere above.

A controller can therefore answer a 4096-byte read with 512 bytes and
have it reported as a complete read; user space then gets 4096 bytes of
which 3584 are whatever was already in the page. I reproduced that with
a test target.

Count the bytes received and refuse to complete a successful read whose
count does not match, at the two NVME_TCP_F_DATA_SUCCESS paths and in
nvme_tcp_process_nvme_cqe(). The success test shifts req->status right
by one, because the driver keeps the wire value there and shifts it on
completion, so the check must see what the completion path will see.
Only REQ_OP_READ is checked, because there the length comes from the
sectors the request covers; a passthrough command is built by its
submitter, which picks both command and buffer, so the kernel has
nothing to compare against.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Cc: stable@vger.kernel.org
Signed-off-by: Yehyeong Lee <yhlee@isslab.korea.ac.kr>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/nvme/host/tcp.c |   34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -118,6 +118,7 @@ struct nvme_tcp_request {
 
 	struct bio		*curr_bio;
 	struct iov_iter		iter;
+	u32			data_recvd;
 
 	/* send state */
 	size_t			offset;
@@ -617,6 +618,29 @@ static void nvme_tcp_error_recovery(stru
 	queue_work(nvme_reset_wq, &to_tcp_ctrl(ctrl)->err_work);
 }
 
+/*
+ * NVMe has no short read: a read that completes successfully must
+ * have transferred everything it asked for.
+ */
+static bool nvme_tcp_data_in_short(struct nvme_tcp_queue *queue,
+				   struct request *rq)
+{
+	struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
+
+	if (le16_to_cpu(req->status) >> 1)
+		return false;
+	if (req_op(rq) != REQ_OP_READ || !req->data_len)
+		return false;
+	if (likely(req->data_recvd == req->data_len))
+		return false;
+
+	dev_err(queue->ctrl->ctrl.device,
+		"queue %d tag %#x short data-in: got %u of %u\n",
+		nvme_tcp_queue_id(queue), rq->tag,
+		req->data_recvd, req->data_len);
+	return true;
+}
+
 static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 		struct nvme_completion *cqe)
 {
@@ -636,6 +660,9 @@ static int nvme_tcp_process_nvme_cqe(str
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
+	if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+		return -EPROTO;
+
 	if (!nvme_try_complete_req(rq, req->status, cqe->result))
 		nvme_complete_rq(rq);
 	queue->nr_cqe++;
@@ -965,6 +992,7 @@ static int nvme_tcp_recv_data(struct nvm
 		*len -= recv_len;
 		*offset += recv_len;
 		queue->data_remaining -= recv_len;
+		req->data_recvd += recv_len;
 	}
 
 	if (!queue->data_remaining) {
@@ -973,6 +1001,8 @@ static int nvme_tcp_recv_data(struct nvm
 			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
 		} else {
 			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
+				if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+					return -EPROTO;
 				nvme_tcp_end_request(rq,
 						le16_to_cpu(req->status));
 				queue->nr_cqe++;
@@ -1021,6 +1051,9 @@ static int nvme_tcp_recv_ddgst(struct nv
 					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+		if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+			return -EPROTO;
+
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
 		queue->nr_cqe++;
 	}
@@ -2726,6 +2759,7 @@ static blk_status_t nvme_tcp_setup_cmd_p
 	req->status = cpu_to_le16(NVME_SC_SUCCESS);
 	req->offset = 0;
 	req->data_sent = 0;
+	req->data_recvd = 0;
 	req->pdu_len = 0;
 	req->pdu_sent = 0;
 	req->h2cdata_left = 0;


