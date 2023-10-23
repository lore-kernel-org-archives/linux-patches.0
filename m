Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8EA514F6A
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:22:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="o2BDHb0r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 254B8C433C8;
	Mon, 23 Oct 2023 11:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060148;
	bh=PIAp5+viyOY56Bfh+rq+wGF4hzjCzjEe9SDhpABfQvo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=o2BDHb0rt76hdcHhGOYJhrCW5YBHiLsGAANjMmsJSNkZpZ8IXzO2JU0XRSx5B2VY/
	 /2EKrddMkOUFcgjMtNE6ElP7RisTYIODDN0v+qHDCq8XN5+zlKlvGuSDIYxD0fpipT
	 JOg1l4rvy3Q/Sz6EuiPEVpS3sN/vD657GhEqwMGA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jiri Pirko <jiri@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.1 074/196] net: avoid UAF on deleted altname
Date: Mon, 23 Oct 2023 12:55:39 +0200
Message-ID: <20231023104830.643689815@linuxfoundation.org>
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

commit 1a83f4a7c156fa6bbd6b530e89fa3270bf3d9d1b upstream.

Altnames are accessed under RCU (dev_get_by_name_rcu())
but freed by kfree() with no synchronization point.

Each node has one or two allocations (node and a variable-size
name, sometimes the name is netdev->name). Adding rcu_heads
here is a bit tedious. Besides most code which unlists the names
already has rcu barriers - so take the simpler approach of adding
synchronize_rcu(). Note that the one on the unregistration path
(which matters more) is removed by the next fix.

Fixes: ff92741270bf ("net: introduce name_node struct to be used in hashlist")
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c |    7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -345,7 +345,6 @@ int netdev_name_node_alt_create(struct n
 static void __netdev_name_node_alt_destroy(struct netdev_name_node *name_node)
 {
 	list_del(&name_node->list);
-	netdev_name_node_del(name_node);
 	kfree(name_node->name);
 	netdev_name_node_free(name_node);
 }
@@ -364,6 +363,8 @@ int netdev_name_node_alt_destroy(struct
 	if (name_node == dev->name_node || name_node->dev != dev)
 		return -EINVAL;
 
+	netdev_name_node_del(name_node);
+	synchronize_rcu();
 	__netdev_name_node_alt_destroy(name_node);
 
 	return 0;
@@ -10835,6 +10836,7 @@ void unregister_netdevice_many(struct li
 	synchronize_net();
 
 	list_for_each_entry(dev, head, unreg_list) {
+		struct netdev_name_node *name_node;
 		struct sk_buff *skb = NULL;
 
 		/* Shutdown queueing discipline. */
@@ -10860,6 +10862,9 @@ void unregister_netdevice_many(struct li
 		dev_uc_flush(dev);
 		dev_mc_flush(dev);
 
+		netdev_for_each_altname(dev, name_node)
+			netdev_name_node_del(name_node);
+		synchronize_rcu();
 		netdev_name_node_alt_flush(dev);
 		netdev_name_node_free(dev->name_node);
 


