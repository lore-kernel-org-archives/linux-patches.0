Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 754AC13D516;
	Fri,  6 Dec 2024 14:49:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733496543; cv=none; b=oc6rxs6B/2kKI+UsGfs3cucgK8hw437IKpMUo/8asGxgOlxqLu/iyOjcmQ5TcXNU6ylqaaxRkvmdX3QmzwqZ5kTHFiy5lJ3lmgQMU2Rzge0+y3nAfGSHrOKRuTJVchPq91GlVWSBSsQgIzKakv+oD3RQ92qnLCTLJZxvyR/WJJg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733496543; c=relaxed/simple;
	bh=5jNcsOXPCC5S2Kl1TEXNq3TCvZ+ttT5Smgjc0q+4jbk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZAqiLptXIwWg6B3XU6ih5jMNJDQBAP35/a2awccdqsTmyFFN5qfyMStZ5rHcb5FBwzVVlTlfBycumbe3wDEod2cWd+ytUu73o/L2dY/ygfdiXLeWPM8Ldc3IMzT5SOmWjsWQkuxR1w1YTcKFvnhh6fQ2yL0jUqPj+uYi7u1blxk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gnuXisv0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gnuXisv0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D75BBC4CED1;
	Fri,  6 Dec 2024 14:49:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733496543;
	bh=5jNcsOXPCC5S2Kl1TEXNq3TCvZ+ttT5Smgjc0q+4jbk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gnuXisv08LCPrTz+a1dEa9hUdNPRIItwC/jdpmnIg61iqmc90V+znIW4YDs5EB8Jq
	 2o8Lxncq50He/ZjAScHK864xyC/gJaWmwQ0h3/pyGE7xT0x8/lCtEPHvenc4deH+8H
	 dENYTFDJsKjvK4RbtIUc1/yKbspf674igrKYl18Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Bin Lan <bin.lan.cn@windriver.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 034/676] i2c: lpi2c: Avoid calling clk_get_rate during transfer
Date: Fri,  6 Dec 2024 15:27:33 +0100
Message-ID: <20241206143654.688723769@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241206143653.344873888@linuxfoundation.org>
References: <20241206143653.344873888@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Stein <alexander.stein@ew.tq-group.com>

[ Upstream commit 4268254a39484fc11ba991ae148bacbe75d9cc0a ]

Instead of repeatedly calling clk_get_rate for each transfer, lock
the clock rate and cache the value.
A deadlock has been observed while adding tlv320aic32x4 audio codec to
the system. When this clock provider adds its clock, the clk mutex is
locked already, it needs to access i2c, which in return needs the mutex
for clk_get_rate as well.

Signed-off-by: Alexander Stein <alexander.stein@ew.tq-group.com>
Reviewed-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Andi Shyti <andi.shyti@kernel.org>
[ Resolve minor conflicts to fix CVE-2024-40965 ]
Signed-off-by: Bin Lan <bin.lan.cn@windriver.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 10 +++++++---
 1 file changed, 7 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 678b30e90492a..5d4f04a3c6d32 100644
--- a/drivers/i2c/busses/i2c-imx-lpi2c.c
+++ b/drivers/i2c/busses/i2c-imx-lpi2c.c
@@ -99,6 +99,7 @@ struct lpi2c_imx_struct {
 	__u8			*rx_buf;
 	__u8			*tx_buf;
 	struct completion	complete;
+	unsigned long		rate_per;
 	unsigned int		msglen;
 	unsigned int		delivered;
 	unsigned int		block_data;
@@ -207,9 +208,7 @@ static int lpi2c_imx_config(struct lpi2c_imx_struct *lpi2c_imx)
 
 	lpi2c_imx_set_mode(lpi2c_imx);
 
-	clk_rate = clk_get_rate(lpi2c_imx->clks[0].clk);
-	if (!clk_rate)
-		return -EINVAL;
+	clk_rate = lpi2c_imx->rate_per;
 
 	if (lpi2c_imx->mode == HS || lpi2c_imx->mode == ULTRA_FAST)
 		filt = 0;
@@ -590,6 +589,11 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	lpi2c_imx->rate_per = clk_get_rate(lpi2c_imx->clks[0].clk);
+	if (!lpi2c_imx->rate_per)
+		return dev_err_probe(&pdev->dev, -EINVAL,
+				     "can't get I2C peripheral clock rate\n");
+
 	pm_runtime_set_autosuspend_delay(&pdev->dev, I2C_PM_TIMEOUT);
 	pm_runtime_use_autosuspend(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
-- 
2.43.0



