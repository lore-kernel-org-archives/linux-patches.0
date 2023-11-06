Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 18E1A2030D
	for <patches@lists.linux.dev>; Mon,  6 Nov 2023 13:19:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kzymFdPU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3E473C433C7;
	Mon,  6 Nov 2023 13:19:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1699276792;
	bh=pMaKvlHyUWEWEYZtP8QcPModizmmkC9hptUqUJiInz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kzymFdPUXgDigA/j9BjsNr/gWbl1PdN0V0SwZoLU6wo9LhmIca/bX7S2EymEPZXzN
	 V5rZd0gzpzLmZzCjdwBu+HPsVNPV3hep3OlybnCODnsTLk2rsXBqIgvYYkCchJ+9Xl
	 0aSSQ10NThoFo83guPtrSmsnxjS7nMIlMlgAlotw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Aviram Dali <aviramd@marvell.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	Ravi Chandra Minnikanti <rminnikanti@marvell.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 01/74] mtd: rawnand: marvell: Ensure program page operations are successful
Date: Mon,  6 Nov 2023 14:03:21 +0100
Message-ID: <20231106130301.733850297@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231106130301.687882731@linuxfoundation.org>
References: <20231106130301.687882731@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

[ Upstream commit 3e01d5254698ea3d18e09d96b974c762328352cd ]

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

Cc: stable@vger.kernel.org
Fixes: 02f26ecf8c77 ("mtd: nand: add reworked Marvell NAND controller driver")
Reported-by: Aviram Dali <aviramd@marvell.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Ravi Chandra Minnikanti <rminnikanti@marvell.com>
Link: https://lore.kernel.org/linux-mtd/20230717194221.229778-1-miquel.raynal@bootlin.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mtd/nand/raw/marvell_nand.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/drivers/mtd/nand/raw/marvell_nand.c b/drivers/mtd/nand/raw/marvell_nand.c
index c49a3e105b427..9a119688c0a63 100644
--- a/drivers/mtd/nand/raw/marvell_nand.c
+++ b/drivers/mtd/nand/raw/marvell_nand.c
@@ -1109,6 +1109,7 @@ static int marvell_nfc_hw_ecc_hmg_do_write_page(struct nand_chip *chip,
 		.ndcb[2] = NDCB2_ADDR5_PAGE(page),
 	};
 	unsigned int oob_bytes = lt->spare_bytes + (raw ? lt->ecc_bytes : 0);
+	u8 status;
 	int ret;
 
 	/* NFCv2 needs more information about the operation being executed */
@@ -1142,7 +1143,18 @@ static int marvell_nfc_hw_ecc_hmg_do_write_page(struct nand_chip *chip,
 
 	ret = marvell_nfc_wait_op(chip,
 				  PSEC_TO_MSEC(chip->data_interface.timings.sdr.tPROG_max));
-	return ret;
+	if (ret)
+		return ret;
+
+	/* Check write status on the chip side */
+	ret = nand_status_op(chip, &status);
+	if (ret)
+		return ret;
+
+	if (status & NAND_STATUS_FAIL)
+		return -EIO;
+
+	return 0;
 }
 
 static int marvell_nfc_hw_ecc_hmg_write_page_raw(struct nand_chip *chip,
@@ -1570,6 +1582,7 @@ static int marvell_nfc_hw_ecc_bch_write_page(struct nand_chip *chip,
 	int data_len = lt->data_bytes;
 	int spare_len = lt->spare_bytes;
 	int chunk, ret;
+	u8 status;
 
 	marvell_nfc_select_target(chip, chip->cur_cs);
 
@@ -1607,6 +1620,14 @@ static int marvell_nfc_hw_ecc_bch_write_page(struct nand_chip *chip,
 	if (ret)
 		return ret;
 
+	/* Check write status on the chip side */
+	ret = nand_status_op(chip, &status);
+	if (ret)
+		return ret;
+
+	if (status & NAND_STATUS_FAIL)
+		return -EIO;
+
 	return 0;
 }
 
-- 
2.42.0



