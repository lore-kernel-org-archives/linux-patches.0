Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADD96569D
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:33:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 16367C433D2;
	Sun, 28 May 2023 19:32:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685302380;
	bh=p/1qBNSjHhVQDzfbR+YBDXcVD80c/BNa3Oh5NZ0Pr2s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x+/YBcLerDOITx/8OksF9OFNxiE6bSvrbrqSvCguMcqe5LD1oW9+1DGBFe77P2euZ
	 4Fd6aZS16tCXPhWxPvXzcgSTkqpo1ZGZauhfkxKVvZGyI3XEuJN9dxYLZrSczvn4ZK
	 dexUiUWqNmAJBNOiankEe/WvQ3EgwDr1KA3HgkOg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Simon Horman <simon.horman@corigine.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 6.3 111/127] net/mlx5e: do as little as possible in napi poll when budget is 0
Date: Sun, 28 May 2023 20:11:27 +0100
Message-Id: <20230528190839.871037946@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190836.161231414@linuxfoundation.org>
References: <20230528190836.161231414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

commit afbed3f74830163f9559579dee382cac3cff82da upstream.

NAPI gets called with budget of 0 from netpoll, which has interrupts
disabled. We should try to free some space on Tx rings and nothing
else.

Specifically do not try to handle XDP TX or try to refill Rx buffers -
we can't use the page pool from IRQ context. Don't check if IRQs moved,
either, that makes no sense in netpoll. Netpoll calls _all_ the rings
from whatever CPU it happens to be invoked on.

In general do as little as possible, the work quickly adds up when
there's tens of rings to poll.

The immediate stack trace I was seeing is:

    __do_softirq+0xd1/0x2c0
    __local_bh_enable_ip+0xc7/0x120
    </IRQ>
    <TASK>
    page_pool_put_defragged_page+0x267/0x320
    mlx5e_free_xdpsq_desc+0x99/0xd0
    mlx5e_poll_xdpsq_cq+0x138/0x3b0
    mlx5e_napi_poll+0xc3/0x8b0
    netpoll_poll_dev+0xce/0x150

AFAIU page pool takes a BH lock, releases it and since BH is now
enabled tries to run softirqs.

Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Fixes: 60bbf7eeef10 ("mlx5: use page_pool for xdp_return_frame call")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Simon Horman <simon.horman@corigine.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c |   16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_txrx.c
@@ -161,20 +161,22 @@ int mlx5e_napi_poll(struct napi_struct *
 		}
 	}
 
+	/* budget=0 means we may be in IRQ context, do as little as possible */
+	if (unlikely(!budget))
+		goto out;
+
 	busy |= mlx5e_poll_xdpsq_cq(&c->xdpsq.cq);
 
 	if (c->xdp)
 		busy |= mlx5e_poll_xdpsq_cq(&c->rq_xdpsq.cq);
 
-	if (likely(budget)) { /* budget=0 means: don't poll rx rings */
-		if (xsk_open)
-			work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
+	if (xsk_open)
+		work_done = mlx5e_poll_rx_cq(&xskrq->cq, budget);
 
-		if (likely(budget - work_done))
-			work_done += mlx5e_poll_rx_cq(&rq->cq, budget - work_done);
+	if (likely(budget - work_done))
+		work_done += mlx5e_poll_rx_cq(&rq->cq, budget - work_done);
 
-		busy |= work_done == budget;
-	}
+	busy |= work_done == budget;
 
 	mlx5e_poll_ico_cq(&c->icosq.cq);
 	if (mlx5e_poll_ico_cq(&c->async_icosq.cq))


