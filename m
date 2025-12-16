Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CA7CB221F0C;
	Tue, 16 Dec 2025 11:34:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1765884841; cv=none; b=qX/lKrLDfDnUYAudIofNzpXOaMFQvy7LdAbmh+gp/1uKx454L/LkP6ia4IGnyEa9u4jou4VgrzLT6lrN4xX7HDD9A6iYRJHHd7s00gCLG0f8T37dOMaNpXZy5pppKldpzmCAlxPnw1x9ymXLV/408df4pWSMy83rBwL969DzE2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1765884841; c=relaxed/simple;
	bh=NHDkJtnHTJRSWH7coEhSNq7cUXhwoIS2GgA4LL/DL80=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZVK0LNiu5GWNvckMQc0FQs842MELOZGHaiFPkbWkSMaDc2JILqYCYg3UuUIxNLoQEqk+X4PWbFAZYRFShLZ9if76OC9x4RvxV1bmhZ+88GAV0fABpFQVRB+kdr2WjjzOuI2WYMhJN+n7on5n4ZTDd3B0NmerM7QxdZWpTiGAgTM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=SjpPzSHk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="SjpPzSHk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 20243C4CEF1;
	Tue, 16 Dec 2025 11:34:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1765884841;
	bh=NHDkJtnHTJRSWH7coEhSNq7cUXhwoIS2GgA4LL/DL80=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SjpPzSHkGJ+/1ol2r66sJcZ/wPMgM3bh8gcaLJK80AT/XVdiJdODJVF2LOlP8RAHC
	 c464+hS7GlF2kmk4DuLAp9e2Yrb4CHKHaO5LhsXVnO6rM7mqURMX5xKxykF/qzZu3b
	 0/RFbeNkNhsljc9Cy0ESQ0wcBPOmSOn6UhkkUKh0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
	Lukasz Majewski <lukma@denx.de>,
	Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	=?UTF-8?q?=C5=81ukasz=20Majewski?= <lukma@nabladev.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 282/354] net: hsr: create an API to get hsr port type
Date: Tue, 16 Dec 2025 12:14:09 +0100
Message-ID: <20251216111331.130795573@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251216111320.896758933@linuxfoundation.org>
References: <20251216111320.896758933@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>

[ Upstream commit a0244e76213980f3b9bb5d40b0b6705fcf24230d ]

Since the introduction of HSR_PT_INTERLINK in commit 5055cccfc2d1 ("net:
hsr: Provide RedBox support (HSR-SAN)"), we see that different port
types require different settings for hardware offload, which was not the
case before when we only had HSR_PT_SLAVE_A and HSR_PT_SLAVE_B. But
there is currently no way to know which port is which type, so create
the hsr_get_port_type() API function and export it.

When hsr_get_port_type() is called from the device driver, the port can
must be found in the HSR port list. An important use case is for this
function to work from offloading drivers' NETDEV_CHANGEUPPER handler,
which is triggered by hsr_portdev_setup() -> netdev_master_upper_dev_link().
Therefore, we need to move the addition of the hsr_port to the HSR port
list prior to calling hsr_portdev_setup(). This makes the error
restoration path also more similar to hsr_del_port(), where
kfree_rcu(port) is already used.

Cc: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: Lukasz Majewski <lukma@denx.de>
Signed-off-by: Xiaoliang Yang <xiaoliang.yang_1@nxp.com>
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Reviewed-by: Łukasz Majewski <lukma@nabladev.com>
Link: https://patch.msgid.link/20251130131657.65080-3-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 30296ac76426 ("net: dsa: xrs700x: reject unsupported HSR configurations")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_hsr.h |  9 +++++++++
 net/hsr/hsr_device.c   | 20 ++++++++++++++++++++
 net/hsr/hsr_slave.c    |  7 ++++---
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/include/linux/if_hsr.h b/include/linux/if_hsr.h
index d7941fd880329..f4cf2dd36d193 100644
--- a/include/linux/if_hsr.h
+++ b/include/linux/if_hsr.h
@@ -43,6 +43,8 @@ extern bool is_hsr_master(struct net_device *dev);
 extern int hsr_get_version(struct net_device *dev, enum hsr_version *ver);
 struct net_device *hsr_get_port_ndev(struct net_device *ndev,
 				     enum hsr_port_type pt);
+int hsr_get_port_type(struct net_device *hsr_dev, struct net_device *dev,
+		      enum hsr_port_type *type);
 #else
 static inline bool is_hsr_master(struct net_device *dev)
 {
@@ -59,6 +61,13 @@ static inline struct net_device *hsr_get_port_ndev(struct net_device *ndev,
 {
 	return ERR_PTR(-EINVAL);
 }
+
+static inline int hsr_get_port_type(struct net_device *hsr_dev,
+				    struct net_device *dev,
+				    enum hsr_port_type *type)
+{
+	return -EINVAL;
+}
 #endif /* CONFIG_HSR */
 
 #endif /*_LINUX_IF_HSR_H_*/
diff --git a/net/hsr/hsr_device.c b/net/hsr/hsr_device.c
index c568d91764235..386aba50930a3 100644
--- a/net/hsr/hsr_device.c
+++ b/net/hsr/hsr_device.c
@@ -689,6 +689,26 @@ struct net_device *hsr_get_port_ndev(struct net_device *ndev,
 }
 EXPORT_SYMBOL(hsr_get_port_ndev);
 
+int hsr_get_port_type(struct net_device *hsr_dev, struct net_device *dev,
+		      enum hsr_port_type *type)
+{
+	struct hsr_priv *hsr = netdev_priv(hsr_dev);
+	struct hsr_port *port;
+
+	rcu_read_lock();
+	hsr_for_each_port(hsr, port) {
+		if (port->dev == dev) {
+			*type = port->type;
+			rcu_read_unlock();
+			return 0;
+		}
+	}
+	rcu_read_unlock();
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(hsr_get_port_type);
+
 /* Default multicast address for HSR Supervision frames */
 static const unsigned char def_multicast_addr[ETH_ALEN] __aligned(2) = {
 	0x01, 0x15, 0x4e, 0x00, 0x01, 0x00
diff --git a/net/hsr/hsr_slave.c b/net/hsr/hsr_slave.c
index 9ac7cf0835118..70472726c6049 100644
--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -203,14 +203,14 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 	port->dev = dev;
 	port->type = type;
 
+	list_add_tail_rcu(&port->port_list, &hsr->ports);
+
 	if (type != HSR_PT_MASTER) {
 		res = hsr_portdev_setup(hsr, dev, port, extack);
 		if (res)
 			goto fail_dev_setup;
 	}
 
-	list_add_tail_rcu(&port->port_list, &hsr->ports);
-
 	master = hsr_port_get_hsr(hsr, HSR_PT_MASTER);
 	netdev_update_features(master->dev);
 	dev_set_mtu(master->dev, hsr_get_max_mtu(hsr));
@@ -218,7 +218,8 @@ int hsr_add_port(struct hsr_priv *hsr, struct net_device *dev,
 	return 0;
 
 fail_dev_setup:
-	kfree(port);
+	list_del_rcu(&port->port_list);
+	kfree_rcu(port, rcu);
 	return res;
 }
 
-- 
2.51.0



