Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8DABC3E764C;
	Mon, 17 Aug 2026 13:41:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974108; cv=none; b=Rm8rqjeJQI4f9Vc9rhhtDxLmsLYoZt6fTaPqO9BI4oSlT6wRkkb+mhGYYyJBSGlOhD95Y29MhfxB0SmsS+yF5jUVl2tze3jB6xV3Y3gaocKj6A84NcEO+b7NU6XtuGRUVbqcxLnqwSXs5YkAxFmB5qE8PF6bNr23Ed6QvSanfmU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974108; c=relaxed/simple;
	bh=vXMfB/kDDSozkoYw4PO78aReeduAANVCwbz4h11Xvqo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ozfHhW3yYweq0g6uYnJhpzcqjLw71qoJu/6qtWYsFzkrV3QI5Wih6XR9IIYItF9CQmwGx0tXTfTQQUPusRnhlS3TUv3ItrG1gwQCZrGduogEZV9BRZGM5E0CmVY5dGkVklwmbqA0G00s7ZJ5foG6KI9JeO+4s2l0iHjZhSRD/vg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kXXZyVnn; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kXXZyVnn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D4A4A1F00A3A;
	Mon, 17 Aug 2026 13:41:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974106;
	bh=lQfXGc6HX6vkLamGFAKWM2g3VKHc80ehOINs57O7FYc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=kXXZyVnnB8d5Hg5lMOYXsm8+ggG5e+Fu95ow5IAi+ggqlwZgTd1whZvNormMZoqKa
	 wwzOV7mCChj8HjKLfzyRDi9sD9oC/Mx+hYnQ8mPVfOIn2i9hu9ReIrmOd6xagxc4lT
	 yLqrCaxWTRNU36RYpzaczhiRCA/Ewf0IKNGHG2xg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Bobby Eshleman <bobbyeshleman@meta.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 092/271] net/mlx5e: fix BQL reset on SQ re-activation
Date: Mon, 17 Aug 2026 15:30:17 +0200
Message-ID: <20260817132540.555667993@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Bobby Eshleman <bobbyeshleman@meta.com>

[ Upstream commit e7386770be1bf810bcd6af39d1e4bfeab3408430 ]

mlx5e_queue_start() deactivates and re-activates all channels but closes
only the queue being restarted. mlx5e_activate_txqsq() then
unconditionally calls netdev_tx_reset_queue(), zeroing the BQL counters
of channels that kept their in-flight TX WQEs. The next completion then
over-charges and trips the BUG_ON() in dql_completed():

  kernel BUG at lib/dynamic_queue_limits.c:99!
  RIP: 0010:dql_completed+0x23d/0x280
  Call Trace:
   <IRQ>
   mlx5e_poll_tx_cq+0x668/0xa60
   mlx5e_napi_poll+0x5b/0x7b0
   net_rx_action+0x15a/0x580

Reset BQL only when the SQ has no bytes in flight (sq->cc == sq->pc).

In the case that reset is skipped, the outstanding WQEs will eventually
complete and rebalance the dql. The dql->limit is carried across the
reset.

Fixes: b2588ea40ec9 ("net/mlx5e: Implement queue mgmt ops and single channel swap")
Signed-off-by: Bobby Eshleman <bobbyeshleman@meta.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260803-mlx5-bql-v3-1-a30d4c66fe1d@meta.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
index 7d1063c7bf649..22ae49af38cd7 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -1939,8 +1939,10 @@ int mlx5e_open_txqsq(struct mlx5e_channel *c, u32 tisn, int txq_ix,
 void mlx5e_activate_txqsq(struct mlx5e_txqsq *sq)
 {
 	sq->txq = netdev_get_tx_queue(sq->netdev, sq->txq_ix);
+	/* Reset BQL only when the SQ has no bytes in flight. */
+	if (sq->cc == sq->pc)
+		netdev_tx_reset_queue(sq->txq);
 	set_bit(MLX5E_SQ_STATE_ENABLED, &sq->state);
-	netdev_tx_reset_queue(sq->txq);
 	netif_tx_start_queue(sq->txq);
 	netif_queue_set_napi(sq->netdev, sq->txq_ix, NETDEV_QUEUE_TYPE_TX, sq->cq.napi);
 }
-- 
2.53.0



