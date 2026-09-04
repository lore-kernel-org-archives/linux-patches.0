Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4AAB9372B4B;
	Fri,  4 Sep 2026 05:43:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788500613; cv=none; b=jL1MkML0TVyucL+1z0/H4vZfF8r4bKGUgHBUxeOEk/pbVQX/gkopFD2vAbjgc0P7h+Dqll2w+PpczTLbeg7VZeKeYCa4fsLX8V8MZSGrAYUa4qWD3KH70XLneL//lEM8dEoy+asMK0L8Rm7vU9olNySI6oRHq+qGjNUmq13tGRQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788500613; c=relaxed/simple;
	bh=YSoCzCKAcdtMA+gy8G0K2bfb8oDMpxyiaVprRilmU3c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QA2Mo1ESdx29B7tvgAabNCReQ5qjvyrs1JXI8oKpD4FbbGCl0ofzTXI+p0XVk1rGb1dRhJQXoVI3AtMSIveSVnWsU6Wa4Ctg14azm8B1RKDk6RdsJVcnpcxV4OOWTIZgitTYkt9TcYrM6MX+eTG5Nwu33kgmDQCabduGpR73vCc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RH+tkg+3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RH+tkg+3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D3EC1F00A3D;
	Fri,  4 Sep 2026 05:43:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788500612;
	bh=huXgI5TRq58C5pBbPvx5fqXqq1DvI7DO3rFa5MmnRuY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RH+tkg+3dQ33cZfIROdsHpyFJuPyTvyvVq/7ezffRvpuo2AaVWk/gLCcEkh/aEckO
	 PpSUMqL2wl2bbogSAqjBEscLGRw2uEK5tjB3gPOn50WpU5B7RoeuiAHHtEZP60a1MZ
	 DfdciPrzOBsOZLzHiwMlTF2je3QKNzxiJgm/NPXs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xu Yang <xu.yang_2@nxp.com>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.18 075/552] usb: typec: tcpci: pass correct rx_type to tcpm_pd_receive()
Date: Fri,  4 Sep 2026 06:53:52 +0200
Message-ID: <20260904045749.553821471@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260904045747.813364717@linuxfoundation.org>
References: <20260904045747.813364717@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
@@ -37,6 +37,7 @@ struct tcpci {
 
 	struct regmap *regmap;
 	unsigned int alert_mask;
+	unsigned int rx_type_mask;
 
 	bool controls_vbus;
 
@@ -485,6 +486,8 @@ static int tcpci_set_pd_rx(struct tcpc_d
 		if (tcpci->data->cable_comm_capable)
 			reg |= TCPC_RX_DETECT_SOP1;
 	}
+
+	tcpci->rx_type_mask = reg;
 	ret = regmap_write(tcpci->regmap, TCPC_RX_DETECT, reg);
 	if (ret < 0)
 		return ret;
@@ -746,6 +749,7 @@ process_status:
 	if (status & TCPC_ALERT_RX_STATUS) {
 		struct pd_message msg;
 		unsigned int cnt, payload_cnt;
+		enum tcpm_transmit_type rx_type;
 		u16 header;
 
 		regmap_read(tcpci->regmap, TCPC_RX_BYTE_CNT, &cnt);
@@ -770,10 +774,16 @@ process_status:
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
 


