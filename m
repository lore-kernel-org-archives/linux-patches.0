Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3FE122EF652;
	Sat, 30 May 2026 18:34:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780166093; cv=none; b=cffr4Hv05BkzJLHxCgZ6b8fOBkuU7BLkHPlfRuKOFiQRVX4ie4tHvLdR14fpGsCAcDhG4l2I8amULXjLlnSvAUsfHRSZlPC7H/LrFFL34+bZQtkw/CWQCtvBgZ+9jLjGji3XIE9k4TvxC0ieOOnNntd5Yxt48wwSLNV28foqISc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780166093; c=relaxed/simple;
	bh=xz8KBB3laHtWQ8zripPPa656JX4Hy/YN/1X5vpi9Ev0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=fbPo0W60GTqvGOSolDm3SoSxuw5HMBCU0fqo1H9Bh+Eal384K1VPZrQ6UD6in9FwlROfpFCmg3ihYKST4pq31yLETHUhhNtMeJ7NNyq9gcyxlFx0tKz6iHFvSpNG9/T/VA37zI2qHselkPIU+PkaPf4EaryRFqE4/lmU4a9/J4Q=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G9bm2ncl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G9bm2ncl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 804DE1F00893;
	Sat, 30 May 2026 18:34:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780166092;
	bh=wJZoLATgYQ/Iuq8aJTBzz5Ah8Rp+MhAj6pYLqs51guw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=G9bm2ncluTq5OvSZBqNPLkFDZ+Sye7fb9qvPyltAO0RL4pZ67WHFCRsYjgIveZ/3K
	 sJYbNVjj5hyidM6wUiPueMKaYezItiDxSG1YsG4agB0voyIczB2YIw8rYFbw2zXpmW
	 8oJXLu+kxKG+2YKvTLKpuppUxEVfEn4wSoxT3N88=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.10 270/589] spi: mtk-nor: fix controller deregistration
Date: Sat, 30 May 2026 18:02:31 +0200
Message-ID: <20260530160232.079658724@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160224.570625122@linuxfoundation.org>
References: <20260530160224.570625122@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Johan Hovold <johan@kernel.org>

commit 76336f24934621db286cabb20b483773ee01dcaa upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 881d1ee9fe81 ("spi: add support for mediatek spi-nor controller")
Cc: stable@vger.kernel.org	# 5.7
Cc: Chuanhong Guo <gch981213@gmail.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-3-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-mtk-nor.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-mtk-nor.c
+++ b/drivers/spi/spi-mtk-nor.c
@@ -835,7 +835,7 @@ static int mtk_nor_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0)
 		goto err_probe;
 
@@ -861,6 +861,8 @@ static int mtk_nor_remove(struct platfor
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


