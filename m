Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D35C2B9C7;
	Sun,  1 Sep 2024 16:35:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1725208508; cv=none; b=JSph5PDzv6ZBymRsgV+9IRT2ylx/gdjfqa935P39vzy4LAcecajWHIT2kVTAtBqYdd6rSdh2xLc8/qMfNLhhYMpAY14fUa/G5orAQB0sDXpxFfEdyNjG1aFtqKYpp4WtndIab3hDhPllwgvu2OMpJWSRrOiZbfPMsjwfMImP3x4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1725208508; c=relaxed/simple;
	bh=k2m/pE2UTS1QFj9KJHLQMLbYOdOmS5fdynoR1dLOFlA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=O0GWlF30pOQHqsL/fIxo4bJrTusuJ/nSIJ/1008C35OY6565DU87n2m6ua9Q/BosFYTk+1XUrOYtARIeTrKGv193gmIxV6JxXHbqpsWtWGIXCuaf55mEAf4SWqR+tLdEdPG4UaKzRuRzW1lGuGHjEyU2xbMW0VNWdi8viiLw/pA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sQhLQ0pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sQhLQ0pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BE283C4CEC8;
	Sun,  1 Sep 2024 16:35:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1725208508;
	bh=k2m/pE2UTS1QFj9KJHLQMLbYOdOmS5fdynoR1dLOFlA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sQhLQ0pLDrVguI3BdAm7lyw9EhN2+3RqjDyeDyaY3q1AaSyw5S4Jdnxzmilcas6TL
	 eLD61iD3qHeXMz+X/HPa7dveuHASi72NqckOIVur9niQq5m7Ev5sfp4zwcRn/mIz32
	 eS5dmh7xfqKdAUgZc6BuRjKpUGuZfEnVkLNFLwtk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jianbo Liu <jianbol@nvidia.com>,
	Tariq Toukan <tariqt@nvidia.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Jay Vosburgh <jv@jvosburgh.net>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 104/149] bonding: implement xdo_dev_state_free and call it after deletion
Date: Sun,  1 Sep 2024 18:16:55 +0200
Message-ID: <20240901160821.368841052@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240901160817.461957599@linuxfoundation.org>
References: <20240901160817.461957599@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jianbo Liu <jianbol@nvidia.com>

[ Upstream commit ec13009472f4a756288eb4e18e20a7845da98d10 ]

Add this implementation for bonding, so hardware resources can be
freed from the active slave after xfrm state is deleted. The netdev
used to invoke xdo_dev_state_free callback, is saved in the xfrm state
(xs->xso.real_dev), which is also the bond's active slave. To prevent
it from being freed, acquire netdev reference before leaving RCU
read-side critical section, and release it after callback is done.

And call it when deleting all SAs from old active real interface while
switching current active slave.

Fixes: 9a5605505d9c ("bonding: Add struct bond_ipesc to manage SA")
Signed-off-by: Jianbo Liu <jianbol@nvidia.com>
Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
Reviewed-by: Hangbin Liu <liuhangbin@gmail.com>
Acked-by: Jay Vosburgh <jv@jvosburgh.net>
Link: https://patch.msgid.link/20240823031056.110999-2-jianbol@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/bonding/bond_main.c | 36 +++++++++++++++++++++++++++++++++
 1 file changed, 36 insertions(+)

diff --git a/drivers/net/bonding/bond_main.c b/drivers/net/bonding/bond_main.c
index b257504a85347..232e592389638 100644
--- a/drivers/net/bonding/bond_main.c
+++ b/drivers/net/bonding/bond_main.c
@@ -581,12 +581,47 @@ static void bond_ipsec_del_sa_all(struct bonding *bond)
 				   __func__);
 		} else {
 			slave->dev->xfrmdev_ops->xdo_dev_state_delete(ipsec->xs);
+			if (slave->dev->xfrmdev_ops->xdo_dev_state_free)
+				slave->dev->xfrmdev_ops->xdo_dev_state_free(ipsec->xs);
 		}
 	}
 	spin_unlock_bh(&bond->ipsec_lock);
 	rcu_read_unlock();
 }
 
+static void bond_ipsec_free_sa(struct xfrm_state *xs)
+{
+	struct net_device *bond_dev = xs->xso.dev;
+	struct net_device *real_dev;
+	netdevice_tracker tracker;
+	struct bonding *bond;
+	struct slave *slave;
+
+	if (!bond_dev)
+		return;
+
+	rcu_read_lock();
+	bond = netdev_priv(bond_dev);
+	slave = rcu_dereference(bond->curr_active_slave);
+	real_dev = slave ? slave->dev : NULL;
+	netdev_hold(real_dev, &tracker, GFP_ATOMIC);
+	rcu_read_unlock();
+
+	if (!slave)
+		goto out;
+
+	if (!xs->xso.real_dev)
+		goto out;
+
+	WARN_ON(xs->xso.real_dev != real_dev);
+
+	if (real_dev && real_dev->xfrmdev_ops &&
+	    real_dev->xfrmdev_ops->xdo_dev_state_free)
+		real_dev->xfrmdev_ops->xdo_dev_state_free(xs);
+out:
+	netdev_put(real_dev, &tracker);
+}
+
 /**
  * bond_ipsec_offload_ok - can this packet use the xfrm hw offload
  * @skb: current data packet
@@ -627,6 +662,7 @@ static bool bond_ipsec_offload_ok(struct sk_buff *skb, struct xfrm_state *xs)
 static const struct xfrmdev_ops bond_xfrmdev_ops = {
 	.xdo_dev_state_add = bond_ipsec_add_sa,
 	.xdo_dev_state_delete = bond_ipsec_del_sa,
+	.xdo_dev_state_free = bond_ipsec_free_sa,
 	.xdo_dev_offload_ok = bond_ipsec_offload_ok,
 };
 #endif /* CONFIG_XFRM_OFFLOAD */
-- 
2.43.0



