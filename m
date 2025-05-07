Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3018823DE;
	Wed,  7 May 2025 19:01:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644516; cv=none; b=FrqX+jVB4paAKKuj4KYuYq+t8hEACh4u05kNKvTfmuyYCPQcYrHz60WYqoU1czw+q9V/8rpzYrldwV4mxGLhipNSnRzGqCht7FdJVgohOhkCdonoDXYqnDfKTD9AApR4PFp0bzBkm/0HPOwgeldh/NW9hT6kbc+K6PCRc2StMF8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644516; c=relaxed/simple;
	bh=GveBhhBYbt8Pi5SkR+4OUTW7AcLk5PUiuSCrA0N9HWE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QKYdk9wvqaEbH7MC8DP02wu2I+HwKT+TqPxbmUmeQdk9vn2J5fTv4A+T0orm6IU9TcxsA8wYk+y6rZHI/p33nm+/yXB2bow97mauO6Ti3IrZAA9++ZgUyFTl2w4QL90K0nkpuX69QdEQkbk7MYzJej4T+2KZv45sqD/ypjbYH0o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=09y1B8vd; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="09y1B8vd"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D1B6C4CEE2;
	Wed,  7 May 2025 19:01:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644515;
	bh=GveBhhBYbt8Pi5SkR+4OUTW7AcLk5PUiuSCrA0N9HWE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=09y1B8vds11gnRHq4oBEtEoIQ2tovUGZeeTc5AS6k87E5/ov/7boLHSKcRgfBTOAm
	 BjRwBWcIYExt19Sh1ZJnTbYImJEGhW8Ji59byjA5yuc0S25q1eTyVfc4JsbF68eKWt
	 iU2fFtpZux9oyHfIzKQB25x46dEh2GV5RuEyvYdo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Mark Bloch <mbloch@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 069/164] net/mlx5e: TC, Continue the attr process even if encap entry is invalid
Date: Wed,  7 May 2025 20:39:14 +0200
Message-ID: <20250507183823.754057086@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183820.781599563@linuxfoundation.org>
References: <20250507183820.781599563@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 172c034264c894518c012387f2de2f9d6443505d ]

Previously the offload of the rule with header rewrite and mirror to
both internal and external destinations is skipped if the encap entry
is not valid. But it shouldn't because driver will try to offload it
again if neighbor is updated and encap entry is valid, to replace the
old FTE added for slow path. But the extra split attr doesn't exist at
that time as the process is skipped, driver then fails to offload it.
To fix this issue, remove the checking and continue the attr process
if encap entry is invalid.

Fixes: b11bde56246e ("net/mlx5e: TC, Offload rewrite and mirror to both internal and external dests")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Mark Bloch <mbloch@nvidia.com>
Link: https://patch.msgid.link/20250423083611.324567-4-mbloch@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 5 +----
 1 file changed, 1 insertion(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 6b3b1afe83121..218d5402cd1a6 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -1750,9 +1750,6 @@ extra_split_attr_dests_needed(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr
 	    !list_is_first(&attr->list, &flow->attrs))
 		return 0;
 
-	if (flow_flag_test(flow, SLOW))
-		return 0;
-
 	esw_attr = attr->esw_attr;
 	if (!esw_attr->split_count ||
 	    esw_attr->split_count == esw_attr->out_count - 1)
@@ -1766,7 +1763,7 @@ extra_split_attr_dests_needed(struct mlx5e_tc_flow *flow, struct mlx5_flow_attr
 	for (i = esw_attr->split_count; i < esw_attr->out_count; i++) {
 		/* external dest with encap is considered as internal by firmware */
 		if (esw_attr->dests[i].vport == MLX5_VPORT_UPLINK &&
-		    !(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP_VALID))
+		    !(esw_attr->dests[i].flags & MLX5_ESW_DEST_ENCAP))
 			ext_dest = true;
 		else
 			int_dest = true;
-- 
2.39.5



