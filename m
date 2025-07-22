Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E0AD2224FD;
	Tue, 22 Jul 2025 13:51:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1753192269; cv=none; b=XKSUuD5temggaGGaIl2DegzlO7FMv60tbPWrJZPEJC5psieMLXxotDqZQqJLnrUmFfpm76OccWpFpqaxulr4og/CFLuK+QlFMvnLnMdq2dFaZHFu5Okxr9Y9961y+2F3UygN2gi1HwL8lA5xKAVuWh7U0ifoHHJllA6CuaEqzQk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1753192269; c=relaxed/simple;
	bh=WUD+FHfvkb3mYWs+Gjg1UbEoTNuKoe/dGj1xivSryO0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EjDGbqj/aktqm1dFMvgOlJYeHQMuLaFQHDIwr33KwH4dbeuPfi7geu366WMCoGhNjP9Ih9Q6GWuOYMmoAEJbCVbbTSPEAj1TDUWnGs99qK1MI+cMBct73UeCvpS8zL1TnyI/O08u6ccRkyYOVdbqUBqfmNs5igAKOy9Up6egLGM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=mo9MX0AB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="mo9MX0AB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 57DF3C4CEEB;
	Tue, 22 Jul 2025 13:51:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1753192268;
	bh=WUD+FHfvkb3mYWs+Gjg1UbEoTNuKoe/dGj1xivSryO0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mo9MX0ABP1uPGjBfvuGb5eGwyR22DLMo9ZK3vaZ0QXgwCImvU3UJPoPtIKg/YXQHS
	 HSAmMgoP5+84L3D/rW3PSW9ODviQ9+ILOYPCS+c++efnmsBJVmwUGJpPUUHbjdwMom
	 AqzaDLFNu7J7t5469Wu/44xMhVqEobHB3UZqUrTc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Cheng Ming Lin <chengminglin@mxic.com.tw>,
	Mark Brown <broonie@kernel.org>
Subject: [PATCH 6.6 015/111] spi: Add check for 8-bit transfer with 8 IO mode support
Date: Tue, 22 Jul 2025 15:43:50 +0200
Message-ID: <20250722134333.961297944@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250722134333.375479548@linuxfoundation.org>
References: <20250722134333.375479548@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Cheng Ming Lin <chengminglin@mxic.com.tw>

commit 710505212e3272396394f8cf78e3ddfd05df3f22 upstream.

The current SPI framework does not verify if the SPI device supports
8 IO mode when doing an 8-bit transfer. This patch adds a check to
ensure that if the transfer tx_nbits or rx_nbits is 8, the SPI mode must
support 8 IO. If not, an error is returned, preventing undefined behavior.

Fixes: d6a711a898672 ("spi: Fix OCTAL mode support")
Cc: stable@vger.kernel.org
Signed-off-by: Cheng Ming Lin <chengminglin@mxic.com.tw>
Link: https://patch.msgid.link/20250714031023.504752-1-linchengming884@gmail.com
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/spi/spi.c |   14 ++++++++++----
 1 file changed, 10 insertions(+), 4 deletions(-)

--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4011,10 +4011,13 @@ static int __spi_validate(struct spi_dev
 				xfer->tx_nbits != SPI_NBITS_OCTAL)
 				return -EINVAL;
 			if ((xfer->tx_nbits == SPI_NBITS_DUAL) &&
-				!(spi->mode & (SPI_TX_DUAL | SPI_TX_QUAD)))
+				!(spi->mode & (SPI_TX_DUAL | SPI_TX_QUAD | SPI_TX_OCTAL)))
 				return -EINVAL;
 			if ((xfer->tx_nbits == SPI_NBITS_QUAD) &&
-				!(spi->mode & SPI_TX_QUAD))
+				!(spi->mode & (SPI_TX_QUAD | SPI_TX_OCTAL)))
+				return -EINVAL;
+			if ((xfer->tx_nbits == SPI_NBITS_OCTAL) &&
+				!(spi->mode & SPI_TX_OCTAL))
 				return -EINVAL;
 		}
 		/* Check transfer rx_nbits */
@@ -4027,10 +4030,13 @@ static int __spi_validate(struct spi_dev
 				xfer->rx_nbits != SPI_NBITS_OCTAL)
 				return -EINVAL;
 			if ((xfer->rx_nbits == SPI_NBITS_DUAL) &&
-				!(spi->mode & (SPI_RX_DUAL | SPI_RX_QUAD)))
+				!(spi->mode & (SPI_RX_DUAL | SPI_RX_QUAD | SPI_RX_OCTAL)))
 				return -EINVAL;
 			if ((xfer->rx_nbits == SPI_NBITS_QUAD) &&
-				!(spi->mode & SPI_RX_QUAD))
+				!(spi->mode & (SPI_RX_QUAD | SPI_RX_OCTAL)))
+				return -EINVAL;
+			if ((xfer->rx_nbits == SPI_NBITS_OCTAL) &&
+				!(spi->mode & SPI_RX_OCTAL))
 				return -EINVAL;
 		}
 


