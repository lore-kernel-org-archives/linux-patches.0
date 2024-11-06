Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 85F9E1F4FCA;
	Wed,  6 Nov 2024 12:55:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730897714; cv=none; b=bLxUEHEQB8hJOsZa0cp1mzFBTQDw4go4+Wg0iaSU0iiuQFt60FnjU45G50AfLfPIMCIMkTFowUguzOiXbRxr2uPm0YJOQHX3nNFk7hfdkPV/G5gvY6Pzj5qq0YGI1HaJRV98dDDQ8xQsJlvi1IsOtiBGiH2yAmLf+f7JViItGrc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730897714; c=relaxed/simple;
	bh=kiFHUA1mWArAIGJOCe30E4nQbsx27aat82dB7Kl8Qtc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bNOz0xDoVhRt6RHcFCNm+lRckrtjfb+4cR4Z63qRAy9ixP8Nm1nt5bFxTUlLxU3ZBqPc2uQ/XjIdtpxjoTlT8RX62vhCD2ABkSTj2zlwzGvgQirqbjU4NyRgTIZvNtrQ10JZ1OqKzX7KR0YrpCNDznDRC5hc22tljOOTwYWG8aM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=YLPYyfof; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="YLPYyfof"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BD79C4CECD;
	Wed,  6 Nov 2024 12:55:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730897714;
	bh=kiFHUA1mWArAIGJOCe30E4nQbsx27aat82dB7Kl8Qtc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=YLPYyfofFrrXShMt2fn3d1zta0yORUiKStK4bGpXkyL4hMCIh6Q23rxdRiJ2le4uK
	 roJdr6YUA2ZSMqShl0uC2DHrHhKfNEnaAd21QpX6NPDrsqypaxWlhRSrgCh0DjObZA
	 A3umYBpU7jDV9xCxKQ95THyzNTuG7AmzYKD5AB4g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hartmut Birr <e9hack@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Esben Haabendal <esben@geanix.com>,
	Pratyush Yadav <pratyush@kernel.org>
Subject: [PATCH 6.6 145/151] mtd: spi-nor: winbond: fix w25q128 regression
Date: Wed,  6 Nov 2024 13:05:33 +0100
Message-ID: <20241106120312.839326216@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120308.841299741@linuxfoundation.org>
References: <20241106120308.841299741@linuxfoundation.org>
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

From: Michael Walle <mwalle@kernel.org>

commit d35df77707bf5ae1221b5ba1c8a88cf4fcdd4901 upstream.

Commit 83e824a4a595 ("mtd: spi-nor: Correct flags for Winbond w25q128")
removed the flags for non-SFDP devices. It was assumed that it wasn't in
use anymore. This wasn't true. Add the no_sfdp_flags as well as the size
again.

We add the additional flags for dual and quad read because they have
been reported to work properly by Hartmut using both older and newer
versions of this flash, the similar flashes with 64Mbit and 256Mbit
already have these flags and because it will (luckily) trigger our
legacy SFDP parsing, so newer versions with SFDP support will still get
the parameters from the SFDP tables.

Reported-by: Hartmut Birr <e9hack@gmail.com>
Closes: https://lore.kernel.org/r/CALxbwRo_-9CaJmt7r7ELgu+vOcgk=xZcGHobnKf=oT2=u4d4aA@mail.gmail.com/
Fixes: 83e824a4a595 ("mtd: spi-nor: Correct flags for Winbond w25q128")
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Michael Walle <mwalle@kernel.org>
Acked-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Reviewed-by: Esben Haabendal <esben@geanix.com>
Reviewed-by: Pratyush Yadav <pratyush@kernel.org>
Signed-off-by: Pratyush Yadav <pratyush@kernel.org>
Link: https://lore.kernel.org/r/20240621120929.2670185-1-mwalle@kernel.org
Link: https://lore.kernel.org/r/20240621120929.2670185-1-mwalle@kernel.org
[Backported to v6.6 - vastly different due to upstream changes]
Reviewed-by: Tudor Ambarus <tudor.ambarus@linaro.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/winbond.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -120,9 +120,10 @@ static const struct flash_info winbond_n
 		NO_SFDP_FLAGS(SECT_4K) },
 	{ "w25q80bl", INFO(0xef4014, 0, 64 * 1024,  16)
 		NO_SFDP_FLAGS(SECT_4K) },
-	{ "w25q128", INFO(0xef4018, 0, 0, 0)
-		PARSE_SFDP
-		FLAGS(SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB) },
+	{ "w25q128", INFO(0xef4018, 0, 64 * 1024, 256)
+		FLAGS(SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB)
+		NO_SFDP_FLAGS(SECT_4K | SPI_NOR_DUAL_READ |
+			      SPI_NOR_QUAD_READ) },
 	{ "w25q256", INFO(0xef4019, 0, 64 * 1024, 512)
 		NO_SFDP_FLAGS(SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ)
 		.fixups = &w25q256_fixups },


