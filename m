Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 62E051F867C;
	Tue, 17 Dec 2024 17:29:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734456599; cv=none; b=fB3xft26XsDpgflYnyhxH6xoKDxFNMMtKkNenciQKHJgM39C7yk3AuJ7HZDU9FhipF4lH9obg7YP/PFHxDnH6cvddzRHykBNj/M/ohK6mDRYv1gjUWtV6GWzlRJhxKYguAR5sj/6HBeAGoVyycekfaJKkJeIhlI1ppyTbLR541Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734456599; c=relaxed/simple;
	bh=5kKBIaWjW3xZmdFEbcEB6LjNCw2G62FaqIiKrgflLgE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oLllo0IDrr61p5YHZDsDA117TnoOtuuSAo5N4PuMWyyGGgZo+T9iqSIvM1+7pU9pW5c/8WDwne5DQH4aPQ4HBBnmAZ1kRGnY+qD+Jsh5Nc1w3Amvyyz0zcZgkT8i9kIS1UVaKTMIgWob6xOJI+qUPG3KmB/TJNsKe5R4W/uQ85Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g1eEigBE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g1eEigBE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB3C1C4CED3;
	Tue, 17 Dec 2024 17:29:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734456599;
	bh=5kKBIaWjW3xZmdFEbcEB6LjNCw2G62FaqIiKrgflLgE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g1eEigBEH2dDdjdqH8kJ+CgMbxBRNVaHnfnBoLa9NP+oJRFhsmjWjPO0KnvWBLX+h
	 UNWawkxbKHvCh0tQGArvoNfU7a1pGpNUdcZAwCFanSCOxhcJlWCaU2l7mVKvd+AJWB
	 c9QTCGKe8Vyh06CQQr9KW67zmaUEgj7kt4/c+0Eg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 107/172] net: mscc: ocelot: perform error cleanup in ocelot_hwstamp_set()
Date: Tue, 17 Dec 2024 18:07:43 +0100
Message-ID: <20241217170550.764085409@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170546.209657098@linuxfoundation.org>
References: <20241217170546.209657098@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Vladimir Oltean <vladimir.oltean@nxp.com>

[ Upstream commit 43a4166349a254446e7a3db65f721c6a30daccf3 ]

An unsupported RX filter will leave the port with TX timestamping still
applied as per the new request, rather than the old setting. When
parsing the tx_type, don't apply it just yet, but delay that until after
we've parsed the rx_filter as well (and potentially returned -ERANGE for
that).

Similarly, copy_to_user() may fail, which is a rare occurrence, but
should still be treated by unwinding what was done.

Fixes: 96ca08c05838 ("net: mscc: ocelot: set up traps for PTP packets")
Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
Link: https://patch.msgid.link/20241205145519.1236778-6-vladimir.oltean@nxp.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mscc/ocelot_ptp.c | 59 ++++++++++++++++++--------
 1 file changed, 42 insertions(+), 17 deletions(-)

diff --git a/drivers/net/ethernet/mscc/ocelot_ptp.c b/drivers/net/ethernet/mscc/ocelot_ptp.c
index 7eb01d1e1ecd..808ce8e68d39 100644
--- a/drivers/net/ethernet/mscc/ocelot_ptp.c
+++ b/drivers/net/ethernet/mscc/ocelot_ptp.c
@@ -497,6 +497,28 @@ static int ocelot_traps_to_ptp_rx_filter(unsigned int proto)
 	return HWTSTAMP_FILTER_NONE;
 }
 
+static int ocelot_ptp_tx_type_to_cmd(int tx_type, int *ptp_cmd)
+{
+	switch (tx_type) {
+	case HWTSTAMP_TX_ON:
+		*ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
+		break;
+	case HWTSTAMP_TX_ONESTEP_SYNC:
+		/* IFH_REW_OP_ONE_STEP_PTP updates the correctionField,
+		 * what we need to update is the originTimestamp.
+		 */
+		*ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
+		break;
+	case HWTSTAMP_TX_OFF:
+		*ptp_cmd = 0;
+		break;
+	default:
+		return -ERANGE;
+	}
+
+	return 0;
+}
+
 int ocelot_hwstamp_get(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
@@ -523,30 +545,19 @@ EXPORT_SYMBOL(ocelot_hwstamp_get);
 int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 {
 	struct ocelot_port *ocelot_port = ocelot->ports[port];
+	int ptp_cmd, old_ptp_cmd = ocelot_port->ptp_cmd;
 	bool l2 = false, l4 = false;
 	struct hwtstamp_config cfg;
+	bool old_l2, old_l4;
 	int err;
 
 	if (copy_from_user(&cfg, ifr->ifr_data, sizeof(cfg)))
 		return -EFAULT;
 
 	/* Tx type sanity check */
-	switch (cfg.tx_type) {
-	case HWTSTAMP_TX_ON:
-		ocelot_port->ptp_cmd = IFH_REW_OP_TWO_STEP_PTP;
-		break;
-	case HWTSTAMP_TX_ONESTEP_SYNC:
-		/* IFH_REW_OP_ONE_STEP_PTP updates the correctional field, we
-		 * need to update the origin time.
-		 */
-		ocelot_port->ptp_cmd = IFH_REW_OP_ORIGIN_PTP;
-		break;
-	case HWTSTAMP_TX_OFF:
-		ocelot_port->ptp_cmd = 0;
-		break;
-	default:
-		return -ERANGE;
-	}
+	err = ocelot_ptp_tx_type_to_cmd(cfg.tx_type, &ptp_cmd);
+	if (err)
+		return err;
 
 	switch (cfg.rx_filter) {
 	case HWTSTAMP_FILTER_NONE:
@@ -571,13 +582,27 @@ int ocelot_hwstamp_set(struct ocelot *ocelot, int port, struct ifreq *ifr)
 		return -ERANGE;
 	}
 
+	old_l2 = ocelot_port->trap_proto & OCELOT_PROTO_PTP_L2;
+	old_l4 = ocelot_port->trap_proto & OCELOT_PROTO_PTP_L4;
+
 	err = ocelot_setup_ptp_traps(ocelot, port, l2, l4);
 	if (err)
 		return err;
 
+	ocelot_port->ptp_cmd = ptp_cmd;
+
 	cfg.rx_filter = ocelot_traps_to_ptp_rx_filter(ocelot_port->trap_proto);
 
-	return copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg)) ? -EFAULT : 0;
+	if (copy_to_user(ifr->ifr_data, &cfg, sizeof(cfg))) {
+		err = -EFAULT;
+		goto out_restore_ptp_traps;
+	}
+
+	return 0;
+out_restore_ptp_traps:
+	ocelot_setup_ptp_traps(ocelot, port, old_l2, old_l4);
+	ocelot_port->ptp_cmd = old_ptp_cmd;
+	return err;
 }
 EXPORT_SYMBOL(ocelot_hwstamp_set);
 
-- 
2.39.5



