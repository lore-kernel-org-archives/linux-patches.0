Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 69A83128816;
	Tue, 30 Apr 2024 11:31:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714476682; cv=none; b=H3jaAx5Nsyz/O2WXmaF9/vHhXG2RjpZ61uFnso7PMhmEiosNEX9YPCmahcvlWbiTeyCPWq3SWKmAIQYc4wti56hib1bqXkQdmEC15GlGbStYJ1NO9gDKt3okystCkldaR2FPOAwzNKEbvS7+an7xVTj+8U2zPHxVS31KhVsSVik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714476682; c=relaxed/simple;
	bh=BUfBUBsmMdH1ih+B3ahMI6XB9e0rAf01VENc4iU2318=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=WdZ6nCyG1FaRIrPIGtocbbWHx1W2QJOkj+E2/vfYrunc91YWYc92X9DELNlb26DoHf8zsh3UoUz5wZASWd8RYtSn+03cbw61ILIZAU3DLikCh0fNZdV3fhCG6Zch8RE9lVLGQAwcyBfMnSYJGeUtaRML6b5/l24Q+KXH0i6rMKA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=bIc/CUTl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bIc/CUTl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF208C2BBFC;
	Tue, 30 Apr 2024 11:31:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714476682;
	bh=BUfBUBsmMdH1ih+B3ahMI6XB9e0rAf01VENc4iU2318=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bIc/CUTlv7Jyf/Ie1dnzsKXKV5T81ndW6Y5HfJ6RQhL01+aJFUpZ7SN6z41VtA3S0
	 9Mhc2JaCStK8UWHHGzPln/ic+xPIInBP3WbQbkDV/ZNoCyVFxefeLy9QPpHEEyoUNo
	 PpXvOaFZYtXJUSpzXA+urAakJUMv2fzMJkf8c/VU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sabrina Dubroca <sd@queasysnail.net>,
	Rahul Rameshbabu <rrameshbabu@nvidia.com>,
	Benjamin Poirier <bpoirier@nvidia.com>,
	Cosmin Ratiu <cratiu@nvidia.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 109/110] macsec: Detect if Rx skb is macsec-related for offloading devices that update md_dst
Date: Tue, 30 Apr 2024 12:41:18 +0200
Message-ID: <20240430103050.793338314@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103047.561802595@linuxfoundation.org>
References: <20240430103047.561802595@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/macsec.c |   44 +++++++++++++++++++++++++++++++++++++-------
 1 file changed, 37 insertions(+), 7 deletions(-)

--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -1007,10 +1007,12 @@ static enum rx_handler_result handle_not
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
@@ -1021,10 +1023,42 @@ static enum rx_handler_result handle_not
 		 * the SecTAG, so we have to deduce which port to deliver to.
 		 */
 		if (macsec_is_offloaded(macsec) && netif_running(ndev)) {
-			if (md_dst && md_dst->type == METADATA_MACSEC &&
-			    (!find_rx_sc(&macsec->secy, md_dst->u.macsec_info.sci)))
+			const struct macsec_ops *ops;
+
+			ops = macsec_get_ops(macsec, NULL);
+
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
@@ -1040,11 +1074,7 @@ static enum rx_handler_result handle_not
 					break;
 
 				nskb->dev = ndev;
-				if (ether_addr_equal_64bits(hdr->h_dest,
-							    ndev->broadcast))
-					nskb->pkt_type = PACKET_BROADCAST;
-				else
-					nskb->pkt_type = PACKET_MULTICAST;
+				eth_skb_pkt_type(nskb, ndev);
 
 				__netif_rx(nskb);
 			}


