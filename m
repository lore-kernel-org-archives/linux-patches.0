Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92CE726461E;
	Tue,  8 Apr 2025 12:37:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744115848; cv=none; b=u5d6RkFmeAnwJOrBmsuwyVeH5qJYArDKbr9E1U5Os2SjrLHs0SHlip9wod6VKSYCZJurBE5YAZ0BclkXGby74LZVcTg9Ak9VlRCwkg/QdObEsu+Gk/v5AokfNt3zeKkEYrt8RpEzW2wjkgdwYloXACs3DmFDkP4p7+OAEROB2q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744115848; c=relaxed/simple;
	bh=km8jtQ/IUHZ2RmfrFr052cR+MCvsI6sJQOc0+GW46J4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IMG3RpEaClMsqwt/fLCk1hL+MzrtS2h0xHm73KaJmo7s5kPcowmuAlFyFewJIlvRLzaLbf5LNDXCPcKjsxbSBWxJHWZ9eA+9SwU0TNQrM4o2BWpVrZe7Pn9A4P1+dy6D3PafkNP/N0KF235ZhH/fIB0vKZavqKI49oXj6Jn7Hck=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=QZSjvssX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="QZSjvssX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B6CCDC4CEE5;
	Tue,  8 Apr 2025 12:37:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744115848;
	bh=km8jtQ/IUHZ2RmfrFr052cR+MCvsI6sJQOc0+GW46J4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QZSjvssX4l1uu9jES51ghD+GwDjufGgzIspKLm+RUGb58pEXO69oohdydpb/2YrF+
	 UdZ7MFJMZCLcCMTe9m24F/1a+FDk+CXdymxr0xvPM4YlJxJANeInJZMpvlcE91ihLu
	 3efPRtXqBM7yaBtYh3jrPBw9Eo3GbJN6V0JTM+us=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Guanghui <zhang.guanghui@cestc.cn>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 128/204] nvme-tcp: fix possible UAF in nvme_tcp_poll
Date: Tue,  8 Apr 2025 12:50:58 +0200
Message-ID: <20250408104824.059352112@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104820.266892317@linuxfoundation.org>
References: <20250408104820.266892317@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sagi Grimberg <sagi@grimberg.me>

[ Upstream commit 8c1624b63a7d24142a2bbc3a5ee7e95f004ea36e ]

nvme_tcp_poll() may race with the send path error handler because
it may complete the request while it is actively being polled for
completion, resulting in a UAF panic [1]:

We should make sure to stop polling when we see an error when
trying to read from the socket. Hence make sure to propagate the
error so that the block layer breaks the polling cycle.

[1]:
--
[35665.692310] nvme nvme2: failed to send request -13
[35665.702265] nvme nvme2: unsupported pdu type (3)
[35665.702272] BUG: kernel NULL pointer dereference, address: 0000000000000000
[35665.702542] nvme nvme2: queue 1 receive failed:  -22
[35665.703209] #PF: supervisor write access in kernel mode
[35665.703213] #PF: error_code(0x0002) - not-present page
[35665.703214] PGD 8000003801cce067 P4D 8000003801cce067 PUD 37e6f79067 PMD 0
[35665.703220] Oops: 0002 [#1] SMP PTI
[35665.703658] nvme nvme2: starting error recovery
[35665.705809] Hardware name: Inspur aaabbb/YZMB-00882-104, BIOS 4.1.26 09/22/2022
[35665.705812] Workqueue: kblockd blk_mq_requeue_work
[35665.709172] RIP: 0010:_raw_spin_lock+0xc/0x30
[35665.715788] Call Trace:
[35665.716201]  <TASK>
[35665.716613]  ? show_trace_log_lvl+0x1c1/0x2d9
[35665.717049]  ? show_trace_log_lvl+0x1c1/0x2d9
[35665.717457]  ? blk_mq_request_bypass_insert+0x2c/0xb0
[35665.717950]  ? __die_body.cold+0x8/0xd
[35665.718361]  ? page_fault_oops+0xac/0x140
[35665.718749]  ? blk_mq_start_request+0x30/0xf0
[35665.719144]  ? nvme_tcp_queue_rq+0xc7/0x170 [nvme_tcp]
[35665.719547]  ? exc_page_fault+0x62/0x130
[35665.719938]  ? asm_exc_page_fault+0x22/0x30
[35665.720333]  ? _raw_spin_lock+0xc/0x30
[35665.720723]  blk_mq_request_bypass_insert+0x2c/0xb0
[35665.721101]  blk_mq_requeue_work+0xa5/0x180
[35665.721451]  process_one_work+0x1e8/0x390
[35665.721809]  worker_thread+0x53/0x3d0
[35665.722159]  ? process_one_work+0x390/0x390
[35665.722501]  kthread+0x124/0x150
[35665.722849]  ? set_kthread_struct+0x50/0x50
[35665.723182]  ret_from_fork+0x1f/0x30

Reported-by: Zhang Guanghui <zhang.guanghui@cestc.cn>
Signed-off-by: Sagi Grimberg <sagi@grimberg.me>
Reviewed-by: Chaitanya Kulkarni <kch@nvidia.com>
Signed-off-by: Keith Busch <kbusch@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/nvme/host/tcp.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/nvme/host/tcp.c b/drivers/nvme/host/tcp.c
index da9d510d3d4f1..6dd19322c7f8e 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2518,6 +2518,7 @@ static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 {
 	struct nvme_tcp_queue *queue = hctx->driver_data;
 	struct sock *sk = queue->sock->sk;
+	int ret;
 
 	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
 		return 0;
@@ -2525,9 +2526,9 @@ static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 	set_bit(NVME_TCP_Q_POLLING, &queue->flags);
 	if (sk_can_busy_loop(sk) && skb_queue_empty_lockless(&sk->sk_receive_queue))
 		sk_busy_loop(sk, true);
-	nvme_tcp_try_recv(queue);
+	ret = nvme_tcp_try_recv(queue);
 	clear_bit(NVME_TCP_Q_POLLING, &queue->flags);
-	return queue->nr_cqe;
+	return ret < 0 ? ret : queue->nr_cqe;
 }
 
 static int nvme_tcp_get_address(struct nvme_ctrl *ctrl, char *buf, int size)
-- 
2.39.5



