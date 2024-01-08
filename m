Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF78C51C2B;
	Mon,  8 Jan 2024 15:43:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="bB7iHVY4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3C1B1C433C8;
	Mon,  8 Jan 2024 15:43:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704728634;
	bh=m5R/EBKpUB3Kk61+dgP1dpSqBeBITStF4/GGzq/Kynk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=bB7iHVY4RlcVekfgG6AoR+USL6ubi80olz9xCxwAUg9RiRgHMtXLnkdm8V2q6DY7E
	 U4R6PwWUppuIwD4ySQcp/k/XNLsOtyDeP2+/yRagT4NS5Wo7mzNAfr02/c6lap9U+o
	 PggVvxB6LH3n7Q23MVhDIFWyzQgyg2E9jYUWggrQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 6.1 139/150] mmc: rpmb: fixes pause retune on all RPMB partitions.
Date: Mon,  8 Jan 2024 16:36:30 +0100
Message-ID: <20240108153517.600894762@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108153511.214254205@linuxfoundation.org>
References: <20240108153511.214254205@linuxfoundation.org>
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

From: Jorge Ramirez-Ortiz <jorge@foundries.io>

commit e7794c14fd73e5eb4a3e0ecaa5334d5a17377c50 upstream.

When RPMB was converted to a character device, it added support for
multiple RPMB partitions (Commit 97548575bef3 ("mmc: block: Convert RPMB to
a character device").

One of the changes in this commit was transforming the variable target_part
defined in __mmc_blk_ioctl_cmd into a bitmask. This inadvertently regressed
the validation check done in mmc_blk_part_switch_pre() and
mmc_blk_part_switch_post(), so let's fix it.

Fixes: 97548575bef3 ("mmc: block: Convert RPMB to a character device")
Signed-off-by: Jorge Ramirez-Ortiz <jorge@foundries.io>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/r/20231201153143.1449753-1-jorge@foundries.io
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/mmc/core/block.c |    7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -866,9 +866,10 @@ static const struct block_device_operati
 static int mmc_blk_part_switch_pre(struct mmc_card *card,
 				   unsigned int part_type)
 {
+	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_RPMB;
 	int ret = 0;
 
-	if (part_type == EXT_CSD_PART_CONFIG_ACC_RPMB) {
+	if ((part_type & mask) == mask) {
 		if (card->ext_csd.cmdq_en) {
 			ret = mmc_cmdq_disable(card);
 			if (ret)
@@ -883,9 +884,10 @@ static int mmc_blk_part_switch_pre(struc
 static int mmc_blk_part_switch_post(struct mmc_card *card,
 				    unsigned int part_type)
 {
+	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_RPMB;
 	int ret = 0;
 
-	if (part_type == EXT_CSD_PART_CONFIG_ACC_RPMB) {
+	if ((part_type & mask) == mask) {
 		mmc_retune_unpause(card->host);
 		if (card->reenable_cmdq && !card->ext_csd.cmdq_en)
 			ret = mmc_cmdq_enable(card);
@@ -3180,4 +3182,3 @@ module_exit(mmc_blk_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Multimedia Card (MMC) block device driver");
-


