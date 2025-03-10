Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 07B331C5F1B;
	Mon, 10 Mar 2025 17:25:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741627541; cv=none; b=k0Be171LRJbOGAt70vttCFQzwvTA8gZhFkkdXzpXdRHD39OZ43f5ZmzdMVPaT9mvvwU11Hel9Km5C2bsKnkWIKdDAzrZI1otPFQZsHbbsd8Cb1823dRmbapkWMgk76kZYHHbszjFo7iwnHDen99hySd93Qv/6uq6ecEo45PYdUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741627541; c=relaxed/simple;
	bh=UtlB5nZ+R6xmX8CptkZs5jlnzouolKmsAJd7g+bcS3M=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kTRC/isbzQUgxeVFl3Z6qh1xsn9rhs8kxIN2fAuQHEpkPxlxG/G3MPUTZkqKQsDhmytnNjSxh4U75KkWp2leVGpGzaG/oAPefq64dheqUiF7okhJoENPnHM0DChF8xHgrrANd87Gf7i2xFfp951aF13h3kPPLbCDzVThE34oN3g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xCrfTiRf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xCrfTiRf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798ACC4CEE5;
	Mon, 10 Mar 2025 17:25:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741627540;
	bh=UtlB5nZ+R6xmX8CptkZs5jlnzouolKmsAJd7g+bcS3M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xCrfTiRfDDUXrxu9Oo2tobKR2VHQIoX2ymYi7RcEkR/KfCWXpLR/ThmsPfkfT3AuV
	 ujSpTUibMFFZ1bTFp86MWBKnS0DEIKEngPuGCN4sGXk6K8SH4qXh70tH47NLxko0Iy
	 QTdDGLZHBuxdpPR2tx8CfxaRUyey49HlRC4Ps3Ug=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maurizio Lombardi <mlombard@redhat.com>,
	Sagi Grimberg <sagi@grimberg.me>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 164/269] nvme-tcp: fix potential memory corruption in nvme_tcp_recv_pdu()
Date: Mon, 10 Mar 2025 18:05:17 +0100
Message-ID: <20250310170504.257163247@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170457.700086763@linuxfoundation.org>
References: <20250310170457.700086763@linuxfoundation.org>
User-Agent: quilt/0.68
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
index 749d464bef9f7..0bcc9bf57d1d0 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -217,6 +217,19 @@ static inline int nvme_tcp_queue_id(struct nvme_tcp_queue *queue)
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
 /*
  * Check if the queue is TLS encrypted
  */
@@ -818,6 +831,16 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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
@@ -850,10 +873,13 @@ static int nvme_tcp_recv_pdu(struct nvme_tcp_queue *queue, struct sk_buff *skb,
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
2.39.5



