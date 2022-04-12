Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF43F1FBA
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 12:40:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7363FC385A5
	for <patches@lists.linux.dev>; Tue, 12 Apr 2022 12:40:07 +0000 (UTC)
Authentication-Results: smtp.kernel.org;
	dkim=pass (2048-bit key) header.d=bootlin.com header.i=@bootlin.com header.b="oapvIhjd"
Resent-From: Mark Brown <broonie@kernel.org>
Resent-Date: Tue, 12 Apr 2022 13:40:03 +0100
Resent-Message-ID: <YlVzI4n0kTZhLLg7@sirena.org.uk>
Resent-To: patches@lists.linux.dev
Envelope-to: broonie@sirena.co.uk
Delivery-date: Tue, 12 Apr 2022 13:22:27 +0100
Received: from ams.source.kernel.org ([2604:1380:4601:e00::1])
	by cassiel.sirena.org.uk with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
	(Exim 4.94.2)
	(envelope-from <SRS0=WVxJ=UW=bootlin.com=paul.kocialkowski@kernel.org>)
	id 1neFXN-008fOb-0X
	for broonie@sirena.co.uk; Tue, 12 Apr 2022 13:22:27 +0100
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ams.source.kernel.org (Postfix) with ESMTPS id 5F96FB819FD
	for <broonie@sirena.co.uk>; Tue, 12 Apr 2022 12:22:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix)
	id 3F9C9C385A6; Tue, 12 Apr 2022 12:22:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE082C385A1
	for <broonie@kernel.org>; Tue, 12 Apr 2022 12:22:20 +0000 (UTC)
DMARC-Filter: OpenDMARC Filter v1.4.1 smtp.kernel.org CE082C385A1
Authentication-Results: smtp.kernel.org; dmarc=pass (p=reject dis=none) header.from=bootlin.com
Authentication-Results: smtp.kernel.org; spf=pass smtp.mailfrom=bootlin.com
Received: (Authenticated sender: paul.kocialkowski@bootlin.com)
	by mail.gandi.net (Postfix) with ESMTPSA id 530E560004;
	Tue, 12 Apr 2022 12:22:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=bootlin.com; s=gm1;
	t=1649766138;
	h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
	 to:to:cc:cc:mime-version:mime-version:
	 content-transfer-encoding:content-transfer-encoding;
	bh=yYar+EZz5N7PiDMFj3b3J7ixymPwvX8499KWau8exU8=;
	b=oapvIhjdGOscEhJufDW+Ov8FKM7b/3KQLJsXzxW+JBdJvZcIHz/Rn3A971azmySNHmlXlR
	dTsdpG6XZzEejvt/fD/kB0Wh3n2ILRWv3CuI2akVA8g4+UwWe791zApK6fjZLVz/OAL5cB
	r08yE0Y+enDC4q9My7eugN138dxjBSnubQEk0AociCTBUv4spDaNSoFySBk+y4ukjP6HCJ
	a1qNz5GHmyYFDKCa0F3Imktw4t8/f6ROb34QPSVF+7XZT1ruJynINb7kL7MElrxBVSk18T
	cKvXOUZSwB8G0w1eHijwoRGFoxrZE2X/aPJEXG7aK++8bnPkNJq8swuDu2gRsw==
From: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
To: linux-spi@vger.kernel.org,
	linux-kernel@vger.kernel.org
Cc: Mark Brown <broonie@kernel.org>,
	Thomas Petazzoni <thomas.petazzoni@bootlin.com>,
	Paul Kocialkowski <paul.kocialkowski@bootlin.com>
Date: Tue, 12 Apr 2022 14:22:07 +0200
Message-Id: <20220412122207.130181-1-paul.kocialkowski@bootlin.com>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 2604:1380:4601:e00::1
X-SA-Exim-Mail-From: SRS0=WVxJ=UW=bootlin.com=paul.kocialkowski@kernel.org
Subject: [PATCH] spi: core: Only check bits_per_word validity when explicitly provided
X-SA-Exim-Version: 4.2.1 (built Sat, 13 Feb 2021 17:57:42 +0000)
X-SA-Exim-Scanned: No (on cassiel.sirena.org.uk); Unknown failure
X-TUID: xBBVOKtMhxP0

On SPI device probe, the core will call spi_setup in spi_add_device
before the corresponding driver was probed. When this happens, the
bits_per_word member of the device is not yet set by the driver,
resulting in the default being set to 8 bits-per-word.

However some controllers do not support 8 bits-per-word at all, which
results in a failure when checking the bits-per-word validity.

In order to support these devices, skip the bits-per-word validity
check when it is not explicitly provided by drivers.

Signed-off-by: Paul Kocialkowski <paul.kocialkowski@bootlin.com>
---
 drivers/spi/spi.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 2e6d6bbeb784..563a56ce34a0 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -3518,13 +3518,18 @@ int spi_setup(struct spi_device *spi)
 		return -EINVAL;
 	}
 
-	if (!spi->bits_per_word)
+	if (!spi->bits_per_word) {
 		spi->bits_per_word = 8;
-
-	status = __spi_validate_bits_per_word(spi->controller,
-					      spi->bits_per_word);
-	if (status)
-		return status;
+	} else {
+		/*
+		 * Some controllers may not support the default 8 bits-per-word
+		 * so only perform the check when this is explicitly provided.
+		 */
+		status = __spi_validate_bits_per_word(spi->controller,
+						      spi->bits_per_word);
+		if (status)
+			return status;
+	}
 
 	if (spi->controller->max_speed_hz &&
 	    (!spi->max_speed_hz ||
-- 
2.35.1

