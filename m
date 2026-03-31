Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1F11423A61;
	Tue, 31 Mar 2026 16:50:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774975800; cv=none; b=BXI0tQgLb6qDDLc4Qmf4UJyh+LRQrvdxn3sceYCJsNqKEQVgk9YTHn8gWrFUJ89QHvkx8ceTRHvZrdvGvgVU12eD7vGOwLzpt6CtGOfxxpuZ1uYgalVYfxUgOU2tZ9SmematKn5hYk4qGLQwK1X5LhtDoqL7l/nLOZtK+mdtMZ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774975800; c=relaxed/simple;
	bh=nEKz+n9fWPmahof70LnSN2F99RcpOlB5wJSZwekuIKI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VZ12aoFsPyXcd/WoplD3wIGabNtQJzuP36p3DxyAmzUpOQoep/h2PWbGy9uZ1648cKFk3dJjcpO0tJqLL1ChRktX0qkqtW+e6ZpuJx0Pk1Cw4ZmkeTBesN3FVooejp5DyCp1vkLxVBLt3Vpd+DSiNeJc4pzy9Kb19xxr512+Cgc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NL6hVsLL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NL6hVsLL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3809BC19423;
	Tue, 31 Mar 2026 16:50:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774975800;
	bh=nEKz+n9fWPmahof70LnSN2F99RcpOlB5wJSZwekuIKI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NL6hVsLLYAraDFQ28dgxs8LfTf2U09PomVqsK8zSrxxvX3UZiSFzD1XZ9O+i/A6Rj
	 1W5JszDyU8qgvy9k+jlkbgiBPtPrZVTvH6Gh8k8D5PK1/o8elpoeo3l+/yFfriqGOL
	 a+tLxLhLhLNWrwAIQXKf0GxnDhYDYPdKYKOzSsWQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+3d8bc31c45e11450f24c@syzkaller.appspotmail.com,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Jiayuan Chen <jiayuan.chen@shopee.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 091/244] team: fix header_ops type confusion with non-Ethernet ports
Date: Tue, 31 Mar 2026 18:20:41 +0200
Message-ID: <20260331161745.037345924@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161741.651718120@linuxfoundation.org>
References: <20260331161741.651718120@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiayuan Chen <jiayuan.chen@shopee.com>

[ Upstream commit 425000dbf17373a4ab8be9428f5dc055ef870a56 ]

Similar to commit 950803f72547 ("bonding: fix type confusion in
bond_setup_by_slave()") team has the same class of header_ops type
confusion.

For non-Ethernet ports, team_setup_by_port() copies port_dev->header_ops
directly. When the team device later calls dev_hard_header() or
dev_parse_header(), these callbacks can run with the team net_device
instead of the real lower device, so netdev_priv(dev) is interpreted as
the wrong private type and can crash.

The syzbot report shows a crash in bond_header_create(), but the root
cause is in team: the topology is gre -> bond -> team, and team calls
the inherited header_ops with its own net_device instead of the lower
device, so bond_header_create() receives a team device and interprets
netdev_priv() as bonding private data, causing a type confusion crash.

Fix this by introducing team header_ops wrappers for create/parse,
selecting a team port under RCU, and calling the lower device callbacks
with port->dev, so each callback always sees the correct net_device
context.

Also pass the selected lower device to the lower parse callback, so
recursion is bounded in stacked non-Ethernet topologies and parse
callbacks always run with the correct device context.

Fixes: 1d76efe1577b ("team: add support for non-ethernet devices")
Reported-by: syzbot+3d8bc31c45e11450f24c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/all/69b46af7.050a0220.36eb34.000e.GAE@google.com/T/
Cc: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Jiayuan Chen <jiayuan.chen@shopee.com>
Link: https://patch.msgid.link/20260320072139.134249-2-jiayuan.chen@linux.dev
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/team/team_core.c | 65 +++++++++++++++++++++++++++++++++++-
 1 file changed, 64 insertions(+), 1 deletion(-)

diff --git a/drivers/net/team/team_core.c b/drivers/net/team/team_core.c
index 50732f9699eea..3cbaee3ff5fd7 100644
--- a/drivers/net/team/team_core.c
+++ b/drivers/net/team/team_core.c
@@ -2133,6 +2133,68 @@ static const struct ethtool_ops team_ethtool_ops = {
  * rt netlink interface
  ***********************/
 
+/* For tx path we need a linkup && enabled port and for parse any port
+ * suffices.
+ */
+static struct team_port *team_header_port_get_rcu(struct team *team,
+						  bool txable)
+{
+	struct team_port *port;
+
+	list_for_each_entry_rcu(port, &team->port_list, list) {
+		if (!txable || team_port_txable(port))
+			return port;
+	}
+
+	return NULL;
+}
+
+static int team_header_create(struct sk_buff *skb, struct net_device *team_dev,
+			      unsigned short type, const void *daddr,
+			      const void *saddr, unsigned int len)
+{
+	struct team *team = netdev_priv(team_dev);
+	const struct header_ops *port_ops;
+	struct team_port *port;
+	int ret = 0;
+
+	rcu_read_lock();
+	port = team_header_port_get_rcu(team, true);
+	if (port) {
+		port_ops = READ_ONCE(port->dev->header_ops);
+		if (port_ops && port_ops->create)
+			ret = port_ops->create(skb, port->dev,
+					       type, daddr, saddr, len);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static int team_header_parse(const struct sk_buff *skb,
+			     const struct net_device *team_dev,
+			     unsigned char *haddr)
+{
+	struct team *team = netdev_priv(team_dev);
+	const struct header_ops *port_ops;
+	struct team_port *port;
+	int ret = 0;
+
+	rcu_read_lock();
+	port = team_header_port_get_rcu(team, false);
+	if (port) {
+		port_ops = READ_ONCE(port->dev->header_ops);
+		if (port_ops && port_ops->parse)
+			ret = port_ops->parse(skb, port->dev, haddr);
+	}
+	rcu_read_unlock();
+	return ret;
+}
+
+static const struct header_ops team_header_ops = {
+	.create		= team_header_create,
+	.parse		= team_header_parse,
+};
+
 static void team_setup_by_port(struct net_device *dev,
 			       struct net_device *port_dev)
 {
@@ -2141,7 +2203,8 @@ static void team_setup_by_port(struct net_device *dev,
 	if (port_dev->type == ARPHRD_ETHER)
 		dev->header_ops	= team->header_ops_cache;
 	else
-		dev->header_ops	= port_dev->header_ops;
+		dev->header_ops	= port_dev->header_ops ?
+				  &team_header_ops : NULL;
 	dev->type = port_dev->type;
 	dev->hard_header_len = port_dev->hard_header_len;
 	dev->needed_headroom = port_dev->needed_headroom;
-- 
2.51.0



