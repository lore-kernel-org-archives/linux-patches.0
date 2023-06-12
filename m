Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E96E11106
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:35:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 471C0C433D2;
	Mon, 12 Jun 2023 10:35:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686566129;
	bh=+itoulZhzRZZvvd5XathDN1MInvOa+/cAW6g8Xg3bko=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tHnfFO8Izf5uJDBb1/XFP/ayUio0QzoLZST89ePgPXfjOn++pekVKF9UiAV4jNH83
	 tEAsFAu6f7drJYZuHSvIpKqF9I2Il3fTJoIpRMIXRG3n3OjSXbY20aTIx5rv458qaE
	 XT7OLgClYNVCt3hxnGXlsO3QYF7gUbmfdBmeD2d4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 56/68] i2c: sprd: Delete i2c adapter in .removes error path
Date: Mon, 12 Jun 2023 12:26:48 +0200
Message-ID: <20230612101700.765848017@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101658.437327280@linuxfoundation.org>
References: <20230612101658.437327280@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit ca0aa17f2db3468fd017038d23a78e17388e2f67 ]

If pm runtime resume fails the .remove callback used to exit early. This
resulted in an error message by the driver core but the device gets
removed anyhow. This lets the registered i2c adapter stay around with an
unbound parent device.

So only skip clk disabling if resume failed, but do delete the adapter.

Fixes: 8b9ec0719834 ("i2c: Add Spreadtrum I2C controller driver")
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-sprd.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sprd.c b/drivers/i2c/busses/i2c-sprd.c
index 8ead7e021008c..a520aa06d2cb5 100644
--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -576,12 +576,14 @@ static int sprd_i2c_remove(struct platform_device *pdev)
 	struct sprd_i2c *i2c_dev = platform_get_drvdata(pdev);
 	int ret;
 
-	ret = pm_runtime_resume_and_get(i2c_dev->dev);
+	ret = pm_runtime_get_sync(i2c_dev->dev);
 	if (ret < 0)
-		return ret;
+		dev_err(&pdev->dev, "Failed to resume device (%pe)\n", ERR_PTR(ret));
 
 	i2c_del_adapter(&i2c_dev->adap);
-	clk_disable_unprepare(i2c_dev->clk);
+
+	if (ret >= 0)
+		clk_disable_unprepare(i2c_dev->clk);
 
 	pm_runtime_put_noidle(i2c_dev->dev);
 	pm_runtime_disable(i2c_dev->dev);
-- 
2.39.2



