Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3211F9F73;
	Tue, 26 Aug 2025 12:58:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756213111; cv=none; b=XHt9XwHZjWqzD58ZK6qbvtnMEKzvlpMh5niY/vtNZeCBwWAz23HGjkgOWWUezEGOlk+W5e3yeVPHrSAdbqIissIQo1jDrG3Y8n80/JDt0NFeLEMNWbUI8LY6gNtj9xTOa3ONSTVuZktLNhM3jZpZaVw6fQl1qbOx9l7k3IoEetY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756213111; c=relaxed/simple;
	bh=31Hr+WR5ZMcHsDJ/6J+O1dq4IGF8XgwpWsjHIHHv9jM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QDVQLk8u0Ufmjwv/vlL5/s0i3NxpUDdlqsa3DB0eMYGyhcElCwhpbDkLq+UCKD0nNfTZ/6bR8GKGhTv+bkkXiRWhNNLKee9ngjhLSHeOhnr+fzZKHKwAv4fWis/MRpIKcgvM8LhB/2F9R2AUgq9EYR1icYfNHQL6msWTKBW2mNQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d/7JlSUC; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d/7JlSUC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0266EC4CEF1;
	Tue, 26 Aug 2025 12:58:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756213111;
	bh=31Hr+WR5ZMcHsDJ/6J+O1dq4IGF8XgwpWsjHIHHv9jM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d/7JlSUCy14GAa+vf3TDAAGqgsfDuPDEeLCNccjIxPIfickNvgpianxJJLJFMwTco
	 0mThb/3ENdki1s2voz7wlvmYxg+iPYveTEGEjuupv34tgtxb5reAjfiiNcKa5+M0mX
	 fcADijZmS4GH4B7+04nJK1LeCsdKFTbdBQ9B75s8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Gal Pressman <gal@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 194/587] net: vlan: Make is_vlan_dev() a stub when VLAN is not configured
Date: Tue, 26 Aug 2025 13:05:43 +0200
Message-ID: <20250826110957.875247311@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110952.942403671@linuxfoundation.org>
References: <20250826110952.942403671@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index 430749a0f362..a6b46f0eab16 100644
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
@@ -199,6 +194,11 @@ struct vlan_dev_priv {
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
@@ -236,6 +236,11 @@ extern void vlan_vids_del_by_dev(struct net_device *dev,
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



