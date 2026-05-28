Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 698A0330B2D;
	Thu, 28 May 2026 19:54:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779998100; cv=none; b=TqaKdW+QHwGG+Fc/PP8XSOLaPOe0dYnWJDR8MLn3T9pGtoNghCTpbSPv2IoZpDXXJT7nxdyNy4TqybtuE8QhcPzLnWwXZlJafU/mJ3IWAx1ZfR67MAL+9bfN7r9nFBy5zWIn51Xa6JLcEk/WY7iP3YCSeGWQin4/AlMI/nNlWAg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779998100; c=relaxed/simple;
	bh=0I4iVRX6adQ5Wf+kL+4tXOPTjTWvmO7zWVT2UesB0y4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rGw2Z8Tv7w1sRf7BFyJHl2itIi2l4GicMMX3E0iy7g5yOESWLzSEzz5QOf7xW1zi+oPWXxwYi6ue26a9vbZ+uW6vg9G086R2UI4fkRA6Rr9+UGnHP06FBsudRLnPtVhUp35n9MufhaScoDD5Gt36Twbbw4lKE1NLw5JwlXkOMmk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=nRXQSrdA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="nRXQSrdA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8A151F000E9;
	Thu, 28 May 2026 19:54:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779998099;
	bh=KizvarwQ2dDNtU4VlFlmIejhKI/XjYEuH2FKJby9Hi8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nRXQSrdA0uXyu3M/tOYQAQhWSVSB8I3mqDTtC/A8Byawg5I7P6zWV6jxpS80FLxwW
	 VSK65sRTRrPs1h+qHpW3fWM6xSKJUp764v/yiGwy/Tte0CTQZwnLIPpEbJm+sfgCiU
	 OzVSBlL1O3cjMxYE+SdcX9z+HOh26KHRSGsH4Q8Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.0 054/461] net/mlx5e: Fix use-after-free in mlx5e_tx_reporter_timeout_recover
Date: Thu, 28 May 2026 21:43:03 +0200
Message-ID: <20260528194648.471847742@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194646.819809818@linuxfoundation.org>
References: <20260528194646.819809818@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Fleming <mfleming@cloudflare.com>

commit 7d260c5d2d89eb2c8c528d54b576b3aae3e20231 upstream.

mlx5e_tx_reporter_timeout_recover() accesses sq->netdev after
mlx5e_safe_reopen_channels() has torn down and freed the channel (and
its embedded SQs). Replace the three sq->netdev references with
priv->netdev which is safe because priv outlives channel teardown.

The netdev_err() call already used priv->netdev for this reason; make
the trylock/unlock and health_channel_eq_recover calls consistent.

This fixes the following KASAN splat:

  BUG: KASAN: use-after-free in mlx5e_tx_reporter_timeout_recover+0x1dd/0x360 [mlx5_core]
  Read of size 8 at addr ffff889860ed0b28 by task kworker/u113:2/5277

  Call Trace:
   mlx5e_tx_reporter_timeout_recover+0x1dd/0x360 [mlx5_core]
   devlink_health_reporter_recover+0xa2/0x150
   devlink_health_report+0x254/0x7c0
   mlx5e_reporter_tx_timeout+0x297/0x380 [mlx5_core]
   mlx5e_tx_timeout_work+0x109/0x170 [mlx5_core]
   process_one_work+0x677/0xf20
   worker_thread+0x51f/0xd90
   kthread+0x3a5/0x810
   ret_from_fork+0x208/0x400
   ret_from_fork_asm+0x1a/0x30

Fixes: 83ac0304a2d7 ("net/mlx5e: Fix deadlocks between devlink and netdev instance locks")
Cc: stable@vger.kernel.org
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Matt Fleming <mfleming@cloudflare.com>
Link: https://patch.msgid.link/20260513112226.140512-1-matt@readmodwrite.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/reporter_tx.c
@@ -160,13 +160,13 @@ static int mlx5e_tx_reporter_timeout_rec
 	 * channels are being closed for other reason and this work is not
 	 * relevant anymore.
 	 */
-	while (!netdev_trylock(sq->netdev)) {
+	while (!netdev_trylock(priv->netdev)) {
 		if (!test_bit(MLX5E_STATE_CHANNELS_ACTIVE, &priv->state))
 			return 0;
 		msleep(20);
 	}
 
-	err = mlx5e_health_channel_eq_recover(sq->netdev, eq, sq->cq.ch_stats);
+	err = mlx5e_health_channel_eq_recover(priv->netdev, eq, sq->cq.ch_stats);
 	if (!err) {
 		to_ctx->status = 0; /* this sq recovered */
 		goto out;
@@ -186,7 +186,7 @@ static int mlx5e_tx_reporter_timeout_rec
 		   "mlx5e_safe_reopen_channels failed recovering from a tx_timeout, err(%d).\n",
 		   err);
 out:
-	netdev_unlock(sq->netdev);
+	netdev_unlock(priv->netdev);
 	return err;
 }
 


