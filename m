Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 91B4C522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:22:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11408C433C7;
	Sun,  9 Jul 2023 11:22:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688901776;
	bh=zH9s6XmQVOMLX/SuqZcLS/3z0qpV+GVeVXav/e5d/JU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x1xx7hzMdfZvpKuH+ybSUUYV8wkkcnqip34ymO8NuPKOE3UiObLuDRER4oc9XVir8
	 IN9t1VTBtwvvw4slK6wQgkm0wkZRgnAWzCUWjQbInKTVdxyvJQ3suhOnwLByJX9/D0
	 XQ0IIxLHoeLyIPrLz2BjtoW+R7MuRPiU+N8Qyd/I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jimmy Assarsson <extja@kvaser.com>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 140/431] can: kvaser_pciefd: Set hardware timestamp on transmitted packets
Date: Sun,  9 Jul 2023 13:11:28 +0200
Message-ID: <20230709111454.443174684@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Jimmy Assarsson <extja@kvaser.com>

[ Upstream commit ec681b91befa982477e24a150dd6452427fe6473 ]

Set hardware timestamp on transmitted packets.

Fixes: 26ad340e582d ("can: kvaser_pciefd: Add driver for Kvaser PCIEcan devices")
Signed-off-by: Jimmy Assarsson <extja@kvaser.com>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://lore.kernel.org/all/20230529134248.752036-5-extja@kvaser.com
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/kvaser_pciefd.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 0b537292c7b19..74a47244f1291 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -1519,6 +1519,7 @@ static void kvaser_pciefd_handle_nack_packet(struct kvaser_pciefd_can *can,
 
 	if (skb) {
 		cf->can_id |= CAN_ERR_BUSERROR;
+		kvaser_pciefd_set_skb_timestamp(can->kv_pcie, skb, p->timestamp);
 		netif_rx(skb);
 	} else {
 		stats->rx_dropped++;
@@ -1550,8 +1551,15 @@ static int kvaser_pciefd_handle_ack_packet(struct kvaser_pciefd *pcie,
 		netdev_dbg(can->can.dev, "Packet was flushed\n");
 	} else {
 		int echo_idx = p->header[0] & KVASER_PCIEFD_PACKET_SEQ_MSK;
-		int dlc = can_get_echo_skb(can->can.dev, echo_idx, NULL);
-		u8 count = ioread32(can->reg_base +
+		int dlc;
+		u8 count;
+		struct sk_buff *skb;
+
+		skb = can->can.echo_skb[echo_idx];
+		if (skb)
+			kvaser_pciefd_set_skb_timestamp(pcie, skb, p->timestamp);
+		dlc = can_get_echo_skb(can->can.dev, echo_idx, NULL);
+		count = ioread32(can->reg_base +
 				    KVASER_PCIEFD_KCAN_TX_NPACKETS_REG) & 0xff;
 
 		if (count < KVASER_PCIEFD_CAN_TX_MAX_COUNT &&
-- 
2.39.2



