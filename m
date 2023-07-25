Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 64A761ED38
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:09:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB46EC433C7;
	Tue, 25 Jul 2023 11:09:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283344;
	bh=JDdpaKhAeiv9MkKxvAlB2lK1hp533pI//KKAPqtaJwc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f8r+iqiINZ9E96opWWtjepg2JE5c30KSlMK8nJpnRzJIQW1BOUhRgdIQJ5cpRYrhP
	 Qkl+fkgqvf04bXD1jkH0VJoyY6p9z6UKsa+JW34Ura/Zi1qNLiHQ1uxIdlePh8PMGd
	 RQ54Cu9zN0YB99vr8M1yw3lWcQFHFiJbQ96iTmU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Coin <hcoin@quietfountain.com>,
	Ido Schimmel <idosch@idosch.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Ido Schimmel <idosch@nvidia.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 43/78] bridge: Add extack warning when enabling STP in netns.
Date: Tue, 25 Jul 2023 12:46:34 +0200
Message-ID: <20230725104452.964991646@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104451.275227789@linuxfoundation.org>
References: <20230725104451.275227789@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit 56a16035bb6effb37177867cea94c13a8382f745 ]

When we create an L2 loop on a bridge in netns, we will see packets storm
even if STP is enabled.

  # unshare -n
  # ip link add br0 type bridge
  # ip link add veth0 type veth peer name veth1
  # ip link set veth0 master br0 up
  # ip link set veth1 master br0 up
  # ip link set br0 type bridge stp_state 1
  # ip link set br0 up
  # sleep 30
  # ip -s link show br0
  2: br0: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc noqueue state UP mode DEFAULT group default qlen 1000
      link/ether b6:61:98:1c:1c:b5 brd ff:ff:ff:ff:ff:ff
      RX: bytes  packets  errors  dropped missed  mcast
      956553768  12861249 0       0       0       12861249  <-. Keep
      TX: bytes  packets  errors  dropped carrier collsns     |  increasing
      1027834    11951    0       0       0       0         <-'   rapidly

This is because llc_rcv() drops all packets in non-root netns and BPDU
is dropped.

Let's add extack warning when enabling STP in netns.

  # unshare -n
  # ip link add br0 type bridge
  # ip link set br0 type bridge stp_state 1
  Warning: bridge: STP does not work in non-root netns.

Note this commit will be reverted later when we namespacify the whole LLC
infra.

Fixes: e730c15519d0 ("[NET]: Make packet reception network namespace safe")
Suggested-by: Harry Coin <hcoin@quietfountain.com>
Link: https://lore.kernel.org/netdev/0f531295-e289-022d-5add-5ceffa0df9bc@quietfountain.com/
Suggested-by: Ido Schimmel <idosch@idosch.org>
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Acked-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_stp_if.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/net/bridge/br_stp_if.c b/net/bridge/br_stp_if.c
index ba55851fe132c..3326dfced68ab 100644
--- a/net/bridge/br_stp_if.c
+++ b/net/bridge/br_stp_if.c
@@ -201,6 +201,9 @@ int br_stp_set_enabled(struct net_bridge *br, unsigned long val,
 {
 	ASSERT_RTNL();
 
+	if (!net_eq(dev_net(br->dev), &init_net))
+		NL_SET_ERR_MSG_MOD(extack, "STP does not work in non-root netns");
+
 	if (br_mrp_enabled(br)) {
 		NL_SET_ERR_MSG_MOD(extack,
 				   "STP can't be enabled if MRP is already enabled");
-- 
2.39.2



