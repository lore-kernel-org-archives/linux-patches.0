Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C8BD416842;
	Sat, 12 Sep 2026 09:33:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789205610; cv=none; b=WapI2TlbxO3oebJA6p32mJDz5S2dg/VJhSAk9iNuVzaagxryfq11wjC1SO8Z3Kd6sp5cSs265lkY2nXHO1H8vFeEVmJ6Dx4/BVZILSNLMlE1UBfEBzJNdEDcmY4CZiUnJFN9xodmYxkU7eYgQHxvXfuxGywu9kfxx4dlOmQXI1Y=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789205610; c=relaxed/simple;
	bh=8Qb4OI8k/0kUl6/RFqrXALRmc/quLoAfTFP7iHn5nJc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qv3TI4VA5fTXahFHy+Pn0Rlk/jutyNi4yffOILiGLP2WsXxSr6xpGu1aja/vmbCdsaM04iMbW5ZIoj4wAsjmHHJwuuv0UsG1k8zTFIXWpS0cM3h3bRTTF1+uMb6Z8q+xFBLv8d3yrwEUcycrY8tpCD91I0tIgXy1hvggNLNAm+0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EBL2133p; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EBL2133p"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D12151F000FF;
	Sat, 12 Sep 2026 09:33:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789205604;
	bh=KG6qjKKYJQO681JT3gfVDsk32Zm+SQRitQVU3OASNJU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=EBL2133phLPn0+i3zrRf+2RUd98XWkAWauk0YbOV1mkNiEYC24NrJYEYfFzyR8aVw
	 FB0zPLQ7HMYbMtxG7j5b0tcBVwNZELkPRT/3kN0XUt/KhmMwMbvGJlmMxjKKM7GSAB
	 OZerQS68EKGt6XrtFLwqfUbnfyF8XKkR+a6rR9AQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0035/1518] mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses
Date: Sat, 12 Sep 2026 08:36:44 +0200
Message-ID: <20260912065624.224597916@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>

[ Upstream commit 80ecacd054ffeb60cd28e46ed5cd6bd0d2de318b ]

Any access not using the hardware ECC engine should be monolithic
because the controller has its very own way of handling the end of a
transaction during operation configuration, so we cannot easily make
repeated reads.

This has the side effect of fixing support for software ECC engines.

Suggested-by: Andrea Scian <andrea.scian@dave.eu>
Cc: stable@vger.kernel.org
Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -914,7 +914,6 @@ static int pl35x_nand_init_hw_ecc_contro
 	chip->ecc.steps = mtd->writesize / chip->ecc.size;
 	chip->ecc.read_page = pl35x_nand_read_page_hwecc;
 	chip->ecc.write_page = pl35x_nand_write_page_hwecc;
-	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 	pl35x_smc_set_ecc_pg_size(nfc, chip, mtd->writesize);
 
 	nfc->ecc_buf = devm_kmalloc(nfc->dev, chip->ecc.bytes * chip->ecc.steps,
@@ -981,7 +980,6 @@ static int pl35x_nand_attach_chip(struct
 	case NAND_ECC_ENGINE_TYPE_NONE:
 	case NAND_ECC_ENGINE_TYPE_SOFT:
 		dev_dbg(nfc->dev, "Using software ECC (Hamming 1-bit/512B)\n");
-		chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
 		break;
 	case NAND_ECC_ENGINE_TYPE_ON_HOST:
 		dev_dbg(nfc->dev, "Using hardware ECC\n");
@@ -995,6 +993,9 @@ static int pl35x_nand_attach_chip(struct
 		return -EINVAL;
 	}
 
+	chip->ecc.read_page_raw = nand_monolithic_read_page_raw;
+	chip->ecc.write_page_raw = nand_monolithic_write_page_raw;
+
 	return 0;
 }
 


