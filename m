Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7ECB117AE11;
	Fri, 15 May 2026 15:51:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778860273; cv=none; b=uuXE9XVIS8nR+nxXj0fKEoVBxEFiYQRwlewhA4zteP+h+9TwAhAxodDHuN+dTGA92/MfPUAuLRh8oEDtL/RhtT/BFzSs734j3Wgnw2sypPFZ0hSnw45c3zJ9jzM/qrcnvzAvTikUHYbADD6loh27GI7gLxjWBnHeVYNoPLz6yBQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778860273; c=relaxed/simple;
	bh=uFc+fG3WqSC2L3LkRGbYjWor5FHv6Zzr/lSXHoiN0cQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=R8kbP5VX8R0cJFHCvth2UMCoQLvJ4tzPfZAHnGCbm/cFpdLvI1qSDb3mR8NKNGJspUipV3GlFTCWSyblrYC7wB1l1npTDQGAcVD8byamNnn+DO1ipnGMVzuXlpla92VmTIt48Tbjdg5vFIWVI4SbVgjPAZMhy1GEO1Po6GjTL9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0txPRF8d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0txPRF8d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 14FCFC2BCB3;
	Fri, 15 May 2026 15:51:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778860273;
	bh=uFc+fG3WqSC2L3LkRGbYjWor5FHv6Zzr/lSXHoiN0cQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0txPRF8dmrRTCk9ku77izTBmEtRuIAZxLgHb37ZFXjHn/4AEnp+9hnNFxhS6hWlhX
	 NnP+xbxcLrrOTMALTLosnxYuGXtx4M9e87sCekgYAxm4q/SOqYAFWUiuNZMh9uoHBD
	 8TB6CQpVF9ZI8QTRJiE6y6OHLv+tSEAt/+rBOrwI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 026/144] spi: qup: fix controller deregistration
Date: Fri, 15 May 2026 17:47:32 +0200
Message-ID: <20260515154654.112882315@linuxfoundation.org>
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
@@ -1194,7 +1194,7 @@ static int spi_qup_probe(struct platform
 	pm_runtime_set_active(dev);
 	pm_runtime_enable(dev);
 
-	ret = devm_spi_register_controller(dev, host);
+	ret = spi_register_controller(host);
 	if (ret)
 		goto disable_pm;
 
@@ -1321,6 +1321,10 @@ static void spi_qup_remove(struct platfo
 	struct spi_qup *controller = spi_controller_get_devdata(host);
 	int ret;
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	ret = pm_runtime_get_sync(&pdev->dev);
 
 	if (ret >= 0) {
@@ -1340,6 +1344,8 @@ static void spi_qup_remove(struct platfo
 
 	pm_runtime_put_noidle(&pdev->dev);
 	pm_runtime_disable(&pdev->dev);
+
+	spi_controller_put(host);
 }
 
 static const struct of_device_id spi_qup_dt_match[] = {


