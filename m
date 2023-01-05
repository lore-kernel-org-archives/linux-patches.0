Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9695B8494
	for <patches@lists.linux.dev>; Thu,  5 Jan 2023 13:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 00529C433D2;
	Thu,  5 Jan 2023 13:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672923889;
	bh=To9YenKa38xIfNW1ELFoZ9tAXRzPd8vtBpipHId5cDQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b32ZIZpJMYpB8wGqryUlQOKk1YUa26KJTPVQa/41BFsEvU4bpRRcZEDGqDJS3+NV/
	 ByfLfddpBJPJLDOMpd42+pp9iStpM2r0Zco0lcqjUeY+X2P8wbgESQmsmghfHu7e9D
	 +77dgGaSIfNRjANTdNj5WDEeRfhmNKTIV2n8VfRA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dragos Tatulea <dtatulea@nvidia.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.9 125/251] IB/IPoIB: Fix queue count inconsistency for PKEY child interfaces
Date: Thu,  5 Jan 2023 13:54:22 +0100
Message-Id: <20230105125340.555205316@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230105125334.727282894@linuxfoundation.org>
References: <20230105125334.727282894@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dragos Tatulea <dtatulea@nvidia.com>

[ Upstream commit dbc94a0fb81771a38733c0e8f2ea8c4fa6934dc1 ]

There are 2 ways to create IPoIB PKEY child interfaces:
1) Writing a PKEY to /sys/class/net/<ib parent interface>/create_child.
2) Using netlink with iproute.

While with sysfs the child interface has the same number of tx and
rx queues as the parent, with netlink there will always be 1 tx
and 1 rx queue for the child interface. That's because the
get_num_tx/rx_queues() netlink ops are missing and the default value
of 1 is taken for the number of queues (in rtnl_create_link()).

This change adds the get_num_tx/rx_queues() ops which allows for
interfaces with multiple queues to be created over netlink. This
constant only represents the max number of tx and rx queues on that
net device.

Fixes: 9baa0b036410 ("IB/ipoib: Add rtnl_link_ops support")
Signed-off-by: Dragos Tatulea <dtatulea@nvidia.com>
Link: https://lore.kernel.org/r/f4a42c8aa43c02d5ae5559a60c3e5e0f18c82531.1670485816.git.leonro@nvidia.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/ulp/ipoib/ipoib_netlink.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
index cdc7df4fdb8a..20a6d1071014 100644
--- a/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
+++ b/drivers/infiniband/ulp/ipoib/ipoib_netlink.c
@@ -42,6 +42,11 @@ static const struct nla_policy ipoib_policy[IFLA_IPOIB_MAX + 1] = {
 	[IFLA_IPOIB_UMCAST]	= { .type = NLA_U16 },
 };
 
+static unsigned int ipoib_get_max_num_queues(void)
+{
+	return min_t(unsigned int, num_possible_cpus(), 128);
+}
+
 static int ipoib_fill_info(struct sk_buff *skb, const struct net_device *dev)
 {
 	struct ipoib_dev_priv *priv = netdev_priv(dev);
@@ -167,6 +172,8 @@ static struct rtnl_link_ops ipoib_link_ops __read_mostly = {
 	.dellink	= ipoib_unregister_child_dev,
 	.get_size	= ipoib_get_size,
 	.fill_info	= ipoib_fill_info,
+	.get_num_rx_queues = ipoib_get_max_num_queues,
+	.get_num_tx_queues = ipoib_get_max_num_queues,
 };
 
 int __init ipoib_netlink_init(void)
-- 
2.35.1



