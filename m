Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 70A3F15DBBC;
	Mon, 29 Jan 2024 17:14:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548441; cv=none; b=mu0wTEH8s+mmDE8Tg6Hrkji/xyvU1l6iMdMMeTcDTG9h3EPdWSsNlTwrWFeVZKmsXCZ1BWD+lyeIHlU8w4x/NeTRSUT51ueEmcDBNf3o3XnjdSOp9coNT14dAsrEVCsjQQXNjxm25cQwAjO1O8nW3f5xhekBtIdb5502mHlNWOQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548441; c=relaxed/simple;
	bh=rBXweQMo8xHxZAGBRbiNU9+QMAb400XjENrjom3R1Hc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=ZEVOD/sHgKx+sWgls1hNfv87Cl1HTsvmliIUYyqFmKlOSuvzvUkOUZ0BER6pZRtb3EoWlYpuumtfDZrcKf0pv+r93L37av/KwrvN6cXzE1FGNRs3pVfcxqhinfapc4i04vTWyG4PRDPcs0qXkkgaTfgefQB66bgIaDSIJDQXItk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=i6WGAye4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="i6WGAye4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 38501C43394;
	Mon, 29 Jan 2024 17:14:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548441;
	bh=rBXweQMo8xHxZAGBRbiNU9+QMAb400XjENrjom3R1Hc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=i6WGAye4dDVHkadEZmNFIHp2J5YRCOdphrfNa1oDduQo+hcZ01J6o2qaPix4L8uQY
	 gKJMfyOfvRfLBls7sa++2AFNdWlps32RngE3qqyyCtYR/m5LP+BeOtFlK14efYoTQM
	 ERTg2OKOr8glAnGOZUWDUBhKC8TjXF+HV6iJm5as=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Miquel Raynal <miquel.raynal@bootlin.com>,
	=?UTF-8?q?Martin=20Hundeb=C3=B8ll?= <martin@geanix.com>
Subject: [PATCH 6.6 046/331] mtd: rawnand: Prevent crossing LUN boundaries during sequential reads
Date: Mon, 29 Jan 2024 09:01:50 -0800
Message-ID: <20240129170016.286290503@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit bbcd80f53a5e8c27c2511f539fec8c373f500cf4 upstream.

The ONFI specification states that devices do not need to support
sequential reads across LUN boundaries. In order to prevent such event
from happening and possibly failing, let's introduce the concept of
"pause" in the sequential read to handle these cases. The first/last
pages remain the same but any time we cross a LUN boundary we will end
and restart (if relevant) the sequential read operation.

Cc: stable@vger.kernel.org
Fixes: 003fe4b9545b ("mtd: rawnand: Support for sequential cache reads")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Martin Hundebøll <martin@geanix.com>
Link: https://lore.kernel.org/linux-mtd/20231215123208.516590-2-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/nand_base.c |   43 +++++++++++++++++++++++++++++++++------
 include/linux/mtd/rawnand.h      |    2 +
 2 files changed, 39 insertions(+), 6 deletions(-)

--- a/drivers/mtd/nand/raw/nand_base.c
+++ b/drivers/mtd/nand/raw/nand_base.c
@@ -1208,6 +1208,23 @@ static int nand_lp_exec_read_page_op(str
 	return nand_exec_op(chip, &op);
 }
 
+static void rawnand_cap_cont_reads(struct nand_chip *chip)
+{
+	struct nand_memory_organization *memorg;
+	unsigned int pages_per_lun, first_lun, last_lun;
+
+	memorg = nanddev_get_memorg(&chip->base);
+	pages_per_lun = memorg->pages_per_eraseblock * memorg->eraseblocks_per_lun;
+	first_lun = chip->cont_read.first_page / pages_per_lun;
+	last_lun = chip->cont_read.last_page / pages_per_lun;
+
+	/* Prevent sequential cache reads across LUN boundaries */
+	if (first_lun != last_lun)
+		chip->cont_read.pause_page = first_lun * pages_per_lun + pages_per_lun - 1;
+	else
+		chip->cont_read.pause_page = chip->cont_read.last_page;
+}
+
 static int nand_lp_exec_cont_read_page_op(struct nand_chip *chip, unsigned int page,
 					  unsigned int offset_in_page, void *buf,
 					  unsigned int len, bool check_only)
@@ -1226,7 +1243,7 @@ static int nand_lp_exec_cont_read_page_o
 		NAND_OP_DATA_IN(len, buf, 0),
 	};
 	struct nand_op_instr cont_instrs[] = {
-		NAND_OP_CMD(page == chip->cont_read.last_page ?
+		NAND_OP_CMD(page == chip->cont_read.pause_page ?
 			    NAND_CMD_READCACHEEND : NAND_CMD_READCACHESEQ,
 			    NAND_COMMON_TIMING_NS(conf, tWB_max)),
 		NAND_OP_WAIT_RDY(NAND_COMMON_TIMING_MS(conf, tR_max),
@@ -1263,16 +1280,29 @@ static int nand_lp_exec_cont_read_page_o
 	}
 
 	if (page == chip->cont_read.first_page)
-		return nand_exec_op(chip, &start_op);
+		ret = nand_exec_op(chip, &start_op);
 	else
-		return nand_exec_op(chip, &cont_op);
+		ret = nand_exec_op(chip, &cont_op);
+	if (ret)
+		return ret;
+
+	if (!chip->cont_read.ongoing)
+		return 0;
+
+	if (page == chip->cont_read.pause_page &&
+	    page != chip->cont_read.last_page) {
+		chip->cont_read.first_page = chip->cont_read.pause_page + 1;
+		rawnand_cap_cont_reads(chip);
+	} else if (page == chip->cont_read.last_page) {
+		chip->cont_read.ongoing = false;
+	}
+
+	return 0;
 }
 
 static bool rawnand_cont_read_ongoing(struct nand_chip *chip, unsigned int page)
 {
-	return chip->cont_read.ongoing &&
-		page >= chip->cont_read.first_page &&
-		page <= chip->cont_read.last_page;
+	return chip->cont_read.ongoing && page >= chip->cont_read.first_page;
 }
 
 /**
@@ -3446,6 +3476,7 @@ static void rawnand_enable_cont_reads(st
 	if (col)
 		chip->cont_read.first_page++;
 	chip->cont_read.last_page = page + ((readlen >> chip->page_shift) & chip->pagemask);
+	rawnand_cap_cont_reads(chip);
 }
 
 /**
--- a/include/linux/mtd/rawnand.h
+++ b/include/linux/mtd/rawnand.h
@@ -1265,6 +1265,7 @@ struct nand_secure_region {
  * @cont_read: Sequential page read internals
  * @cont_read.ongoing: Whether a continuous read is ongoing or not
  * @cont_read.first_page: Start of the continuous read operation
+ * @cont_read.pause_page: End of the current sequential cache read operation
  * @cont_read.last_page: End of the continuous read operation
  * @controller: The hardware controller	structure which is shared among multiple
  *              independent devices
@@ -1321,6 +1322,7 @@ struct nand_chip {
 	struct {
 		bool ongoing;
 		unsigned int first_page;
+		unsigned int pause_page;
 		unsigned int last_page;
 	} cont_read;
 


