Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795621487;
	b=AiwCLktaQKzii+FPuX7Sqer6ayVqy6AfFj4uE7vd1j4Kk9gk9eT7q/9KzO3//8I+QApk
	 YsH21o00po8jRwZSEP4d7+VVp6iUY0BavLVCRkLf3P6DCgafXmoOI53kNNeT7Ca9tCpPK
	 VrqcfR+sDkGDR3T5rhnbIHVQb/xTAvW7VFFJL8pnP6CI95tcoQEstkqnrAN9Um3JTt/ne
	 A5zVFL8hv5qUQJAB7tLVa1U7wR/r9kT4y+c4IW4Ux/KKJDz01AQmyFI34z3zD1HFPgztf
	 IE+mP94OpN0PStaXTdJY9tH1Yvf+5WevOwPiUqBtn8gUjcc98geteRZwIHWLHJ+3c3Q==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795621487;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=n8ht9PxHXHx+MH7/MJnY/OcIHakahI0+VhpYjTuJ/Ic=;
	b=iucV+9FRUHUtlDTGpknSsLgB3cjP52Iofvq9HOVa3hX9aEgjvfOd20YYly6P2LAgS+ES
	 pohRYPtGuuyYFufx/lY+Ozm85erOa1iLgPV625xjPb+M9Z4jLzup9YMPGdNqBKPxRvycd
	 hPdUR2Cf/TFZWCmaOXEKUFlwV3h//Ff1pS4y9PfcVT0lXg0AG80ZH+tzhM9JOG0/yQ5ln
	 8n1SNLC5m4wG/e1E7m3swRcGyep+XLJkLbzCY1J+aNUOGTCMtUsOEiLPt1odAh8osp6ix
	 iT7AhkciTmkS64FbUPwuNC55R1BA7xxIM8gEuY+1Z6UFUOaFAc4qdkqxPqkD3Fmgf2Q==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAyqRFx0;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01C57606A321;
	Wed, 25 Nov 2026 15:44:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=qAyqRFx0
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B4F661F000C0;
	Wed, 25 Nov 2026 15:44:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795621486;
	bh=n8ht9PxHXHx+MH7/MJnY/OcIHakahI0+VhpYjTuJ/Ic=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qAyqRFx0ra8JvdHNUayZsYbNxBk9+4aQGLFpIYkThoVEXKAZvWaeH6RDksfIouby5
	 xYl6MNZzDjdBhJLRmVCJNAf88EJLUMA4ANXPGK+NWhlGpW+TYvcdtyVhISkFLBpV6f
	 +AwxHUoNqLtqvauDt/2nwHyPSIfbnTEW0ntjBx9c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Christoph Hellwig <hch@lst.de>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Hannes Reinecke <hare@kernel.org>,
	Josef Bacik <josef@toxicpanda.com>,
	Jens Axboe <axboe@kernel.dk>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 239/990] nvmet-tcp: limit the connections accepted per work run
Date: Wed, 25 Nov 2026 15:26:46 +0100
Message-ID: <20261125143827.687513355@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143822.072087159@linuxfoundation.org>
References: <20261125143822.072087159@linuxfoundation.org>
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

From: Josef Bacik <josef@toxicpanda.com>

[ Upstream commit a029f1b2fb13e6ac6e1c2f27fba1d80b6e7cac51 ]

nvmet_tcp_accept_work() loops until there's nothing left to accept, and
anyone opening and closing connections fast enough keeps it running
indefinitely, since tearing down a dead connection takes long enough for
more to arrive. Whoever flushes nvmet_wq waits for it: removing any
other port of the target does in nvmet_port_release(), and so does
unloading the rdma and fc modules.

Accept a bounded number of connections per run and requeue the work. A
flush doesn't wait for work queued behind it.

Fixes: 872d26a391da ("nvmet-tcp: add NVMe over TCP target driver")
Cc: Christoph Hellwig <hch@lst.de>
Cc: Sagi Grimberg <sagi@grimberg.me>
Cc: Chaitanya Kulkarni <kch@nvidia.com>
Reviewed-by: Hannes Reinecke <hare@kernel.org>
Reviewed-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Josef Bacik <josef@toxicpanda.com>
Signed-off-by: Jens Axboe <axboe@kernel.dk>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/target/tcp.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/target/tcp.c b/drivers/nvme/target/tcp.c
index c059a671a1d59..72e928c38aa2a 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -102,6 +102,7 @@ MODULE_PARM_DESC(tls_handshake_timeout,
 #define NVMET_TCP_RECV_BUDGET		8
 #define NVMET_TCP_SEND_BUDGET		8
 #define NVMET_TCP_IO_WORK_BUDGET	64
+#define NVMET_TCP_ACCEPT_BUDGET		16
 
 enum nvmet_tcp_send_state {
 	NVMET_TCP_SEND_DATA_PDU,
@@ -2095,9 +2096,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 	struct nvmet_tcp_port *port =
 		container_of(w, struct nvmet_tcp_port, accept_work);
 	struct socket *newsock;
-	int ret;
+	int ret, i;
 
-	while (true) {
+	for (i = 0; i < NVMET_TCP_ACCEPT_BUDGET; i++) {
 		ret = kernel_accept(port->sock, &newsock, O_NONBLOCK);
 		if (ret < 0) {
 			if (ret != -EAGAIN)
@@ -2106,6 +2107,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 		}
 		nvmet_tcp_alloc_queue(port, newsock);
 	}
+
+	/* There may be more. Come to an end for those who flush nvmet_wq. */
+	queue_work(nvmet_wq, &port->accept_work);
 }
 
 static void nvmet_tcp_listen_data_ready(struct sock *sk)
-- 
2.53.0



