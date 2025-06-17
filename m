Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 92A3E2F234B;
	Tue, 17 Jun 2025 16:02:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176173; cv=none; b=sD0vfcVR5Q5li/1cYx2GP+IUyCZrCbISdqbSGg8L5FRKaB4vI1o6IF29IIvYNGa1wv6TykYQ5sHd1nKXA52SMnJ4ZJOWyahPb3p8bA5xh6c4GAynU5EuB/i44/7qqWnN7CTz7OD7njsnIuQWMFDjwOm+tm2CvIr3fT3KdG50CKw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176173; c=relaxed/simple;
	bh=lbpJFo1LscpSK7ul1Yq23cPPlbn4U1ietZtFDny98p8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=l2e1kgDZqKN3HYPHsdozF7vQxQIeD+++Wd7ZmxfrpesDKlVhxwB1ZJ778K9Ysy409z3+z4cCHuoR7wp6lC1wtToq1mKk+WLZZL1nHnGLNzukFEToJCDw1/NXrNbX84p+dQq6Z8tCHJiw29nnYsuWbIpIakPtkM8bbApMvci/QzA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZcIdkCwQ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZcIdkCwQ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 01459C4CEE3;
	Tue, 17 Jun 2025 16:02:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176173;
	bh=lbpJFo1LscpSK7ul1Yq23cPPlbn4U1ietZtFDny98p8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZcIdkCwQ3MzoTC88ENvY5JlNjEAlXdnNh1t6Kqa9ngQSJ+27fjrMTWebeJffLq7h4
	 y95uYG790OmczHGaIJv1Fb3qgDv+6aA+AXVXgDdri45M0XyXG1M7z1pcMtf1XRMU7m
	 JVrZaNxjshIubKGwSUf/FbU47KKl5zZQN+3opzgA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Horatiu Vultur <horatiu.vultur@microchip.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 203/512] net: lan966x: Fix 1-step timestamping over ipv4 or ipv6
Date: Tue, 17 Jun 2025 17:22:49 +0200
Message-ID: <20250617152427.865701114@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Horatiu Vultur <horatiu.vultur@microchip.com>

[ Upstream commit 57ee9584fd8606deef66d7b65fa4dcf94f6843aa ]

When enabling 1-step timestamping for ptp frames that are over udpv4 or
udpv6 then the inserted timestamp is added at the wrong offset in the
frame, meaning that will modify the frame at the wrong place, so the
frame will be malformed.
To fix this, the HW needs to know which kind of frame it is to know
where to insert the timestamp. For that there is a field in the IFH that
says the PDU_TYPE, which can be NONE  which is the default value,
IPV4 or IPV6. Therefore make sure to set the PDU_TYPE so the HW knows
where to insert the timestamp.
Like I mention before the issue is not seen with L2 frames because by
default the PDU_TYPE has a value of 0, which represents the L2 frames.

Fixes: 77eecf25bd9d2f ("net: lan966x: Update extraction/injection for timestamping")
Signed-off-by: Horatiu Vultur <horatiu.vultur@microchip.com>
Link: https://patch.msgid.link/20250521124159.2713525-1-horatiu.vultur@microchip.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/lan966x/lan966x_main.c |  6 +++
 .../ethernet/microchip/lan966x/lan966x_main.h |  5 ++
 .../ethernet/microchip/lan966x/lan966x_ptp.c  | 49 ++++++++++++++-----
 3 files changed, 47 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
index 534d4716d5f7d..73832bba93270 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.c
@@ -353,6 +353,11 @@ static void lan966x_ifh_set_rew_op(void *ifh, u64 rew_op)
 	lan966x_ifh_set(ifh, rew_op, IFH_POS_REW_CMD, IFH_WID_REW_CMD);
 }
 
+static void lan966x_ifh_set_oam_type(void *ifh, u64 oam_type)
+{
+	lan966x_ifh_set(ifh, oam_type, IFH_POS_PDU_TYPE, IFH_WID_PDU_TYPE);
+}
+
 static void lan966x_ifh_set_timestamp(void *ifh, u64 timestamp)
 {
 	lan966x_ifh_set(ifh, timestamp, IFH_POS_TIMESTAMP, IFH_WID_TIMESTAMP);
@@ -380,6 +385,7 @@ static netdev_tx_t lan966x_port_xmit(struct sk_buff *skb,
 			return err;
 
 		lan966x_ifh_set_rew_op(ifh, LAN966X_SKB_CB(skb)->rew_op);
+		lan966x_ifh_set_oam_type(ifh, LAN966X_SKB_CB(skb)->pdu_type);
 		lan966x_ifh_set_timestamp(ifh, LAN966X_SKB_CB(skb)->ts_id);
 	}
 
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
index 25cb2f61986f6..bd3d19cea0034 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_main.h
@@ -75,6 +75,10 @@
 #define IFH_REW_OP_ONE_STEP_PTP		0x3
 #define IFH_REW_OP_TWO_STEP_PTP		0x4
 
+#define IFH_PDU_TYPE_NONE		0
+#define IFH_PDU_TYPE_IPV4		7
+#define IFH_PDU_TYPE_IPV6		8
+
 #define FDMA_RX_DCB_MAX_DBS		1
 #define FDMA_TX_DCB_MAX_DBS		1
 
@@ -254,6 +258,7 @@ struct lan966x_phc {
 
 struct lan966x_skb_cb {
 	u8 rew_op;
+	u8 pdu_type;
 	u16 ts_id;
 	unsigned long jiffies;
 };
diff --git a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
index 63905bb5a63a8..87e5e81d40dc6 100644
--- a/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
+++ b/drivers/net/ethernet/microchip/lan966x/lan966x_ptp.c
@@ -322,34 +322,55 @@ void lan966x_ptp_hwtstamp_get(struct lan966x_port *port,
 	*cfg = phc->hwtstamp_config;
 }
 
-static int lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb)
+static void lan966x_ptp_classify(struct lan966x_port *port, struct sk_buff *skb,
+				 u8 *rew_op, u8 *pdu_type)
 {
 	struct ptp_header *header;
 	u8 msgtype;
 	int type;
 
-	if (port->ptp_tx_cmd == IFH_REW_OP_NOOP)
-		return IFH_REW_OP_NOOP;
+	if (port->ptp_tx_cmd == IFH_REW_OP_NOOP) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		return;
+	}
 
 	type = ptp_classify_raw(skb);
-	if (type == PTP_CLASS_NONE)
-		return IFH_REW_OP_NOOP;
+	if (type == PTP_CLASS_NONE) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		return;
+	}
 
 	header = ptp_parse_header(skb, type);
-	if (!header)
-		return IFH_REW_OP_NOOP;
+	if (!header) {
+		*rew_op = IFH_REW_OP_NOOP;
+		*pdu_type = IFH_PDU_TYPE_NONE;
+		return;
+	}
 
-	if (port->ptp_tx_cmd == IFH_REW_OP_TWO_STEP_PTP)
-		return IFH_REW_OP_TWO_STEP_PTP;
+	if (type & PTP_CLASS_L2)
+		*pdu_type = IFH_PDU_TYPE_NONE;
+	if (type & PTP_CLASS_IPV4)
+		*pdu_type = IFH_PDU_TYPE_IPV4;
+	if (type & PTP_CLASS_IPV6)
+		*pdu_type = IFH_PDU_TYPE_IPV6;
+
+	if (port->ptp_tx_cmd == IFH_REW_OP_TWO_STEP_PTP) {
+		*rew_op = IFH_REW_OP_TWO_STEP_PTP;
+		return;
+	}
 
 	/* If it is sync and run 1 step then set the correct operation,
 	 * otherwise run as 2 step
 	 */
 	msgtype = ptp_get_msgtype(header, type);
-	if ((msgtype & 0xf) == 0)
-		return IFH_REW_OP_ONE_STEP_PTP;
+	if ((msgtype & 0xf) == 0) {
+		*rew_op = IFH_REW_OP_ONE_STEP_PTP;
+		return;
+	}
 
-	return IFH_REW_OP_TWO_STEP_PTP;
+	*rew_op = IFH_REW_OP_TWO_STEP_PTP;
 }
 
 static void lan966x_ptp_txtstamp_old_release(struct lan966x_port *port)
@@ -374,10 +395,12 @@ int lan966x_ptp_txtstamp_request(struct lan966x_port *port,
 {
 	struct lan966x *lan966x = port->lan966x;
 	unsigned long flags;
+	u8 pdu_type;
 	u8 rew_op;
 
-	rew_op = lan966x_ptp_classify(port, skb);
+	lan966x_ptp_classify(port, skb, &rew_op, &pdu_type);
 	LAN966X_SKB_CB(skb)->rew_op = rew_op;
+	LAN966X_SKB_CB(skb)->pdu_type = pdu_type;
 
 	if (rew_op != IFH_REW_OP_TWO_STEP_PTP)
 		return 0;
-- 
2.39.5



