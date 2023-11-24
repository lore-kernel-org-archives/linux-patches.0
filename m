Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D96A381BF;
	Fri, 24 Nov 2023 18:33:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="N/Yr2YWg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B247C433C7;
	Fri, 24 Nov 2023 18:33:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700850827;
	bh=ayIA0WtwP6xwBdw3uMbwzxNM5JOncXNyCjUYf/de7Qg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=N/Yr2YWgVObqTQJpTRLmXltcLFoQjmVX6+bFUEG0H+iAlJ1opl2IkdSOoCAPqXxpD
	 p0s+CHL5mYZr6KM9sC6fxC1psROgLEYTecNhYj3J+cYMSJglDlz5mzvMfU39KVBNIa
	 PPKAP1xHk7V99gRvHq0/bXqKmpV1NjBA4P+dVyJc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cruz Zhao <cruzzhao@linux.alibaba.com>,
	Tianchen Ding <dtcccc@linux.alibaba.com>,
	Dust Li <dust.li@linux.alibaba.com>,
	Wojciech Drewek <wojciech.drewek@intel.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.5 205/491] net/mlx5e: fix double free of encap_header
Date: Fri, 24 Nov 2023 17:47:21 +0000
Message-ID: <20231124172030.668158576@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231124172024.664207345@linuxfoundation.org>
References: <20231124172024.664207345@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dust Li <dust.li@linux.alibaba.com>

[ Upstream commit 6f9b1a0731662648949a1c0587f6acb3b7f8acf1 ]

When mlx5_packet_reformat_alloc() fails, the encap_header allocated in
mlx5e_tc_tun_create_header_ipv4{6} will be released within it. However,
e->encap_header is already set to the previously freed encap_header
before mlx5_packet_reformat_alloc(). As a result, the later
mlx5e_encap_put() will free e->encap_header again, causing a double free
issue.

mlx5e_encap_put()
    --> mlx5e_encap_dealloc()
        --> kfree(e->encap_header)

This happens when cmd: MLX5_CMD_OP_ALLOC_PACKET_REFORMAT_CONTEXT fail.

This patch fix it by not setting e->encap_header until
mlx5_packet_reformat_alloc() success.

Fixes: d589e785baf5e ("net/mlx5e: Allow concurrent creation of encap entries")
Reported-by: Cruz Zhao <cruzzhao@linux.alibaba.com>
Reported-by: Tianchen Ding <dtcccc@linux.alibaba.com>
Signed-off-by: Dust Li <dust.li@linux.alibaba.com>
Reviewed-by: Wojciech Drewek <wojciech.drewek@intel.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c | 10 ++++------
 1 file changed, 4 insertions(+), 6 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
index 00a04fdd756f5..8bca696b6658c 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en/tc_tun.c
@@ -300,9 +300,6 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 	if (err)
 		goto destroy_neigh_entry;
 
-	e->encap_size = ipv4_encap_size;
-	e->encap_header = encap_header;
-
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
@@ -322,6 +319,8 @@ int mlx5e_tc_tun_create_header_ipv4(struct mlx5e_priv *priv,
 		goto destroy_neigh_entry;
 	}
 
+	e->encap_size = ipv4_encap_size;
+	e->encap_header = encap_header;
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv4_put(&attr);
@@ -568,9 +567,6 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 	if (err)
 		goto destroy_neigh_entry;
 
-	e->encap_size = ipv6_encap_size;
-	e->encap_header = encap_header;
-
 	if (!(nud_state & NUD_VALID)) {
 		neigh_event_send(attr.n, NULL);
 		/* the encap entry will be made valid on neigh update event
@@ -590,6 +586,8 @@ int mlx5e_tc_tun_create_header_ipv6(struct mlx5e_priv *priv,
 		goto destroy_neigh_entry;
 	}
 
+	e->encap_size = ipv6_encap_size;
+	e->encap_header = encap_header;
 	e->flags |= MLX5_ENCAP_ENTRY_VALID;
 	mlx5e_rep_queue_neigh_stats_work(netdev_priv(attr.out_dev));
 	mlx5e_route_lookup_ipv6_put(&attr);
-- 
2.42.0



