Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415A51774B;
	Thu, 18 Jan 2024 10:56:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705575383; cv=none; b=E0O5hcGrsmpoQjawcaN2XuNOu8d3u0xfsfIVPJgnVO2XCUh2dthm8wqiN5mGJ39BnKF0JlL4hUQ3/+na7LByN/ypexBq+YjA3Z+niB1DxlDLnuReMM2cxVwvFDyLfwAj9EIPZTiPOKj4/ZEphHSKDWr/pFvmsuhKDWSo1Nb2SFQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705575383; c=relaxed/simple;
	bh=gWan/ugkENzO/EXmD8xXYfnWR1nthG88EUGvGr/DtmE=;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:
	 X-Mailer:In-Reply-To:References:User-Agent:X-stable:
	 X-Patchwork-Hint:MIME-Version:Content-Transfer-Encoding; b=sJkvaDGnYAsM2EZ0cjlrE9W3Phq4eq6TvQStnOQYiI07hTenght6kP9Cxsj94qOdkjk2uhlXx6qp/9RZiVGaGH3TEn3xaGhhKutXUdvqvI5ZB+cRZWv84KLCLl0Dz5Tx8K/djCDeDHqR2RdRSpgRFyFHHnIBqeHFx+FDFMgUPAM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=u8pzxHn0; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="u8pzxHn0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 52C43C433F1;
	Thu, 18 Jan 2024 10:56:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705575382;
	bh=gWan/ugkENzO/EXmD8xXYfnWR1nthG88EUGvGr/DtmE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=u8pzxHn0AFuV3G2tyIEWP1qlhwvX6CSf0SvrNxFHLqGirlXxbcO0D4QMY0LYyso5R
	 iL2DozZLRcV4s+8JDEuXi+IL77E+eSodrspv7l8b7Ufct1S3Od2KFiKENuwD6M2zBP
	 jWlFD/0DDvsXEZlMWClXSr+J/Wqp8XQ9IFB/izYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jensen Huang <jensenhuang@friendlyarm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 112/150] i2c: rk3x: fix potential spinlock recursion on poll
Date: Thu, 18 Jan 2024 11:48:54 +0100
Message-ID: <20240118104325.248646850@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240118104320.029537060@linuxfoundation.org>
References: <20240118104320.029537060@linuxfoundation.org>
User-Agent: quilt/0.67
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

From: Jensen Huang <jensenhuang@friendlyarm.com>

[ Upstream commit 19cde9c92b8d3b7ee555d0da3bcb0232d3a784f4 ]

Possible deadlock scenario (on reboot):
rk3x_i2c_xfer_common(polling)
    -> rk3x_i2c_wait_xfer_poll()
        -> rk3x_i2c_irq(0, i2c);
            --> spin_lock(&i2c->lock);
            ...
        <rk3x i2c interrupt>
        -> rk3x_i2c_irq(0, i2c);
            --> spin_lock(&i2c->lock); (deadlock here)

Store the IRQ number and disable/enable it around the polling transfer.
This patch has been tested on NanoPC-T4.

Signed-off-by: Jensen Huang <jensenhuang@friendlyarm.com>
Reviewed-by: Heiko Stuebner <heiko@sntech.de>
Reviewed-by: Andi Shyti <andi.shyti@kernel.org>
Signed-off-by: Wolfram Sang <wsa@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/i2c/busses/i2c-rk3x.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/i2c/busses/i2c-rk3x.c b/drivers/i2c/busses/i2c-rk3x.c
index a044ca0c35a1..4362db7c5789 100644
--- a/drivers/i2c/busses/i2c-rk3x.c
+++ b/drivers/i2c/busses/i2c-rk3x.c
@@ -178,6 +178,7 @@ struct rk3x_i2c_soc_data {
  * @clk: function clk for rk3399 or function & Bus clks for others
  * @pclk: Bus clk for rk3399
  * @clk_rate_nb: i2c clk rate change notify
+ * @irq: irq number
  * @t: I2C known timing information
  * @lock: spinlock for the i2c bus
  * @wait: the waitqueue to wait for i2c transfer
@@ -200,6 +201,7 @@ struct rk3x_i2c {
 	struct clk *clk;
 	struct clk *pclk;
 	struct notifier_block clk_rate_nb;
+	int irq;
 
 	/* Settings */
 	struct i2c_timings t;
@@ -1087,13 +1089,18 @@ static int rk3x_i2c_xfer_common(struct i2c_adapter *adap,
 
 		spin_unlock_irqrestore(&i2c->lock, flags);
 
-		rk3x_i2c_start(i2c);
-
 		if (!polling) {
+			rk3x_i2c_start(i2c);
+
 			timeout = wait_event_timeout(i2c->wait, !i2c->busy,
 						     msecs_to_jiffies(WAIT_TIMEOUT));
 		} else {
+			disable_irq(i2c->irq);
+			rk3x_i2c_start(i2c);
+
 			timeout = rk3x_i2c_wait_xfer_poll(i2c);
+
+			enable_irq(i2c->irq);
 		}
 
 		spin_lock_irqsave(&i2c->lock, flags);
@@ -1310,6 +1317,8 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	i2c->irq = irq;
+
 	platform_set_drvdata(pdev, i2c);
 
 	if (i2c->soc_data->calc_timings == rk3x_i2c_v0_calc_timings) {
-- 
2.43.0



