Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB62B7E
	for <patches@lists.linux.dev>; Wed,  2 Nov 2022 02:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE7EDC43470;
	Wed,  2 Nov 2022 02:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1667356817;
	bh=flm/uUKV4mhs7EWfUkurx135fN2KPjZvwASFEHuc4fo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ah7R3OzrMArwm/PCcG7986THqI+bcWxR992xKawpIM0K90p842cnzwuWHHWtvXC+j
	 Wx/CIzo+XuPpOvepxgs23wC9+g7Dfo0Fx1QHm1GoOe5CjU2xVrY5F5Wl1j4N7D6AFc
	 6rRQd6k2DKBowtIJPaew08jgrM2Tl3Zutu+xFeFo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Hongyu Ning <hongyu.ning@intel.com>,
	Mika Westerberg <mika.westerberg@linux.intel.com>,
	Michael Walle <michael@walle.cc>,
	Tudor Ambarus <tudor.ambarus@microchip.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.0 036/240] mtd: spi-nor: core: Ignore -ENOTSUPP in spi_nor_init()
Date: Wed,  2 Nov 2022 03:30:11 +0100
Message-Id: <20221102022112.220709200@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221102022111.398283374@linuxfoundation.org>
References: <20221102022111.398283374@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Mika Westerberg <mika.westerberg@linux.intel.com>

commit 69d04ca999499bccb6ca849fa2bfc5e6448f7233 upstream.

The Intel SPI-NOR controller does not support the 4-byte address opcode
so ->set_4byte_addr_mode() ends up returning -ENOTSUPP and the SPI flash
chip probe fail like this:

  [ 12.291082] spi-nor: probe of spi0.0 failed with error -524

Whereas previously before commit 08412e72afba ("mtd: spi-nor: core:
Return error code from set_4byte_addr_mode()") it worked just fine.

Fix this by ignoring -ENOTSUPP in spi_nor_init().

Fixes: 08412e72afba ("mtd: spi-nor: core: Return error code from set_4byte_addr_mode()")
Cc: stable@vger.kernel.org
Reported-by: Hongyu Ning <hongyu.ning@intel.com>
Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
Reviewed-by: Michael Walle <michael@walle.cc>
Acked-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20220923093441.3178-1-mika.westerberg@linux.intel.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/core.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/drivers/mtd/spi-nor/core.c
+++ b/drivers/mtd/spi-nor/core.c
@@ -2724,7 +2724,9 @@ static int spi_nor_init(struct spi_nor *
 		 */
 		WARN_ONCE(nor->flags & SNOR_F_BROKEN_RESET,
 			  "enabling reset hack; may not recover from unexpected reboots\n");
-		return nor->params->set_4byte_addr_mode(nor, true);
+		err = nor->params->set_4byte_addr_mode(nor, true);
+		if (err && err != -ENOTSUPP)
+			return err;
 	}
 
 	return 0;


