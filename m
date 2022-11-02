Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D9C2B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 03:16:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1029C433C1;
	Wed,  2 Nov 2022 03:16:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667359019;
	bh=L1/g0wUi8BoqUKPivCprXmieUwYWV9jkqxHWCe6DoOo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qyZXhkSd+bwlrp4h15dSewWoT9PzMlCtTRR96bOSh4BF1kvSY5qVwEN+hES52TDdE
	 3uavsRwYE3PtSnhP2p4lqwzXYElaMm8HELijV40KtfUaGlCzv1/SJFLRXqCdwSKsCt
	 kuvNm//SyaPGeSnbany67d6hI06pWQ9Jsf35y4yc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dongliang Mu <dzm91@hust.edu.cn>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 62/91] can: mcp251x: mcp251x_can_probe(): add missing unregister_candev() in error path
Date: Wed,  2 Nov 2022 03:33:45 +0100
Message-Id: <20221102022056.792731036@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022055.039689234@linuxfoundation.org>
References: <20221102022055.039689234@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dongliang Mu <dzm91@hust.edu.cn>

[ Upstream commit b1a09b63684cea56774786ca14c13b7041ffee63 ]

In mcp251x_can_probe(), if mcp251x_gpio_setup() fails, it forgets to
unregister the CAN device.

Fix this by unregistering can device in mcp251x_can_probe().

Fixes: 2d52dabbef60 ("can: mcp251x: add GPIO support")
Signed-off-by: Dongliang Mu <dzm91@hust.edu.cn>
Link: https://lore.kernel.org/all/20221024090256.717236-1-dzm91@hust.edu.cn
[mkl: adjust label]
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/spi/mcp251x.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/can/spi/mcp251x.c b/drivers/net/can/spi/mcp251x.c
index 5dde3c42d241..ffcb04aac972 100644
--- a/drivers/net/can/spi/mcp251x.c
+++ b/drivers/net/can/spi/mcp251x.c
@@ -1419,11 +1419,14 @@ static int mcp251x_can_probe(struct spi_device *spi)
 
 	ret = mcp251x_gpio_setup(priv);
 	if (ret)
-		goto error_probe;
+		goto out_unregister_candev;
 
 	netdev_info(net, "MCP%x successfully initialized.\n", priv->model);
 	return 0;
 
+out_unregister_candev:
+	unregister_candev(net);
+
 error_probe:
 	destroy_workqueue(priv->wq);
 	priv->wq = NULL;
-- 
2.35.1



