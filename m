Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AE6072D8378;
	Sun,  7 Jun 2026 10:50:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829414; cv=none; b=PsE7y4/QA6RRaKsKvmojMq6wTUGDal/iDZGh9Tbl2XrhUamykXZ+20jFcK5i1ZUTyY57SuxQ+RIMXFLGDhiZlfwu9M9j8qVEVpw/0xjzgYKlMwnG+kS6/oKiV8QeY12/9W5QWBxLOgVt/jQ7XCZypI9Loo8G96g5lFpcCG2o9J8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829414; c=relaxed/simple;
	bh=Ndsuer3yJC2H6Rm3XSiJVk5BCYZtN1JlgtB3E47f9yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m4d9sEZnrBd2CVX1lJK3cMkke4YBFzsqmtNKixqbsThgnr3TDFyTWSkebbfcdmXmY5QpvtqIzJ/iYKYwU8eruGM8xWxNVTOixJmUWL0rAlrqzcTSDg9dSZ+DRECX62Jdpx9Cwanw8FnL6XIqHDLnJiBxTQd+PtuTEk5qw/ZmwLE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jXe0/otj; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jXe0/otj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3B371F00893;
	Sun,  7 Jun 2026 10:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829413;
	bh=wJEV1yIOLq/14U1Gqs02mVQk46R4l+h/XRMjLwrNjfw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jXe0/otjs8uaGaz8X5L33S+4rsxw+J1TQOENi85X+9Lw7MgfiT4wSyPxRWFGtQRMf
	 oB2fHlLvIBaFQ10YIl+9hM+eNgL3VFIpYCmGebeQ8+rJip+xLQEqETXDk3nav2Q0/4
	 u55ZQ8L7xj8ZjbPc+ptPfVxzE1Sio5qqd6/66iR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.12 222/307] usb: typec: tcpm: improve handling of DISCOVER_MODES failures
Date: Sun,  7 Jun 2026 12:00:19 +0200
Message-ID: <20260607095735.864030243@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.647295505@linuxfoundation.org>
References: <20260607095727.647295505@linuxfoundation.org>
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

From: Sebastian Reichel <sebastian.reichel@collabora.com>

commit c06e6cd488194e37ed4dc29d1488d1ffb760de60 upstream.

UGREEN USB-C Multifunction Adapter Model CM512 (AKA "Revodok 107")
exposes two SVIDs: 0xff01 (DP Alt Mode) and 0x1d5c. The DISCOVER_MODES
step succeeds for 0xff01 and gets a NAK for 0x1d5c. Currently this
results in DP Alt Mode not being registered either, since the modes
are only registered once all of them have been discovered. The NAK
results in the processing being stopped and thus no Alt modes being
registered.

Improve the situation by handling the NAK gracefully and continue
processing the other modes.

Before this change, the TCPM log ends like this:

(more log entries before this)
[    5.028287] AMS DISCOVER_SVIDS finished
[    5.028291] cc:=4
[    5.040040] SVID 1: 0xff01
[    5.040054] SVID 2: 0x1d5c
[    5.040082] AMS DISCOVER_MODES start
[    5.040096] PD TX, header: 0x1b6f
[    5.050946] PD TX complete, status: 0
[    5.059609] PD RX, header: 0x264f [1]
[    5.059626] Rx VDM cmd 0xff018043 type 1 cmd 3 len 2
[    5.059640] AMS DISCOVER_MODES finished
[    5.059644] cc:=4
[    5.069994]  Alternate mode 0: SVID 0xff01, VDO 1: 0x000c0045
[    5.070029] AMS DISCOVER_MODES start
[    5.070043] PD TX, header: 0x1d6f
[    5.081139] PD TX complete, status: 0
[    5.087498] PD RX, header: 0x184f [1]
[    5.087515] Rx VDM cmd 0x1d5c8083 type 2 cmd 3 len 1
[    5.087529] AMS DISCOVER_MODES finished
[    5.087534] cc:=4
(no further log entries after this point)

After this patch the TCPM log looks exactly the same, but then
continues like this:

[    5.100222] Skip SVID 0x1d5c (failed to discover mode)
[    5.101699] AMS DFP_TO_UFP_ENTER_MODE start
(log goes on as the system initializes DP AltMode)

Cc: stable <stable@kernel.org>
Fixes: 41d9d75344d9 ("usb: typec: tcpm: add discover svids and discover modes support for sop'")
Reviewed-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Signed-off-by: Sebastian Reichel <sebastian.reichel@collabora.com>
Reviewed-by: RD Babiera <rdbabiera@google.com>
Reviewed-by: Badhri Jagan Sridharan <badhri@google.com>
Link: https://patch.msgid.link/20260429-tcpm-discover-modes-nak-fix-v4-1-75945d0ed30f@collabora.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/usb/typec/tcpm/tcpm.c |   97 ++++++++++++++++++++++++++----------------
 1 file changed, 61 insertions(+), 36 deletions(-)

--- a/drivers/usb/typec/tcpm/tcpm.c
+++ b/drivers/usb/typec/tcpm/tcpm.c
@@ -1933,6 +1933,55 @@ static bool tcpm_cable_vdm_supported(str
 	       tcpm_can_communicate_sop_prime(port);
 }
 
+static int tcpm_handle_discover_mode(struct tcpm_port *port, u32 *response,
+				     enum tcpm_transmit_type rx_sop_type,
+				     enum tcpm_transmit_type *response_tx_sop_type)
+{
+	struct typec_port *typec = port->typec_port;
+	struct pd_mode_data *modep;
+
+	if (rx_sop_type == TCPC_TX_SOP) {
+		modep = &port->mode_data;
+		modep->svid_index++;
+
+		if (modep->svid_index < modep->nsvids) {
+			u16 svid = modep->svids[modep->svid_index];
+			*response_tx_sop_type = TCPC_TX_SOP;
+			response[0] = VDO(svid, 1,
+					  typec_get_negotiated_svdm_version(typec),
+					  CMD_DISCOVER_MODES);
+			return 1;
+		}
+
+		if (tcpm_cable_vdm_supported(port)) {
+			*response_tx_sop_type = TCPC_TX_SOP_PRIME;
+			response[0] = VDO(USB_SID_PD, 1,
+					  typec_get_cable_svdm_version(typec),
+					  CMD_DISCOVER_SVID);
+			return 1;
+		}
+
+		tcpm_register_partner_altmodes(port);
+	} else if (rx_sop_type == TCPC_TX_SOP_PRIME) {
+		modep = &port->mode_data_prime;
+		modep->svid_index++;
+
+		if (modep->svid_index < modep->nsvids) {
+			u16 svid = modep->svids[modep->svid_index];
+			*response_tx_sop_type = TCPC_TX_SOP_PRIME;
+			response[0] = VDO(svid, 1,
+					  typec_get_cable_svdm_version(typec),
+					  CMD_DISCOVER_MODES);
+			return 1;
+		}
+
+		tcpm_register_plug_altmodes(port);
+		tcpm_register_partner_altmodes(port);
+	}
+
+	return 0;
+}
+
 static int tcpm_pd_svdm(struct tcpm_port *port, struct typec_altmode *adev,
 			const u32 *p, int cnt, u32 *response,
 			enum adev_actions *adev_action,
@@ -2190,41 +2239,11 @@ static int tcpm_pd_svdm(struct tcpm_port
 			}
 			break;
 		case CMD_DISCOVER_MODES:
-			if (rx_sop_type == TCPC_TX_SOP) {
-				/* 6.4.4.3.3 */
-				svdm_consume_modes(port, p, cnt, rx_sop_type);
-				modep->svid_index++;
-				if (modep->svid_index < modep->nsvids) {
-					u16 svid = modep->svids[modep->svid_index];
-					*response_tx_sop_type = TCPC_TX_SOP;
-					response[0] = VDO(svid, 1, svdm_version,
-							  CMD_DISCOVER_MODES);
-					rlen = 1;
-				} else if (tcpm_cable_vdm_supported(port)) {
-					*response_tx_sop_type = TCPC_TX_SOP_PRIME;
-					response[0] = VDO(USB_SID_PD, 1,
-							  typec_get_cable_svdm_version(typec),
-							  CMD_DISCOVER_SVID);
-					rlen = 1;
-				} else {
-					tcpm_register_partner_altmodes(port);
-				}
-			} else if (rx_sop_type == TCPC_TX_SOP_PRIME) {
-				/* 6.4.4.3.3 */
-				svdm_consume_modes(port, p, cnt, rx_sop_type);
-				modep_prime->svid_index++;
-				if (modep_prime->svid_index < modep_prime->nsvids) {
-					u16 svid = modep_prime->svids[modep_prime->svid_index];
-					*response_tx_sop_type = TCPC_TX_SOP_PRIME;
-					response[0] = VDO(svid, 1,
-							  typec_get_cable_svdm_version(typec),
-							  CMD_DISCOVER_MODES);
-					rlen = 1;
-				} else {
-					tcpm_register_plug_altmodes(port);
-					tcpm_register_partner_altmodes(port);
-				}
-			}
+			/* 6.4.4.3.3 */
+			svdm_consume_modes(port, p, cnt, rx_sop_type);
+			rlen = tcpm_handle_discover_mode(port, response,
+							 rx_sop_type,
+							 response_tx_sop_type);
 			break;
 		case CMD_ENTER_MODE:
 			*response_tx_sop_type = rx_sop_type;
@@ -2267,9 +2286,15 @@ static int tcpm_pd_svdm(struct tcpm_port
 		switch (cmd) {
 		case CMD_DISCOVER_IDENT:
 		case CMD_DISCOVER_SVID:
-		case CMD_DISCOVER_MODES:
 		case VDO_CMD_VENDOR(0) ... VDO_CMD_VENDOR(15):
 			break;
+		case CMD_DISCOVER_MODES:
+			tcpm_log(port, "Skip SVID 0x%04x (failed to discover mode)",
+				 PD_VDO_SVID_SVID0(p[0]));
+			rlen = tcpm_handle_discover_mode(port, response,
+							 rx_sop_type,
+							 response_tx_sop_type);
+			break;
 		case CMD_ENTER_MODE:
 			/* Back to USB Operation */
 			*adev_action = ADEV_NOTIFY_USB_AND_QUEUE_VDM;


