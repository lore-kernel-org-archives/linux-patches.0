Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 756FD4C97;
	Tue, 11 Nov 2025 00:55:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1762822507; cv=none; b=GnIfleSzkHgHB0o+OSkUGOeC/PVQ5wZ1uJmkaZzEtrBgriAjY6STP61FO62FNng+EZBFpos2p1v6kFR+LpbYFLJ8rtZYy34z4+Gz6M9Y/u01Ng/ntw8qSHOhKz6PsJFa7PbJk5BNkTJU8heti5xAQkgMMG0QMR+iQivOL8OjQK4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1762822507; c=relaxed/simple;
	bh=4IIXF6NqgK/aoGAEq6K/CO+w4RkgnGZJkyaieL3mJdA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=iguLXi/eoxgT7Z2RvHzuo6VGKHaQ9Bz+gwcHoDQ5wfNK7BS9YvJHqTx8lHrY91SAzenSIiblSh+Yl/XRnf4gTaNKLdiqsyl8+0o9FuvWZMi/WTGKaaBdotPDKcGGVWDhWICVpT9UAilvfa5RUa+bvLw0xHycnvP0lqNnYRtFUxc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=PK6WHAv5; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="PK6WHAv5"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12667C16AAE;
	Tue, 11 Nov 2025 00:55:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1762822507;
	bh=4IIXF6NqgK/aoGAEq6K/CO+w4RkgnGZJkyaieL3mJdA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=PK6WHAv5JgZDPv59w4szLYVbuW/Cw6Vlh2lxPIO6rjRgvLuiNqOOpt9sA+B+ZdaRF
	 TCl4eLH6GcMYV40/AMluHBoiK9cFzw/A+PM5cSJJvKNvWaeJQ8bIvjm1GROITItrBg
	 R/XBmxJvyzBmXI7prp5787N5F7adt7w9Pp6oJitw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <thomas.weissschuh@linutronix.de>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 121/849] spi: loopback-test: Dont use %pK through printk
Date: Tue, 11 Nov 2025 09:34:51 +0900
Message-ID: <20251111004539.324238635@linuxfoundation.org>
X-Mailer: git-send-email 2.51.2
In-Reply-To: <20251111004536.460310036@linuxfoundation.org>
References: <20251111004536.460310036@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

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
index 7dd92deffe3fb..e0b131aa29b62 100644
--- a/drivers/spi/spi-loopback-test.c
+++ b/drivers/spi/spi-loopback-test.c
@@ -446,7 +446,7 @@ static void spi_test_dump_message(struct spi_device *spi,
 	int i;
 	u8 b;
 
-	dev_info(&spi->dev, "  spi_msg@%pK\n", msg);
+	dev_info(&spi->dev, "  spi_msg@%p\n", msg);
 	if (msg->status)
 		dev_info(&spi->dev, "    status:        %i\n",
 			 msg->status);
@@ -456,15 +456,15 @@ static void spi_test_dump_message(struct spi_device *spi,
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
@@ -558,7 +558,7 @@ static int spi_check_rx_ranges(struct spi_device *spi,
 		/* if still not found then something has modified too much */
 		/* we could list the "closest" transfer here... */
 		dev_err(&spi->dev,
-			"loopback strangeness - rx changed outside of allowed range at: %pK\n",
+			"loopback strangeness - rx changed outside of allowed range at: %p\n",
 			addr);
 		/* do not return, only set ret,
 		 * so that we list all addresses
@@ -696,7 +696,7 @@ static int spi_test_translate(struct spi_device *spi,
 	}
 
 	dev_err(&spi->dev,
-		"PointerRange [%pK:%pK[ not in range [%pK:%pK[ or [%pK:%pK[\n",
+		"PointerRange [%p:%p[ not in range [%p:%p[ or [%p:%p[\n",
 		*ptr, *ptr + len,
 		RX(0), RX(SPI_TEST_MAX_SIZE),
 		TX(0), TX(SPI_TEST_MAX_SIZE));
-- 
2.51.0



