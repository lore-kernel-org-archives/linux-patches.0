Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B0F4635201C;
	Tue, 21 Jul 2026 20:46:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666782; cv=none; b=mscgHvtvm6V/TmFIjIHE5MIJwJuU34nwnvOClylx+dhXpDrlXiQdiPFor+/5KNdItsafSAho/bwmLDZKAn9A8Hur/fU4qlWUE7dImAXdrUduaHPMAPEFyHg+DLPLO8wyep3oHksk5scqvWjAfwB0ceXykPo3xzTQvCEBmvqS7rg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666782; c=relaxed/simple;
	bh=BIqY4xQPct3OFfebpVMTdjSyLgCC6qNMR0vJYn2qpE8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aNHl2mhOIKIEDH/ltp475NR8woLYYUlUwGSYboB6WTeeVgEYPIoFnkOIfUcXtxdf/co5I2CfBGMUrAf7/vnnTEwQVnfLcOeoz/yUbcDKPWNh47fio/05mtWW1uZF0kbf2u/4LZK/BKFXMk1+N13p3Z4x/oOHArWFz0CRjcsN7So=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FZ9T8d88; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FZ9T8d88"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 192901F000E9;
	Tue, 21 Jul 2026 20:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666781;
	bh=TGd6hru0BPmeWTbkyzD1+URzYZh5WOCu2jExI1AmcW4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FZ9T8d88QZV5zw95O3cGXG42qwWByymWa244wusj5c3Q97daflwCOU0IGzbHdxeGK
	 PZntqAOVtziWg+em6h/A2LBoOdzEq/JIkU+ce/ApJTm8cKz2icdrARPPK1XgNVVxlo
	 7iV1O5BzkCzY1DbOo16Oq7AivPOU42w+ADHRJjko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Rosen Penev <rosenp@gmail.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0812/1266] net: gianfar: dispose irq mappings on probe failure and device removal
Date: Tue, 21 Jul 2026 17:20:49 +0200
Message-ID: <20260721152500.029191015@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rosen Penev <rosenp@gmail.com>

[ Upstream commit dbf803bc4a8b0522c9a12560c20905a5952d1cb9 ]

irq_of_parse_and_map() creates irqdomain mappings that should be
balanced with irq_dispose_mapping(). The driver never called
irq_dispose_mapping(), leaking mappings on probe failure and
device removal.

Fix by adding irq_dispose_mapping() in free_gfar_dev() and
expanding its loop from priv->num_grps to MAXGROUPS so the
error path also catches partially-initialized groups. All
irqinfo pointers are pre-initialized to NULL in gfar_of_init(),
making the NULL-guarded walk in free_gfar_dev() safe for every
scenario.

gfar_parse_group() itself is left as a simple parse function
with no resource management; cleanup is centralized in the
caller's error path.

Assisted-by: opencode:big-pickle
Fixes: b31a1d8b4151 ("gianfar: Convert gianfar to an of_platform_driver")
Signed-off-by: Rosen Penev <rosenp@gmail.com>
Link: https://patch.msgid.link/20260626225228.427392-1-rosenp@gmail.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/freescale/gianfar.c | 16 +++++++++++-----
 1 file changed, 11 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index e3dfbd7a42361e..4d7fdfe5522483 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -470,10 +470,13 @@ static void free_gfar_dev(struct gfar_private *priv)
 {
 	int i, j;
 
-	for (i = 0; i < priv->num_grps; i++)
+	for (i = 0; i < MAXGROUPS; i++)
 		for (j = 0; j < GFAR_NUM_IRQS; j++) {
-			kfree(priv->gfargrp[i].irqinfo[j]);
-			priv->gfargrp[i].irqinfo[j] = NULL;
+			if (priv->gfargrp[i].irqinfo[j]) {
+				irq_dispose_mapping(priv->gfargrp[i].irqinfo[j]->irq);
+				kfree(priv->gfargrp[i].irqinfo[j]);
+				priv->gfargrp[i].irqinfo[j] = NULL;
+			}
 		}
 
 	free_netdev(priv->ndev);
@@ -630,7 +633,7 @@ static phy_interface_t gfar_get_interface(struct net_device *dev)
 static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 {
 	const char *model;
-	int err = 0, i;
+	int err = 0, i, j;
 	phy_interface_t interface;
 	struct net_device *dev = NULL;
 	struct gfar_private *priv = NULL;
@@ -714,8 +717,11 @@ static int gfar_of_init(struct platform_device *ofdev, struct net_device **pdev)
 	priv->rx_list.count = 0;
 	mutex_init(&priv->rx_queue_access);
 
-	for (i = 0; i < MAXGROUPS; i++)
+	for (i = 0; i < MAXGROUPS; i++) {
 		priv->gfargrp[i].regs = NULL;
+		for (j = 0; j < GFAR_NUM_IRQS; j++)
+			priv->gfargrp[i].irqinfo[j] = NULL;
+	}
 
 	/* Parse and initialize group specific information */
 	if (priv->mode == MQ_MG_MODE) {
-- 
2.53.0



