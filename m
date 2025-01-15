Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17D0E248BD1;
	Wed, 15 Jan 2025 10:54:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736938467; cv=none; b=sLSX2i+QlNepGhDcptU3Es4DAz8evONYAuA/aXkRxiwsTzjgLx7RceaRexcualKLIJyi4wAhj7Gt4Uj5K67GdsdqpvE+bhQparJGqgKJTi/jIk0ggUDWamD3PSBHhPGgNQZrmbRf63xQNF+UQQfjEOVKbNfOVGvzEKGaSilyNS4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736938467; c=relaxed/simple;
	bh=DyqArR/cDlss4y/VzZlkzDfta+Nq/MAdy4TUNUVRIgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uoR+Ot3i4Axmp4ULYFCeu5b5b1YEIo88SnRs13yKF/LJ0TUiMetAE+U+ahyQGK/YapAMB922H9579thhI3zlI37wv96HrGHmwNaw3IIs+RBnsi+ZG+AksvyZW//RSuq9BA+Qq0Y63LrLCTmdgMhPGJS7ohYhkpIOv1t/aFb8pqI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PRHNLGwM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PRHNLGwM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3B7C4CEDF;
	Wed, 15 Jan 2025 10:54:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736938467;
	bh=DyqArR/cDlss4y/VzZlkzDfta+Nq/MAdy4TUNUVRIgo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PRHNLGwM6dYpMtmQPSx+HoWEetGk6L5nBm+r1hnscf2BpTWoQ+5xBqT8R/sfCnKN7
	 LKvOm2W1eVzLtO+2HM/oi3+zyOkmuT//Q7zp44AryIZt5YqZ46sR04CdR7u5AHdpaj
	 KKvkyFJhQME3rkA1CRrUzbymoTd9lHNOh0SGKD+0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sridhar Samudrala <sridhar.samudrala@intel.com>,
	Joe Damato <jdamato@fastly.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 189/189] netdev: prevent accessing NAPI instances from another namespace
Date: Wed, 15 Jan 2025 11:38:05 +0100
Message-ID: <20250115103613.943251030@linuxfoundation.org>
X-Mailer: git-send-email 2.48.0
In-Reply-To: <20250115103606.357764746@linuxfoundation.org>
References: <20250115103606.357764746@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Kicinski <kuba@kernel.org>

commit d1cacd74776895f6435941f86a1130e58f6dd226 upstream.

The NAPI IDs were not fully exposed to user space prior to the netlink
API, so they were never namespaced. The netlink API must ensure that
at the very least NAPI instance belongs to the same netns as the owner
of the genl sock.

napi_by_id() can become static now, but it needs to move because of
dev_get_by_napi_id().

Cc: stable@vger.kernel.org
Fixes: 1287c1ae0fc2 ("netdev-genl: Support setting per-NAPI config values")
Fixes: 27f91aaf49b3 ("netdev-genl: Add netlink framework functions for napi")
Reviewed-by: Sridhar Samudrala <sridhar.samudrala@intel.com>
Reviewed-by: Joe Damato <jdamato@fastly.com>
Link: https://patch.msgid.link/20250106180137.1861472-1-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/core/dev.c         |   43 ++++++++++++++++++++++++++++++-------------
 net/core/dev.h         |    3 ++-
 net/core/netdev-genl.c |    4 +---
 3 files changed, 33 insertions(+), 17 deletions(-)

--- a/net/core/dev.c
+++ b/net/core/dev.c
@@ -753,6 +753,36 @@ int dev_fill_forward_path(const struct n
 }
 EXPORT_SYMBOL_GPL(dev_fill_forward_path);
 
+/* must be called under rcu_read_lock(), as we dont take a reference */
+static struct napi_struct *napi_by_id(unsigned int napi_id)
+{
+	unsigned int hash = napi_id % HASH_SIZE(napi_hash);
+	struct napi_struct *napi;
+
+	hlist_for_each_entry_rcu(napi, &napi_hash[hash], napi_hash_node)
+		if (napi->napi_id == napi_id)
+			return napi;
+
+	return NULL;
+}
+
+/* must be called under rcu_read_lock(), as we dont take a reference */
+struct napi_struct *netdev_napi_by_id(struct net *net, unsigned int napi_id)
+{
+	struct napi_struct *napi;
+
+	napi = napi_by_id(napi_id);
+	if (!napi)
+		return NULL;
+
+	if (WARN_ON_ONCE(!napi->dev))
+		return NULL;
+	if (!net_eq(net, dev_net(napi->dev)))
+		return NULL;
+
+	return napi;
+}
+
 /**
  *	__dev_get_by_name	- find a device by its name
  *	@net: the applicable net namespace
@@ -6291,19 +6321,6 @@ bool napi_complete_done(struct napi_stru
 }
 EXPORT_SYMBOL(napi_complete_done);
 
-/* must be called under rcu_read_lock(), as we dont take a reference */
-struct napi_struct *napi_by_id(unsigned int napi_id)
-{
-	unsigned int hash = napi_id % HASH_SIZE(napi_hash);
-	struct napi_struct *napi;
-
-	hlist_for_each_entry_rcu(napi, &napi_hash[hash], napi_hash_node)
-		if (napi->napi_id == napi_id)
-			return napi;
-
-	return NULL;
-}
-
 static void skb_defer_free_flush(struct softnet_data *sd)
 {
 	struct sk_buff *skb, *next;
--- a/net/core/dev.h
+++ b/net/core/dev.h
@@ -22,6 +22,8 @@ struct sd_flow_limit {
 
 extern int netdev_flow_limit_table_len;
 
+struct napi_struct *netdev_napi_by_id(struct net *net, unsigned int napi_id);
+
 #ifdef CONFIG_PROC_FS
 int __init dev_proc_init(void);
 #else
@@ -146,7 +148,6 @@ void xdp_do_check_flushed(struct napi_st
 static inline void xdp_do_check_flushed(struct napi_struct *napi) { }
 #endif
 
-struct napi_struct *napi_by_id(unsigned int napi_id);
 void kick_defer_list_purge(struct softnet_data *sd, unsigned int cpu);
 
 #define XMIT_RECURSION_LIMIT	8
--- a/net/core/netdev-genl.c
+++ b/net/core/netdev-genl.c
@@ -164,8 +164,6 @@ netdev_nl_napi_fill_one(struct sk_buff *
 	void *hdr;
 	pid_t pid;
 
-	if (WARN_ON_ONCE(!napi->dev))
-		return -EINVAL;
 	if (!(napi->dev->flags & IFF_UP))
 		return 0;
 
@@ -216,7 +214,7 @@ int netdev_nl_napi_get_doit(struct sk_bu
 	rtnl_lock();
 	rcu_read_lock();
 
-	napi = napi_by_id(napi_id);
+	napi = netdev_napi_by_id(genl_info_net(info), napi_id);
 	if (napi) {
 		err = netdev_nl_napi_fill_one(rsp, napi, info);
 	} else {


