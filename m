Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0837C1494CB;
	Tue, 25 Jun 2024 09:38:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719308339; cv=none; b=AGTMrtGSmx2esG5YaSMpzFwfvOALmuyBqx5iCD9mINU2hrA5q2mdWPRVZX4nc+p9kAj4TSfW+X/ju7mVL7qBfMbNtbIuqcBX9cMWR236ujR9no57Npc/erV2e6tiQ419tStFgEDq4YdTBUhTkfJdtnRsaHHPaptehkuc2FDoroU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719308339; c=relaxed/simple;
	bh=b75ffO8u8jsu1Dcc53Zoq7ubg7LFobqqwOmxmvQElPc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Or1ffBL8o3w4U7p4ZHyphy5XYp4XRGY4Rn+JPIzHN6oILXwKLsoOjCiCq1mHSVU1G49llvvJ8kIJQHsXS5kOa4HNMyIJhzP03fzbGobL+gFoMKEFKhV9l6yEsTHAMDC4jxCI9v2LE/7zSzTBl8YXfvsLQd2IvzcxlEIj9XMsi/k=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Y/DSJCxF; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Y/DSJCxF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 81F94C32781;
	Tue, 25 Jun 2024 09:38:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719308338;
	bh=b75ffO8u8jsu1Dcc53Zoq7ubg7LFobqqwOmxmvQElPc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Y/DSJCxFB2RAkuA9TAPH7mnr0X/W1EDQVBiMdARqCkpBIytUQ6jaLytNv0k2ARNVc
	 3Ugrd1aI2a/wRVii/R5xRCpm5fkCxlj2UR5tdi1+jb8782IzbyBGNAmsYQBKDOjPDr
	 Sp03HORiODRnk4uDh9roNrOU5c53xiQxhIhHWt8w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexander Stein <alexander.stein@ew.tq-group.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 087/250] i2c: lpi2c: Avoid calling clk_get_rate during transfer
Date: Tue, 25 Jun 2024 11:30:45 +0200
Message-ID: <20240625085551.407702969@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240625085548.033507125@linuxfoundation.org>
References: <20240625085548.033507125@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-imx-lpi2c.c | 19 ++++++++++++++++---
 1 file changed, 16 insertions(+), 3 deletions(-)

diff --git a/drivers/i2c/busses/i2c-imx-lpi2c.c b/drivers/i2c/busses/i2c-imx-lpi2c.c
index 6d72e4e126dde..36e8f6196a87b 100644
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
@@ -212,9 +213,7 @@ static int lpi2c_imx_config(struct lpi2c_imx_struct *lpi2c_imx)
 
 	lpi2c_imx_set_mode(lpi2c_imx);
 
-	clk_rate = clk_get_rate(lpi2c_imx->clks[0].clk);
-	if (!clk_rate)
-		return -EINVAL;
+	clk_rate = lpi2c_imx->rate_per;
 
 	if (lpi2c_imx->mode == HS || lpi2c_imx->mode == ULTRA_FAST)
 		filt = 0;
@@ -611,6 +610,20 @@ static int lpi2c_imx_probe(struct platform_device *pdev)
 	if (ret)
 		return ret;
 
+	/*
+	 * Lock the parent clock rate to avoid getting parent clock upon
+	 * each transfer
+	 */
+	ret = devm_clk_rate_exclusive_get(&pdev->dev, lpi2c_imx->clks[0].clk);
+	if (ret)
+		return dev_err_probe(&pdev->dev, ret,
+				     "can't lock I2C peripheral clock rate\n");
+
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



