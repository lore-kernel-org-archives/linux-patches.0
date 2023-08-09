Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9A9BD174CA
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:00:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 173F9C433C8;
	Wed,  9 Aug 2023 11:00:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691578803;
	bh=XlbgVCpjLjBcuC5CO9oQMBvE6AsXTStywk+HeY1I650=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CGeFcrsXVPI7NUtpJNvo2XLJ3n2yMX/m5eqwjdoSUHsb7qD4QEclRfhblbUGzwAVS
	 0F/iMmYnfH2vScHBD9ZgDGJaVimOXFeYbT96r87z7zolq5IXIrpd222pbATpV5LXtE
	 ciC5kZOKaxgJKp6j/hq4fbVhW6hTW7NnncmQ6sN8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stable@vger.kernel.org,
	Arseniy Krasnov <AVKrasnov@sberdevices.ru>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 5.15 63/92] mtd: rawnand: meson: fix OOB available bytes for ECC
Date: Wed,  9 Aug 2023 12:41:39 +0200
Message-ID: <20230809103635.772775097@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103633.485906560@linuxfoundation.org>
References: <20230809103633.485906560@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

commit 7e6b04f9238eab0f684fafd158c1f32ea65b9eaa upstream.

It is incorrect to calculate number of OOB bytes for ECC engine using
some "already known" ECC step size (1024 bytes here). Number of such
bytes for ECC engine must be whole OOB except 2 bytes for bad block
marker, while proper ECC step size and strength will be selected by
ECC logic.

Fixes: 8fae856c5350 ("mtd: rawnand: meson: add support for Amlogic NAND flash controller")
Cc: <Stable@vger.kernel.org>
Signed-off-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20230705065211.293500-1-AVKrasnov@sberdevices.ru
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/meson_nand.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/meson_nand.c
+++ b/drivers/mtd/nand/raw/meson_nand.c
@@ -1180,7 +1180,6 @@ static int meson_nand_attach_chip(struct
 	struct meson_nfc *nfc = nand_get_controller_data(nand);
 	struct meson_nfc_nand_chip *meson_chip = to_meson_nand(nand);
 	struct mtd_info *mtd = nand_to_mtd(nand);
-	int nsectors = mtd->writesize / 1024;
 	int ret;
 
 	if (!mtd->name) {
@@ -1198,7 +1197,7 @@ static int meson_nand_attach_chip(struct
 	nand->options |= NAND_NO_SUBPAGE_WRITE;
 
 	ret = nand_ecc_choose_conf(nand, nfc->data->ecc_caps,
-				   mtd->oobsize - 2 * nsectors);
+				   mtd->oobsize - 2);
 	if (ret) {
 		dev_err(nfc->dev, "failed to ECC init\n");
 		return -EINVAL;


