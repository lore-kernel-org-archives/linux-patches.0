Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A863A27703A;
	Tue,  8 Apr 2025 12:52:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744116763; cv=none; b=tg6T1zetuZ2SNjM5aPWAC3EVmXXs5Y9OFSj0ty64rCymNxDw8JE60iraIVl+M5UgLSpjbZdDYLHjFL6QfhPTBaqHBlhyDL/T3/vd+3MdudUm010Vo6EAOy7Fzao15fnIWSRXhl7udo/b162CbLPpMByxyXiIV72SGr26pDkhWaA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744116763; c=relaxed/simple;
	bh=s/mgmr3LzYQy9rKt7d859Rr/jzUXGSmkthAU/tBFmZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hHrFkOhNinzSnBTkuNC9hddrh5vB6xaP6sbMhLhe87laHDSE+G2zdKi2btzAAt7svSEOZR7adDjRYSLlN3icrIg9KO3nX+E6uDq69Ig4+k0F3Rxv6BGi0vXg3dBqNshLt8onWF7pyPIDfRB0xE+ivoLcCgV8vy1SYFcntpEVwFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=on/zaPxw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="on/zaPxw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34528C4CEE5;
	Tue,  8 Apr 2025 12:52:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744116763;
	bh=s/mgmr3LzYQy9rKt7d859Rr/jzUXGSmkthAU/tBFmZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=on/zaPxwqV5atgqcs8J5nhZbHtfC68nYYxdJQtH0WRtGJHXOteXOZ3uaDli9E55yv
	 MZWwu24pwHg2iCrnTr3mDGVTP0J/hu5XX+0qHllCKzr+sS8Ndbu/CjBmYFQH7k1MGW
	 8AV7ovg39z2K6MAlJ0zmxYsBoZnnnb/tYp5sSFk8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhang Guanghui <zhang.guanghui@cestc.cn>,
	Sagi Grimberg <sagi@grimberg.me>,
	Chaitanya Kulkarni <kch@nvidia.com>,
	Keith Busch <kbusch@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 258/423] nvme-tcp: fix possible UAF in nvme_tcp_poll
Date: Tue,  8 Apr 2025 12:49:44 +0200
Message-ID: <20250408104851.753989837@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250408104845.675475678@linuxfoundation.org>
References: <20250408104845.675475678@linuxfoundation.org>
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
index eeb05b7bc0fd0..854aa6a070ca8 100644
--- a/drivers/nvme/host/tcp.c
+++ b/drivers/nvme/host/tcp.c
@@ -2736,6 +2736,7 @@ static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
 {
 	struct nvme_tcp_queue *queue = hctx->driver_data;
 	struct sock *sk = queue->sock->sk;
+	int ret;
 
 	if (!test_bit(NVME_TCP_Q_LIVE, &queue->flags))
 		return 0;
@@ -2743,9 +2744,9 @@ static int nvme_tcp_poll(struct blk_mq_hw_ctx *hctx, struct io_comp_batch *iob)
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



