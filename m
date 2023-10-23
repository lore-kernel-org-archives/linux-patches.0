Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 293A714282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MFpZpMQ/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 98B57C433C7;
	Mon, 23 Oct 2023 11:10:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059439;
	bh=UiCM2xUJr/+xFkaZlcWM0w/5sj+6jR8eay4tx/6MnQs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MFpZpMQ/DHXbxqJd1/AJFI6YVpKHuhhpLboO/KkX/Jp6EN9Fb6amdvyTrVUDf+PTw
	 CeGpFyr9GpWKmo54R0etXrfuabLfdZvW5yrsNk8z7qYboDws4KG45E4Gf+ZWMaJaRo
	 0997Q1EM1ddejbJtGBr4b5Dy9KY4aLsg07tV1UXg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mason <clm@fb.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 151/241] net/mlx5e: RX, Fix page_pool allocation failure recovery for striding rq
Date: Mon, 23 Oct 2023 12:55:37 +0200
Message-ID: <20231023104837.550759581@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit be43b7489a3c4702799e50179da69c3df7d6899b ]

When a page allocation fails during refill in mlx5e_post_rx_mpwqes, the
page will be released again on the next refill call. This triggers the
page_pool negative page fragment count warning below:

 [ 2436.447717] WARNING: CPU: 1 PID: 2419 at include/net/page_pool/helpers.h:130 mlx5e_page_release_fragmented.isra.0+0x42/0x50 [mlx5_core]
 ...
 [ 2436.447895] RIP: 0010:mlx5e_page_release_fragmented.isra.0+0x42/0x50 [mlx5_core]
 [ 2436.447991] Call Trace:
 [ 2436.447975]  mlx5e_post_rx_mpwqes+0x1d5/0xcf0 [mlx5_core]
 [ 2436.447994]  <IRQ>
 [ 2436.447996]  ? __warn+0x7d/0x120
 [ 2436.448009]  ? mlx5e_handle_rx_cqe_mpwrq+0x109/0x1d0 [mlx5_core]
 [ 2436.448002]  ? mlx5e_page_release_fragmented.isra.0+0x42/0x50 [mlx5_core]
 [ 2436.448044]  ? mlx5e_poll_rx_cq+0x87/0x6e0 [mlx5_core]
 [ 2436.448061]  ? report_bug+0x155/0x180
 [ 2436.448065]  ? handle_bug+0x36/0x70
 [ 2436.448067]  ? exc_invalid_op+0x13/0x60
 [ 2436.448070]  ? asm_exc_invalid_op+0x16/0x20
 [ 2436.448079]  mlx5e_napi_poll+0x122/0x6b0 [mlx5_core]
 [ 2436.448077]  ? mlx5e_page_release_fragmented.isra.0+0x42/0x50 [mlx5_core]
 [ 2436.448113]  ? generic_exec_single+0x35/0x100
 [ 2436.448117]  __napi_poll+0x25/0x1a0
 [ 2436.448120]  net_rx_action+0x28a/0x300
 [ 2436.448122]  __do_softirq+0xcd/0x279
 [ 2436.448126]  irq_exit_rcu+0x6a/0x90
 [ 2436.448128]  sysvec_apic_timer_interrupt+0x6e/0x90
 [ 2436.448130]  </IRQ>

This patch fixes the striding rq case by setting the skip flag on all
the wqe pages that were expected to have new pages allocated.

Fixes: 4c2a13236807 ("net/mlx5e: RX, Defer page release in striding rq for better recycling")
Tested-by: Chris Mason <clm@fb.com>
Reported-by: Chris Mason <clm@fb.com>
Closes: https://lore.kernel.org/netdev/117FF31A-7BE0-4050-B2BB-E41F224FF72F@meta.com
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_rx.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
index 41d37159e027b..0b558db1a9455 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_rx.c
@@ -816,6 +816,8 @@ static int mlx5e_alloc_rx_mpwqe(struct mlx5e_rq *rq, u16 ix)
 		mlx5e_page_release_fragmented(rq, frag_page);
 	}
 
+	bitmap_fill(wi->skip_release_bitmap, rq->mpwqe.pages_per_wqe);
+
 err:
 	rq->stats->buff_alloc_err++;
 
-- 
2.40.1



