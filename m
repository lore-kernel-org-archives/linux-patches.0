Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 072481C280;
	Wed,  3 Jan 2024 17:09:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SlNUOu+y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60774C433C7;
	Wed,  3 Jan 2024 17:09:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704301775;
	bh=6/u/YvHfh7j0IyEp3zunlwM75jIiPC+WCy2Jar4ydnY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SlNUOu+yoEEwobQHO4C+OBHndy4y+yse2wHEVtE9PWAitYnMbJQJhA79EMXFvVkG3
	 5ZYV7JzS7NhS1nkVtc7C0y74ejR7bS+/RviGFuAZhodKGKhXEVDsV8DDET2dGjJQCI
	 TKf4y8+iyejCdXEZndXflsz13tAOHM8WJa6w1/PU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	Shifeng Li <lishifeng@sangfor.com.cn>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 08/75] net/mlx5e: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list()
Date: Wed,  3 Jan 2024 17:54:49 +0100
Message-ID: <20240103164844.223078120@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240103164842.953224409@linuxfoundation.org>
References: <20240103164842.953224409@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shifeng Li <lishifeng@sangfor.com.cn>

[ Upstream commit ddb38ddff9c71026bad481b791a94d446ee37603 ]

Out_sz that the size of out buffer is calculated using query_nic_vport
_context_in structure when driver query the MAC list. However query_nic
_vport_context_in structure is smaller than query_nic_vport_context_out.
When allowed_list_size is greater than 96, calling ether_addr_copy() will
trigger an slab-out-of-bounds.

[ 1170.055866] BUG: KASAN: slab-out-of-bounds in mlx5_query_nic_vport_mac_list+0x481/0x4d0 [mlx5_core]
[ 1170.055869] Read of size 4 at addr ffff88bdbc57d912 by task kworker/u128:1/461
[ 1170.055870]
[ 1170.055932] Workqueue: mlx5_esw_wq esw_vport_change_handler [mlx5_core]
[ 1170.055936] Call Trace:
[ 1170.055949]  dump_stack+0x8b/0xbb
[ 1170.055958]  print_address_description+0x6a/0x270
[ 1170.055961]  kasan_report+0x179/0x2c0
[ 1170.056061]  mlx5_query_nic_vport_mac_list+0x481/0x4d0 [mlx5_core]
[ 1170.056162]  esw_update_vport_addr_list+0x2c5/0xcd0 [mlx5_core]
[ 1170.056257]  esw_vport_change_handle_locked+0xd08/0x1a20 [mlx5_core]
[ 1170.056377]  esw_vport_change_handler+0x6b/0x90 [mlx5_core]
[ 1170.056381]  process_one_work+0x65f/0x12d0
[ 1170.056383]  worker_thread+0x87/0xb50
[ 1170.056390]  kthread+0x2e9/0x3a0
[ 1170.056394]  ret_from_fork+0x1f/0x40

Fixes: e16aea2744ab ("net/mlx5: Introduce access functions to modify/query vport mac lists")
Cc: Ding Hui <dinghui@sangfor.com.cn>
Signed-off-by: Shifeng Li <lishifeng@sangfor.com.cn>
Reviewed-by: Simon Horman <horms@kernel.org>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/vport.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/vport.c b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
index fc91bbf7d0c37..e77cf11356c07 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -276,7 +276,7 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 		req_list_size = max_list_size;
 	}
 
-	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_in) +
+	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_out) +
 			req_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
 	out = kzalloc(out_sz, GFP_KERNEL);
-- 
2.43.0



