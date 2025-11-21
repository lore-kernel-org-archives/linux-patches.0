Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3B2EE2737FC;
	Fri, 21 Nov 2025 13:28:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1763731715; cv=none; b=mOWn2R+thpPY0Q7eeFYOhEgQ1j40sA4epQXNEqtRn+UqKV86TVBfO2eByvVrHQ0YRT1svqMvZJY3YG0hBXi0Upja8Hg3e0MPOSf3PzArW5u3y3XFUw9Eexqg28nib+cx5lIHRHXA7H3q9qefxKbbCsgS3tzS79ecKCF9o0INcTA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1763731715; c=relaxed/simple;
	bh=rO+tCPNdNuA4qm5Wtz6AdNX4r4rDBfFSxdO7nnzR6oc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ehrvRa2xGM8lIJMZhFV8x3FLMIGxOJCoJgETDKYfwPFBs4NE3IE1vzbvcaAiMXbBAZ96lLeWN4370rHcGSVUBm3yhHHQ9/7ySZkrOSnPhum14PHlwkOJmr0pKyJb3x6I10yogHSl6nP2Blu39NRi7Mo+3w4MnlRkBhiPQlHt1Ug=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TvF2z27U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TvF2z27U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC6ACC4CEF1;
	Fri, 21 Nov 2025 13:28:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1763731715;
	bh=rO+tCPNdNuA4qm5Wtz6AdNX4r4rDBfFSxdO7nnzR6oc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TvF2z27U1YL558jcxXFQIeNCoOcXD3OQEB8en4tfDCzmeV4auCnsdfdJkz74JiVud
	 Zv0Io55CK4ASKQsDFCW9Zk3MtY3O6SDYvp7AnZqRWPSyvPfJ+NLKaWE/LOWuNi0p51
	 EpUnQI2oU1a9VubzeZjsuX1QcZVYm4+W0StIAoFc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aksh Garg <a-garg7@ti.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 048/185] net: ethernet: ti: am65-cpsw-qos: fix IET verify retry mechanism
Date: Fri, 21 Nov 2025 14:11:15 +0100
Message-ID: <20251121130145.612624829@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251121130143.857798067@linuxfoundation.org>
References: <20251121130143.857798067@linuxfoundation.org>
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

From: Aksh Garg <a-garg7@ti.com>

[ Upstream commit d4b00d132d7cb70a74bc039c91c1d6120943c71b ]

The am65_cpsw_iet_verify_wait() function attempts verification 20 times,
toggling the AM65_CPSW_PN_IET_MAC_LINKFAIL bit in each iteration. When
the LINKFAIL bit transitions from 1 to 0, the MAC merge layer initiates
the verification process and waits for the timeout configured in
MAC_VERIFY_CNT before automatically retransmitting. The MAC_VERIFY_CNT
register is configured according to the user-defined verify/response
timeout in am65_cpsw_iet_set_verify_timeout_count(). As per IEEE 802.3
Clause 99, the hardware performs this automatic retry up to 3 times.

Current implementation toggles LINKFAIL after the user-configured
verify/response timeout in each iteration, forcing the hardware to
restart verification instead of respecting the MAC_VERIFY_CNT timeout.
This bypasses the hardware's automatic retry mechanism.

Fix this by moving the LINKFAIL bit toggle outside the retry loop and
reducing the retry count from 20 to 3. The software now only monitors
the status register while the hardware autonomously handles the 3
verification attempts at proper MAC_VERIFY_CNT intervals.

Fixes: 49a2eb9068246 ("net: ethernet: ti: am65-cpsw-qos: Add Frame Preemption MAC Merge support")
Signed-off-by: Aksh Garg <a-garg7@ti.com>
Link: https://patch.msgid.link/20251106092305.1437347-3-a-garg7@ti.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-qos.c | 27 +++++++++++++------------
 1 file changed, 14 insertions(+), 13 deletions(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-qos.c b/drivers/net/ethernet/ti/am65-cpsw-qos.c
index ad06942ce461a..66e8b224827b6 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-qos.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-qos.c
@@ -317,20 +317,21 @@ static int am65_cpsw_iet_verify_wait(struct am65_cpsw_port *port)
 	u32 ctrl, status;
 	int try;
 
-	try = 20;
-	do {
-		/* Reset the verify state machine by writing 1
-		 * to LINKFAIL
-		 */
-		ctrl = readl(port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
-		ctrl |= AM65_CPSW_PN_IET_MAC_LINKFAIL;
-		writel(ctrl, port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
+	try = 3;
 
-		/* Clear MAC_LINKFAIL bit to start Verify. */
-		ctrl = readl(port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
-		ctrl &= ~AM65_CPSW_PN_IET_MAC_LINKFAIL;
-		writel(ctrl, port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
+	/* Reset the verify state machine by writing 1
+	 * to LINKFAIL
+	 */
+	ctrl = readl(port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
+	ctrl |= AM65_CPSW_PN_IET_MAC_LINKFAIL;
+	writel(ctrl, port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
 
+	/* Clear MAC_LINKFAIL bit to start Verify. */
+	ctrl = readl(port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
+	ctrl &= ~AM65_CPSW_PN_IET_MAC_LINKFAIL;
+	writel(ctrl, port->port_base + AM65_CPSW_PN_REG_IET_CTRL);
+
+	do {
 		msleep(port->qos.iet.verify_time_ms);
 
 		status = readl(port->port_base + AM65_CPSW_PN_REG_IET_STATUS);
@@ -352,7 +353,7 @@ static int am65_cpsw_iet_verify_wait(struct am65_cpsw_port *port)
 			netdev_dbg(port->ndev, "MAC Merge verify error\n");
 			return -ENODEV;
 		}
-	} while (try-- > 0);
+	} while (--try > 0);
 
 	netdev_dbg(port->ndev, "MAC Merge verify timeout\n");
 	return -ETIMEDOUT;
-- 
2.51.0



