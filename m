Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4ED6423A98D;
	Tue,  8 Jul 2025 16:38:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992730; cv=none; b=ab6siB0p0QwmYQzDF0xKxbWaFWAUJ+xVYh+O5Ar8gN6jJEtFThYNQ2R8LZqsEAFMqGsiO8xB710BgA14oAxtMMakADxNhpFeKiR2j0723VNUtBGwga4AukyBIg2PwDrDPR385FcPHIB4d00gb7J97Rbw/NnXH/K/St5GdffipCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992730; c=relaxed/simple;
	bh=L0VIg7G2HyKiJQgKmu8qz5Mew4ZKZrqETqBIIsbtzew=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Y77S0DQXHqocovyAfJHMKl0fDKGBF+I/fhRUYvZPDmrWUZ0xqOnAvbq5PF8ABFnskiqhFANFAbWG65sIEZ7DfwRug8MJ9LGCa/Ex5oozj9BOlgMTFVQy4S8/3ZhD0fqk5z5lbBhso5N9krTOg9T/qznxyhI/zV/0Wj0AhTk6SUs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gyTwvpPY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gyTwvpPY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C432C4CEED;
	Tue,  8 Jul 2025 16:38:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992729;
	bh=L0VIg7G2HyKiJQgKmu8qz5Mew4ZKZrqETqBIIsbtzew=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gyTwvpPYVz5UVzNlZdKQmmuay8JGaXqlXuLsugtoY2vX3thqOYalFgFtI46u5iKEn
	 w8vD0ehN2MCVVYRWhANquCdShOx2jv2aCuvzn+YPyfsYb33QeNzHntgMo335oSIpxp
	 LC2cgzaD/++wwyKiRitdxY8EJKu3TlX97inHBl14=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Or Har-Toov <ohartoov@nvidia.com>,
	Patrisious Haddad <phaddad@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 033/232] RDMA/mlx5: Fix unsafe xarray access in implicit ODP handling
Date: Tue,  8 Jul 2025 18:20:29 +0200
Message-ID: <20250708162242.298464625@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
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

From: Or Har-Toov <ohartoov@nvidia.com>

[ Upstream commit 2c6b640ea08bff1a192bf87fa45246ff1e40767c ]

__xa_store() and __xa_erase() were used without holding the proper lock,
which led to a lockdep warning due to unsafe RCU usage.  This patch
replaces them with xa_store() and xa_erase(), which perform the necessary
locking internally.

  =============================
  WARNING: suspicious RCPU usage
  6.14.0-rc7_for_upstream_debug_2025_03_18_15_01 #1 Not tainted
  -----------------------------
  ./include/linux/xarray.h:1211 suspicious rcu_dereference_protected() usage!

  other info that might help us debug this:

  rcu_scheduler_active = 2, debug_locks = 1
  3 locks held by kworker/u136:0/219:
      at: process_one_work+0xbe4/0x15f0
      process_one_work+0x75c/0x15f0
      pagefault_mr+0x9a5/0x1390 [mlx5_ib]

  stack backtrace:
  CPU: 14 UID: 0 PID: 219 Comm: kworker/u136:0 Not tainted
  6.14.0-rc7_for_upstream_debug_2025_03_18_15_01 #1
  Hardware name: QEMU Standard PC (Q35 + ICH9, 2009), BIOS
  rel-1.16.0-0-gd239552ce722-prebuilt.qemu.org 04/01/2014
  Workqueue: mlx5_ib_page_fault mlx5_ib_eqe_pf_action [mlx5_ib]
  Call Trace:
   dump_stack_lvl+0xa8/0xc0
   lockdep_rcu_suspicious+0x1e6/0x260
   xas_create+0xb8a/0xee0
   xas_store+0x73/0x14c0
   __xa_store+0x13c/0x220
   ? xa_store_range+0x390/0x390
   ? spin_bug+0x1d0/0x1d0
   pagefault_mr+0xcb5/0x1390 [mlx5_ib]
   ? _raw_spin_unlock+0x1f/0x30
   mlx5_ib_eqe_pf_action+0x3be/0x2620 [mlx5_ib]
   ? lockdep_hardirqs_on_prepare+0x400/0x400
   ? mlx5_ib_invalidate_range+0xcb0/0xcb0 [mlx5_ib]
   process_one_work+0x7db/0x15f0
   ? pwq_dec_nr_in_flight+0xda0/0xda0
   ? assign_work+0x168/0x240
   worker_thread+0x57d/0xcd0
   ? rescuer_thread+0xc40/0xc40
   kthread+0x3b3/0x800
   ? kthread_is_per_cpu+0xb0/0xb0
   ? lock_downgrade+0x680/0x680
   ? do_raw_spin_lock+0x12d/0x270
   ? spin_bug+0x1d0/0x1d0
   ? finish_task_switch.isra.0+0x284/0x9e0
   ? lockdep_hardirqs_on_prepare+0x284/0x400
   ? kthread_is_per_cpu+0xb0/0xb0
   ret_from_fork+0x2d/0x70
   ? kthread_is_per_cpu+0xb0/0xb0
   ret_from_fork_asm+0x11/0x20

Fixes: d3d930411ce3 ("RDMA/mlx5: Fix implicit ODP use after free")
Link: https://patch.msgid.link/r/a85ddd16f45c8cb2bc0a188c2b0fcedfce975eb8.1750061791.git.leon@kernel.org
Signed-off-by: Or Har-Toov <ohartoov@nvidia.com>
Reviewed-by: Patrisious Haddad <phaddad@nvidia.com>
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/odp.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/odp.c b/drivers/infiniband/hw/mlx5/odp.c
index e158d5b1ab17b..98a76c9db7aba 100644
--- a/drivers/infiniband/hw/mlx5/odp.c
+++ b/drivers/infiniband/hw/mlx5/odp.c
@@ -247,8 +247,8 @@ static void destroy_unused_implicit_child_mr(struct mlx5_ib_mr *mr)
 	}
 
 	if (MLX5_CAP_ODP(mr_to_mdev(mr)->mdev, mem_page_fault))
-		__xa_erase(&mr_to_mdev(mr)->odp_mkeys,
-			   mlx5_base_mkey(mr->mmkey.key));
+		xa_erase(&mr_to_mdev(mr)->odp_mkeys,
+			 mlx5_base_mkey(mr->mmkey.key));
 	xa_unlock(&imr->implicit_children);
 
 	/* Freeing a MR is a sleeping operation, so bounce to a work queue */
@@ -521,8 +521,8 @@ static struct mlx5_ib_mr *implicit_get_child_mr(struct mlx5_ib_mr *imr,
 	}
 
 	if (MLX5_CAP_ODP(dev->mdev, mem_page_fault)) {
-		ret = __xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
-				 &mr->mmkey, GFP_KERNEL);
+		ret = xa_store(&dev->odp_mkeys, mlx5_base_mkey(mr->mmkey.key),
+			       &mr->mmkey, GFP_KERNEL);
 		if (xa_is_err(ret)) {
 			ret = ERR_PTR(xa_err(ret));
 			__xa_erase(&imr->implicit_children, idx);
-- 
2.39.5



