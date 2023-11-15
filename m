Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 742332836D
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:30:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yC+HcJeU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97E88C433C8;
	Wed, 15 Nov 2023 19:30:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700076654;
	bh=w/XZGq9bhYIPgrukJarEF3dA2q2mPykXei/doswv6z4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yC+HcJeU/1MWUas2kvTUT+3UhFrbwjrGhtn1Zpiub4XfVtyJNuYpEmcEN1KC/A1x9
	 owGh5m0CUfbNMSSSDCtj2Uc10eTGugwvDIJRfQW/i6/FjqR+wc/tpYnL7B/vooOOHS
	 OhnbD/hj9Y4UA1rLPfs7/2hq5+vuJ/2aMUEjM6TI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leon@kernel.org>,
	George Kennedy <george.kennedy@oracle.com>,
	Jason Gunthorpe <jgg@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 365/550] IB/mlx5: Fix init stage error handling to avoid double free of same QP and UAF
Date: Wed, 15 Nov 2023 14:15:49 -0500
Message-ID: <20231115191626.119874629@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191600.708733204@linuxfoundation.org>
References: <20231115191600.708733204@linuxfoundation.org>
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

From: George Kennedy <george.kennedy@oracle.com>

[ Upstream commit 2ef422f063b74adcc4a4a9004b0a87bb55e0a836 ]

In the unlikely event that workqueue allocation fails and returns NULL in
mlx5_mkey_cache_init(), delete the call to
mlx5r_umr_resource_cleanup() (which frees the QP) in
mlx5_ib_stage_post_ib_reg_umr_init().  This will avoid attempted double
free of the same QP when __mlx5_ib_add() does its cleanup.

Resolves a splat:

   Syzkaller reported a UAF in ib_destroy_qp_user

   workqueue: Failed to create a rescuer kthread for wq "mkey_cache": -EINTR
   infiniband mlx5_0: mlx5_mkey_cache_init:981:(pid 1642):
   failed to create work queue
   infiniband mlx5_0: mlx5_ib_stage_post_ib_reg_umr_init:4075:(pid 1642):
   mr cache init failed -12
   ==================================================================
   BUG: KASAN: slab-use-after-free in ib_destroy_qp_user (drivers/infiniband/core/verbs.c:2073)
   Read of size 8 at addr ffff88810da310a8 by task repro_upstream/1642

   Call Trace:
   <TASK>
   kasan_report (mm/kasan/report.c:590)
   ib_destroy_qp_user (drivers/infiniband/core/verbs.c:2073)
   mlx5r_umr_resource_cleanup (drivers/infiniband/hw/mlx5/umr.c:198)
   __mlx5_ib_add (drivers/infiniband/hw/mlx5/main.c:4178)
   mlx5r_probe (drivers/infiniband/hw/mlx5/main.c:4402)
   ...
   </TASK>

   Allocated by task 1642:
   __kmalloc (./include/linux/kasan.h:198 mm/slab_common.c:1026
   mm/slab_common.c:1039)
   create_qp (./include/linux/slab.h:603 ./include/linux/slab.h:720
   ./include/rdma/ib_verbs.h:2795 drivers/infiniband/core/verbs.c:1209)
   ib_create_qp_kernel (drivers/infiniband/core/verbs.c:1347)
   mlx5r_umr_resource_init (drivers/infiniband/hw/mlx5/umr.c:164)
   mlx5_ib_stage_post_ib_reg_umr_init (drivers/infiniband/hw/mlx5/main.c:4070)
   __mlx5_ib_add (drivers/infiniband/hw/mlx5/main.c:4168)
   mlx5r_probe (drivers/infiniband/hw/mlx5/main.c:4402)
   ...

   Freed by task 1642:
   __kmem_cache_free (mm/slub.c:1826 mm/slub.c:3809 mm/slub.c:3822)
   ib_destroy_qp_user (drivers/infiniband/core/verbs.c:2112)
   mlx5r_umr_resource_cleanup (drivers/infiniband/hw/mlx5/umr.c:198)
   mlx5_ib_stage_post_ib_reg_umr_init (drivers/infiniband/hw/mlx5/main.c:4076
   drivers/infiniband/hw/mlx5/main.c:4065)
   __mlx5_ib_add (drivers/infiniband/hw/mlx5/main.c:4168)
   mlx5r_probe (drivers/infiniband/hw/mlx5/main.c:4402)
   ...

Fixes: 04876c12c19e ("RDMA/mlx5: Move init and cleanup of UMR to umr.c")
Link: https://lore.kernel.org/r/1698170518-4006-1-git-send-email-george.kennedy@oracle.com
Suggested-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: George Kennedy <george.kennedy@oracle.com>
Signed-off-by: Jason Gunthorpe <jgg@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/main.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/main.c b/drivers/infiniband/hw/mlx5/main.c
index 666e737371b76..61d892bf6d38b 100644
--- a/drivers/infiniband/hw/mlx5/main.c
+++ b/drivers/infiniband/hw/mlx5/main.c
@@ -4052,10 +4052,8 @@ static int mlx5_ib_stage_post_ib_reg_umr_init(struct mlx5_ib_dev *dev)
 		return ret;
 
 	ret = mlx5_mkey_cache_init(dev);
-	if (ret) {
+	if (ret)
 		mlx5_ib_warn(dev, "mr cache init failed %d\n", ret);
-		mlx5r_umr_resource_cleanup(dev);
-	}
 	return ret;
 }
 
-- 
2.42.0



