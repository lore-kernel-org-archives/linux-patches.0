Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FB82435504;
	Mon, 31 Aug 2026 13:53:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788184429; cv=none; b=PszkWmZEbDk1jG72AWYYKUrC7GL9YRCAltwYYAXvSRLYrKa6IyRwx9KRQScg+JFNk834LfJ9mZWgCN07FPdWtUlMzmeqkOAKATidrqqumwTDA/71FcEYEUdNmuvpsuOldfjtOs4IjI9WuEUnxXG/EYOQ5+F5S4vVu+ldBfU0yHg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788184429; c=relaxed/simple;
	bh=tkVgBAgjtGPJFjFd9dTQ3d24n122omPCmnaNvceYLQo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZjIuwBLkRPaTyEsJrD32/9M4uW01+8AQu+pnMDev9c9A3DAVNKDFtjXn0PZoSLNSYACISauLCKPD9YslsShGo600YozKS8OpFuptbSGtfR9exsSPbGDVzRxsgj8zHe4R1aP/yyXuCJRIFqIqSnLSWfMh567YHCfhaz+dfoXqjDo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HzTtsqFX; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HzTtsqFX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DBF0B1F000E9;
	Mon, 31 Aug 2026 13:53:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788184428;
	bh=M5pObhBjxKY2PC1ClRTj0e5suBOl/To7wbqVb3dFZ7c=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HzTtsqFX/CcAIWRd9pJRVzib6DwlEeF6rXJ0Lcy0e7+5VP0/dwWVPxMlvNj1KwE9r
	 hkri6T/7p5YB7Cga2TEZDGSLVV1xqwbX1Rypt5pWQe2RkZxWodmaDFwVG3cug90wMX
	 oypSJxNWzJPS3Y90t29hk3nL1yEAeG0I5irIGCfs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.12 66/99] gtp: serialize PDP context updates
Date: Mon, 31 Aug 2026 15:34:35 +0200
Message-ID: <20260831133403.283665209@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.740409777@linuxfoundation.org>
References: <20260831133359.740409777@linuxfoundation.org>
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

From: Qing Ming <a0yami@mailbox.org>

commit 498386b6d402737db1e2eeed4c385acbf0ef9e34 upstream.

PDP contexts can be deleted through GTP_CMD_DELPDP or while the GTP
network device is being unregistered. The latter is serialized by RTNL,
but the generic-netlink delete path only holds RCU.

Running both paths concurrently can therefore make both paths delete the
same PDP context. The issue was found through static analysis and
reproduced on a KASAN-enabled kernel by a simple two-thread program
racing GTP_CMD_DELPDP against RTM_DELLINK:

  Oops: general protection fault, probably for non-canonical address
  KASAN: maybe wild-memory-access in range
         [0xdead000000000120-0xdead000000000127]
  RIP: gtp_genl_del_pdp+0x1c1/0x420 [gtp]
  RBP: dead000000000122

The second deletion dereferenced the poisoned hlist pprev pointer.

Serialize gtp_pdp_add(), gtp_genl_del_pdp(), and gtp_dellink() with a
shared mutex. Keep the mutex held until the final use of a PDP context in
the NEWPDP path, and keep the RCU read-side section around the complete
PDP context use in the DELPDP path.

Fixes: 459aa660eb1d ("gtp: add initial driver for datapath of GPRS Tunneling Protocol (GTP-U)")
Cc: stable@vger.kernel.org
Signed-off-by: Qing Ming <a0yami@mailbox.org>
Link: https://patch.msgid.link/20260818150000.7670-1-a0yami@mailbox.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   21 +++++++++++++++++----
 1 file changed, 17 insertions(+), 4 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include <linux/udp.h>
 #include <linux/rculist.h>
@@ -105,6 +106,7 @@ struct gtp_net {
 };
 
 static u32 gtp_h_initval;
+static DEFINE_MUTEX(gtp_pdp_lock);
 
 static struct genl_family gtp_genl_family;
 
@@ -148,7 +150,8 @@ static struct pdp_ctx *gtp0_pdp_find(str
 
 	head = &gtp->tid_hash[gtp0_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == family &&
 		    pdp->gtp_version == GTP_V0 &&
 		    pdp->u.v0.tid == tid)
@@ -165,7 +168,8 @@ static struct pdp_ctx *gtp1_pdp_find(str
 
 	head = &gtp->tid_hash[gtp1u_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == family &&
 		    pdp->gtp_version == GTP_V1 &&
 		    pdp->u.v1.i_tei == tid)
@@ -182,7 +186,8 @@ static struct pdp_ctx *ipv4_pdp_find(str
 
 	head = &gtp->addr_hash[ipv4_hashfn(ms_addr) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_addr,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == AF_INET &&
 		    pdp->ms.addr.s_addr == ms_addr)
 			return pdp;
@@ -217,7 +222,8 @@ static struct pdp_ctx *ipv6_pdp_find(str
 
 	head = &gtp->addr_hash[ipv6_hashfn(ms_addr) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_addr,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == AF_INET6 &&
 		    ipv6_pdp_addr_equal(&pdp->ms.addr6, ms_addr))
 			return pdp;
@@ -1550,9 +1556,11 @@ static void gtp_dellink(struct net_devic
 	struct pdp_ctx *pctx;
 	int i;
 
+	mutex_lock(&gtp_pdp_lock);
 	for (i = 0; i < gtp->hash_size; i++)
 		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
+	mutex_unlock(&gtp_pdp_lock);
 
 	list_del(&gtp->list);
 	unregister_netdevice_queue(dev, head);
@@ -2051,6 +2059,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		goto out_unlock;
 	}
 
+	mutex_lock(&gtp_pdp_lock);
 	pctx = gtp_pdp_add(gtp, sk, info);
 	if (IS_ERR(pctx)) {
 		err = PTR_ERR(pctx);
@@ -2058,6 +2067,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP, GFP_KERNEL);
 		err = 0;
 	}
+	mutex_unlock(&gtp_pdp_lock);
 
 out_unlock:
 	rtnl_unlock();
@@ -2135,6 +2145,8 @@ static int gtp_genl_del_pdp(struct sk_bu
 	if (!info->attrs[GTPA_VERSION])
 		return -EINVAL;
 
+	mutex_lock(&gtp_pdp_lock);
+
 	rcu_read_lock();
 
 	pctx = gtp_find_pdp(sock_net(skb->sk), info->attrs);
@@ -2155,6 +2167,7 @@ static int gtp_genl_del_pdp(struct sk_bu
 
 out_unlock:
 	rcu_read_unlock();
+	mutex_unlock(&gtp_pdp_lock);
 	return err;
 }
 


