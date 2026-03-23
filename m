Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DCB0A3803EF;
	Mon, 23 Mar 2026 14:14:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774275270; cv=none; b=Ia2UUmw+Rl8wLSojBLpSqgsdtzEQ+aKvmq/FQdlTCy/h90FN6b8Akl0Fg6P+EbByksU84+NlOXSs5RUGibrbRO0sdAw+oedPbMRNtdti3G+JEPDs3Uk1WjNQEBrJ5VLXp//isl5PLICMf6fE31rrmlDTT0bN09UAVO5sHFo857w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774275270; c=relaxed/simple;
	bh=mOqh5RsOFJRynXRvEpPKSICtMm4ObOnTTjjsTvJOuA0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GYrIaT/gw0qmAT0JWmJNtmSIUQEhO71Bo3Sx95miyRXFfwazgFIRx8CqQxaM8RvHmQxTw3nfoAMZDei5MhEvC12DI4YqA9gvMNKwbcn83YYfA1JnOyQOGXI+OwZf4Fw5aO4aWTKwN8EZwCpD7iRtPXco16NpAdLfQ4q84/92eFw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yGDYmAI4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yGDYmAI4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6E882C4CEF7;
	Mon, 23 Mar 2026 14:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774275270;
	bh=mOqh5RsOFJRynXRvEpPKSICtMm4ObOnTTjjsTvJOuA0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yGDYmAI4kA8I5zJJczX36U4dmtQdV9wkA5WTTl224ztC4voNc4ujPKdbV1LmYYech
	 1jBH2ujkYo4PdxBAhXw4/GXo4tA+WW/6X1537C3DMB83fmx35a6dqL1faBgDx0GE78
	 hx7t8Vo7KI2ikyy7eSxHsjf6hes0QnfWEp9kfpP0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Jurgens <danielj@nvidia.com>,
	William Tu <witu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 036/460] net/mlx5: Query to see if host PF is disabled
Date: Mon, 23 Mar 2026 14:40:32 +0100
Message-ID: <20260323134527.595250571@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260323134526.647552166@linuxfoundation.org>
References: <20260323134526.647552166@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Daniel Jurgens <danielj@nvidia.com>

[ Upstream commit 9e84de72aef9bcf0e751a0bff3ac91b0cf52366f ]

The host PF can be disabled, query firmware to check if the host PF of
this function exists.

Signed-off-by: Daniel Jurgens <danielj@nvidia.com>
Reviewed-by: William Tu <witu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1755112796-467444-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: aed763abf0e9 ("net/mlx5: Fix deadlock between devlink lock and esw->wq")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/eswitch.c | 23 +++++++++++++++++++
 .../net/ethernet/mellanox/mlx5/core/eswitch.h |  1 +
 2 files changed, 24 insertions(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
index 6544546a1153f..b26ab78006ea0 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.c
@@ -1038,6 +1038,25 @@ const u32 *mlx5_esw_query_functions(struct mlx5_core_dev *dev)
 	return ERR_PTR(err);
 }
 
+static int mlx5_esw_host_functions_enabled_query(struct mlx5_eswitch *esw)
+{
+	const u32 *query_host_out;
+
+	if (!mlx5_core_is_ecpf_esw_manager(esw->dev))
+		return 0;
+
+	query_host_out = mlx5_esw_query_functions(esw->dev);
+	if (IS_ERR(query_host_out))
+		return PTR_ERR(query_host_out);
+
+	esw->esw_funcs.host_funcs_disabled =
+		MLX5_GET(query_esw_functions_out, query_host_out,
+			 host_params_context.host_pf_not_exist);
+
+	kvfree(query_host_out);
+	return 0;
+}
+
 static void mlx5_eswitch_event_handler_register(struct mlx5_eswitch *esw)
 {
 	if (esw->mode == MLX5_ESWITCH_OFFLOADS && mlx5_eswitch_is_funcs_handler(esw->dev)) {
@@ -1871,6 +1890,10 @@ int mlx5_eswitch_init(struct mlx5_core_dev *dev)
 		goto abort;
 	}
 
+	err = mlx5_esw_host_functions_enabled_query(esw);
+	if (err)
+		goto abort;
+
 	err = mlx5_esw_vports_init(esw);
 	if (err)
 		goto abort;
diff --git a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
index 48fd0400ffd4e..be6e60d961689 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
+++ b/drivers/net/ethernet/mellanox/mlx5/core/eswitch.h
@@ -316,6 +316,7 @@ struct mlx5_host_work {
 
 struct mlx5_esw_functions {
 	struct mlx5_nb		nb;
+	bool			host_funcs_disabled;
 	u16			num_vfs;
 	u16			num_ec_vfs;
 };
-- 
2.51.0



