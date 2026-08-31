Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 96DD3495527;
	Mon, 31 Aug 2026 13:38:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183525; cv=none; b=Otp064LyDICa5cv24I+bj1nybQ2mhCy+KlKjrVDb8VyUj6JKtB/QHmSL1DdYP81hXu+fG/nJIkNzFXIS6jNTuX6nO2MhYazAwABIQcWJ/5KdLo42mAsmdcr2ca+D++FtXrlr/KwRDcThLpazO2LxBknhUFDXZ+jhFPS5dMbzF7s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183525; c=relaxed/simple;
	bh=U5b3dj9NlpsswexkQU/QyB/L88p1nHgW4AQHyiee0kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Xh8BYQgwN21fuDplgmBcYde5bQpgLRB1S75Nj60608BV4p+TubkeYNbA1Aoc21lLuusZu1Z6+Wdoee1dHDmaTBuOzclcZtYMAOP+jeRhPN66hP+KS9qxxVNq8wg34TCOmGQ+FA8TEBAf/VeyDyPCYoUDycxlekFozYQJkCpiTrU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jQGU9irN; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jQGU9irN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E28BB1F000E9;
	Mon, 31 Aug 2026 13:38:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183523;
	bh=46yG9NTInalE0CuzhSPfITou56dyfT/XFbEsGg73RZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jQGU9irN+IUlgQw/6b4Lg4pYyEWiksbjVnRN5YABgDeIBS72PDCzSXQEcn28NuayY
	 Kl8rHddlvM307VuTgcRfXbDKQjtJ0Jjy9sg3nXPTIsZNLOqJC9gZmAd84wUmIWWXZ8
	 ns44AAJKf3fJXj0YQmb3181ZHbqTFRIC42nztwrE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 7.2 27/71] gtp: serialize PDP context updates
Date: Mon, 31 Aug 2026 15:33:52 +0200
Message-ID: <20260831133400.475260579@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.055927882@linuxfoundation.org>
References: <20260831133359.055927882@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -108,6 +109,7 @@ struct gtp_net {
 };
 
 static u32 gtp_h_initval;
+static DEFINE_MUTEX(gtp_pdp_lock);
 
 static struct genl_family gtp_genl_family;
 
@@ -151,7 +153,8 @@ static struct pdp_ctx *gtp0_pdp_find(str
 
 	head = &gtp->tid_hash[gtp0_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == family &&
 		    pdp->gtp_version == GTP_V0 &&
 		    pdp->u.v0.tid == tid)
@@ -168,7 +171,8 @@ static struct pdp_ctx *gtp1_pdp_find(str
 
 	head = &gtp->tid_hash[gtp1u_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == family &&
 		    pdp->gtp_version == GTP_V1 &&
 		    pdp->u.v1.i_tei == tid)
@@ -185,7 +189,8 @@ static struct pdp_ctx *ipv4_pdp_find(str
 
 	head = &gtp->addr_hash[ipv4_hashfn(ms_addr) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_addr,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == AF_INET &&
 		    pdp->ms.addr.s_addr == ms_addr)
 			return pdp;
@@ -220,7 +225,8 @@ static struct pdp_ctx *ipv6_pdp_find(str
 
 	head = &gtp->addr_hash[ipv6_hashfn(ms_addr) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_addr,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == AF_INET6 &&
 		    ipv6_pdp_addr_equal(&pdp->ms.addr6, ms_addr))
 			return pdp;
@@ -1555,9 +1561,11 @@ static void gtp_dellink(struct net_devic
 	struct pdp_ctx *pctx;
 	int i;
 
+	mutex_lock(&gtp_pdp_lock);
 	for (i = 0; i < gtp->hash_size; i++)
 		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
+	mutex_unlock(&gtp_pdp_lock);
 
 	list_del(&gtp->list);
 	unregister_netdevice_queue(dev, head);
@@ -2053,6 +2061,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		goto out_unlock;
 	}
 
+	mutex_lock(&gtp_pdp_lock);
 	pctx = gtp_pdp_add(gtp, sk, info);
 	if (IS_ERR(pctx)) {
 		err = PTR_ERR(pctx);
@@ -2060,6 +2069,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP, GFP_KERNEL);
 		err = 0;
 	}
+	mutex_unlock(&gtp_pdp_lock);
 
 out_unlock:
 	rtnl_unlock();
@@ -2134,6 +2144,8 @@ static int gtp_genl_del_pdp(struct sk_bu
 	if (!info->attrs[GTPA_VERSION])
 		return -EINVAL;
 
+	mutex_lock(&gtp_pdp_lock);
+
 	rcu_read_lock();
 
 	pctx = gtp_find_pdp(sock_net(skb->sk), info->attrs);
@@ -2154,6 +2166,7 @@ static int gtp_genl_del_pdp(struct sk_bu
 
 out_unlock:
 	rcu_read_unlock();
+	mutex_unlock(&gtp_pdp_lock);
 	return err;
 }
 


