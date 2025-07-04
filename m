Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3237A19F40A;
	Fri,  4 Jul 2025 15:45:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1751643945; cv=none; b=stL9ZdSprs+h8LV6hHyT8cKql1bdIGhg481aEMPsPHkbedUxEk8dGUdRkVKhrjFNqTClVPoHY+x5bFTWjvfFY1hKj5AncOuUj0DeUf2tkKNGaxH7pRIBZ09h0sKQwq5Np70s7rA02UqjRoyBbWhCLAKsIzTKmSkXq0ffV5K8864=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1751643945; c=relaxed/simple;
	bh=9lm9zh+rY3R25ZONGP1EZ6ZiDrYnHo9tcgTDZ4Ofr5k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:Message-ID:
	 MIME-Version:Content-Type; b=ort8FmM1w8JKzvJkA7qFc890UFp7Gd+bPfACkHiyVCTi7I1+46wu800lSLqqbJvwQZzzfcNITv6h8rccULgJzyDcTtQ1nc6CZtUPUqMGpmsrDxQYK6KLsboXWMeHtLLTIJfHnrwewEdChwE3agde8NzpX/COifrLukSBpxU5awc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eyOPmbex; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eyOPmbex"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 612F6C4CEE3;
	Fri,  4 Jul 2025 15:45:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1751643943;
	bh=9lm9zh+rY3R25ZONGP1EZ6ZiDrYnHo9tcgTDZ4Ofr5k=;
	h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
	b=eyOPmbexiptgTyQ0KyjgcW+VJXH6njYzNNYQ6Cu+I50j+cF+Qx67IQC5KovURYIOB
	 kL7Y4X7r+XmKR3gm+5Esz7YQGrY0lM/VHETOQuyxt1oCstm6izsMu2JeE2xDxDjwgq
	 pD/h0nARxBwX38aNI6zZOhj/226OjundB8coQzWQAG01Vpr6hgtBGQb8qZmbAwtZCB
	 C/lNYHgj/MKlNvq7R8V0vwsA++Jb+p5p85bZWFE/xE1/XCGbomIMH/f8vr6dv4+SMK
	 OtaApUoBS9l3ZtNZKIgKwCg042mbjAediFnRISCNfXqNcETCM+F0J/vkuHmlAV3kp8
	 u7EAZaFhMmV2w==
From: Pratyush Yadav <pratyush@kernel.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Pratyush Yadav <pratyush@kernel.org>,  stable@vger.kernel.org,
  patches@lists.linux.dev,  Miquel Raynal <miquel.raynal@bootlin.com>,
  Mark Brown <broonie@kernel.org>,  Sasha Levin <sashal@kernel.org>
Subject: Re: [PATCH 6.12 212/218] spi: spi-mem: Extend spi-mem operations
 with a per-operation maximum frequency
In-Reply-To: <2025070449-scruffy-difficult-5852@gregkh>
References: <20250703143955.956569535@linuxfoundation.org>
	<20250703144004.692234510@linuxfoundation.org>
	<mafs04ivs186o.fsf@kernel.org> <2025070449-scruffy-difficult-5852@gregkh>
Date: Fri, 04 Jul 2025 17:45:41 +0200
Message-ID: <mafs0zfdkyn6i.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13)
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain

On Fri, Jul 04 2025, Greg Kroah-Hartman wrote:

> On Fri, Jul 04, 2025 at 01:55:59PM +0200, Pratyush Yadav wrote:
>> Hi Greg,
>> 
>> On Thu, Jul 03 2025, Greg Kroah-Hartman wrote:
>> 
>> > 6.12-stable review patch.  If anyone has any objections, please let me know.
>> 
>> This and patches 213, 214, and 215 seem to be new features. So why are
>> they being added to a stable release?
>
> It was to get commit 40369bfe717e ("spi: fsl-qspi: use devm function
> instead of driver remove") to apply cleanly.  I'll try removing these to
> see if that commit can still apply somehow...

The conflict resolution seems simple. Perhaps the patch below? (**not
even compile tested**):

--- 8< ---
From 6edae14f9e968fbb5c566dda8055e92cd491a3a6 Mon Sep 17 00:00:00 2001
From: Han Xu <han.xu@nxp.com>
Date: Wed, 26 Mar 2025 17:41:51 -0500
Subject: [PATCH] spi: fsl-qspi: use devm function instead of driver remove

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
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
---
 drivers/spi/spi-fsl-qspi.c | 31 +++++++++++++++++--------------
 1 file changed, 17 insertions(+), 14 deletions(-)

diff --git a/drivers/spi/spi-fsl-qspi.c b/drivers/spi/spi-fsl-qspi.c
index 79bac30e79af6..310350d2c5302 100644
--- a/drivers/spi/spi-fsl-qspi.c
+++ b/drivers/spi/spi-fsl-qspi.c
@@ -839,6 +839,19 @@ static const struct spi_controller_mem_ops fsl_qspi_mem_ops = {
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
@@ -928,6 +941,10 @@ static int fsl_qspi_probe(struct platform_device *pdev)
 
 	ctlr->dev.of_node = np;
 
+	ret = devm_add_action_or_reset(dev, fsl_qspi_cleanup, q);
+	if (ret)
+		goto err_destroy_mutex;
+
 	ret = devm_spi_register_controller(dev, ctlr);
 	if (ret)
 		goto err_destroy_mutex;
@@ -947,19 +964,6 @@ static int fsl_qspi_probe(struct platform_device *pdev)
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
@@ -997,7 +1001,6 @@ static struct platform_driver fsl_qspi_driver = {
 		.pm =   &fsl_qspi_pm_ops,
 	},
 	.probe          = fsl_qspi_probe,
-	.remove_new	= fsl_qspi_remove,
 };
 module_platform_driver(fsl_qspi_driver);
 
-- 
Regards,
Pratyush Yadav
