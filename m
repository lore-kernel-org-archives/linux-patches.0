Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D5F814F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y95ubzTA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0288CC433C7;
	Mon, 23 Oct 2023 11:22:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060154;
	bh=HTwWeekizCdQoXAtIzHBgWtL7IDRWZUmYdxN7ddKFNg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y95ubzTAGrHLuIdF8xvGCBVcL3Kr8H8r2WMTIInGE+G0XsuQpPRxZ1gR/aubsgf+s
	 xkT8TwbgBY2ZOGLyy6IkgRRpCnJvW8tQcQvkt0h9tawll7PuCvrr4AZ32hnDeQcVwl
	 Yhyp/e70UB2seBzgdLKg18yhyFWyKbrK8shYSXaw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 076/196] net: check for altname conflicts when changing netdevs netns
Date: Mon, 23 Oct 2023 12:55:41 +0200
Message-ID: <20231023104830.698361283@linuxfoundation.org>
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

commit 7663d522099ecc464512164e660bc771b2ff7b64 upstream.

It's currently possible to create an altname conflicting
with an altname or real name of another device by creating
it in another netns and moving it over:

 [ ~]$ ip link add dev eth0 type dummy

 [ ~]$ ip netns add test
 [ ~]$ ip -netns test link add dev ethX netns test type dummy
 [ ~]$ ip -netns test link property add dev ethX altname eth0
 [ ~]$ ip -netns test link set dev ethX netns 1

 [ ~]$ ip link
 ...
 3: eth0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 02:40:88:62:ec:b8 brd ff:ff:ff:ff:ff:ff
 ...
 5: ethX: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN mode DEFAULT group default qlen 1000
     link/ether 26:b7:28:78:38:0f brd ff:ff:ff:ff:ff:ff
     altname eth0

Create a macro for walking the altnames, this hopefully makes
it clearer that the list we walk contains only altnames.
Which is otherwise not entirely intuitive.

Fixes: 36fbf1e52bd3 ("net: rtnetlink: add linkprop commands to add and delete alternative ifnames")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    9 ++++++++-
 net/core/dev.h |    3 +++
 2 files changed, 11 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1054,7 +1054,8 @@ static int __dev_alloc_name(struct net *
 
 		for_each_netdev(net, d) {
 			struct netdev_name_node *name_node;
-			list_for_each_entry(name_node, &d->name_node->list, list) {
+
+			netdev_for_each_altname(d, name_node) {
 				if (!sscanf(name_node->name, name, &i))
 					continue;
 				if (i < 0 || i >= max_netdevices)
@@ -10949,6 +10950,7 @@ EXPORT_SYMBOL(unregister_netdev);
 int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 			       const char *pat, int new_ifindex)
 {
+	struct netdev_name_node *name_node;
 	struct net *net_old = dev_net(dev);
 	char new_name[IFNAMSIZ] = {};
 	int err, new_nsid;
@@ -10981,6 +10983,11 @@ int __dev_change_net_namespace(struct ne
 		if (err < 0)
 			goto out;
 	}
+	/* Check that none of the altnames conflicts. */
+	err = -EEXIST;
+	netdev_for_each_altname(dev, name_node)
+		if (netdev_name_in_use(net, name_node->name))
+			goto out;
 
 	/* Check that new_ifindex isn't used yet. */
 	err = -EBUSY;
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -61,6 +61,9 @@ struct netdev_name_node {
 int netdev_get_name(struct net *net, char *name, int ifindex);
 int dev_change_name(struct net_device *dev, const char *newname);
 
+#define netdev_for_each_altname(dev, namenode)				\
+	list_for_each_entry((namenode), &(dev)->name_node->list, list)
+
 int netdev_name_node_alt_create(struct net_device *dev, const char *name);
 int netdev_name_node_alt_destroy(struct net_device *dev, const char *name);
 


