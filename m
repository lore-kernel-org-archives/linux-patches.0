Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9E7671C29
	for <patches@lists.linux.dev>; Wed, 23 Nov 2022 09:19:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EC9A8C433C1;
	Wed, 23 Nov 2022 09:19:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669195147;
	bh=lsMZlUJMxJ34d4h3ylrNWXuIl2QPP7Luvb1IvJC3YwI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=URX9R7ZRzRb8qPN0MU7CbjMiCDrwm5yVrtDS13AZlryld/TN+Y1YriV6715BcXeP6
	 Nihxu/5akxIyETlSSWZOMLdLRUD7SurQ6J21TQ0JucX9ftq8tadQbL7mszwGsKjfsI
	 PYYSVmW37IUCJV9PTQfsGq82u5KvaTLar3MCJELw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable <stable@kernel.org>,
	=?UTF-8?q?Ilpo=20J=C3=A4rvinen?= <ilpo.jarvinen@linux.intel.com>,
	Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Subject: [PATCH 5.4 131/156] serial: 8250_lpss: Configure DMA also w/o DMA filter
Date: Wed, 23 Nov 2022 09:51:28 +0100
Message-Id: <20221123084602.667330997@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221123084557.816085212@linuxfoundation.org>
References: <20221123084557.816085212@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>

commit 1bfcbe5805d0cfc83c3544dcd01e0a282c1f6790 upstream.

If the platform doesn't use DMA device filter (as is the case with
Elkhart Lake), whole lpss8250_dma_setup() setup is skipped. This
results in skipping also *_maxburst setup which is undesirable.
Refactor lpss8250_dma_setup() to configure DMA even if filter is not
setup.

Cc: stable <stable@kernel.org>
Signed-off-by: Ilpo Järvinen <ilpo.jarvinen@linux.intel.com>
Reviewed-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Link: https://lore.kernel.org/r/20221108121952.5497-3-ilpo.jarvinen@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/tty/serial/8250/8250_lpss.c |   15 +++++++++++----
 1 file changed, 11 insertions(+), 4 deletions(-)

--- a/drivers/tty/serial/8250/8250_lpss.c
+++ b/drivers/tty/serial/8250/8250_lpss.c
@@ -258,8 +258,13 @@ static int lpss8250_dma_setup(struct lps
 	struct dw_dma_slave *rx_param, *tx_param;
 	struct device *dev = port->port.dev;
 
-	if (!lpss->dma_param.dma_dev)
+	if (!lpss->dma_param.dma_dev) {
+		dma = port->dma;
+		if (dma)
+			goto out_configuration_only;
+
 		return 0;
+	}
 
 	rx_param = devm_kzalloc(dev, sizeof(*rx_param), GFP_KERNEL);
 	if (!rx_param)
@@ -270,16 +275,18 @@ static int lpss8250_dma_setup(struct lps
 		return -ENOMEM;
 
 	*rx_param = lpss->dma_param;
-	dma->rxconf.src_maxburst = lpss->dma_maxburst;
-
 	*tx_param = lpss->dma_param;
-	dma->txconf.dst_maxburst = lpss->dma_maxburst;
 
 	dma->fn = lpss8250_dma_filter;
 	dma->rx_param = rx_param;
 	dma->tx_param = tx_param;
 
 	port->dma = dma;
+
+out_configuration_only:
+	dma->rxconf.src_maxburst = lpss->dma_maxburst;
+	dma->txconf.dst_maxburst = lpss->dma_maxburst;
+
 	return 0;
 }
 


