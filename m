Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E00BA495F0;
	Mon,  1 Apr 2024 17:00:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1711990841; cv=none; b=rm0/Ilx+UXnkCYiJD/HmhJlWttRp/xc0XvbkjK5mRQYWb0QkBxhwOPInT9wcldUeiQXf747luVc4rBFbJT+OQcbRqR+RzPLXA46+Ho4QHQv1GhJpbIq4X9JNOWeNL7NdJegyoNvmYgAWj0bUjGnH5R98iQQBSusQrrRPmnFssjs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1711990841; c=relaxed/simple;
	bh=l14bJgXnphPm5b1aUWNacFgEdTIslD2JvQeQNgxo8jY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=FKFRu/Lz8FRbpBQ6sU/o2goW+VxH/dwPx/Y42zSJrxJIJPlaYq+PSksXh17XjBKZYsXM7/79ALe2hvkE1sKVxz6n+yZag7Q2BKmWZRGk++3EEgCOJw5nMQV0scU587HoLpGJhu5XvtiVoG27cDN8tglQ3XAkhyARkI/3GDq/Kk0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=qFYnwP+d; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="qFYnwP+d"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4FB2FC43390;
	Mon,  1 Apr 2024 17:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1711990840;
	bh=l14bJgXnphPm5b1aUWNacFgEdTIslD2JvQeQNgxo8jY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qFYnwP+dFdt2Gr0miy0dhw+fdZE1sgu2xVgbcAB+7P+/8vnS021307ABEQomaqmpm
	 Mv6vMYAdDbI3GkGHH4JOVMa5fuWMgCigBchYOYanPzpVjtPhlMa3vEYWWaS+DhVLIQ
	 gugGDmxXP7Wf5TMRygEfVLBbeKZhTjPPcTUavpbA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 081/272] mmc: core: Fix switch on gp3 partition
Date: Mon,  1 Apr 2024 17:44:31 +0200
Message-ID: <20240401152533.130200605@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240401152530.237785232@linuxfoundation.org>
References: <20240401152530.237785232@linuxfoundation.org>
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
index ea60efaecb0dd..4688a658d6a6d 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -889,10 +889,11 @@ static const struct block_device_operations mmc_bdops = {
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
@@ -907,10 +908,11 @@ static int mmc_blk_part_switch_pre(struct mmc_card *card,
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



