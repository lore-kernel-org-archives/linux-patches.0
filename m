Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3E1C6309F19;
	Mon,  1 Dec 2025 11:25:58 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588358; cv=none; b=bTYKGw6J73SLZDUlXzL6GzMGvaNCslCBUEVLYpjTtrij6bWTngdtrzISvRdGWT+F5JSH2EdNjm2wp7K7oxhflD1tMR7nDPvx1HI/RMaf5voDYW/nELa3cdzeHsCodUwjIZ4/MU5JaHngnsPuiCEJTtiAlUF0b3z4f6FK9RhEloo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588358; c=relaxed/simple;
	bh=iosJk3mA2wj/Fl1bsEIsZ86SqjGY3iY3SQ7lzpQrgws=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m5Eg5LGVP/8PU3U44kwADXq9WRgXFm1xxFC+vakUkqb6jY8DL2amErAQEJbyKO7kCsF++rG/ljmOad53AMgBGy7BK7VpfYUUZNNPRLI21WCVAv/D2m3Xv8msy4srtvm2RawS5RXqzs1aCDoWHebt5xpaofPu3AVwxNfCo319zac=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PHeEGJNX; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PHeEGJNX"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B4AC113D0;
	Mon,  1 Dec 2025 11:25:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588358;
	bh=iosJk3mA2wj/Fl1bsEIsZ86SqjGY3iY3SQ7lzpQrgws=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PHeEGJNXhQDcAWLdBqV4KPIhVWxmiblS5Z8mDLsl8hM3HB65Eqm7i3eS0V2991Yic
	 6ng1bZOjC78lcOpej+rO3iLCQUo2O+i+O+tHe33KS6y7em+tVayI7rPmXvz/OhORsp
	 StZjQalR8m/BAIJV1vIDFUg+T1dViBvKkfTVkDGk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 021/187] serial: 8250_dw: Use devm_clk_get_optional() to get the input clock
Date: Mon,  1 Dec 2025 12:22:09 +0100
Message-ID: <20251201112242.021855975@linuxfoundation.org>
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

[ Upstream commit a8afc193558a42d5df724c84436ae3b2446d8a30 ]

Simplify the code which fetches the input clock by using
devm_clk_get_optional(). This comes with a small functional change: previously
all errors were ignored except deferred probe. Now all errors are
treated as errors. If no input clock is present devm_clk_get_optional() will
return NULL instead of an error which matches the behavior of the old code.

Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20190925162617.30368-1-andriy.shevchenko@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Stable-dep-of: daeb4037adf7 ("serial: 8250_dw: handle reset control deassert error")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_dw.c |   75 ++++++++++++++++----------------------
 1 file changed, 32 insertions(+), 43 deletions(-)

--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -283,9 +283,6 @@ static void dw8250_set_termios(struct ua
 	long rate;
 	int ret;
 
-	if (IS_ERR(d->clk))
-		goto out;
-
 	clk_disable_unprepare(d->clk);
 	rate = clk_round_rate(d->clk, baud * 16);
 	if (rate < 0)
@@ -296,8 +293,10 @@ static void dw8250_set_termios(struct ua
 		ret = clk_set_rate(d->clk, rate);
 	clk_prepare_enable(d->clk);
 
-	if (!ret)
-		p->uartclk = rate;
+	if (ret)
+		goto out;
+
+	p->uartclk = rate;
 
 out:
 	p->status &= ~UPSTAT_AUTOCTS;
@@ -473,19 +472,18 @@ static int dw8250_probe(struct platform_
 	device_property_read_u32(dev, "clock-frequency", &p->uartclk);
 
 	/* If there is separate baudclk, get the rate from it. */
-	data->clk = devm_clk_get(dev, "baudclk");
-	if (IS_ERR(data->clk) && PTR_ERR(data->clk) != -EPROBE_DEFER)
-		data->clk = devm_clk_get(dev, NULL);
-	if (IS_ERR(data->clk) && PTR_ERR(data->clk) == -EPROBE_DEFER)
-		return -EPROBE_DEFER;
-	if (!IS_ERR_OR_NULL(data->clk)) {
-		err = clk_prepare_enable(data->clk);
-		if (err)
-			dev_warn(dev, "could not enable optional baudclk: %d\n",
-				 err);
-		else
-			p->uartclk = clk_get_rate(data->clk);
-	}
+	data->clk = devm_clk_get_optional(dev, "baudclk");
+	if (data->clk == NULL)
+		data->clk = devm_clk_get_optional(dev, NULL);
+	if (IS_ERR(data->clk))
+		return PTR_ERR(data->clk);
+
+	err = clk_prepare_enable(data->clk);
+	if (err)
+		dev_warn(dev, "could not enable optional baudclk: %d\n", err);
+
+	if (data->clk)
+		p->uartclk = clk_get_rate(data->clk);
 
 	/* If no clock rate is defined, fail. */
 	if (!p->uartclk) {
@@ -494,17 +492,16 @@ static int dw8250_probe(struct platform_
 		goto err_clk;
 	}
 
-	data->pclk = devm_clk_get(dev, "apb_pclk");
-	if (IS_ERR(data->pclk) && PTR_ERR(data->pclk) == -EPROBE_DEFER) {
-		err = -EPROBE_DEFER;
+	data->pclk = devm_clk_get_optional(dev, "apb_pclk");
+	if (IS_ERR(data->pclk)) {
+		err = PTR_ERR(data->pclk);
 		goto err_clk;
 	}
-	if (!IS_ERR(data->pclk)) {
-		err = clk_prepare_enable(data->pclk);
-		if (err) {
-			dev_err(dev, "could not enable apb_pclk\n");
-			goto err_clk;
-		}
+
+	err = clk_prepare_enable(data->pclk);
+	if (err) {
+		dev_err(dev, "could not enable apb_pclk\n");
+		goto err_clk;
 	}
 
 	data->rst = devm_reset_control_get_optional_exclusive(dev, NULL);
@@ -547,12 +544,10 @@ err_reset:
 	reset_control_assert(data->rst);
 
 err_pclk:
-	if (!IS_ERR(data->pclk))
-		clk_disable_unprepare(data->pclk);
+	clk_disable_unprepare(data->pclk);
 
 err_clk:
-	if (!IS_ERR(data->clk))
-		clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(data->clk);
 
 	return err;
 }
@@ -568,11 +563,9 @@ static int dw8250_remove(struct platform
 
 	reset_control_assert(data->rst);
 
-	if (!IS_ERR(data->pclk))
-		clk_disable_unprepare(data->pclk);
+	clk_disable_unprepare(data->pclk);
 
-	if (!IS_ERR(data->clk))
-		clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(data->clk);
 
 	pm_runtime_disable(dev);
 	pm_runtime_put_noidle(dev);
@@ -605,11 +598,9 @@ static int dw8250_runtime_suspend(struct
 {
 	struct dw8250_data *data = dev_get_drvdata(dev);
 
-	if (!IS_ERR(data->clk))
-		clk_disable_unprepare(data->clk);
+	clk_disable_unprepare(data->clk);
 
-	if (!IS_ERR(data->pclk))
-		clk_disable_unprepare(data->pclk);
+	clk_disable_unprepare(data->pclk);
 
 	return 0;
 }
@@ -618,11 +609,9 @@ static int dw8250_runtime_resume(struct
 {
 	struct dw8250_data *data = dev_get_drvdata(dev);
 
-	if (!IS_ERR(data->pclk))
-		clk_prepare_enable(data->pclk);
+	clk_prepare_enable(data->pclk);
 
-	if (!IS_ERR(data->clk))
-		clk_prepare_enable(data->clk);
+	clk_prepare_enable(data->clk);
 
 	return 0;
 }


