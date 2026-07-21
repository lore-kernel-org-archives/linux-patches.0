Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 324C038399A;
	Tue, 21 Jul 2026 17:17:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784654280; cv=none; b=raQ8sz6ceB27aWlbgc7Qqz9LwLT5DPR5DdctXaWXPoGEsL1WYvakFL3B2zFMK+LB7uXFPBEBpmoT6dFKQSOHYx5mz0aC/CcRZFI6nG6Z8nxH+FBgOrs+iKeTRuYvO04MXKSelbipT5fXaXJnrZoC3+yCUyMc7D4J1FUyP5YfbT4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784654280; c=relaxed/simple;
	bh=NfTSXHbw9136Eh1CG7a0baiQ/d3ABdYQZu7smlf1n0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F7/1T1sKSI+aDVnHOnAPLSmUKPh6G+WSY55murxMwtQqAVByWSbhYPl8alS6tw5wegvTksfApnmUx3qk8U16bX4Fcwgfbnvz28QQ4GWdAUPVcBl7C1GGgoviUwjO64I5uxaVUTry71Ul2JFIbkKJMluRdQqMLvBUzeaWCq9WLig=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mSLIj9e5; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mSLIj9e5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4D7A11F00A3A;
	Tue, 21 Jul 2026 17:17:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784654277;
	bh=l7+UgQKAZjoCQyXKFS0gqch7bdThCqPwLeCD+eyDxsw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mSLIj9e5zeQn62lpEbr1+r1/26y0dAbMqbrA2Oy4FwRD6pfhRh/UAispRnvx+YuNE
	 KYcZ75/LH4NAK6jrEAvinv4Hwdch+EvvI93jfEmAx2SOmZhwGBXDAmgiVfvfbkwqT/
	 tiknRTh3ZWXoJN40MZ5BJ6Q3oa7hKeZwi39cgJ5s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 7.1 1643/2077] batman-adv: dat: ensure accessible eth_hdr proto field
Date: Tue, 21 Jul 2026 17:21:56 +0200
Message-ID: <20260721152631.505660785@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -1065,6 +1065,9 @@ out:
  * @skb: the buffer containing the packet to extract the VID from
  * @hdr_size: the size of the batman-adv header encapsulating the packet
  *
+ * The caller must ensure that at least @hdr_size + ETH_HLEN bytes are
+ * accessible after skb->data.
+ *
  * Return: If the packet embedded in the skb is vlan tagged this function
  * returns the VID with the BATADV_VLAN_HAS_TAG flag. Otherwise BATADV_NO_FLAGS
  * is returned.
@@ -1147,6 +1150,10 @@ bool batadv_dat_snoop_outgoing_arp_reque
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1242,6 +1249,10 @@ bool batadv_dat_snoop_incoming_arp_reque
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1304,6 +1315,10 @@ void batadv_dat_snoop_outgoing_arp_reply
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		return;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		return;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1352,6 +1367,10 @@ bool batadv_dat_snoop_incoming_arp_reply
 	if (!atomic_read(&bat_priv->distributed_arp_table))
 		goto out;
 
+	/* first, find out the vid. */
+	if (!pskb_may_pull(skb, hdr_size + ETH_HLEN))
+		goto out;
+
 	vid = batadv_dat_get_vid(skb, &hdr_size);
 
 	type = batadv_arp_get_type(bat_priv, skb, hdr_size);
@@ -1806,6 +1825,10 @@ bool batadv_dat_drop_broadcast_packet(st
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
@@ -566,6 +566,9 @@ void batadv_recv_handler_unregister(u8 p
  * @skb: the buffer containing the packet
  * @header_len: length of the batman header preceding the ethernet header
  *
+ * The caller must ensure that at least @header_len + ETH_HLEN bytes are
+ * accessible after skb->data.
+ *
  * Return: VID with the BATADV_VLAN_HAS_TAG flag when the packet embedded in the
  * skb is vlan tagged. Otherwise BATADV_NO_FLAGS.
  */


