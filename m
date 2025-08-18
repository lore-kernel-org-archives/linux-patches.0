Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D313922A7E0;
	Mon, 18 Aug 2025 13:31:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755523875; cv=none; b=AA5PWAG+IB6ZHXWjttaUMHB32CiRNaF/DfvDA6amx1SQVeH9Yw9jNherYPCnNmntJpVHe5KA4vlrYi7C9SItMswm/89Rd9ICVVY98Uj5qlo70eJVt+anga0SqBGnI9u//8gVKNgcPH/uXOEzwRJ2/KBU6IYWA/AlDb2AQb5DS7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755523875; c=relaxed/simple;
	bh=Xq4gue0Y2oPL+3JOkfK/P0pkgBKwQIYGCDfw/trTQWo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=rqqjGKJxYXR9al1l7cjG+s1fHra1UrKGF3iJaPWoYxiANr+IXoerm0jDT03XpiGZ+9uo7lXaWtLv3DozGpl5/q5FAUGL3EdITb8z+5E/+QgpQ45pT0KP2MHAVqeIgQ9lVA8Zk0UfguBkJ7tPjirPSp+lOu7KfbnSx6tPH7+/m7U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h4gfUcc4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h4gfUcc4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AC1AC4CEEB;
	Mon, 18 Aug 2025 13:31:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755523875;
	bh=Xq4gue0Y2oPL+3JOkfK/P0pkgBKwQIYGCDfw/trTQWo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=h4gfUcc4gTdCn8iCapBF6cfkToIkGyFeObru3zjOd4vg4Y8TbToMl+gkmFZCNk3R2
	 aSHsJvdF3bqYVMXSB3qcIXdWD/JnwZGwjfTD6qJsQNOo3fT6hwwd9B8HaBgOXGl34K
	 tvjDi3v1CQFS4JJIq6evv77Z/0ZZF/qMMs+A0mMA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 300/515] net: vlan: Make is_vlan_dev() a stub when VLAN is not configured
Date: Mon, 18 Aug 2025 14:44:46 +0200
Message-ID: <20250818124509.978724144@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124458.334548733@linuxfoundation.org>
References: <20250818124458.334548733@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Gal Pressman <gal@nvidia.com>

[ Upstream commit 2de1ba0887e5d3bf02d7c212f380039b34e10aa3 ]

Add a stub implementation of is_vlan_dev() that returns false when
VLAN support is not compiled in (CONFIG_VLAN_8021Q=n).

This allows us to compile-out VLAN-dependent dead code when it is not
needed.

This also resolves the following compilation error when:
* CONFIG_VLAN_8021Q=n
* CONFIG_OBJTOOL=y
* CONFIG_OBJTOOL_WERROR=y

drivers/net/ethernet/mellanox/mlx5/core/mlx5_core.o: error: objtool: parse_mirred.isra.0+0x370: mlx5e_tc_act_vlan_add_push_action() missing __noreturn in .c/.h or NORETURN() in noreturns.h

The error occurs because objtool cannot determine that unreachable BUG()
(which doesn't return) calls in VLAN code paths are actually dead code
when VLAN support is disabled.

Signed-off-by: Gal Pressman <gal@nvidia.com>
Link: https://patch.msgid.link/20250616132626.1749331-2-gal@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 15 ++++++++++-----
 1 file changed, 10 insertions(+), 5 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 38456b42cdb5..618a973ff8ee 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -79,11 +79,6 @@ static inline struct vlan_ethhdr *skb_vlan_eth_hdr(const struct sk_buff *skb)
 /* found in socket.c */
 extern void vlan_ioctl_set(int (*hook)(struct net *, void __user *));
 
-static inline bool is_vlan_dev(const struct net_device *dev)
-{
-        return dev->priv_flags & IFF_802_1Q_VLAN;
-}
-
 #define skb_vlan_tag_present(__skb)	(!!(__skb)->vlan_all)
 #define skb_vlan_tag_get(__skb)		((__skb)->vlan_tci)
 #define skb_vlan_tag_get_id(__skb)	((__skb)->vlan_tci & VLAN_VID_MASK)
@@ -200,6 +195,11 @@ struct vlan_dev_priv {
 #endif
 };
 
+static inline bool is_vlan_dev(const struct net_device *dev)
+{
+	return dev->priv_flags & IFF_802_1Q_VLAN;
+}
+
 static inline struct vlan_dev_priv *vlan_dev_priv(const struct net_device *dev)
 {
 	return netdev_priv(dev);
@@ -237,6 +237,11 @@ extern void vlan_vids_del_by_dev(struct net_device *dev,
 extern bool vlan_uses_dev(const struct net_device *dev);
 
 #else
+static inline bool is_vlan_dev(const struct net_device *dev)
+{
+	return false;
+}
+
 static inline struct net_device *
 __vlan_find_dev_deep_rcu(struct net_device *real_dev,
 		     __be16 vlan_proto, u16 vlan_id)
-- 
2.39.5



