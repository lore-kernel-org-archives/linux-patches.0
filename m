Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D1BF2F5E;
	Tue, 12 Aug 2025 18:04:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755021846; cv=none; b=q2mw+4Q32jt1ScSUdudNT1bICoc6aoejeou4ckPWlX35miL1XHSS+ZFkXg7Zlc7uhIMZqP50YBS+UnGiF+hh8B8efpyOesjPTnf8WCOxYa3SVDFDhvCBk8HUrl0rmkPu1AyyuPYbxG44vwu2TkUCfkQL8Hv8y54gaxgPQ6HvxYU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755021846; c=relaxed/simple;
	bh=/oArxbwcMb9PGRJNzsTbRXGsNzbYMQRmU/5niuZ+PRU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NoEbFBWLhygtxSk5fkGcLmSYiNOfK/hO8tgUjzcVd+Oed0mSUhwmVdmS3GnEHtBFHgG2WCk/OMY3UNAyM9HecZHLNGtSFCFA53RojlUd2V+7ImvpgbOKF4T/qVsQyta5b5/6wZvAxbeFmP37hUmV3klaanXCGxqySmt+wZcFvhI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=c0ZByo/i; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="c0ZByo/i"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EBFCAC4CEF0;
	Tue, 12 Aug 2025 18:04:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755021846;
	bh=/oArxbwcMb9PGRJNzsTbRXGsNzbYMQRmU/5niuZ+PRU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=c0ZByo/iwe2j4t6XC4Fb7UMZ0FzGjHFbD1NdLvQHP4rfRLfV3d+TT3ZIezNqaQi1X
	 z+TeiL6eC/CGyR2NnDrH+KE+ahrURrRJiiWGS4hGlQBrmnDW+KIuM4bJ/iLOiBFwcH
	 iuyALADpMIZu2hyK8zP5BieLxmL8l3E2oRmIqjGE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andi Shyti <andi.shyti@kernel.org>,
	Alain Volmat <alain.volmat@foss.st.com>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 243/262] i2c: stm32f7: Use devm_clk_get_enabled()
Date: Tue, 12 Aug 2025 19:30:31 +0200
Message-ID: <20250812173003.496745860@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250812172952.959106058@linuxfoundation.org>
References: <20250812172952.959106058@linuxfoundation.org>
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

From: Andi Shyti <andi.shyti@kernel.org>

[ Upstream commit 7ba2b17a87466e1410ae0ccc94d8eb381de177c2 ]

Replace the pair of functions, devm_clk_get() and
clk_prepare_enable(), with a single function
devm_clk_get_enabled().

Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
Acked-by: Alain Volmat <alain.volmat@foss.st.com>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Stable-dep-of: 6aae87fe7f18 ("i2c: stm32f7: unmap DMA mapped buffer")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/i2c/busses/i2c-stm32f7.c |   37 ++++++++++++-------------------------
 1 file changed, 12 insertions(+), 25 deletions(-)

--- a/drivers/i2c/busses/i2c-stm32f7.c
+++ b/drivers/i2c/busses/i2c-stm32f7.c
@@ -2177,23 +2177,16 @@ static int stm32f7_i2c_probe(struct plat
 	i2c_dev->wakeup_src = of_property_read_bool(pdev->dev.of_node,
 						    "wakeup-source");
 
-	i2c_dev->clk = devm_clk_get(&pdev->dev, NULL);
+	i2c_dev->clk = devm_clk_get_enabled(&pdev->dev, NULL);
 	if (IS_ERR(i2c_dev->clk))
 		return dev_err_probe(&pdev->dev, PTR_ERR(i2c_dev->clk),
-				     "Failed to get controller clock\n");
-
-	ret = clk_prepare_enable(i2c_dev->clk);
-	if (ret) {
-		dev_err(&pdev->dev, "Failed to prepare_enable clock\n");
-		return ret;
-	}
+				     "Failed to enable controller clock\n");
 
 	rst = devm_reset_control_get(&pdev->dev, NULL);
-	if (IS_ERR(rst)) {
-		ret = dev_err_probe(&pdev->dev, PTR_ERR(rst),
-				    "Error: Missing reset ctrl\n");
-		goto clk_free;
-	}
+	if (IS_ERR(rst))
+		return dev_err_probe(&pdev->dev, PTR_ERR(rst),
+				     "Error: Missing reset ctrl\n");
+
 	reset_control_assert(rst);
 	udelay(2);
 	reset_control_deassert(rst);
@@ -2208,7 +2201,7 @@ static int stm32f7_i2c_probe(struct plat
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq event %i\n",
 			irq_event);
-		goto clk_free;
+		return ret;
 	}
 
 	ret = devm_request_irq(&pdev->dev, irq_error, stm32f7_i2c_isr_error, 0,
@@ -2216,29 +2209,28 @@ static int stm32f7_i2c_probe(struct plat
 	if (ret) {
 		dev_err(&pdev->dev, "Failed to request irq error %i\n",
 			irq_error);
-		goto clk_free;
+		return ret;
 	}
 
 	setup = of_device_get_match_data(&pdev->dev);
 	if (!setup) {
 		dev_err(&pdev->dev, "Can't get device data\n");
-		ret = -ENODEV;
-		goto clk_free;
+		return -ENODEV;
 	}
 	i2c_dev->setup = *setup;
 
 	ret = stm32f7_i2c_setup_timing(i2c_dev, &i2c_dev->setup);
 	if (ret)
-		goto clk_free;
+		return ret;
 
 	/* Setup Fast mode plus if necessary */
 	if (i2c_dev->bus_rate > I2C_MAX_FAST_MODE_FREQ) {
 		ret = stm32f7_i2c_setup_fm_plus_bits(pdev, i2c_dev);
 		if (ret)
-			goto clk_free;
+			return ret;
 		ret = stm32f7_i2c_write_fm_plus_bits(i2c_dev, true);
 		if (ret)
-			goto clk_free;
+			return ret;
 	}
 
 	adap = &i2c_dev->adap;
@@ -2349,9 +2341,6 @@ clr_wakeup_capable:
 fmp_clear:
 	stm32f7_i2c_write_fm_plus_bits(i2c_dev, false);
 
-clk_free:
-	clk_disable_unprepare(i2c_dev->clk);
-
 	return ret;
 }
 
@@ -2385,8 +2374,6 @@ static void stm32f7_i2c_remove(struct pl
 	}
 
 	stm32f7_i2c_write_fm_plus_bits(i2c_dev, false);
-
-	clk_disable_unprepare(i2c_dev->clk);
 }
 
 static int __maybe_unused stm32f7_i2c_runtime_suspend(struct device *dev)


