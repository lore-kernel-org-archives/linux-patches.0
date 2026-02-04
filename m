Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B096F421892;
	Wed,  4 Feb 2026 15:26:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218764; cv=none; b=FcLtiaP18tI6GQeON2mxb8wGSpqCPIn9N0MUe9a08TvogMgGIQjMlpueM0RvhZCG8ygcA7h0VWhbl6ATzwRep4vBDSU5R2mJAFNoUkqPiMqNRdRPL+B3b5V03uHk181l3JmDz8RZNeHH/XjHrBvLK0lFm+LHzyrXAfqhQPAkphQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218764; c=relaxed/simple;
	bh=LW+e3F+Xbmf2yW5jvwEqP1N3wacmohLW+st2B2Po8sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=e/KwStkSJUZKfr7lmvCQDwRc0lt0B+aYXKQij9/iecwMXeZO8jUP8ZCXOHbAVW5W+KqkGQFLLOMdm/C/JbOSNlsr9qweN6tm2cQSQBY9u45TtI72Hnnz0R7pq+0oyyYemBC6JMepAW16wBvgvZQtYf7Nm8G96jHbjJnKH4omHjQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mNLqBORP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mNLqBORP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20E3FC4CEF7;
	Wed,  4 Feb 2026 15:26:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218764;
	bh=LW+e3F+Xbmf2yW5jvwEqP1N3wacmohLW+st2B2Po8sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mNLqBORPf/qa81aw2pR6xboN/EGq4xPIcHgywo8o+0ryjlL++ji2mx/IJUDk/f9oe
	 rrTY18idVk/bKEsB/Y/lfFvJd5KjT20mPDVu3N0c9ZuXofc+C3ktDdQPCtmt8+BNxk
	 GWQ05/MN4sVYZ/Bjt5pF8TRoVJjA94+dXx8JD96k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Carolina Jubran <cjubran@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 21/87] net/mlx5: Initialize events outside devlink lock
Date: Wed,  4 Feb 2026 15:40:19 +0100
Message-ID: <20260204143847.673940751@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit b6b03097f9826db72aeb3f751774c5e9edd9a5b3 ]

Move event init/cleanup outside of mlx5_init_one() / mlx5_uninit_one()
and into the mlx5_mdev_init() / mlx5_mdev_uninit() functions.

By doing this, we avoid the events being reinitialized on devlink reload
and, more importantly, the events->sw_nh notifier chain becomes
available earlier in the init procedure, which will be used in
subsequent patches. This makes sense because the events struct is pure
software, independent of any HW details.

Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Carolina Jubran <cjubran@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1763325940-1231508-2-git-send-email-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: a8f930b7be7b ("net/mlx5: Fix vhca_id access call trace use before alloc")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/main.c    | 34 +++++++++++++------
 1 file changed, 24 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/main.c b/drivers/net/ethernet/mellanox/mlx5/core/main.c
index e97b3494b9161..4ed23d19c0eca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/main.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/main.c
@@ -1016,16 +1016,10 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 		goto err_irq_cleanup;
 	}
 
-	err = mlx5_events_init(dev);
-	if (err) {
-		mlx5_core_err(dev, "failed to initialize events\n");
-		goto err_eq_cleanup;
-	}
-
 	err = mlx5_fw_reset_init(dev);
 	if (err) {
 		mlx5_core_err(dev, "failed to initialize fw reset events\n");
-		goto err_events_cleanup;
+		goto err_eq_cleanup;
 	}
 
 	mlx5_cq_debugfs_init(dev);
@@ -1121,8 +1115,6 @@ static int mlx5_init_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
-err_events_cleanup:
-	mlx5_events_cleanup(dev);
 err_eq_cleanup:
 	mlx5_eq_table_cleanup(dev);
 err_irq_cleanup:
@@ -1155,7 +1147,6 @@ static void mlx5_cleanup_once(struct mlx5_core_dev *dev)
 	mlx5_cleanup_reserved_gids(dev);
 	mlx5_cq_debugfs_cleanup(dev);
 	mlx5_fw_reset_cleanup(dev);
-	mlx5_events_cleanup(dev);
 	mlx5_eq_table_cleanup(dev);
 	mlx5_irq_table_cleanup(dev);
 	mlx5_unregister_hca_devcom_comp(dev);
@@ -1829,6 +1820,24 @@ static int vhca_id_show(struct seq_file *file, void *priv)
 
 DEFINE_SHOW_ATTRIBUTE(vhca_id);
 
+static int mlx5_notifiers_init(struct mlx5_core_dev *dev)
+{
+	int err;
+
+	err = mlx5_events_init(dev);
+	if (err) {
+		mlx5_core_err(dev, "failed to initialize events\n");
+		return err;
+	}
+
+	return 0;
+}
+
+static void mlx5_notifiers_cleanup(struct mlx5_core_dev *dev)
+{
+	mlx5_events_cleanup(dev);
+}
+
 int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 {
 	struct mlx5_priv *priv = &dev->priv;
@@ -1884,6 +1893,10 @@ int mlx5_mdev_init(struct mlx5_core_dev *dev, int profile_idx)
 	if (err)
 		goto err_hca_caps;
 
+	err = mlx5_notifiers_init(dev);
+	if (err)
+		goto err_hca_caps;
+
 	/* The conjunction of sw_vhca_id with sw_owner_id will be a global
 	 * unique id per function which uses mlx5_core.
 	 * Those values are supplied to FW as part of the init HCA command to
@@ -1926,6 +1939,7 @@ void mlx5_mdev_uninit(struct mlx5_core_dev *dev)
 	if (priv->sw_vhca_id > 0)
 		ida_free(&sw_vhca_ida, dev->priv.sw_vhca_id);
 
+	mlx5_notifiers_cleanup(dev);
 	mlx5_hca_caps_free(dev);
 	mlx5_adev_cleanup(dev);
 	mlx5_pagealloc_cleanup(dev);
-- 
2.51.0



