Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7081D175A87;
	Fri, 15 May 2026 15:52:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860325; cv=none; b=HYqidC1n5QmDCK+4UBJKnFbv1kyeotZDJWj+Lz2jSZyjI9PKvZCR7ZsZnOk7lXO6PjsgoBFNEX3YZtxQgSNr/mTa88iUP3MgdqoFaWvWQUMF1zvy9dLIWBfAqkRJYOWobXZv+JQmQfKNzaWiofyOxGr+cvQ9JHrmOOnYleuDvCk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860325; c=relaxed/simple;
	bh=pBWO4+UkxaS7LbhHK5jVA36Vp+eeTn0IFWz3nRTxpNY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtDa6Ng/P/X0hiDZ0a8yl6OhWZSeJHvG+22w9xHZJzx7P4odc9nrBNEcUkrwhPPqYO1NXo+wbI9kcvso2I75rlYkKqQ6NmFc9D29nD4DhRA2LjiIupo33xbgKEv/53ef7xYtgMF4i07VSFG9uCUtNAjI0gw8c8mJ2ecmMJOK7OQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JacRbZmG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JacRbZmG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7FF9AC2BCF7;
	Fri, 15 May 2026 15:52:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860325;
	bh=pBWO4+UkxaS7LbhHK5jVA36Vp+eeTn0IFWz3nRTxpNY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JacRbZmGuuz/za06WCYjIcVUCorcNlYV1mPjQ8Z5KBuBdfXu0Rlf/U9FJyEnl1vUV
	 jTxp2LpO5PmKg8Y89uOYBCGQNMAd/4P7PBSs5PSpPilXY1YfITd2uh8LWDux1s6gz2
	 BNB9/L8BQT3VaIwCutAupK3vEMfiPr4xyLcZ86UY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 044/144] spi: mtk-nor: fix controller deregistration
Date: Fri, 15 May 2026 17:47:50 +0200
Message-ID: <20260515154654.551504074@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154653.469907118@linuxfoundation.org>
References: <20260515154653.469907118@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
@@ -914,7 +914,7 @@ static int mtk_nor_probe(struct platform
 	pm_runtime_enable(&pdev->dev);
 	pm_runtime_get_noresume(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret < 0)
 		goto err_probe;
 
@@ -940,6 +940,8 @@ static void mtk_nor_remove(struct platfo
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


