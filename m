Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0AB761E9B38;
	Tue, 21 Jan 2025 17:53:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1737482035; cv=none; b=iKWP+xhwyKiaBtWUVADiU9k/VA+vGG6srMFtn4wwfjhItGn4+0wEzbxkKwdy0xiXvp3pl73LEttmruqS/jmBEXJxBxIQTOreSvQm/JD5jA5WyN8fS+IsdRxLlmZ51fBrWU26+ggS7HHRXQHOGs6hiGHkxhoxywQadqgnH9HCu6Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1737482035; c=relaxed/simple;
	bh=ndgoO94/0na+NHBDoAj9+sikkb04kZcnkqYJHsriDHc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YqIQoGcV0hcxD1of8T+ayZPSua4uqEmBKh5k4hM51vmqwOG+hYVYyYcwZix97zpqjvFdMjtUyiW3CBjia05Wd/rNn7ukM0B4cbfs88z4l170srAgkjBxc/Wy9Y2UiOm0lbXD8/Zcx5KRK9IIF8FXxltmEqS2E/3ERHcy5JjZ0Cs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=S0BiD9Z3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="S0BiD9Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF771C4CEDF;
	Tue, 21 Jan 2025 17:53:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1737482034;
	bh=ndgoO94/0na+NHBDoAj9+sikkb04kZcnkqYJHsriDHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=S0BiD9Z3LimSzgV5Qj1YdZ7Iqw8tL7PkRHvg7ZKQTOi/FHegBoZTo23gZRs3ej3NV
	 DqH9WaRp6o9kvQ0Z+JIr4swznmFN+G2sYKTSl6M2KhCUcNKRHxv9zUG81Q3e0g5J/j
	 WL5TsnQYfQL6m6RZ2qaXmuPrjEge3pZfk9ngXbEQ=
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
Subject: [PATCH 6.6 12/72] net/mlx5: Fix RDMA TX steering prio
Date: Tue, 21 Jan 2025 18:51:38 +0100
Message-ID: <20250121174523.902514435@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250121174523.429119852@linuxfoundation.org>
References: <20250121174523.429119852@linuxfoundation.org>
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
index 474e63d02ba49..d2dc375f5e49c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/fs_core.c
@@ -2490,6 +2490,7 @@ struct mlx5_flow_namespace *mlx5_get_flow_namespace(struct mlx5_core_dev *dev,
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_TX:
 		root_ns = steering->rdma_tx_root_ns;
+		prio = RDMA_TX_BYPASS_PRIO;
 		break;
 	case MLX5_FLOW_NAMESPACE_RDMA_RX_COUNTERS:
 		root_ns = steering->rdma_rx_root_ns;
-- 
2.39.5



