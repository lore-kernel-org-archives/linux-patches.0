Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 486774F404B;
	Tue, 13 Oct 2026 11:57:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892673; cv=none; b=RuNk0hASYuwzPuLAt41r99m7OQTzexao5DiZPrsjob7ZY733meBXVknf8kVEBiwiFCRzk6tBdNU5Hi+8MH0ArwwTwvQa7tkhpTkSx2igBFBMWKxYtkvrk+L6jrITj87DMnwMltmECF/Q1QkhuFDSZGl4STlNWfyIVal61RRUnOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892673; c=relaxed/simple;
	bh=Av4UX5mvIjO28QWwBcGVxFKBjrokUwCI0msOGz9GmwA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TYLixF+nitHiY8wMxsvb3Et7JjLK54NLnhWKM6Nq+NH2SYE3l8TfW9PWkdgXZWwUnlUhq8ZplQsgF4tF0+gHlLur3952fDUuAGyF+UdrZPx2xWU7DYcbUGkxajzGE31LkCZoMQfYKz4L2dNSf59uvEoWjYTot/uGfrHR26gDKuc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FHZtqO1e; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FHZtqO1e"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A23F11F000FF;
	Tue, 13 Oct 2026 11:57:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892672;
	bh=yNMm81KJ3YWP8nyzBTAe9loyOHbNeFOMMOhaRJUWDOY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FHZtqO1eyhUShWZc4pfmP7mPDQvrXKq+kwX4nR1ZwMonduAJEwoJ+0vP0BEBGv6mO
	 lEnoF17MYymfpJ+NO/kHk8J3n97Y7P2CFpn4QUdYrhyXFZ7OKnrglpmnWYWqPovjwo
	 Jr884fWiM3kKTYzOdyy+UTh83lATG5FeKJAg0VTI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Quentin Freimanis <quentin@q-lab.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 250/281] net: sparx5: start the TOD counters on non-PTP lan969x variants
Date: Tue, 13 Oct 2026 13:39:26 +0200
Message-ID: <20261013112901.211614429@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

From: Quentin Freimanis <quentin@q-lab.dev>

[ Upstream commit ca5012757bf027df83d51593a07656cb8c80caee ]

Currently the base non-PTP-capable lan969x variants don't forward any
Ethernet frames:

  $ ip link set eth10 up

  $ ip addr add 10.0.0.54/24 dev eth10

  $ ping 10.0.0.1
  PING 10.0.0.1 (10.0.0.1): 56 data bytes

  --- 10.0.0.1 ping statistics ---
  7 packets transmitted, 0 packets received, 100% packet loss

  $ cat /proc/interrupts | grep fdma
    20:          0  GIC-0  120 Level     sparx5-fdma

  $ ip -s link show dev eth10
      RX:  bytes packets errors dropped  missed   mcast
           20828     102      0       0       0      72
      TX:  bytes packets errors dropped carrier collsns
               0       0      0       0       0       0

Testing showed that starting the domain 0 TOD counter gets networking
working again, but start all three for consistency with the PTP variants.

Fixes: 207966787b71 ("net: sparx5: add feature support")
Suggested-by: Daniel Machon <daniel.machon@microchip.com>
Signed-off-by: Quentin Freimanis <quentin@q-lab.dev>
Reviewed-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20261005052826.14251-1-quentin@q-lab.dev
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 28 +++++++++++--------
 1 file changed, 16 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 5953e04ef14e6..2826e48af1033 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -622,18 +622,9 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 		sparx5->ptp = 1;
 	}
 
-	if (!sparx5->ptp)
-		return 0;
-
-	for (i = 0; i < SPARX5_PHC_COUNT; ++i) {
-		err = sparx5_ptp_phc_init(sparx5, i, &sparx5_ptp_clock_info);
-		if (err)
-			return err;
-	}
-
-	spin_lock_init(&sparx5->ptp_clock_lock);
-	spin_lock_init(&sparx5->ptp_ts_id_lock);
-	mutex_init(&sparx5->ptp_lock);
+	/* The base, non-PTP-capable lan969x variants need the
+	 * first TOD counter running to forward frames.
+	 */
 
 	/* Disable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0), sparx5, PTP_PTP_DOM_CFG);
@@ -657,6 +648,19 @@ int sparx5_ptp_init(struct sparx5 *sparx5)
 	/* Enable master counters */
 	spx5_wr(PTP_PTP_DOM_CFG_PTP_ENA_SET(0x7), sparx5, PTP_PTP_DOM_CFG);
 
+	if (!sparx5->ptp)
+		return 0;
+
+	for (i = 0; i < SPARX5_PHC_COUNT; ++i) {
+		err = sparx5_ptp_phc_init(sparx5, i, &sparx5_ptp_clock_info);
+		if (err)
+			return err;
+	}
+
+	spin_lock_init(&sparx5->ptp_clock_lock);
+	spin_lock_init(&sparx5->ptp_ts_id_lock);
+	mutex_init(&sparx5->ptp_lock);
+
 	for (i = 0; i < sparx5->data->consts->n_ports; i++) {
 		port = sparx5->ports[i];
 		if (!port)
-- 
2.53.0



