Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2E79B34041A;
	Sat, 30 May 2026 17:57:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1780163876; cv=none; b=gU5inqF5ULpma5PJ2jNkok4DVj+yrSLP/hu0S7lbAST9aBhOsL7CwwN0ZIZlPwdWvfvtma/4YpDp1JIjOmK516mt4FYpWTg+zhqqg9bU+BlVZDEPiYVrkMt6evGbnHlemhAmitXlillucHM38RzgAG1x09wChqSXER7fNDsrUsA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1780163876; c=relaxed/simple;
	bh=Ndqo4upwnOiy+2cXxExlmcGeqKl+2CM7aDNPENoxhFU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=plT0CcUZgu/Az0fj4CH+8gbSh0TJq2QMFFeiM4iNoSxPXZC+2O8gSlAPMs1zNcwoepK+le+kWE6FFZQtpggfRmZueOBZS58Na79y9j4kqM+qoDoy+kzFaDSZTxMmcvRsKUQQWARFJXqjFqmRliY39acWDiLgw2pxnJQDlZSWpFM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jDhh8Kzz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jDhh8Kzz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 721B91F00893;
	Sat, 30 May 2026 17:57:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1780163875;
	bh=9laGVbwwYK3rgmbOg8RrinPZc8iIQc8L2Iw6N0myS14=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jDhh8Kzz62LK8EX3zDasUTFD2LZcTNJD+U3rSy7JnCSe/Jdy5l4yYEAEr5sfYwara
	 DSWrz8/39d55BHbO0y1HTFjC28VnntUfYQ0ELKAgqNzRvLmm/BvVUnE738g9QBddNs
	 AJCqyDGVZY0QxjF7YNyGBuFRhf+kcmvuasAPtfhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 5.15 361/776] spi: mtk-nor: fix controller deregistration
Date: Sat, 30 May 2026 18:01:15 +0200
Message-ID: <20260530160249.900610792@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260530160240.228940103@linuxfoundation.org>
References: <20260530160240.228940103@linuxfoundation.org>
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
@@ -849,7 +849,7 @@ static int mtk_nor_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0)
 		goto err_probe;
 
@@ -875,6 +875,8 @@ static int mtk_nor_remove(struct platfor
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


