Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B5AD3370E4
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 21:03:45 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1037AC433EF;
	Wed,  7 Jun 2023 21:03:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686171825;
	bh=wAQKrnLMTbjrBRltM3Dp68jT6dYe4jW4y3QlIFiNXkU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=osO5IZKDmJA5fT0KkfeYQoAudzpsZnjkZdYMFFsEp6UYZmGESNe/mDoZV8cf90LP5
	 kUBORDb99Fy3DE+Ru9FlUp0ApvIfeikRAWx7W6ns9vrNsNQLDB3h0aRTa+FtY/nGz+
	 0QMkJoHQ7U55qJQUa3KDHnbwAealOdpnpArsz85E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Lino Sanfilippo <l.sanfilippo@kunbus.com>,
	=?UTF-8?q?Michael=20Niew=C3=B6hner?= <linux@mniewoehner.de>,
	Jarkko Sakkinen <jarkko@kernel.org>
Subject: [PATCH 5.15 148/159] tpm, tpm_tis: Request threaded interrupt handler
Date: Wed,  7 Jun 2023 22:17:31 +0200
Message-ID: <20230607200908.509076356@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200903.652580797@linuxfoundation.org>
References: <20230607200903.652580797@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Lino Sanfilippo <l.sanfilippo@kunbus.com>

commit 0c7e66e5fd69bf21034c9a9b081d7de7c3eb2cea upstream.

The TIS interrupt handler at least has to read and write the interrupt
status register. In case of SPI both operations result in a call to
tpm_tis_spi_transfer() which uses the bus_lock_mutex of the spi device
and thus must only be called from a sleepable context.

To ensure this request a threaded interrupt handler.

Signed-off-by: Lino Sanfilippo <l.sanfilippo@kunbus.com>
Tested-by: Michael Niewöhner <linux@mniewoehner.de>
Tested-by: Jarkko Sakkinen <jarkko@kernel.org>
Reviewed-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Jarkko Sakkinen <jarkko@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/char/tpm/tpm_tis_core.c |    7 +++++--
 1 file changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/char/tpm/tpm_tis_core.c
+++ b/drivers/char/tpm/tpm_tis_core.c
@@ -764,8 +764,11 @@ static int tpm_tis_probe_irq_single(stru
 	int rc;
 	u32 int_status;
 
-	if (devm_request_irq(chip->dev.parent, irq, tis_int_handler, flags,
-			     dev_name(&chip->dev), chip) != 0) {
+
+	rc = devm_request_threaded_irq(chip->dev.parent, irq, NULL,
+				       tis_int_handler, IRQF_ONESHOT | flags,
+				       dev_name(&chip->dev), chip);
+	if (rc) {
 		dev_info(&chip->dev, "Unable to request irq: %d for probe\n",
 			 irq);
 		return -1;


