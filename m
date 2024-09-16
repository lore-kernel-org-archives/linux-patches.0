Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0ABB0146A79;
	Mon, 16 Sep 2024 12:10:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1726488656; cv=none; b=mPs/DhqFjueHUsY7Bc2fOXt5c4ylPSR9EhnB/Q1w7kiwa64UM8/KTgce0sWVit+IUW4tTFt85kdNZjoLCovPN3MtDdZQEybfkkn3XgLFJiIlTkXarCZlLNjzIY2JQ49Bg2LGVZM6AfxpanhlQ3GYQDnHLZPUQ2rkG+LL1WPWD9s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1726488656; c=relaxed/simple;
	bh=HsoYHyJKglsY0i21SPaemsCye3DF/VHrdGLEohEvJ/A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TY5fFzEVNyE/KOv1r6RRZhEDFXyrSioT09PoCIEhFl732uTjp7gTZ00SHBIfya4KvkNJZiLqOdmTyStk/AK6tLwRLu4Wt1aCXijfz53HBmch2G4EF0MLteyZ52scR09pHw6cZgh03fa4qjMPmKhvoi+F/Co/CpJHCozMDAnL2Z0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FxyGX17t; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FxyGX17t"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 83FB8C4CEC4;
	Mon, 16 Sep 2024 12:10:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1726488655;
	bh=HsoYHyJKglsY0i21SPaemsCye3DF/VHrdGLEohEvJ/A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FxyGX17tl4mxPlrdhwhRqTY4ViflTzX247PXxzABDsR57Lxqg07tuvZzqH9sIfjyl
	 XrLLj39edmu8lE9biBu1QtJlS2k9IEWAJuTGPJhwq1KF7C/amnUXQ5F68Mg5fFKSQY
	 /90Z/g+fselSMDjTcDrUUjPrTTrJlE8bQxeBSLIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Saeed Mahameed <saeedm@nvidia.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 67/91] net/mlx5: Fix bridge mode operations when there are no VFs
Date: Mon, 16 Sep 2024 13:44:43 +0200
Message-ID: <20240916114226.698433970@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240916114224.509743970@linuxfoundation.org>
References: <20240916114224.509743970@linuxfoundation.org>
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

From: Benjamin Poirier <bpoirier@nvidia.com>

[ Upstream commit b1d305abef4640af1b4f1b4774d513cd81b10cfc ]

Currently, trying to set the bridge mode attribute when numvfs=0 leads to a
crash:

bridge link set dev eth2 hwmode vepa

[  168.967392] BUG: kernel NULL pointer dereference, address: 0000000000000030
[...]
[  168.969989] RIP: 0010:mlx5_add_flow_rules+0x1f/0x300 [mlx5_core]
[...]
[  168.976037] Call Trace:
[  168.976188]  <TASK>
[  168.978620]  _mlx5_eswitch_set_vepa_locked+0x113/0x230 [mlx5_core]
[  168.979074]  mlx5_eswitch_set_vepa+0x7f/0xa0 [mlx5_core]
[  168.979471]  rtnl_bridge_setlink+0xe9/0x1f0
[  168.979714]  rtnetlink_rcv_msg+0x159/0x400
[  168.980451]  netlink_rcv_skb+0x54/0x100
[  168.980675]  netlink_unicast+0x241/0x360
[  168.980918]  netlink_sendmsg+0x1f6/0x430
[  168.981162]  ____sys_sendmsg+0x3bb/0x3f0
[  168.982155]  ___sys_sendmsg+0x88/0xd0
[  168.985036]  __sys_sendmsg+0x59/0xa0
[  168.985477]  do_syscall_64+0x79/0x150
[  168.987273]  entry_SYSCALL_64_after_hwframe+0x76/0x7e
[  168.987773] RIP: 0033:0x7f8f7950f917

(esw->fdb_table.legacy.vepa_fdb is null)

The bridge mode is only relevant when there are multiple functions per
port. Therefore, prevent setting and getting this setting when there are no
VFs.

Note that after this change, there are no settings to change on the PF
interface using `bridge link` when there are no VFs, so the interface no
longer appears in the `bridge link` output.

Fixes: 4b89251de024 ("net/mlx5: Support ndo bridge_setlink and getlink")
Signed-off-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Saeed Mahameed <saeedm@nvidia.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
index 255bc8b749f9..8587cd572da5 100644
--- a/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
+++ b/drivers/net/ethernet/mellanox/mlx5/core/esw/legacy.c
@@ -319,7 +319,7 @@ int mlx5_eswitch_set_vepa(struct mlx5_eswitch *esw, u8 setting)
 		return -EPERM;
 
 	mutex_lock(&esw->state_lock);
-	if (esw->mode != MLX5_ESWITCH_LEGACY) {
+	if (esw->mode != MLX5_ESWITCH_LEGACY || !mlx5_esw_is_fdb_created(esw)) {
 		err = -EOPNOTSUPP;
 		goto out;
 	}
@@ -339,7 +339,7 @@ int mlx5_eswitch_get_vepa(struct mlx5_eswitch *esw, u8 *setting)
 	if (!mlx5_esw_allowed(esw))
 		return -EPERM;
 
-	if (esw->mode != MLX5_ESWITCH_LEGACY)
+	if (esw->mode != MLX5_ESWITCH_LEGACY || !mlx5_esw_is_fdb_created(esw))
 		return -EOPNOTSUPP;
 
 	*setting = esw->fdb_table.legacy.vepa_uplink_rule ? 1 : 0;
-- 
2.43.0



