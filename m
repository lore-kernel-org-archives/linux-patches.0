Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C3DDFA93F
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:08:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C407C433EF;
	Tue, 10 Jan 2023 18:08:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673374133;
	bh=C6aaC7dEEj/94roJOoP9V7BTOQZCt8kHmoXOk/GmSL4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZkvxiuMrNTv55x8Ot8akxLZg+rGqYguSOEX457wgNghGQUcNBYZZ13jRMahO4XkeI
	 tQLr+ud8WqYgSuk6lmZsJoc3e8RaYFwqVC9s5/8cwI11oiuO6mRVNrhxJNay+l49Hh
	 K9b7gNb9EU/qgig2Y5kQIgtyGmuGhPS6xYZUQi3Y=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 057/148] net/mlx5e: Always clear dest encap in neigh-update-del
Date: Tue, 10 Jan 2023 19:02:41 +0100
Message-Id: <20230110180019.037645548@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180017.145591678@linuxfoundation.org>
References: <20230110180017.145591678@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Chris Mi <cmi@nvidia.com>

[ Upstream commit 2951b2e142ecf6e0115df785ba91e91b6da74602 ]

The cited commit introduced a bug for multiple encapsulations flow.
If one dest encap becomes invalid, the flow is set slow path flag.
But when other dests encap become invalid, they are not cleared due
to slow path flag of the flow. When neigh-update-add is running, it
will use invalid encap.

Fix it by checking slow path flag after clearing dest encap.

Fixes: 9a5f9cc794e1 ("net/mlx5e: Fix possible use-after-free deleting fdb rule")
Signed-off-by: Chris Mi <cmi@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c    | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
index ff73d25bc6eb..2aaf8ab857b8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -222,7 +222,7 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
+		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
 
 		attr = mlx5e_tc_get_encap_attr(flow);
@@ -231,6 +231,13 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 		esw_attr->dests[flow->tmp_entry_index].flags &= ~MLX5_ESW_DEST_ENCAP_VALID;
 		esw_attr->dests[flow->tmp_entry_index].pkt_reformat = NULL;
 
+		/* Clear pkt_reformat before checking slow path flag. Because
+		 * in next iteration, the same flow is already set slow path
+		 * flag, but still need to clear the pkt_reformat.
+		 */
+		if (flow_flag_test(flow, SLOW))
+			continue;
+
 		/* update from encap rule to slow path rule */
 		spec = &flow->attr->parse_attr->spec;
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
-- 
2.35.1



