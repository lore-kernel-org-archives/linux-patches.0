Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5E7C288CB0;
	Wed,  7 May 2025 18:41:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746643312; cv=none; b=bQW4G6z8f73xRUGiHDXtESYrLA2z6z/gGGkUNJkhJoJjxHo6Kho8EYAZJ58ClThN3v65S7v065ZM80uGJT1iHsUiM2evAkiXAqUwH82InC+0g83jT3JmxLJ0E03zBifEmT6pUK/dv1EgzqTZYTk+DVi3kwQqCmSQ2FWHtyc9iEU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746643312; c=relaxed/simple;
	bh=PS4PKuVRAFSJ+ZUI1vjW8DHug34ZBKyGTKMpZObyQts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LfubZm9vrakg532Su1aeHpICxJDh+U0Jlm+bnKg5gImMc5pbrZENT8rpdoX5DtTBbztb+CwYWA35aLRziEGpneIiL6KJ6ckyX3oeUTENQI/Ix81FWjIn0msUnrKY5xUPUD/VG9RZvYZn5oPWc8iUfp0vYL/KBNpfS2Jsx7gElFQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uNiacLj+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uNiacLj+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CFC55C4CEE2;
	Wed,  7 May 2025 18:41:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746643312;
	bh=PS4PKuVRAFSJ+ZUI1vjW8DHug34ZBKyGTKMpZObyQts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uNiacLj+FouXDnKq09IQZmUU4uve0HCxAEk+HAcOUSfDX7t4VyhEh2MhObn+jJCgR
	 tA0EOi1xEUzyVVtX2alN3GYUjey0Kz8fKm2JR99Ih9sxaN9SI6EpE2ecCdAIrOUNV/
	 KJx+Q31t43suEUttoXgcHcweYw4rtF8OyihvtCfw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 18/55] net/mlx5: E-Switch, Initialize MAC Address for Default GID
Date: Wed,  7 May 2025 20:39:19 +0200
Message-ID: <20250507183759.782097674@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183759.048732653@linuxfoundation.org>
References: <20250507183759.048732653@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
index 540cf05f63739..ab5afa6c5e0fd 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/rdma.c
@@ -130,8 +130,8 @@ static void mlx5_rdma_make_default_gid(struct mlx5_core_dev *dev, union ib_gid *
 
 static int mlx5_rdma_add_roce_addr(struct mlx5_core_dev *dev)
 {
+	u8 mac[ETH_ALEN] = {};
 	union ib_gid gid;
-	u8 mac[ETH_ALEN];
 
 	mlx5_rdma_make_default_gid(dev, &gid);
 	return mlx5_core_roce_gid_set(dev, 0,
-- 
2.39.5



