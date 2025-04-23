Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 124C42820BC;
	Wed, 23 Apr 2025 14:48:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745419721; cv=none; b=Qrl3KRFP9xsOff99ch72Fx1Jc89YWyQX0BJKHpk43e6w3BF5QXBZmZjw3AQI+wM9AG/DtojrH/zj+2UO94D7H17fEQx8HU3DgDOHTOc7E0s7PW7U0a86AUIE+0owZENIhDnKT2A51CBeerl+cpfWYML3g94NbZ0rQQuDPSVAAb0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745419721; c=relaxed/simple;
	bh=f9gfa4fQfoLYeEUcqzLAMBS2TEE48HXwYxv0EEqZdmk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=s1pU4VkO6WxBOwpk4J8O6ApVx7WpFCDz/gZGkkIi182JnBO2ZvXproXKixyYfH9r83+BaDye++FTOkatZM4lOv4Exo2mb3tKsnlV+FahBQShnZLHmYK1fP+EjgXhznc9wygPfHBj4LLm5KfTYw3ZXeq2XKiucf7OyjhDYzlTp6A=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LA6SfLvA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LA6SfLvA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 930AAC4CEE2;
	Wed, 23 Apr 2025 14:48:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745419720;
	bh=f9gfa4fQfoLYeEUcqzLAMBS2TEE48HXwYxv0EEqZdmk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LA6SfLvAkHDrjpPo75xz7sgHUB7vqANZ1Yf+JKLM06Ui1rbb3zcr7Z9Xhh4cH0EsW
	 q+f/tMaq3D+uLio4aZsKDx8jENTS5XBd83VL26z0haceIKs1SsvI06uRB+D/4njaI3
	 G8KlqhIhNWs5HV5/DqJOaSloCZi/i5Ye3VZ9ebpc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michael Walle <mwalle@kernel.org>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/223] net: ethernet: ti: am65-cpsw: fix port_np reference counting
Date: Wed, 23 Apr 2025 16:42:02 +0200
Message-ID: <20250423142619.172532772@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit 903d2b9f9efc5b3339d74015fcfc0d9fff276c4c ]

A reference to the device tree node is stored in a private struct, thus
the reference count has to be incremented. Also, decrement the count on
device removal and in the error path.

Fixes: 93a76530316a ("net: ethernet: ti: introduce am65x/j721e gigabit eth subsystem driver")
Signed-off-by: Michael Walle <mwalle@kernel.org>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20250414083942.4015060-1-mwalle@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/ti/am65-cpsw-nuss.c | 15 ++++++++++++++-
 1 file changed, 14 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/ti/am65-cpsw-nuss.c b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
index 308a2b72a65de..a21e7c0afbfdc 100644
--- a/drivers/net/ethernet/ti/am65-cpsw-nuss.c
+++ b/drivers/net/ethernet/ti/am65-cpsw-nuss.c
@@ -2680,7 +2680,7 @@ static int am65_cpsw_nuss_init_slave_ports(struct am65_cpsw_common *common)
 				of_property_read_bool(port_np, "ti,mac-only");
 
 		/* get phy/link info */
-		port->slave.port_np = port_np;
+		port->slave.port_np = of_node_get(port_np);
 		ret = of_get_phy_mode(port_np, &port->slave.phy_if);
 		if (ret) {
 			dev_err(dev, "%pOF read phy-mode err %d\n",
@@ -2741,6 +2741,17 @@ static void am65_cpsw_nuss_phylink_cleanup(struct am65_cpsw_common *common)
 	}
 }
 
+static void am65_cpsw_remove_dt(struct am65_cpsw_common *common)
+{
+	struct am65_cpsw_port *port;
+	int i;
+
+	for (i = 0; i < common->port_num; i++) {
+		port = &common->ports[i];
+		of_node_put(port->slave.port_np);
+	}
+}
+
 static int
 am65_cpsw_nuss_init_port_ndev(struct am65_cpsw_common *common, u32 port_idx)
 {
@@ -3647,6 +3658,7 @@ static int am65_cpsw_nuss_probe(struct platform_device *pdev)
 	am65_cpsw_nuss_cleanup_ndev(common);
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
+	am65_cpsw_remove_dt(common);
 err_of_clear:
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
@@ -3686,6 +3698,7 @@ static void am65_cpsw_nuss_remove(struct platform_device *pdev)
 	am65_cpsw_nuss_phylink_cleanup(common);
 	am65_cpts_release(common->cpts);
 	am65_cpsw_disable_serdes_phy(common);
+	am65_cpsw_remove_dt(common);
 
 	if (common->mdio_dev)
 		of_platform_device_destroy(common->mdio_dev, NULL);
-- 
2.39.5



