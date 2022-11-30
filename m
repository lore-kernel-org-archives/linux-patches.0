Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B71A879C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:45:57 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3BE54C433D6;
	Wed, 30 Nov 2022 18:45:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833957;
	bh=1hxq+5procx+PKPqz24ogZFnK68ScjqL0nen4a7xnjo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=b1U0ZpTutHMo7gqXhyBgO7QjNYbyUBkI+XKYcVr+KUskyvAHEFlA526DzP1nArF/s
	 DVsjMdbxf78QZOVzqPRZ6zxW/dPARXdd/gKjdRNe4JQx5Ta5UKcgrK2yBct4jQNY9D
	 9UHkpk5B92fDDl9R/i8l5mnTIWViNsCpQKGFCD6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mahesh Bandewar <maheshb@google.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 076/289] ipvlan: hold lower dev to avoid possible use-after-free
Date: Wed, 30 Nov 2022 19:21:01 +0100
Message-Id: <20221130180545.864186535@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180544.105550592@linuxfoundation.org>
References: <20221130180544.105550592@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mahesh Bandewar <maheshb@google.com>

[ Upstream commit 40b9d1ab63f5c4f3cb69450044d07b45e5af72e1 ]

Recently syzkaller discovered the issue of disappearing lower
device (NETDEV_UNREGISTER) while the virtual device (like
macvlan) is still having it as a lower device. So it's just
a matter of time similar discovery will be made for IPvlan
device setup. So fixing it preemptively. Also while at it,
add a refcount tracker.

Fixes: 2ad7bf363841 ("ipvlan: Initial check-in of the IPVLAN driver.")
Signed-off-by: Mahesh Bandewar <maheshb@google.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ipvlan/ipvlan.h      | 1 +
 drivers/net/ipvlan/ipvlan_main.c | 2 ++
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ipvlan/ipvlan.h b/drivers/net/ipvlan/ipvlan.h
index de94921cbef9..025e0c19ec25 100644
--- a/drivers/net/ipvlan/ipvlan.h
+++ b/drivers/net/ipvlan/ipvlan.h
@@ -98,6 +98,7 @@ struct ipvl_port {
 	struct sk_buff_head	backlog;
 	int			count;
 	struct ida		ida;
+	netdevice_tracker	dev_tracker;
 };
 
 struct ipvl_skb_cb {
diff --git a/drivers/net/ipvlan/ipvlan_main.c b/drivers/net/ipvlan/ipvlan_main.c
index 49ba8a50dfb1..9043bcd1b41d 100644
--- a/drivers/net/ipvlan/ipvlan_main.c
+++ b/drivers/net/ipvlan/ipvlan_main.c
@@ -83,6 +83,7 @@ static int ipvlan_port_create(struct net_device *dev)
 	if (err)
 		goto err;
 
+	netdev_hold(dev, &port->dev_tracker, GFP_KERNEL);
 	return 0;
 
 err:
@@ -95,6 +96,7 @@ static void ipvlan_port_destroy(struct net_device *dev)
 	struct ipvl_port *port = ipvlan_port_get_rtnl(dev);
 	struct sk_buff *skb;
 
+	netdev_put(dev, &port->dev_tracker);
 	if (port->mode == IPVLAN_MODE_L3S)
 		ipvlan_l3s_unregister(port);
 	netdev_rx_handler_unregister(dev);
-- 
2.35.1



