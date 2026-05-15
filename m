Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EDFEA26CE11;
	Fri, 15 May 2026 16:20:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862036; cv=none; b=oePhqCUnL+8wK+zPUGsKdWY90hOO48qThMDYNkOiB4bfFJ6f8aAWcmjX3SOoKf3ke+mYRM0pNZenM8ASxwZCpM/A8biS9DtVS8lynHHAclDHRyxVuyBWxczRebJolW4yZcM1Y/1Hg0Yo/sTJ3RtDBqbo+dUriDdY+OzEYtMDqz4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862036; c=relaxed/simple;
	bh=fXT8ouSEEcqvS5Q34rDS77XlTp/EOoki0RDbLBDGI30=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fkVDDeGHlbECXNRlLBoFxsq8M/SKJRNTE8DGCTkGXWrlLqZH6jSIjRn26tpYIa9zTxT0cqLlFyZnk7QY8LpsBOfwXTLyhihFiDkjuEhY+zBQjfR/XLFWz8Rflylq75//e4tUbK81b+a/iDI5thFUsOb1BSg1zTyQY7I6ySHnHwk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=R78CkcLn; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="R78CkcLn"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5D4F1C2BCB0;
	Fri, 15 May 2026 16:20:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862035;
	bh=fXT8ouSEEcqvS5Q34rDS77XlTp/EOoki0RDbLBDGI30=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=R78CkcLn9Ft8F3XRDuFzs37+C3dRTelCgLplRsLWdSIL734MaJscBbdAnaGrDy2Ao
	 FgF30Y9whHtUN//F+kvNDT8DutoQ6zPuT+vhwvZvrjA3AibU4GmYzYBHZ5MnKHLJyc
	 wItryRU0gvQqNOuqJAez9Kg80Nvgz0pfpz/InXXw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leilk Liu <leilk.liu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 083/188] spi: slave-mt27xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:20 +0200
Message-ID: <20260515154659.123853114@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154657.309489048@linuxfoundation.org>
References: <20260515154657.309489048@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit ab840cbda4fe6c40e52f6415c47056797c663bb2 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks (by disabling runtime PM) during driver unbind.

Fixes: 805be7ddf367 ("spi: mediatek: add spi slave for Mediatek MT2712")
Cc: stable@vger.kernel.org	# 4.20
Cc: Leilk Liu <leilk.liu@mediatek.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-16-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-slave-mt27xx.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-slave-mt27xx.c
+++ b/drivers/spi/spi-slave-mt27xx.c
@@ -454,7 +454,7 @@ static int mtk_spi_slave_probe(struct pl
 
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	clk_disable_unprepare(mdata->spi_clk);
 	if (ret) {
 		dev_err(&pdev->dev,
@@ -474,7 +474,15 @@ err_put_ctlr:
 
 static void mtk_spi_slave_remove(struct platform_device *pdev)
 {
+	struct spi_controller *ctlr = platform_get_drvdata(pdev);
+
+	spi_controller_get(ctlr);
+
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(ctlr);
 }
 
 #ifdef CONFIG_PM_SLEEP


