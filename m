Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 395201A6192;
	Tue, 30 Jul 2024 17:02:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1722358955; cv=none; b=kvoQDYskyekA4jfa/Vh2HhLQnCVkn7mvMRZ6LhKMcsUY4NNMcD8HtfDUK6q5ECvYjUjIShW7HthrZZ8PKQm4wJXfI+OTQHWrQIy3N9qDZVAd3+hcWSyftDRfQGI4gdvFxWn5IwNP/FOIIvxeAaW2vlzhuJ0eEHoqlPRL50eIcjQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1722358955; c=relaxed/simple;
	bh=gZdl/+Y9usrDAduarSntyMOhRHABcKLnF0hHrzdUPBw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=f693j65iLy7Qsfc3/STrCEcxAq+PveczgMTWgXAsCuyyF7k9TG/WKzq7F7Xiu+6xjCu5Z3patHodvBAQcmSSY2mqQmywPEAqn1s+BsiWT1h++jXW2sK2Qb1t1DCjOulQpKrhAbTAs/bK1yGT5/tlEX3XVwoMH0suCAFiLOQIyTc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=MfhcV37K; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="MfhcV37K"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2078EC32782;
	Tue, 30 Jul 2024 17:02:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1722358954;
	bh=gZdl/+Y9usrDAduarSntyMOhRHABcKLnF0hHrzdUPBw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=MfhcV37K/MmINrTHSnnWz4wGvv7rvsjzCMBUlyadnG9DC6pxhn8+CHuiP7wdt/ZT4
	 TUWEzyr+nh5eDvabFO5GVoXDAXqq7ijPgBTEr9RkeFCA2xFVMB0/KRHzgxv92pCfqK
	 HfyGqYDJrHrKj0/pNEoG0zC1iebgtrF5CS8ZHSPA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hartmut Birr <e9hack@gmail.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Michael Walle <mwalle@kernel.org>,
	Tudor Ambarus <tudor.ambarus@linaro.org>,
	Esben Haabendal <esben@geanix.com>,
	Pratyush Yadav <pratyush@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 411/809] mtd: spi-nor: winbond: fix w25q128 regression
Date: Tue, 30 Jul 2024 17:44:47 +0200
Message-ID: <20240730151740.923725268@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240730151724.637682316@linuxfoundation.org>
References: <20240730151724.637682316@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Walle <mwalle@kernel.org>

[ Upstream commit d35df77707bf5ae1221b5ba1c8a88cf4fcdd4901 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/spi-nor/winbond.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/mtd/spi-nor/winbond.c b/drivers/mtd/spi-nor/winbond.c
index 142fb27b2ea9a..e065e4fd42a33 100644
--- a/drivers/mtd/spi-nor/winbond.c
+++ b/drivers/mtd/spi-nor/winbond.c
@@ -105,7 +105,9 @@ static const struct flash_info winbond_nor_parts[] = {
 	}, {
 		.id = SNOR_ID(0xef, 0x40, 0x18),
 		.name = "w25q128",
+		.size = SZ_16M,
 		.flags = SPI_NOR_HAS_LOCK | SPI_NOR_HAS_TB,
+		.no_sfdp_flags = SECT_4K | SPI_NOR_DUAL_READ | SPI_NOR_QUAD_READ,
 	}, {
 		.id = SNOR_ID(0xef, 0x40, 0x19),
 		.name = "w25q256",
-- 
2.43.0



