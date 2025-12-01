Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 71B2A30ACE6;
	Mon,  1 Dec 2025 11:26:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588362; cv=none; b=MJVl53xorjhbvRbJcxmYezowrPekKNdsMDfQO8HOp2B89trbefp/K8X0VPIgHJ1vLQLGqNleMWBfQEdGfjwos7DW1q/uNiH4muf9Ba1Y5o0IeXmAVTOVC4rZS86oWwHk9B6LlC+tozZ60Pmow0WtYHlUPIR7ZZYS+0KDlOjlIvk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588362; c=relaxed/simple;
	bh=LyDrR2MnHjFmlnL5fLNRa8AYm0eVzFug83xtrF0mfo0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pwccDXCH3XkfkX/aY8BlLPQj5Ed4Z7lWDDO9aX+bR0PD+g6rXz4fjGvE379QZmINgvsddRkT8OD+XlW/hsl7PIHXyh83rpGFXas1BH8kMpV6maY5uSfsZc19S4V9BPoAld3msuilDA8e9t1U0AOOQRTcPy85F43L4CvVZ85rNaw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XZynAklR; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XZynAklR"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 90D8AC113D0;
	Mon,  1 Dec 2025 11:26:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588361;
	bh=LyDrR2MnHjFmlnL5fLNRa8AYm0eVzFug83xtrF0mfo0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XZynAklRDJzmaNesaXD0bf7hCAyBbPKi2K1uUg8rqEKQHeyiWq+nlGN9CfxsBw496
	 QOkmRXdLYk3PEEFKTcteor86wzgQOYGEv9q3uXyXBUrWLr00SUC1dPqvlXQKR0tcCz
	 0wBbM7154+AyYZSCpCfKpBdul3oBDVIhoVWI+i5U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/187] serial: 8250_dw: Use devm_add_action_or_reset()
Date: Mon,  1 Dec 2025 12:22:10 +0100
Message-ID: <20251201112242.057792798@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Andy Shevchenko <andriy.shevchenko@linux.intel.com>

[ Upstream commit 295b09128d12fb1a7a67f771cc0ae0df869eafaf ]

Slightly simplify ->probe() and drop a few goto labels by using
devm_add_action_or_reset() for clock and reset cleanup.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20220509172129.37770-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: daeb4037adf7 ("serial: 8250_dw: handle reset control deassert error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |   63 ++++++++++++++++++--------------------
 1 file changed, 31 insertions(+), 32 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -384,6 +384,16 @@ static void dw8250_quirks(struct uart_po
 	}
 }
 
+static void dw8250_clk_disable_unprepare(void *data)
+{
+	clk_disable_unprepare(data);
+}
+
+static void dw8250_reset_control_assert(void *data)
+{
+	reset_control_assert(data);
+}
+
 static int dw8250_probe(struct platform_device *pdev)
 {
 	struct uart_8250_port uart = {}, *up = &uart;
@@ -482,35 +492,43 @@ static int dw8250_probe(struct platform_
 	if (err)
 		dev_warn(dev, "could not enable optional baudclk: %d\n", err);
 
+	err = devm_add_action_or_reset(dev, dw8250_clk_disable_unprepare, data->clk);
+	if (err)
+		return err;
+
 	if (data->clk)
 		p->uartclk = clk_get_rate(data->clk);
 
 	/* If no clock rate is defined, fail. */
 	if (!p->uartclk) {
 		dev_err(dev, "clock rate not defined\n");
-		err = -EINVAL;
-		goto err_clk;
+		return -EINVAL;
 	}
 
 	data->pclk = devm_clk_get_optional(dev, "apb_pclk");
-	if (IS_ERR(data->pclk)) {
-		err = PTR_ERR(data->pclk);
-		goto err_clk;
-	}
+	if (IS_ERR(data->pclk))
+		return PTR_ERR(data->pclk);
 
 	err = clk_prepare_enable(data->pclk);
 	if (err) {
 		dev_err(dev, "could not enable apb_pclk\n");
-		goto err_clk;
+		return err;
 	}
 
+	err = devm_add_action_or_reset(dev, dw8250_clk_disable_unprepare, data->pclk);
+	if (err)
+		return err;
+
 	data->rst = devm_reset_control_get_optional_exclusive(dev, NULL);
-	if (IS_ERR(data->rst)) {
-		err = PTR_ERR(data->rst);
-		goto err_pclk;
-	}
+	if (IS_ERR(data->rst))
+		return PTR_ERR(data->rst);
+
 	reset_control_deassert(data->rst);
 
+	err = devm_add_action_or_reset(dev, dw8250_reset_control_assert, data->rst);
+	if (err)
+		return err;
+
 	dw8250_quirks(p, data);
 
 	/* If the Busy Functionality is not implemented, don't handle it */
@@ -528,10 +546,8 @@ static int dw8250_probe(struct platform_
 	}
 
 	data->data.line = serial8250_register_8250_port(up);
-	if (data->data.line < 0) {
-		err = data->data.line;
-		goto err_reset;
-	}
+	if (data->data.line < 0)
+		return data->data.line;
 
 	platform_set_drvdata(pdev, data);
 
@@ -539,17 +555,6 @@ static int dw8250_probe(struct platform_
 	pm_runtime_enable(dev);
 
 	return 0;
-
-err_reset:
-	reset_control_assert(data->rst);
-
-err_pclk:
-	clk_disable_unprepare(data->pclk);
-
-err_clk:
-	clk_disable_unprepare(data->clk);
-
-	return err;
 }
 
 static int dw8250_remove(struct platform_device *pdev)
@@ -561,12 +566,6 @@ static int dw8250_remove(struct platform
 
 	serial8250_unregister_port(data->data.line);
 
-	reset_control_assert(data->rst);
-
-	clk_disable_unprepare(data->pclk);
-
-	clk_disable_unprepare(data->clk);
-
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
 


