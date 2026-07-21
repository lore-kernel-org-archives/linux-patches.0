Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3EEF93B7B79;
	Tue, 21 Jul 2026 20:52:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784667145; cv=none; b=NZw+oRCbN32XsasdUVO3RFdG3WaqYuG+6v/BCs/4PpT2IjIbfGc2hLw8JIWA2xy4Q5LagSJEvFf5fr6sieUBAraCIPfi6MXFE2Ba950sBp2/0ZguxDGxfVyIFI+EJhBDmk5JR6qgaLApndedceUitC3WVtpZccq6jWrea7knin0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784667145; c=relaxed/simple;
	bh=GWB2ZUC6tGRNWlQJ0rfm+ihQG3DQ3v4Pf55kyxin1pI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B9ctiDKTxftx8/kDxUqhZjEf929ekbMM1DA/+wJmxxHKnPeIiaPW/5J0AImNS9HjF9e/m0MoWvGKSCpuwVfd/13VBZmV/tGfi59vOxXg1Gwxs4AAxhxfzvBzI96TuPZZaDZIcpMiuXLMfE8CT1gbi/nxycNGTQMw60QNh2cm2DU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=h2aOV8rH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="h2aOV8rH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A143D1F000E9;
	Tue, 21 Jul 2026 20:52:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784667144;
	bh=nKO6Zc/A3BBWOGTGvj3oQEiKgGL/rkGoonZX2/bxaKw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=h2aOV8rHZs5WIFsHcEVPOwncC8JWOyq7CZ9SCS7Hmbf7w2c2WqIYDooHMSIL5EGRU
	 Ux5I4kloKsmUEXF+u6lsjQVZc+GMK2AGfTQYbsDGIlX3Vsnc3OWA+IE5TK5VHM/zCR
	 SNhQIyO0Z3JQjmRKLWJ7uz0/luXvUCTlPV+DbYaU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sashiko <sashiko-bot@kernel.org>,
	Sven Eckelmann <sven@narfation.org>
Subject: [PATCH 6.6 0949/1266] batman-adv: dat: ensure accessible eth_hdr proto field
Date: Tue, 21 Jul 2026 17:23:06 +0200
Message-ID: <20260721152503.063608925@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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


