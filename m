Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 39E4A611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BB6CFC433D2;
	Sun, 28 May 2023 19:50:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303418;
	bh=zQaC3A4sihifGlwDg9ifI1pb/5Gnh95E5covwIp02Fw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hm1ZADHeM2op0jsV55Wp9h6e2saOwT+ZqS5RMfIWsgEE9VEZB6nOLIlHtUIpeJjIU
	 hZuX316WqOX9jAG6f2aEVWg7Wk+6sGfE3gCC29wMshy39hPm+LmMlEV5wjHCqTIF67
	 LCnyNcgTV8ezIUDl8QNul8v782axRpJWE+rf+Ka4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.15 38/69] octeontx2-pf: Fix TSOv6 offload
Date: Sun, 28 May 2023 20:11:58 +0100
Message-Id: <20230528190829.778435217@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190828.358612414@linuxfoundation.org>
References: <20230528190828.358612414@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Sunil Goutham <sgoutham@marvell.com>

commit de678ca38861f2eb58814048076dcf95ed1b5bf9 upstream.

HW adds segment size to the payload length
in the IPv6 header. Fix payload length to
just TCP header length instead of 'TCP header
size + IPv6 header size'.

Fixes: 86d7476078b8 ("octeontx2-pf: TCP segmentation offload support")
Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
Signed-off-by: Ratheesh Kannoth <rkannoth@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c |    4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

--- a/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/nic/otx2_txrx.c
@@ -574,9 +574,7 @@ static void otx2_sqe_add_ext(struct otx2
 				htons(ext->lso_sb - skb_network_offset(skb));
 		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_TCPV6) {
 			ext->lso_format = pfvf->hw.lso_tsov6_idx;
-
-			ipv6_hdr(skb)->payload_len =
-				htons(ext->lso_sb - skb_network_offset(skb));
+			ipv6_hdr(skb)->payload_len = htons(tcp_hdrlen(skb));
 		} else if (skb_shinfo(skb)->gso_type & SKB_GSO_UDP_L4) {
 			__be16 l3_proto = vlan_get_protocol(skb);
 			struct udphdr *udph = udp_hdr(skb);


