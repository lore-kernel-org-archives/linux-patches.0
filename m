Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9BF7C1E86C;
	Mon,  1 Apr 2024 16:40:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711989611; cv=none; b=GH0UFlW5Wd5uZUziQWLsv7ALoB7EtAehj/1Ta4oSi1tQAbr2cgv+baADuGFXpHRk76/pUCfl0jGwxa5Ch9MiWHOgG5jt5mesEYbUrOpo3qC4JS9/frD56OaZNh+EHis8ErsOV/CgSlsqx0IxUpDWZAhxaqKXA9LP65YDpRhwQXs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711989611; c=relaxed/simple;
	bh=4D1FsQuh3PsAD10cQAU5ukHlnrUSuC7aia9ZIFigae8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VClhtiPJIGinL8+rOP2OwezuJKBWxUoIErJCV72dghjjIzlBI+Z0ECbPX4hvzTItZ8j1365CRlGvi1DlnleuK4fPZsy3DLB8G5mPFgDyfNuF8ah3GxU8MT0ooejCJuGeTUHrKJTIC7ISXpvHDw46JOA4fEos3TaxJ9JPBb9PHp4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OPqvyzJS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OPqvyzJS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF605C433F1;
	Mon,  1 Apr 2024 16:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711989611;
	bh=4D1FsQuh3PsAD10cQAU5ukHlnrUSuC7aia9ZIFigae8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=OPqvyzJS7mCehDTZ+38rGDA1+xVyAcyqCginYp9FE/U7fwpOerjQiryVvPGhEFeM+
	 6ekUEwP5TMbFis1HmskcUoU86XCTX1k3kRe0wt9iKOpNRXUif8PoSDLOmA/pWl/Mea
	 dy3KyhR3a3LHj22zuNr3J5jq8fN1S1f5pVfgthNM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 101/396] mmc: core: Fix switch on gp3 partition
Date: Mon,  1 Apr 2024 17:42:30 +0200
Message-ID: <20240401152550.932309734@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152547.867452742@linuxfoundation.org>
References: <20240401152547.867452742@linuxfoundation.org>
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

From: Dominique Martinet <dominique.martinet@atmark-techno.com>

[ Upstream commit 4af59a8df5ea930038cd3355e822f5eedf4accc1 ]

Commit e7794c14fd73 ("mmc: rpmb: fixes pause retune on all RPMB
partitions.") added a mask check for 'part_type', but the mask used was
wrong leading to the code intended for rpmb also being executed for GP3.

On some MMCs (but not all) this would make gp3 partition inaccessible:
armadillo:~# head -c 1 < /dev/mmcblk2gp3
head: standard input: I/O error
armadillo:~# dmesg -c
[  422.976583] mmc2: running CQE recovery
[  423.058182] mmc2: running CQE recovery
[  423.137607] mmc2: running CQE recovery
[  423.137802] blk_update_request: I/O error, dev mmcblk2gp3, sector 0 op 0x0:(READ) flags 0x80700 phys_seg 4 prio class 0
[  423.237125] mmc2: running CQE recovery
[  423.318206] mmc2: running CQE recovery
[  423.397680] mmc2: running CQE recovery
[  423.397837] blk_update_request: I/O error, dev mmcblk2gp3, sector 0 op 0x0:(READ) flags 0x0 phys_seg 1 prio class 0
[  423.408287] Buffer I/O error on dev mmcblk2gp3, logical block 0, async page read

the part_type values of interest here are defined as follow:
main  0
boot0 1
boot1 2
rpmb  3
gp0   4
gp1   5
gp2   6
gp3   7

so mask with EXT_CSD_PART_CONFIG_ACC_MASK (7) to correctly identify rpmb

Fixes: e7794c14fd73 ("mmc: rpmb: fixes pause retune on all RPMB partitions.")
Cc: stable@vger.kernel.org
Cc: Jorge Ramirez-Ortiz <jorge@foundries.io>
Signed-off-by: Dominique Martinet <dominique.martinet@atmark-techno.com>
Reviewed-by: Linus Walleij <linus.walleij@linaro.org>
Link: https://lore.kernel.org/r/20240306-mmc-partswitch-v1-1-bf116985d950@codewreck.org
Signed-off-by: Ulf Hansson <ulf.hansson@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/mmc/core/block.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/mmc/core/block.c b/drivers/mmc/core/block.c
index 32d49100dff51..86efa6084696e 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -874,10 +874,11 @@ static const struct block_device_operations mmc_bdops = {
 static int mmc_blk_part_switch_pre(struct mmc_card *card,
 				   unsigned int part_type)
 {
-	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_RPMB;
+	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_MASK;
+	const unsigned int rpmb = EXT_CSD_PART_CONFIG_ACC_RPMB;
 	int ret = 0;
 
-	if ((part_type & mask) == mask) {
+	if ((part_type & mask) == rpmb) {
 		if (card->ext_csd.cmdq_en) {
 			ret = mmc_cmdq_disable(card);
 			if (ret)
@@ -892,10 +893,11 @@ static int mmc_blk_part_switch_pre(struct mmc_card *card,
 static int mmc_blk_part_switch_post(struct mmc_card *card,
 				    unsigned int part_type)
 {
-	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_RPMB;
+	const unsigned int mask = EXT_CSD_PART_CONFIG_ACC_MASK;
+	const unsigned int rpmb = EXT_CSD_PART_CONFIG_ACC_RPMB;
 	int ret = 0;
 
-	if ((part_type & mask) == mask) {
+	if ((part_type & mask) == rpmb) {
 		mmc_retune_unpause(card->host);
 		if (card->reenable_cmdq && !card->ext_csd.cmdq_en)
 			ret = mmc_cmdq_enable(card);
-- 
2.43.0



