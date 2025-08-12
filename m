Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0FD827781E;
	Tue, 12 Aug 2025 19:13:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755026000; cv=none; b=fh/IgFH9FAOfm6pqddv9ekjf4p3gfTJnIeObHxdshBScoVKUXTNqn+gH5qh5wE43Gb2qf3GSWUrX3kpvpROQMCptLCIX3cIt8zr2kCNw0SDwuR4s1gPQq5HcKvNy5E4o0Ch3fN+vfVerLqmpDe3sU95XFY+AC/FPOWd1kAUKqS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755026000; c=relaxed/simple;
	bh=984xDvMH7E/tKB9xmAfeq0G3oSNZw8rYpVxFvyHacuY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dJiCL7bU88QHyMfYMZJsj2J8o4HklD20Hqsm+ZeLcDgTMdzlhGaVVr+rRCOVWBqGU3bdeTkVebeODKMOEVLOr2n3JQAnjD1Tl8KxFu9jVELzPJ5kSP4xS/SIaldpfUWCmhPGmjQrLe4ekj4ATAPjCPycWPgdOyukExFPhGFL3c8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VyKr7f6I; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VyKr7f6I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30BC1C4CEF0;
	Tue, 12 Aug 2025 19:13:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755026000;
	bh=984xDvMH7E/tKB9xmAfeq0G3oSNZw8rYpVxFvyHacuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VyKr7f6IRYnmiYmCU0tyZdKv3gXdoxTPoxD4iZZ3v3UhSzicUCP+0pd2di0SFjvhj
	 66tz1cwN5tQrwq1B8Bse9hIZyzgqyJxZGgmNUCHe4IWYV0uZwmn2DiRZFZixHrIihC
	 X6CXBcPCyR/UdnkchvMTVTKHIfp8w9LBg4Xhw6f0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Simon Horman <horms@kernel.org>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 207/480] macsec: set IFF_UNICAST_FLT priv flag
Date: Tue, 12 Aug 2025 19:46:55 +0200
Message-ID: <20250812174406.008875185@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812174357.281828096@linuxfoundation.org>
References: <20250812174357.281828096@linuxfoundation.org>
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

From: Stanislav Fomichev <sdf@fomichev.me>

[ Upstream commit 0349659fd72f662c054ff20d432559bfaa228ce4 ]

Cosmin reports the following locking issue:

  # BUG: sleeping function called from invalid context at
  kernel/locking/mutex.c:275
  #   dump_stack_lvl+0x4f/0x60
  #   __might_resched+0xeb/0x140
  #   mutex_lock+0x1a/0x40
  #   dev_set_promiscuity+0x26/0x90
  #   __dev_set_promiscuity+0x85/0x170
  #   __dev_set_rx_mode+0x69/0xa0
  #   dev_uc_add+0x6d/0x80
  #   vlan_dev_open+0x5f/0x120 [8021q]
  #  __dev_open+0x10c/0x2a0
  #  __dev_change_flags+0x1a4/0x210
  #  netif_change_flags+0x22/0x60
  #  do_setlink.isra.0+0xdb0/0x10f0
  #  rtnl_newlink+0x797/0xb00
  #  rtnetlink_rcv_msg+0x1cb/0x3f0
  #  netlink_rcv_skb+0x53/0x100
  #  netlink_unicast+0x273/0x3b0
  #  netlink_sendmsg+0x1f2/0x430

Which is similar to recent syzkaller reports in [0] and [1] and triggers
because macsec does not advertise IFF_UNICAST_FLT although it has proper
ndo_set_rx_mode callback that takes care of pushing uc/mc addresses
down to the real device.

In general, dev_uc_add call path is problematic for stacking
non-IFF_UNICAST_FLT because we might grab netdev instance lock under
addr_list_lock spinlock, so this is not a systemic fix.

0: https://lore.kernel.org/netdev/686d55b4.050a0220.1ffab7.0014.GAE@google.com
1: https://lore.kernel.org/netdev/68712acf.a00a0220.26a83e.0051.GAE@google.com/
Reviewed-by: Simon Horman <horms@kernel.org>
Tested-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/netdev/2aff4342b0f5b1539c02ffd8df4c7e58dd9746e7.camel@nvidia.com
Fixes: 7e4d784f5810 ("net: hold netdev instance lock during rtnetlink operations")
Reported-by: Cosmin Ratiu <cratiu@nvidia.com>
Tested-by: Cosmin Ratiu <cratiu@nvidia.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20250723224715.1341121-1-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index 7edbe76b5455..4c75d1fea552 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -3868,7 +3868,7 @@ static void macsec_setup(struct net_device *dev)
 	ether_setup(dev);
 	dev->min_mtu = 0;
 	dev->max_mtu = ETH_MAX_MTU;
-	dev->priv_flags |= IFF_NO_QUEUE;
+	dev->priv_flags |= IFF_NO_QUEUE | IFF_UNICAST_FLT;
 	dev->netdev_ops = &macsec_netdev_ops;
 	dev->needs_free_netdev = true;
 	dev->priv_destructor = macsec_free_netdev;
-- 
2.39.5



