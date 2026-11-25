Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795623060;
	b=nO49Jn//1mD0QsvJNuidxRCf6yFscRDDh4HFRxUCJMFER3/9EumpL+hq7jmtAB0sDH2c
	 7vIs2PFx23QvPlbReRpJTpHLix5CDZnJjLpkRu9rxL6MRsjQ8diTNjdgEgIwtpriImRZu
	 9c/Oyu2g526oOFEh7pIqQKRWJn+vKfEG9oZy3Z42cNzZ6sljPYZQYmPNttqbYuxi9sqH+
	 l4/ICueYKPqwqqRxWji+9LsQvF6nC2blc7DYZwqCZHCI5Z6MAds/G5Pckq+XIVdmSm7db
	 Y6u4V4Wl57sIL6jOrRLtTuD+s6QZJQE/CO0pfbSJmjgD19knY396rJcm5zzUBmg4Jqg==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795623060;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=716JrijMMQAlN1V4meVGy2BtwPvfjmioVCvnGUgvNFw=;
	b=G9gWyAlthy+4WRatxvekTURr4iECV4w3XMLKoK7wa6BWqCdRLh5xxIR+8+L3gYFshagU
	 kXyA7CI1GiMBEuaqNh+7Z0ryfVh8T9l4yk/Ksgbdjj8SZ0Hqr7KrWag5yV5tv0XvihCh0
	 ON4Hy3W2amA61yVyGLfHPM7wfmVSO87hVoqu30Rw25Q1QLyvxFcQuxqaxb06Uv3dfDnKc
	 4BzfwsrZWvpiHW66F1ooEMtC9f5vVcWWo2DsglgFFPoFiMYXb5VG7dWkTi7NLnjj8HXKc
	 7GFibgk+rSmpdmXip8g1siHlUYOfupqJbMo1MUC6AbV1s9F5sVPyOMVzykHlh0EoZVw==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkfJiA+W;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36831606A321;
	Wed, 25 Nov 2026 16:11:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=nkfJiA+W
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7D5901F000C4;
	Wed, 25 Nov 2026 16:10:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795623060;
	bh=716JrijMMQAlN1V4meVGy2BtwPvfjmioVCvnGUgvNFw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=nkfJiA+Wlq9TuoytOCXj1Nhwfvh+QavmUJDzUIZIXm5jSArwfYg/BcU4rkBZm1Nxs
	 ydGodKKLXT4x0y2Zu5vg6xaYIfTNwXDSvq06AhoWzgLFzo1BkcN/SLyTrPDfXsbRsh
	 TnL3NNSL1qvuGl3ty2+5SpcGNiiLzjv9YLWTwlMg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Breno Leitao <leitao@debian.org>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.18 692/990] net/mlx5e: Fix queue stats access to queues without stats
Date: Wed, 25 Nov 2026 15:34:19 +0100
Message-ID: <20261125143838.297533204@linuxfoundation.org>
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

From: Breno Leitao <leitao@debian.org>

commit 9a24799e219b1699bb1c144248c8c500b9504db5 upstream.

I am seeing the following mlx5e crash in the Meta fleet:

  pc : mlx5e_get_queue_stats_rx+0x4c/0xc8
  Call trace:
   mlx5e_get_queue_stats_rx+0x4c/0xc8 (P)
   netdev_stat_queue_sum+0x78/0x480
   netdev_nl_qstats_get_dump_one+0xf0/0x268
   netdev_nl_qstats_get_dumpit+0x7c/0x1f8

When dumping device-wide qstats, the core calls the per-queue callbacks
for every queue below real_num_{rx,tx}_queues, regardless of whether the
netdev is up. Some of those queues have no stats behind them:

 - RX stats live in priv->channel_stats[], which only has entries for
   channels that have been opened (stats_nch). real_num_rx_queues can
   be larger, for example after the channel count is raised while the
   netdev is down, or after opening the channels failed part way.

 - TX stats are looked up in priv->txq2sq_stats[], which is NULL for
   SQs that were never activated and for HTB queues while the channels
   are closed.

In both cases the callback dereferences a NULL pointer. The dump needs
no privileges, so any user can trigger it.

Return early for RX queues at or above stats_nch and for TX queues
without SQ stats.

Fixes: 7b66ae536a78 ("net/mlx5e: Add per queue netdev-genl stats")
Cc: stable@vger.kernel.org
Signed-off-by: Breno Leitao <leitao@debian.org>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20261104-mlx5e-qstats-null-v1-1-a6a003245cec@debian.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_main.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_main.c
@@ -5413,7 +5413,7 @@ static void mlx5e_get_queue_stats_rx(str
 	struct mlx5e_rq_stats *xskrq_stats;
 	struct mlx5e_rq_stats *rq_stats;
 
-	if (mlx5e_is_uplink_rep(priv) || !mlx5e_stats_nch_read(priv))
+	if (mlx5e_is_uplink_rep(priv) || i >= mlx5e_stats_nch_read(priv))
 		return;
 
 	channel_stats = priv->channel_stats[i];
@@ -5440,6 +5440,9 @@ static void mlx5e_get_queue_stats_tx(str
 	 * inactive sqs.
 	 */
 	sq_stats = priv->txq2sq_stats[i];
+	if (!sq_stats)
+		return;
+
 	stats->packets = sq_stats->packets;
 	stats->bytes = sq_stats->bytes;
 }


