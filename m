Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 894E33F58FC;
	Fri, 15 May 2026 16:10:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861452; cv=none; b=oYaA14OtvU93lwK/EHawFWwFVoJaa0Fv4BCd9yjngGCr7T57736yQF/sKo3CXtc4KILc2n8/Uu1vXxm46RR2LnnweCTqw/gG55lNEURvaOb5/65fGNLpENx/O4qE5J2z0zYUn1qZ5b7xFvrxU26vDYCo39coKcTxxPFyJIK6rZw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861452; c=relaxed/simple;
	bh=gXkYUa/Fz8Y6jtbwMkaP6abNU/mzFJkNmQBecczy0gM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BzbaV1AClOpTAiRFR8PD8pj5wlso6Vb/N7jftyuEmp61uUd4VCGJXVMjscRPjx0wlrdNxU1NDbwIlSnSFdfKwFBtAMn4+74Sw/8yhsModBPZUR9AunZqr2KqX52LIhIZjdnN9hITgeZgDPWFS+ljEmQOXbcoEdzL7jrabC/MKQ8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=cW4PklZx; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="cW4PklZx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 212C5C2BCB0;
	Fri, 15 May 2026 16:10:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861452;
	bh=gXkYUa/Fz8Y6jtbwMkaP6abNU/mzFJkNmQBecczy0gM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=cW4PklZxv7Wjr7M1k49Wnc4UA1F9M3FJ4J1zqRxYAgXKKqD1MozlKvxqGA2v2RtHv
	 R0GErKHEebvWYCKctSJDDiUGgPBuxUiQVzu+hvtIm/MeyttSSLNTq8CI6uvefRa7Qb
	 /RNHyihgP+zg8pvT9c/RSld+HUf51KMv1K8N8yLo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jingoo Han <jg1.han@samsung.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 332/474] spi: rspi: fix controller deregistration
Date: Fri, 15 May 2026 17:47:21 +0200
Message-ID: <20260515154722.196435705@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 9944fa6726afb1e6eb7e2212764e7da0c97f2dcc upstream.

Make sure to deregister the controller before releasing underlying
resources like DMA during driver unbind.

Fixes: 9e03d05eee4c ("spi: rcar: Use devm_spi_register_master()")
Cc: stable@vger.kernel.org	# 3.14
Cc: Jingoo Han <jg1.han@samsung.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-11-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-rspi.c |   10 ++++++++--
 1 file changed, 8 insertions(+), 2 deletions(-)

--- a/drivers/spi/spi-rspi.c
+++ b/drivers/spi/spi-rspi.c
@@ -1176,8 +1176,14 @@ static void rspi_remove(struct platform_
 {
 	struct rspi_data *rspi = platform_get_drvdata(pdev);
 
+	spi_controller_get(rspi->ctlr);
+
+	spi_unregister_controller(rspi->ctlr);
+
 	rspi_release_dma(rspi->ctlr);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(rspi->ctlr);
 }
 
 static const struct spi_ops rspi_ops = {
@@ -1387,9 +1393,9 @@ static int rspi_probe(struct platform_de
 	if (ret < 0)
 		dev_warn(&pdev->dev, "DMA not available, using PIO\n");
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0) {
-		dev_err(&pdev->dev, "devm_spi_register_controller error.\n");
+		dev_err(&pdev->dev, "failed to register controller\n");
 		goto error3;
 	}
 


