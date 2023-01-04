Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1486DAD48
	for <patches@lists.linux.dev>; Wed,  4 Jan 2023 16:21:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8A79FC433EF;
	Wed,  4 Jan 2023 16:21:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672849297;
	bh=Sh52N/4oQ36B4hWKWoGJgmNOjeg4t01WHjVXah8fEf4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0OE0NycE646Zv+fTuZhoiqAzmHdRYwhbMngG0JRQWHlwqY3RAHvsCJNo7LCa8g7Fi
	 8p0nApM0A8vFgHD+M+ZFCPHhi83BAPGvq3ydaFDaYJ0f/66lrAyL3/OxlWX4D4KnCh
	 ZuoStJuS6UFphNPyGG3DptUqrsdRjkPEuG5uJxxY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Yaliang Wang <Yaliang.Wang@windriver.com>,
	Tudor Ambarus <tudor.ambarus@microchip.com>
Subject: [PATCH 6.0 099/177] mtd: spi-nor: gigadevice: gd25q256: replace gd25q256_default_init with gd25q256_post_bfpt
Date: Wed,  4 Jan 2023 17:06:30 +0100
Message-Id: <20230104160510.636286376@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230104160507.635888536@linuxfoundation.org>
References: <20230104160507.635888536@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yaliang Wang <Yaliang.Wang@windriver.com>

commit 4dc49062a7e9c0c7261807fb855df1c611eb78c3 upstream.

When utilizing PARSE_SFDP to initialize the flash parameter, the
deprecated initializing method spi_nor_init_params_deprecated() and the
function spi_nor_manufacturer_init_params() within it will never be
executed, which results in the default_init hook function will also never
be executed.

This is okay for 'D' generation of GD25Q256, because 'D' generation is
implementing the JESD216B standards, it has QER field defined in BFPT,
parsing the SFDP can properly set the quad_enable function. The 'E'
generation also implements the JESD216B standards, and it has the same
status register definitions as 'D' generation, parsing the SFDP to set
the quad_enable function should also work for 'E' generation.

However, the same thing can't apply to 'C' generation. 'C' generation
'GD25Q256C' implements the JESD216 standards, and it doesn't have the
QER field defined in BFPT, since it does have QE bit in status register
1, the quad_enable hook needs to be tweaked to properly set the
quad_enable function, this can be done in post_bfpt fixup hook.

Fixes: 047275f7de18 ("mtd: spi-nor: gigadevice: gd25q256: Init flash based on SFDP")
Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: Yaliang Wang <Yaliang.Wang@windriver.com>
[tudor.ambarus@microchip.com: Update comment in gd25q256_post_bfpt]
Signed-off-by: Tudor Ambarus <tudor.ambarus@microchip.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/r/20221016171901.1483542-2-yaliang.wang@windriver.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/spi-nor/gigadevice.c |   24 +++++++++++++++++-------
 1 file changed, 17 insertions(+), 7 deletions(-)

--- a/drivers/mtd/spi-nor/gigadevice.c
+++ b/drivers/mtd/spi-nor/gigadevice.c
@@ -8,19 +8,29 @@
 
 #include "core.h"
 
-static void gd25q256_default_init(struct spi_nor *nor)
+static int
+gd25q256_post_bfpt(struct spi_nor *nor,
+		   const struct sfdp_parameter_header *bfpt_header,
+		   const struct sfdp_bfpt *bfpt)
 {
 	/*
-	 * Some manufacturer like GigaDevice may use different
-	 * bit to set QE on different memories, so the MFR can't
-	 * indicate the quad_enable method for this case, we need
-	 * to set it in the default_init fixup hook.
+	 * GD25Q256C supports the first version of JESD216 which does not define
+	 * the Quad Enable methods. Overwrite the default Quad Enable method.
+	 *
+	 * GD25Q256 GENERATION | SFDP MAJOR VERSION | SFDP MINOR VERSION
+	 *      GD25Q256C      | SFDP_JESD216_MAJOR | SFDP_JESD216_MINOR
+	 *      GD25Q256D      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
+	 *      GD25Q256E      | SFDP_JESD216_MAJOR | SFDP_JESD216B_MINOR
 	 */
-	nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+	if (bfpt_header->major == SFDP_JESD216_MAJOR &&
+	    bfpt_header->minor == SFDP_JESD216_MINOR)
+		nor->params->quad_enable = spi_nor_sr1_bit6_quad_enable;
+
+	return 0;
 }
 
 static const struct spi_nor_fixups gd25q256_fixups = {
-	.default_init = gd25q256_default_init,
+	.post_bfpt = gd25q256_post_bfpt,
 };
 
 static const struct flash_info gigadevice_nor_parts[] = {


