Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793208255;
	b=eG/eOaULLY6TSVMTsJL6X2ryaZGxX2QC9/Jtg9e2hJ0cAdjEo48TiElVI4wIkfCs4+ju
	 b1it5HuT4i3CxIS3JORF3DvBJlWtZ8AecDaKf0BxI5H7A1nj1O02QBPb1YVXVuDM7F0Sw
	 iNH1UcdwLqTmO9IRDGmh2GDKktF6idifVHQb1AGJSdlfBxc2cELyzIdWURF+hPSNoK/0x
	 NAXjjty6M18zGfCL3FNk1P2F422aTj0v62yC0mudnYf1g7gBOaFYJQIAIDVun3+4h4ZmM
	 zwsETr+c4HegyDA0eTPpkCCE3L8BWsGjT9I3GEks10+zS+/N4yjr4QupdruhdVzDqfQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793208255;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=91z8JyPvziNKdNrCLBNpmLawnBas1SfcEmeQ955gISI=;
	b=WLrJFVwShlh6RdBknMKdN2mSj1HI3GHo0gCu6c8w+yzXdEHG37FkHzxyJlLqVXO/siGU
	 yKRek2H+DMmRXFcOSKro3NvHa8g34dnRv5as+zpiKbaQK5pxQgIwZLXRknimUwIFkpeyu
	 B0CdLNIL4tqsLHhNafr9igptpAgmURbCDOoJiHdAxMw6b/yhkOVW1SxhDYyDHshgDVyFH
	 nizDkNpm3acR5VSLmgxxdAaqULeuFvVh3mglsoBXLlYIHQKv3KE34ZBlpq7eOEAKA//jw
	 gUN2687TXtP1GxZXVwnt85fqYZJ01lDky9cC2RUjqB6/1qSs+dqnkjNsb3aZ1akv/2g==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmKUYARh;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC013606A31C;
	Wed, 28 Oct 2026 17:24:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=MmKUYARh
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 056261F01825;
	Wed, 28 Oct 2026 17:24:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793208254;
	bh=91z8JyPvziNKdNrCLBNpmLawnBas1SfcEmeQ955gISI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=MmKUYARhxXZC74WNRAhxwbDe3CaOnLPddHKKaHz6wIxpXXrIkzQ5JXBGaQ4JlCdcI
	 jjCLCwE/yN+y0ohgV7s3LbQvsooyltXjhosbpYajMjJD0E6SVF541yF94vBY2QDbMM
	 EmWDrWqtxcMNdaPIEG//nb/hBEAXkEVx06SbcjA4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Varun Prakash <varun@chelsio.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Christoph Hellwig <hch@lst.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 012/516] nvme-tcp: validate R2T PDU in nvme_tcp_handle_r2t()
Date: Wed, 28 Oct 2026 17:52:44 +0100
Message-ID: <20261028170003.817919998@linuxfoundation.org>
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

From: Varun Prakash <varun@chelsio.com>

[ Upstream commit 1d3ef9c3a39e04be31155c27ebf80342350c3abf ]

If maxh2cdata < r2t_length then driver will form multiple
H2CData PDUs, validate R2T PDU in nvme_tcp_handle_r2t() to
reuse nvme_tcp_setup_h2c_data_pdu().

Also set req->state to NVME_TCP_SEND_H2C_PDU in
nvme_tcp_setup_h2c_data_pdu().

Signed-off-by: Varun Prakash <varun@chelsio.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Stable-dep-of: 6efbc52237fa ("nvme-tcp: fix host memory disclosure on R2T for a read command")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 55 ++++++++++++++++++-----------------------
 1 file changed, 24 insertions(+), 31 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e08fce47e237c..e47c73a74177c 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -607,7 +607,7 @@ static int nvme_tcp_handle_comp(struct nvme_tcp_queue *queue,
 	return ret;
 }
 
-static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
+static void nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 		struct nvme_tcp_r2t_pdu *pdu)
 {
 	struct nvme_tcp_data_pdu *data = req->pdu;
@@ -616,32 +616,11 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	u8 hdgst = nvme_tcp_hdgst_len(queue);
 	u8 ddgst = nvme_tcp_ddgst_len(queue);
 
+	req->state = NVME_TCP_SEND_H2C_PDU;
+	req->offset = 0;
 	req->pdu_len = le32_to_cpu(pdu->r2t_length);
 	req->pdu_sent = 0;
 
-	if (unlikely(!req->pdu_len)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d r2t len is %u, probably a bug...\n",
-			rq->tag, req->pdu_len);
-		return -EPROTO;
-	}
-
-	if (unlikely(req->data_sent + req->pdu_len > req->data_len)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d r2t len %u exceeded data len %u (%zu sent)\n",
-			rq->tag, req->pdu_len, req->data_len,
-			req->data_sent);
-		return -EPROTO;
-	}
-
-	if (unlikely(le32_to_cpu(pdu->r2t_offset) < req->data_sent)) {
-		dev_err(queue->ctrl->ctrl.device,
-			"req %d unexpected r2t offset %u (expected %zu)\n",
-			rq->tag, le32_to_cpu(pdu->r2t_offset),
-			req->data_sent);
-		return -EPROTO;
-	}
-
 	memset(data, 0, sizeof(*data));
 	data->hdr.type = nvme_tcp_h2c_data;
 	data->hdr.flags = NVME_TCP_F_DATA_LAST;
@@ -657,7 +636,6 @@ static int nvme_tcp_setup_h2c_data_pdu(struct nvme_tcp_request *req,
 	data->command_id = nvme_cid(rq);
 	data->data_offset = pdu->r2t_offset;
 	data->data_length = cpu_to_le32(req->pdu_len);
-	return 0;
 }
 
 static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
@@ -665,7 +643,7 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 {
 	struct nvme_tcp_request *req;
 	struct request *rq;
-	int ret;
+	u32 r2t_length = le32_to_cpu(pdu->r2t_length);
 
 	rq = nvme_find_rq(nvme_tcp_tagset(queue), pdu->command_id);
 	if (!rq) {
@@ -676,13 +654,28 @@ static int nvme_tcp_handle_r2t(struct nvme_tcp_queue *queue,
 	}
 	req = blk_mq_rq_to_pdu(rq);
 
-	ret = nvme_tcp_setup_h2c_data_pdu(req, pdu);
-	if (unlikely(ret))
-		return ret;
+	if (unlikely(!r2t_length)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d r2t len is %u, probably a bug...\n",
+			rq->tag, r2t_length);
+		return -EPROTO;
+	}
 
-	req->state = NVME_TCP_SEND_H2C_PDU;
-	req->offset = 0;
+	if (unlikely(req->data_sent + r2t_length > req->data_len)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d r2t len %u exceeded data len %u (%zu sent)\n",
+			rq->tag, r2t_length, req->data_len, req->data_sent);
+		return -EPROTO;
+	}
+
+	if (unlikely(le32_to_cpu(pdu->r2t_offset) < req->data_sent)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"req %d unexpected r2t offset %u (expected %zu)\n",
+			rq->tag, le32_to_cpu(pdu->r2t_offset), req->data_sent);
+		return -EPROTO;
+	}
 
+	nvme_tcp_setup_h2c_data_pdu(req, pdu);
 	nvme_tcp_queue_request(req, false, true);
 
 	return 0;
-- 
2.53.0



