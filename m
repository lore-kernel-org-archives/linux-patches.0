Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CEECD1F63EF;
	Tue, 21 Jan 2025 17:58:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482288; cv=none; b=k4edQZuo6h+q3EUQAAxf5bFUoPix3X78bun8g9RLKKeYmfhkvnn3Y9kUG+d6ZDMnpENs+7iDGqcBXLYaAF4vcBrLkRG/7yqV+Zrw0JtBhvfYOaf0zuDNQE8uefcIfcV00K2unsqNMjr6Zkn++DGyUBFv0NFyOTlCH8GXn+mOrvw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482288; c=relaxed/simple;
	bh=6aWUOQIx5iuhehR10qAp103YeTsWfjEYU4xSmHrt+nI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=K/bmum/Y3WrcaBTmDs4JF5rtEpWYRH1JXhZ6ivCr3yulzRUyw8e1J4E6cxsx9V8IaGQOCUT69vLr5HHXu5S0w0BaC+8jskGTGDfSR35ivVzr3LjVIVfsaBID6MSHgC1BRNt0mpcbPqEeD8w1XJK2/BhjmsgYTjdbvBdU66E9tYk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Zg9bs/Qd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Zg9bs/Qd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E96C4CEDF;
	Tue, 21 Jan 2025 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482288;
	bh=6aWUOQIx5iuhehR10qAp103YeTsWfjEYU4xSmHrt+nI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Zg9bs/QdXzNTYpAkNfPKLa7sYoOffB9wrbBJ+dEvwLvYshH3o1dTfFDuuVPrYZy0t
	 oWZ6Ilspqqjb4LHbY7PzwfUEtGrlfSlGQ2OxTREG+/WwWdiijFuXPZ6G1dlTS/5kpO
	 pzzx3MukmVMnrAHtg2F8coipZXz45nE5ZM/VCFTw=
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
Subject: [PATCH 6.12 025/122] net/mlx5: Fix RDMA TX steering prio
Date: Tue, 21 Jan 2025 18:51:13 +0100
Message-ID: <20250121174533.967410224@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174532.991109301@linuxfoundation.org>
References: <20250121174532.991109301@linuxfoundation.org>
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
index 2eabfcc247c6a..0ce999706d412 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2709,6 +2709,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_BYPASS_PRIO;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
-- 
2.39.5



