Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4CCA214A81
	for <patches@lists.linux.dev>; Thu, 24 Aug 2023 17:21:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BF16CC433C7;
	Thu, 24 Aug 2023 17:21:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1692897696;
	bh=z8zDloZQ+YloSddYAkxtFwGDgbr8aaM4Rc/7pTmLkw8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jXn3jsYz/y/ndWNWfLnJ9cEPe4ICbyq93VK0vG89sX3HKAbig7EcDpVh9bz4Or/pv
	 wC9LCm60OGHo6TBHT56nAosz27zzRSkRY4naW3iLVWXvDdSxDkIBZ22Ryw0IxpQ+z0
	 AXUH1r2P1vU+ytlvaL6J2unnqCDXjwCvVpLYBoK4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@idosch.org>,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 089/135] team: Fix incorrect deletion of ETH_P_8021AD protocol vid from slaves
Date: Thu, 24 Aug 2023 19:09:21 +0200
Message-ID: <20230824170621.112184136@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230824170617.074557800@linuxfoundation.org>
References: <20230824170617.074557800@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit dafcbce07136d799edc4c67f04f9fd69ff1eac1f ]

Similar to commit 01f4fd270870 ("bonding: Fix incorrect deletion of
ETH_P_8021AD protocol vid from slaves"), we can trigger BUG_ON(!vlan_info)
in unregister_vlan_dev() with the following testcase:

  # ip netns add ns1
  # ip netns exec ns1 ip link add team1 type team
  # ip netns exec ns1 ip link add team_slave type veth peer veth2
  # ip netns exec ns1 ip link set team_slave master team1
  # ip netns exec ns1 ip link add link team_slave name team_slave.10 type vlan id 10 protocol 802.1ad
  # ip netns exec ns1 ip link add link team1 name team1.10 type vlan id 10 protocol 802.1ad
  # ip netns exec ns1 ip link set team_slave nomaster
  # ip netns del ns1

Add S-VLAN tag related features support to team driver. So the team driver
will always propagate the VLAN info to its slaves.

Fixes: 8ad227ff89a7 ("net: vlan: add 802.1ad support")
Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://lore.kernel.org/r/20230814032301.2804971-1-william.xuanziyang@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 36c7eae776d44..721b536ce8861 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2195,7 +2195,9 @@ static void team_setup(struct net_device *dev)
 
 	dev->hw_features = TEAM_VLAN_FEATURES |
 			   NETIF_F_HW_VLAN_CTAG_RX |
-			   NETIF_F_HW_VLAN_CTAG_FILTER;
+			   NETIF_F_HW_VLAN_CTAG_FILTER |
+			   NETIF_F_HW_VLAN_STAG_RX |
+			   NETIF_F_HW_VLAN_STAG_FILTER;
 
 	dev->hw_features |= NETIF_F_GSO_ENCAP_ALL | NETIF_F_GSO_UDP_L4;
 	dev->features |= dev->hw_features;
-- 
2.40.1



