Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EA5BE1F7577;
	Tue, 17 Dec 2024 17:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455943; cv=none; b=YwK54fjbr9j8Xx/xqFbmFJPBcFZyDzc3ZXZZx8rtAX4Y+PCN9D74sGtfDxP74J2hrLFpgsKJ3BbcjAkCbTiLoBS9aMmqxul6u7uUkuef47GkGzNIZKdv7GsAguAfmu+ZJF4/0ZZTRlqJlgvXZJQdsEk1sh/ZET3wjMUOnBX6c2U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455943; c=relaxed/simple;
	bh=2FAKj98RKFau3ZF9QCI7FzbvAtU0StcIPL+gTSjfv/Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=qihFOFsfRdKCLnZ8hQjJ1wDh2WicVPdJ2oRAfh6pvVxCpj0jD3uEy1DZ3//yjjKOjNm8f3JO1PqNuwZC24isTgLhH7A9a3XXJr9XnoGOsrUgfqLHqhSrBUxuOgQEnXOPIaXfrGshZ5R12Hyu0Rw1JCCg4LJT7KkkuzMBZDnRu18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CqJm1TVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CqJm1TVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 739B1C4CED3;
	Tue, 17 Dec 2024 17:19:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455942;
	bh=2FAKj98RKFau3ZF9QCI7FzbvAtU0StcIPL+gTSjfv/Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CqJm1TVlw5x9Cfn14hfvc/D2RxavWpkmiJpWr2/4KJaRaDDHqirIqorDOSyL8zcxJ
	 J2jcwFo7NG0MEcPq0KB2rFBczpU1Jjj1wAfWG/CLIQzJAOX+vrtpZ80+M3W8bYIIPb
	 yBcH99i0DBaszGdhAgfWET2r/ij3Ep8DD9cCeTR4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Vladimir Oltean <vladimir.oltean@nxp.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 48/76] net: mscc: ocelot: perform error cleanup in ocelot_hwstamp_set()
Date: Tue, 17 Dec 2024 18:07:28 +0100
Message-ID: <20241217170528.257809720@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170526.232803729@linuxfoundation.org>
References: <20241217170526.232803729@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

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
index bc44aa635d49..34a2d8ea3b2d 100644
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



