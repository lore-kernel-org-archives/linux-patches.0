Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8FE6E5540A7;
	Wed,  9 Sep 2026 13:56:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788962165; cv=none; b=Bpup7vyWhumg2vZzalAfT0q8npM5bFHgdZNtUBYcjFbEQbVItCfwz9Bod8UPPcuZEfWEm7TyF23TgU0gHER6wsi+kDtLtD6qDh1rcxFSaOi3ic6jg3OaR5TCQAq3VBgbowaCeWFnWS9o7z1pcuSVF9Gtl9rgnX76GsE+YiJATqg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788962165; c=relaxed/simple;
	bh=ktKaMU8cb/KqC22Vnh6vVAoskwHNxbEU/e/eMfIgT+Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AtpzYBPrN5dC8lcY/lJVTnhwLSWJhJjK4HWNRwsOAYcBoXaq5avOHV58DU4CXlnt5j80uDwv6P4P5EFyOpLdPdB+wgoCEHcc5Lp4P09GqPF/XzWZrj7ZxS79Bt9RQGgtKz+F07b4J0K7OMnoRJ5p4q1s+rYXE1i0/siJ9DTFL18=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qqgol1r8; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qqgol1r8"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DA10D1F00A3A;
	Wed,  9 Sep 2026 13:56:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788962164;
	bh=UxGlY7BoxA5vWNiLRL2OiMTtl28b6tiL7J6ss4RCqDM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=qqgol1r8906UIIlctCw24uIyIMHRj2vmo66GuhL0iLqn+sw0LrMuMRmzK/HDtc16c
	 h/LeLLwtgo3OWg5DQxEibXqXDfZD6fHjhTqftTKzc9dqvrDgHfi/t5XavIGzeh5I8R
	 W++hnzaU/CkAZsfqut8ofX/+EfOEoe7H1t+/80NU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrea Scian <andrea.scian@dave.eu>,
	"Miquel Raynal (DAVE)" <miquel.raynal@bootlin.com>,
	Michal Simek <michal.simek@amd.com>
Subject: [PATCH 7.2 195/556] mtd: rawnand: pl353: Make sure we use the monolithic helpers for raw accesses
Date: Wed,  9 Sep 2026 15:37:55 +0200
Message-ID: <20260909134237.263637931@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134230.441546314@linuxfoundation.org>
References: <20260909134230.441546314@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal (DAVE) <miquel.raynal@bootlin.com>

commit 80ecacd054ffeb60cd28e46ed5cd6bd0d2de318b upstream.

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
 


