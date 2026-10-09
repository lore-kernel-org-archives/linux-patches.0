Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5B0543AC0E7;
	Fri,  9 Oct 2026 14:26:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555995; cv=none; b=GM8ceiOXeDWNQ2fIAq5PNkIDKORExvxda6Lgg1F68SV+0Aa0hRKsoSE5t9YbsaV3kMOR+cy0RJOsLD+eDUJZBYaKYFgTQTV+nTEOuArJ+fQRRkDUBxmRjYLWjTBUT89onXBLyaM2+joDOZnpfHNr49hBBCWP7FerTeqFiHS87ZY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555995; c=relaxed/simple;
	bh=dOIDobhFKtpBXalW4g6JHQ/WFy1Tqx1VBqJ30NxqHFg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMavPWRoKglR0oFADd6WJebqFJmnJdTc0seLMnf/sozT2MUq5v/SOORSq0ba9Yei0Ydts/iDmSbaVFY9v1GkwDG/LwsLVAjHLFayComqSMis1wf09OZglEULATgcHwFJJVR7/s0gUINzuR/mdFWscMFJErMnJahcyyegV8ag5sU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P2m9QUcz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P2m9QUcz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B86D81F000FF;
	Fri,  9 Oct 2026 14:26:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555994;
	bh=zV7GBH70EHF9DqTzj8BTzRC+KomRiwM4GezV178U2Is=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P2m9QUcz2lxk6UZxcQZLrknEAt6S8/d+NpfFaXQT67dyJs9WKPcSt/Ut5cF2Jh8lQ
	 zKsFqetQtI7+yZVkR9JUfCE3VHIEp53LSiHpdxH0GScbdPzSvs3w9GDRtREigIMmwy
	 4+k9ackmixyZEBTDcLTrzFzou/ZD8MTCyozdiX34=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 113/403] net: sparx5: move netdev and notifier block registration to probe
Date: Fri,  9 Oct 2026 16:07:54 +0200
Message-ID: <20261009140954.722998215@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Daniel Machon <daniel.machon@microchip.com>

[ Upstream commit b8909aad5b8de0e2d7e27c0246119eb07f0caa3b ]

Move netdev registration and notifier block registration from
sparx5_start() to probe(). This allows proper cleanup via goto-based
error labels in probe().

Also, remove the sparx5_cleanup_ports() helper as its functionality is now
split between sparx5_unregister_netdevs() and sparx5_destroy_netdevs()
called at appropriate points.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260227-sparx5-init-deinit-v2-1-10ba54ccf005@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0d2c49915bc3 ("net: sparx5: skip ptp deinit if init was skipped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   | 41 ++++++++++---------
 1 file changed, 21 insertions(+), 20 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 40b1bfc600a79..6bd0f43ef275c 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -771,20 +771,11 @@ static int sparx5_start(struct sparx5 *sparx5)
 	mutex_init(&sparx5->mdb_lock);
 	INIT_LIST_HEAD(&sparx5->mdb_entries);
 
-	err = sparx5_register_netdevs(sparx5);
-	if (err)
-		return err;
-
 	sparx5_board_init(sparx5);
-	err = sparx5_register_notifier_blocks(sparx5);
-	if (err)
-		return err;
 
 	err = sparx5_vcap_init(sparx5);
-	if (err) {
-		sparx5_unregister_notifier_blocks(sparx5);
+	if (err)
 		return err;
-	}
 
 	/* Start Frame DMA with fallback to register based INJ/XTR */
 	err = -ENXIO;
@@ -833,12 +824,6 @@ static int sparx5_start(struct sparx5 *sparx5)
 	return err;
 }
 
-static void sparx5_cleanup_ports(struct sparx5 *sparx5)
-{
-	sparx5_unregister_netdevs(sparx5);
-	sparx5_destroy_netdevs(sparx5);
-}
-
 static int mchp_sparx5_probe(struct platform_device *pdev)
 {
 	struct initial_port_config *configs, *config;
@@ -1018,10 +1003,26 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&sparx5->mall_entries);
 
+	err = sparx5_register_netdevs(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "Failed to register net devices\n");
+		goto cleanup_ptp;
+	}
+
+	err = sparx5_register_notifier_blocks(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "Failed to register notifier blocks\n");
+		goto cleanup_netdevs;
+	}
+
 	goto cleanup_config;
 
+cleanup_netdevs:
+	sparx5_unregister_netdevs(sparx5);
+cleanup_ptp:
+	sparx5_ptp_deinit(sparx5);
 cleanup_ports:
-	sparx5_cleanup_ports(sparx5);
+	sparx5_destroy_netdevs(sparx5);
 	if (sparx5->mact_queue)
 		destroy_workqueue(sparx5->mact_queue);
 cleanup_config:
@@ -1045,12 +1046,12 @@ static void mchp_sparx5_remove(struct platform_device *pdev)
 		disable_irq(sparx5->fdma_irq);
 		sparx5->fdma_irq = -ENXIO;
 	}
+	sparx5_unregister_notifier_blocks(sparx5);
+	sparx5_unregister_netdevs(sparx5);
 	sparx5_ptp_deinit(sparx5);
 	ops->fdma_deinit(sparx5);
-	sparx5_cleanup_ports(sparx5);
 	sparx5_vcap_destroy(sparx5);
-	/* Unregister netdevs */
-	sparx5_unregister_notifier_blocks(sparx5);
+	sparx5_destroy_netdevs(sparx5);
 	destroy_workqueue(sparx5->mact_queue);
 }
 
-- 
2.53.0



