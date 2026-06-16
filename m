Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BA1393AB267;
	Tue, 16 Jun 2026 15:37:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1781624263; cv=none; b=UY269gfRQSTBShlk6g6d6FF0v1nQEO/AR33OdMC1t9DvhfFQGDafLLD98Hy79YgAsAg174kpLHiRIhaUtdr8rJ3xuJaKJvnOqQl4Kyh3Dh5oXIb2pd8F4DMx40b9NUo4xqM4th7aHlC1GdqBU2Onf1Lwq2Cp3fY6zeX0ry+DJK0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1781624263; c=relaxed/simple;
	bh=Wxzh7ixPfitfX0MSEDtKI6K1LHZ4icUok+jr+YR2Qsk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AqKHhcykDPN4141B7s3PM3eXig0rcGZkGRyJU8QAFsL2x+Iww3gHTVBb62gaQaPC3M+VwzEjLNz9P73wR76jS4ULn7M/oCRoIoizziQpNvt89iraZKYxIUV6jJAPs/VPhPEMF3d6G7QIAAlRuI4QiZTX9+2QhueX7c1e5kci3bQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=1DctTfuo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="1DctTfuo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8FDC81F000E9;
	Tue, 16 Jun 2026 15:37:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1781624262;
	bh=wQDVSdHSeeOrLkjNMzkDR3FgNLigqfzwBYV2/cSS+dw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1DctTfuo6MitJogqFGzxF2AjGhFdz2IwCcPCZW6+UPTZ+Nj82w1OWkBMGEFSIkB+7
	 uaIOz8grcvjmlkWJcq7WfF4iqoVFwshNyaXZZFdi7pX0FcvRGoxuyZjZgNB+viGn/L
	 BWJppbNp+UETU9mE4vIfEmiDu0zWi0PXFaOoyXnw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Carlos Song <carlos.song@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Andi Shyti <andi.shyti@kernel.org>
Subject: [PATCH 7.0 270/378] i2c: imx: fix clock and pinctrl state inconsistency in runtime PM
Date: Tue, 16 Jun 2026 20:28:21 +0530
Message-ID: <20260616145124.322253930@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260616145109.744539446@linuxfoundation.org>
References: <20260616145109.744539446@linuxfoundation.org>
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

From: Carlos Song <carlos.song@nxp.com>

commit 8783fb8031799f1230997c16df8c8dce9fcd1841 upstream.

In i2c_imx_runtime_suspend(), the clock is disabled before switching
the pinctrl state to sleep. If pinctrl_pm_select_sleep_state() fails,
the runtime suspend is aborted but the clock remains disabled, causing
a system crash when the hardware is subsequently accessed.

Fix this by switching the pinctrl state before disabling the clock so
that a pinctrl failure leaves the clock enabled and the hardware
accessible.

In i2c_imx_runtime_resume(), restore the pinctrl state back to sleep
if clk_enable() fails to keep the consistent.

Fixes: 576eba03c994 ("i2c: imx: switch different pinctrl state in different system power status")
Signed-off-by: Carlos Song <carlos.song@nxp.com>
Cc: <stable@vger.kernel.org> # v6.14+
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Link: https://lore.kernel.org/r/20260521065038.2954998-1-carlos.song@oss.nxp.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-imx.c |   15 ++++++++++++---
 1 file changed, 12 insertions(+), 3 deletions(-)

--- a/drivers/i2c/busses/i2c-imx.c
+++ b/drivers/i2c/busses/i2c-imx.c
@@ -1892,9 +1892,15 @@ static void i2c_imx_remove(struct platfo
 static int i2c_imx_runtime_suspend(struct device *dev)
 {
 	struct imx_i2c_struct *i2c_imx = dev_get_drvdata(dev);
+	int ret;
+
+	ret = pinctrl_pm_select_sleep_state(dev);
+	if (ret)
+		return ret;
 
 	clk_disable(i2c_imx->clk);
-	return pinctrl_pm_select_sleep_state(dev);
+
+	return 0;
 }
 
 static int i2c_imx_runtime_resume(struct device *dev)
@@ -1907,10 +1913,13 @@ static int i2c_imx_runtime_resume(struct
 		return ret;
 
 	ret = clk_enable(i2c_imx->clk);
-	if (ret)
+	if (ret) {
 		dev_err(dev, "can't enable I2C clock, ret=%d\n", ret);
+		pinctrl_pm_select_sleep_state(dev);
+		return ret;
+	}
 
-	return ret;
+	return 0;
 }
 
 static int i2c_imx_suspend(struct device *dev)


