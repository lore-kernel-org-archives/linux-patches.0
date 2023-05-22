Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 00F48171A9
	for <patches@lists.linux.dev>; Mon, 22 May 2023 19:48:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7229DC4339B;
	Mon, 22 May 2023 19:48:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1684784887;
	bh=6zucVjGLwXPUJQyX3e7Bmk09Yq9AKbWIRmnBydL7Iz0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WJAqJA4PclUdCYcTNj+eWTaE6bDkPFS5wqmOnEokuUgdlNCNWKRSsguu+71S+3l6h
	 IabnWgOIHKMnTuXFfA0D8GidPMIsn1VLu+wFUJCzyhc0ix4uSen5h1m/XmQnWyFsqx
	 sMXjwdg6J3J+yGMgVapqEqo+P9PViH1IJ8e8EYvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	XuDong Liu <m202071377@hust.edu.cn>,
	Doug Berger <opendmb@gmail.com>,
	Florian Fainelli <f.fainelli@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 235/364] serial: 8250_bcm7271: balance clk_enable calls
Date: Mon, 22 May 2023 20:09:00 +0100
Message-Id: <20230522190418.577222728@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230522190412.801391872@linuxfoundation.org>
References: <20230522190412.801391872@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Doug Berger <opendmb@gmail.com>

[ Upstream commit 8a3b5477256a54ae4a470dcebbcf8cdc18e4696d ]

The sw_baud clock must be disabled when the device driver is not
connected to the device. This now occurs when probe fails and
upon remove.

Fixes: 41a469482de2 ("serial: 8250: Add new 8250-core based Broadcom STB driver")
Reported-by: XuDong Liu <m202071377@hust.edu.cn>
Link: https://lore.kernel.org/lkml/20230424125100.4783-1-m202071377@hust.edu.cn/
Signed-off-by: Doug Berger <opendmb@gmail.com>
Acked-by: Florian Fainelli <f.fainelli@gmail.com>
Link: https://lore.kernel.org/r/20230427181916.2983697-2-opendmb@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/tty/serial/8250/8250_bcm7271.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_bcm7271.c b/drivers/tty/serial/8250/8250_bcm7271.c
index f801b1f5b46c0..90ee7bc12f77b 100644
--- a/drivers/tty/serial/8250/8250_bcm7271.c
+++ b/drivers/tty/serial/8250/8250_bcm7271.c
@@ -1032,7 +1032,7 @@ static int brcmuart_probe(struct platform_device *pdev)
 	if (clk_rate == 0) {
 		dev_err(dev, "clock-frequency or clk not defined\n");
 		ret = -EINVAL;
-		goto release_dma;
+		goto err_clk_disable;
 	}
 
 	dev_dbg(dev, "DMA is %senabled\n", priv->dma_enabled ? "" : "not ");
@@ -1119,6 +1119,8 @@ static int brcmuart_probe(struct platform_device *pdev)
 	serial8250_unregister_port(priv->line);
 err:
 	brcmuart_free_bufs(dev, priv);
+err_clk_disable:
+	clk_disable_unprepare(baud_mux_clk);
 release_dma:
 	if (priv->dma_enabled)
 		brcmuart_arbitration(priv, 0);
@@ -1133,6 +1135,7 @@ static int brcmuart_remove(struct platform_device *pdev)
 	hrtimer_cancel(&priv->hrt);
 	serial8250_unregister_port(priv->line);
 	brcmuart_free_bufs(&pdev->dev, priv);
+	clk_disable_unprepare(priv->baud_mux_clk);
 	if (priv->dma_enabled)
 		brcmuart_arbitration(priv, 0);
 	return 0;
-- 
2.39.2



