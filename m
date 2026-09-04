Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F8CB400DE8;
	Fri,  4 Sep 2026 06:06:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788501986; cv=none; b=EcsjLRkZ31CDvwYWWfJA2OkujUMhKGvkGfdo1jaDPWmwCQuwt6rM1KZBP3T8saloC93kDrtXsSs9t2N3n9Vmq5NcGXTjMH4JckOnrSO92L3oz/DlNQEm45/E8sjEzKY69Gq/GmAP5JcYDptdljPJlRoVPORkoK1B7PPNBQEvtSs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788501986; c=relaxed/simple;
	bh=jkNL6DwCBR9pSvJTHKgRR5jKhixoMSBpkR9X+MJAx98=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ojxH6fI1JK/0U+gCeO1IoE8YEdWwfwJ+16JXmvIbwKHD3rqLYF7RvC3Fnq82jXNmvolF5KAHhgt/SdDtoMQtVRJ6iB3UDlaySflOG6J1GXCRgVQyaBzUtXahlyXrcMXDb+GwspB3s7rANVGf2tc3t27LhWxISuY4srO7qB93bR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mb/41bb9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mb/41bb9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B409D1F00A3D;
	Fri,  4 Sep 2026 06:06:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788501985;
	bh=JwbSU8U+boiu0U+590RcXciwpU+BoD48V6EQlh2/mJ0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=mb/41bb9GwJGcTb6sIAvUP57XBRt2XxD1KuGO1EnGAVSPGXaKcNhuvixFh833BKR2
	 CIBZZgul5fXorwiVQxqfTDr1vD794P2M4HbKEieXMP0LuQIA+yRfJILVQh2wSHoKQd
	 BU7zwnLgduNXa+5ZznwIjOlgX5KcHFdQDodfUpjs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.12 050/403] usb: typec: tcpci: pass correct rx_type to tcpm_pd_receive()
Date: Fri,  4 Sep 2026 06:57:33 +0200
Message-ID: <20260904045735.968063080@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045734.806166532@linuxfoundation.org>
References: <20260904045734.806166532@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xu Yang <xu.yang_2@nxp.com>

commit b691a07c5f644080374ddd24de6a0e05f5d28744 upstream.

Previously, tcpci_irq() always passed TCPC_TX_SOP as the receive type
to tcpm_pd_receive(), ignoring the actual frame type reported by the
TCPC_RX_BUF_FRAME_TYPE register.

Cache the TCPC_RX_DETECT register value in rx_type_mask variable. When
a PD messageis received, read TCPC_RX_BUF_FRAME_TYPE register and handle
the message only if its frame type is enabled in mask.

The TCPC_RX_BUF_FRAME_TYPE register records the received message type,
which has a 1:1 mapping to enum tcpm_transmit_type.

Fixes: fb7ff25ae433 ("usb: typec: tcpm: add discover identity support for SOP'")
Cc: stable@vger.kernel.org
Signed-off-by: Xu Yang <xu.yang_2@nxp.com>
Acked-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/20260723104614.3717623-1-xu.yang_2@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpci.c |   12 +++++++++++-
 include/linux/usb/tcpci.h      |    1 +
 2 files changed, 12 insertions(+), 1 deletion(-)

--- a/drivers/usb/typec/tcpm/tcpci.c
+++ b/drivers/usb/typec/tcpm/tcpci.c
@@ -36,6 +36,7 @@ struct tcpci {
 
 	struct regmap *regmap;
 	unsigned int alert_mask;
+	unsigned int rx_type_mask;
 
 	bool controls_vbus;
 
@@ -484,6 +485,8 @@ static int tcpci_set_pd_rx(struct tcpc_d
 		if (tcpci->data->cable_comm_capable)
 			reg |= TCPC_RX_DETECT_SOP1;
 	}
+
+	tcpci->rx_type_mask = reg;
 	ret = regmap_write(tcpci->regmap, TCPC_RX_DETECT, reg);
 	if (ret < 0)
 		return ret;
@@ -745,6 +748,7 @@ process_status:
 	if (status & TCPC_ALERT_RX_STATUS) {
 		struct pd_message msg;
 		unsigned int cnt, payload_cnt;
+		enum tcpm_transmit_type rx_type;
 		u16 header;
 
 		regmap_read(tcpci->regmap, TCPC_RX_BYTE_CNT, &cnt);
@@ -769,10 +773,16 @@ process_status:
 			regmap_raw_read(tcpci->regmap, TCPC_RX_DATA,
 					&msg.payload, payload_cnt);
 
+		ret = regmap_read(tcpci->regmap, TCPC_RX_BUF_FRAME_TYPE, &rx_type);
+		if (ret)
+			return ret;
+
 		/* Read complete, clear RX status alert bit */
 		tcpci_write16(tcpci, TCPC_ALERT, TCPC_ALERT_RX_STATUS);
 
-		tcpm_pd_receive(tcpci->port, &msg, TCPC_TX_SOP);
+		rx_type &= TCPC_RX_BUF_FRAME_TYPE_MASK;
+		if (tcpci->rx_type_mask & BIT(rx_type))
+			tcpm_pd_receive(tcpci->port, &msg, rx_type);
 	}
 
 	if (tcpci->data->vbus_vsafe0v && (status & TCPC_ALERT_EXTENDED_STATUS)) {
--- a/include/linux/usb/tcpci.h
+++ b/include/linux/usb/tcpci.h
@@ -144,6 +144,7 @@
 #define TCPC_RX_BUF_FRAME_TYPE		0x31
 #define TCPC_RX_BUF_FRAME_TYPE_SOP	0
 #define TCPC_RX_BUF_FRAME_TYPE_SOP1	1
+#define TCPC_RX_BUF_FRAME_TYPE_MASK	GENMASK(2, 0)
 #define TCPC_RX_HDR			0x32
 #define TCPC_RX_DATA			0x34 /* through 0x4f */
 


