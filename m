Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15DD0611B
	for <patches@lists.linux.dev>; Sun, 28 May 2023 19:46:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93FA7C433D2;
	Sun, 28 May 2023 19:46:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1685303189;
	bh=dIeBcgy0h135Hy5mTH/0jUsKJ7yYbg12WPl3Pp8iebg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=H9+EtH/ImZnXs3CX2LCSEHysGqfQ39/pv/Koq+mmtzdyWrlESKZReYEHBxVv11Xt4
	 alf9urlcomieWiNM7mg25GS4+mG7yN0xBCG0nidPfqT9CjqUKo6Gv1BO2B6Kd2ue/z
	 SaSQl2KvvHN4uGb1T44NMpoNEGDjNqoHyogUv0tY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sunil Goutham <sgoutham@marvell.com>,
	Ratheesh Kannoth <rkannoth@marvell.com>,
	"David S. Miller" <davem@davemloft.net>
Subject: [PATCH 5.10 191/211] octeontx2-pf: Fix TSOv6 offload
Date: Sun, 28 May 2023 20:11:52 +0100
Message-Id: <20230528190848.245237378@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230528190843.514829708@linuxfoundation.org>
References: <20230528190843.514829708@linuxfoundation.org>
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
@@ -526,9 +526,7 @@ static void otx2_sqe_add_ext(struct otx2
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


