Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 33C55331A44;
	Tue, 16 Jun 2026 18:46:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781635606; cv=none; b=t43K7JDzizEx9EszxyMdUYrnnt/VNvu8VRYCVCeFt/Fk5+QhfY98hoe0UfoxqGAEJNkwd0r9QLLRymkpKCHJGIIx0kSYK/Tar6WiRo5NpZq59IFH9qWS1bosb53Bm5geQ/JDhMIrrv8i+8x2zhX4GBXceykKlNIXPUWe8SlDpJA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781635606; c=relaxed/simple;
	bh=H77T1yCOlhOthhj1OYgRh4t8TSPJ/Vos0ANGpFlcYIA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=orNZvYe6QsPLY5RKJpmuNul8+mdy3DaYursWO2lWyMs742qPwiqeYavBNl/KT5vbiNCIYxM2PWljgWP3vhew8iBsWMK30FMaG/LtiKHveF5lxUCnOObMq+0rNwpNMh024kDiyR+YCAkVCtG9wq5g6nWUmtN2/OKg629rdffK7ic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HRL2NhAC; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HRL2NhAC"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9B0D1F000E9;
	Tue, 16 Jun 2026 18:46:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781635604;
	bh=V5OfZ+h8uDei1ljrFmpXGLvTgRIZ+UDJkuIgeOzvCOw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=HRL2NhACwL1SxXIxtftTgsPeYexF2qIw0iCs3K4u65p1FRY3gWRmyupKM+pPjxMTu
	 6UH3gyn4abJh0Thf1SsAEX9SQBbG+jtDc9s4BQrGorIS6Y2i6UbrPUNZXtR3lGjc/8
	 8qPVJiD52QL+9x0Z25/ad+vhvxrAxKML/XM8/I6I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maoyi Xie <maoyi.xie@ntu.edu.sg>,
	Steffen Klassert <steffen.klassert@secunet.com>
Subject: [PATCH 5.10 079/342] xfrm: route MIGRATE notifications to callers netns
Date: Tue, 16 Jun 2026 20:26:15 +0530
Message-ID: <20260616145051.922882715@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145048.348037099@linuxfoundation.org>
References: <20260616145048.348037099@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maoyi Xie <maoyixie.tju@gmail.com>

commit 7e2a4f7ca0952820731ef7bdadfc9a9e9d3571b4 upstream.

xfrm_send_migrate() in net/xfrm/xfrm_user.c and pfkey_send_migrate()
in net/key/af_key.c both hardcode &init_net for the multicast that
announces a successful XFRM_MSG_MIGRATE / SADB_X_MIGRATE.

XFRM_MSG_MIGRATE arrives on a per-netns NETLINK_XFRM socket, and the
rest of the xfrm/af_key netlink path was made netns-aware in 2008.
The other 14 multicast paths in xfrm_user.c route their event using
xs_net(x), xp_net(xp) or sock_net(skb->sk); only the migrate path
was missed.

Two consequences of the init_net hardcoding:

  1. The notification (selector, old/new endpoint addresses, and the
     km_address) is delivered to listeners on init_net's
     XFRMNLGRP_MIGRATE / pfkey BROADCAST_ALL groups rather than on
     the issuing netns. An IKE daemon running in init_net therefore
     receives migration notifications originating from any other
     netns on the host.

  2. An IKE daemon running inside a non-init netns and subscribed
     to its own XFRMNLGRP_MIGRATE / pfkey groups never receives the
     notification of its own migration. IKEv2 MOBIKE / address-update
     handling inside a netns is silently broken.

Thread struct net through km_migrate() and the xfrm_mgr.migrate
function pointer, drop the &init_net override in xfrm_send_migrate()
and pfkey_send_migrate(), and pass the caller's net (already in
scope in xfrm_migrate() via sock_net(skb->sk)) all the way down.
struct xfrm_mgr is in-tree only and not exported as a stable API,
so the function-pointer signature change is internal.

pfkey_broadcast() is already netns-aware via net_generic(net,
pfkey_net_id) since the pernet conversion. The five other
pfkey_broadcast() callers in af_key.c already pass xs_net(x),
sock_net(sk) or a per-netns net, so this only removes the
&init_net outlier.

Fixes: 5c79de6e79cd ("[XFRM]: User interface for handling XFRM_MSG_MIGRATE")
Cc: stable@vger.kernel.org # v5.15+
Signed-off-by: Maoyi Xie <maoyi.xie@ntu.edu.sg>
Signed-off-by: Steffen Klassert <steffen.klassert@secunet.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/net/xfrm.h     |    3 ++-
 net/key/af_key.c       |    6 +++---
 net/xfrm/xfrm_policy.c |    2 +-
 net/xfrm/xfrm_state.c  |    4 ++--
 net/xfrm/xfrm_user.c   |    5 ++---
 5 files changed, 10 insertions(+), 10 deletions(-)

--- a/include/net/xfrm.h
+++ b/include/net/xfrm.h
@@ -593,6 +593,7 @@ struct xfrm_mgr {
 					   const struct xfrm_migrate *m,
 					   int num_bundles,
 					   const struct xfrm_kmaddress *k,
+					   struct net *net,
 					   const struct xfrm_encap_tmpl *encap);
 	bool			(*is_alive)(const struct km_event *c);
 };
@@ -1697,7 +1698,7 @@ int xfrm_sk_policy_insert(struct sock *s
 #ifdef CONFIG_XFRM_MIGRATE
 int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	       const struct xfrm_migrate *m, int num_bundles,
-	       const struct xfrm_kmaddress *k,
+	       const struct xfrm_kmaddress *k, struct net *net,
 	       const struct xfrm_encap_tmpl *encap);
 struct xfrm_state *xfrm_migrate_state_find(struct xfrm_migrate *m, struct net *net,
 						u32 if_id);
--- a/net/key/af_key.c
+++ b/net/key/af_key.c
@@ -3552,7 +3552,7 @@ static int set_ipsecrequest(struct sk_bu
 #ifdef CONFIG_NET_KEY_MIGRATE
 static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 			      const struct xfrm_migrate *m, int num_bundles,
-			      const struct xfrm_kmaddress *k,
+			      const struct xfrm_kmaddress *k, struct net *net,
 			      const struct xfrm_encap_tmpl *encap)
 {
 	int i;
@@ -3657,7 +3657,7 @@ static int pfkey_send_migrate(const stru
 	}
 
 	/* broadcast migrate message to sockets */
-	pfkey_broadcast(skb, GFP_ATOMIC, BROADCAST_ALL, NULL, &init_net);
+	pfkey_broadcast(skb, GFP_ATOMIC, BROADCAST_ALL, NULL, net);
 
 	return 0;
 
@@ -3668,7 +3668,7 @@ err:
 #else
 static int pfkey_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 			      const struct xfrm_migrate *m, int num_bundles,
-			      const struct xfrm_kmaddress *k,
+			      const struct xfrm_kmaddress *k, struct net *net,
 			      const struct xfrm_encap_tmpl *encap)
 {
 	return -ENOPROTOOPT;
--- a/net/xfrm/xfrm_policy.c
+++ b/net/xfrm/xfrm_policy.c
@@ -4532,7 +4532,7 @@ int xfrm_migrate(const struct xfrm_selec
 	}
 
 	/* Stage 5 - announce */
-	km_migrate(sel, dir, type, m, num_migrate, k, encap);
+	km_migrate(sel, dir, type, m, num_migrate, k, net, encap);
 
 	xfrm_pol_put(pol);
 
--- a/net/xfrm/xfrm_state.c
+++ b/net/xfrm/xfrm_state.c
@@ -2270,7 +2270,7 @@ EXPORT_SYMBOL(km_policy_expired);
 #ifdef CONFIG_XFRM_MIGRATE
 int km_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 	       const struct xfrm_migrate *m, int num_migrate,
-	       const struct xfrm_kmaddress *k,
+	       const struct xfrm_kmaddress *k, struct net *net,
 	       const struct xfrm_encap_tmpl *encap)
 {
 	int err = -EINVAL;
@@ -2281,7 +2281,7 @@ int km_migrate(const struct xfrm_selecto
 	list_for_each_entry_rcu(km, &xfrm_km_list, list) {
 		if (km->migrate) {
 			ret = km->migrate(sel, dir, type, m, num_migrate, k,
-					  encap);
+					  net, encap);
 			if (!ret)
 				err = ret;
 		}
--- a/net/xfrm/xfrm_user.c
+++ b/net/xfrm/xfrm_user.c
@@ -2675,10 +2675,9 @@ out_cancel:
 
 static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 			     const struct xfrm_migrate *m, int num_migrate,
-			     const struct xfrm_kmaddress *k,
+			     const struct xfrm_kmaddress *k, struct net *net,
 			     const struct xfrm_encap_tmpl *encap)
 {
-	struct net *net = &init_net;
 	struct sk_buff *skb;
 	int err;
 
@@ -2696,7 +2695,7 @@ static int xfrm_send_migrate(const struc
 #else
 static int xfrm_send_migrate(const struct xfrm_selector *sel, u8 dir, u8 type,
 			     const struct xfrm_migrate *m, int num_migrate,
-			     const struct xfrm_kmaddress *k,
+			     const struct xfrm_kmaddress *k, struct net *net,
 			     const struct xfrm_encap_tmpl *encap)
 {
 	return -ENOPROTOOPT;


