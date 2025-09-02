Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BD522DF3CF;
	Tue,  2 Sep 2025 13:38:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756820335; cv=none; b=HtrZYT2g6rNYmsc4uZzPsmogCBhlGYKxIejGUmOMImGf6Dry71l7KPUEZzp2Mf/9/46OA2vqQMPliv0X+EI2CfL9Qk6+khDMD38I59H9zi9rpsmDFzHXzyF9rloWTkZm6KDpoNlMYs3huWc0z7Ws57LnXcxn9UthzwC/JeLf6F0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756820335; c=relaxed/simple;
	bh=UxcVC4YzPNsejQNOGdgfoRBK/u5W8lpUukAc/Tz9hG8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xqit8qAaoCGPYNTmMiCBNMgodupVixAT4f5GRXA2yFpjzA8jcCZSzxCnFwm0sl9KjcoNNa905Jyy3nPk8C4dPIIGbNYveEapjozd4edNBxOtBynGU3BndQTFgLD5GGTfWKLLDoF9SbcayvBAroQHiHxEFnn4mp3bHbi3+oCztD4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lBYlklAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lBYlklAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06339C4CEED;
	Tue,  2 Sep 2025 13:38:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756820335;
	bh=UxcVC4YzPNsejQNOGdgfoRBK/u5W8lpUukAc/Tz9hG8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lBYlklAvXXhEMX0MMlbGUPVKV7FgpMvC7iLYIgRKhQDIie5h4yrehtE8/l0JOC+0k
	 LCfkwltmYKDWCgUTETdgUN9LrZayq2Vnw8AsKXf9m9iaOXZtkBfMf8Hvlbm0VmGLmp
	 I7b6BcpmKsF6ep4HwaHLD6RxbiDUzsmMSHfj/Bxo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Shay Drory <shayd@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 40/75] net/mlx5: Call mlx5_sf_id_erase() once in mlx5_sf_dealloc()
Date: Tue,  2 Sep 2025 15:20:52 +0200
Message-ID: <20250902131936.692602936@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20250902131935.107897242@linuxfoundation.org>
References: <20250902131935.107897242@linuxfoundation.org>
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

From: Jiri Pirko <jiri@nvidia.com>

[ Upstream commit 2597ee190b4eb48d3b7d35b7bb2cc18046ae087e ]

Before every call of mlx5_sf_dealloc(), there is a call to
mlx5_sf_id_erase(). So move it to the beginning of mlx5_sf_dealloc().
Also remove redundant mlx5_sf_id_erase() call from mlx5_sf_free()
as it is called only from mlx5_sf_dealloc().

Signed-off-by: Jiri Pirko <jiri@nvidia.com>
Reviewed-by: Shay Drory <shayd@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 26e42ec7712d ("net/mlx5: Nack sync reset when SFs are present")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
index e34a8f88c518c..1dd01701df20e 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/sf/devlink.c
@@ -111,7 +111,6 @@ mlx5_sf_alloc(struct mlx5_sf_table *table, struct mlx5_eswitch *esw,
 
 static void mlx5_sf_free(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
-	mlx5_sf_id_erase(table, sf);
 	mlx5_sf_hw_table_sf_free(table->dev, sf->controller, sf->id);
 	trace_mlx5_sf_free(table->dev, sf->port_index, sf->controller, sf->hw_fn_id);
 	kfree(sf);
@@ -361,6 +360,8 @@ int mlx5_devlink_sf_port_new(struct devlink *devlink,
 
 static void mlx5_sf_dealloc(struct mlx5_sf_table *table, struct mlx5_sf *sf)
 {
+	mlx5_sf_id_erase(table, sf);
+
 	if (sf->hw_state == MLX5_VHCA_STATE_ALLOCATED) {
 		mlx5_sf_free(table, sf);
 	} else if (mlx5_sf_is_active(sf)) {
@@ -401,7 +402,6 @@ int mlx5_devlink_sf_port_del(struct devlink *devlink,
 	}
 
 	mlx5_eswitch_unload_sf_vport(esw, sf->hw_fn_id);
-	mlx5_sf_id_erase(table, sf);
 
 	mutex_lock(&table->sf_state_lock);
 	mlx5_sf_dealloc(table, sf);
@@ -473,7 +473,6 @@ static void mlx5_sf_deactivate_all(struct mlx5_sf_table *table)
 	 */
 	xa_for_each(&table->port_indices, index, sf) {
 		mlx5_eswitch_unload_sf_vport(esw, sf->hw_fn_id);
-		mlx5_sf_id_erase(table, sf);
 		mlx5_sf_dealloc(table, sf);
 	}
 }
-- 
2.50.1



