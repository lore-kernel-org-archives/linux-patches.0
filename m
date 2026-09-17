Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 80BD84E73A0;
	Thu, 17 Sep 2026 16:05:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789661118; cv=none; b=WxB+5mwbqBfir6cMcweZN900RasvfjyHTGKRgEtZJTECJGHHNp9tIKb7+HG67wbAo0Ix9sydw6mV9VcgCqKCt3dyEFzqgipuYkxuTv6I2y6SgMJTtzZcQqYQeA8XD4UcPm2yztt/nFHENHO5DQtYVvDb6od0ggJ4Le0kUu8NpB8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789661118; c=relaxed/simple;
	bh=ymnEyRaAy0o0pTFFMXr5NcPqpei5DnnCYU11MLzv81I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJdAaXLPACHedyVVPEqdgXSDIn2mJYPsnawhTWJc2xLuCtCwZIEju/gHriOK5Cs8sMssv1JkvjFau6TC0GdRipeI2HgJDs2SM9bxHxyKGjjhTwI7p2kriR0956GlPbPe/dNRw+1aDWL/mMhxMTFNxjjcjiBC8pvTVURLBMiXJDQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=eH8T4YeR; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="eH8T4YeR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DD9F21F00893;
	Thu, 17 Sep 2026 16:05:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789661117;
	bh=Qx47yj9+FVEXYzwCU6NIIqtduTFDpJqpqoKLAqAS644=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=eH8T4YeRK4N6HiQiHQEqoFunUTLYNrK9w5Fyy0FpWV+Tlj5gEfaXctpsfTOaW9x+S
	 vIxoLrpzQt7CGMbtPIER4z9gJICBx18pS7WMCLsJ/DpsICISTkDonGW1WNeE8o1guR
	 W9dEWpZNe7+NPO814NNLiw+i2tQyi7R7JKCWhdmk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Shay Drori <shayd@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0089/1250] net/mlx5: HWS, Check if device is down while polling for completion
Date: Thu, 17 Sep 2026 15:58:04 +0100
Message-ID: <20260917151554.395346744@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit e3ec1570895bcf81f443e8ac60059edc61dbfca3 ]

In case the device is down for any reason (e.g. FLR),
the HW will no longer generate completions - no point
polling and waiting for timeout.

Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Reviewed-by: Shay Drori <shayd@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260507173443.320465-2-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/hws/bwc.c   | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
index 564ae98316bc9..756b87a3d68dd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/hws/bwc.c
@@ -423,6 +423,18 @@ int mlx5hws_bwc_queue_poll(struct mlx5hws_context *ctx,
 	if (!got_comp && !drain)
 		return 0;
 
+	if (unlikely(ctx->mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)) {
+		/* If the device is down for any reason (e.g. FLR), the HW will
+		 * no longer generate completions.
+		 * Note that ETIMEDOUT is returned here because the BWC layer
+		 * already has a special handling for timeouts - it breaks the
+		 * rehash / resize / shrink loops to avoid chain of timeouts.
+		 */
+		mlx5_core_warn_once(ctx->mdev,
+				    "BWC poll: device is down, polling for completion aborted\n");
+		return -ETIMEDOUT;
+	}
+
 	queue_full = mlx5hws_send_engine_full(&ctx->send_queue[queue_id]);
 	while (queue_full || ((got_comp || drain) && *pending_rules)) {
 		ret = mlx5hws_send_queue_poll(ctx, queue_id, comp, burst_th);
-- 
2.53.0



