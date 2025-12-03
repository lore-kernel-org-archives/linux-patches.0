Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F35AD3590A2;
	Wed,  3 Dec 2025 16:36:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764779769; cv=none; b=RKhLFSHi94WsL76y4TGUumsUBk1MEKqM3jOiaYke3y/uqqb+uJ7VtNFbVluqVRwfmN3i3IU4tyaDAy3UvYdyi4pHIT9tGSjkVy2no39/SvEMidnqNIKemwXc5OTZGQmNN45vPJ+oYMK3TADK3mY4/EORn5xvmVbfFigI1SkCRhA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764779769; c=relaxed/simple;
	bh=8I+N0Tdmfx16Y6KSAN5IuWQ7omjJkKX6J6J4oUTEIco=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U3El3+yAtuyklF/7XIkFIBvZ40Vt84trRvTtn0ZFwk/4q6ZRb39R1q5FDpk+dzs0LWSSMNLjDO5nmNz2oqKXOYSFQKU/ulg4TycC0jExkyVlvNleYbtT1idJVbaT4ztIORgUQNbjoQ2gT7Ym3M3doO6XmfI+YXF4qCdD2/pW2GI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HGzmsP8Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HGzmsP8Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A6C6C4CEF5;
	Wed,  3 Dec 2025 16:36:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764779768;
	bh=8I+N0Tdmfx16Y6KSAN5IuWQ7omjJkKX6J6J4oUTEIco=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HGzmsP8ZJZfk2l1KY4ekxOSLenXqi3+uz88+HMtB1vctNzZExrRyxRygXgxEA03ol
	 u8+mnWqHvr7gbuURxCQ8gaAPCJ1v6DZ3zQTjOF5QbPwpl+/fvBwzsHiNJ1KjREwXMW
	 nx9vWk6eHzcbCNsf3lE/zzrwFc9H49CxEt/R7RNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 323/568] net: bridge: fix MST static key usage
Date: Wed,  3 Dec 2025 16:25:25 +0100
Message-ID: <20251203152452.542451038@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251203152440.645416925@linuxfoundation.org>
References: <20251203152440.645416925@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikolay Aleksandrov <razor@blackwall.org>

[ Upstream commit ee87c63f9b2a418f698d79c2991347e31a7d2c27 ]

As Ido pointed out, the static key usage in MST is buggy and should use
inc/dec instead of enable/disable because we can have multiple bridges
with MST enabled which means a single bridge can disable MST for all.
Use static_branch_inc/dec to avoid that. When destroying a bridge decrement
the key if MST was enabled.

Fixes: ec7328b59176 ("net: bridge: mst: Multiple Spanning Tree (MST) mode")
Reported-by: Ido Schimmel <idosch@nvidia.com>
Closes: https://lore.kernel.org/netdev/20251104120313.1306566-1-razor@blackwall.org/T/#m6888d87658f94ed1725433940f4f4ebb00b5a68b
Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
Reviewed-by: Ido Schimmel <idosch@nvidia.com>
Link: https://patch.msgid.link/20251105111919.1499702-3-razor@blackwall.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/bridge/br_if.c      |  1 +
 net/bridge/br_mst.c     | 10 ++++++++--
 net/bridge/br_private.h |  5 +++++
 3 files changed, 14 insertions(+), 2 deletions(-)

diff --git a/net/bridge/br_if.c b/net/bridge/br_if.c
index 0989074f316ef..42495d643a1bc 100644
--- a/net/bridge/br_if.c
+++ b/net/bridge/br_if.c
@@ -386,6 +386,7 @@ void br_dev_delete(struct net_device *dev, struct list_head *head)
 		del_nbp(p);
 	}
 
+	br_mst_uninit(br);
 	br_recalculate_neigh_suppress_enabled(br);
 
 	br_fdb_delete_by_port(br, NULL, 0, 1);
diff --git a/net/bridge/br_mst.c b/net/bridge/br_mst.c
index 3f24b4ee49c27..43a300ae6bfaf 100644
--- a/net/bridge/br_mst.c
+++ b/net/bridge/br_mst.c
@@ -22,6 +22,12 @@ bool br_mst_enabled(const struct net_device *dev)
 }
 EXPORT_SYMBOL_GPL(br_mst_enabled);
 
+void br_mst_uninit(struct net_bridge *br)
+{
+	if (br_opt_get(br, BROPT_MST_ENABLED))
+		static_branch_dec(&br_mst_used);
+}
+
 int br_mst_get_info(const struct net_device *dev, u16 msti, unsigned long *vids)
 {
 	const struct net_bridge_vlan_group *vg;
@@ -225,9 +231,9 @@ int br_mst_set_enabled(struct net_bridge *br, bool on,
 		return err;
 
 	if (on)
-		static_branch_enable(&br_mst_used);
+		static_branch_inc(&br_mst_used);
 	else
-		static_branch_disable(&br_mst_used);
+		static_branch_dec(&br_mst_used);
 
 	br_opt_toggle(br, BROPT_MST_ENABLED, on);
 	return 0;
diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
index 372e9664b2cb8..901b9f609b0c7 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1821,6 +1821,7 @@ int br_mst_fill_info(struct sk_buff *skb,
 		     const struct net_bridge_vlan_group *vg);
 int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
 		   struct netlink_ext_ack *extack);
+void br_mst_uninit(struct net_bridge *br);
 #else
 static inline bool br_mst_is_enabled(const struct net_bridge_port *p)
 {
@@ -1856,6 +1857,10 @@ static inline int br_mst_process(struct net_bridge_port *p,
 {
 	return -EOPNOTSUPP;
 }
+
+static inline void br_mst_uninit(struct net_bridge *br)
+{
+}
 #endif
 
 struct nf_br_ops {
-- 
2.51.0



