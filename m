Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 32B3D2949E0;
	Fri, 15 May 2026 16:29:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862583; cv=none; b=LUFtXBK6debA+CX5+pa0jS3ZYkEqK7gS0V3YyGtXynEReUgLToJeM8u5o+qjaF/3v2yhLhPQuL+qLvY15fAV5X1zE+yKL5hIRq9yMbO/OItq7bj/C02ekPG6eYJY109NdE9JO2469zHgdnzvZ3tu07bM8tncGXzMNNgc/euFTkc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862583; c=relaxed/simple;
	bh=08VHu7H/W+0ndZTIT2Bw84AFML76DLy8OAiA0sIk2Sk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R39b2SmZxOZ3az79koZC130ZyMWwhzUpEd864esCxTvJTIrEifbrQy0XaQyxzG/PXLEML6s0OyTIZVh7BuNtvku4SMdjxt8xlPvJq8WDocsIQ/xDJ6rQ3r1WQ3gMXd/0UV+nrUaM4/pjvcUf+fthRNnMsZVo72oWozeAZVQVjsw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=urW4V2w7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="urW4V2w7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BC5C6C2BCB0;
	Fri, 15 May 2026 16:29:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862583;
	bh=08VHu7H/W+0ndZTIT2Bw84AFML76DLy8OAiA0sIk2Sk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=urW4V2w7ZCzpsFcTOZtUkIopbtpXcbIXYnAb7awl+kZb8B7s6G8c4NYGimVHxw3kT
	 M/Co0ShgsowkoBqvkt8xgVXw/+ZG7fv2Dst5WC0lZP9i1zgzmsxfl0vZV0vORiBR5P
	 SE0aqFamhSRyJyYaglcgxLvOmTUCTDUlgDmvyums=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leilk Liu <leilk.liu@mediatek.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 104/201] spi: slave-mt27xx: fix controller deregistration
Date: Fri, 15 May 2026 17:48:42 +0200
Message-ID: <20260515154700.798075981@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154658.538039039@linuxfoundation.org>
References: <20260515154658.538039039@linuxfoundation.org>
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

7.0-stable review patch.  If anyone has any objections, please let me know.

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
@@ -453,7 +453,7 @@ static int mtk_spi_slave_probe(struct pl
 
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	clk_disable_unprepare(mdata->spi_clk);
 	if (ret) {
 		dev_err(&pdev->dev,
@@ -473,7 +473,15 @@ err_put_ctlr:
 
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


