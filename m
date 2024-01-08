Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 393A64643F;
	Mon,  8 Jan 2024 14:22:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XaYoswZy"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 15C35C433C8;
	Mon,  8 Jan 2024 14:22:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1704723749;
	bh=ehnjA8Jr/4XkBNkpd+FuV6OsWSYdI0a8OTmem3t2/OE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XaYoswZyoI1IXGjXLj505waqYZukMgI+Onw4O8DXDuff28scA8DkbG+q2FhiEC6/S
	 N1TQZqkfuiH8xf/n7BFDSasXpqVYZejoARnYlLHx+mA2hy9GIBsrLHtLE43dN5kv/1
	 uoPVT3PTKWoLop339SRjzSQkc37zJ1JaJrz84rmY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>
Subject: [PATCH 4.14 6/7] mmc: rpmb: fixes pause retune on all RPMB partitions.
Date: Mon,  8 Jan 2024 15:22:00 +0100
Message-ID: <20240108141854.369402409@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240108141854.158274814@linuxfoundation.org>
References: <20240108141854.158274814@linuxfoundation.org>
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

4.14-stable review patch.  If anyone has any objections, please let me know.

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
@@ -834,9 +834,10 @@ static const struct block_device_operati
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
@@ -851,9 +852,10 @@ static int mmc_blk_part_switch_pre(struc
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
@@ -2929,4 +2931,3 @@ module_exit(mmc_blk_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("Multimedia Card (MMC) block device driver");
-


