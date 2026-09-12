Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D2B0D309EEB;
	Sat, 12 Sep 2026 16:26:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789230405; cv=none; b=bE9ElKkMIclcBStn9+x8k3uOQVTnAI7DoYuP/Nx7dKTxMFUiJ2wKT1IqWUBN84kXXfI2s85sjC6HhKja0nwXMDIbu0mbXlrwmxQLv+4xfTOEcaLYet/0w7+zyxFs8/1InUAtqwXIjS93McXOXqNvIqDhsrAckb/JXJc0jy9x6RY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789230405; c=relaxed/simple;
	bh=fcl1ubjEUaVQbtEYT1OySCpxh8N2eJPvZpNfrU04Y8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Wtz/Qj5DtWktPIFmGXCxnZ7GDrA3FO/DGj6mFm1oPWBRapfTXLVJQkNYp21zPTuA/VG64BbCQ7Fwou5qYNQQZ6lFeUgBNPn/yAslR34qMzAauI2yaxwv8BLfdm9hcYy0EmAIJgBNxihTctcTzx3aCmPGPeHBMRbx1hOae7zPTNo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pTCiOaOB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pTCiOaOB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9BCF11F000FF;
	Sat, 12 Sep 2026 16:26:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789230404;
	bh=ksS+8kvbRptdVd99IUM/emopWySjJ/ZNsABXoAC909Q=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=pTCiOaOBViz68bebIu0CpVP2rurrWP227x7p60pkVUgMQVHqV4+ORDGwbHnHo9Uod
	 3YAkUBTJvx/ejk9MYASzPUnxuzFflN6cQ+I+TDMBZibav0Z1l7SrFkuJBw/m8QmuEr
	 RLVSC9jm1wRsvIE7rw8+lY4kutUTKWha430708X0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0744/1191] RDMA/mlx5: Send cong param changes to the resolved port mdev
Date: Sat, 12 Sep 2026 08:57:52 +0200
Message-ID: <20260912065604.990087388@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065548.086904252@linuxfoundation.org>
References: <20260912065548.086904252@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 033a79e308e4fe832b0924347eda8c4364055174 ]

mlx5_ib_set_cc_params() resolves the port-specific mlx5_core_dev via
mlx5_ib_get_native_port_mdev() but issued MLX5_CMD_OP_MODIFY_CONG_PARAMS
through dev->mdev. On an affiliated secondary RoCE port those pointers
refer to different devices, so a write to the secondary port's cc_params
debugfs file either altered the master port or failed with a master-side
command error, while the read path already used the resolved mdev and
returned the unchanged secondary value.

Issue the command to the resolved mdev, the same device whose capabilities
were checked when its debugfs directory was created. It is already
referenced by the get/put pair, so its lifetime is safe.

Fixes: 31578defe4eb ("RDMA/mlx5: Update mlx5_ib to use new cmd interface")
Link: https://patch.msgid.link/20260726-mlx5-ib-set-cc-params-applies-conges-v1-1-a253edafe1f3@nvidia.com
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/cong.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/cong.c b/drivers/infiniband/hw/mlx5/cong.c
index f93ff7afc9cc6..17cbc8a9199d4 100644
--- a/drivers/infiniband/hw/mlx5/cong.c
+++ b/drivers/infiniband/hw/mlx5/cong.c
@@ -339,7 +339,7 @@ static int mlx5_ib_set_cc_params(struct mlx5_ib_dev *dev, u32 port_num,
 	MLX5_SET(field_select_r_roce_rp, field, field_select_r_roce_rp,
 		 attr_mask);
 
-	err = mlx5_cmd_exec_in(dev->mdev, modify_cong_params, in);
+	err = mlx5_cmd_exec_in(mdev, modify_cong_params, in);
 	kvfree(in);
 alloc_err:
 	mlx5_ib_put_native_port_mdev(dev, port_num + 1);
-- 
2.53.0



