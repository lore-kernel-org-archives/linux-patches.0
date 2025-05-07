Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DE481E22E9;
	Wed,  7 May 2025 19:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644513; cv=none; b=gcJ1WTlpuXtj1GxcrYSn2ezZFKTW/y6QOmPAYz1YX0FeLfuRixaXNniOAQJruXZ+CrxY41znzHRNr+39KOyG1hhcOS/weXeAfq5viVSqUOLmqb+22abQERTAz2NASzif4F0IiWTmSJd1CPKD/23OYBDfvbHZRi42F5K/H+26piw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644513; c=relaxed/simple;
	bh=aEkIXKXteIbP1CtLGhsE2l8AwzDlJpVN7qn3rQE96MM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jYZgng/MRRqQDfspcLZPV90xSPmfHHxOjQ4wtU5gdRk7si2OuKvRZkMCV/Kkt2H+/fmhYjJInLlsgVMczyN+P489B6yEqrun/gph6cjMQO8wASPaKkCl/rvR7jD0RkPe231+Q5AfJZzqtiWKUyrH/jM9mLBJpqERIx87JBXOfLw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDb5l3O6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDb5l3O6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A98BC4CEE2;
	Wed,  7 May 2025 19:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644512;
	bh=aEkIXKXteIbP1CtLGhsE2l8AwzDlJpVN7qn3rQE96MM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jDb5l3O6Lnt/B7mcUDUcVVaeR779AeZofRlcg4fOEgaypjJ4v8750xYngnU3lFM9i
	 6JH1Qtv+ktxhsZH/1DZff814AJlteobPrmf95oMukcpbH6QPX8RMN6C69DmxnyB78A
	 4QpEtt3OvX7qSGiDAMACsx9/5dVixWJNQKd9/07Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 068/164] net/mlx5: E-Switch, Initialize MAC Address for Default GID
Date: Wed,  7 May 2025 20:39:13 +0200
Message-ID: <20250507183823.709854108@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

From: Maor Gottlieb <maorg@nvidia.com>

[ Upstream commit 5d1a04f347e6cbf5ffe74da409a5d71fbe8c5f19 ]

Initialize the source MAC address when creating the default GID entry.
Since this entry is used only for loopback traffic, it only needs to
be a unicast address. A zeroed-out MAC address is sufficient for this
purpose.
Without this fix, random bits would be assigned as the source address.
If these bits formed a multicast address, the firmware would return an
error, preventing the user from switching to switchdev mode:

Error: mlx5_core: Failed setting eswitch to offloads.
kernel answers: Invalid argument

Fixes: 80f09dfc237f ("net/mlx5: Eswitch, enable RoCE loopback traffic")
Signed-off-by: Maor Gottlieb <maorg@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Michal Swiatkowski <michal.swiatkowski@linux.intel.com>
Link: https://patch.msgid.link/20250423083611.324567-3-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/rdma.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
index a42f6cd99b744..f585ef5a34243 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -118,8 +118,8 @@ static void mlx5_rdma_make_default_gid(struct mlx5_core_dev *dev, union ib_gid *
 
 static int mlx5_rdma_add_roce_addr(struct mlx5_core_dev *dev)
 {
+	u8 mac[ETH_ALEN] = {};
 	union ib_gid gid;
-	u8 mac[ETH_ALEN];
 
 	mlx5_rdma_make_default_gid(dev, &gid);
 	return mlx5_core_roce_gid_set(dev, 0,
-- 
2.39.5



