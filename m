Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1AB33A6B82;
	Fri,  4 Sep 2026 05:09:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788498569; cv=none; b=tr2yoORu5WRdYss2Ba5OJ07cZrjOueGQ2hbnVjUcKx9k/RSfU+F3oCkPMARsLG0wFvWli6UoWPxbYbn6E10Kh8grVuSAySwRVOaRfXTtP9/97G9EclOYt+pYeLS3DdpuqGl1fa394CoTSm3MfbMWxjOjByAFY37EVbIXeeRS2fo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788498569; c=relaxed/simple;
	bh=RdVUTCefOpkg5mT0zk9MxoLuIAnyLkIbT09TBoF70Co=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s96d3A3duQDOoUckTMMPtpbyyhzA3Ur8LxMDKMT8RzAEAWqGo83VSEzzqm8qQYtbYcqEmV5UsnYkBNxPZNSEDopscw4elElk41b59eSrtPUFKGMPh6dubZFiCqkHY+jfnUHGBuIGNYdzBS0t9GtrHfaW2RaSYSDsv6myoqpuTCQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ovM9a+pw; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ovM9a+pw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 27C861F00A3D;
	Fri,  4 Sep 2026 05:09:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788498567;
	bh=B00sA+q4NfNZMxIFQhfoEXebnNkB9KM8fS30bd2wcj4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ovM9a+pwBIDgBX0eERtNvk8lhU9cZXqR8Yg71Cbbi3zaSvvbfxoj4ETYPo/Lzmgms
	 Rbj+K3dQpDJNLpFvllP4iwIcQBL4xjhfmTWHH4szmE5u05lCitLkQgNUy/KCunjqSa
	 uEDGvGvRJuD415CxM9cKR8O7Jzd1lDtkUociM34k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 7.2 108/713] usb: typec: tcpci: pass correct rx_type to tcpm_pd_receive()
Date: Fri,  4 Sep 2026 06:51:16 +0200
Message-ID: <20260904045806.256340672@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045803.810145556@linuxfoundation.org>
References: <20260904045803.810145556@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

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
@@ -38,6 +38,7 @@ struct tcpci {
 
 	struct regmap *regmap;
 	unsigned int alert_mask;
+	unsigned int rx_type_mask;
 
 	bool controls_vbus;
 
@@ -488,6 +489,8 @@ static int tcpci_set_pd_rx(struct tcpc_d
 		if (tcpci->data->cable_comm_capable)
 			reg |= TCPC_RX_DETECT_SOP1;
 	}
+
+	tcpci->rx_type_mask = reg;
 	ret = regmap_write(tcpci->regmap, TCPC_RX_DETECT, reg);
 	if (ret < 0)
 		return ret;
@@ -749,6 +752,7 @@ process_status:
 	if (status & TCPC_ALERT_RX_STATUS) {
 		struct pd_message msg;
 		unsigned int cnt, payload_cnt;
+		enum tcpm_transmit_type rx_type;
 		u16 header;
 
 		regmap_read(tcpci->regmap, TCPC_RX_BYTE_CNT, &cnt);
@@ -773,10 +777,16 @@ process_status:
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
 


