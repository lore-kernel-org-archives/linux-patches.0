Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5372580D7;
	Thu, 28 May 2026 20:17:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779999426; cv=none; b=maT9jwVu58aM3wamkxsPItc85Ap5tNWnloHAY/GSmcouBEcsO+aWjEHqwS90M5C2D5IZQTkm2Ui+jwJiw8Z0uFQHtaTiUHbu2z2OFp3Ubkt8s+ZsQtkvxGL7FlyMywKsJnOHmhx9BKZCwA/wnEUhPSkFDXwcdI9H0cXL4GeAz74=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779999426; c=relaxed/simple;
	bh=qdoQ8ADjy0T062E3NK1+DR1sVwtZ2uVaWLdOHlI/pzI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=E3bWgcD1DZPqc4QvjXQ/qP8Qsr68Ocg1HKi0q+jvVoRuPDa+jDXMpsk3u/WPe/zECFuvlKgvFG8NSdl8xSMbML2JtH6VW84u3ktEIoYY5d7TL6IvlECMaXtoT95tcR/W65Egf9uoE23BHKrC5pPoWFsxtoGc1x9p6XhYCSospDk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=I9QWnCoM; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="I9QWnCoM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 558831F000E9;
	Thu, 28 May 2026 20:17:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779999424;
	bh=OdzgbvpG+BCWCDzIo1qokojNeqHzsyWUOTCK/gr5tOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=I9QWnCoMAriHsOKGus10bY9xvwpgBvGyyAmllMRVFZWoUn7j6gDS9ycf6K3Onm3RX
	 JOHWqt5SrCs+rNNT6mGCUleRBD6Vbx4hJQbG8QQ7mhFEgrZbs70AZ/PUDAXo6oj1h5
	 r8BM4zvpsTdHqbW1VZMj8zx3JpLFO0k6JqkUtiH0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Matt Fleming <mfleming@cloudflare.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 062/377] net/mlx5e: Fix use-after-free in mlx5e_tx_reporter_timeout_recover
Date: Thu, 28 May 2026 21:45:00 +0200
Message-ID: <20260528194640.163812232@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260528194638.371537336@linuxfoundation.org>
References: <20260528194638.371537336@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -159,13 +159,13 @@ static int mlx5e_tx_reporter_timeout_rec
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
@@ -185,7 +185,7 @@ static int mlx5e_tx_reporter_timeout_rec
 		   "mlx5e_safe_reopen_channels failed recovering from a tx_timeout, err(%d).\n",
 		   err);
 out:
-	netdev_unlock(sq->netdev);
+	netdev_unlock(priv->netdev);
 	return err;
 }
 


