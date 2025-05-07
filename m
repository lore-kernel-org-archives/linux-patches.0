Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 051A92144C1;
	Wed,  7 May 2025 19:11:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746645070; cv=none; b=tRNp055uZdyFKnND/L6thMdIRGuw4hBad+ZrNYU7K+gLUKTZIu2LDPZj76kgJ6w0lKlNrbxhFxlBf8JpJ8NrqASugBZxcKoj37++LfZ6wrsAC2w0jiuvilZyMjA2cTR7PRhbRJrn4Mj62MUhAlRmr+uCUYyaeoAPoTpxsN/SiJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746645070; c=relaxed/simple;
	bh=dCvzHwQg9Afwp2BqFDQg4G2V67HxE7jU5nC2R6KXMnM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b5NRHGHcGoYNF0koYp0MZAtEJVZljP411W5uZim5nXmTGrT8WlyQtI25CJG94fIfo7qphBZW7FqmAUqd+Z4dReHM/7y52MeaHYwyLXq/vkHstPKiFO21KzHwD52FE4ydR5mNUSDtBgJz/PeZZujsSeYFIbXeMuS5LvB8urjFr1g=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T06brcgr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T06brcgr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1833DC4CEE2;
	Wed,  7 May 2025 19:11:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746645069;
	bh=dCvzHwQg9Afwp2BqFDQg4G2V67HxE7jU5nC2R6KXMnM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T06brcgrFl0CCSwMFLJdUyjMfXaS3wSFAe8iHrlF1LdAXF3HIm0v/OYacLMLOa7k2
	 freSYt7zsYiUTVCukaOGQoPGhlWJHNngqJwQ2QGFuNcT41m04vOLRtUvHyxLR0lkMb
	 veZUosxRqc2X1Lod00LS5F1k8g8TCizE7IEVHcjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Gottlieb <maorg@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Michal Swiatkowski <michal.swiatkowski@linux.intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 054/129] net/mlx5: E-Switch, Initialize MAC Address for Default GID
Date: Wed,  7 May 2025 20:39:50 +0200
Message-ID: <20250507183815.724160798@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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



