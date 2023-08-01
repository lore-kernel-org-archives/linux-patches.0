Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17FDF1FB4F
	for <patches@lists.linux.dev>; Tue,  1 Aug 2023 09:43:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DA9BC433C7;
	Tue,  1 Aug 2023 09:43:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690883007;
	bh=zzdsrycn6fMYsj4PJw/y9yXe1oS91z457/dA5ZdVseY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=hy1nQoTbuKsUunYNBQKhuTpw+ifHdh3YX2L4BnkaF2ckM9YMVTGryXmIOCFX751MB
	 k0og0BfQmD7Fx3CnQFNoNvuczv3aK76OjVrfucgLuf2behICsQRKUQnBomdty9G7uE
	 MK83GSk9hmg7lwGTCujiqi6f4ZP1xLGhfawT6/34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 081/239] team: reset teams flags when down link is P2P device
Date: Tue,  1 Aug 2023 11:19:05 +0200
Message-ID: <20230801091928.662699786@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230801091925.659598007@linuxfoundation.org>
References: <20230801091925.659598007@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Hangbin Liu <liuhangbin@gmail.com>

[ Upstream commit fa532bee17d15acf8bba4bc8e2062b7a093ba801 ]

When adding a point to point downlink to team device, we neglected to reset
the team's flags, which were still using flags like BROADCAST and
MULTICAST. Consequently, this would initiate ARP/DAD for P2P downlink
interfaces, such as when adding a GRE device to team device. Fix this by
remove multicast/broadcast flags and add p2p and noarp flags.

After removing the none ethernet interface and adding an ethernet interface
to team, we need to reset team interface flags. Unlike bonding interface,
team do not need restore IFF_MASTER, IFF_SLAVE flags.

Reported-by: Liang Li <liali@redhat.com>
Closes: https://bugzilla.redhat.com/show_bug.cgi?id=2221438
Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Signed-off-by: Hangbin Liu <liuhangbin@gmail.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team.c | 9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/net/team/team.c b/drivers/net/team/team.c
index 555b0b1e9a789..d3dc22509ea58 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2135,6 +2135,15 @@ static void team_setup_by_port(struct net_device *dev,
 	dev->mtu = port_dev->mtu;
 	memcpy(dev->broadcast, port_dev->broadcast, port_dev->addr_len);
 	eth_hw_addr_inherit(dev, port_dev);
+
+	if (port_dev->flags & IFF_POINTOPOINT) {
+		dev->flags &= ~(IFF_BROADCAST | IFF_MULTICAST);
+		dev->flags |= (IFF_POINTOPOINT | IFF_NOARP);
+	} else if ((port_dev->flags & (IFF_BROADCAST | IFF_MULTICAST)) ==
+		    (IFF_BROADCAST | IFF_MULTICAST)) {
+		dev->flags |= (IFF_BROADCAST | IFF_MULTICAST);
+		dev->flags &= ~(IFF_POINTOPOINT | IFF_NOARP);
+	}
 }
 
 static int team_dev_type_check_change(struct net_device *dev,
-- 
2.39.2



