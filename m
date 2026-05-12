Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7E98F3EDE5B;
	Tue, 12 May 2026 17:57:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778608670; cv=none; b=UK/m0ikP1tm7CdlZmPJtCpbdhGjPG/G18yk81dULu25UrxyL3bazyQqiD0iP8mWvoa+h5MZFrzcbg9Az9FW5pK1wmTgice3GgM8A8t9uIKXz4SC0Sgsyh1ftevywhHkGrNCXThjtiUVK3qhnzxxf+bv8s+01MBUrXMdXdFz6tTk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778608670; c=relaxed/simple;
	bh=ixKg7+WFcwCeEBZtc3+N8+nU90WHcSNh7f8gMIXxTYg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pW5R8gxo0NSVpod7G2OohA34S9IksmxSOnotZ8n6hacsWkVfymKyHlcxeIj+D3OzAYhKSNw6mQuM2UMYZ22/f8BhwkvngKASNz+P0F3XUNZJiZucsnheEUzVYVWMeSSL56CqB3JK2HerAUi5/MF6T0Rlmgmv1JJCV9urU9C+U44=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Rj3vXL7Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Rj3vXL7Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C804EC2BCC7;
	Tue, 12 May 2026 17:57:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778608670;
	bh=ixKg7+WFcwCeEBZtc3+N8+nU90WHcSNh7f8gMIXxTYg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Rj3vXL7Z/cz88WylYLgIYUk4g5jcYldWVT5nddtpREkKt/c6E1fN5i5BZb8yufCwo
	 lFmKw0K9sJZEzh6ptIa0H/GLResjzU8NkvFxi73XUujOxHkef9ugWoLAItrS79xHOZ
	 joolXxFaYf1EiwFyweE5e9deEjsFxipyNqgsMDeo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Conor Dooley <conor.dooley@microchip.com>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.18 128/270] spi: microchip-core-qspi: dont attempt to transmit during emulated read-only dual/quad operations
Date: Tue, 12 May 2026 19:38:49 +0200
Message-ID: <20260512173941.149220409@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260512173938.452574370@linuxfoundation.org>
References: <20260512173938.452574370@linuxfoundation.org>
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

From: Conor Dooley <conor.dooley@microchip.com>

commit eb56deaabf127e8985fc91fa6c97bf8a3b062844 upstream.

The core will deal with reads by creating clock cycles itself, there's
no need to generate clock cycles by transmitting garbage data at the
driver level. Further, transmitting garbage data just bricks the transfer
since QSPI doesn't have a dedicated master-out line like MOSI in regular
SPI. I'm not entirely sure if the transfer is bricked because of the
garbage data being transmitted on the bus or because the core loses
track of whether it is supposed to be sending or receiving data.

Fixes: 8f9cf02c88528 ("spi: microchip-core-qspi: Add regular transfers")
CC: stable@vger.kernel.org
Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
Link: https://patch.msgid.link/20260430-freezing-saloon-95b1f3d9dad0@spud
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi-microchip-core-qspi.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/spi/spi-microchip-core-qspi.c
+++ b/drivers/spi/spi-microchip-core-qspi.c
@@ -662,18 +662,28 @@ static int mchp_coreqspi_transfer_one(st
 				      struct spi_transfer *t)
 {
 	struct mchp_coreqspi *qspi = spi_controller_get_devdata(ctlr);
+	bool dual_quad = false;
 
 	qspi->tx_len = t->len;
 
+	if (t->tx_nbits == SPI_NBITS_QUAD || t->rx_nbits == SPI_NBITS_QUAD ||
+			t->tx_nbits == SPI_NBITS_DUAL ||
+			t->rx_nbits == SPI_NBITS_DUAL)
+		dual_quad = true;
+
 	if (t->tx_buf)
 		qspi->txbuf = (u8 *)t->tx_buf;
 
 	if (!t->rx_buf) {
 		mchp_coreqspi_write_op(qspi);
-	} else {
+	} else if (!dual_quad) {
 		qspi->rxbuf = (u8 *)t->rx_buf;
 		qspi->rx_len = t->len;
 		mchp_coreqspi_write_read_op(qspi);
+	} else {
+		qspi->rxbuf = (u8 *)t->rx_buf;
+		qspi->rx_len = t->len;
+		mchp_coreqspi_read_op(qspi);
 	}
 
 	return 0;


