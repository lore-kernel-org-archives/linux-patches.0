Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08C261CD0C;
	Tue, 27 May 2025 17:26:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748366810; cv=none; b=QGplfdDpgjmQj1q6qCZ/1BsN6cdrnfu6mxQ3ww1V3Nf8WIRh3NE2CKfn7Li9wRc8RBv9NWD+zpElYxba0ndQflmm2X+DwTxicrcOph43w+URoA11Rif/RSeyDBPmtoi+TUl/ScV93w61L7JhzJTaXRfJhBFkI5BHq17KON2t9zE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748366810; c=relaxed/simple;
	bh=HungnwSrasTmNlyF6vSu8lcXiNTDbmo4nCey2/21YSg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Pxp2G/z+LMe19w2YieKMWkUJ65eD0jKVRG9lI6AQBoXXa0ZnH7vwHWB96hOm+Y4RZR0pVvgsXS6zCd3VPizAR3CK0h6MFY6xkfwzkWhWkBTq537LfMBQZ4qMqQf3yp/zQIQDm2mmNVI5fB9HkA9F4rugaw4LVUnlVJrsqNRx9ng=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xOSaWIMs; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xOSaWIMs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 33ECAC4CEE9;
	Tue, 27 May 2025 17:26:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748366809;
	bh=HungnwSrasTmNlyF6vSu8lcXiNTDbmo4nCey2/21YSg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xOSaWIMsz3Tx32w4APEFFO4drxhaXHtIKfKfvzAl8gHzbZ2aIWX1mKFIbJB3TpD60
	 /a6gRRIq2DYoELm1uCpnp7QC4kJGs++3S0T49sVx80cz6i7MA4w4AdYwzq+kBcD6wX
	 hbGLJrgfC9oNwxzHipwf5w+RmTsSNDgmn3YI3nQY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carolina Jubran <cjubran@nvidia.com>,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jacob Keller <jacob.e.keller@intel.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 152/783] net/mlx5: Preserve rate settings when creating a rate node
Date: Tue, 27 May 2025 18:19:09 +0200
Message-ID: <20250527162519.352738247@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162513.035720581@linuxfoundation.org>
References: <20250527162513.035720581@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Carolina Jubran <cjubran@nvidia.com>

[ Upstream commit f88c349c75e3784a3f5463f5b403ff28dd823782 ]

Modify `esw_qos_create_node_sched_elem()` to receive max_rate and
bw_share values while maintaining the previous configuration.

This change is essential for the upcoming patch that will modify rate
nodes and requires the existing settings to be preserved unless
explicitly changed.

Signed-off-by: Carolina Jubran <cjubran@nvidia.com>
Reviewed-by: Dragos Tatulea <dtatulea@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/1741642016-44918-4-git-send-email-tariqt@nvidia.com
Reviewed-by: Jacob Keller <jacob.e.keller@intel.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c | 13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
index 823c1ba456cd1..803bacf2a95e6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/qos.c
@@ -305,8 +305,9 @@ static int esw_qos_set_node_min_rate(struct mlx5_esw_sched_node *node,
 	return 0;
 }
 
-static int esw_qos_create_node_sched_elem(struct mlx5_core_dev *dev, u32 parent_element_id,
-					  u32 *tsar_ix)
+static int
+esw_qos_create_node_sched_elem(struct mlx5_core_dev *dev, u32 parent_element_id,
+			       u32 max_rate, u32 bw_share, u32 *tsar_ix)
 {
 	u32 tsar_ctx[MLX5_ST_SZ_DW(scheduling_context)] = {};
 	void *attr;
@@ -323,6 +324,8 @@ static int esw_qos_create_node_sched_elem(struct mlx5_core_dev *dev, u32 parent_
 		 SCHEDULING_CONTEXT_ELEMENT_TYPE_TSAR);
 	MLX5_SET(scheduling_context, tsar_ctx, parent_element_id,
 		 parent_element_id);
+	MLX5_SET(scheduling_context, tsar_ctx, max_average_bw, max_rate);
+	MLX5_SET(scheduling_context, tsar_ctx, bw_share, bw_share);
 	attr = MLX5_ADDR_OF(scheduling_context, tsar_ctx, element_attributes);
 	MLX5_SET(tsar_element, attr, tsar_type, TSAR_ELEMENT_TSAR_TYPE_DWRR);
 
@@ -396,7 +399,8 @@ __esw_qos_create_vports_sched_node(struct mlx5_eswitch *esw, struct mlx5_esw_sch
 	u32 tsar_ix;
 	int err;
 
-	err = esw_qos_create_node_sched_elem(esw->dev, esw->qos.root_tsar_ix, &tsar_ix);
+	err = esw_qos_create_node_sched_elem(esw->dev, esw->qos.root_tsar_ix, 0,
+					     0, &tsar_ix);
 	if (err) {
 		NL_SET_ERR_MSG_MOD(extack, "E-Switch create TSAR for node failed");
 		return ERR_PTR(err);
@@ -463,7 +467,8 @@ static int esw_qos_create(struct mlx5_eswitch *esw, struct netlink_ext_ack *exta
 	if (!MLX5_CAP_GEN(dev, qos) || !MLX5_CAP_QOS(dev, esw_scheduling))
 		return -EOPNOTSUPP;
 
-	err = esw_qos_create_node_sched_elem(esw->dev, 0, &esw->qos.root_tsar_ix);
+	err = esw_qos_create_node_sched_elem(esw->dev, 0, 0, 0,
+					     &esw->qos.root_tsar_ix);
 	if (err) {
 		esw_warn(dev, "E-Switch create root TSAR failed (%d)\n", err);
 		return err;
-- 
2.39.5



