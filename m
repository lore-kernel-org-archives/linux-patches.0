Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8EA5E33438F;
	Thu, 30 Jul 2026 15:38:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785425927; cv=none; b=Fg9tL6GQuXmoKAnqaYhr9vSp3oViFn5Gf3PhQhTxJ3j1Zivc2dJfYtuLaEDl6jmeeKXUqfghyiL0GfGqyNU33Jgu0pi0902SEfUdTDFUuGp5e2T7qk6Xsk3j+SNMWBb5t3txmMwIFtAnVAyGXlI/+JPba7BZBqi/pgi1mOwy9f4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785425927; c=relaxed/simple;
	bh=0TGVSOHOa95bpXiDXfc2wU2vAQjNE1OR4JAEP/HfbOU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dvKsZM0YEj+nTqamKVI8AiCopda3gixF8b0Ckc10d9BAco5KvDyhPeWeQ1q0f1L/6uQiEP+n9TzRMIrbmWUROXNlby5WlVStBbox87CNd7PtEvC59vxFOB/lX1GRmpaD2T60frUntk3H41j5E+rvhnSqbhNQPzDmfvEXchi5/i8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GSiED/8y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GSiED/8y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EA4601F000E9;
	Thu, 30 Jul 2026 15:38:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785425926;
	bh=JPLJ5domnhyx2XU95TT7YjkIdMwMYJDAF9ap+kKRBI0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=GSiED/8yxRemgB8WgKzt+NsrfuTnFhQ7OAWlkWAtP68ktF80CPRXV+v7cWIT3W5J9
	 dsSvu1IORgwYDdvIyN0NRkN2+mZoo9CwCZ5j3rKMBPRNTmMYlVqYIHea53FHRAqzQO
	 zzbHpFF6GU8CudzJlxFEEndAfEI4smls2TpyhQQE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yael Chemla <ychemla@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 241/602] net/mlx5: E-Switch, fix zero num_dest in prio_tag egress vlan rule
Date: Thu, 30 Jul 2026 16:10:33 +0200
Message-ID: <20260730141441.036828144@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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
index d599e50af346be..fc545bfb54de76 100644
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



