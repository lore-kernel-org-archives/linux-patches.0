Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C073879CD;
	Sat, 30 Dec 2023 12:02:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1REgFgdk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48CD7C433C7;
	Sat, 30 Dec 2023 12:02:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1703937769;
	bh=nn1kwg3UNqzCI7Veln1qYK2L+aOh0gTYa7OMi4szTAE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=1REgFgdk2mcXh5tPAzGZg5OVkShvgkky7yiztBfG+ySi8xG2DKrs7YsaV6JDFzJW6
	 KZSrQP6vUuTBUNBs/rI6z7nbiJkH1MCX7y/p1mUcdNsQgmO2u9Z9SrxpqcqqLp7oJi
	 yw6y9uk+b4kk8OiNi5FbHS1g8IGf1vSIyknmjWVE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	Shifeng Li <lishifeng@sangfor.com.cn>,
	Simon Horman <horms@kernel.org>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 032/156] net/mlx5e: Fix slab-out-of-bounds in mlx5_query_nic_vport_mac_list()
Date: Sat, 30 Dec 2023 11:58:06 +0000
Message-ID: <20231230115813.420181729@linuxfoundation.org>
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
index 5a31fb47ffa58..21753f3278685 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/vport.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/vport.c
@@ -277,7 +277,7 @@ int mlx5_query_nic_vport_mac_list(struct mlx5_core_dev *dev,
 		req_list_size = max_list_size;
 	}
 
-	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_in) +
+	out_sz = MLX5_ST_SZ_BYTES(query_nic_vport_context_out) +
 			req_list_size * MLX5_ST_SZ_BYTES(mac_address_layout);
 
 	out = kvzalloc(out_sz, GFP_KERNEL);
-- 
2.43.0



