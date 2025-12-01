Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7A057302CD6;
	Mon,  1 Dec 2025 11:26:12 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1764588372; cv=none; b=tBYVERhrE3d3oF5Hu//JxQFV9O6iQBsHf8SB0tKCVWoAKypxqoA8Q192/hAd2kRfJQAxPM4yfXCFL9aQk6DAQalN71Lc0ojLdTX2+RTjZ3EC+ri1L7TZUsx2bkOmFiYMdsTuAJVsTgYUg6M1bQ98K3nLiOfOa5GVYO9B4PJPq+M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1764588372; c=relaxed/simple;
	bh=ok/vZVsERLcgZbNpo+WMGPotknNwGSZ4M6Y6uFJ9pRw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=d923RZFUklWGSsafy6bmy+6QSAiiasDLzPPuV/ZVxsdPBgszzIU0RVDrmwgTwZurAGbHuZk5SOegB7LoNeSwPKnAe2syC2N5FI7mLG3Y4H/b4hNZb9vp1/qgI6DPDB4fP6nLTTQrvnDZ+68YmCiAYsQe5FX0MYZVPuJX4o+AMPM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O8XVWIAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O8XVWIAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F40FBC116D0;
	Mon,  1 Dec 2025 11:26:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1764588372;
	bh=ok/vZVsERLcgZbNpo+WMGPotknNwGSZ4M6Y6uFJ9pRw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O8XVWIAvQymDkaZMP192vOsP++FFsIaYXfYNVDrC23H/149krhiVoQh8Nfh6HkULb
	 HgCR/8UwxbubDxHflKGfduiHj6WemM2X62Nh07/dsIThHo0N/aV5LMyZeT4dxg1Pm9
	 sEUmymFrhe+gMg8huuTvWUoKxRxx4cO6uGHtLKIE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 026/187] spi: loopback-test: Dont use %pK through printk
Date: Mon,  1 Dec 2025 12:22:14 +0100
Message-ID: <20251201112242.199983842@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251201112241.242614045@linuxfoundation.org>
References: <20251201112241.242614045@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Weißschuh <thomas.weissschuh@linutronix.de>

[ Upstream commit b832b19318534bb4f1673b24d78037fee339c679 ]

In the past %pK was preferable to %p as it would not leak raw pointer
values into the kernel log.
Since commit ad67b74d2469 ("printk: hash addresses printed with %p")
the regular %p has been improved to avoid this issue.
Furthermore, restricted pointers ("%pK") were never meant to be used
through printk(). They can still unintentionally leak raw pointers or
acquire sleeping locks in atomic contexts.

Switch to the regular pointer formatting which is safer and
easier to reason about.
There are still a few users of %pK left, but these use it through seq_file,
for which its usage is safe.

Signed-off-by: Thomas Weißschuh <thomas.weissschuh@linutronix.de>
Link: https://patch.msgid.link/20250811-restricted-pointers-spi-v1-1-32c47f954e4d@linutronix.de
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/spi/spi-loopback-test.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/spi/spi-loopback-test.c b/drivers/spi/spi-loopback-test.c
index 0f571ff132377..3edcb5bf59f79 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -403,7 +403,7 @@ static void spi_test_dump_message(struct spi_device *spi,
 	int i;
 	u8 b;
 
-	dev_info(&spi->dev, "  spi_msg@%pK\n", msg);
+	dev_info(&spi->dev, "  spi_msg@%p\n", msg);
 	if (msg->status)
 		dev_info(&spi->dev, "    status:        %i\n",
 			 msg->status);
@@ -413,15 +413,15 @@ static void spi_test_dump_message(struct spi_device *spi,
 		 msg->actual_length);
 
 	list_for_each_entry(xfer, &msg->transfers, transfer_list) {
-		dev_info(&spi->dev, "    spi_transfer@%pK\n", xfer);
+		dev_info(&spi->dev, "    spi_transfer@%p\n", xfer);
 		dev_info(&spi->dev, "      len:    %i\n", xfer->len);
-		dev_info(&spi->dev, "      tx_buf: %pK\n", xfer->tx_buf);
+		dev_info(&spi->dev, "      tx_buf: %p\n", xfer->tx_buf);
 		if (dump_data && xfer->tx_buf)
 			spi_test_print_hex_dump("          TX: ",
 						xfer->tx_buf,
 						xfer->len);
 
-		dev_info(&spi->dev, "      rx_buf: %pK\n", xfer->rx_buf);
+		dev_info(&spi->dev, "      rx_buf: %p\n", xfer->rx_buf);
 		if (dump_data && xfer->rx_buf)
 			spi_test_print_hex_dump("          RX: ",
 						xfer->rx_buf,
@@ -514,7 +514,7 @@ static int spi_check_rx_ranges(struct spi_device *spi,
 		/* if still not found then something has modified too much */
 		/* we could list the "closest" transfer here... */
 		dev_err(&spi->dev,
-			"loopback strangeness - rx changed outside of allowed range at: %pK\n",
+			"loopback strangeness - rx changed outside of allowed range at: %p\n",
 			addr);
 		/* do not return, only set ret,
 		 * so that we list all addresses
@@ -652,7 +652,7 @@ static int spi_test_translate(struct spi_device *spi,
 	}
 
 	dev_err(&spi->dev,
-		"PointerRange [%pK:%pK[ not in range [%pK:%pK[ or [%pK:%pK[\n",
+		"PointerRange [%p:%p[ not in range [%p:%p[ or [%p:%p[\n",
 		*ptr, *ptr + len,
 		RX(0), RX(SPI_TEST_MAX_SIZE),
 		TX(0), TX(SPI_TEST_MAX_SIZE));
-- 
2.51.0



