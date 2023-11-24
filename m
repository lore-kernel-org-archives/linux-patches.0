Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C1F3328DBB;
	Fri, 24 Nov 2023 18:52:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fJBd4AzS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2326DC433C7;
	Fri, 24 Nov 2023 18:52:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700851926;
	bh=hu3xzNlmkS5ukdK3b52Ecd27D+ASnenPs6+yGwBNGKQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fJBd4AzSfgdytmx+8rcFu3yDMOG9H9x283uv4tqL9vnu0oHRTudzNascrmdbhQBB+
	 j9YgYDKXmYAUcsMELVzR4BZ0o+dRVFzjdD1LdCkEEk0b1uJJ8GiCt0Ye4P2euWq6wg
	 6+LoIE/9FYTdOK2CbZQjpujlJMn+BL5ZGi8I7kFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gavin Li <gavinl@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 151/372] net/mlx5e: fix double free of encap_header in update funcs
Date: Fri, 24 Nov 2023 17:48:58 +0000
Message-ID: <20231124172015.516120710@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172010.413667921@linuxfoundation.org>
References: <20231124172010.413667921@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gavin Li <gavinl@nvidia.com>

[ Upstream commit 3a4aa3cb83563df942be49d145ee3b7ddf17d6bb ]

Follow up to the previous patch to fix the same issue for
mlx5e_tc_tun_update_header_ipv4{6} when mlx5_packet_reformat_alloc()
fails.

When mlx5_packet_reformat_alloc() fails, the encap_header allocated in
mlx5e_tc_tun_update_header_ipv4{6} will be released within it. However,
e->encap_header is already set to the previously freed encap_header
before mlx5_packet_reformat_alloc(). As a result, the later
mlx5e_encap_put() will free e->encap_header again, causing a double free
issue.

mlx5e_encap_put()
     --> mlx5e_encap_dealloc()
         --> kfree(e->encap_header)

This patch fix it by not setting e->encap_header until
mlx5_packet_reformat_alloc() success.

Fixes: a54e20b4fcae ("net/mlx5e: Add basic TC tunnel set action for SRIOV offloads")
Signed-off-by: Gavin Li <gavinl@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Link: https://lore.kernel.org/r/20231114215846.5902-7-saeed@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index ccfc626c37d48..4db0483c066a8 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -403,16 +403,12 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 	if (err)
 		goto free_encap;
 
-	e->encap_size = ipv4_encap_size;
-	kfree(e->encap_header);
-	e->encap_header = encap_header;
-
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto release_neigh;
+		goto free_encap;
 	}
 
 	memset(&reformat_params, 0, sizeof(reformat_params));
@@ -426,6 +422,10 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 		goto free_encap;
 	}
 
+	e->encap_size = ipv4_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv4_put(&attr);
@@ -669,16 +669,12 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 	if (err)
 		goto free_encap;
 
-	e->encap_size = ipv6_encap_size;
-	kfree(e->encap_header);
-	e->encap_header = encap_header;
-
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto release_neigh;
+		goto free_encap;
 	}
 
 	memset(&reformat_params, 0, sizeof(reformat_params));
@@ -692,6 +688,10 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 		goto free_encap;
 	}
 
+	e->encap_size = ipv6_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv6_put(&attr);
-- 
2.42.0



