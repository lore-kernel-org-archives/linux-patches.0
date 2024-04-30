Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CDA3512D76B;
	Tue, 30 Apr 2024 11:15:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475723; cv=none; b=KeRuo4CmOBHapHFm8OF6XfhZgfslJQiZHUtvd7/GTzqJsS85ZY0Hu2l6OIoOzP1AQk29DzkdvOByb3e+l2AAL6q8PbcWSRUDm2FY8HbgIi0WIm+3VVPXnan5wJXSOUmK0McgAWvzXXBZXQQBU7vDRRBuLUlZlMKvkR3eVPc0+t4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475723; c=relaxed/simple;
	bh=h5DDdYnpJNzwlPXrx87DpLG6N70fzMJUvJqAXuosqX0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tw+DjVtsbVk+r/JmzIDbco/D4D8tOz3E6YXtV1H58IBYwOaLVCGcMFfSpSQhXjP0g/eKbVqG4Gzu+kmVdyz6iQ6mqGUdiYxe/pga2CpoZg/F5MvPA1VycHClBYPsPFgUT5i6h7LGhf/f3ARxXloVo99/RUBjAhxW9yMZAAUhW2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IFCm21d+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IFCm21d+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52552C2BBFC;
	Tue, 30 Apr 2024 11:15:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475723;
	bh=h5DDdYnpJNzwlPXrx87DpLG6N70fzMJUvJqAXuosqX0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=IFCm21d+kBoeHoB9wS2MyEHYQKhRkcwvXknC7c/I0atFbIOl4ts4nMJfmAGBp4Rrp
	 E1Xn/DyeqRT4yLChiIARmuTsxdoJcFzom4IIkyXUiy0LbCKUUb9rL4xEc0gc5CW8Ch
	 Zh6Hpo1FIokRsHc9GTii4qL1o7QiVaTOv4m0mMNY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.6 184/186] macsec: Detect if Rx skb is macsec-related for offloading devices that update md_dst
Date: Tue, 30 Apr 2024 12:40:36 +0200
Message-ID: <20240430103103.373078586@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Rahul Rameshbabu <rrameshbabu@nvidia.com>

commit 642c984dd0e37dbaec9f87bd1211e5fac1f142bf upstream.

Can now correctly identify where the packets should be delivered by using
md_dst or its absence on devices that provide it.

This detection is not possible without device drivers that update md_dst. A
fallback pattern should be used for supporting such device drivers. This
fallback mode causes multicast messages to be cloned to both the non-macsec
and macsec ports, independent of whether the multicast message received was
encrypted over MACsec or not. Other non-macsec traffic may also fail to be
handled correctly for devices in promiscuous mode.

Link: https://lore.kernel.org/netdev/ZULRxX9eIbFiVi7v@hog/
Cc: Sabrina Dubroca <sd@queasysnail.net>
Cc: stable@vger.kernel.org
Fixes: 860ead89b851 ("net/macsec: Add MACsec skb_metadata_dst Rx Data path support")
Signed-off-by: Rahul Rameshbabu <rrameshbabu@nvidia.com>
Reviewed-by: Benjamin Poirier <bpoirier@nvidia.com>
Reviewed-by: Cosmin Ratiu <cratiu@nvidia.com>
Reviewed-by: Sabrina Dubroca <sd@queasysnail.net>
Link: https://lore.kernel.org/r/20240423181319.115860-4-rrameshbabu@nvidia.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/macsec.c |   46 ++++++++++++++++++++++++++++++++++++----------
 1 file changed, 36 insertions(+), 10 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -996,10 +996,12 @@ static enum rx_handler_result handle_not
 	struct metadata_dst *md_dst;
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
+	bool is_macsec_md_dst;
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
 	md_dst = skb_metadata_dst(skb);
+	is_macsec_md_dst = md_dst && md_dst->type == METADATA_MACSEC;
 
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct sk_buff *nskb;
@@ -1010,14 +1012,42 @@ static enum rx_handler_result handle_not
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			struct macsec_rx_sc *rx_sc = NULL;
+			const struct macsec_ops *ops;
 
-			if (md_dst && md_dst->type == METADATA_MACSEC)
-				rx_sc = find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci);
+			ops = macsec_get_ops(macsec, NULL);
 
-			if (md_dst && md_dst->type == METADATA_MACSEC && !rx_sc)
+			if (ops->rx_uses_md_dst && !is_macsec_md_dst)
 				continue;
 
+			if (is_macsec_md_dst) {
+				struct macsec_rx_sc *rx_sc;
+
+				/* All drivers that implement MACsec offload
+				 * support using skb metadata destinations must
+				 * indicate that they do so.
+				 */
+				DEBUG_NET_WARN_ON_ONCE(!ops->rx_uses_md_dst);
+				rx_sc = find_rx_sc(&macsec->secy,
+						   md_dst->u.macsec_info.sci);
+				if (!rx_sc)
+					continue;
+				/* device indicated macsec offload occurred */
+				skb->dev = ndev;
+				skb->pkt_type = PACKET_HOST;
+				eth_skb_pkt_type(skb, ndev);
+				ret = RX_HANDLER_ANOTHER;
+				goto out;
+			}
+
+			/* This datapath is insecure because it is unable to
+			 * enforce isolation of broadcast/multicast traffic and
+			 * unicast traffic with promiscuous mode on the macsec
+			 * netdev. Since the core stack has no mechanism to
+			 * check that the hardware did indeed receive MACsec
+			 * traffic, it is possible that the response handling
+			 * done by the MACsec port was to a plaintext packet.
+			 * This violates the MACsec protocol standard.
+			 */
 			if (ether_addr_equal_64bits(hdr->h_dest,
 						    ndev->dev_addr)) {
 				/* exact match, divert skb to this port */
@@ -1033,14 +1063,10 @@ static enum rx_handler_result handle_not
 					break;
 
 				nskb->dev = ndev;
-				if (ether_addr_equal_64bits(hdr->h_dest,
-							    ndev->broadcast))
-					nskb->pkt_type = PACKET_BROADCAST;
-				else
-					nskb->pkt_type = PACKET_MULTICAST;
+				eth_skb_pkt_type(nskb, ndev);
 
 				__netif_rx(nskb);
-			} else if (rx_sc || ndev->flags & IFF_PROMISC) {
+			} else if (ndev->flags & IFF_PROMISC) {
 				skb->dev = ndev;
 				skb->pkt_type = PACKET_HOST;
 				ret = RX_HANDLER_ANOTHER;


