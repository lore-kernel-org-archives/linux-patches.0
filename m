Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 82A0979DF;
	Sat, 30 Dec 2023 12:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Q33JMx3u"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0AB78C433C7;
	Sat, 30 Dec 2023 12:02:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937764;
	bh=EbSFyYZvtUrAXgupq9AYtgB4CMa5OBrCrAT9fPULWmc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Q33JMx3u1iY4a0YIrVJkUAsKkboLz7RGxksf4rABcAGBqkxVpquRulOM3JLkBfGBE
	 fHKiJQAzsUtGzCGjzMtrr8MgzIkufUsIw61AADQyPFu6AZSTLVR7iMhm2WTdb9axJy
	 VBVq3zfZdhHdj87+x0YzB5/tZWA/2qPl170tjcQk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vlad Buslov <vladbu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 030/156] Revert "net/mlx5e: fix double free of encap_header in update funcs"
Date: Sat, 30 Dec 2023 11:58:04 +0000
Message-ID: <20231230115813.353899485@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231230115812.333117904@linuxfoundation.org>
References: <20231230115812.333117904@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vlad Buslov <vladbu@nvidia.com>

[ Upstream commit 66ca8d4deca09bce3fc7bcf8ea7997fa1a51c33c ]

This reverts commit 3a4aa3cb83563df942be49d145ee3b7ddf17d6bb.

This patch is causing a null ptr issue, the proper fix is in the next
patch.

Fixes: 3a4aa3cb8356 ("net/mlx5e: fix double free of encap_header in update funcs")
Signed-off-by: Vlad Buslov <vladbu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/mellanox/mlx5/core/en/tc_tun.c   | 20 +++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 668da5c70e63d..8bca696b6658c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -403,12 +403,16 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 	if (err)
 		goto free_encap;
 
+	e->encap_size = ipv4_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto free_encap;
+		goto release_neigh;
 	}
 
 	memset(&reformat_params, 0, sizeof(reformat_params));
@@ -422,10 +426,6 @@ int mlx5e_tc_tun_update_header_ipv4(struct mlx5e_priv *priv,
 		goto free_encap;
 	}
 
-	e->encap_size = ipv4_encap_size;
-	kfree(e->encap_header);
-	e->encap_header = encap_header;
-
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv4_put(&attr);
@@ -669,12 +669,16 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 	if (err)
 		goto free_encap;
 
+	e->encap_size = ipv6_encap_size;
+	kfree(e->encap_header);
+	e->encap_header = encap_header;
+
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
 		 * and not used before that.
 		 */
-		goto free_encap;
+		goto release_neigh;
 	}
 
 	memset(&reformat_params, 0, sizeof(reformat_params));
@@ -688,10 +692,6 @@ int mlx5e_tc_tun_update_header_ipv6(struct mlx5e_priv *priv,
 		goto free_encap;
 	}
 
-	e->encap_size = ipv6_encap_size;
-	kfree(e->encap_header);
-	e->encap_header = encap_header;
-
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv6_put(&attr);
-- 
2.43.0



