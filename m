Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 074AC397AD8;
	Wed, 21 Jan 2026 18:25:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769019928; cv=none; b=LeI2dw7qowDJx9iKaR5D35sk/IEB7UISk56IJgqLQJEasbr0ufjmkSYqiDaaDpdTc0eGqSdjQYvcLKx6tQQ5AqTp4gTGgPYrOcSKzSX4ervjWYECwtjk527a76IFxSb9TX1d1Wh6W5tWxBidBJqRA2xGrisb+RBdR/LTD7JJafA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769019928; c=relaxed/simple;
	bh=keA2BlmHk21OcbSObJcSyQlAtr4pTMHywx4Dn7X66b8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZSAneHv0mjszfo+rNmgJwyaSpvUGaMQkn3ISeirhDrOgAlbmjzq5C8HGzAiapnb0wDsIZ3EtLtJO6ttuAlRhtO2pzXEYu/8eMiqSJg4sirsxjqMFhjOWrDNbPx5u4f9GbVqTSFaK+T06F71m9ahk361i4RO+MKtjYKB5C7Yfahc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kZ4PMCVX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kZ4PMCVX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A99AC4CEF1;
	Wed, 21 Jan 2026 18:25:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769019927;
	bh=keA2BlmHk21OcbSObJcSyQlAtr4pTMHywx4Dn7X66b8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kZ4PMCVXM+9TH66M1qspXCRcyR8lja4pBYSmtL9Kcg4+JjZpE/hSGjAv7TeprsgcB
	 FGY1sdGaAgOXWKKjja6hS+FeD/vZYc93wAtZBlqR9RujmiasvXbcmtdVZW/8mYnONQ
	 exWNAckEXgdu6KBtyhePHZ79P22LvnS3PBWJFU3A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Frank Li <Frank.Li@nxp.com>,
	Peng Fan <peng.fan@nxp.com>,
	Shawn Guo <shawnguo@kernel.org>,
	Ben Hutchings <ben@decadent.org.uk>
Subject: [PATCH 6.18 001/198] firmware: imx: scu-irq: Set mu_resource_id before get handle
Date: Wed, 21 Jan 2026 19:13:49 +0100
Message-ID: <20260121181418.595234309@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260121181418.537774329@linuxfoundation.org>
References: <20260121181418.537774329@linuxfoundation.org>
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

From: Peng Fan <peng.fan@nxp.com>

commit ff3f9913bc0749364fbfd86ea62ba2d31c6136c8 upstream.

mu_resource_id is referenced in imx_scu_irq_get_status() and
imx_scu_irq_group_enable() which could be used by other modules, so
need to set correct value before using imx_sc_irq_ipc_handle in
SCU API call.

Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Peng Fan <peng.fan@nxp.com>
Signed-off-by: Shawn Guo <shawnguo@kernel.org>
Fixes: 81fb53feb66a ("firmware: imx: scu-irq: Init workqueue before request mbox channel")
Cc: Ben Hutchings <ben@decadent.org.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/firmware/imx/imx-scu-irq.c |   24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

--- a/drivers/firmware/imx/imx-scu-irq.c
+++ b/drivers/firmware/imx/imx-scu-irq.c
@@ -203,6 +203,18 @@ int imx_scu_enable_general_irq_channel(s
 	struct mbox_chan *ch;
 	int ret = 0, i = 0;
 
+	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
+				       "#mbox-cells", 0, &spec)) {
+		i = of_alias_get_id(spec.np, "mu");
+		of_node_put(spec.np);
+	}
+
+	/* use mu1 as general mu irq channel if failed */
+	if (i < 0)
+		i = 1;
+
+	mu_resource_id = IMX_SC_R_MU_0A + i;
+
 	ret = imx_scu_get_handle(&imx_sc_irq_ipc_handle);
 	if (ret)
 		return ret;
@@ -225,18 +237,6 @@ int imx_scu_enable_general_irq_channel(s
 		return ret;
 	}
 
-	if (!of_parse_phandle_with_args(dev->of_node, "mboxes",
-				       "#mbox-cells", 0, &spec)) {
-		i = of_alias_get_id(spec.np, "mu");
-		of_node_put(spec.np);
-	}
-
-	/* use mu1 as general mu irq channel if failed */
-	if (i < 0)
-		i = 1;
-
-	mu_resource_id = IMX_SC_R_MU_0A + i;
-
 	/* Create directory under /sysfs/firmware */
 	wakeup_obj = kobject_create_and_add("scu_wakeup_source", firmware_kobj);
 	if (!wakeup_obj) {


