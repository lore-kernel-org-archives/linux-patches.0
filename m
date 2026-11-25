Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795624447;
	b=wmwy3YxwLDHUEBVN01YHvNxfzGUNuf5f/RpoR/hAJ7BGO1qJU6JEJiiOmtr/sZCZLI4T
	 WXvMUO97v6PkvOTFpoE+9X1xa3oMB+kStT2wJuiVFdQQfNAPaasTuKUX2iuQVbTuVgM0O
	 52OSzlIzYKp16MuWQAyNl7crm4ue061i5d252FlaQGH4oJgqGZ2InH/KMUDEgWJ6Brqh3
	 vZjEIEOz4b4NFgAxYpWkAOE7QwBc88ezDkW3T3x9g7Z6RAJF6NczUH/P1Xx0d95mYiqtZ
	 CGKC3Yp4cMHO1wsQjQbJDUJN1x/JXllvikDyqNjVctbdgCfmpyx+zmT64uF4DqovGCw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795624447;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YG7y9UEK4H7rx+lULpCQlCwAlKFQfh4Or08CMkOC77I=;
	b=TdirauxmxcvyMCjXzKgq8YeJZAx5s/GsuDRx6PuITUHBgMzPZN8rmzzvhwBspMLxIkid
	 9ZrUZBPZMxBBSENh02Qq6jPTnVAvT+HKl0myb7rMV/sptpi7p616yFGZXsmz3dZvmjykF
	 K/XAHMgK1NJLG4XMqmMhtYmDxhS7lsfhwCreMXq70M9TgXaME4fT7Yp1SMYkVpT9bW1xG
	 ZfQfzR6gSZHvYAhCjVsq6qD89he0XE9zxB11bamYkUnww6PZHUv3q8HHL3TjaHKwbcufn
	 XHeOBl6+Z/CdrF+JLlM8gPUL3zY8McchR5sZ6VtfuqZe/d92mDFR81G1ooj6gzuG8ew==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsUhZbsD;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 642FD606A33C;
	Wed, 25 Nov 2026 16:34:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=KsUhZbsD
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7AC581F000C4;
	Wed, 25 Nov 2026 16:34:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795624447;
	bh=YG7y9UEK4H7rx+lULpCQlCwAlKFQfh4Or08CMkOC77I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=KsUhZbsDW3vvbeectWniBIS3J7mkIlZpVE5WpTjNDmqM4SYQ0LsbjbGGB02BdM26H
	 32feW63MWx3QeeEuuE9bBgPgPb7qnTeTagBwysjPZvxFs9aacL7Ck8cxXIHTSmFFDT
	 ikLy+j0kBV1tvxmCiAbBvnNFD8FB9dLecWEKkdlk=
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
Subject: [PATCH 6.12 195/816] nvmet-tcp: limit the connections accepted per work run
Date: Wed, 25 Nov 2026 15:29:03 +0100
Message-ID: <20261125143853.707920942@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index d61b1efbddfa0..ab74d36438888 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -86,6 +86,7 @@ MODULE_PARM_DESC(tls_handshake_timeout,
 #define NVMET_TCP_RECV_BUDGET		8
 #define NVMET_TCP_SEND_BUDGET		8
 #define NVMET_TCP_IO_WORK_BUDGET	64
+#define NVMET_TCP_ACCEPT_BUDGET		16
 
 enum nvmet_tcp_send_state {
 	NVMET_TCP_SEND_DATA_PDU,
@@ -2090,9 +2091,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
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
@@ -2101,6 +2102,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
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



