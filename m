Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 95F453C10A7;
	Tue, 21 Jul 2026 21:39:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784669998; cv=none; b=karZ4F8pnClTDk74OQM53C6ck12iwT3JtJSSCSJVaxAVfgi4YJ4nQhV3uMzDZXHNYy4PbSDWwD79Bzk4IKAxuuDhdFQHPQUikmPIAIxE7TY1LwFOGNKzVinC7c6htdnlhL4bh7jTxsP1m8QgdYnBxXQjqsxuRt3Ci0jODLP97Rk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784669998; c=relaxed/simple;
	bh=C5nh4q9sT/v0szLGXeEcFrWb670R+dravYvp0SBWtKo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GJrJJPPo9bhAR1ODryW2IjiE/Pz4eQsShsQOzZG8FjBNO9IBfTZ9Yrn6/flNAH229NJCd1xiC+WCP3hTy8rBM/swRt0FGlpOWtjQfB9VxyW1TVvMDx2oRKQ98Rx8AyMJ329YTUOtmIZIpI5rWvRPZsV32rG6Vqd+WClVD7I6jHo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yprD1Kri; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yprD1Kri"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 023501F000E9;
	Tue, 21 Jul 2026 21:39:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784669997;
	bh=mh1zoWNUar+DovWvcPFTlh6AuWztcw49Oam3/S+InHc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yprD1KriLKX7Ri1zeqiX4VmMtmDBzJ0vB06m2DksK9GbSQUvwx9BkRbtat1qZpHs8
	 AP3Ci+M/SU/cwCe/nSjEmmHptTSQXToKfpb6HTfCx8GEDbObe2FO2IkE1Ma/FK7jvn
	 ymREJKDRUY4XWkPDefpEi9htpACre+qWUNYsg9Qs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.1 0766/1067] batman-adv: dat: ensure accessible eth_hdr proto field
Date: Tue, 21 Jul 2026 17:22:47 +0200
Message-ID: <20260721152441.710577633@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152424.521567757@linuxfoundation.org>
References: <20260721152424.521567757@linuxfoundation.org>
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

From: Sven Eckelmann <sven@narfation.org>

commit 26560c4a03dc4d607331600c187f59ab2df5f341 upstream.

When batadv_get_vid() accesses the proto field of the ethernet header, it
is not checking if the data itself is accessible. The caller is responsible
for it. But in contrast to other call sites, batadv_dat_get_vid() and its
caller didn't make sure this is true. This could have caused an
out-of-bounds access.

Cc: stable@vger.kernel.org
Reported-by: Sashiko <sashiko-bot@kernel.org>
Fixes: be1db4f6615b ("batman-adv: make the Distributed ARP Table vlan aware")
Signed-off-by: Sven Eckelmann <sven@narfation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/batman-adv/distributed-arp-table.c |   23 +++++++++++++++++++++++
 net/batman-adv/main.c                  |    3 +++
 2 files changed, 26 insertions(+)

--- a/net/batman-adv/distributed-arp-table.c
+++ b/net/batman-adv/distributed-arp-table.c
@@ -1077,6 +1077,9 @@ out:
  * @skb: the buffer containing the packet to extract the VID from
  * @hdr_size: the size of the batman-adv header encapsulating the packet
  *
+ * The caller must ensure that at least @hdr_size + ETH_HLEN bytes are
+ * accessible after skb->data.
+ *
  * Return: If the packet embedded in the skb is vlan tagged this function
  * returns the VID with the BATADV_VLAN_HAS_TAG flag. Otherwise BATADV_NO_FLAGS
  * is returned.
@@ -1159,6 +1162,10 @@ bool batadv_dat_snoop_outgoing_arp_reque
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1254,6 +1261,10 @@ bool batadv_dat_snoop_incoming_arp_reque
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1316,6 +1327,10 @@ void batadv_dat_snoop_outgoing_arp_reply
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		return;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		return;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1364,6 +1379,10 @@ bool batadv_dat_snoop_incoming_arp_reply
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1818,6 +1837,10 @@ bool batadv_dat_drop_broadcast_packet(st
 	if (batadv_forw_packet_is_rebroadcast(forw_packet))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(forw_packet->skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(forw_packet->skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, forw_packet->skb, hdr_size);
--- a/net/batman-adv/main.c
+++ b/net/batman-adv/main.c
@@ -618,6 +618,9 @@ __be32 batadv_skb_crc32(struct sk_buff *
  * @skb: the buffer containing the packet
  * @header_len: length of the batman header preceding the ethernet header
  *
+ * The caller must ensure that at least @header_len + ETH_HLEN bytes are
+ * accessible after skb->data.
+ *
  * Return: VID with the BATADV_VLAN_HAS_TAG flag when the packet embedded in the
  * skb is vlan tagged. Otherwise BATADV_NO_FLAGS.
  */


