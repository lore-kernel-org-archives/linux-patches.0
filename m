Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A043C39B4A5;
	Sat, 17 Oct 2026 17:11:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792257099; cv=none; b=s/LTAzUEAsXn/O3lnEUGCrISOTmEbsfYHX3oqJWYvk3ZZqYNuFKZbQzVZN2SL1N0J5/JQB2a9wyHG8hr+V+dvnIC3bpXP/f/HY6Np8EyEN57EAi6tQynwMsUAkyWN1qNljhK5AK/AjtKeK9/LL69IEEgnVlm7CBxJwM2OwXweXo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792257099; c=relaxed/simple;
	bh=h3dCMRX6bITf69vvBKb+qTRK0JGdkQWyc3hV+lWHGZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YWLpznN/JO4kkM9Wt7mVBqjc13jiqMJ2MrPvTL4gTuavs08U4N9C+tWGd7dROjgLFKZUbynwzP+YQ3LhbuA49iSd0eeGpZtD5Q55Rot25yAKMYLpBpvHJLvt0JTCwH3Ez7naNNeRq1AtQAr+sxQBWbUaMoUSqj0NSEQDlfR95Ek=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=oFefKPg6; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="oFefKPg6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C2AD01F000C4;
	Sat, 17 Oct 2026 17:11:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792257098;
	bh=OFme1HeOhczwChP4OI3P5prT07Eh0XTjjAn7tT3rJn0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=oFefKPg6NSL+Zk9fysuvKO4/xxmrdk0Rj/WafEG4Ts975ACyf36ufB5gCB9V9NFhY
	 SL1fjoczPVCrdBHbKxSCN/uFZHVMOGzA071jmnwLYAMFA6FgAluKdidWyhoNhd9+b7
	 QCy4vnPfp2++HtRTAe9igZRZd7bPOjvG+NxVpvI0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jerome Tollet <jtollet@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0434/1674] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Sat, 17 Oct 2026 17:45:06 +0200
Message-ID: <20261017160442.264685278@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jerome Tollet <jtollet@cisco.com>

[ Upstream commit e01620844c5c88b6fcf819d171df8e3976a0e76f ]

When an XDP redirect to an AF_XDP socket fails because its RX ring is
full, the XSK core frees the buffer. During the subsequent batched refill
of a legacy cyclic RQ, mlx5e also releases the WQE's XSK buffer before
allocating a replacement. If that refill succeeds only partially, a WQE
left without a replacement retains its old buffer pointer.

The buffer can meanwhile be allocated to another WQE. A later refill
retry can then free the live buffer through the stale pointer and publish
the same UMEM frame twice.

Mark the WQE as released immediately after the driver-side free. The flag
is already cleared when a replacement buffer is assigned, so refill
retries no longer release stale pointers.

The failure is silent and produces no kernel warning or splat. A
standalone legacy cyclic-RQ zero-copy libxsk reproducer, using 64-byte UDP
traffic offered at 12 Mpps, detected it: stock stopped after 2,854,914
packets in 4.094 seconds, with 4,542 xdp_rx_ring_full events and 64
ownership/double-publication errors. With this change it processed
356,904,225 packets in 30 seconds despite 571,405 xdp_rx_ring_full events,
with no ownership or data errors.

Fixes: 3f93f82988bc ("net/mlx5e: RX, Defer page release in legacy rq for better recycling")
Cc: stable@vger.kernel.org
Suggested-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Jerome Tollet <jtollet@cisco.com>
Link: https://patch.msgid.link/20260824141645.23700-2-jtollet@cisco.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 1d586451900b8..1146a8a4ea19b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -382,8 +382,11 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 
 static void mlx5e_xsk_free_rx_wqe(struct mlx5e_wqe_frag_info *wi)
 {
-	if (!(wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE)))
-		xsk_buff_free(*wi->xskp);
+	if (wi->flags & BIT(MLX5E_WQE_FRAG_SKIP_RELEASE))
+		return;
+
+	xsk_buff_free(*wi->xskp);
+	wi->flags |= BIT(MLX5E_WQE_FRAG_SKIP_RELEASE);
 }
 
 static void mlx5e_dealloc_rx_wqe(struct mlx5e_rq *rq, u16 ix)
-- 
2.53.0



