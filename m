Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AB1568BF8;
	Tue,  5 Dec 2023 03:41:10 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zA9OzBzi"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C0CEC433C8;
	Tue,  5 Dec 2023 03:41:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1701747670;
	bh=bzPUwTFNLv9O0uDSPloC+E+TNp3YeSNnQ63SGgXBpBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zA9OzBzisFnRqvhU3zh3oExFwwMuTjXFNuxYs8bNEGIdVRI5ApQsLYxNaeJslOkIA
	 v0ZvGJgi5NxwqRDsGcxhhqcPNHbd3RhKx2G4DUVxEMyefGLZjrVZq7bWDC3PXJUGSQ
	 H5ngbIAeYJhir8IR9Gz9OwdX5+Qr8hgzH+Sosoxc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Olivier Matz <olivier.matz@6wind.com>
Subject: [PATCH 5.15 25/67] vlan: introduce vlan_dev_free_egress_priority
Date: Tue,  5 Dec 2023 12:17:10 +0900
Message-ID: <20231205031521.240733406@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20231205031519.853779502@linuxfoundation.org>
References: <20231205031519.853779502@linuxfoundation.org>
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

From: Xin Long <lucien.xin@gmail.com>

commit 37aa50c539bcbcc01767e515bd170787fcfc0f33 upstream.

This patch is to introduce vlan_dev_free_egress_priority() to
free egress priority for vlan dev, and keep vlan_dev_uninit()
static as .ndo_uninit. It makes the code more clear and safer
when adding new code in vlan_dev_uninit() in the future.

Signed-off-by: Xin Long <lucien.xin@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Olivier Matz <olivier.matz@6wind.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.h         |    2 +-
 net/8021q/vlan_dev.c     |    7 ++++++-
 net/8021q/vlan_netlink.c |    7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -129,6 +129,7 @@ void vlan_dev_set_ingress_priority(const
 				   u32 skb_prio, u16 vlan_prio);
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
+void vlan_dev_free_egress_priority(const struct net_device *dev);
 int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result,
 			       size_t size);
@@ -139,7 +140,6 @@ int vlan_check_real_dev(struct net_devic
 void vlan_setup(struct net_device *dev);
 int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack);
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head);
-void vlan_dev_uninit(struct net_device *dev);
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev);
 
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -622,7 +622,7 @@ static int vlan_dev_init(struct net_devi
 }
 
 /* Note: this function might be called multiple times for the same device. */
-void vlan_dev_uninit(struct net_device *dev)
+void vlan_dev_free_egress_priority(const struct net_device *dev)
 {
 	struct vlan_priority_tci_mapping *pm;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
@@ -636,6 +636,11 @@ void vlan_dev_uninit(struct net_device *
 	}
 }
 
+static void vlan_dev_uninit(struct net_device *dev)
+{
+	vlan_dev_free_egress_priority(dev);
+}
+
 static netdev_features_t vlan_dev_fix_features(struct net_device *dev,
 	netdev_features_t features)
 {
--- a/net/8021q/vlan_netlink.c
+++ b/net/8021q/vlan_netlink.c
@@ -183,10 +183,11 @@ static int vlan_newlink(struct net *src_
 		return -EINVAL;
 
 	err = vlan_changelink(dev, tb, data, extack);
-	if (!err)
-		err = register_vlan_dev(dev, extack);
 	if (err)
-		vlan_dev_uninit(dev);
+		return err;
+	err = register_vlan_dev(dev, extack);
+	if (err)
+		vlan_dev_free_egress_priority(dev);
 	return err;
 }
 


