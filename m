Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 42E9812D215;
	Tue, 30 Apr 2024 11:14:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1714475649; cv=none; b=L4fWHUFipIP7EonxjtGQZinjeduwmjij0ruI7rJicK1O3bnsSroEVHJ1wtjFYw21dGhu6gwrao+iHuKS2chau4y2lNDYFe7nE43NI3VUMHcyHio/FMQZuM3obdOIaKW9VqmN9V/cTM2T9wZf1VMazip2EJKDmjx//HsVgMnKSL8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1714475649; c=relaxed/simple;
	bh=QER33Um8DSt9li4AakiqdP6eonE84+scmJVfTMhqtCM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bZIptTMBHNOb9PRgcwW9+l2dyy99JngOura6IEzUKx/Ze5MyVvRjLdfgpLA1OvYegyxq8D1c8PyrKQyEUZ1RTNRCdq4ZSd2mDzVEvoYUZQEIghuW3UQrmGALKsnUm68uO1bjvNvrSo4kjxZ7/VLK+zc1HGwks9FR4qoPTrIB2y8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kNpv/Z1k; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kNpv/Z1k"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C1E6DC4AF1B;
	Tue, 30 Apr 2024 11:14:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1714475649;
	bh=QER33Um8DSt9li4AakiqdP6eonE84+scmJVfTMhqtCM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kNpv/Z1khctJDl2cOcafCSbWaJV2kjQIb6LMQHmsp4+fn3AeS46CI34LxY+DOym3F
	 tvueLdjmnzwI76/20IWjkCRPSgMdOSmrwcD7tn9N1JtlH0Z699bwqh11La4G0G6V0i
	 tllpC/lDl3Q2eL12rjsv8qAvsjiYycq6EM8i4xsg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>,
	Christian Marangi <ansuelsmth@gmail.com>,
	Miquel Raynal <miquel.raynal@bootlin.com>
Subject: [PATCH 6.6 122/186] mtd: rawnand: qcom: Fix broken OP_RESET_DEVICE command in qcom_misc_cmd_type_exec()
Date: Tue, 30 Apr 2024 12:39:34 +0200
Message-ID: <20240430103101.575140727@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240430103058.010791820@linuxfoundation.org>
References: <20240430103058.010791820@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Christian Marangi <ansuelsmth@gmail.com>

commit b61bb5bc2c1cd00bb53db42f705735db6e8700f0 upstream.

While migrating to exec_ops in commit a82990c8a409 ("mtd: rawnand: qcom:
Add read/read_start ops in exec_op path"), OP_RESET_DEVICE command handling
got broken unintentionally. Right now for the OP_RESET_DEVICE command,
qcom_misc_cmd_type_exec() will simply return 0 without handling it. Even,
if that gets fixed, an unnecessary FLASH_STATUS read descriptor command is
being added in the middle and that seems to be causing the command to fail
on IPQ806x devices.

So let's fix the above two issues to make OP_RESET_DEVICE command working
again.

Fixes: a82990c8a409 ("mtd: rawnand: qcom: Add read/read_start ops in exec_op path")
Cc: stable@vger.kernel.org
Reviewed-by: Manivannan Sadhasivam <manivannan.sadhasivam@linaro.org>
Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
Signed-off-by: Miquel Raynal <miquel.raynal@bootlin.com>
Link: https://lore.kernel.org/linux-mtd/20240404083157.940-1-ansuelsmth@gmail.com
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mtd/nand/raw/qcom_nandc.c | 7 +++----
 1 file changed, 3 insertions(+), 4 deletions(-)

diff --git a/drivers/mtd/nand/raw/qcom_nandc.c b/drivers/mtd/nand/raw/qcom_nandc.c
index b079605c84d3..b8cff9240b28 100644
--- a/drivers/mtd/nand/raw/qcom_nandc.c
+++ b/drivers/mtd/nand/raw/qcom_nandc.c
@@ -2815,7 +2815,7 @@ static int qcom_misc_cmd_type_exec(struct nand_chip *chip, const struct nand_sub
 			      host->cfg0_raw & ~(7 << CW_PER_PAGE));
 		nandc_set_reg(chip, NAND_DEV0_CFG1, host->cfg1_raw);
 		instrs = 3;
-	} else {
+	} else if (q_op.cmd_reg != OP_RESET_DEVICE) {
 		return 0;
 	}
 
@@ -2830,9 +2830,8 @@ static int qcom_misc_cmd_type_exec(struct nand_chip *chip, const struct nand_sub
 	nandc_set_reg(chip, NAND_EXEC_CMD, 1);
 
 	write_reg_dma(nandc, NAND_FLASH_CMD, instrs, NAND_BAM_NEXT_SGL);
-	(q_op.cmd_reg == OP_BLOCK_ERASE) ? write_reg_dma(nandc, NAND_DEV0_CFG0,
-	2, NAND_BAM_NEXT_SGL) : read_reg_dma(nandc,
-	NAND_FLASH_STATUS, 1, NAND_BAM_NEXT_SGL);
+	if (q_op.cmd_reg == OP_BLOCK_ERASE)
+		write_reg_dma(nandc, NAND_DEV0_CFG0, 2, NAND_BAM_NEXT_SGL);
 
 	write_reg_dma(nandc, NAND_EXEC_CMD, 1, NAND_BAM_NEXT_SGL);
 	read_reg_dma(nandc, NAND_FLASH_STATUS, 1, NAND_BAM_NEXT_SGL);
-- 
2.44.0



