Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 373F82609EE;
	Fri, 15 May 2026 16:21:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862108; cv=none; b=UY3pIy3kr6xzsMYd64Uq6jSRZd/Uejlk+Lxm35oxobXeamABQ07IsavH4B8/1ufmq7vtF3q86XHqQtwZ3z1SEoU+DktmdfK/LSxs3sB8x6kvF4Pf6r0apzLCvibGI0Riwz8T7eG2TvS64OzRO7a6YqdoRBcbBavRxP77g7goqo0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862108; c=relaxed/simple;
	bh=Yz+fF4wb5TErlmsoEyFSs/L45yCUc7L5mTD9cIGAo0I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=khz4PRhCLInWWJMBGsZ3Ws9pEnIt0NF1RWkg1mDcP71dGZ+8SePCjq+HDsxYb0oHwK1mv4106bE8xqrGtLPxQC8Cxc+ePXRz44AIpyiwJnDA7VgIKtiRHKfcz89yballv9hS43JQ0rimqqXkspDuzXfI8ckiIgRw15bdJapux3I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Gh4uLSw3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Gh4uLSw3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C208EC2BCB0;
	Fri, 15 May 2026 16:21:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862108;
	bh=Yz+fF4wb5TErlmsoEyFSs/L45yCUc7L5mTD9cIGAo0I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Gh4uLSw38K6kYIdk1Y0yqS4nGbUxdCpGvhY/y0820WgXV6NXo6h3cwArXmS1FvhGS
	 i3cNqVJtnvS3NqKrbYL7FH9+rc+CqyIsayHfKcX1+EneupOpi0G/WGXHJT8woxQYaz
	 +ofJkbjsSnX+F/xNEOa8SrEIydR5eRUz/W+eizn4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chuanhong Guo <gch981213@gmail.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 070/188] spi: mtk-nor: fix controller deregistration
Date: Fri, 15 May 2026 17:48:07 +0200
Message-ID: <20260515154658.837639931@linuxfoundation.org>
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
 
@@ -939,6 +939,8 @@ static void mtk_nor_remove(struct platfo
 	struct spi_controller *ctlr = dev_get_drvdata(&pdev->dev);
 	struct mtk_nor *sp = spi_controller_get_devdata(ctlr);
 
+	spi_unregister_controller(ctlr);
+
 	pm_runtime_disable(&pdev->dev);
 	pm_runtime_set_suspended(&pdev->dev);
 	pm_runtime_dont_use_autosuspend(&pdev->dev);


