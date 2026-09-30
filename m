Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D4A0E40F74B;
	Wed, 30 Sep 2026 19:39:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790797198; cv=none; b=BJBUrLFXtJFc8iev/qIuaIepjTSIoT3/HiHbqygwwsJvNWHbviFh3rH8CjFrNYexjX89VdFT7cq/0yDA0BtaGgGApkCLkqk43RA2PATtDuTYOcilLU1St6caInsj/0B5yiEDVrYueZV5P4+Jb4b8SXY9Yhevp7ngwz9foVZwG28=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790797198; c=relaxed/simple;
	bh=YK7jBEAy+lMaBUYjYjFZgIJHIMQoSQWsI+oPFaopikc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pvutCXWnAL5v+kzF2wS0c03k/JYiriNVhqJHGXcI80KrUebeGnkS6fCd/OtNmtwWLkxmeVT+s/NY87SsU/dt1MNASYMl/ySmlZU+xNNuciOxiQUI6IvxG6/u+2/EA0erGJ2X4+derR2NdLeocUge6nuVpqZOwQYP5cmSdFDr3xc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lRtohTUk; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lRtohTUk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E1E581F0089C;
	Wed, 30 Sep 2026 19:39:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790797196;
	bh=Z86IVJ0xcYGHjHFPDS+WfSyHbPqFXdAENBSkeKGni94=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lRtohTUk2SycpmDz9NzifBTrZaMJ6c53GLW1C322CEMbX+b7v8oK+TEU/HXcNnJjU
	 PYaFJLcmA5P4/pT5Du8NlzAWpLKtmPNDihda7kST2OcL3eVSOJYm73Jv41emE0d3nd
	 I8+DkC1a43mV/XaruRZ3Q1IHYt+TZW+oUsWg4mnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Qing Ming <a0yami@mailbox.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1180/1193] gtp: serialize PDP context updates
Date: Wed, 30 Sep 2026 17:31:04 +0200
Message-ID: <20260930152500.456021599@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152434.301151190@linuxfoundation.org>
References: <20260930152434.301151190@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Qing Ming <a0yami@mailbox.org>

[ Upstream commit 498386b6d402737db1e2eeed4c385acbf0ef9e34 ]

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
[ adapted the locking changes to the older IPv4-only PDP context API and omitted the absent IPv6 lookup hunk. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/gtp.c |   18 +++++++++++++++---
 1 file changed, 15 insertions(+), 3 deletions(-)

--- a/drivers/net/gtp.c
+++ b/drivers/net/gtp.c
@@ -12,6 +12,7 @@
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
 
 #include <linux/module.h>
+#include <linux/mutex.h>
 #include <linux/skbuff.h>
 #include <linux/udp.h>
 #include <linux/rculist.h>
@@ -92,6 +93,7 @@ struct gtp_net {
 };
 
 static u32 gtp_h_initval;
+static DEFINE_MUTEX(gtp_pdp_lock);
 
 static struct genl_family gtp_genl_family;
 
@@ -129,7 +131,8 @@ static struct pdp_ctx *gtp0_pdp_find(str
 
 	head = &gtp->tid_hash[gtp0_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->gtp_version == GTP_V0 &&
 		    pdp->u.v0.tid == tid)
 			return pdp;
@@ -145,7 +148,8 @@ static struct pdp_ctx *gtp1_pdp_find(str
 
 	head = &gtp->tid_hash[gtp1u_hashfn(tid) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_tid) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_tid,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->gtp_version == GTP_V1 &&
 		    pdp->u.v1.i_tei == tid)
 			return pdp;
@@ -161,7 +165,8 @@ static struct pdp_ctx *ipv4_pdp_find(str
 
 	head = &gtp->addr_hash[ipv4_hashfn(ms_addr) % gtp->hash_size];
 
-	hlist_for_each_entry_rcu(pdp, head, hlist_addr) {
+	hlist_for_each_entry_rcu(pdp, head, hlist_addr,
+				 lockdep_is_held(&gtp_pdp_lock)) {
 		if (pdp->af == AF_INET &&
 		    pdp->ms_addr_ip4.s_addr == ms_addr)
 			return pdp;
@@ -1121,9 +1126,11 @@ static void gtp_dellink(struct net_devic
 	struct pdp_ctx *pctx;
 	int i;
 
+	mutex_lock(&gtp_pdp_lock);
 	for (i = 0; i < gtp->hash_size; i++)
 		hlist_for_each_entry_safe(pctx, next, &gtp->tid_hash[i], hlist_tid)
 			pdp_context_delete(pctx);
+	mutex_unlock(&gtp_pdp_lock);
 
 	list_del(&gtp->list);
 	unregister_netdevice_queue(dev, head);
@@ -1508,6 +1515,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		goto out_unlock;
 	}
 
+	mutex_lock(&gtp_pdp_lock);
 	pctx = gtp_pdp_add(gtp, sk, info);
 	if (IS_ERR(pctx)) {
 		err = PTR_ERR(pctx);
@@ -1515,6 +1523,7 @@ static int gtp_genl_new_pdp(struct sk_bu
 		gtp_tunnel_notify(pctx, GTP_CMD_NEWPDP, GFP_KERNEL);
 		err = 0;
 	}
+	mutex_unlock(&gtp_pdp_lock);
 
 out_unlock:
 	rtnl_unlock();
@@ -1569,6 +1578,8 @@ static int gtp_genl_del_pdp(struct sk_bu
 	if (!info->attrs[GTPA_VERSION])
 		return -EINVAL;
 
+	mutex_lock(&gtp_pdp_lock);
+
 	rcu_read_lock();
 
 	pctx = gtp_find_pdp(sock_net(skb->sk), info->attrs);
@@ -1589,6 +1600,7 @@ static int gtp_genl_del_pdp(struct sk_bu
 
 out_unlock:
 	rcu_read_unlock();
+	mutex_unlock(&gtp_pdp_lock);
 	return err;
 }
 


