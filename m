Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2B188223DCD;
	Mon,  2 Jun 2025 14:03:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748873016; cv=none; b=GdUYmjt/fsOMT/UI5uVKmqhKKY/lVHdaPATxDe525mjZgwRYJafTVOr8OQJFmjAoaf7kM2AghHdYnUNL/V8d5ICaklyax+/WNHIndBf4k/DxSd9SsgkGuCJYxMAPS5K9VDF9t9pdmJ8aQ7sM5vakHewWY/3J73s9yj7XmaJyIgI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748873016; c=relaxed/simple;
	bh=7co+SJzbYUttvfPlnIBHXKfCFcHcqr1N49N73ntPv14=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZzG0dWYZWqVv9jVMt5TEeIl/9trEcd8Qk6kl96VAzxtf90I6HUjwgZpLLeRv17r50xsvRmz/yvmXmulgmt/z93IxLIQYZfC0sWECxBjhG+Aa0M0sLEg8utK8TdXpa9AOXKwfJcfwzfY9H5tf3Ts9H3O1Q2rwuT1plTpvTPkELeM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ap45t3pL; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ap45t3pL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E861C4CEEB;
	Mon,  2 Jun 2025 14:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748873014;
	bh=7co+SJzbYUttvfPlnIBHXKfCFcHcqr1N49N73ntPv14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ap45t3pL2JJSEK6Omy5fIpY4V0y4E3TvaXS447U5cWNqgt4sZvWihv8MxvonGkjTr
	 Gg3es/Vs9q1muKLUNyYN1PEsbpsiFbRcTq7G1YERZ/RjTbFIofI8iPr+BdIBpQJfop
	 9Y/J368s0s+M9s1ZjaJ7X3T3YcvQC9I5qoKKcmUg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jarkko Nikula <jarkko.nikula@linux.intel.com>,
	Jiawen Wu <jiawenwu@trustnetic.com>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 004/444] i2c: designware: Uniform initialization flow for polling mode
Date: Mon,  2 Jun 2025 15:41:08 +0200
Message-ID: <20250602134341.092585329@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134340.906731340@linuxfoundation.org>
References: <20250602134340.906731340@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jarkko Nikula <jarkko.nikula@linux.intel.com>

[ Upstream commit 535677e44d57a31e1363529b5ecddb92653d7136 ]

Currently initialization flow in i2c_dw_probe_master() skips a few steps
and has code duplication for polling mode implementation.

Simplify this by adding a new ACCESS_POLLING flag that is set for those
two platforms that currently use polling mode and use it to skip
interrupt handler setup.

Signed-off-by: Jarkko Nikula <jarkko.nikula@linux.intel.com>
Tested-by: Jiawen Wu <jiawenwu@trustnetic.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Stable-dep-of: 1cfe51ef07ca ("i2c: designware: Fix an error handling path in i2c_dw_pci_probe()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-designware-core.h    |  1 +
 drivers/i2c/busses/i2c-designware-master.c  | 42 ++++-----------------
 drivers/i2c/busses/i2c-designware-pcidrv.c  |  2 +-
 drivers/i2c/busses/i2c-designware-platdrv.c |  2 +-
 4 files changed, 11 insertions(+), 36 deletions(-)

diff --git a/drivers/i2c/busses/i2c-designware-core.h b/drivers/i2c/busses/i2c-designware-core.h
index 5eb130c1d6719..a26fff9716ddc 100644
--- a/drivers/i2c/busses/i2c-designware-core.h
+++ b/drivers/i2c/busses/i2c-designware-core.h
@@ -305,6 +305,7 @@ struct dw_i2c_dev {
 #define ACCESS_INTR_MASK			BIT(0)
 #define ACCESS_NO_IRQ_SUSPEND			BIT(1)
 #define ARBITRATION_SEMAPHORE			BIT(2)
+#define ACCESS_POLLING				BIT(3)
 
 #define MODEL_MSCC_OCELOT			BIT(8)
 #define MODEL_BAIKAL_BT1			BIT(9)
diff --git a/drivers/i2c/busses/i2c-designware-master.c b/drivers/i2c/busses/i2c-designware-master.c
index 579c668cb78a6..c1e516df5cd4c 100644
--- a/drivers/i2c/busses/i2c-designware-master.c
+++ b/drivers/i2c/busses/i2c-designware-master.c
@@ -991,31 +991,6 @@ static int i2c_dw_init_recovery_info(struct dw_i2c_dev *dev)
 	return 0;
 }
 
-static int i2c_dw_poll_adap_quirk(struct dw_i2c_dev *dev)
-{
-	struct i2c_adapter *adap = &dev->adapter;
-	int ret;
-
-	pm_runtime_get_noresume(dev->dev);
-	ret = i2c_add_numbered_adapter(adap);
-	if (ret)
-		dev_err(dev->dev, "Failed to add adapter: %d\n", ret);
-	pm_runtime_put_noidle(dev->dev);
-
-	return ret;
-}
-
-static bool i2c_dw_is_model_poll(struct dw_i2c_dev *dev)
-{
-	switch (dev->flags & MODEL_MASK) {
-	case MODEL_AMD_NAVI_GPU:
-	case MODEL_WANGXUN_SP:
-		return true;
-	default:
-		return false;
-	}
-}
-
 int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 {
 	struct i2c_adapter *adap = &dev->adapter;
@@ -1071,9 +1046,6 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 	adap->dev.parent = dev->dev;
 	i2c_set_adapdata(adap, dev);
 
-	if (i2c_dw_is_model_poll(dev))
-		return i2c_dw_poll_adap_quirk(dev);
-
 	if (dev->flags & ACCESS_NO_IRQ_SUSPEND) {
 		irq_flags = IRQF_NO_SUSPEND;
 	} else {
@@ -1087,12 +1059,14 @@ int i2c_dw_probe_master(struct dw_i2c_dev *dev)
 	regmap_write(dev->map, DW_IC_INTR_MASK, 0);
 	i2c_dw_release_lock(dev);
 
-	ret = devm_request_irq(dev->dev, dev->irq, i2c_dw_isr, irq_flags,
-			       dev_name(dev->dev), dev);
-	if (ret) {
-		dev_err(dev->dev, "failure requesting irq %i: %d\n",
-			dev->irq, ret);
-		return ret;
+	if (!(dev->flags & ACCESS_POLLING)) {
+		ret = devm_request_irq(dev->dev, dev->irq, i2c_dw_isr,
+				       irq_flags, dev_name(dev->dev), dev);
+		if (ret) {
+			dev_err(dev->dev, "failure requesting irq %i: %d\n",
+				dev->irq, ret);
+			return ret;
+		}
 	}
 
 	ret = i2c_dw_init_recovery_info(dev);
diff --git a/drivers/i2c/busses/i2c-designware-pcidrv.c b/drivers/i2c/busses/i2c-designware-pcidrv.c
index 61d7a27aa0701..9be9a2658e1f6 100644
--- a/drivers/i2c/busses/i2c-designware-pcidrv.c
+++ b/drivers/i2c/busses/i2c-designware-pcidrv.c
@@ -154,7 +154,7 @@ static int navi_amd_setup(struct pci_dev *pdev, struct dw_pci_controller *c)
 {
 	struct dw_i2c_dev *dev = dev_get_drvdata(&pdev->dev);
 
-	dev->flags |= MODEL_AMD_NAVI_GPU;
+	dev->flags |= MODEL_AMD_NAVI_GPU | ACCESS_POLLING;
 	dev->timings.bus_freq_hz = I2C_MAX_STANDARD_MODE_FREQ;
 	return 0;
 }
diff --git a/drivers/i2c/busses/i2c-designware-platdrv.c b/drivers/i2c/busses/i2c-designware-platdrv.c
index 855b698e99c08..4ab41ba39d55f 100644
--- a/drivers/i2c/busses/i2c-designware-platdrv.c
+++ b/drivers/i2c/busses/i2c-designware-platdrv.c
@@ -290,7 +290,7 @@ static int dw_i2c_plat_probe(struct platform_device *pdev)
 
 	dev->flags = (uintptr_t)device_get_match_data(&pdev->dev);
 	if (device_property_present(&pdev->dev, "wx,i2c-snps-model"))
-		dev->flags = MODEL_WANGXUN_SP;
+		dev->flags = MODEL_WANGXUN_SP | ACCESS_POLLING;
 
 	dev->dev = &pdev->dev;
 	dev->irq = irq;
-- 
2.39.5



