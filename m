Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE3713F9293;
	Fri, 15 May 2026 16:27:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862445; cv=none; b=AwYaQSGtJJN2QReLXKCgv4GwqduY5sXeU3ESjBuupHqTE3KeIl/bBbgU4YBF01/5vg86kxOUwQmrJmV+a3sUzjAomvfCMui2doHyXjo2U53vBz2aCPwnVrSCohZF1y/UwkMre1Ga6FSUV0T8nIFrd+T8ql+5K+r4yEfstDSDo4w=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862445; c=relaxed/simple;
	bh=9Xs90yG3CjkCHcZntF0dXBEfD+edt0XQJtBxcaeN5vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XnPWVHoW42eQn9JmMGO+9MWocmYhZQA/wKPf9SC5pjlDJzVwx0Erh1/7CbRcixMbzofJl/eGI+pLxP5IsQeDBLGTOLF6HA3mkzF4eSBM16zSGHKR6ANM7m49npmBUThgtNW8Fpa7bDIIIca5+xgHC/GH9N/PYgSXfIXpD/tAT40=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zxWXjiks; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zxWXjiks"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 48AA0C2BCB0;
	Fri, 15 May 2026 16:27:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862445;
	bh=9Xs90yG3CjkCHcZntF0dXBEfD+edt0XQJtBxcaeN5vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zxWXjiks0yVMitg7LGwor5zrZK+XSVZwRV/86zxiG/rXFLVtLrS9MgoJTg6k49IFD
	 mMOv767Wzt7BHz1nyXkP9QZ/3YF3UsqkzwMi7gO/ienwB23zM5VLmeR+6eR2UjW8Uu
	 xWLwUdxNGDlng3NuHlpKmxnDrKA+9+WfWWganzTg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 052/201] spi: qup: fix controller deregistration
Date: Fri, 15 May 2026 17:47:50 +0200
Message-ID: <20260515154659.662636706@linuxfoundation.org>
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

commit 443e3a0005a4342b218b6dbd4c6387d3c7fed85a upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: 64ff247a978f ("spi: Add Qualcomm QUP SPI controller support")
Cc: stable@vger.kernel.org	# 3.15
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-10-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-qup.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-qup.c
+++ b/drivers/spi/spi-qup.c
@@ -1193,7 +1193,7 @@ static int spi_qup_probe(struct platform
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -1320,6 +1320,10 @@ static void spi_qup_remove(struct platfo
 	struct spi_qup *controller = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	ret = pm_runtime_get_sync(&pdev->dev);
 
 	if (ret >= 0) {
@@ -1339,6 +1343,8 @@ static void spi_qup_remove(struct platfo
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id spi_qup_dt_match[] = {


