Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793211553;
	b=Sg9Eo2ATMLhItgfFHL2QQdvX6wRbGZabeS3vIGx1e9sFKL25kEiBqdHW3rxfHugwEOFr
	 l6NL6e5fwq0KIb8pZFaCdPLvKgNA3uA6PeFxROeFBsAsFF1cqcpz9h6XBYp+IcaVu1Qox
	 ZOJ1ofASkOD5ppZqru+NMIj2fzUGBmpOoIkk2W51KTOE7tWRR12vmktgR67g21sTzasiH
	 Y3nL6jld6m7dAZoAmVVzPHDVVdcfhdDi7UpPsOFbXPMrrl0WPGFu3X/y9AZfXzf/jO8k8
	 IW4uvPsCIdPL5b75XfLVQimwSaSizfwQkOQUuxQmOtFVe3gBPkBq+nxYRTImYnBek1g==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793211553;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ig9Xy0PfJtSxqUaW5FqndI7B/QewKPxQ5wTctk6r4X8=;
	b=PzwUyWiEUsj/aTSrMh/9YT1JZL67EHvQ67ju4j4cgBJ70CpHOGjfENwebuwUi8zPtjI/
	 xE0srrbC+tE3aDuoI+j8XQDs8QuseWEdhWZVuRZVc/G9+jiUny7miluLT/uVby7iO9Nqj
	 KXEDy2SBTTcIJMvEv0hhB3LgA++CPowTCpPKXe5XcWvV/kuCoQsczJYqRRC7ezAILn5Te
	 YbTDkRBd0h5IuBb+mAfYjFPfIdDnAz3pppjMwj/RnBV6wkrZeW9uhG3gdLcbHwswQE7+P
	 tEs2cOEeJAKSjF32by/I0Lko2FPu1EsA6iwj5V8he4muHJ3RCbrmV8NuteXyrJ6AHHQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6k4VpGY;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 17846606A31A;
	Wed, 28 Oct 2026 18:19:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=K6k4VpGY
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 654911F01825;
	Wed, 28 Oct 2026 18:19:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793211552;
	bh=ig9Xy0PfJtSxqUaW5FqndI7B/QewKPxQ5wTctk6r4X8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=K6k4VpGYtb0/Dzpg4rrPCEo2bvL30gyovi8ZiQ3DaWAKjnzwBOKJe0+HkT+ZJ4S20
	 Wr+5iqeRNbfVep0qmpKND4/kqaQkh70tnxux5bxRg2YkdBYxmms8w0taWk2/hBMHFi
	 5md8Wc+NZtDRURjHT9VsrayrCKYouPvZ/fDpSEU8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vega <vega@nebusec.ai>,
	Zixuan Chai <petalzu987@gmail.com>,
	Ren Wei <weir@nebusec.ai>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 373/571] net: bridge: avoid recursive multicast port cleanup
Date: Wed, 28 Oct 2026 17:58:40 +0100
Message-ID: <20261028170016.863522557@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170008.009143722@linuxfoundation.org>
References: <20261028170008.009143722@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zixuan Chai <petalzu987@gmail.com>

commit 5158353121bae4f552cb677ce8c5c3ef52f93a0d upstream.

br_multicast_sg_del_exclude_ports() removes automatically added STAR_EXCL
port groups by calling br_multicast_del_pg(). For S,G entries, that
deletion calls back into br_multicast_sg_del_exclude_ports(), so a large
number of STAR_EXCL ports consumes one kernel stack frame per port and can
hit the stack guard page.

Keep the complete port-group deletion path for cleanup, but suppress the
S,G exclude-port cleanup while that helper is already walking the same
entry. Normal deletion callers retain the existing behavior.

Fixes: 8266a0491e92 ("net: bridge: mcast: handle port group filter modes")
Cc: stable@vger.kernel.org
Reported-by: Vega <vega@nebusec.ai>
Assisted-by: LLM
Signed-off-by: Zixuan Chai <petalzu987@gmail.com>
Signed-off-by: Ren Wei <weir@nebusec.ai>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/bridge/br_multicast.c |   23 ++++++++++++++++++-----
 1 file changed, 18 insertions(+), 5 deletions(-)

--- a/net/bridge/br_multicast.c
+++ b/net/bridge/br_multicast.c
@@ -80,6 +80,10 @@ __br_multicast_add_group(struct net_brid
 			 bool blocked);
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg);
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports);
 static void __br_multicast_stop(struct net_bridge_mcast *brmctx);
 
 static int br_mc_disabled_update(struct net_device *dev, bool value,
@@ -436,7 +440,7 @@ static void br_multicast_sg_del_exclude_
 	for (pp = &sgmp->ports;
 	     (p = mlock_dereference(*pp, sgmp->br)) != NULL;) {
 		if (!(p->flags & MDB_PG_FLAGS_PERMANENT))
-			br_multicast_del_pg(sgmp, p, pp);
+			__br_multicast_del_pg(sgmp, p, pp, false);
 		else
 			pp = &p->next;
 	}
@@ -675,9 +679,10 @@ static void br_multicast_destroy_port_gr
 	kfree_rcu(pg, rcu);
 }
 
-void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
-			 struct net_bridge_port_group *pg,
-			 struct net_bridge_port_group __rcu **pp)
+static void __br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+				  struct net_bridge_port_group *pg,
+				  struct net_bridge_port_group __rcu **pp,
+				  bool sg_del_exclude_ports)
 {
 	struct net_bridge *br = pg->key.port->br;
 	struct net_bridge_group_src *ent;
@@ -692,7 +697,8 @@ void br_multicast_del_pg(struct net_brid
 	if (!br_multicast_is_star_g(&mp->addr)) {
 		rhashtable_remove_fast(&br->sg_port_tbl, &pg->rhnode,
 				       br_sg_port_rht_params);
-		br_multicast_sg_del_exclude_ports(mp);
+		if (sg_del_exclude_ports)
+			br_multicast_sg_del_exclude_ports(mp);
 	} else {
 		br_multicast_star_g_handle_mode(pg, MCAST_INCLUDE);
 	}
@@ -703,6 +709,13 @@ void br_multicast_del_pg(struct net_brid
 		mod_timer(&mp->timer, jiffies);
 }
 
+void br_multicast_del_pg(struct net_bridge_mdb_entry *mp,
+			 struct net_bridge_port_group *pg,
+			 struct net_bridge_port_group __rcu **pp)
+{
+	__br_multicast_del_pg(mp, pg, pp, true);
+}
+
 static void br_multicast_find_del_pg(struct net_bridge *br,
 				     struct net_bridge_port_group *pg)
 {


