Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620E717AA6
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:28:00 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D9E9CC433C7;
	Wed,  9 Aug 2023 11:27:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691580480;
	bh=qCqiEe2B2yuBZX7CJ8ZVcqrpxUHEoH6rgWRJAqYgPr8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ewa9J65qfdOBH9izDzAphlI4MtGroqMzxvU6V913z1Z2F5tT6xlQCTDtVtn9v69xG
	 j+PyliJzSxZinNPHxVatXp3f8Jn/eJgQ5JrrWbWpsOaXZQNaChab7Yryk57Yw8966L
	 X7YKiunoCKam7+HnvLYknYsmJlBG/YXYDxqSS3rs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liang Li <liali@redhat.com>,
	Hangbin Liu <liuhangbin@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 039/154] team: reset teams flags when down link is P2P device
Date: Wed,  9 Aug 2023 12:41:10 +0200
Message-ID: <20230809103638.317712007@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103636.887175326@linuxfoundation.org>
References: <20230809103636.887175326@linuxfoundation.org>
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
index 227d97b4dc224..5c72e9ac4804d 100644
--- a/drivers/net/team/team.c
+++ b/drivers/net/team/team.c
@@ -2129,6 +2129,15 @@ static void team_setup_by_port(struct net_device *dev,
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



