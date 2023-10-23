Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0CFF315E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:28:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="F9alNztf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B76EC433C8;
	Mon, 23 Oct 2023 11:28:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060496;
	bh=79M3672aYhrt6KN6ZLZsLrYHepXjUf3tOfI4Et5yxQE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=F9alNztfyseGxL8CVpuuvegajiFPqa0vpGcEdRnipaBKlFioknuvraEssi44bQiG1
	 qjeEg+osczU+Wy7lrANqwfV/wEwpcxEfDUieqTH2JhgrgD+ufpv4eSKEQr3Xk3h/fZ
	 CrJPN92YYFiQLis4zUPF/rjyIoKtJFIDdMOHThcQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 191/196] net: move altnames together with the netdevice
Date: Mon, 23 Oct 2023 12:57:36 +0200
Message-ID: <20231023104833.766378653@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit 8e15aee621618a3ee3abecaf1fd8c1428098b7ef upstream.

The altname nodes are currently not moved to the new netns
when netdevice itself moves:

  [ ~]# ip netns add test
  [ ~]# ip -netns test link add name eth0 type dummy
  [ ~]# ip -netns test link property add dev eth0 altname some-name
  [ ~]# ip -netns test link show dev some-name
  2: eth0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 1e:67:ed:19:3d:24 brd ff:ff:ff:ff:ff:ff
      altname some-name
  [ ~]# ip -netns test link set dev eth0 netns 1
  [ ~]# ip link
  ...
  3: eth0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
      link/ether 02:40:88:62:ec:b8 brd ff:ff:ff:ff:ff:ff
      altname some-name
  [ ~]# ip li show dev some-name
  Device "some-name" does not exist.

Remove them from the hash table when device is unlisted
and add back when listed again.

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |   13 +++++++++----
 1 file changed, 9 insertions(+), 4 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -381,6 +381,7 @@ static void netdev_name_node_alt_flush(s
 /* Device list insertion */
 static void list_netdevice(struct net_device *dev)
 {
+	struct netdev_name_node *name_node;
 	struct net *net = dev_net(dev);
 
 	ASSERT_RTNL();
@@ -392,6 +393,9 @@ static void list_netdevice(struct net_de
 			   dev_index_hash(net, dev->ifindex));
 	write_unlock(&dev_base_lock);
 
+	netdev_for_each_altname(dev, name_node)
+		netdev_name_node_add(net, name_node);
+
 	dev_base_seq_inc(net);
 }
 
@@ -400,8 +404,13 @@ static void list_netdevice(struct net_de
  */
 static void unlist_netdevice(struct net_device *dev, bool lock)
 {
+	struct netdev_name_node *name_node;
+
 	ASSERT_RTNL();
 
+	netdev_for_each_altname(dev, name_node)
+		netdev_name_node_del(name_node);
+
 	/* Unlink dev from the device chain */
 	if (lock)
 		write_lock(&dev_base_lock);
@@ -10851,7 +10860,6 @@ void unregister_netdevice_many(struct li
 	synchronize_net();
 
 	list_for_each_entry(dev, head, unreg_list) {
-		struct netdev_name_node *name_node;
 		struct sk_buff *skb = NULL;
 
 		/* Shutdown queueing discipline. */
@@ -10877,9 +10885,6 @@ void unregister_netdevice_many(struct li
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
-		netdev_for_each_altname(dev, name_node)
-			netdev_name_node_del(name_node);
-		synchronize_rcu();
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 


