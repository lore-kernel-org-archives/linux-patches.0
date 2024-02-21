Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1B627B3F2;
	Wed, 21 Feb 2024 13:28:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522130; cv=none; b=TLF2mFzEspzdUfaD6d+ymwhV2m0uuY/8fa9PZARsAzMNm9wU2IkPwNEpbecrxOQ60GmkuK8403OFH4ySgifMZkapYrWolOnyT+ZlUDQ/KN7nfArHK3ksjGF44KTJkAhkc7J1SUNLKUOYlzCfme+IhF7GXqKx9QxjU1wSMlwc8pI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522130; c=relaxed/simple;
	bh=OdDcmyN1RXWQk9mqvEedD3kP5lPMpxhlTswOcI2gCgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uhkYDu/Fek+7pfh8rZrlQN2+VWdca1YkPba/wrFxMdk4S8G0N5maxyh1YVNYvali+wuV/Bj1FBP72aWAElZLTMuwC8IDEHgh2vZcoB9ShWwUPBzyu+UpAX6kaXRYPV/oR1DINlHY3zAmTUeTGau7eBNBWKKKK3purxV5UyVr54M=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D8Dsh5Hr; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D8Dsh5Hr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0B78FC433F1;
	Wed, 21 Feb 2024 13:28:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522130;
	bh=OdDcmyN1RXWQk9mqvEedD3kP5lPMpxhlTswOcI2gCgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=D8Dsh5Hr+Jfq9KuObHjVOHJB2aBod8XzIWpHBbPDW/31VYhpjSAMxPrTyVG6gWF4m
	 dRAh6gvdHfFkx5PEZwLSV6s4oO743zIWgS4cKzZ0WGZJmbufzI+3aEOb13AZiJDgVo
	 qfTAirzR+dCCVz2L+UoGgyD+w1+zcHOFmU6RKgpo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shun Hao <shunh@nvidia.com>,
	Alex Vesker <valex@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 059/476] net/mlx5: DR, Align mlx5dv_dr API vport action with FW behavior
Date: Wed, 21 Feb 2024 14:01:50 +0100
Message-ID: <20240221130010.114739161@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240221130007.738356493@linuxfoundation.org>
References: <20240221130007.738356493@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shun Hao <shunh@nvidia.com>

[ Upstream commit aa818fbf8f36e8c6f3e608ea960567906c2d6112 ]

This aligns the behavior with FW when creating an FDB rule with wire
vport destination but no source port matching. Until now such rules
would fail on internal DR RX rule creation since the source and
destination are the wire vport.
The new behavior is the same as done on FW steering, if destination is
wire, we will create both TX and RX rules, but the RX packet coming from
wire will be dropped due to loopback not supported.

Signed-off-by: Shun Hao <shunh@nvidia.com>
Reviewed-by: Alex Vesker <valex@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Stable-dep-of: 5b2a2523eeea ("net/mlx5: DR, Can't go to uplink vport on RX rule")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/steering/dr_action.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
index 3f074d09a5fc..1cd0276fc991 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -669,15 +669,9 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
 		case DR_ACTION_TYP_VPORT:
 			attr.hit_gvmi = action->vport->caps->vhca_gvmi;
 			dest_action = action;
-			if (rx_rule) {
-				if (action->vport->caps->num == MLX5_VPORT_UPLINK) {
-					mlx5dr_dbg(dmn, "Device doesn't support Loopback on WIRE vport\n");
-					return -EOPNOTSUPP;
-				}
-				attr.final_icm_addr = action->vport->caps->icm_address_rx;
-			} else {
-				attr.final_icm_addr = action->vport->caps->icm_address_tx;
-			}
+			attr.final_icm_addr = rx_rule ?
+				action->vport->caps->icm_address_rx :
+				action->vport->caps->icm_address_tx;
 			break;
 		case DR_ACTION_TYP_POP_VLAN:
 			if (!rx_rule && !(dmn->ste_ctx->actions_caps &
-- 
2.43.0



