Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 724A93E0721;
	Tue, 12 May 2026 17:44:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778607877; cv=none; b=SmZ1HtXuNEug4NfsxELEY67evtdXS9Qt5Fj0+wKKGEL+sSZcOp7aqFrXjFagtt7lQSCxPm7ABIo2uUvKBPE/Ba6v/Aw7Wgn7+RxbADM1ElBf2BSu9kuCzbPYfxnmhT5mAw4yr8JObC+vVtaHYl+bGA1dddyDOSCc8XBQs6leUPE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778607877; c=relaxed/simple;
	bh=ro/AaViGdXTQ5SpLc6v9ewFSb065Z+3XTCnaNpWskMg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=n2g05ClWkkjVZ/SQg+SCK0G99ClnYe0qL/tVeg2NbPYW+M0X30e/JQ/Tht1p5aRneBBC4j4gZboe62qhiA0+zW03kQDIPwWmyc8MgGIZex8eDUKH6uTkZifDYgmMT1fLqpmzHrQIN4u/Yot8vEWJh3GGZATAYfrXV+PEpBMTTSk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uCqq2nW3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uCqq2nW3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0A0DDC2BCB0;
	Tue, 12 May 2026 17:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778607877;
	bh=ro/AaViGdXTQ5SpLc6v9ewFSb065Z+3XTCnaNpWskMg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uCqq2nW3PAqz535NHBik3lUoaNFj0xncDIaKYy1xE+4WwqHapccf0xfyGGXD/Xl7S
	 yWvejh/RrSKJ0lk2+NxGt6A6rdxmo/xOlDz39ofYRmLCv0sgC6qqrWhN9o17Ijj4XP
	 n+K6/Iq3deLCLKnnLOu8MIQAXgw2ALl07/JqsigI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ranjit Waghmode <ranjit.waghmode@xilinx.com>,
	Johan Hovold <johan@kernel.org>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.12 071/206] spi: zynqmp-gqspi: fix controller deregistration
Date: Tue, 12 May 2026 19:38:43 +0200
Message-ID: <20260512173934.351934036@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173932.810559588@linuxfoundation.org>
References: <20260512173932.810559588@linuxfoundation.org>
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

commit 6895fc4faafc9082e15e4e624b23dd5f0c98feb5 upstream.

Make sure to deregister the controller before disabling underlying
resources like clocks during driver unbind.

Fixes: dfe11a11d523 ("spi: Add support for Zynq Ultrascale+ MPSoC GQSPI controller")
Cc: stable@vger.kernel.org	# 4.2: 64640f6c972e
Cc: stable@vger.kernel.org	# 4.2
Cc: Ranjit Waghmode <ranjit.waghmode@xilinx.com>
Signed-off-by: Johan Hovold <johan@kernel.org>
Link: https://patch.msgid.link/20260410081757.503099-26-johan@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-zynqmp-gqspi.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-zynqmp-gqspi.c
+++ b/drivers/spi/spi-zynqmp-gqspi.c
@@ -1334,7 +1334,7 @@ static int zynqmp_qspi_probe(struct plat
 	ctlr->dev.of_node = np;
 	ctlr->auto_runtime_pm = true;
 
-	ret = devm_spi_register_controller(&pdev->dev, ctlr);
+	ret = spi_register_controller(ctlr);
 	if (ret) {
 		dev_err(&pdev->dev, "spi_register_controller failed\n");
 		goto clk_dis_all;
@@ -1373,6 +1373,8 @@ static void zynqmp_qspi_remove(struct pl
 
 	pm_runtime_get_sync(&pdev->dev);
 
+	spi_unregister_controller(xqspi->ctlr);
+
 	zynqmp_gqspi_write(xqspi, GQSPI_EN_OFST, 0x0);
 
 	pm_runtime_disable(&pdev->dev);


