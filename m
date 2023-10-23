Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C43D215E83
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:39:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PWeg4Vf9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3A50AC433C7;
	Mon, 23 Oct 2023 11:39:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698061187;
	bh=9kwqtBtiyNzod2XPWHEXVc7bcmhxt+DjPFWjbSmjj08=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PWeg4Vf9TZf2oG8psTLBOsbnzkSuL+7tSsoWttscCnQtKH/aW8zPOoJ6LLrKx2pGp
	 hLDqGgRc8iRYiSpJ8E9AS+FQmN5oL9c7K3FWVZajNSjmIW+ezeF/XPao73/RGUtKIh
	 //4XCUzJ2GRxI6gifHrh7Eq5w1AJFSVnc1t4yGPg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Kicinski <kuba@kernel.org>,
	Jiri Pirko <jiri@nvidia.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 101/137] net: fix ifname in netlink ntf during netns move
Date: Mon, 23 Oct 2023 12:57:38 +0200
Message-ID: <20231023104824.262611983@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104820.849461819@linuxfoundation.org>
References: <20231023104820.849461819@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 311cca40661f428b7aa114fb5af578cfdbe3e8b6 ]

dev_get_valid_name() overwrites the netdev's name on success.
This makes it hard to use in prepare-commit-like fashion,
where we do validation first, and "commit" to the change
later.

Factor out a helper which lets us save the new name to a buffer.
Use it to fix the problem of notification on netns move having
incorrect name:

 5: eth0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
     link/ether be:4d:58:f9:d5:40 brd ff:ff:ff:ff:ff:ff
 6: eth1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
     link/ether 1e:4a:34:36:e3:cd brd ff:ff:ff:ff:ff:ff

 [ ~]# ip link set dev eth0 netns 1 name eth1

ip monitor inside netns:
 Deleted inet eth0
 Deleted inet6 eth0
 Deleted 5: eth1: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default
     link/ether be:4d:58:f9:d5:40 brd ff:ff:ff:ff:ff:ff new-netnsid 0 new-ifindex 7

Name is reported as eth1 in old netns for ifindex 5, already renamed.

Fixes: d90310243fd7 ("net: device name allocation cleanups")
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Reviewed-by: Jiri Pirko <jiri@nvidia.com>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/dev.c | 44 +++++++++++++++++++++++++++++++-------------
 1 file changed, 31 insertions(+), 13 deletions(-)

diff --git a/net/core/dev.c b/net/core/dev.c
index af0e0ce53ca52..8f4f355a963f8 100644
--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -1151,6 +1151,26 @@ static int __dev_alloc_name(struct net *net, const char *name, char *buf)
 	return -ENFILE;
 }
 
+static int dev_prep_valid_name(struct net *net, struct net_device *dev,
+			       const char *want_name, char *out_name)
+{
+	int ret;
+
+	if (!dev_valid_name(want_name))
+		return -EINVAL;
+
+	if (strchr(want_name, '%')) {
+		ret = __dev_alloc_name(net, want_name, out_name);
+		return ret < 0 ? ret : 0;
+	} else if (netdev_name_in_use(net, want_name)) {
+		return -EEXIST;
+	} else if (out_name != want_name) {
+		strscpy(out_name, want_name, IFNAMSIZ);
+	}
+
+	return 0;
+}
+
 static int dev_alloc_name_ns(struct net *net,
 			     struct net_device *dev,
 			     const char *name)
@@ -1188,19 +1208,13 @@ EXPORT_SYMBOL(dev_alloc_name);
 static int dev_get_valid_name(struct net *net, struct net_device *dev,
 			      const char *name)
 {
-	BUG_ON(!net);
-
-	if (!dev_valid_name(name))
-		return -EINVAL;
-
-	if (strchr(name, '%'))
-		return dev_alloc_name_ns(net, dev, name);
-	else if (netdev_name_in_use(net, name))
-		return -EEXIST;
-	else if (dev->name != name)
-		strscpy(dev->name, name, IFNAMSIZ);
+	char buf[IFNAMSIZ];
+	int ret;
 
-	return 0;
+	ret = dev_prep_valid_name(net, dev, name, buf);
+	if (ret >= 0)
+		strscpy(dev->name, buf, IFNAMSIZ);
+	return ret;
 }
 
 /**
@@ -11154,6 +11168,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 			       const char *pat, int new_ifindex)
 {
 	struct net *net_old = dev_net(dev);
+	char new_name[IFNAMSIZ] = {};
 	int err, new_nsid;
 
 	ASSERT_RTNL();
@@ -11180,7 +11195,7 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 		/* We get here if we can't use the current device name */
 		if (!pat)
 			goto out;
-		err = dev_get_valid_name(net, dev, pat);
+		err = dev_prep_valid_name(net, dev, pat, new_name);
 		if (err < 0)
 			goto out;
 	}
@@ -11248,6 +11263,9 @@ int __dev_change_net_namespace(struct net_device *dev, struct net *net,
 	kobject_uevent(&dev->dev.kobj, KOBJ_ADD);
 	netdev_adjacent_add_links(dev);
 
+	if (new_name[0]) /* Rename the netdev to prepared name */
+		strscpy(dev->name, new_name, IFNAMSIZ);
+
 	/* Fixup kobjects */
 	err = device_rename(&dev->dev, dev->name);
 	WARN_ON(err);
-- 
2.40.1



