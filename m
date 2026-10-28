Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793214139;
	b=DUCTlcM4iXqxz24nzgEpKpliV77CyLCTop8sJHvEq1HX5OKMzf8ajTfqVbJCc3RVBdwV
	 xX8ujc5F80ExRwBFoIjbJ+b3cxEE6YkGPNpAT3v1LElqR4bfYmJ6h6/3+zTHJNeM0MScX
	 f/By9uRBASPA6uZfiCdY+M38IT0JfzHJleLM1V/ymDVpus6xeoPFVg06WNjGkyG9SAYgL
	 DIzg7VfAXM4GtssgYRy8mQjMdjgf4ffhGV2Y/T+YU5pkndU2vJ5qzUmwasEjjrP6Bmzlv
	 2Mb0FwQxyJQ6hN/2czeRQVsJYslV7Ru2nGMgTV0s5s4JLq2PUymBNm/E/871/VhrCQw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793214139;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=XjZ41kPI3O9etMuxXywuO8RNQQLXfCaqFAZNFYRSnR0=;
	b=ts6vDZG9565XYHDPJNeTTwMK/51EDbYqJOmfYzEsk3Vnq3ouwimCwYOfH3LLlN+BDP8e
	 TxprYm12+uqVruCBLPuGINMJfbeAwtfqZ4H1TrIXLiOVPGdR2yTKHafR1UwHSDm1Boudf
	 rFBtNE0xx/xJMRXRJSh6Tx9vnXWyVBUqgubbtJNnlsMEpqfmRQchdpgPgrqD/XQvIREdt
	 PBjtrjoJjqw6WUuiw8gKvNEqG8qCUV0P9XcCqLvbX/pHbCO0Wqr0fkA3Qqu0TbZy0E5pR
	 PxVdY+n2jISFh+JHd4z8WMraFHyZAnseWEVl1PRgsSQVXhNfE5Jzwdt9GLwqPW5F3RA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrLxTP3y;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E4074606A31F;
	Wed, 28 Oct 2026 19:02:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=SrLxTP3y
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 40FB51F01825;
	Wed, 28 Oct 2026 19:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793214138;
	bh=XjZ41kPI3O9etMuxXywuO8RNQQLXfCaqFAZNFYRSnR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=SrLxTP3yLTa5ePUyJw96t/nrtc43s59Anux0lD3A9KWhzHybDtyCB783UXoKTSoAX
	 Pyfr7NH7/YAzCvqJ1D4ZFfTu6AlKflVDGcjOGPjK5Yf+5Vjk/X8m7HJYnOLwiFeqE6
	 cmztWVXNKxNEqPInwUR9oFxiNla/NEeE2y7l+mTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0752/1887] nvme-tcp: fix potential memory corruption in nvme_tcp_recv_pdu()
Date: Wed, 28 Oct 2026 17:47:28 +0100
Message-ID: <20261028170516.557779873@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maurizio Lombardi <mlombard@redhat.com>

[ Upstream commit ad95bab0cd28ed77c2c0d0b6e76e03e031391064 ]

nvme_tcp_recv_pdu() doesn't check the validity of the header length.
When header digests are enabled, a target might send a packet with an
invalid header length (e.g. 255), causing nvme_tcp_verify_hdgst()
to access memory outside the allocated area and cause memory corruptions
by overwriting it with the calculated digest.

Fix this by rejecting packets with an unexpected header length.

Fixes: 3f2304f8c6d6 ("nvme-tcp: add NVMe over TCP host driver")
Signed-off-by: Maurizio Lombardi <mlombard@redhat.com>
Reviewed-by: Sagi Grimberg <sagi@grimberg.me>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 32 +++++++++++++++++++++++++++++---
 1 file changed, 29 insertions(+), 3 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index e139f567a8535..19aed2125a18b 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -189,6 +189,19 @@ static inline int nvme_tcp_queue_id(struct nvme_tcp_queue *queue)
 	return queue - queue->ctrl->queues;
 }
 
+static inline bool nvme_tcp_recv_pdu_supported(enum nvme_tcp_pdu_type type)
+{
+	switch (type) {
+	case nvme_tcp_c2h_term:
+	case nvme_tcp_c2h_data:
+	case nvme_tcp_r2t:
+	case nvme_tcp_rsp:
+		return true;
+	default:
+		return false;
+	}
+}
+
 static inline struct blk_mq_tags *nvme_tcp_tagset(struct nvme_tcp_queue *queue)
 {
 	u32 queue_idx = nvme_tcp_queue_id(queue);
@@ -792,6 +805,16 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		return 0;
 
 	hdr = queue->pdu;
+	if (unlikely(hdr->hlen != sizeof(struct nvme_tcp_rsp_pdu))) {
+		if (!nvme_tcp_recv_pdu_supported(hdr->type))
+			goto unsupported_pdu;
+
+		dev_err(queue->ctrl->ctrl.device,
+			"pdu type %d has unexpected header length (%d)\n",
+			hdr->type, hdr->hlen);
+		return -EPROTO;
+	}
+
 	if (unlikely(hdr->type == nvme_tcp_c2h_term)) {
 		/*
 		 * C2HTermReq never includes Header or Data digests.
@@ -824,10 +847,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
 		nvme_tcp_init_recv_ctx(queue);
 		return nvme_tcp_handle_r2t(queue, (void *)queue->pdu);
 	default:
-		dev_err(queue->ctrl->ctrl.device,
-			"unsupported pdu type (%d)\n", hdr->type);
-		return -EINVAL;
+		goto unsupported_pdu;
 	}
+
+unsupported_pdu:
+	dev_err(queue->ctrl->ctrl.device,
+		"unsupported pdu type (%d)\n", hdr->type);
+	return -EINVAL;
 }
 
 static inline void nvme_tcp_end_request(struct request *rq, u16 status)
-- 
2.53.0



