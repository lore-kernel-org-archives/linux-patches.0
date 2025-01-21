Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C81B41F5439;
	Tue, 21 Jan 2025 17:58:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482291; cv=none; b=T/MNB+Q1j3HOChD9izcA7OJskQ542UKu6nfE/drR82GBOexDZmWo0IuM9vZCQTmCvdgpSFintJI3MEwEPL8pgXugDZxq4kjZy6fptJsRiiXm9adsR8vCfGXeZ2Am0gIKLvBq3FcxZAacTlDCR8XJBbL9lbMk7nGjamARxdw9R/Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482291; c=relaxed/simple;
	bh=PDK7chRLR+eGyG54oCYSbpyT3Hh54Nbc9tM4WrqnS8I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jUkRbduTgHshXShsXt3f8Bq1xfBTPHvLy82fWPRPWAZQx4dPBl9N/26uTAs+UAfHwWBTj9Sb9HKD3N27wKTvRGcGZN5Jgi62KRGo0PDcnwper0UQV5kLDDKOoosLnkG8FVwkLOdnhkD5HMb0R/UWZQru/NknDQFLLIhnv+de+94=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cFDnj9Wf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cFDnj9Wf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48FFBC4CEE1;
	Tue, 21 Jan 2025 17:58:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482291;
	bh=PDK7chRLR+eGyG54oCYSbpyT3Hh54Nbc9tM4WrqnS8I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cFDnj9WfnZvd4z06vqGGcrOfiAqlXm8+oamkNNnTUU5IL2kuo0xAApLdGhOLTjawV
	 kQf1WwJfDYgpn5LHEXASfFnddO5GWx+I9EhkDHToOgxXQu3xQMh/7LqZlT9FWQMRnk
	 rys85gl4j8f6tjtaAlsttNwmBcXnCnOiWZDBul3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yishai Hadas <yishaih@nvidia.com>,
	Michael Guralnik <michaelgur@nvidia.com>,
	Larysa Zaremba <larysa.zaremba@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 026/122] net/mlx5: Fix a lockdep warning as part of the write combining test
Date: Tue, 21 Jan 2025 18:51:14 +0100
Message-ID: <20250121174534.005161510@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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

From: Yishai Hadas <yishaih@nvidia.com>

[ Upstream commit 1b10a519a45704d4b06ebd9245b272d145752c18 ]

Fix a lockdep warning [1] observed during the write combining test.

The warning indicates a potential nested lock scenario that could lead
to a deadlock.

However, this is a false positive alarm because the SF lock and its
parent lock are distinct ones.

The lockdep confusion arises because the locks belong to the same object
class (i.e., struct mlx5_core_dev).

To resolve this, the code has been refactored to avoid taking both
locks. Instead, only the parent lock is acquired.

[1]
raw_ethernet_bw/2118 is trying to acquire lock:
[  213.619032] ffff88811dd75e08 (&dev->wc_state_lock){+.+.}-{3:3}, at:
               mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.620270]
[  213.620270] but task is already holding lock:
[  213.620943] ffff88810b585e08 (&dev->wc_state_lock){+.+.}-{3:3}, at:
               mlx5_wc_support_get+0x10c/0x210 [mlx5_core]
[  213.622045]
[  213.622045] other info that might help us debug this:
[  213.622778]  Possible unsafe locking scenario:
[  213.622778]
[  213.623465]        CPU0
[  213.623815]        ----
[  213.624148]   lock(&dev->wc_state_lock);
[  213.624615]   lock(&dev->wc_state_lock);
[  213.625071]
[  213.625071]  *** DEADLOCK ***
[  213.625071]
[  213.625805]  May be due to missing lock nesting notation
[  213.625805]
[  213.626522] 4 locks held by raw_ethernet_bw/2118:
[  213.627019]  #0: ffff88813f80d578 (&uverbs_dev->disassociate_srcu){.+.+}-{0:0},
                at: ib_uverbs_ioctl+0xc4/0x170 [ib_uverbs]
[  213.628088]  #1: ffff88810fb23930 (&file->hw_destroy_rwsem){.+.+}-{3:3},
                at: ib_init_ucontext+0x2d/0xf0 [ib_uverbs]
[  213.629094]  #2: ffff88810fb23878 (&file->ucontext_lock){+.+.}-{3:3},
                at: ib_init_ucontext+0x49/0xf0 [ib_uverbs]
[  213.630106]  #3: ffff88810b585e08 (&dev->wc_state_lock){+.+.}-{3:3},
                at: mlx5_wc_support_get+0x10c/0x210 [mlx5_core]
[  213.631185]
[  213.631185] stack backtrace:
[  213.631718] CPU: 1 UID: 0 PID: 2118 Comm: raw_ethernet_bw Not tainted
               6.12.0-rc7_internal_net_next_mlx5_89a0ad0 #1
[  213.632722] Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
               rel-1.13.0-0-gf21b5a4aeb02-prebuilt.qemu.org 04/01/2014
[  213.633785] Call Trace:
[  213.634099]
[  213.634393]  dump_stack_lvl+0x7e/0xc0
[  213.634806]  print_deadlock_bug+0x278/0x3c0
[  213.635265]  __lock_acquire+0x15f4/0x2c40
[  213.635712]  lock_acquire+0xcd/0x2d0
[  213.636120]  ? mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.636722]  ? mlx5_ib_enable_lb+0x24/0xa0 [mlx5_ib]
[  213.637277]  __mutex_lock+0x81/0xda0
[  213.637697]  ? mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.638305]  ? mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.638902]  ? rcu_read_lock_sched_held+0x3f/0x70
[  213.639400]  ? mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.640016]  mlx5_wc_support_get+0x18c/0x210 [mlx5_core]
[  213.640615]  set_ucontext_resp+0x68/0x2b0 [mlx5_ib]
[  213.641144]  ? debug_mutex_init+0x33/0x40
[  213.641586]  mlx5_ib_alloc_ucontext+0x18e/0x7b0 [mlx5_ib]
[  213.642145]  ib_init_ucontext+0xa0/0xf0 [ib_uverbs]
[  213.642679]  ib_uverbs_handler_UVERBS_METHOD_GET_CONTEXT+0x95/0xc0
                [ib_uverbs]
[  213.643426]  ? _copy_from_user+0x46/0x80
[  213.643878]  ib_uverbs_cmd_verbs+0xa6b/0xc80 [ib_uverbs]
[  213.644426]  ? ib_uverbs_handler_UVERBS_METHOD_INVOKE_WRITE+0x130/0x130
               [ib_uverbs]
[  213.645213]  ? __lock_acquire+0xa99/0x2c40
[  213.645675]  ? lock_acquire+0xcd/0x2d0
[  213.646101]  ? ib_uverbs_ioctl+0xc4/0x170 [ib_uverbs]
[  213.646625]  ? reacquire_held_locks+0xcf/0x1f0
[  213.647102]  ? do_user_addr_fault+0x45d/0x770
[  213.647586]  ib_uverbs_ioctl+0xe0/0x170 [ib_uverbs]
[  213.648102]  ? ib_uverbs_ioctl+0xc4/0x170 [ib_uverbs]
[  213.648632]  __x64_sys_ioctl+0x4d3/0xaa0
[  213.649060]  ? do_user_addr_fault+0x4a8/0x770
[  213.649528]  do_syscall_64+0x6d/0x140
[  213.649947]  entry_SYSCALL_64_after_hwframe+0x4b/0x53
[  213.650478] RIP: 0033:0x7fa179b0737b
[  213.650893] Code: ff ff ff 85 c0 79 9b 49 c7 c4 ff ff ff ff 5b 5d 4c
               89 e0 41 5c c3 66 0f 1f 84 00 00 00 00 00 f3 0f 1e fa b8
               10 00 00 00 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d
               7d 2a 0f 00 f7 d8 64 89 01 48
[  213.652619] RSP: 002b:00007ffd2e6d46e8 EFLAGS: 00000246 ORIG_RAX:
               0000000000000010
[  213.653390] RAX: ffffffffffffffda RBX: 00007ffd2e6d47f8 RCX:
               00007fa179b0737b
[  213.654084] RDX: 00007ffd2e6d47e0 RSI: 00000000c0181b01 RDI:
               0000000000000003
[  213.654767] RBP: 00007ffd2e6d47c0 R08: 00007fa1799be010 R09:
               0000000000000002
[  213.655453] R10: 00007ffd2e6d4960 R11: 0000000000000246 R12:
               00007ffd2e6d487c
[  213.656170] R13: 0000000000000027 R14: 0000000000000001 R15:
               00007ffd2e6d4f70

Fixes: d98995b4bf98 ("net/mlx5: Reimplement write combining test")
Signed-off-by: Yishai Hadas <yishaih@nvidia.com>
Reviewed-by: Michael Guralnik <michaelgur@nvidia.com>
Reviewed-by: Larysa Zaremba <larysa.zaremba@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/wc.c | 24 ++++++++++----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/wc.c b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
index 1bed75eca97db..740b719e7072d 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/wc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/wc.c
@@ -382,6 +382,7 @@ static void mlx5_core_test_wc(struct mlx5_core_dev *mdev)
 
 bool mlx5_wc_support_get(struct mlx5_core_dev *mdev)
 {
+	struct mutex *wc_state_lock = &mdev->wc_state_lock;
 	struct mlx5_core_dev *parent = NULL;
 
 	if (!MLX5_CAP_GEN(mdev, bf)) {
@@ -400,32 +401,31 @@ bool mlx5_wc_support_get(struct mlx5_core_dev *mdev)
 		 */
 		goto out;
 
-	mutex_lock(&mdev->wc_state_lock);
-
-	if (mdev->wc_state != MLX5_WC_STATE_UNINITIALIZED)
-		goto unlock;
-
 #ifdef CONFIG_MLX5_SF
-	if (mlx5_core_is_sf(mdev))
+	if (mlx5_core_is_sf(mdev)) {
 		parent = mdev->priv.parent_mdev;
+		wc_state_lock = &parent->wc_state_lock;
+	}
 #endif
 
-	if (parent) {
-		mutex_lock(&parent->wc_state_lock);
+	mutex_lock(wc_state_lock);
 
+	if (mdev->wc_state != MLX5_WC_STATE_UNINITIALIZED)
+		goto unlock;
+
+	if (parent) {
 		mlx5_core_test_wc(parent);
 
 		mlx5_core_dbg(mdev, "parent set wc_state=%d\n",
 			      parent->wc_state);
 		mdev->wc_state = parent->wc_state;
 
-		mutex_unlock(&parent->wc_state_lock);
+	} else {
+		mlx5_core_test_wc(mdev);
 	}
 
-	mlx5_core_test_wc(mdev);
-
 unlock:
-	mutex_unlock(&mdev->wc_state_lock);
+	mutex_unlock(wc_state_lock);
 out:
 	mlx5_core_dbg(mdev, "wc_state=%d\n", mdev->wc_state);
 
-- 
2.39.5



