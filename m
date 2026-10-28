Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208138;
	b=YBp1DhumdVsFKImjP+Zd8jhFMQfr9FF4TVJ/agq771AKcVuHo/N1HYdPHjJhRLt++4kB
	 gsCy2uZCGsJi5Bl4YPUSRnK5o53FepYJqUbQk1ZbO9hUTUcz9hdaxAp1cva51tcOZNeZR
	 j4DIBZDbPeB3i6+DEHXjKt/w3dNqsqnrkrtzSvy0mpPt97Vg8eNRcHmFQoSnotckZ7LyS
	 spL34RqrhiBupagVtL2jf9157v6nZnYwnYqvaHndD6H6u8C/BLubfGLZ4uIn5IKBt5At4
	 whsGAqOI90o2dd7QAN65H2TbfaagQSuYP0BFMwsxZ3CBiQtw2/22fWHkuZXhSyM0/KQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208138;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ryIHsU/S/sUZPfWbuOTE/v1QAwccSKn8dM32DK+l35o=;
	b=TMciuYY24+cACGCAkBwcAqI6Kklp3UoukxD2aK6YbvU1Iuo4tdIkR5K4fReWERbqOaTk
	 BAoQVKoKNWjjwoKpOnWJYcQupYa/Ir7/efsvgVKBnEs94hHGCVNOGyxMvoKve1stDrk66
	 rE7WNIfnRu5sjjGb8rKh8QN2R1aB0FavNErRjRW34QwXl6nhZTd0/Wi2RUb/gyXEhwsaO
	 oTv3yFcK/GSPnOSvzYcgGbawPaoUOOmK9DyOWF/6Y6J7J8oVp0nDLkx/cOQSpWOeTdocm
	 v5MGZli+97qXzoYaZrFMo2etKprJSD0kCXedSehIQSoFXahsBqGy9titZSMHFy3EUMw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13ISNFt8;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1FE8160A2606;
	Wed, 28 Oct 2026 17:22:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=13ISNFt8
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F03C1F01829;
	Wed, 28 Oct 2026 17:22:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208138;
	bh=ryIHsU/S/sUZPfWbuOTE/v1QAwccSKn8dM32DK+l35o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=13ISNFt8onK6IbJZQkHjGBmG9Jfdk7QhyH+O0q1TNNM6usRiOhHiGtPv3drbF7SXa
	 cFAwf3ZIJAI4j6Cu88VuSGc9hflwJq5Z05MEfakVrHwdI8oMEukLfgq1keR/h5lvLC
	 RGctvHMWRadm3ex83/47YanIVm42C0lnUpmZAwvM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yehyeong Lee <yhlee@isslab.korea.ac.kr>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 015/516] nvme-tcp: reject a read that transferred too few bytes
Date: Wed, 28 Oct 2026 17:52:47 +0100
Message-ID: <20261028170003.889657705@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170003.522232767@linuxfoundation.org>
References: <20261028170003.522232767@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yehyeong Lee <yhlee@isslab.korea.ac.kr>

[ Upstream commit 7fa3f73f6c8ddc5f0425b50fb2a626a782ef7d12 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 34 ++++++++++++++++++++++++++++++++++
 1 file changed, 34 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 9be5e42d0c709..fd222eed9e019 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -90,6 +90,7 @@ struct nvme_tcp_request {
 
 	struct bio		*curr_bio;
 	struct iov_iter		iter;
+	u32			data_recvd;
 
 	/* send state */
 	size_t			offset;
@@ -522,6 +523,29 @@ static void nvme_tcp_error_recovery(struct nvme_ctrl *ctrl)
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
@@ -541,6 +565,9 @@ static int nvme_tcp_process_nvme_cqe(struct nvme_tcp_queue *queue,
 	if (req->status == cpu_to_le16(NVME_SC_SUCCESS))
 		req->status = cqe->status;
 
+	if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+		return -EPROTO;
+
 	if (!nvme_try_complete_req(rq, req->status, cqe->result))
 		nvme_complete_rq(rq);
 	queue->nr_cqe++;
@@ -804,6 +831,7 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		*len -= recv_len;
 		*offset += recv_len;
 		queue->data_remaining -= recv_len;
+		req->data_recvd += recv_len;
 	}
 
 	if (!queue->data_remaining) {
@@ -812,6 +840,8 @@ static int nvme_tcp_recv_data(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 			queue->ddgst_remaining = NVME_TCP_DIGEST_LENGTH;
 		} else {
 			if (pdu->hdr.flags & NVME_TCP_F_DATA_SUCCESS) {
+				if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+					return -EPROTO;
 				nvme_tcp_end_request(rq,
 						le16_to_cpu(req->status));
 				queue->nr_cqe++;
@@ -860,6 +890,9 @@ static int nvme_tcp_recv_ddgst(struct nvme_tcp_queue *queue,
 					pdu->command_id);
 		struct nvme_tcp_request *req = blk_mq_rq_to_pdu(rq);
 
+		if (unlikely(nvme_tcp_data_in_short(queue, rq)))
+			return -EPROTO;
+
 		nvme_tcp_end_request(rq, le16_to_cpu(req->status));
 		queue->nr_cqe++;
 	}
@@ -2395,6 +2428,7 @@ static blk_status_t nvme_tcp_setup_cmd_pdu(struct nvme_ns *ns,
 	req->status = cpu_to_le16(NVME_SC_SUCCESS);
 	req->offset = 0;
 	req->data_sent = 0;
+	req->data_recvd = 0;
 	req->pdu_len = 0;
 	req->pdu_sent = 0;
 	req->data_len = blk_rq_nr_phys_segments(rq) ?
-- 
2.53.0



