Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4D044171A2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 11:24:55 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9EF0FC433A0;
	Mon,  8 May 2023 11:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683545095;
	bh=MpW3w6jfisRmUtKAjpAmTaV3QOAnGZAxiVtgi0KS92o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hlbiqRhH/gcPFup1b9yV/DWntQ82lK5HX7rW6gNPrJGDqOFfxT/fIZgTLkmqyUJYR
	 XAUrU8nX4WoGgUS6Lv+AmXC44zhWIa9k0e5YsMFZL49345+0U1I3n7NJfSY7znWe4C
	 t++cFvxgW6RsUCHrYo0BG0AQ4zAC7+eiM6NWiz9E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Avihai Horon <avihaih@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 623/694] RDMA/mlx5: Check pcie_relaxed_ordering_enabled() in UMR
Date: Mon,  8 May 2023 11:47:38 +0200
Message-Id: <20230508094455.782785427@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094432.603705160@linuxfoundation.org>
References: <20230508094432.603705160@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Avihai Horon <avihaih@nvidia.com>

[ Upstream commit d43b020b0f82c088ef8ff3196ef00575a97d200e ]

relaxed_ordering_read HCA capability is set if both the device supports
relaxed ordering (RO) read and RO is set in PCI config space.

RO in PCI config space can change during runtime. This will change the
value of relaxed_ordering_read HCA capability in FW, but the driver will
not see it since it queries the capabilities only once.

This can lead to the following scenario:
1. RO in PCI config space is enabled.
2. User creates MKey without RO.
3. RO in PCI config space is disabled.
   As a result, relaxed_ordering_read HCA capability is turned off in FW
   but remains on in driver copy of the capabilities.
4. User requests to reconfig the MKey with RO via UMR.
5. Driver will try to reconfig the MKey with RO read although it
   shouldn't (as relaxed_ordering_read HCA capability is really off).

To fix this, check pcie_relaxed_ordering_enabled() before setting RO
read in UMR.

Fixes: 896ec9735336 ("RDMA/mlx5: Set mkey relaxed ordering by UMR with ConnectX-7")
Signed-off-by: Avihai Horon <avihaih@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Link: https://lore.kernel.org/r/8d39eb8317e7bed1a354311a20ae707788fd94ed.1681131553.git.leon@kernel.org
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/umr.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/infiniband/hw/mlx5/umr.c b/drivers/infiniband/hw/mlx5/umr.c
index 55f4e048d9474..c9e176e8ced46 100644
--- a/drivers/infiniband/hw/mlx5/umr.c
+++ b/drivers/infiniband/hw/mlx5/umr.c
@@ -380,6 +380,9 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 				       struct mlx5_mkey_seg *seg,
 				       unsigned int access_flags)
 {
+	bool ro_read = (access_flags & IB_ACCESS_RELAXED_ORDERING) &&
+		       pcie_relaxed_ordering_enabled(dev->mdev->pdev);
+
 	MLX5_SET(mkc, seg, a, !!(access_flags & IB_ACCESS_REMOTE_ATOMIC));
 	MLX5_SET(mkc, seg, rw, !!(access_flags & IB_ACCESS_REMOTE_WRITE));
 	MLX5_SET(mkc, seg, rr, !!(access_flags & IB_ACCESS_REMOTE_READ));
@@ -387,8 +390,7 @@ static void mlx5r_umr_set_access_flags(struct mlx5_ib_dev *dev,
 	MLX5_SET(mkc, seg, lr, 1);
 	MLX5_SET(mkc, seg, relaxed_ordering_write,
 		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
-	MLX5_SET(mkc, seg, relaxed_ordering_read,
-		 !!(access_flags & IB_ACCESS_RELAXED_ORDERING));
+	MLX5_SET(mkc, seg, relaxed_ordering_read, ro_read);
 }
 
 int mlx5r_umr_rereg_pd_access(struct mlx5_ib_mr *mr, struct ib_pd *pd,
-- 
2.39.2



