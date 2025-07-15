Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 01D152ECD31;
	Tue, 15 Jul 2025 13:46:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752587169; cv=none; b=TWSeyLVJ+3SJ8+1I/V1ttSE9VnyGzWwdNl65ycSsXkEsmarGlroco3H3e89QP6+KxtaQOdob3FCapcbnCNcIiB1YqPnjbiKeFoA2yq2vO12tzFaLY7IdSx6aMEE+Gp+5XwdRFNf3NOvdvoctXdwKSzPdCZCrWFWRO6oihImSIjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752587169; c=relaxed/simple;
	bh=30ND6ap1T1LWGER9JY8kDkj3vSi/PMuFs82t3IGipd8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L8l2a/cC8m4tecWZXZO4xfA1762BtHcayuDw0PrlK0mea2EKAjr94i7n09Tdw2bBxczSZiaAejik4mP8MGMCcZzfQH10FVwnDDKefE1eQ9+Ww9XSZ2NPA/tQ5cdqeYC0VizeIg+jWcecN//g61ymeNhGmwj1f3qEIiIuK1+6MlE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M7SPde1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M7SPde1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A9C7C4CEF1;
	Tue, 15 Jul 2025 13:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752587168;
	bh=30ND6ap1T1LWGER9JY8kDkj3vSi/PMuFs82t3IGipd8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=M7SPde1olYOlRlQZ/4BFHujSHYjbZoGF2nz3sU3Q5fOyYa8AnxtASi1I78KwvP5K6
	 iZeD1qp9HsB48Y/RHzpdB1lqU/n6Kq13K6NiGQcxAGMht5FUhyxnPy2V40tRhDrH8e
	 7/exHf7GryRO5fcktV78PnPwuI4czarX0fg7PBVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 161/192] net/mlx5e: Fix race between DIM disable and net_dim()
Date: Tue, 15 Jul 2025 15:14:16 +0200
Message-ID: <20250715130821.374377790@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130814.854109770@linuxfoundation.org>
References: <20250715130814.854109770@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit eb41a264a3a576dc040ee37c3d9d6b7e2d9be968 ]

There's a race between disabling DIM and NAPI callbacks using the dim
pointer on the RQ or SQ.

If NAPI checks the DIM state bit and sees it still set, it assumes
`rq->dim` or `sq->dim` is valid. But if DIM gets disabled right after
that check, the pointer might already be set to NULL, leading to a NULL
pointer dereference in net_dim().

Fix this by calling `synchronize_net()` before freeing the DIM context.
This ensures all in-progress NAPI callbacks are finished before the
pointer is cleared.

Kernel log:

BUG: kernel NULL pointer dereference, address: 0000000000000000
...
RIP: 0010:net_dim+0x23/0x190
...
Call Trace:
 <TASK>
 ? __die+0x20/0x60
 ? page_fault_oops+0x150/0x3e0
 ? common_interrupt+0xf/0xa0
 ? sysvec_call_function_single+0xb/0x90
 ? exc_page_fault+0x74/0x130
 ? asm_exc_page_fault+0x22/0x30
 ? net_dim+0x23/0x190
 ? mlx5e_poll_ico_cq+0x41/0x6f0 [mlx5_core]
 ? sysvec_apic_timer_interrupt+0xb/0x90
 mlx5e_handle_rx_dim+0x92/0xd0 [mlx5_core]
 mlx5e_napi_poll+0x2cd/0xac0 [mlx5_core]
 ? mlx5e_poll_ico_cq+0xe5/0x6f0 [mlx5_core]
 busy_poll_stop+0xa2/0x200
 ? mlx5e_napi_poll+0x1d9/0xac0 [mlx5_core]
 ? mlx5e_trigger_irq+0x130/0x130 [mlx5_core]
 __napi_busy_loop+0x345/0x3b0
 ? sysvec_call_function_single+0xb/0x90
 ? asm_sysvec_call_function_single+0x16/0x20
 ? sysvec_apic_timer_interrupt+0xb/0x90
 ? pcpu_free_area+0x1e4/0x2e0
 napi_busy_loop+0x11/0x20
 xsk_recvmsg+0x10c/0x130
 sock_recvmsg+0x44/0x70
 __sys_recvfrom+0xbc/0x130
 ? __schedule+0x398/0x890
 __x64_sys_recvfrom+0x20/0x30
 do_syscall_64+0x4c/0x100
 entry_SYSCALL_64_after_hwframe+0x4b/0x53
...
---[ end trace 0000000000000000 ]---
...
---[ end Kernel panic - not syncing: Fatal exception in interrupt ]---

Fixes: 445a25f6e1a2 ("net/mlx5e: Support updating coalescing configuration without resetting channels")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Link: https://patch.msgid.link/1752155624-24095-3-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_dim.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_dim.c b/drivers/net/ethernet/mellanox/mlx5/core/en_dim.c
index 298bb74ec5e94..d1d629697e285 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_dim.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_dim.c
@@ -113,7 +113,7 @@ int mlx5e_dim_rx_change(struct mlx5e_rq *rq, bool enable)
 		__set_bit(MLX5E_RQ_STATE_DIM, &rq->state);
 	} else {
 		__clear_bit(MLX5E_RQ_STATE_DIM, &rq->state);
-
+		synchronize_net();
 		mlx5e_dim_disable(rq->dim);
 		rq->dim = NULL;
 	}
@@ -140,7 +140,7 @@ int mlx5e_dim_tx_change(struct mlx5e_txqsq *sq, bool enable)
 		__set_bit(MLX5E_SQ_STATE_DIM, &sq->state);
 	} else {
 		__clear_bit(MLX5E_SQ_STATE_DIM, &sq->state);
-
+		synchronize_net();
 		mlx5e_dim_disable(sq->dim);
 		sq->dim = NULL;
 	}
-- 
2.39.5



