Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E994D4E4C5E;
	Fri,  9 Oct 2026 14:22:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791555782; cv=none; b=DRxHbUD/5OOxUQdstdNMgAAUPKtHe1pN1I+j2t3UwJNAtBAOTosZX/JGXkwxpDkufc65TvEZU3D34j4vk4xXV9cdpIPdVI9PeuarpWCM0gUteoRN3Kijgc3G05VTi0dsITPJRv0oxfCR63JtQQMJY3quSgPHH8IJmpkNOKXPUQ0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791555782; c=relaxed/simple;
	bh=vmgjaW6TZpPLu8PObVvWWu2cd0fFFiE9LNK820nzDOk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sK4mB08uwrU279oBvQybaRNK/6BLveueUdYx+FlYh7DoGdIhJSvyMoeLoqO+wLHbhf72IpSU6g1fLAImGeHMDum51n1Xn9K3fJakapJ8eTFlP+Ezk1plmxZXI+e57F84hD7H00lpRJrfBtxtoujPr1ti0vvGln0f7aT+bJqD000=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e4IUU+VO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e4IUU+VO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3B3B61F000FF;
	Fri,  9 Oct 2026 14:22:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791555779;
	bh=ovD7bIFSyWkJSbLJXP0DUmfqE7VuNHWEwhk6Zi8BWXQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e4IUU+VOHL8aF0cB9T+l/xWgwbXU6kIfHdcFYuABpLyHRIeWjdGJGal9xUgNg5DzM
	 doDOlMKvokhD/YUUOL0SlKH3Tw34JDCOxhfY99yu/Pd6PrY28cVwKj5WRbIG0BRTdk
	 ntdmZoxo5kVwwc+ZFc1I1WtMG30D3XQzUWd0dkXA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Machon <daniel.machon@microchip.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 117/403] net: sparx5: move PTP IRQ handling out of sparx5_start()
Date: Fri,  9 Oct 2026 16:07:58 +0200
Message-ID: <20261009140954.816114370@linuxfoundation.org>
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

[ Upstream commit 0432c60112b4fe3ebaf5c2c6bd859b9666233a03 ]

Move the PTP IRQ request into sparx5_ptp_init() so all PTP setup is
done in one place.

Also move the sparx5_ptp_init() call to right before
sparx5_register_netdevs() and add a cleanup_ptp label. Update remove()
to disable the PTP IRQ and reorder ptp_deinit accordingly.

Signed-off-by: Daniel Machon <daniel.machon@microchip.com>
Link: https://patch.msgid.link/20260227-sparx5-init-deinit-v2-7-10ba54ccf005@microchip.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Stable-dep-of: 0d2c49915bc3 ("net: sparx5: skip ptp deinit if init was skipped")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../ethernet/microchip/sparx5/sparx5_main.c   | 34 ++++++-------------
 .../ethernet/microchip/sparx5/sparx5_ptp.c    | 18 ++++++++++
 2 files changed, 29 insertions(+), 23 deletions(-)

diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
index 4ebcc4f127a5b..f201cb6c587a7 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_main.c
@@ -775,18 +775,6 @@ static int sparx5_start(struct sparx5 *sparx5)
 		sparx5->xtr_irq = -ENXIO;
 	}
 
-	if (sparx5->ptp_irq >= 0 &&
-	    sparx5_has_feature(sparx5, SPX5_FEATURE_PTP)) {
-		err = devm_request_threaded_irq(sparx5->dev, sparx5->ptp_irq,
-						NULL, ops->ptp_irq_handler,
-						IRQF_ONESHOT, "sparx5-ptp",
-						sparx5);
-		if (err)
-			sparx5->ptp_irq = -ENXIO;
-
-		sparx5->ptp = 1;
-	}
-
 	return err;
 }
 
@@ -961,16 +949,10 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 		goto cleanup_ports;
 	}
 
-	err = sparx5_ptp_init(sparx5);
-	if (err) {
-		dev_err(sparx5->dev, "PTP failed\n");
-		goto cleanup_ports;
-	}
-
 	err = sparx5_vcap_init(sparx5);
 	if (err) {
 		dev_err(sparx5->dev, "Failed to initialize VCAP\n");
-		goto cleanup_ptp;
+		goto cleanup_ports;
 	}
 
 	err = sparx5_mact_init(sparx5);
@@ -987,10 +969,16 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 	INIT_LIST_HEAD(&sparx5->mall_entries);
 
+	err = sparx5_ptp_init(sparx5);
+	if (err) {
+		dev_err(sparx5->dev, "Failed to initialize PTP\n");
+		goto cleanup_stats;
+	}
+
 	err = sparx5_register_netdevs(sparx5);
 	if (err) {
 		dev_err(sparx5->dev, "Failed to register net devices\n");
-		goto cleanup_stats;
+		goto cleanup_ptp;
 	}
 
 	err = sparx5_register_notifier_blocks(sparx5);
@@ -1003,14 +991,14 @@ static int mchp_sparx5_probe(struct platform_device *pdev)
 
 cleanup_netdevs:
 	sparx5_unregister_netdevs(sparx5);
+cleanup_ptp:
+	sparx5_ptp_deinit(sparx5);
 cleanup_stats:
 	sparx5_stats_deinit(sparx5);
 cleanup_mact:
 	sparx5_mact_deinit(sparx5);
 cleanup_vcap:
 	sparx5_vcap_deinit(sparx5);
-cleanup_ptp:
-	sparx5_ptp_deinit(sparx5);
 cleanup_ports:
 	sparx5_destroy_netdevs(sparx5);
 cleanup_config:
@@ -1036,10 +1024,10 @@ static void mchp_sparx5_remove(struct platform_device *pdev)
 	}
 	sparx5_unregister_notifier_blocks(sparx5);
 	sparx5_unregister_netdevs(sparx5);
+	sparx5_ptp_deinit(sparx5);
 	sparx5_stats_deinit(sparx5);
 	sparx5_mact_deinit(sparx5);
 	sparx5_vcap_deinit(sparx5);
-	sparx5_ptp_deinit(sparx5);
 	ops->fdma_deinit(sparx5);
 	sparx5_destroy_netdevs(sparx5);
 }
diff --git a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
index 8b2e07821a950..a16ec8136d6d6 100644
--- a/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
+++ b/drivers/net/ethernet/microchip/sparx5/sparx5_ptp.c
@@ -606,9 +606,22 @@ static int sparx5_ptp_phc_init(struct sparx5 *sparx5,
 int sparx5_ptp_init(struct sparx5 *sparx5)
 {
 	u64 tod_adj = sparx5_ptp_get_nominal_value(sparx5);
+	const struct sparx5_ops *ops = sparx5->data->ops;
 	struct sparx5_port *port;
 	int err, i;
 
+	if (sparx5->ptp_irq >= 0 &&
+	    sparx5_has_feature(sparx5, SPX5_FEATURE_PTP)) {
+		err = devm_request_threaded_irq(sparx5->dev, sparx5->ptp_irq,
+						NULL, ops->ptp_irq_handler,
+						IRQF_ONESHOT, "sparx5-ptp",
+						sparx5);
+		if (err)
+			sparx5->ptp_irq = -ENXIO;
+
+		sparx5->ptp = 1;
+	}
+
 	if (!sparx5->ptp)
 		return 0;
 
@@ -660,6 +673,11 @@ void sparx5_ptp_deinit(struct sparx5 *sparx5)
 	struct sparx5_port *port;
 	int i;
 
+	if (sparx5->ptp_irq >= 0) {
+		disable_irq(sparx5->ptp_irq);
+		sparx5->ptp_irq = -ENXIO;
+	}
+
 	for (i = 0; i < sparx5->data->consts->n_ports; i++) {
 		port = sparx5->ports[i];
 		if (!port)
-- 
2.53.0



