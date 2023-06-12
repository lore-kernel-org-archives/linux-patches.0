Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0415018C35
	for <patches@lists.linux.dev>; Mon, 12 Jun 2023 10:29:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5774CC433EF;
	Mon, 12 Jun 2023 10:29:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686565796;
	bh=pgJv83F9eu2OwDARpeDWs7cjWHOhbJzIydDdiYdSHrA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQ2NNC9YWYwUAtl0C54Md4JGBb6YvT/w6XWJj09LW5ZxnZvbLgtLkh/KwfFlHAbH3
	 aSbwIaZH7uLGPdCoTC9EDeMJlxaia5e6U05PWDuwLNPdWaFUYSQhov6WPrvz9NSBpu
	 u3qeomvybkkYfSzFwjcGhmhWLFsFEghh8OOjx4k8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 19/23] i2c: sprd: Delete i2c adapter in .removes error path
Date: Mon, 12 Jun 2023 12:26:20 +0200
Message-ID: <20230612101651.786437398@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230612101651.138592130@linuxfoundation.org>
References: <20230612101651.138592130@linuxfoundation.org>
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
 drivers/i2c/busses/i2c-sprd.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-sprd.c b/drivers/i2c/busses/i2c-sprd.c
index bb1478e781c42..6c95b809abdc4 100644
--- a/drivers/i2c/busses/i2c-sprd.c
+++ b/drivers/i2c/busses/i2c-sprd.c
@@ -581,10 +581,12 @@ static int sprd_i2c_remove(struct platform_device *pdev)
 
 	ret = pm_runtime_get_sync(i2c_dev->dev);
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



