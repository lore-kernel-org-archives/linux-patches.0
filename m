Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 78F0E2EE262;
	Tue, 31 Mar 2026 16:24:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774974276; cv=none; b=kNkcV1JVwcNW7Ap+guH+nP/Ao/psknetMbdtPILhUXI/+rUS6HQdQ+/6gVWJQG/Oh/oGYkrCrWGFeqmdlt+/GJTdbr9JfLUU3uXkuPUztozizCKT5oOWVqTF92fahyZyCcPKX2aR4qoDSuf3TCzvfNUEj4UPrJhi7db/1RCn11Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774974276; c=relaxed/simple;
	bh=YFObIE7faauXSulh+EH/II0bpQ7jQHluUoIo39Vh1pU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d8Fyb8CyMM5IgaPEYInUEY3Am1gjdck0QbmYnlw7xHGeGiGxiBDzb4fTZytlIPZpI+g2DC4jzm+EQwNUi4P+Gv2i0QYsmprTam8lBSnctbg370ynKqYqHEidHUJ3fYZi9Whu3oxqCGTFOdH7drjn2Ggu9r+DTGqYopQF51w00Yk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fTpV5hAe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fTpV5hAe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE61FC19423;
	Tue, 31 Mar 2026 16:24:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774974276;
	bh=YFObIE7faauXSulh+EH/II0bpQ7jQHluUoIo39Vh1pU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fTpV5hAeA86ZoGCO/eMMmjrDt98mc78PGL3DFjMNbWCFPRUCoo0mbdTFYn6X7wGZn
	 4E3dXGRZ5pZ2euxFHwjLcEClx/yKVFI5wo/U01bH+wo5Nop4/DQVaroneQRPm2zaPN
	 iIJrCAi0kLh69fOxcZTRGMptEwkEyPSOoET0pbwc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nuno Sa <nuno.sa@analog.com>,
	Guenter Roeck <linux@roeck-us.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 005/175] hwmon: (axi-fan-control) Make use of dev_err_probe()
Date: Tue, 31 Mar 2026 18:19:49 +0200
Message-ID: <20260331161729.982481934@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161729.779738837@linuxfoundation.org>
References: <20260331161729.779738837@linuxfoundation.org>
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

From: Nuno Sa <nuno.sa@analog.com>

[ Upstream commit ec823656c1e0e5f49e92ed86cee9fb26585da18e ]

Use dev_err_probe() to slightly simplify printing errors during probe.
No functional changes intended.

Signed-off-by: Nuno Sa <nuno.sa@analog.com>
Link: https://lore.kernel.org/r/20240214-axi-fan-control-no-of-v1-3-43ca656fe2e3@analog.com
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Stable-dep-of: 813bbc4d33d2 ("hwmon: axi-fan: don't use driver_override as IRQ name")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/hwmon/axi-fan-control.c | 40 +++++++++++++++------------------
 1 file changed, 18 insertions(+), 22 deletions(-)

diff --git a/drivers/hwmon/axi-fan-control.c b/drivers/hwmon/axi-fan-control.c
index 8dfe3b6c5a177..df99cad16b208 100644
--- a/drivers/hwmon/axi-fan-control.c
+++ b/drivers/hwmon/axi-fan-control.c
@@ -466,10 +466,9 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 		return PTR_ERR(ctl->base);
 
 	clk = devm_clk_get_enabled(&pdev->dev, NULL);
-	if (IS_ERR(clk)) {
-		dev_err(&pdev->dev, "clk_get failed with %ld\n", PTR_ERR(clk));
-		return PTR_ERR(clk);
-	}
+	if (IS_ERR(clk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(clk),
+				     "clk_get failed\n");
 
 	ctl->clk_rate = clk_get_rate(clk);
 	if (!ctl->clk_rate)
@@ -477,22 +476,20 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 
 	version = axi_ioread(ADI_AXI_REG_VERSION, ctl);
 	if (ADI_AXI_PCORE_VER_MAJOR(version) !=
-	    ADI_AXI_PCORE_VER_MAJOR((*id))) {
-		dev_err(&pdev->dev, "Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
-			ADI_AXI_PCORE_VER_MAJOR(*id),
-			ADI_AXI_PCORE_VER_MINOR(*id),
-			ADI_AXI_PCORE_VER_PATCH(*id),
-			ADI_AXI_PCORE_VER_MAJOR(version),
-			ADI_AXI_PCORE_VER_MINOR(version),
-			ADI_AXI_PCORE_VER_PATCH(version));
-		return -ENODEV;
-	}
+	    ADI_AXI_PCORE_VER_MAJOR((*id)))
+		return dev_err_probe(&pdev->dev, -ENODEV,
+				     "Major version mismatch. Expected %d.%.2d.%c, Reported %d.%.2d.%c\n",
+				     ADI_AXI_PCORE_VER_MAJOR(*id),
+				     ADI_AXI_PCORE_VER_MINOR(*id),
+				     ADI_AXI_PCORE_VER_PATCH(*id),
+				     ADI_AXI_PCORE_VER_MAJOR(version),
+				     ADI_AXI_PCORE_VER_MINOR(version),
+				     ADI_AXI_PCORE_VER_PATCH(version));
 
 	ret = axi_fan_control_init(ctl, &pdev->dev);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to initialize device\n");
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "Failed to initialize device\n");
 
 	ctl->hdev = devm_hwmon_device_register_with_info(&pdev->dev,
 							 name,
@@ -511,10 +508,9 @@ static int axi_fan_control_probe(struct platform_device *pdev)
 					axi_fan_control_irq_handler,
 					IRQF_ONESHOT | IRQF_TRIGGER_HIGH,
 					pdev->driver_override, ctl);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to request an irq, %d", ret);
-		return ret;
-	}
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "failed to request an irq\n");
 
 	return 0;
 }
-- 
2.51.0



