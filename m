Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 337C82DC34C;
	Tue,  8 Jul 2025 16:41:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751992909; cv=none; b=Klg7SH2cE4gp3HeFXC5sRaSoFA8DWIr86eez4z4FNkagyRCQQbJYy03f2bbPD5M4yN0cOOu4uU5JG0lMCjASc+LQrrkTV3Fi5L79aYbi14FJuBddHKZfHaIVs/QgiCK7uCnIZErZncfj/JkKbuMhhIazOgtyx38JuTNUYzDoiMI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751992909; c=relaxed/simple;
	bh=nsR9Yx3UewF75WtMRBnl31EpQljltAC0eGbJnS5/aqU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DA4yzNXRJLQsA34iQz4bp5c2G7/moHCVL0ix1pqHTMTEb77/X/IzjCS85DHpceomXXxkd+hcKLaD8/qrdSWHMurGZeyWvlpdtgfxFBHVSa+8u696k0VCfPZZk8s/PGelZyppEfvRMN850MiNxCogr5SUMWRdxaqGf8W75FPUrzE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FjvPXODL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FjvPXODL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AF567C4CEED;
	Tue,  8 Jul 2025 16:41:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1751992909;
	bh=nsR9Yx3UewF75WtMRBnl31EpQljltAC0eGbJnS5/aqU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FjvPXODLl3MhAA2kUR7+R60VBReNb9mB12hV20QlAxAb17ijmNXeY1q7p9AB2PZGz
	 xAGJGHqrOZrTYRk+dc782N1epFSQ7z88R+DV9rQtw2GHoMU4voSHvv9j6FocFEjwLj
	 HjM3VAYBCRGbhYiCagskMO2vQ6MHbhx3b8pDAu5g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Leon Romanovsky <leonro@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Steffen Klassert <steffen.klassert@secunet.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 122/232] bonding: Mark active offloaded xfrm_states
Date: Tue,  8 Jul 2025 18:21:58 +0200
Message-ID: <20250708162244.635370133@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250708162241.426806072@linuxfoundation.org>
References: <20250708162241.426806072@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cosmin Ratiu <cratiu@nvidia.com>

[ Upstream commit fd4e41ebf66cb8b43de2f640b97314c4ee3b4499 ]

When the active link is changed for a bond device, the existing xfrm
states need to be migrated over to the new link. This is done with:
- bond_ipsec_del_sa_all() goes through the offloaded states list and
  removes all of them from hw.
- bond_ipsec_add_sa_all() re-offloads all states to the new device.

But because the offload status of xfrm states isn't marked in any way,
there can be bugs.

When all bond links are down, bond_ipsec_del_sa_all() unoffloads
everything from the previous active link. If the same link then comes
back up, nothing gets reoffloaded by bond_ipsec_add_sa_all().
This results in a stack trace like this a bit later when user space
removes the offloaded rules, because mlx5e_xfrm_del_state() is asked to
remove a rule that's no longer offloaded:

 [] Call Trace:
 []  <TASK>
 []  ? __warn+0x7d/0x110
 []  ? mlx5e_xfrm_del_state+0x90/0xa0 [mlx5_core]
 []  ? report_bug+0x16d/0x180
 []  ? handle_bug+0x4f/0x90
 []  ? exc_invalid_op+0x14/0x70
 []  ? asm_exc_invalid_op+0x16/0x20
 []  ? mlx5e_xfrm_del_state+0x73/0xa0 [mlx5_core]
 []  ? mlx5e_xfrm_del_state+0x90/0xa0 [mlx5_core]
 []  bond_ipsec_del_sa+0x1ab/0x200 [bonding]
 []  xfrm_dev_state_delete+0x1f/0x60
 []  __xfrm_state_delete+0x196/0x200
 []  xfrm_state_delete+0x21/0x40
 []  xfrm_del_sa+0x69/0x110
 []  xfrm_user_rcv_msg+0x11d/0x300
 []  ? release_pages+0xca/0x140
 []  ? copy_to_user_tmpl.part.0+0x110/0x110
 []  netlink_rcv_skb+0x54/0x100
 []  xfrm_netlink_rcv+0x31/0x40
 []  netlink_unicast+0x1fc/0x2d0
 []  netlink_sendmsg+0x1e4/0x410
 []  __sock_sendmsg+0x38/0x60
 []  sock_write_iter+0x94/0xf0
 []  vfs_write+0x338/0x3f0
 []  ksys_write+0xba/0xd0
 []  do_syscall_64+0x4c/0x100
 []  entry_SYSCALL_64_after_hwframe+0x4b/0x53

There's also another theoretical bug:
Calling bond_ipsec_del_sa_all() multiple times can result in corruption
in the driver implementation if the double-free isn't tolerated. This
isn't nice.

Before the "Fixes" commit, xs->xso.real_dev was set to NULL when an xfrm
state was unoffloaded from a device, but a race with netdevsim's
.xdo_dev_offload_ok() accessing real_dev was considered a sufficient
reason to not set real_dev to NULL anymore. This unfortunately
introduced the new bugs.

Since .xdo_dev_offload_ok() was significantly refactored by [1] and
there are no more users in the stack of xso.real_dev, that
race is now gone and xs->xso.real_dev can now once again be used to
represent which device (if any) currently holds the offloaded rule.

Go one step further and set real_dev after add/before delete calls, to
catch any future driver misuses of real_dev.

[1] https://lore.kernel.org/netdev/cover.1739972570.git.leon@kernel.org/
Fixes: f8cde9805981 ("bonding: fix xfrm real_dev null pointer dereference")
Signed-off-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Tested-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index 2a513dbbd9756..52ff0f9e04e07 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -497,9 +497,9 @@ static int bond_ipsec_add_sa(struct xfrm_state *xs,
 		goto out;
 	}
 
-	xs->xso.real_dev = real_dev;
 	err = real_dev->xfrmdev_ops->xdo_dev_state_add(xs, extack);
 	if (!err) {
+		xs->xso.real_dev = real_dev;
 		ipsec->xs = xs;
 		INIT_LIST_HEAD(&ipsec->list);
 		mutex_lock(&bond->ipsec_lock);
@@ -541,11 +541,11 @@ static void bond_ipsec_add_sa_all(struct bonding *bond)
 		if (ipsec->xs->xso.real_dev == real_dev)
 			continue;
 
-		ipsec->xs->xso.real_dev = real_dev;
 		if (real_dev->xfrmdev_ops->xdo_dev_state_add(ipsec->xs, NULL)) {
 			slave_warn(bond_dev, real_dev, "%s: failed to add SA\n", __func__);
-			ipsec->xs->xso.real_dev = NULL;
+			continue;
 		}
+		ipsec->xs->xso.real_dev = real_dev;
 	}
 out:
 	mutex_unlock(&bond->ipsec_lock);
@@ -627,6 +627,7 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 				   "%s: no slave xdo_dev_state_delete\n",
 				   __func__);
 		} else {
+			ipsec->xs->xso.real_dev = NULL;
 			real_dev->xfrmdev_ops->xdo_dev_state_delete(ipsec->xs);
 			if (real_dev->xfrmdev_ops->xdo_dev_state_free)
 				real_dev->xfrmdev_ops->xdo_dev_state_free(ipsec->xs);
@@ -661,6 +662,7 @@ static void bond_ipsec_free_sa(struct xfrm_state *xs)
 
 	WARN_ON(xs->xso.real_dev != real_dev);
 
+	xs->xso.real_dev = NULL;
 	if (real_dev && real_dev->xfrmdev_ops &&
 	    real_dev->xfrmdev_ops->xdo_dev_state_free)
 		real_dev->xfrmdev_ops->xdo_dev_state_free(xs);
-- 
2.39.5



