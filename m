Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C48A0341AF
	for <patches@lists.linux.dev>; Mon,  9 Oct 2023 13:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CE1q+gDK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F83DC433B9;
	Mon,  9 Oct 2023 13:48:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1696859321;
	bh=p0AqrE7ew5Z1ZCus4se5+9HK9BQ4y5pTPSRXM1kjjEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CE1q+gDKZNUl+dPM2L/QFfLkKe2ms3xyJaPfcrRkkNBrvQUKzg6zjkYh5bCn2nQYo
	 KmNAyhXUnIpRpFrm7Fy5V+NJuNQ0uHJ6+ork8Tk5mHmhYpetg516xU3KuaSUn2B8dp
	 K/xjQlE6p6ZJ2B4kqMUYuNLGFgav66JuP55z9Crc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pin-yen Lin <treapking@chromium.org>,
	Brian Norris <briannorris@chromium.org>,
	Matthew Wang <matthewmwang@chromium.org>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.14 40/55] wifi: mwifiex: Fix oob check condition in mwifiex_process_rx_packet
Date: Mon,  9 Oct 2023 15:06:39 +0200
Message-ID: <20231009130109.229758529@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231009130107.717692466@linuxfoundation.org>
References: <20231009130107.717692466@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Pin-yen Lin <treapking@chromium.org>

[ Upstream commit aef7a0300047e7b4707ea0411dc9597cba108fc8 ]

Only skip the code path trying to access the rfc1042 headers when the
buffer is too small, so the driver can still process packets without
rfc1042 headers.

Fixes: 119585281617 ("wifi: mwifiex: Fix OOB and integer underflow when rx packets")
Signed-off-by: Pin-yen Lin <treapking@chromium.org>
Acked-by: Brian Norris <briannorris@chromium.org>
Reviewed-by: Matthew Wang <matthewmwang@chromium.org>
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230908104308.1546501-1-treapking@chromium.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/marvell/mwifiex/sta_rx.c | 16 +++++++++-------
 1 file changed, 9 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/marvell/mwifiex/sta_rx.c b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
index f3c6daeba1b85..346e91b9f2ad7 100644
--- a/drivers/net/wireless/marvell/mwifiex/sta_rx.c
+++ b/drivers/net/wireless/marvell/mwifiex/sta_rx.c
@@ -98,7 +98,8 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 	rx_pkt_len = le16_to_cpu(local_rx_pd->rx_pkt_length);
 	rx_pkt_hdr = (void *)local_rx_pd + rx_pkt_off;
 
-	if (sizeof(*rx_pkt_hdr) + rx_pkt_off > skb->len) {
+	if (sizeof(rx_pkt_hdr->eth803_hdr) + sizeof(rfc1042_header) +
+	    rx_pkt_off > skb->len) {
 		mwifiex_dbg(priv->adapter, ERROR,
 			    "wrong rx packet offset: len=%d, rx_pkt_off=%d\n",
 			    skb->len, rx_pkt_off);
@@ -107,12 +108,13 @@ int mwifiex_process_rx_packet(struct mwifiex_private *priv,
 		return -1;
 	}
 
-	if ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
-		     sizeof(bridge_tunnel_header))) ||
-	    (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
-		     sizeof(rfc1042_header)) &&
-	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_AARP &&
-	     ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_IPX)) {
+	if (sizeof(*rx_pkt_hdr) + rx_pkt_off <= skb->len &&
+	    ((!memcmp(&rx_pkt_hdr->rfc1042_hdr, bridge_tunnel_header,
+		      sizeof(bridge_tunnel_header))) ||
+	     (!memcmp(&rx_pkt_hdr->rfc1042_hdr, rfc1042_header,
+		      sizeof(rfc1042_header)) &&
+	      ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_AARP &&
+	      ntohs(rx_pkt_hdr->rfc1042_hdr.snap_type) != ETH_P_IPX))) {
 		/*
 		 *  Replace the 803 header and rfc1042 header (llc/snap) with an
 		 *    EthernetII header, keep the src/dst and snap_type
-- 
2.40.1



