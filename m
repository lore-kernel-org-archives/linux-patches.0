Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 918551E522;
	Thu, 30 Jan 2025 14:24:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1738247095; cv=none; b=Bj5YjWsZBPr9FRh98EfbRfNM+GaMqdgHI+M/bilaBJA+kEZTkTzdL3R0NI9iVoogQfJrJASqbX1g3/+ShLCA93Hq2EW0dQO4L2BcqjlPOrs2+TNJzms05SeyUHeXyEVsp147BEAPxOzNb8HZ4/EwbNFC216U7YhuiR4qmEYmIiw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1738247095; c=relaxed/simple;
	bh=S50AAcEASruFDhmO/hFHGxPf7ocG+kjCf/Qvsm3wi1s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O6plLRyfU1ci5E5E5YM6qAXNiJGHIK3wmP0GyWiI2YKuqNl9ITJibPFdX72R8v8Ax7ZTxcpTrYFSqZp/ULCdPqLtaW81Ooc+oMr5COro47O1wtp0thTumqsdbG6GExAzcgOeHPoT5i7KMQODUeinGb1JTKgrswvVRchmJx3zxr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IaP0zcaC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IaP0zcaC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AF4EC4CED2;
	Thu, 30 Jan 2025 14:24:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1738247095;
	bh=S50AAcEASruFDhmO/hFHGxPf7ocG+kjCf/Qvsm3wi1s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IaP0zcaCVqzLIGkEjg8oinKsFV8ovgxvUH7gJDKx1jYfLL49niE4IWjuyJxkOrnxh
	 1J/SPMi6VA0bXf0bfDAz7d7Dvkt1G0WgE1BH3iFHlZa0uyxuI/MrSWwV1RF3qTTgfe
	 MNmY/6mY0SqS3Bc3nRS6Y5WuMNwti1J8G4ZQm1+c=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrisious Haddad <phaddad@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 081/133] net/mlx5: Fix RDMA TX steering prio
Date: Thu, 30 Jan 2025 15:01:10 +0100
Message-ID: <20250130140145.785258500@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250130140142.491490528@linuxfoundation.org>
References: <20250130140142.491490528@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrisious Haddad <phaddad@nvidia.com>

[ Upstream commit c08d3e62b2e73e14da318a1d20b52d0486a28ee0 ]

User added steering rules at RDMA_TX were being added to the first prio,
which is the counters prio.
Fix that so that they are correctly added to the BYPASS_PRIO instead.

Fixes: 24670b1a3166 ("net/mlx5: Add support for RDMA TX steering")
Signed-off-by: Patrisious Haddad <phaddad@nvidia.com>
Reviewed-by: Mark Bloch <mbloch@nvidia.com>
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/fs_core.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
index 3c5e9bf1cde33..c1a33f05702ec 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2358,6 +2358,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_BYPASS_PRIO;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
-- 
2.39.5



