Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 519D8392829;
	Sat, 17 Oct 2026 17:24:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257843; cv=none; b=L1NsOWqBgripf1ipFlRR1nSp63TWpMCMbwNRot63ms7AN09hZrRXbpmHwdMSQoq4CoIdKZlwmySU1gz5YieldqCEL08oKuvcx+uzDe9JYl/QtxStmNcLqyOc1A/o42D0++LHbyhvnlaRnk2njLczc86aozpsZzRs3YUtdpq8Ozc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257843; c=relaxed/simple;
	bh=xkNiCC0/3my+oGI2HjC5XzmhxHUfdAFAdRCk9I+F61c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Igi2KSrBguVd9XCG5WEaUHQ5JZD0a7m6DP8rsZCQPue9qZjVCoYmlWhkPbHS78oXrbiG/Utkz59iabA3L6UzhLXs3FRi/7izEynIAq5FGmrVaS+S947EyTfUDbu7Wt4H/WoYrRcQM+MCaI/HqaAQ77OiBD9nm1wdsyaEj40mgmI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=BZpawxX3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="BZpawxX3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9701F000C4;
	Sat, 17 Oct 2026 17:24:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257842;
	bh=cCEWq7wUKUjPsI52NN6oP+MHpmwB95H/3YGaICQJCuA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BZpawxX3X0Dk6tbZLc/nt3vrMoTY/GVdxueQzfAvr0UZsmwHRCeYNZ3DNBIVfwyfM
	 gO0okhzftBLDZ0kR2AqY+ZQJWGjKI6OQvV32D5ZbBoPdnSMKIkdyYMtH5qHzEtL7Ve
	 n92/P9XQGD/2TwdTIW2APOnZsHKw04eMrLWsUamU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0687/1674] nvme-tcp: fix potential memory corruption in nvme_tcp_recv_pdu()
Date: Sat, 17 Oct 2026 17:49:19 +0200
Message-ID: <20261017160448.742002662@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index e270024fe5490..cd8fb901cabcd 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -190,6 +190,19 @@ static inline int nvme_tcp_queue_id(struct nvme_tcp_queue *queue)
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
@@ -816,6 +829,16 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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
@@ -848,10 +871,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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



