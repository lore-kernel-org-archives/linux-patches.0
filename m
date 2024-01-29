Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ACB22157031;
	Mon, 29 Jan 2024 17:09:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548154; cv=none; b=RCPBWlg0tqV8M/zi1Sszx7xhs1HBYKHt/wUg2Gz072J91Bo0dMo0wA9ahTxgdGIIGeUUydwQSSiXjvNILwVFoGImmdR+NrNR3b3+PzNQ6frFqYR4sfuCuDtVRO7XZcg93le9N1x8yfDYnwHBUVjyVNJa3rMB0EHCb3LjSOrgZy8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548154; c=relaxed/simple;
	bh=bjZ2zgupQrXT0xdlFR7tABmQeLFKsRUKscZ2mKcSAFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HFOguUqWkSTmCP6sfP5hH97BIgpTgTqnlLg6ybXMI+TkEFO3MSqTENchDeceVYXWCnqFygKDoOChnv4JeDkRIJBnTIbiup/9V++psttlvHqf9dzzgqIYnVA1bKlYDcoFIoO48LmzB+UDRNUt4BYVGzAezDAICd67H0jf4r4S7yU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k+rRk4J/; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k+rRk4J/"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 745C0C433F1;
	Mon, 29 Jan 2024 17:09:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548154;
	bh=bjZ2zgupQrXT0xdlFR7tABmQeLFKsRUKscZ2mKcSAFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k+rRk4J/sSgRcfInhg4MW5dTMCgov7X+0D02cBNCJBulESvc9FbTgZgQidF97rZDm
	 bPpt4vcFgpO88WvLpFqGQWa1IBsOUQsfRxhYO/babU/1/z9GXMQEYlIX7ZXgGQB+lf
	 GQ27uvzvkBtVnBj66WkB6vcKGhGSXXK1f+40PuQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.7 192/346] net/mlx5: DR, Cant go to uplink vport on RX rule
Date: Mon, 29 Jan 2024 09:03:43 -0800
Message-ID: <20240129170022.051511082@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170016.356158639@linuxfoundation.org>
References: <20240129170016.356158639@linuxfoundation.org>
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

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yevgeny Kliteynik <kliteyn@nvidia.com>

[ Upstream commit 5b2a2523eeea5f03d39a9d1ff1bad2e9f8eb98d2 ]

Go-To-Vport action on RX is not allowed when the vport is uplink.
In such case, the packet should be dropped.

Fixes: 9db810ed2d37 ("net/mlx5: DR, Expose steering action functionality")
Signed-off-by: Yevgeny Kliteynik <kliteyn@nvidia.com>
Reviewed-by: Erez Shitrit <erezsh@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../mellanox/mlx5/core/steering/dr_action.c      | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 74fc318b5027..d2b65a0ce47b 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -874,11 +874,17 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 							action->sampler->tx_icm_addr;
 			break;
 		case DR_ACTION_TYP_VPORT:
-			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
-			dest_action = action;
-			attr.final_icm_addr = rx_rule ?
-				action->vport->caps->icm_address_rx :
-				action->vport->caps->icm_address_tx;
+			if (unlikely(rx_rule && action->vport->caps->num == MLX5_VPORT_UPLINK)) {
+				/* can't go to uplink on RX rule - dropping instead */
+				attr.final_icm_addr = nic_dmn->drop_icm_addr;
+				attr.hit_gvmi = nic_dmn->drop_icm_addr >> 48;
+			} else {
+				attr.hit_gvmi = action->vport->caps->vhca_gvmi;
+				dest_action = action;
+				attr.final_icm_addr = rx_rule ?
+						      action->vport->caps->icm_address_rx :
+						      action->vport->caps->icm_address_tx;
+			}
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
 			if (!rx_rule && !(dmn->ste_ctx->actions_caps &
-- 
2.43.0



