Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6AB541F5844;
	Wed, 19 Mar 2025 14:39:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1742395172; cv=none; b=rLnoSrhLjhwdQaRGsd91/XmtS7M9kMxihDgAZpi+m8aP0fqg9cjQxZUWLBvYAJ3vzC+q5BO9yKzfNlL3ifUJOyySO+LqlYAnemtH4aJ8w70lkxswjf7tV/iw6B9+rjQQdfqg3BZ+GyO0I2Nobxl/aHyKp3ZCaBJLLpxKtb8BwYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1742395172; c=relaxed/simple;
	bh=86dz5b4DksMnWrks0BkWgobACjRxEPrNlYXJMWAU/mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ajMTjIW8t+o7Id4PP6hZpAmc3cxGjbap0TxXzgkYMCu4kY5ZIOYwU8+rHNhJjKMitm7foGS4IDqQyzX0jvh2DFeL9xVGgL+sSTHunJXEPxj8swa+P74OFjcUdm4NcnjdzhGW5zW1FyfzMJY7dcvn+lznBgRTuLL/apZKS4kf0m0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=F7jOhyfJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F7jOhyfJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 360B1C4CEE4;
	Wed, 19 Mar 2025 14:39:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1742395172;
	bh=86dz5b4DksMnWrks0BkWgobACjRxEPrNlYXJMWAU/mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F7jOhyfJqpqBxm34RWlodHhaGygPID15aF7Sxrl/hEklcVhY+luw5yTpX75QMuYdg
	 KADWaPE9dOUh7emnp3MFeOmA6sWyL/iU5yB9+FScCTWmOHvOUQzmFlYxofjIIoqrrR
	 ezJvXWsQmReJTmfNML8dzBoWH12G+hXB5Om1SB4Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wentao Liang <vulab@iscas.ac.cn>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 023/166] net/mlx5: handle errors in mlx5_chains_create_table()
Date: Wed, 19 Mar 2025 07:29:54 -0700
Message-ID: <20250319143020.613428163@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250319143019.983527953@linuxfoundation.org>
References: <20250319143019.983527953@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wentao Liang <vulab@iscas.ac.cn>

[ Upstream commit eab0396353be1c778eba1c0b5180176f04dd21ce ]

In mlx5_chains_create_table(), the return value of mlx5_get_fdb_sub_ns()
and mlx5_get_flow_namespace() must be checked to prevent NULL pointer
dereferences. If either function fails, the function should log error
message with mlx5_core_warn() and return error pointer.

Fixes: 39ac237ce009 ("net/mlx5: E-Switch, Refactor chains and priorities")
Signed-off-by: Wentao Liang <vulab@iscas.ac.cn>
Reviewed-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20250307021820.2646-1-vulab@iscas.ac.cn
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
index a80ecb672f33d..711d14dea2485 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/lib/fs_chains.c
@@ -196,6 +196,11 @@ mlx5_chains_create_table(struct mlx5_fs_chains *chains,
 		ns = mlx5_get_flow_namespace(chains->dev, chains->ns);
 	}
 
+	if (!ns) {
+		mlx5_core_warn(chains->dev, "Failed to get flow namespace\n");
+		return ERR_PTR(-EOPNOTSUPP);
+	}
+
 	ft_attr.autogroup.num_reserved_entries = 2;
 	ft_attr.autogroup.max_num_groups = chains->group_num;
 	ft = mlx5_create_auto_grouped_flow_table(ns, &ft_attr);
-- 
2.39.5



