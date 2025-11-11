Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1D162472A6;
	Tue, 11 Nov 2025 01:34:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762824872; cv=none; b=MqcXCDIKE1TuYv2QKURb85ZijjR6PYAKtdJNMqg8UhhXJxDZWQpaP7ze0K3WLOYd5seFEAa7sNu+FDbeBQ+UNYGbfQi7cL8uQSt7XYg0nF34douuMcfjegVCbaJydu+X3VRL7panr6nCBpfNg7Ce4n8/NFHpbVkXALVXlNeZjPY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762824872; c=relaxed/simple;
	bh=4G9RXbZ39Ea5JmxKZ4FQVg6CHuvICWU+1CuTb2rF0is=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Z3P9Zmo/d6WK6k6QFVvPtehd3fTdPJcGdotraUB18IFSOW9VEsXMX+rNTQDwsGIvbFO/ZSc21ZfNVZpJ5Kf8+Fn1jkoW97R52irFYjdC8bld+13dknP2riL0At8dEZgC6Y0NInjvqU2fA7RKQP39+9/yvnZ4lOhzSopHDuD7XvY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lDMOkq2M; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lDMOkq2M"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FE35C4CEF5;
	Tue, 11 Nov 2025 01:34:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762824871;
	bh=4G9RXbZ39Ea5JmxKZ4FQVg6CHuvICWU+1CuTb2rF0is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lDMOkq2MkbbzOl0Rx1UwnEyUH97FCttdpO6Y7NSACuNGORcCdzAKAI0UYgant7Qc2
	 xu0N93oPFhSujbHXs/BSTGj/bc+VLC++gK7YWHSAWH8jpcrB91SCNDoU0BkWuwJnQQ
	 CtuKY5m/Xd9AtGNCHeY43KVKmMIRzV1gc6UCxGeg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ido Schimmel <idosch@nvidia.com>,
	Nikolay Aleksandrov <razor@blackwall.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 541/565] net: bridge: fix MST static key usage
Date: Tue, 11 Nov 2025 09:46:37 +0900
Message-ID: <20251111004539.154734787@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004526.816196597@linuxfoundation.org>
References: <20251111004526.816196597@linuxfoundation.org>
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
index 2450690f98cfa..6ffc81eedf074 100644
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
index 40dcffc2132ed..741b0b8c4babb 100644
--- a/net/bridge/br_private.h
+++ b/net/bridge/br_private.h
@@ -1923,6 +1923,7 @@ int br_mst_fill_info(struct sk_buff *skb,
 		     const struct net_bridge_vlan_group *vg);
 int br_mst_process(struct net_bridge_port *p, const struct nlattr *mst_attr,
 		   struct netlink_ext_ack *extack);
+void br_mst_uninit(struct net_bridge *br);
 #else
 static inline bool br_mst_is_enabled(const struct net_bridge_port *p)
 {
@@ -1958,6 +1959,10 @@ static inline int br_mst_process(struct net_bridge_port *p,
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



