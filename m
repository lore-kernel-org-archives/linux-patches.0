Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8E4222572
	for <patches@lists.linux.dev>; Tue, 18 Apr 2023 12:48:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 136C2C433D2;
	Tue, 18 Apr 2023 12:48:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1681822098;
	bh=zkQ5AhsawpZj7Xix93umrARHMynvPlxsFMYwEHx6efU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g7XEz2sLhaEs8lo3Js0xVdttgtcw3bLJNy+xdreWc8nmalAayHfKZyVBogMg2zgif
	 Z2HQsuDamgb7BaNdQqjNBKkGfi4TouQr4n3hGiUugRGyaZ7tBAwJYkSTkkMbNG9t8n
	 PX/EBICuPZRS8vE2Ry/3nKiXS6rlJ7mnuucNpyXc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.2 022/139] mtd: rawnand: meson: fix bitmask for length in command word
Date: Tue, 18 Apr 2023 14:21:27 +0200
Message-Id: <20230418120314.485369886@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230418120313.725598495@linuxfoundation.org>
References: <20230418120313.725598495@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arseniy Krasnov <avkrasnov@sberdevices.ru>

commit 93942b70461574ca7fc3d91494ca89b16a4c64c7 upstream.

Valid mask is 0x3FFF, without this patch the following problems were
found:

1) [    0.938914] Could not find a valid ONFI parameter page, trying
                  bit-wise majority to recover it
   [    0.947384] ONFI parameter recovery failed, aborting

2) Read with disabled ECC mode was broken.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/3794ffbf-dfea-e96f-1f97-fe235b005e19@sberdevices.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/meson_nand.c |    6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -280,7 +280,7 @@ static void meson_nfc_cmd_access(struct
 
 	if (raw) {
 		len = mtd->writesize + mtd->oobsize;
-		cmd = (len & GENMASK(5, 0)) | scrambler | DMA_DIR(dir);
+		cmd = (len & GENMASK(13, 0)) | scrambler | DMA_DIR(dir);
 		writel(cmd, nfc->reg_base + NFC_REG_CMD);
 		return;
 	}
@@ -544,7 +544,7 @@ static int meson_nfc_read_buf(struct nan
 	if (ret)
 		goto out;
 
-	cmd = NFC_CMD_N2M | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_N2M | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);
@@ -568,7 +568,7 @@ static int meson_nfc_write_buf(struct na
 	if (ret)
 		return ret;
 
-	cmd = NFC_CMD_M2N | (len & GENMASK(5, 0));
+	cmd = NFC_CMD_M2N | (len & GENMASK(13, 0));
 	writel(cmd, nfc->reg_base + NFC_REG_CMD);
 
 	meson_nfc_drain_cmd(nfc);


