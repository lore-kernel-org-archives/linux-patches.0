Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C9B8D4F055E;
	Tue, 13 Oct 2026 11:46:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892002; cv=none; b=KIMezVvqUyNcLrfCvVsQMrucAZolgsuTChs1R3VTtX15Hf2YvfCv4EuCViZ6DdAe0frCyT6Xc1HlCwns4u99ZE45vHPyisPwQCxv2lY2NdB6UCC1+Za04fpXlcqHjvfPRAaLKm0Yi5QHH8gR7K3CkgKgSA6H34uefS1Chejiau8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892002; c=relaxed/simple;
	bh=WIEOJ4JQ2Fgqq5suVr405Lbego1zvY/ni1KRhvzA9zE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tnDSidjXsPlgpQZ9SLGY8Xq8EB4Tz53JxCfEFYOvW7gMKQbrZXM/0IwMfdRcEkd8mFsC2iuu599g1Y6VvRiuKjmsnodIGuFeyVVgjIDFlSxtxFfOs+J328s4vabnHW+L2McwFSebNJeQ+i4hQKEae/AEoznY733O+5FHCvdEvL0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PNpXWWkT; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PNpXWWkT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 24C241F000FF;
	Tue, 13 Oct 2026 11:46:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892000;
	bh=NQGgtnyDrV2eoOl2/HYvzIEi80fEFvjV0d1K6kFecnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=PNpXWWkTw3zK5mNLirtqNMfmRoZgAj1mMcMTIAsHpjdF4cn2mHMC3z42YG4GpNYPN
	 uBjxQNJYgMzyshq6Y+qBiX/28jC+83VuFVEImH80z3xL816Uzc8UhfDbmUBw9kNiiI
	 Xx4q1Ok5WKucf7YoWiYoRVNKz3joSPK5KTzkKqNQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Jerome Tollet <jtollet@cisco.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 003/281] net/mlx5e: Prevent stale XSK buffer release on refill retry
Date: Tue, 13 Oct 2026 13:35:19 +0200
Message-ID: <20261013112855.133343510@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
index 6fc6605d20549..7967a27372981 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -410,8 +410,11 @@ static inline void mlx5e_free_rx_wqe(struct mlx5e_rq *rq,
 
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



