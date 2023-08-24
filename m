Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2080E11C86
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 14:58:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 992BBC433C7;
	Thu, 24 Aug 2023 14:58:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692889134;
	bh=Vr/HCksX5FKvYUbAxFKaiONck05JeAhOfl8ggRl91KU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=goiz/TdL1a67yy95MRDFIQf3jb+TDdlH0843Ur8JqxeN4Kdp3C2uyDbXW2Qs1bQXi
	 ueUUt4DQ1pV2YRcYaQepPZvy96t3AKwFf/Ln5YYcNflLaSwpxjTKib3juCvcdM/1u/
	 cwT8407o1DjHpkDFfdtLUOSPCbnQgV/MJ75a/4Vk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Moshe Shemesh <moshe@nvidia.com>,
	Aya Levin <ayal@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>,
	Ganesh G R <ganeshgr@linux.ibm.com>
Subject: [PATCH 5.10 006/135] net/mlx5: Skip clock update work when device is in error state
Date: Thu, 24 Aug 2023 16:49:09 +0200
Message-ID: <20230824145027.288720794@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824145027.008282920@linuxfoundation.org>
References: <20230824145027.008282920@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Moshe Shemesh <moshe@nvidia.com>

[ Upstream commit d006207625657322ba8251b6e7e829f9659755dc ]

When device is in error state, marked by the flag
MLX5_DEVICE_STATE_INTERNAL_ERROR, the HW and PCI may not be accessible
and so clock update work should be skipped. Furthermore, such access
through PCI in error state, after calling mlx5_pci_disable_device() can
result in failing to recover from pci errors.

Fixes: ef9814deafd0 ("net/mlx5e: Add HW timestamping (TS) support")
Reported-and-tested-by: Ganesh G R <ganeshgr@linux.ibm.com>
Closes: https://lore.kernel.org/netdev/9bdb9b9d-140a-7a28-f0de-2e64e873c068@nvidia.com
Signed-off-by: Moshe Shemesh <moshe@nvidia.com>
Reviewed-by: Aya Levin <ayal@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
index 01b8a9648b16f..80dee8c692495 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/clock.c
@@ -162,10 +162,15 @@ static void mlx5_timestamp_overflow(struct work_struct *work)
 	clock = container_of(timer, struct mlx5_clock, timer);
 	mdev = container_of(clock, struct mlx5_core_dev, clock);
 
+	if (mdev->state == MLX5_DEVICE_STATE_INTERNAL_ERROR)
+		goto out;
+
 	write_seqlock_irqsave(&clock->lock, flags);
 	timecounter_read(&timer->tc);
 	mlx5_update_clock_info_page(mdev);
 	write_sequnlock_irqrestore(&clock->lock, flags);
+
+out:
 	schedule_delayed_work(&timer->overflow_work, timer->overflow_period);
 }
 
-- 
2.40.1



