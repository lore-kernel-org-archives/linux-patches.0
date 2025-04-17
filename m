Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0EF4A8462;
	Thu, 17 Apr 2025 18:36:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744914999; cv=none; b=tGvL9JczhPP4wH2QDBDUkkDzXcMUpnmCTaKxV2w7tGtiE56yEhddLcyl+xWmjW+1g/VMEEioHUWgkIpwD6zSF0Z855F4fAGBWRs/b6/bYiPLPnoK0gVQvNJzoFI9kg1+uuxF3XDcVeGeeDnkTDeI26aEhO2UVlS0NOAe+iua+2s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744914999; c=relaxed/simple;
	bh=QWwYg10vtWwmP7+MescVksk0RxQGo2IdVp96FK8bE/0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kYKhKJueZkcGAcybqzmeppTXrgvmqL/bnfNYySqUrJfgc0wjBxYiI88I6qtQfBWKPmTAxoHoxOpQqwWiTRcXUDiWho1imwKoZx2SbcCZxNFbdJBbpYgtFgHgzy4/PPiXNM7qHUYzZQEmQ7kLva1HRfTkUB1nWXfJAflAKx/HIjg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LB/tZn4Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LB/tZn4Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A688C4CEE4;
	Thu, 17 Apr 2025 18:36:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744914998;
	bh=QWwYg10vtWwmP7+MescVksk0RxQGo2IdVp96FK8bE/0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LB/tZn4ZpKlovMmwjJdnk72gbednE2Tcupsj55qvHheSzciA6VOWnh2Y28kNHdaPa
	 AJMSeBS3clcokCnEl9BI0TD+JQ+o4YTVat4GZSrMjeCAi2f0Nw1A7zcf01MapLGXmo
	 uf+AEsa+35KiJLBymQAPJs62IBzjWj5rSMxq2bNc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kevin Hao <haokexin@gmail.com>,
	Han Xu <han.xu@nxp.com>,
	Frank Li <Frank.Li@nxp.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.13 400/414] spi: fsl-qspi: use devm function instead of driver remove
Date: Thu, 17 Apr 2025 19:52:38 +0200
Message-ID: <20250417175127.569946604@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Han Xu <han.xu@nxp.com>

commit 40369bfe717e96e26650eeecfa5a6363563df6e4 upstream.

Driver use devm APIs to manage clk/irq/resources and register the spi
controller, but the legacy remove function will be called first during
device detach and trigger kernel panic. Drop the remove function and use
devm_add_action_or_reset() for driver cleanup to ensure the release
sequence.

Trigger kernel panic on i.MX8MQ by
echo 30bb0000.spi >/sys/bus/platform/drivers/fsl-quadspi/unbind

Cc: stable@vger.kernel.org
Fixes: 8fcb830a00f0 ("spi: spi-fsl-qspi: use devm_spi_register_controller")
Reported-by: Kevin Hao <haokexin@gmail.com>
Signed-off-by: Han Xu <han.xu@nxp.com>
Reviewed-by: Frank Li <Frank.Li@nxp.com>
Link: https://patch.msgid.link/20250326224152.2147099-1-han.xu@nxp.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-fsl-qspi.c |   31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -839,6 +839,19 @@ static const struct spi_controller_mem_o
 	.get_name = fsl_qspi_get_name,
 };
 
+static void fsl_qspi_cleanup(void *data)
+{
+	struct fsl_qspi *q = data;
+
+	/* disable the hardware */
+	qspi_writel(q, QUADSPI_MCR_MDIS_MASK, q->iobase + QUADSPI_MCR);
+	qspi_writel(q, 0x0, q->iobase + QUADSPI_RSER);
+
+	fsl_qspi_clk_disable_unprep(q);
+
+	mutex_destroy(&q->lock);
+}
+
 static int fsl_qspi_probe(struct platform_device *pdev)
 {
 	struct spi_controller *ctlr;
@@ -928,6 +941,10 @@ static int fsl_qspi_probe(struct platfor
 
 	ctlr->dev.of_node = np;
 
+	ret = devm_add_action_or_reset(dev, fsl_qspi_cleanup, q);
+	if (ret)
+		goto err_destroy_mutex;
+
 	ret = devm_spi_register_controller(dev, ctlr);
 	if (ret)
 		goto err_destroy_mutex;
@@ -947,19 +964,6 @@ err_put_ctrl:
 	return ret;
 }
 
-static void fsl_qspi_remove(struct platform_device *pdev)
-{
-	struct fsl_qspi *q = platform_get_drvdata(pdev);
-
-	/* disable the hardware */
-	qspi_writel(q, QUADSPI_MCR_MDIS_MASK, q->iobase + QUADSPI_MCR);
-	qspi_writel(q, 0x0, q->iobase + QUADSPI_RSER);
-
-	fsl_qspi_clk_disable_unprep(q);
-
-	mutex_destroy(&q->lock);
-}
-
 static int fsl_qspi_suspend(struct device *dev)
 {
 	return 0;
@@ -997,7 +1001,6 @@ static struct platform_driver fsl_qspi_d
 		.pm =   &fsl_qspi_pm_ops,
 	},
 	.probe          = fsl_qspi_probe,
-	.remove		= fsl_qspi_remove,
 };
 module_platform_driver(fsl_qspi_driver);
 


