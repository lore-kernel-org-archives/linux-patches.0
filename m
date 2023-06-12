Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A779919526
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:31:44 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E210C433D2;
	Mon, 12 Jun 2023 10:31:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565904;
	bh=9alBJ066ZQaUM7Z5J0Oxo3TQMox0Ft6lg9LI57asbTc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bYK91ob66vTXoMO4iYEeczMkyNZ218QzM0xC5ab9zl326BPsUhQ5oJLAnzLbzXhUn
	 XllnXWw0pS+KYI57k6GEftdLsQIM1dUlQS3gVaaWfwtkh0AjFHjiKQeLVM6E9uifFr
	 pL0WreTg+q7E0XLyy3vO42WEX+eCYW9yNdoFMF4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 35/45] i2c: sprd: Delete i2c adapter in .removes error path
Date: Mon, 12 Jun 2023 12:26:29 +0200
Message-ID: <20230612101656.090598007@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101654.644983109@linuxfoundation.org>
References: <20230612101654.644983109@linuxfoundation.org>
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
index 92ba0183fd8a0..ef0dc06a3778e 100644
--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -577,12 +577,14 @@ static int sprd_i2c_remove(struct platform_device *pdev)
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



