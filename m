Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0654C3FF1A2;
	Fri, 15 May 2026 16:29:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778862552; cv=none; b=Q0qwpBu9mtkDWLtwbe01cdHBVrWHiItEv2/tkC5F+bpWpnLfOoo3z+H83U30Yw3hMDYqtAgGV7AJlM2aYXosEbD7PWzK7RkSxKevD/y5znNohgaVRNIBri8fmjPLClEb0L2NNWca+DS21qKTw9xBrYH8SaE7/pAE2W8tudrAG/E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778862552; c=relaxed/simple;
	bh=7BvtRYdqbTE6ow/hkzMscwjH7RB02v4SgOHgdYF3Tj8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=kEouE9nkw8stJyIlMF3R+/gA5ZbZQDmzNvBP1PmDjcRdBTXRvnWNhqTA0a8Qjoy1RZGZl4FOPbds6/eoBWOlUsiZNNA0VfKy2dNfTubWazCNFWOHkx5k5wddowyJJrj9EWuHePfm2K+gyMWFQmLlU4HHKXeM4GxUORKi1VPjXeU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Qeh4Cszc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Qeh4Cszc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 92C47C2BCB0;
	Fri, 15 May 2026 16:29:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778862551;
	bh=7BvtRYdqbTE6ow/hkzMscwjH7RB02v4SgOHgdYF3Tj8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qeh4Cszcx1fhulcexdim3/7rL2ndOBfgbHY8FktUOGscgXuLqVxEmbsxLlh8QYLgp
	 JZnshsJIVJcvLmqF7WKarSOR9zBHm9cm+40qB5xSXmhigybMW1I+eAGgWPcL+AOIbj
	 KEaHWp4a0UCGxthOAooj8lZB0mNEQfIPjGU8OJKg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Laurentiu Palcu <laurentiu.palcu@intel.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 7.0 085/201] spi: dln2: fix controller deregistration
Date: Fri, 15 May 2026 17:48:23 +0200
Message-ID: <20260515154700.373664087@linuxfoundation.org>
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

commit c353020fbfa8514ee91a6de2d88de4e5edca5803 upstream.

Make sure to deregister the controller before disabling it to allow
SPI device drivers to do I/O during deregistration.

Fixes: 3d8c0d749da3 ("spi: add support for DLN-2 USB-SPI adapter")
Cc: stable@vger.kernel.org	# 4.0
Cc: Laurentiu Palcu <laurentiu.palcu@intel.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260409120419.388546-12-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-dln2.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-dln2.c
+++ b/drivers/spi/spi-dln2.c
@@ -758,7 +758,7 @@ static int dln2_spi_probe(struct platfor
 	pm_runtime_set_active(&pdev->dev);
 	pm_runtime_enable(&pdev->dev);
 
-	ret = devm_spi_register_controller(&pdev->dev, host);
+	ret = spi_register_controller(host);
 	if (ret < 0) {
 		dev_err(&pdev->dev, "Failed to register host\n");
 		goto exit_register;
@@ -783,10 +783,16 @@ static void dln2_spi_remove(struct platf
 	struct spi_controller *host = platform_get_drvdata(pdev);
 	struct dln2_spi *dln2 = spi_controller_get_devdata(host);
 
+	spi_controller_get(host);
+
+	spi_unregister_controller(host);
+
 	pm_runtime_disable(&pdev->dev);
 
 	if (dln2_spi_enable(dln2, false) < 0)
 		dev_err(&pdev->dev, "Failed to disable SPI module\n");
+
+	spi_controller_put(host);
 }
 
 #ifdef CONFIG_PM_SLEEP


