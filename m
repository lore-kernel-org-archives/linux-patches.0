Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3320513D896;
	Tue, 23 Jul 2024 18:33:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721759581; cv=none; b=d6v8AySocHkL6epUqeL/9uLewqyk7IqnE9FTjMJaGTGZ4EZ0IPvFdR5wk5rYbMKLUDwEGoFSEG2igDHE5Ue/z0UJOYD9XQaD7hYaIYdqv8HkQwuDIqmlGui4BsLJ9DTfvIURXIpoMMifXVsE+JkRLPNIO5fEkQr0JxBK1F5vY3Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721759581; c=relaxed/simple;
	bh=BLQXfJ5hGkwBcZG5VH8mSm4g8AGcoUTtw80fnaMKOYQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=abmUywuZnP8GTWJbXqpIP2nrANqUbZHc7vYYGX/yhzsYo3Zh6oF03vlX4RPQdOFWJgl3RRc4wivZIrEmK0uGOJEvnnWpq7EbZOKHY3ExbRZfQ+k66Y1C3xK7WypSZJXekIWVGsLlu8pQfO+pzRwI78Sldy0cYQvRoWP56X49qR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=x8Zahl7D; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="x8Zahl7D"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ACDDEC4AF0A;
	Tue, 23 Jul 2024 18:33:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721759581;
	bh=BLQXfJ5hGkwBcZG5VH8mSm4g8AGcoUTtw80fnaMKOYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=x8Zahl7DSO2A5yb6MRydEPXhSv+BHZ5iAd8m3AVUPBYuop0BfEHBsCIivkdjtQhZ2
	 9t5ZHQms7DTlf47O8XBxF862iEIYHlApFOB3nCZqnLJXk+ir1EdZ6hisw/TSq3U+Ju
	 6y3lYWeEYfTSZnm0xmmQjWpAEVaCZ1zaaB0I9jAw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Patrice Chotard <patrice.chotard@foss.st.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 057/129] spi: Fix OCTAL mode support
Date: Tue, 23 Jul 2024 20:23:25 +0200
Message-ID: <20240723180406.991030682@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240723180404.759900207@linuxfoundation.org>
References: <20240723180404.759900207@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
index da15c3f388d1f..5c57c7378ee70 100644
--- a/drivers/spi/spi.c
+++ b/drivers/spi/spi.c
@@ -4000,7 +4000,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
 				return -EINVAL;
 			if (xfer->tx_nbits != SPI_NBITS_SINGLE &&
 				xfer->tx_nbits != SPI_NBITS_DUAL &&
-				xfer->tx_nbits != SPI_NBITS_QUAD)
+				xfer->tx_nbits != SPI_NBITS_QUAD &&
+				xfer->tx_nbits != SPI_NBITS_OCTAL)
 				return -EINVAL;
 			if ((xfer->tx_nbits == SPI_NBITS_DUAL) &&
 				!(spi->mode & (SPI_TX_DUAL | SPI_TX_QUAD)))
@@ -4015,7 +4016,8 @@ static int __spi_validate(struct spi_device *spi, struct spi_message *message)
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
index 8cc7a99927f95..e5baf43bcfbb6 100644
--- a/include/linux/spi/spi.h
+++ b/include/linux/spi/spi.h
@@ -1049,12 +1049,13 @@ struct spi_transfer {
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



