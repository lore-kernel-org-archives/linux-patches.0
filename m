Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 140B41C03
	for <patches@lists.linux.dev>; Mon, 20 Mar 2023 15:16:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B54EC433D2;
	Mon, 20 Mar 2023 15:16:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1679325366;
	bh=/IA41X6jVd4qri3IP5JsJS9aTdiSEyZvBtQ7Tq1RG8Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=chdLph4DCdQwggPl4qz9DYVMZnkJAtZqzNzTkf2PScBjUFLVA/xEbmC9I3EyAaO7r
	 tTdJBsVCMvJTqclDp2OU400Q1k8SzppnMJBrJbxLlX7SB2/pTaS56yXIV8JCJqTvJE
	 yKnRg4Qv4GfE5VTuifd1T306TvCmiCubMMsECXow=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maor Dickman <maord@nvidia.com>,
	Roi Dayan <roid@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 073/198] net/mlx5: E-switch, Fix missing set of split_count when forward to ovs internal port
Date: Mon, 20 Mar 2023 15:53:31 +0100
Message-Id: <20230320145510.604776282@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230320145507.420176832@linuxfoundation.org>
References: <20230320145507.420176832@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Maor Dickman <maord@nvidia.com>

[ Upstream commit 28d3815a629cbdee660dd1c9de28d77cb3d77917 ]

Rules with mirror actions are split to two FTEs when the actions after the mirror
action contains pedit, vlan push/pop or ct. Forward to ovs internal port adds
implicit header rewrite (pedit) but missing trigger to do split.

Fix by setting split_count when forwarding to ovs internal port which
will trigger split in mirror rules.

Fixes: 27484f7170ed ("net/mlx5e: Offload tc rules that redirect to ovs internal port")
Signed-off-by: Maor Dickman <maord@nvidia.com>
Reviewed-by: Roi Dayan <roid@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_tc.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
index 53b7d3775e8dc..a71eaa0601149 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_tc.c
@@ -4054,6 +4054,7 @@ int mlx5e_set_fwd_to_int_port_actions(struct mlx5e_priv *priv,
 
 	esw_attr->dest_int_port = dest_int_port;
 	esw_attr->dests[out_index].flags |= MLX5_ESW_DEST_CHAIN_WITH_SRC_PORT_CHANGE;
+	esw_attr->split_count = out_index;
 
 	/* Forward to root fdb for matching against the new source vport */
 	attr->dest_chain = 0;
-- 
2.39.2



