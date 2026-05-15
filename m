Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 012663F44DB;
	Fri, 15 May 2026 16:23:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862184; cv=none; b=TfZ2pY0yfrHWzOTZwdF4PZ5BeDLnRtqbnEDlj+KBFNUDday3fVZzM35ioiwkddOZs91DJ9mZfMJDREyFfvP2M9W+t9citVWlPg/nPtbHgDx4toOfIEuTxNOatNfHhv4FHNH9CXV7PNm+rdeVdJCOclIAHBKHBzHonIHhXfBMSzY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862184; c=relaxed/simple;
	bh=cFBw2ApuWtWB9BTXYJPWAB7g9jvSw5ffFTng/BNteag=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sb19Ei36nES1bfPyT3ur0RO15Z7IwylAsCTSLCMiw1//ku+whDURCzyrl2OoCMNQiOFME6fJplsNRCyRn+Ic7P3Yiu+aokN5u4G5eFjrLpgPTvWDyBKkri7Zsz3dCOncKze4p17r1Acvc/2GeV6U+eKhqWQXFtm64VfQrkg5jH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vYx3SH+0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vYx3SH+0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26F45C2BCB0;
	Fri, 15 May 2026 16:23:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862183;
	bh=cFBw2ApuWtWB9BTXYJPWAB7g9jvSw5ffFTng/BNteag=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=vYx3SH+0rTknhz8PKLgDEfUI9lNGj02BUJ7k9cjgCbxp7jmY5XcQcd0Q01dvHv14l
	 C5n9yfNZ0pWHpFSDdFcxlps9l8kIdXHnlNpnMloDQTK2I9xeBfl537oQHTrhXvzqIA
	 5GJmS8lIj742ixuU1IfpAlRJD5sMjVJ1cVE/LYso=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	Yuan Tan <yuantan098@gmail.com>,
	Yifan Wu <yifanwucs@gmail.com>,
	Juefei Pu <tomapufckgml@gmail.com>,
	Xin Liu <bird@lzu.edu.cn>,
	Jiexun Wang <wangjiexun2025@gmail.com>,
	Ren Wei <n05ec@lzu.edu.cn>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.18 139/188] batman-adv: stop caching unowned originator pointers in BAT IV
Date: Fri, 15 May 2026 17:49:16 +0200
Message-ID: <20260515154700.342145865@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jiexun Wang <wangjiexun2025@gmail.com>

commit f03e8583532941b07761c5429de7d50766fa3110 upstream.

BAT IV keeps the last-hop neighbor address in each neigh_node, but some
paths also cache an originator pointer derived from a temporary lookup.
That pointer is not owned by the neigh_node and may no longer refer to a
live originator entry after purge handling runs.

Stop storing the auxiliary originator pointer in the BAT IV neighbor
state. When BAT IV needs the neighbor originator data, resolve it from
the stored neighbor address and drop the reference again after use.

Fixes: c6c8fea29769 ("net: Add batman-adv meshing protocol")
Cc: stable@kernel.org
Reported-by: Yuan Tan <yuantan098@gmail.com>
Reported-by: Yifan Wu <yifanwucs@gmail.com>
Reported-by: Juefei Pu <tomapufckgml@gmail.com>
Reported-by: Xin Liu <bird@lzu.edu.cn>
Signed-off-by: Jiexun Wang <wangjiexun2025@gmail.com>
Signed-off-by: Ren Wei <n05ec@lzu.edu.cn>
[sven: avoid bonding logic for outgoing OGM]
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/bat_iv_ogm.c |   83 +++++++++++++++++++++++++++++++-------------
 1 file changed, 59 insertions(+), 24 deletions(-)

--- a/net/batman-adv/bat_iv_ogm.c
+++ b/net/batman-adv/bat_iv_ogm.c
@@ -173,19 +173,12 @@ free_orig_node_hash:
 static struct batadv_neigh_node *
 batadv_iv_ogm_neigh_new(struct batadv_hard_iface *hard_iface,
 			const u8 *neigh_addr,
-			struct batadv_orig_node *orig_node,
-			struct batadv_orig_node *orig_neigh)
+			struct batadv_orig_node *orig_node)
 {
 	struct batadv_neigh_node *neigh_node;
 
 	neigh_node = batadv_neigh_node_get_or_create(orig_node,
 						     hard_iface, neigh_addr);
-	if (!neigh_node)
-		goto out;
-
-	neigh_node->orig_node = orig_neigh;
-
-out:
 	return neigh_node;
 }
 
@@ -907,6 +900,31 @@ static u8 batadv_iv_orig_ifinfo_sum(stru
 }
 
 /**
+ * batadv_iv_ogm_neigh_ifinfo_sum() - Get bcast_own sum for a last-hop neighbor
+ * @bat_priv: the bat priv with all the mesh interface information
+ * @neigh_node: last-hop neighbor of an originator
+ *
+ * Return: Number of replied (rebroadcasted) OGMs for the originator currently
+ * announced by the neighbor. Returns 0 if the neighbor's originator entry is
+ * not available anymore.
+ */
+static u8 batadv_iv_ogm_neigh_ifinfo_sum(struct batadv_priv *bat_priv,
+					 const struct batadv_neigh_node *neigh_node)
+{
+	struct batadv_orig_node *orig_neigh;
+	u8 sum;
+
+	orig_neigh = batadv_orig_hash_find(bat_priv, neigh_node->addr);
+	if (!orig_neigh)
+		return 0;
+
+	sum = batadv_iv_orig_ifinfo_sum(orig_neigh, neigh_node->if_incoming);
+	batadv_orig_node_put(orig_neigh);
+
+	return sum;
+}
+
+/**
  * batadv_iv_ogm_orig_update() - use OGM to update corresponding data in an
  *  originator
  * @bat_priv: the bat priv with all the mesh interface information
@@ -975,17 +993,9 @@ batadv_iv_ogm_orig_update(struct batadv_
 	}
 
 	if (!neigh_node) {
-		struct batadv_orig_node *orig_tmp;
-
-		orig_tmp = batadv_iv_ogm_orig_get(bat_priv, ethhdr->h_source);
-		if (!orig_tmp)
-			goto unlock;
-
 		neigh_node = batadv_iv_ogm_neigh_new(if_incoming,
 						     ethhdr->h_source,
-						     orig_node, orig_tmp);
-
-		batadv_orig_node_put(orig_tmp);
+						     orig_node);
 		if (!neigh_node)
 			goto unlock;
 	} else {
@@ -1037,10 +1047,9 @@ batadv_iv_ogm_orig_update(struct batadv_
 	 */
 	if (router_ifinfo &&
 	    neigh_ifinfo->bat_iv.tq_avg == router_ifinfo->bat_iv.tq_avg) {
-		sum_orig = batadv_iv_orig_ifinfo_sum(router->orig_node,
-						     router->if_incoming);
-		sum_neigh = batadv_iv_orig_ifinfo_sum(neigh_node->orig_node,
-						      neigh_node->if_incoming);
+		sum_orig = batadv_iv_ogm_neigh_ifinfo_sum(bat_priv, router);
+		sum_neigh = batadv_iv_ogm_neigh_ifinfo_sum(bat_priv,
+							   neigh_node);
 		if (sum_orig >= sum_neigh)
 			goto out;
 	}
@@ -1106,7 +1115,6 @@ static bool batadv_iv_ogm_calc_tq(struct
 	if (!neigh_node)
 		neigh_node = batadv_iv_ogm_neigh_new(if_incoming,
 						     orig_neigh_node->orig,
-						     orig_neigh_node,
 						     orig_neigh_node);
 
 	if (!neigh_node)
@@ -1303,6 +1311,32 @@ out:
 }
 
 /**
+ * batadv_orig_to_direct_router() - get direct next hop neighbor to an orig address
+ * @bat_priv: the bat priv with all the mesh interface information
+ * @orig_addr: the originator MAC address to search the best next hop router for
+ * @if_outgoing: the interface where the OGM should be sent to
+ *
+ * Return: A neighbor node which is the best router towards the given originator
+ * address. Bonding candidates are ignored.
+ */
+static struct batadv_neigh_node *
+batadv_orig_to_direct_router(struct batadv_priv *bat_priv, u8 *orig_addr,
+			     struct batadv_hard_iface *if_outgoing)
+{
+	struct batadv_neigh_node *neigh_node;
+	struct batadv_orig_node *orig_node;
+
+	orig_node = batadv_orig_hash_find(bat_priv, orig_addr);
+	if (!orig_node)
+		return NULL;
+
+	neigh_node = batadv_orig_router_get(orig_node, if_outgoing);
+	batadv_orig_node_put(orig_node);
+
+	return neigh_node;
+}
+
+/**
  * batadv_iv_ogm_process_per_outif() - process a batman iv OGM for an outgoing
  *  interface
  * @skb: the skb containing the OGM
@@ -1372,8 +1406,9 @@ batadv_iv_ogm_process_per_outif(const st
 
 	router = batadv_orig_router_get(orig_node, if_outgoing);
 	if (router) {
-		router_router = batadv_orig_router_get(router->orig_node,
-						       if_outgoing);
+		router_router = batadv_orig_to_direct_router(bat_priv,
+							     router->addr,
+							     if_outgoing);
 		router_ifinfo = batadv_neigh_ifinfo_get(router, if_outgoing);
 	}
 


