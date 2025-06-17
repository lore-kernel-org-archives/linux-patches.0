Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 36503237162;
	Tue, 17 Jun 2025 16:11:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176699; cv=none; b=rE1JgUo44z2ZjARCqN1IVlIb6aJOV3+vvhs1cOor6SlGPlB/V88ALYe4E/BM7p3urpK+ImprhWr15oNXMmOEy2pbhqM/V62gPsIoev3Rt3gIanCm3U8f2LG4oGrMlLPk8XlSxYbyO2YNmxuKhXcRv40SABeOr7705v8ycr2LqlE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176699; c=relaxed/simple;
	bh=q1u4Hfz6wKnfEEjcDE2YLkfaiOCZy/gfMo9aIRhvLV8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DiuDc7GxM6wV/9a53hrmCPv9szsBwfhlLRu4CCuZFV02+mMjmCz4eXPwTMRX7HfDy7inCS7fVU6k3T2i+QBPm6BaiXV8KVnjqPxzzlzO+optYOrR2Cuqa4epaPNc08juLMgHpScIcUkZBbWukQyBwVHyvYJUGGKDU4cJuZaICqE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSyanxaB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSyanxaB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A9F1C4CEE7;
	Tue, 17 Jun 2025 16:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176699;
	bh=q1u4Hfz6wKnfEEjcDE2YLkfaiOCZy/gfMo9aIRhvLV8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSyanxaBh7nPmZYSPGqD0hmVMS65dgPIHhGMclWFuywnSFz5YeTPDfh7jpm5Zr65s
	 tnzcEyx+5Ex23r2/vIIrqifniOFBkSpnQzXEKrNDEHDNwzzABd2ibI6+Xf/bqwCVMc
	 h/C2IQen1nO5V+c09AV/at0DFmm/UQhf7A6PiVSg=
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
Subject: [PATCH 6.15 197/780] bonding: Mark active offloaded xfrm_states
Date: Tue, 17 Jun 2025 17:18:25 +0200
Message-ID: <20250617152459.494955905@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

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
index b183a3c99f627..14ebbe82a2c5b 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -496,9 +496,9 @@ static int bond_ipsec_add_sa(struct net_device *bond_dev,
 		goto out;
 	}
 
-	xs->xso.real_dev = real_dev;
 	err = real_dev->xfrmdev_ops->xdo_dev_state_add(real_dev, xs, extack);
 	if (!err) {
+		xs->xso.real_dev = real_dev;
 		ipsec->xs = xs;
 		INIT_LIST_HEAD(&ipsec->list);
 		mutex_lock(&bond->ipsec_lock);
@@ -540,12 +540,12 @@ static void bond_ipsec_add_sa_all(struct bonding *bond)
 		if (ipsec->xs->xso.real_dev == real_dev)
 			continue;
 
-		ipsec->xs->xso.real_dev = real_dev;
 		if (real_dev->xfrmdev_ops->xdo_dev_state_add(real_dev,
 							     ipsec->xs, NULL)) {
 			slave_warn(bond_dev, real_dev, "%s: failed to add SA\n", __func__);
-			ipsec->xs->xso.real_dev = NULL;
+			continue;
 		}
+		ipsec->xs->xso.real_dev = real_dev;
 	}
 out:
 	mutex_unlock(&bond->ipsec_lock);
@@ -629,6 +629,7 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 				   __func__);
 			continue;
 		}
+		ipsec->xs->xso.real_dev = NULL;
 		real_dev->xfrmdev_ops->xdo_dev_state_delete(real_dev,
 							    ipsec->xs);
 		if (real_dev->xfrmdev_ops->xdo_dev_state_free)
@@ -664,6 +665,7 @@ static void bond_ipsec_free_sa(struct net_device *bond_dev,
 
 	WARN_ON(xs->xso.real_dev != real_dev);
 
+	xs->xso.real_dev = NULL;
 	if (real_dev && real_dev->xfrmdev_ops &&
 	    real_dev->xfrmdev_ops->xdo_dev_state_free)
 		real_dev->xfrmdev_ops->xdo_dev_state_free(real_dev, xs);
-- 
2.39.5



