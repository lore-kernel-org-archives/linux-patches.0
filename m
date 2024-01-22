Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C03A560252;
	Tue, 23 Jan 2024 00:47:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705970869; cv=none; b=cmFjroHHy0/Su8o9KmyFlGWkf+tqMT2NcBKWdzJ3s+iW07xPJZbKTpqlypZTgzjSpM5iXdXfQF8OI+t8c7d8548te1n+19huzcqtusDJiKfIf8GRgezvMiNtZeBNEfFxNfAucuctYN8T/wBxKEtenH9tNKv1kHLOTEfj4na8uDg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705970869; c=relaxed/simple;
	bh=zyT0Ky1w2G1HVCDDlATBMbPk9e17QY438tXbjhTwZug=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dERfRUi1ed09ScpTr4K8hl2FLZKfpAk1PjDTArfsnDw/arO+FLZUPYrLNuomGroImSCKeWs0cUP40xStoCbFf5U4yeNIgJGgY9E993bTQ0TdRUi+xjp7wCFn0OUDXrr0V1jowPFwGULKjEct8fJvMlrgaEfvtXr7g/B5rxTO/N0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WZGrzVJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WZGrzVJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71294C433C7;
	Tue, 23 Jan 2024 00:47:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705970869;
	bh=zyT0Ky1w2G1HVCDDlATBMbPk9e17QY438tXbjhTwZug=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WZGrzVJkBe4HAFBiAjWZo2HCQ+NB3Ejxw18fvq0H6JMpynhelpaRWJPZO4TYnBBPz
	 YmIZjQ3Wxy8gUGFLiuzcprT6R5rXDKJcwWpzpARe4zM5TfVD0eWMifDpHYmqYPlRSP
	 IHvr9kaD+wKBry0RqfnnmBKAkXBhPKHCEbmgnvSY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jensen Huang <jensenhuang@friendlyarm.com>,
	Heiko Stuebner <heiko@sntech.de>,
	Andi Shyti <andi.shyti@kernel.org>,
	Wolfram Sang <wsa@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 035/286] i2c: rk3x: fix potential spinlock recursion on poll
Date: Mon, 22 Jan 2024 15:55:41 -0800
Message-ID: <20240122235733.368503229@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235732.009174833@linuxfoundation.org>
References: <20240122235732.009174833@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index 13c14eb175e9..6abcf975a2db 100644
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
@@ -1301,6 +1308,8 @@ static int rk3x_i2c_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	i2c->irq = irq;
+
 	platform_set_drvdata(pdev, i2c);
 
 	if (i2c->soc_data->calc_timings == rk3x_i2c_v0_calc_timings) {
-- 
2.43.0



