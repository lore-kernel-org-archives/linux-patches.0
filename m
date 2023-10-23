Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A3D14282
	for <patches@lists.linux.dev>; Mon, 23 Oct 2023 11:10:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jJOViV+n"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB5B9C433C8;
	Mon, 23 Oct 2023 11:10:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1698059402;
	bh=eSZDGzjZnCry1pW/gshQFJeby5A4F+UD5vYKi8IDgGA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jJOViV+nJpGlBDw2N0OeMI3cekVcCn4WQcX8s+go3e8JJFeYWOAAQJ4br6PGoqVdS
	 /iBCk5wtRYMBN9833T1sHS/Y8r/otzRkAuNguN4ghLi+cVkE/vkwu396FNNSIs9I53
	 qOxJwGh0R+a86sZitmCE3tHRG6X9mu5guSZv54JY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Simek <michal.simek@amd.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.5 165/241] mtd: rawnand: pl353: Ensure program page operations are successful
Date: Mon, 23 Oct 2023 12:55:51 +0200
Message-ID: <20231023104837.899319351@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20231023104833.832874523@linuxfoundation.org>
References: <20231023104833.832874523@linuxfoundation.org>
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

6.5-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Miquel Raynal <miquel.raynal@bootlin.com>

commit 9777cc13fd2c3212618904636354be60835e10bb upstream.

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
Fixes: 08d8c62164a3 ("mtd: rawnand: pl353: Add support for the ARM PL353 SMC NAND controller")
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Tested-by: Michal Simek <michal.simek@amd.com>
Link: https://lore.kernel.org/linux-mtd/20230717194221.229778-3-miquel.raynal@bootlin.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/pl35x-nand-controller.c |    9 +++++++++
 1 file changed, 9 insertions(+)

--- a/drivers/mtd/nand/raw/pl35x-nand-controller.c
+++ b/drivers/mtd/nand/raw/pl35x-nand-controller.c
@@ -513,6 +513,7 @@ static int pl35x_nand_write_page_hwecc(s
 	u32 addr1 = 0, addr2 = 0, row;
 	u32 cmd_addr;
 	int i, ret;
+	u8 status;
 
 	ret = pl35x_smc_set_ecc_mode(nfc, chip, PL35X_SMC_ECC_CFG_MODE_APB);
 	if (ret)
@@ -565,6 +566,14 @@ static int pl35x_nand_write_page_hwecc(s
 	if (ret)
 		goto disable_ecc_engine;
 
+	/* Check write status on the chip side */
+	ret = nand_status_op(chip, &status);
+	if (ret)
+		goto disable_ecc_engine;
+
+	if (status & NAND_STATUS_FAIL)
+		ret = -EIO;
+
 disable_ecc_engine:
 	pl35x_smc_set_ecc_mode(nfc, chip, PL35X_SMC_ECC_CFG_MODE_BYPASS);
 


