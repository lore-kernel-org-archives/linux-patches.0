Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1794063739;
	b=378oe+XEP66pW+/uM07KR0D5WYOmZM0rTmufZFo4QJYR7BcCe3WwJCIrXXbKYntOy4gJ
	 ECbLs02w18zsW8OQolQE226lciDa4/zD00rdw1kQGad1pf7b+gNd1Bmyxodxop1G6mAAf
	 ZCLIUOZ4VyhbhoNEBmehvuRH062WsMfYMmRpaGgS9uTidW/NgHXWtEj4YBYzWKg8vz7Vk
	 zsPkIEsOTknFkOAp0JewI8mxIJcdvrGud/Ia1O466eLrSmKS+h3OvYKvr22MLh3NKqdV7
	 z0ju6lfW6x/eKGSyXWT9Q0iAbKPWNR7qE1DHIyL+vLZlzrrxhLdO9kih5xvvVxFKTzQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1794063739;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=cMNO8lAMnlJDXxnLwV5DJZTAsJgMLv5FhgJwR2hk6/4=;
	b=sA3NqYx6oqc4AMz29+AnAJis/j+MU45OIHcYWn/6bLNgfZPckFj8v6uxtP4X2KJnbRlm
	 QuqBVefrUb/Gr/qHB8+6V/9Ezuwfl3m021foFcSkv3QUCCqg6Opneb1gui1PIfEWbPYKX
	 F0228LF5R3FrxIQ8rJ97nnZ0TP87Oz3kWmiAxfpbzH98tL91BBG0h7q5Y/XAcUV1KShZ0
	 69HmE/XJr+BL+wXWFeJi89U+wkm+RGDK5GsaF589pfLDzaGtRwB0qXY2sNJEAflDeP6Pq
	 yI9rJIalrsg901PEbLCWSFweh5ifB/Koodir5JCgIi6l2pEMj54AvAwhSRQFh7c6oVg==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOGKsye5;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 35080606A32D;
	Sat,  7 Nov 2026 15:02:19 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=cOGKsye5
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D83571F0089F;
	Sat,  7 Nov 2026 15:02:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1794063739;
	bh=cMNO8lAMnlJDXxnLwV5DJZTAsJgMLv5FhgJwR2hk6/4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=cOGKsye58RQRblRrx8raz/dWXMAJz9al2By1krGK3VUmqJBMz9yfE6d7hSwbbvScV
	 TvbeqKZ0EEQSlovA6SFrB9O+ltsRRhbakkB9REgDZ2QZzvFg5WXBv3qZJ0DuFhK0OH
	 lBIarqT3TSc76B3FxHIjqA0VWXg9lCA7w/6vqu4c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hannes Reinecke <hare@kernel.org>,
	Christoph Hellwig <hch@lst.de>,
	Martin Belanger <martin.belanger@dell.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 834/869] nvme-tcp: start error recovery when read_sock fails
Date: Sat,  7 Nov 2026 08:58:36 -0500
Message-ID: <20261107134921.182761247@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261107134852.069646174@linuxfoundation.org>
References: <20261107134852.069646174@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index b7e4624f1dcd8..5d7581a1dc41d 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -1425,6 +1425,19 @@ static int nvme_tcp_try_recv(struct nvme_tcp_queue *queue)
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



