Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 06A772DFF04;
	Sun,  7 Jun 2026 10:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780829274; cv=none; b=CR0udc89tVQAGlgZ1VD8pjTMvSt1qxuj91tUs9alab8fAOnX9CGr8ZyVBHAGNPaWAzLCBrFEwr0BwkrxKwVwAJ0o+sM0U9sVgzCpzLqrQooxlLQSaxwgo7ANjelHYNuklX1sRufKk6MeDPDY8f604N/qLNy8N9WSjWr4Ifks1ls=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780829274; c=relaxed/simple;
	bh=TRFc29/XLG8EH8IkUpGkUtoLL2R+8X8sq+Gm0MI0V18=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=X2hfguladc35QkxAhQwMolUo3b4/vvlisr2nRJ0ygGcuLrzCSM7aNUUNyablW/R28RDnnNH82KbmdVFZ4YHVSYtQsPdhI/38F6J3uXFtIUNXLH6cv7hiOpyV3aVbc28JEMnqOgGItroRbCydLVDRWaTpIc1vedrzE5XXesCci00=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hdQCnjrf; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hdQCnjrf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 029901F00893;
	Sun,  7 Jun 2026 10:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780829272;
	bh=yAudjAlSG5EDwk0ALjRsD24jh5o2xP7bbPdwStDvI6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hdQCnjrfsV+Bbpv0g6lfFPVf+6298NIx5Fk+cgdOmPHrgtjmW4dIe1QUbyP9VC94+
	 NN0dHVAmNGNEUfEWYVnrz/aRc502b0HW3CzcUoalY/6yCfaXsj+RidhXtG3vNcs9PY
	 1ZFd8S29VovknS1BDngphc6RYviMK5I0rxBY6nOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	Heikki Krogerus <heikki.krogerus@linux.intel.com>,
	Sebastian Reichel <sebastian.reichel@collabora.com>,
	RD Babiera <rdbabiera@google.com>,
	Badhri Jagan Sridharan <badhri@google.com>
Subject: [PATCH 6.18 231/315] usb: typec: tcpm: improve handling of DISCOVER_MODES failures
Date: Sun,  7 Jun 2026 12:00:18 +0200
Message-ID: <20260607095736.057922553@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260607095727.528828913@linuxfoundation.org>
References: <20260607095727.528828913@linuxfoundation.org>
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
@@ -1989,6 +1989,55 @@ static bool tcpm_cable_vdm_supported(str
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
@@ -2246,41 +2295,11 @@ static int tcpm_pd_svdm(struct tcpm_port
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
@@ -2323,9 +2342,15 @@ static int tcpm_pd_svdm(struct tcpm_port
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


