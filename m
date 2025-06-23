Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 46614218AC1;
	Mon, 23 Jun 2025 21:53:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750715582; cv=none; b=ayyasRQO7cbT2UfKzm1MYp+Rglmm4gAaXn3YYLiWVmk2pEqC5vrRhI3wr1b5IfEYSQ2ywGMShKO5R3XZtLfH7LQVE6akCL3RxFScQ6E9NP+QCkTB7zRk6hnkhx9y2dgfDXjHLOFNgth4X1w5+t0/KVa0SpDYoXXBTJN54Awmt0s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750715582; c=relaxed/simple;
	bh=ohfU6N412EpGx3D3ps2BifsE7lHG4toCjqD+ssHlop8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=esKujcWcDy3RRzjoxwgEe/RYhjhY5gcbeH26m4NJ2zfiXI3JJxCedMdfj+mGBwo6Q+BYL/+5WycdFAfLSLoEgaQx93gDvETDOnk2TOnLG8z+H2C7GX/BOHPZMbzOeo2jdtQ/E3/WdhtLZ9SNMBYEh97ELnp1H9Yo1zj7ho7vU+I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uZ8tL9mo; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uZ8tL9mo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D32D1C4CEEA;
	Mon, 23 Jun 2025 21:53:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750715582;
	bh=ohfU6N412EpGx3D3ps2BifsE7lHG4toCjqD+ssHlop8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uZ8tL9mouHkEpe7bvaD+xOuqT9joAqhuc8sSNoylhOERULG9CVfRhInvZH9kYx6Of
	 a41p/+7e7ijJlzYUo7uR/biwVU/lqGtk/SjTS84RK5Uj8q68937EWpiY7K7jNbmXHD
	 yY71Jl2RClEfjj+qtruYJXXBleJ1MXCEzgj09hh4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andreu Montiel <Andreu.Montiel@technica-engineering.de>,
	Carlos Fernandez <carlos.fernandez@technica-engineering.de>,
	Subbaraya Sundeep <sbhatta@marvell.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 249/508] macsec: MACsec SCI assignment for ES = 0
Date: Mon, 23 Jun 2025 15:04:54 +0200
Message-ID: <20250623130651.377261326@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130645.255320792@linuxfoundation.org>
References: <20250623130645.255320792@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Carlos Fernandez <carlos.fernandez@technica-engineering.de>

[ Upstream commit d9816ec74e6d6aa29219d010bba3f780ba1d9d75 ]

According to 802.1AE standard, when ES and SC flags in TCI are zero,
used SCI should be the current active SC_RX. Current code uses the
header MAC address. Without this patch, when ES flag is 0 (using a
bridge or switch), header MAC will not fit the SCI and MACSec frames
will be discarted.

In order to test this issue, MACsec link should be stablished between
two interfaces, setting SC and ES flags to zero and a port identifier
different than one. For example, using ip macsec tools:

ip link add link $ETH0 macsec0 type macsec port 11 send_sci off
end_station off
ip macsec add macsec0 tx sa 0 pn 2 on key 01 $ETH1_KEY
ip macsec add macsec0 rx port 11 address $ETH1_MAC
ip macsec add macsec0 rx port 11 address $ETH1_MAC sa 0 pn 2 on key 02
ip link set dev macsec0 up

ip link add link $ETH1 macsec1 type macsec port 11 send_sci off
end_station off
ip macsec add macsec1 tx sa 0 pn 2 on key 01 $ETH0_KEY
ip macsec add macsec1 rx port 11 address $ETH0_MAC
ip macsec add macsec1 rx port 11 address $ETH0_MAC sa 0 pn 2 on key 02
ip link set dev macsec1 up

Fixes: c09440f7dcb3 ("macsec: introduce IEEE 802.1AE driver")
Co-developed-by: Andreu Montiel <Andreu.Montiel@technica-engineering.de>
Signed-off-by: Andreu Montiel <Andreu.Montiel@technica-engineering.de>
Signed-off-by: Carlos Fernandez <carlos.fernandez@technica-engineering.de>
Reviewed-by: Subbaraya Sundeep <sbhatta@marvell.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/macsec.c | 40 ++++++++++++++++++++++++++++++++++------
 1 file changed, 34 insertions(+), 6 deletions(-)

diff --git a/drivers/net/macsec.c b/drivers/net/macsec.c
index c007e262daf7d..e954b46ebe86b 100644
--- a/drivers/net/macsec.c
+++ b/drivers/net/macsec.c
@@ -243,15 +243,39 @@ static sci_t make_sci(const u8 *addr, __be16 port)
 	return sci;
 }
 
-static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present)
+static sci_t macsec_active_sci(struct macsec_secy *secy)
 {
-	sci_t sci;
+	struct macsec_rx_sc *rx_sc = rcu_dereference_bh(secy->rx_sc);
+
+	/* Case single RX SC */
+	if (rx_sc && !rcu_dereference_bh(rx_sc->next))
+		return (rx_sc->active) ? rx_sc->sci : 0;
+	/* Case no RX SC or multiple */
+	else
+		return 0;
+}
+
+static sci_t macsec_frame_sci(struct macsec_eth_header *hdr, bool sci_present,
+			      struct macsec_rxh_data *rxd)
+{
+	struct macsec_dev *macsec;
+	sci_t sci = 0;
 
-	if (sci_present)
+	/* SC = 1 */
+	if (sci_present) {
 		memcpy(&sci, hdr->secure_channel_id,
 		       sizeof(hdr->secure_channel_id));
-	else
+	/* SC = 0; ES = 0 */
+	} else if ((!(hdr->tci_an & (MACSEC_TCI_ES | MACSEC_TCI_SC))) &&
+		   (list_is_singular(&rxd->secys))) {
+		/* Only one SECY should exist on this scenario */
+		macsec = list_first_or_null_rcu(&rxd->secys, struct macsec_dev,
+						secys);
+		if (macsec)
+			return macsec_active_sci(&macsec->secy);
+	} else {
 		sci = make_sci(hdr->eth.h_source, MACSEC_PORT_ES);
+	}
 
 	return sci;
 }
@@ -1110,7 +1134,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	struct macsec_rxh_data *rxd;
 	struct macsec_dev *macsec;
 	unsigned int len;
-	sci_t sci;
+	sci_t sci = 0;
 	u32 hdr_pn;
 	bool cbit;
 	struct pcpu_rx_sc_stats *rxsc_stats;
@@ -1157,11 +1181,14 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 
 	macsec_skb_cb(skb)->has_sci = !!(hdr->tci_an & MACSEC_TCI_SC);
 	macsec_skb_cb(skb)->assoc_num = hdr->tci_an & MACSEC_AN_MASK;
-	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci);
 
 	rcu_read_lock();
 	rxd = macsec_data_rcu(skb->dev);
 
+	sci = macsec_frame_sci(hdr, macsec_skb_cb(skb)->has_sci, rxd);
+	if (!sci)
+		goto drop_nosc;
+
 	list_for_each_entry_rcu(macsec, &rxd->secys, secys) {
 		struct macsec_rx_sc *sc = find_rx_sc(&macsec->secy, sci);
 
@@ -1284,6 +1311,7 @@ static rx_handler_result_t macsec_handle_frame(struct sk_buff **pskb)
 	macsec_rxsa_put(rx_sa);
 drop_nosa:
 	macsec_rxsc_put(rx_sc);
+drop_nosc:
 	rcu_read_unlock();
 drop_direct:
 	kfree_skb(skb);
-- 
2.39.5



