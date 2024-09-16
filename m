Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B9AA4146A79;
	Mon, 16 Sep 2024 12:10:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488641; cv=none; b=fhVpp0C8cMbjUlpKUO7waGrjNg6FdFSF0mnZ9EjMnzaQZIL3k3uwU0Aadpg1aHyEY2hv28MwBdoky2l0opDZ7WhXfAn+Ds70E3vQc+B6HYiCRdtXOSsxrhnY4cFgKB+yEnDji8wf+71gJwFCczRvneyCXKiYDAnkI5JkDmDaANA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488641; c=relaxed/simple;
	bh=YwHH4f+Mgf97+ya8fpoBAKoSH4SAHFQMezlT18PMmd0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Kq1u/gEYTkFcSlO7f2UhhRDaygM02PZ0bpqDYK6lqX7JlbHt4R/I793UbyF9EvTVHi4mAE7/sUKu+R+Ye0u/uLBJ6OzrebSVvAjf1FfV1eItG8YYAIWY1TThWGexJy1r27YW+K2p4WhbuGX168pcUtpjzFYqSJJHHLxr0jFb6ak=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JvPtMELk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JvPtMELk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E705C4CEC4;
	Mon, 16 Sep 2024 12:10:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488641;
	bh=YwHH4f+Mgf97+ya8fpoBAKoSH4SAHFQMezlT18PMmd0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JvPtMELksZnV2J7ZQyMNWN52jlbYp7d3FXtXAvvBpuoy5+2pWxdCcWKvbuiJuiFGn
	 hE+iFRmaVm+qQyCCqNI9Ht8XTfZGSoJnqvZ6zUSvdhpy6Yc4gJEy+1tT4ZwooeLtPy
	 1sFl4Di/SQVYANkh8PpwtH+8FLXIkZ8Yb7Q13eqw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 63/91] net/mlx5: Explicitly set scheduling element and TSAR type
Date: Mon, 16 Sep 2024 13:44:39 +0200
Message-ID: <20240916114226.562672715@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit c88146abe4d0f8cf659b2b8883fdc33936d2e3b8 ]

Ensure the scheduling element type and TSAR type are explicitly
initialized in the QoS rate group creation.

This prevents potential issues due to default values.

Fixes: 1ae258f8b343 ("net/mlx5: E-switch, Introduce rate limiting groups API")
Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 1887a24ee414..627cdb072573 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -420,6 +420,7 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	struct mlx5_esw_rate_group *group;
+	__be32 *attr;
 	u32 divider;
 	int err;
 
@@ -427,6 +428,12 @@ __esw_qos_create_rate_group(struct mlx5_eswitch *esw, struct netlink_ext_ack *ex
 	if (!group)
 		return ERR_PTR(-ENOMEM);
 
+	MLX5_SET(scheduling_context, tsar_ctx, element_type,
+		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
+
+	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
+	*attr = cpu_to_be32(TSAR_ELEMENT_TSAR_TYPE_DWRR << 16);
+
 	MLX5_SET(scheduling_context, tsar_ctx, parent_element_id,
 		 esw->qos.root_tsar_ix);
 	err = mlx5_create_scheduling_element_cmd(esw->dev,
-- 
2.43.0



