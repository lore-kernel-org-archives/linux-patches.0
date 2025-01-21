Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 868361F4275;
	Tue, 21 Jan 2025 18:03:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482603; cv=none; b=lQZYAtNpJD7wLPTbsV8n5d+aiOLMO9mZet6lcC59eZ/KH3sDeg9goWr+3BdUdyzgYAP5JCYddkh3r40uuy4Ft3fTSNU9UV5JDz4xuE4QkGX3bs2JUo7U90LO5q+z/LNQ6jHrMBpc28gN6GMNWMFJWl0FlugC+Y0F249AcCGLRro=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482603; c=relaxed/simple;
	bh=PyqewibvtKPx2SI5DVEZN8+3qIi1h9zV6vCyfI8XjF8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sRy7RsMqHl/lUrq3GKxb6vw3DTcejXnlVhz5BOB8z3UhXMtZzaa3kOPk3zPH+uaZckMPZLn3kNR7fPTs9g0D/3LGh9WUJ/yOjpvcZZLVeYtjkm85UEOXognZZ+xtN9H4sbOBrMALW/k3Hdtd25m+lVXqmZCuOyi1cJlfIsn+7y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UOhLU/ed; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UOhLU/ed"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11A92C4CEDF;
	Tue, 21 Jan 2025 18:03:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482603;
	bh=PyqewibvtKPx2SI5DVEZN8+3qIi1h9zV6vCyfI8XjF8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=UOhLU/ed2R9uVrSbVvVUVuqC0uNQggC/vlNKs2Vg/0+QNoxsT4rLEx2eRwVyWoLRF
	 VMnJrhHo/rLUtoelWF4wHl6prSQmYROm4nffZoxukznvupAH3EPsrF6q8NQ0D+Ys1S
	 TpZgyfOz2E+myAn4YwRBEVMvJSGd5OKmU0LJRl70=
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
Subject: [PATCH 6.1 11/64] net/mlx5: Fix RDMA TX steering prio
Date: Tue, 21 Jan 2025 18:52:10 +0100
Message-ID: <20250121174521.994924769@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174521.568417761@linuxfoundation.org>
References: <20250121174521.568417761@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index 50fdc3cbb778e..2717450e96661 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2421,6 +2421,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_BYPASS_PRIO;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
-- 
2.39.5



