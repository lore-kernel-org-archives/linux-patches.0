Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794065588;
	b=J2nBpn1h6Uh+W0yftaYDrqzaVNjykqda0k0le3EqCTwCgDKlaosGDiu5P5kqPAFkpno1
	 BQ2f+KvyBoN0Jwc91g2LYKLLvxE00nwWyGBFZIwqAa0CCF4GsDDGWCuV9gFaO4jjcX7H7
	 zIU2s9SVqQFwXMVehHvhYwNiFgUj2xXtlWTUSV5Wn/t6yc6wN0vCtGY/jDoWaBtuG75qi
	 M9kLRJblsw1GlIPqmTrmxw95v6ksK1it0AFKovYT3OZFnm5SMeS2vL0yCyaxgEMavxBvO
	 PQIqH4FGSvcyVgPeJM3vk+xvQywUr30E7/+p2lDCqucV0SX6SJchfDcW8h6HHKvzjmQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794065588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=aVXWpLG8V1Sy3WfagclSjN3lB4ccqp29SUkA7nZfn3I=;
	b=fbdY0M7xgQVGgL0nDDKy+KYWXR9AF2kTh3/Mw3R21+G4/MmO6xPKoQJEM7VZI4U/J2/A
	 1iGkbkXBwhX1dIuUA4LX8hepDArRmTvyqcL6fviVbzJnmG3jVVoqdb3Kg9WFUTShl54uv
	 8pTMquO4gjQStTaviFdPnXIn3DiytGzxNcMFBsRjJVKuZT+U78RYRMMmVnyTh56juQh2r
	 dKlBIcTtgyOsTg/ZO8j5JNoRSOuFRdi4GweNbodcswTPFvSO5gRDZKC+MBTPs9dkxKxQj
	 UVUF+h8+zrx0dKu8vnedUIG23cC8YhuEMDPOpnb9c3sr6tXkUPv36mgnXL351fY293w==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTNEjw06;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2256606A32C;
	Sat,  7 Nov 2026 15:33:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=bTNEjw06
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 50CA01F0089F;
	Sat,  7 Nov 2026 15:33:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794065587;
	bh=aVXWpLG8V1Sy3WfagclSjN3lB4ccqp29SUkA7nZfn3I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=bTNEjw06BRkhS4hpqUI1XZ7BaJueIZ6HhIrR3Pni/42cQpoo9oY/BhJDwSNx6nwHi
	 jyy7nEAg7T30Pd22KxDibViAtEniSCBAZhOHHHSlTj4zi7BM2rcEQlzdvZLAvgZuc0
	 DeB9bKETw/SsUozgP8XuG9FyPnJjT9z5zMn8mpaE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Martin Belanger <martin.belanger@dell.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 1208/1257] nvme-tcp: start error recovery when read_sock fails
Date: Sat,  7 Nov 2026 08:58:24 -0500
Message-ID: <20261107135012.709607533@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134939.434104957@linuxfoundation.org>
References: <20261107134939.434104957@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Martin Belanger <martin.belanger@dell.com>

[ Upstream commit 288cfa187208cc9d0809eb8e1508658151a444dd ]

nvme_tcp_recv_skb() disables the queue and starts error recovery for
errors it detects itself. An error returned by the transport reaches
nvme_tcp_try_recv() without either action.

nvme_tcp_io_work() returns on a negative result and does not requeue
itself, so the queue stops receiving and remains stalled until a command
times out.

Report the error and start error recovery when the queue is still
enabled, which indicates that the error was not handled by the actor.
Do this under the socket lock, as nvme_tcp_recv_skb() does.

Fixes: be8e82caa685 ("nvme-tcp: enable TLS handshake upcall")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Martin Belanger <martin.belanger@dell.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index 7eec983c0eade..129966ffeb9c5 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1421,6 +1421,19 @@ static int nvme_tcp_try_recv(struct nvme_tcp_queue *queue)
 	lock_sock(sk);
 	queue->nr_cqe = 0;
 	consumed = sock->ops->read_sock(sk, &rd_desc, nvme_tcp_recv_skb);
+	/*
+	 * nvme_tcp_recv_skb() handles its own errors, so a queue that is
+	 * still enabled failed inside read_sock(). Handle it before
+	 * release_sock() processes the backlog.
+	 */
+	if (unlikely(consumed < 0 && consumed != -EAGAIN &&
+		     queue->rd_enabled)) {
+		dev_err(queue->ctrl->ctrl.device,
+			"queue %d: receive failed: %d\n",
+			nvme_tcp_queue_id(queue), consumed);
+		queue->rd_enabled = false;
+		nvme_tcp_error_recovery(&queue->ctrl->ctrl);
+	}
 	release_sock(sk);
 	return consumed == -EAGAIN ? 0 : consumed;
 }
-- 
2.53.0



