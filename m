Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795705221;
	b=yV0sUsM0IiNhNX8GeiMQG001/upCzETtpyzPk4IScoV15vKxEUq7alA3B3GvOPWcYuT9
	 MJ5woMu6E50qEjBmZFscUWAKEV3twBbal646URph0gOE/BBlQmE3AIpvEMRU5GSW2027s
	 YOF5HsdOvZR834+u8DyFaz66Ql33HPDZzPQTSMUAZlrmMgzR1omrjQHHjr/LmhdM7vUp4
	 yeDBiOkS4PNkEb1ZB51rnyhtkfgAt5nLawSix5uW9W7oE+F3fXhS+72nmrfnO1s2jykkW
	 uc3rbY8qN0PgJSqw9bcb9aYwj1yKbo2QetgcES1vxZrzZQPNAlXj3Mvaf21ZdnXipfg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795705221;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=8Xl4ScA9xdIdOGEwzFcTWhxP9Xrl9GSc9z5su6REsrM=;
	b=b/jt0NNaEYrTSx8KnCnAgfhOrnTq+bSl9pGBPYqjVkaTTs5omzuaPw7l9QgAwHcf0V5g
	 aQY6ZJH5xi/A2HrNff3FvX0yjj9QN5mnlTy/Y+nlZN+3gajnpkk8AkOEGgsCgO10qYgvL
	 Jf92hIRh1Kun85ttGXH2j/7R3T8c6/3sJkpyOncMGj2p0kmtyBAATjtsv56RSf5co/4kJ
	 NrryRAxVfVtnZnylpI1eb7HaH4dJeEBYFkncBCjAf1FrunYi067XOuNlmok8OnuyVtNrk
	 XQnc+ZQ2+qmDZ4qyvhiQhO2orHekVl+K5Dk6Q7FJWD9v52u+8hUR7yOnkO0pxnPgogQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbOddBbt;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B7F6B606A333;
	Thu, 26 Nov 2026 15:00:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=RbOddBbt
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 297831F000CA;
	Thu, 26 Nov 2026 15:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795705221;
	bh=8Xl4ScA9xdIdOGEwzFcTWhxP9Xrl9GSc9z5su6REsrM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RbOddBbt5dyKP+IDrAmfVY45tIn62d3IOpQOPklPReGXN3WSWSG9cVj2i0ShCYSIb
	 +WA9/mGhVVi4n7VHqVUxbW8fbEvKBC4tCPYJBCtYBVYZGR0RrVJwPBl7VBCqMt2ys+
	 EnynzviVWoR+veoL7Zie3Tj+4cbz+RGUWpQmh7W0=
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
Subject: [PATCH 5.15 080/319] nvmet-tcp: limit the connections accepted per work run
Date: Thu, 26 Nov 2026 15:37:28 +0100
Message-ID: <20261126144008.547269576@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261126144006.732901931@linuxfoundation.org>
References: <20261126144006.732901931@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 76f9dae1086fe..deb2b31a01b07 100644
--- a/drivers/nvme/target/tcp.c
+++ b/drivers/nvme/target/tcp.c
@@ -43,6 +43,7 @@ MODULE_PARM_DESC(idle_poll_period_usecs,
 #define NVMET_TCP_RECV_BUDGET		8
 #define NVMET_TCP_SEND_BUDGET		8
 #define NVMET_TCP_IO_WORK_BUDGET	64
+#define NVMET_TCP_ACCEPT_BUDGET		16
 
 enum nvmet_tcp_send_state {
 	NVMET_TCP_SEND_DATA_PDU,
@@ -1733,9 +1734,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
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
@@ -1748,6 +1749,9 @@ static void nvmet_tcp_accept_work(struct work_struct *w)
 			sock_release(newsock);
 		}
 	}
+
+	/* There may be more. Come to an end for those who flush nvmet_wq. */
+	queue_work(nvmet_wq, &port->accept_work);
 }
 
 static void nvmet_tcp_listen_data_ready(struct sock *sk)
-- 
2.53.0



