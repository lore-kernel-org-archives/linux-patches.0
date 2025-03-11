Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF11425F790;
	Tue, 11 Mar 2025 15:33:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707207; cv=none; b=V6fCm8xsycYQpg9gPxQDycTfAPmu3VCZxZY8ShGvraURLu/5SbycJlGAE4Hnatk49885mEOSSl6wbNycTvAe+VrA//CZG2SG1i1UFHLjhoge6T0HGf+X8zb6FzqC2j0tJSqQ/zvBQVoGAPM7HrB5cIFb7cC5vlTpn67koWH/UYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707207; c=relaxed/simple;
	bh=J3MLoOQsxTRc6urU98tzulelVyKY6z1NjIDRGiitPOg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tiNrclRh6xxzDDz6myVRHGXeDPGyl5rgQrAnbZ0bEb72lq3hMYewI8EDCT6YcvJKKIFammEnqgATmlwNhV9xYw+KBDTgRyllPECD6z5uqzGNvlmbD9JirjGVPSiDBTaNPo5QwKMFQvDbxcW3G+umRqbFUJsFxxnXR3iKm0IF1oU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IF3r3qCO; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IF3r3qCO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 547EAC4CEE9;
	Tue, 11 Mar 2025 15:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707207;
	bh=J3MLoOQsxTRc6urU98tzulelVyKY6z1NjIDRGiitPOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IF3r3qCOOl52Q9kwTeD1TDNaZ3LzOpHW4xEBIBnQPRHebRWVJ2XX6CTCXBL1z4RPT
	 gxdtvgsV4dRBfZC/rTvR9+ym0b9gFmPm8RzinJwMLLc3b62smZ8qKyZZNeMG0OdXGn
	 nEXoamYvDjwFNYJqd1jm0qk5WVDH3F7RyUnX4NOU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xin Long <lucien.xin@gmail.com>,
	"David S. Miller" <davem@davemloft.net>,
	Olivier Matz <olivier.matz@6wind.com>,
	Ivan Delalande <colona@arista.com>
Subject: [PATCH 5.10 309/462] vlan: introduce vlan_dev_free_egress_priority
Date: Tue, 11 Mar 2025 15:59:35 +0100
Message-ID: <20250311145810.567031935@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Ivan Delalande <colona@arista.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/8021q/vlan.h         |    2 +-
 net/8021q/vlan_dev.c     |    7 ++++++-
 net/8021q/vlan_netlink.c |    7 ++++---
 3 files changed, 11 insertions(+), 5 deletions(-)

--- a/net/8021q/vlan.h
+++ b/net/8021q/vlan.h
@@ -124,6 +124,7 @@ void vlan_dev_set_ingress_priority(const
 				   u32 skb_prio, u16 vlan_prio);
 int vlan_dev_set_egress_priority(const struct net_device *dev,
 				 u32 skb_prio, u16 vlan_prio);
+void vlan_dev_free_egress_priority(const struct net_device *dev);
 int vlan_dev_change_flags(const struct net_device *dev, u32 flag, u32 mask);
 void vlan_dev_get_realdev_name(const struct net_device *dev, char *result);
 
@@ -133,7 +134,6 @@ int vlan_check_real_dev(struct net_devic
 void vlan_setup(struct net_device *dev);
 int register_vlan_dev(struct net_device *dev, struct netlink_ext_ack *extack);
 void unregister_vlan_dev(struct net_device *dev, struct list_head *head);
-void vlan_dev_uninit(struct net_device *dev);
 bool vlan_dev_inherit_address(struct net_device *dev,
 			      struct net_device *real_dev);
 
--- a/net/8021q/vlan_dev.c
+++ b/net/8021q/vlan_dev.c
@@ -613,7 +613,7 @@ static int vlan_dev_init(struct net_devi
 }
 
 /* Note: this function might be called multiple times for the same device. */
-void vlan_dev_uninit(struct net_device *dev)
+void vlan_dev_free_egress_priority(const struct net_device *dev)
 {
 	struct vlan_priority_tci_mapping *pm;
 	struct vlan_dev_priv *vlan = vlan_dev_priv(dev);
@@ -627,6 +627,11 @@ void vlan_dev_uninit(struct net_device *
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
@@ -187,10 +187,11 @@ static int vlan_newlink(struct net *src_
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
 


