Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39CE96FBB
	for <patches@lists.linux.dev>; Tue, 10 Jan 2023 18:32:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB7D6C433EF;
	Tue, 10 Jan 2023 18:32:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673375555;
	bh=qByWPVrL98Y6KtiGg5+/3GLGRTU8oh/YauQRgeycSE4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OU5+Yop+CN+VNeJ+cGffozb7jbxgD2fpUb6VNQq6nIjkjwjROnvdInmp2R6cLuJ1Y
	 GRfY6cCSfLDwxJJS58qb4f9jnzlfVx5eoZTXIdwxS5agzS9Phm08KywI5TmiSZQGuZ
	 55wEooDnNcVy+1pM3KQWkG8GagAUIGU1HiqK/nMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chris Mi <cmi@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 227/290] net/mlx5e: Always clear dest encap in neigh-update-del
Date: Tue, 10 Jan 2023 19:05:19 +0100
Message-Id: <20230110180039.848723073@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230110180031.620810905@linuxfoundation.org>
References: <20230110180031.620810905@linuxfoundation.org>
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
index 3b63d9c20580..a8d7f07ee2ca 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun_encap.c
@@ -188,12 +188,19 @@ void mlx5e_tc_encap_flows_del(struct mlx5e_priv *priv,
 	int err;
 
 	list_for_each_entry(flow, flow_list, tmp_list) {
-		if (!mlx5e_is_offloaded_flow(flow) || flow_flag_test(flow, SLOW))
+		if (!mlx5e_is_offloaded_flow(flow))
 			continue;
 		attr = flow->attr;
 		esw_attr = attr->esw_attr;
 		spec = &attr->parse_attr->spec;
 
+		/* Clear pkt_reformat before checking slow path flag. Because
+		 * in next iteration, the same flow is already set slow path
+		 * flag, but still need to clear the pkt_reformat.
+		 */
+		if (flow_flag_test(flow, SLOW))
+			continue;
+
 		/* update from encap rule to slow path rule */
 		rule = mlx5e_tc_offload_to_slow_path(esw, flow, spec);
 		/* mark the flow's encap dest as non-valid */
-- 
2.35.1



