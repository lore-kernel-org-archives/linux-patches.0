Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C2B2924A06A;
	Fri, 15 May 2026 16:33:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862794; cv=none; b=V4+VrxgoC2I2X8fkUc30b6pVNQRcGkZOWBCAYSieF/+I/qUNn4KR+/RC5Eywjpny4U//x6EsZslRdSUomqGMYD+MBIBChR6VRA3IW9JtSjLsZUVUQ7mxUWIXq3Z1Kgv7/piIsAgU8SlMGsdOWiO/uyM4v0dSvGd25guVAWyZrqo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862794; c=relaxed/simple;
	bh=JG0TDXUD9Hxh5I9r+u52SwtdXIUahfpfHYJ4FccvueQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gDXap3ChBz8OarMgt5mWGMIW0IW3vInOndcC1n+JcN9FK49bNRR8VDydtFp4QASihNhpRreE2Hd2Yr4VtNoXpFZDqAe6LSxItIvvfUFW31WAlmq6R5b7RzftLQCEUVKlKpUWB9LkZhoLapCS1DbqrmRo2fUfU85cDMK6Umi9/KA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k2dhpakh; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k2dhpakh"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57B3CC2BCB0;
	Fri, 15 May 2026 16:33:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862794;
	bh=JG0TDXUD9Hxh5I9r+u52SwtdXIUahfpfHYJ4FccvueQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k2dhpakh0mmmVot6C4D1HjakqBH4egGTPhAsjWIUoyfZTim0ItZ59p2cNKixBPDN8
	 PmBJ01/vllldAiBzJqDuRTl7A6KA21quCsf/8XJwMrExam/CJnjk8GSHUKKk6g5iMI
	 vGIpq4Q4KtdTaiCY0XyptNTHp5mtm9eXu9B7NBeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>,
	"Borislav Petkov (AMD)" <bp@alien8.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.0 186/201] EDAC/versalnet: Refactor memory controller initialization and cleanup
Date: Fri, 15 May 2026 17:50:04 +0200
Message-ID: <20260515154702.608381524@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>

[ Upstream commit 62a9fc50e8d947601ea3484e732b1a65a0a54b96 ]

Simplify the initialization and cleanup flow for Versal Net DDRMC
controllers in the EDAC driver by carving out the single controller init
into a separate function which allows for a much better and more
readable error handling and unwinding.

  [ bp:
	- do the kzalloc allocations first
	- "publish" the structures only after they've been initialized
	  properly so that you don't need to unwind unnecessarily when
	  it fails later
	- remove_versalnet() is now trivial
   ]

Signed-off-by: Shubhrajyoti Datta <shubhrajyoti.datta@amd.com>
Signed-off-by: Borislav Petkov (AMD) <bp@alien8.de>
Link: https://patch.msgid.link/20251104093932.3838876-1-shubhrajyoti.datta@amd.com
Stable-dep-of: 8cf5dd235eff ("EDAC/versalnet: Fix device name memory leak")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/edac/versalnet_edac.c |  174 +++++++++++++++++++++++-------------------
 1 file changed, 97 insertions(+), 77 deletions(-)

--- a/drivers/edac/versalnet_edac.c
+++ b/drivers/edac/versalnet_edac.c
@@ -70,6 +70,8 @@
 #define XDDR5_BUS_WIDTH_32		1
 #define XDDR5_BUS_WIDTH_16		2
 
+#define MC_NAME_LEN			32
+
 /**
  * struct ecc_error_info - ECC error log information.
  * @burstpos:		Burst position.
@@ -760,7 +762,17 @@ static void versal_edac_release(struct d
 	kfree(dev);
 }
 
-static int init_versalnet(struct mc_priv *priv, struct platform_device *pdev)
+static void remove_one_mc(struct mc_priv *priv, int i)
+{
+	struct mem_ctl_info *mci;
+
+	mci = priv->mci[i];
+	device_unregister(mci->pdev);
+	edac_mc_del_mc(mci->pdev);
+	edac_mc_free(mci);
+}
+
+static int init_one_mc(struct mc_priv *priv, struct platform_device *pdev, int i)
 {
 	u32 num_chans, rank, dwidth, config;
 	struct edac_mc_layer layers[2];
@@ -768,102 +780,110 @@ static int init_versalnet(struct mc_priv
 	struct device *dev;
 	enum dev_type dt;
 	char *name;
-	int rc, i;
+	int rc;
 
-	for (i = 0; i < NUM_CONTROLLERS; i++) {
-		config = priv->adec[CONF + i * ADEC_NUM];
-		num_chans = FIELD_GET(MC5_NUM_CHANS_MASK, config);
-		rank = 1 << FIELD_GET(MC5_RANK_MASK, config);
-		dwidth = FIELD_GET(MC5_BUS_WIDTH_MASK, config);
-
-		switch (dwidth) {
-		case XDDR5_BUS_WIDTH_16:
-			dt = DEV_X16;
-			break;
-		case XDDR5_BUS_WIDTH_32:
-			dt = DEV_X32;
-			break;
-		case XDDR5_BUS_WIDTH_64:
-			dt = DEV_X64;
-			break;
-		default:
-			dt = DEV_UNKNOWN;
-		}
+	config = priv->adec[CONF + i * ADEC_NUM];
+	num_chans = FIELD_GET(MC5_NUM_CHANS_MASK, config);
+	rank = 1 << FIELD_GET(MC5_RANK_MASK, config);
+	dwidth = FIELD_GET(MC5_BUS_WIDTH_MASK, config);
+
+	switch (dwidth) {
+	case XDDR5_BUS_WIDTH_16:
+		dt = DEV_X16;
+		break;
+	case XDDR5_BUS_WIDTH_32:
+		dt = DEV_X32;
+		break;
+	case XDDR5_BUS_WIDTH_64:
+		dt = DEV_X64;
+		break;
+	default:
+		dt = DEV_UNKNOWN;
+	}
 
-		if (dt == DEV_UNKNOWN)
-			continue;
+	if (dt == DEV_UNKNOWN)
+		return 0;
 
-		/* Find the first enabled device and register that one. */
-		layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
-		layers[0].size = rank;
-		layers[0].is_virt_csrow = true;
-		layers[1].type = EDAC_MC_LAYER_CHANNEL;
-		layers[1].size = num_chans;
-		layers[1].is_virt_csrow = false;
-
-		rc = -ENOMEM;
-		mci = edac_mc_alloc(i, ARRAY_SIZE(layers), layers,
-				    sizeof(struct mc_priv));
-		if (!mci) {
-			edac_printk(KERN_ERR, EDAC_MC, "Failed memory allocation for MC%d\n", i);
-			goto err_alloc;
-		}
+	/* Find the first enabled device and register that one. */
+	layers[0].type = EDAC_MC_LAYER_CHIP_SELECT;
+	layers[0].size = rank;
+	layers[0].is_virt_csrow = true;
+	layers[1].type = EDAC_MC_LAYER_CHANNEL;
+	layers[1].size = num_chans;
+	layers[1].is_virt_csrow = false;
 
-		priv->mci[i] = mci;
-		priv->dwidth = dt;
+	rc = -ENOMEM;
+	name = kzalloc(MC_NAME_LEN, GFP_KERNEL);
+	if (!name)
+		return rc;
 
-		dev = kzalloc_obj(*dev);
-		dev->release = versal_edac_release;
-		name = kmalloc(32, GFP_KERNEL);
-		sprintf(name, "versal-net-ddrmc5-edac-%d", i);
-		dev->init_name = name;
-		rc = device_register(dev);
-		if (rc)
-			goto err_alloc;
+	dev = kzalloc(sizeof(*dev), GFP_KERNEL);
+	if (!dev)
+		goto err_name_free;
 
-		mci->pdev = dev;
+	mci = edac_mc_alloc(i, ARRAY_SIZE(layers), layers, sizeof(struct mc_priv));
+	if (!mci) {
+		edac_printk(KERN_ERR, EDAC_MC, "Failed memory allocation for MC%d\n", i);
+		goto err_dev_free;
+	}
 
-		platform_set_drvdata(pdev, priv);
+	sprintf(name, "versal-net-ddrmc5-edac-%d", i);
 
-		mc_init(mci, dev);
-		rc = edac_mc_add_mc(mci);
-		if (rc) {
-			edac_printk(KERN_ERR, EDAC_MC, "Failed to register MC%d with EDAC core\n", i);
-			goto err_alloc;
-		}
-	}
-	return 0;
+	dev->init_name = name;
+	dev->release = versal_edac_release;
 
-err_alloc:
-	while (i--) {
-		mci = priv->mci[i];
-		if (!mci)
-			continue;
-
-		if (mci->pdev) {
-			device_unregister(mci->pdev);
-			edac_mc_del_mc(mci->pdev);
-		}
+	rc = device_register(dev);
+	if (rc)
+		goto err_mc_free;
 
-		edac_mc_free(mci);
+	mci->pdev = dev;
+	mc_init(mci, dev);
+
+	rc = edac_mc_add_mc(mci);
+	if (rc) {
+		edac_printk(KERN_ERR, EDAC_MC, "Failed to register MC%d with EDAC core\n", i);
+		goto err_unreg;
 	}
 
+	priv->mci[i] = mci;
+	priv->dwidth = dt;
+
+	platform_set_drvdata(pdev, priv);
+
+	return 0;
+
+err_unreg:
+	device_unregister(mci->pdev);
+err_mc_free:
+	edac_mc_free(mci);
+err_dev_free:
+	kfree(dev);
+err_name_free:
+	kfree(name);
+
 	return rc;
 }
 
-static void remove_versalnet(struct mc_priv *priv)
+static int init_versalnet(struct mc_priv *priv, struct platform_device *pdev)
 {
-	struct mem_ctl_info *mci;
-	int i;
+	int rc, i;
 
 	for (i = 0; i < NUM_CONTROLLERS; i++) {
-		device_unregister(priv->mci[i]->pdev);
-		mci = edac_mc_del_mc(priv->mci[i]->pdev);
-		if (!mci)
-			return;
+		rc = init_one_mc(priv, pdev, i);
+		if (rc) {
+			while (i--)
+				remove_one_mc(priv, i);
 
-		edac_mc_free(mci);
+			return rc;
+		}
 	}
+	return 0;
+}
+
+static void remove_versalnet(struct mc_priv *priv)
+{
+	for (int i = 0; i < NUM_CONTROLLERS; i++)
+		remove_one_mc(priv, i);
 }
 
 static int mc_probe(struct platform_device *pdev)


