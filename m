Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3222E15E84
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:27:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DWXt+osN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9D861C433CA;
	Mon, 23 Oct 2023 11:27:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698060440;
	bh=RMJdTkNsf5KpFN8WYdms4Kt6Di2xYpxFVh9AL+kEkbw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=DWXt+osNF7zPksw2fmTxw4/LVDvXuE5tmcFyisfOKn+/gSeOIgnWeicwoo3Di/Ipw
	 0ojTnzpKtX7qGD3PE5votfWDYWieokgn93/BOS7t0e8MCR5g+/2qcwvUQ0kcnihixY
	 LN5DN/aQCz6aZFakJJnm7ISlXcXOp1dgwmOC/cd0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.1 145/196] mtd: rawnand: arasan: Ensure program page operations are successful
Date: Mon, 23 Oct 2023 12:56:50 +0200
Message-ID: <20231023104832.583146848@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104828.488041585@linuxfoundation.org>
References: <20231023104828.488041585@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 3a4a893dbb19e229db3b753f0462520b561dee98 upstream.

The NAND core complies with the ONFI specification, which itself
mentions that after any program or erase operation, a status check
should be performed to see whether the operation was finished *and*
successful.

The NAND core offers helpers to finish a page write (sending the
"PAGE PROG" command, waiting for the NAND chip to be ready again, and
checking the operation status). But in some cases, advanced controller
drivers might want to optimize this and craft their own page write
helper to leverage additional hardware capabilities, thus not always
using the core facilities.

Some drivers, like this one, do not use the core helper to finish a page
write because the final cycles are automatically managed by the
hardware. In this case, the additional care must be taken to manually
perform the final status check.

Let's read the NAND chip status at the end of the page write helper and
return -EIO upon error.

Cc: Michal Simek <michal.simek@amd.com>
Cc: stable@vger.kernel.org
Fixes: 88ffef1b65cf ("mtd: rawnand: arasan: Support the hardware BCH ECC engine")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Acked-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/linux-mtd/20230717194221.229778-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/arasan-nand-controller.c |   16 ++++++++++++++--
 1 file changed, 14 insertions(+), 2 deletions(-)

--- a/drivers/mtd/nand/raw/arasan-nand-controller.c
+++ b/drivers/mtd/nand/raw/arasan-nand-controller.c
@@ -515,6 +515,7 @@ static int anfc_write_page_hw_ecc(struct
 	struct mtd_info *mtd = nand_to_mtd(chip);
 	unsigned int len = mtd->writesize + (oob_required ? mtd->oobsize : 0);
 	dma_addr_t dma_addr;
+	u8 status;
 	int ret;
 	struct anfc_op nfc_op = {
 		.pkt_reg =
@@ -561,10 +562,21 @@ static int anfc_write_page_hw_ecc(struct
 	}
 
 	/* Spare data is not protected */
-	if (oob_required)
+	if (oob_required) {
 		ret = nand_write_oob_std(chip, page);
+		if (ret)
+			return ret;
+	}
+
+	/* Check write status on the chip side */
+	ret = nand_status_op(chip, &status);
+	if (ret)
+		return ret;
+
+	if (status & NAND_STATUS_FAIL)
+		return -EIO;
 
-	return ret;
+	return 0;
 }
 
 static int anfc_sel_write_page_hw_ecc(struct nand_chip *chip, const u8 *buf,


