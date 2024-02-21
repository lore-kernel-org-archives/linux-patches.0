Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DF2B9762C1;
	Wed, 21 Feb 2024 13:28:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708522134; cv=none; b=PO0pINgYwZN3RDb6z50xvoCcgNdQ+Qpf1VCRVSvkeekj4NL1hayJTM9kS14HyXyNbi2FibtDP0z+YdZ9lDl/2wDrxpn7W1trj+gUhn66qUE3ti9vf5jGmmI7fSq++xgSFnv4W7n750fmoRyuapLsNa3iL7KOy6uEnCahMXUrDDA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708522134; c=relaxed/simple;
	bh=hKXnoXCsaq1jrSDj/sLs2a2JIf/NwwUbdudx2lTc8Qc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QHaPbjgZ52qZ3g1nApsdwj1qDc5k4X1s1AlETjbTuh8pspBZYGb22C/mX1WDeu/DR6UOZXALOOtrQAYP/deDurWUXyRj5XNH/3lwMpXkxm3laKfN7zNp1gfI6CpFhiHKTo7frFnQ1bNcGlwh0xZwoCkpKZuTbrhJNX90Nkbr0tg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EfiKN5bA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EfiKN5bA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4F325C433C7;
	Wed, 21 Feb 2024 13:28:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708522133;
	bh=hKXnoXCsaq1jrSDj/sLs2a2JIf/NwwUbdudx2lTc8Qc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EfiKN5bA2mrFEOQCm1/TsWTb70C5Z0HJzPfodwlv9iasAcHoKOa4DNIdFJLmWRorE
	 ujkn0zT+UC1nnR3mp9MfuVWJDZdwtDVQ3JrGg5yaKVqlc/r8lQ3buAeF92sdhaXJTk
	 4DFHhDi2B0mHszNWjBs+CLV4d4KZOA3CfT1jrREc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yevgeny Kliteynik <kliteyn@nvidia.com>,
	Erez Shitrit <erezsh@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 060/476] net/mlx5: DR, Cant go to uplink vport on RX rule
Date: Wed, 21 Feb 2024 14:01:51 +0100
Message-ID: <20240221130010.145929844@linuxfoundation.org>
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
index 1cd0276fc991..51453d082966 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/steering/dr_action.c
@@ -667,11 +667,17 @@ int mlx5dr_actions_build_ste_arr(struct mlx5dr_matcher *matcher,
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



