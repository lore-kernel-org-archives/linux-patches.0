Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6036C43E9DF;
	Thu, 30 Jul 2026 14:35:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422137; cv=none; b=qxW+rOxPsdbROKB6VIhatI+tnidf5OeIKevRUphq2h0Mx104uaXHMeEQ92x7cSCdvv/wtrfNdxQi0cbKH9qjulOoIxo6ptQIh0kvucxK+fZR+D9D2g5ghNpmQuH/WyegpqTrrF/wF3GfKbZ7MKwg47wyBDck0VzjqE/AGRPi8ks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422137; c=relaxed/simple;
	bh=2r1uHoBQ5bhBKfTbStvwCzTKV2dBf8Vv5yFBOfD+y8A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X0Ze9nQVzkfu5gZM5bUUTCEw8bK4BCqL9H/icokqOWz8Ps7hbyU1kYTj2HpUDGRlFJZkcIa6wlE+3c10hlv+90X9qG/UaRzN+dRxa+7e8GktMgCoqT8fhOz7isyWmFAG4b1DWrpx8nBXGfLjoHqMtdMlZDIQdiCFLFTZqmf75ms=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Mh+YobzA; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Mh+YobzA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E958B1F00A3F;
	Thu, 30 Jul 2026 14:35:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422133;
	bh=cUcA+hILhK5W+UlPBgENocvXubCrgZZJdwAD7SLG8vA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Mh+YobzA1Yc6esKjvhsUN+urHFddupEjIC787tvyiDE+q3RPGG+FahAH6y4HYfMnM
	 UfaqEPErWndosx1+NCYg9Zy2G75LLm3Jfp1FJsHaGtfMlY8bahru1MK5Q+FJpqJELR
	 xKPbXfROSwK4vtOeF8hcvuE9sXot97NQhDgCZtyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 336/744] net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule
Date: Thu, 30 Jul 2026 16:10:09 +0200
Message-ID: <20260730141451.424710462@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yael Chemla <ychemla@nvidia.com>

[ Upstream commit d12956d083eb70f2c6d72711aebaf8c2ce21e170 ]

esw_egress_acl_vlan_create() hardcodes num_dest=0 in its
mlx5_add_flow_rules() call. When invoked from the non-bond path
fwd_dest is NULL and num_dest=0 is correct. When invoked from
esw_acl_egress_ofld_rules_create() during a bond event, fwd_dest is
non-NULL and flow_act.action carries MLX5_FLOW_CONTEXT_ACTION_FWD_DEST,
but _mlx5_add_flow_rules() rejects a non-NULL dest pointer paired with
dest_num<=0 and returns -EINVAL. The error propagates as
"configure slave vport egress fwd, err(-22)". The passive vport's egress
ACL table ends up with its flow groups allocated but no FTEs, so
prio-tagged packets are not popped and bond failover is broken on
prio_tag_required devices.

Fix by passing fwd_dest ? 1 : 0 as num_dest to match the actual number
of destinations supplied.

Fixes: bf773dc0e6d5 ("net/mlx5: E-Switch, Introduce APIs to enable egress acl forward-to-vport rule")
Signed-off-by: Yael Chemla <ychemla@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Link: https://patch.msgid.link/20260717073306.1242399-1-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
index ba5cce706ea269..9693c74e9b16a4 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/acl/helper.c
@@ -71,7 +71,7 @@ int esw_egress_acl_vlan_create(struct mlx5_eswitch *esw,
 	flow_act.action = flow_action;
 	vport->egress.allowed_vlan =
 		mlx5_add_flow_rules(vport->egress.acl, spec,
-				    &flow_act, fwd_dest, 0);
+				    &flow_act, fwd_dest, fwd_dest ? 1 : 0);
 	if (IS_ERR(vport->egress.allowed_vlan)) {
 		err = PTR_ERR(vport->egress.allowed_vlan);
 		esw_warn(esw->dev,
-- 
2.53.0



