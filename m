Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5FA7113D600;
	Tue, 23 Jul 2024 18:41:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721760113; cv=none; b=u+CTV+hCYeoeeidQYfiMF5mbkgfgV/AZW9UybxMJtz0a+m1S8yl0IYfGJ/M1pvbcyfKdB6F6tond07GpZsEmXEsEWyvjjJ3ZYfaD4Ig0cOk9Txjr0XDOnIbg4GfKRM64boOlwo5xjX5MctmoYQcyQyLWpPPndfkDx2AZwRqDCT8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721760113; c=relaxed/simple;
	bh=5UqoxbDwXx2VcIXdoyjujmD3orObj+ivKX2DgFvtDnE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=B+a0e4dEb1uejh4geX18ZTucNwjkYgJ2skszMCLaLxFA/Ii2OOsdcMa+otLFRMrG4ySf4DrTCnUBRu1sKBG4yxxDETjr9uqRzkViDyrHtW7PF2hNMMgcGG5KgoEdrtWb9nrg/eBa89BdCLO31ys6wnqtOhNFHFv+smBYH6qG2WM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KDGJ8+FH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KDGJ8+FH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D7C2FC4AF09;
	Tue, 23 Jul 2024 18:41:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721760113;
	bh=5UqoxbDwXx2VcIXdoyjujmD3orObj+ivKX2DgFvtDnE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KDGJ8+FHqwa3AamvnUPOhYqb0K2UWnR0hmG+9a/5Emb7PzWNggp/jIBOhl+028scl
	 TFVirNT/0ppEi0sWv2fHWs7JZLQck7oXROTYd+hpfUnoZSGG41ExIRVcSnMPIwzx6i
	 gBJSTw0lGYOkvI338XnyvgDJ+WXlp5X8a+bBlLbE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 076/163] spi: Fix OCTAL mode support
Date: Tue, 23 Jul 2024 20:23:25 +0200
Message-ID: <20240723180146.405595558@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180143.461739294@linuxfoundation.org>
References: <20240723180143.461739294@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Patrice Chotard <patrice.chotard@foss.st.com>

[ Upstream commit d6a711a898672dd873aab3844f754a3ca40723a5 ]

Add OCTAL mode support.
Issue detected using "--octal" spidev_test's option.

Signed-off-by: Patrice Chotard <patrice.chotard@foss.st.com>
Link: https://msgid.link/r/20240618132951.2743935-4-patrice.chotard@foss.st.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi.c       | 6 ++++--
 include/linux/spi/spi.h | 5 +++--
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/spi/spi.c b/drivers/spi/spi.c
index 9304fd03bf764..fcc39523d6857 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4152,7 +4152,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 				return -EINVAL;
 			if (xfer->tx_nbits != SPI_NBITS_SINGLE &&
 				xfer->tx_nbits != SPI_NBITS_DUAL &&
-				xfer->tx_nbits != SPI_NBITS_QUAD)
+				xfer->tx_nbits != SPI_NBITS_QUAD &&
+				xfer->tx_nbits != SPI_NBITS_OCTAL)
 				return -EINVAL;
 			if ((xfer->tx_nbits == SPI_NBITS_DUAL) &&
 				!(spi->mode & (SPI_TX_DUAL | SPI_TX_QUAD)))
@@ -4167,7 +4168,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 				return -EINVAL;
 			if (xfer->rx_nbits != SPI_NBITS_SINGLE &&
 				xfer->rx_nbits != SPI_NBITS_DUAL &&
-				xfer->rx_nbits != SPI_NBITS_QUAD)
+				xfer->rx_nbits != SPI_NBITS_QUAD &&
+				xfer->rx_nbits != SPI_NBITS_OCTAL)
 				return -EINVAL;
 			if ((xfer->rx_nbits == SPI_NBITS_DUAL) &&
 				!(spi->mode & (SPI_RX_DUAL | SPI_RX_QUAD)))
diff --git a/include/linux/spi/spi.h b/include/linux/spi/spi.h
index 64a4deb18dd00..afe6631da1bc6 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1089,12 +1089,13 @@ struct spi_transfer {
 	unsigned	dummy_data:1;
 	unsigned	cs_off:1;
 	unsigned	cs_change:1;
-	unsigned	tx_nbits:3;
-	unsigned	rx_nbits:3;
+	unsigned	tx_nbits:4;
+	unsigned	rx_nbits:4;
 	unsigned	timestamped:1;
 #define	SPI_NBITS_SINGLE	0x01 /* 1-bit transfer */
 #define	SPI_NBITS_DUAL		0x02 /* 2-bit transfer */
 #define	SPI_NBITS_QUAD		0x04 /* 4-bit transfer */
+#define	SPI_NBITS_OCTAL	0x08 /* 8-bit transfer */
 	u8		bits_per_word;
 	struct spi_delay	delay;
 	struct spi_delay	cs_change_delay;
-- 
2.43.0



