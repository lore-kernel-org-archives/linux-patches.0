Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 273D063B8
	for <patches@lists.linux.dev>; Mon, 20 Feb 2023 13:58:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8AE8EC433D2;
	Mon, 20 Feb 2023 13:58:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1676901517;
	bh=I5xRH2qrYlHm87/6xUB5Y8i+Y4zJ2WUuZn9ylKcm5VA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=wdkYEXtajconnpP4DHhrVZa63/j1ZrpNYwY7v1t8Ze0g0ZJKr/JavGxL8kg5ZD4U+
	 fVoF7k6NPLd2uT/Gi7rlETUN8gvmLni/m6uKkfMltFwV0NNCqLTf95FG5Eee1vVxs1
	 gCVoWgWr/qrKsJqi+u7QNfyLY/tAstmlQIqjnzOM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ronak Doshi <doshir@vmware.com>,
	Peng Li <lpeng@vmware.com>,
	Guolin Yang <gyang@vmware.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 6.1 048/118] vmxnet3: move rss code block under eop descriptor
Date: Mon, 20 Feb 2023 14:36:04 +0100
Message-Id: <20230220133602.351145047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230220133600.368809650@linuxfoundation.org>
References: <20230220133600.368809650@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ronak Doshi <doshir@vmware.com>

commit ec76d0c2da5c6dfb6a33f1545cc15997013923da upstream.

Commit b3973bb40041 ("vmxnet3: set correct hash type based on
rss information") added hashType information into skb. However,
rssType field is populated for eop descriptor. This can lead
to incorrectly reporting of hashType for packets which use
multiple rx descriptors. Multiple rx descriptors are used
for Jumbo frame or LRO packets, which can hit this issue.

This patch moves the RSS codeblock under eop descritor.

Cc: stable@vger.kernel.org
Fixes: b3973bb40041 ("vmxnet3: set correct hash type based on rss information")
Signed-off-by: Ronak Doshi <doshir@vmware.com>
Acked-by: Peng Li <lpeng@vmware.com>
Acked-by: Guolin Yang <gyang@vmware.com>
Link: https://lore.kernel.org/r/20230208223900.5794-1-doshir@vmware.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/vmxnet3/vmxnet3_drv.c |   50 +++++++++++++++++++-------------------
 1 file changed, 25 insertions(+), 25 deletions(-)

--- a/drivers/net/vmxnet3/vmxnet3_drv.c
+++ b/drivers/net/vmxnet3/vmxnet3_drv.c
@@ -1546,31 +1546,6 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx
 				rxd->len = rbi->len;
 			}
 
-#ifdef VMXNET3_RSS
-			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
-			    (adapter->netdev->features & NETIF_F_RXHASH)) {
-				enum pkt_hash_types hash_type;
-
-				switch (rcd->rssType) {
-				case VMXNET3_RCD_RSS_TYPE_IPV4:
-				case VMXNET3_RCD_RSS_TYPE_IPV6:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
-				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
-					hash_type = PKT_HASH_TYPE_L4;
-					break;
-				default:
-					hash_type = PKT_HASH_TYPE_L3;
-					break;
-				}
-				skb_set_hash(ctx->skb,
-					     le32_to_cpu(rcd->rssHash),
-					     hash_type);
-			}
-#endif
 			skb_record_rx_queue(ctx->skb, rq->qid);
 			skb_put(ctx->skb, rcd->len);
 
@@ -1653,6 +1628,31 @@ vmxnet3_rq_rx_complete(struct vmxnet3_rx
 			u32 mtu = adapter->netdev->mtu;
 			skb->len += skb->data_len;
 
+#ifdef VMXNET3_RSS
+			if (rcd->rssType != VMXNET3_RCD_RSS_TYPE_NONE &&
+			    (adapter->netdev->features & NETIF_F_RXHASH)) {
+				enum pkt_hash_types hash_type;
+
+				switch (rcd->rssType) {
+				case VMXNET3_RCD_RSS_TYPE_IPV4:
+				case VMXNET3_RCD_RSS_TYPE_IPV6:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_TCPIPV6:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV4:
+				case VMXNET3_RCD_RSS_TYPE_UDPIPV6:
+					hash_type = PKT_HASH_TYPE_L4;
+					break;
+				default:
+					hash_type = PKT_HASH_TYPE_L3;
+					break;
+				}
+				skb_set_hash(skb,
+					     le32_to_cpu(rcd->rssHash),
+					     hash_type);
+			}
+#endif
 			vmxnet3_rx_csum(adapter, skb,
 					(union Vmxnet3_GenericDesc *)rcd);
 			skb->protocol = eth_type_trans(skb, adapter->netdev);


