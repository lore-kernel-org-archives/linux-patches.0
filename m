Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DEADA12CD9B;
	Tue, 30 Apr 2024 11:21:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476076; cv=none; b=EsqS8p0ZbET0ETZyVSeXnky/yx0pwc/YYn0MRM896AqXuJLQZGmz366tFjk16sMCQe0pcl7nseen2WO2OcNcgdDR3XzTubhslSzQc+tITJkwSO+EGtiEWIvoYFg5cL+vh6moHXaVnKuzqSJjjkXK0VtGRQI1mMPFAjfaw5uM8Xo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476076; c=relaxed/simple;
	bh=T5vadjCBokk3W7b39KvSHV/soDElfxwavfFgjzTLI/s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VlfWIDRAGBPt2502vD0HgIRL+LBoDWPA9vZx/37SWbUI4DR/pOO6TPrqX13SNfNwL7Crx1u3yQNFxJiKVQyUKtAFU6gSxyyXi/VKZsq6TdGeN+w7tO+Dznh4MWft06MYHGMyq429HTcP41bIOURTuJOxCZdmZvVJsY/8SMyC8aU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AZ+ddMI6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AZ+ddMI6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49A18C2BBFC;
	Tue, 30 Apr 2024 11:21:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476075;
	bh=T5vadjCBokk3W7b39KvSHV/soDElfxwavfFgjzTLI/s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AZ+ddMI6C1vkBESNhqSfKsYSwETseDR5tlL63aAsB2vCPNM/6DsWaxx9bhVmxRtKp
	 sJHH81sS0MF4qf+nV5IEG5l1O5tRre22trNZsNu4voVdjzbgHQhQVh+SRbBz+2RVe7
	 0xU1wt02WF9wTUpR9vkNkankiiltnl7hA/z+GmYI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Guralnik <michaelgur@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/107] RDMA/mlx5: Fix port number for counter query in multi-port configuration
Date: Tue, 30 Apr 2024 12:39:46 +0200
Message-ID: <20240430103045.435853006@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103044.655968143@linuxfoundation.org>
References: <20240430103044.655968143@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Guralnik <michaelgur@nvidia.com>

[ Upstream commit be121ffb384f53e966ee7299ffccc6eeb61bc73d ]

Set the correct port when querying PPCNT in multi-port configuration.
Distinguish between cases where switchdev mode was enabled to multi-port
configuration and don't overwrite the queried port to 1 in multi-port
case.

Fixes: 74b30b3ad5ce ("RDMA/mlx5: Set local port to one when accessing counters")
Signed-off-by: Michael Guralnik <michaelgur@nvidia.com>
Link: https://lore.kernel.org/r/9bfcc8ade958b760a51408c3ad654a01b11f7d76.1712134988.git.leon@kernel.org
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/hw/mlx5/mad.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/hw/mlx5/mad.c b/drivers/infiniband/hw/mlx5/mad.c
index 3897a3ce02ad0..84d72b3b6df84 100644
--- a/drivers/infiniband/hw/mlx5/mad.c
+++ b/drivers/infiniband/hw/mlx5/mad.c
@@ -219,7 +219,8 @@ static int process_pma_cmd(struct mlx5_ib_dev *dev, u8 port_num,
 		mdev = dev->mdev;
 		mdev_port_num = 1;
 	}
-	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1) {
+	if (MLX5_CAP_GEN(dev->mdev, num_ports) == 1 &&
+	    !mlx5_core_mp_enabled(mdev)) {
 		/* set local port to one for Function-Per-Port HCA. */
 		mdev = dev->mdev;
 		mdev_port_num = 1;
-- 
2.43.0



