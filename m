Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 520DA311967;
	Sat, 12 Sep 2026 19:10:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789240256; cv=none; b=G6QdSROoCu7iQDL6GQ8W+QJbIDknaJ/AUrmQldcf02SdeqCPGxrRHweb8nGugZhJZGMphl4hWqFPvOL80ONAOYRsgJQeSyrF1+kfgY8+z/8YeDztecwTq7iDUb/Yz3HLGH/Pjy8L2hx0GUmqCy/0I91oY8jQ1FQvrsFlqc72c5E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789240256; c=relaxed/simple;
	bh=KcWslLr9oLYTzMYuFg9jBoLOq8W0a4xPbV+Bd96KrPU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eZK3rKjv5yW6vf1wHGqXxmaaP/MUzbNfK7COLv0wqc2ShLqIdwppmnlzXsn3qCqdpPppBlWYnJjNNhSxSltLnSjs4KwkB0O4LOghAip2PeOJ7m1NPjyBE6cAdDehHebWuEgdlfioN+pDmadfOxQ1x2J7Wcq/am9oRqz6t/PG1QM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=q+Mq3HsH; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="q+Mq3HsH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 137261F000FF;
	Sat, 12 Sep 2026 19:10:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789240254;
	bh=L7tYCSvrCWLBtGjUjJtKFRrMoCP+qtgQ/YorwGPUIP8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q+Mq3HsHkkhGu5jSU29acvy2TJSiXmQ7JS1q4RKJiuwMh/WxVmYPuKiO34YjVuKIi
	 7JdqDK5rhagDmOaW56x83hycFnw1HojWZr4/OqblxmpjBIO7urgxbd1A6ekw10QFi9
	 8dcdWF19JPBVO4k990rLX+BzSRSylWNxgo+33Ykw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linmao Li <lilinmao@kylinos.cn>,
	Jassi Brar <jassisinghbrar@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 831/935] mailbox: rockchip: disable pclk on probe failure and unbind
Date: Sat, 12 Sep 2026 09:04:21 +0200
Message-ID: <20260912065545.884069379@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linmao Li <lilinmao@kylinos.cn>

[ Upstream commit ded48fcbdc1e3ed1dc8e1974b7fe9639fcea6dd6 ]

rockchip_mbox_probe() enables the peripheral clock and then keeps going.
None of the later failure paths - platform_get_irq(),
devm_request_threaded_irq() and devm_mbox_controller_register() - disables
it again. The driver has no remove callback either, so the clock also stays
prepared and enabled once the device is unbound, and its enable count keeps
growing over bind/unbind cycles.

Use devm_clk_get_enabled() to tie disabling and unpreparing the clock to
the device lifetime. It is registered before the interrupts and the mailbox
controller, so devres releases it after both are gone.

While rewriting the error path, switch it to dev_err_probe() so that a
deferred probe is not reported as an error.

Fixes: f70ed3b5dc8b ("mailbox: rockchip: Add Rockchip mailbox driver")
Signed-off-by: Linmao Li <lilinmao@kylinos.cn>
Signed-off-by: Jassi Brar <jassisinghbrar@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mailbox/rockchip-mailbox.c | 17 ++++-------------
 1 file changed, 4 insertions(+), 13 deletions(-)

diff --git a/drivers/mailbox/rockchip-mailbox.c b/drivers/mailbox/rockchip-mailbox.c
index ca50f7f176f6a..e0e9ba8f89993 100644
--- a/drivers/mailbox/rockchip-mailbox.c
+++ b/drivers/mailbox/rockchip-mailbox.c
@@ -207,19 +207,10 @@ static int rockchip_mbox_probe(struct platform_device *pdev)
 	/* Each channel has two buffers for A2B and B2A */
 	mb->buf_size = (size_t)resource_size(res) / (drv_data->num_chans * 2);
 
-	mb->pclk = devm_clk_get(&pdev->dev, "pclk_mailbox");
-	if (IS_ERR(mb->pclk)) {
-		ret = PTR_ERR(mb->pclk);
-		dev_err(&pdev->dev, "failed to get pclk_mailbox clock: %d\n",
-			ret);
-		return ret;
-	}
-
-	ret = clk_prepare_enable(mb->pclk);
-	if (ret) {
-		dev_err(&pdev->dev, "failed to enable pclk: %d\n", ret);
-		return ret;
-	}
+	mb->pclk = devm_clk_get_enabled(&pdev->dev, "pclk_mailbox");
+	if (IS_ERR(mb->pclk))
+		return dev_err_probe(&pdev->dev, PTR_ERR(mb->pclk),
+				     "failed to get and enable pclk_mailbox clock\n");
 
 	for (i = 0; i < mb->mbox.num_chans; i++) {
 		irq = platform_get_irq(pdev, i);
-- 
2.53.0



