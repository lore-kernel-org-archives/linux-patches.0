Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 13DF5143C72;
	Thu, 11 Apr 2024 10:00:14 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1712829614; cv=none; b=JHthTds2TcJTzT3zniQZmqrTMrBLIyuZZYtgEdsJhLiOLR3sPp6O8NfrNm3EWJpCvJHPgFnv/NKToOVuPOoScF1Fcknr79v1BNDR1gjuygojFWnSDd6NLpNi/z9d4vuKv6WDBNPZdbGjdyl+D9yxtuh7cdQKKqFpc4cIGKYk/XY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1712829614; c=relaxed/simple;
	bh=0YjjAcWMgqc260bYBP3kiFN7AYM5MScTdq3KU0Ufyz4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=bG7KygQulMzHfy2ncQXgvp0A47nTgtT3wsi57DOnuMHBfHnLSkA+PeShfoeq/BSvW1IgLnWV/sEbasmMAgLOJRU1V3ASb6uzCpUgxdOgm6Nlq5t5sQL7UczswPiigVxrBF44ixcDiKkgfTEsi1AiOS7rusCLH72NXBs+oywPe2w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RqYhnB2h; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RqYhnB2h"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F3F7C433C7;
	Thu, 11 Apr 2024 10:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1712829613;
	bh=0YjjAcWMgqc260bYBP3kiFN7AYM5MScTdq3KU0Ufyz4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=RqYhnB2hgTrg6AlJV0Qwm+lBMOCquAj5Clj9qZCNVRSycB0SlfnYYyZ9sFTAY0Zym
	 5XtOGUKYy4OQPyixvUvQbLuaF/U9d9Sz0dXPZvbi6qJfxZaLIYd+WJ3+9ItJetCbXd
	 mKfMkAgFRZGK3pWQNkVsKCVV6qmy1C5WlApYG3j0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jorge Ramirez-Ortiz <jorge@foundries.io>,
	Dominique Martinet <dominique.martinet@atmark-techno.com>,
	Linus Walleij <linus.walleij@linaro.org>,
	Ulf Hansson <ulf.hansson@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 047/175] mmc: core: Fix switch on gp3 partition
Date: Thu, 11 Apr 2024 11:54:30 +0200
Message-ID: <20240411095420.983027638@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240411095419.532012976@linuxfoundation.org>
References: <20240411095419.532012976@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index ef9422917e1ca..c3b329946429c 100644
--- a/drivers/mmc/core/block.c
+++ b/drivers/mmc/core/block.c
@@ -851,10 +851,11 @@ static const struct block_device_operations mmc_bdops = {
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
@@ -869,10 +870,11 @@ static int mmc_blk_part_switch_pre(struct mmc_card *card,
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



