Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 709CB38F233;
	Sat, 17 Oct 2026 17:36:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258561; cv=none; b=HBHSUgqhNZvu0GdSgQwpo9g08fU7IZy06gfx2amzP2kTt7GIl0blAEM5CXk5hbrRopvtCAerlSWdmlwjoWINLit8mCLVdKciaURjW5QJVFXsjF5SId2WlTbGj5vyHhMj7HiFg+wtGj4WdHV0mb/a/VK98ucHHRwr8S/eiIVftCA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258561; c=relaxed/simple;
	bh=Wgg6ngSy0iJJ0pAU0eHr0q1/BkydrsUjK+odzQrkqsc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FfBhvD2JT/ScxSTrMu/xRAKe8bY9md2a2Uh2V7AX+tYwSslO/j5TGnTNqp4jz/fuZskT6xwtWLBNB/GwwLHcwwFB3HhTASJfRbiraDbSj3NLz0nLKD13MiRhLMRCaxf5Il9CO4gA/1xOspJcV5LxrrKFukBrKr650TYudChCrsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=M6OhTdPX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="M6OhTdPX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CEA3E1F000C4;
	Sat, 17 Oct 2026 17:35:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258560;
	bh=y6mnL5CsVlm1JOkiJ1k3HNB33X4LM2A1rrHzk6U857U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=M6OhTdPXBL7zp/nhGN06+SrOhJcEvsyGhoPnBnbznX7eoasMh8fiTWasyG3bnUE/z
	 83VkPKVyZWig932AVwmDFomH1hq64M2UczIk8iOGYwl7zAv7oJWcYBuhR1BAUBFF8l
	 Y/HPWUtTVWjcR2Szt/Q2jFRIrKoGgOBTnRHo+mEI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0923/1674] net/mlx5e: Fix "scheduling while atomic" in IPsec MAC address query
Date: Sat, 17 Oct 2026 17:53:15 +0200
Message-ID: <20261017160454.825533205@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit 859380694f434597407632c29f30fdb5e763e6cc ]

Fix a "scheduling while atomic" bug in mlx5e_ipsec_init_macs() by
replacing mlx5_query_mac_address() with ether_addr_copy() to get the
local MAC address directly from netdev->dev_addr.

The issue occurs because mlx5_query_mac_address() queries the hardware
which involves mlx5_cmd_exec() that can sleep, but it is called from
the mlx5e_ipsec_handle_event workqueue which runs in atomic context.

The MAC address is already available in netdev->dev_addr, so no need
to query hardware. This avoids the sleeping call and resolves the bug.

Call trace:
  BUG: scheduling while atomic: kworker/u112:2/69344/0x00000200
  __schedule+0x7ab/0xa20
  schedule+0x1c/0xb0
  schedule_timeout+0x6e/0xf0
  __wait_for_common+0x91/0x1b0
  cmd_exec+0xa85/0xff0 [mlx5_core]
  mlx5_cmd_exec+0x1f/0x50 [mlx5_core]
  mlx5_query_nic_vport_mac_address+0x7b/0xd0 [mlx5_core]
  mlx5_query_mac_address+0x19/0x30 [mlx5_core]
  mlx5e_ipsec_init_macs+0xc1/0x720 [mlx5_core]
  mlx5e_ipsec_build_accel_xfrm_attrs+0x422/0x670 [mlx5_core]
  mlx5e_ipsec_handle_event+0x2b9/0x460 [mlx5_core]
  process_one_work+0x178/0x2e0
  worker_thread+0x2ea/0x430

Fixes: cee137a63431 ("net/mlx5e: Handle ESN update events")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260224114652.1787431-6-tariqt@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
index fdf664e9c46e9..13c143610d6cf 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/en_accel/ipsec.c
@@ -265,7 +265,6 @@ static void mlx5e_ipsec_init_limits(struct mlx5e_ipsec_sa_entry *sa_entry,
 static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 				  struct mlx5_accel_esp_xfrm_attrs *attrs)
 {
-	struct mlx5_core_dev *mdev = mlx5e_ipsec_sa2dev(sa_entry);
 	struct xfrm_state *x = sa_entry->x;
 	struct net_device *netdev;
 	struct neighbour *n;
@@ -279,7 +278,7 @@ static void mlx5e_ipsec_init_macs(struct mlx5e_ipsec_sa_entry *sa_entry,
 
 	netdev = x->xso.real_dev;
 
-	mlx5_query_mac_address(mdev, addr);
+	ether_addr_copy(addr, netdev->dev_addr);
 	switch (attrs->dir) {
 	case XFRM_DEV_OFFLOAD_IN:
 		src = attrs->dmac;
-- 
2.53.0



