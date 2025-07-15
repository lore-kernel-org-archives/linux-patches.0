Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 221421F4CB3;
	Tue, 15 Jul 2025 13:21:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752585683; cv=none; b=NM1m0iNe6Ge0KXXNnvCycXtWPAEg8K4NEejcwMlMgaOG5bU6pz2AJnzY+ZYS8AgMJUz0L7lY6ar1gZz4U6yP1OYpmUVq3DRhPVk85RdmzwgHs5CzBoma4wq+KGaKEbPlaNuFcCGhFUNC6PdB6IvgGKoKZ4HdtOJfIhMaVt10lVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752585683; c=relaxed/simple;
	bh=/CPFyCLGUwSkw5+dq0MBEpimVB1VDq7eQ2bnxCVisNU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=J7zQ4Z9IPvp/fGPW0IprE+qrMXUTiVEIDhdAiyfmbyggIlFmgxdSNOLYXfEeCONDXI9X0hELsxIogY6bPAl5W/ewsaw0421j7FA2r7e37iszbv4aSOtM678eiEqzt+P4FWR5f8tmsF5hcAEwDE2JfPFFnzRxDNU9p6zfGrZmj4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1S3WZsqM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1S3WZsqM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A6D3BC4CEE3;
	Tue, 15 Jul 2025 13:21:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752585683;
	bh=/CPFyCLGUwSkw5+dq0MBEpimVB1VDq7eQ2bnxCVisNU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1S3WZsqMX42ZosYAiUGeGEKhQ7tuzzxOzs4wNEARkb9EY8+crXuqgwPfpbXPUJI28
	 8EaigcX2xz5SZBAFZHRYqluxOqTF05DBsFHJJFcJqtwcXx6ty8El/pB7MEYWffpwPl
	 vy55demMFue/QkbirN5YCf/nmaOGMmYnm7jE+m3w=
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
Subject: [PATCH 6.12 133/163] net/mlx5e: Fix race between DIM disable and net_dim()
Date: Tue, 15 Jul 2025 15:13:21 +0200
Message-ID: <20250715130814.175331415@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130808.777350091@linuxfoundation.org>
References: <20250715130808.777350091@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



