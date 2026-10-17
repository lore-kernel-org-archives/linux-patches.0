Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14BE117BED0;
	Sat, 17 Oct 2026 17:34:39 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258480; cv=none; b=KaQTuuH14rH3xQg8BmVUFofVRfE6q8rUvJyIftnuw47MkerRLh8fUJrn61oov5ZOkfQUtOxew+NNoXeetuJ5lW/JxCIrDirtZYXEomYCcBcXXN9Lb1bh6jBei3ZV6ItOHPlPkhQ1upRzLNpjKfZCeJ5maL0fNb29oJgmGygxlwM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258480; c=relaxed/simple;
	bh=j7+AmajgMnrOcikH0Pm4dnePbOGpIuLYSYWj5cSly7Y=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F0T1LSJOsg3Ebi6He+zc4O/ZWQHZ0BAU6fgnTIMxaSG0OUFxStpfQrZSGQuvj/WeWHBJgBaQxYavgssmFHRFO5NgF3y6rWERm8QQNnXh7QxnUoQxn8lslfT6J2/uJ/EcY7O/7YU5AMQskLTtU03GXUY0kBlKv0jRWmg+3wcRjdk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ds8rzYJl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ds8rzYJl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 583461F000C4;
	Sat, 17 Oct 2026 17:34:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258478;
	bh=ct4InAN2ov2HRs/QRnPeXZTnjFgxQup4XYpgi+Y/tU4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ds8rzYJlioWKuhwdt5ddMWORe9TxyNoYLVSFRrv4+y/3Wb3GgR1cuvriMyBkYBCCz
	 hafWFPJ8CDnEQIw0L8R5Mx8JgHceUWm1kyt5UQeKDT79CnYiG0+ubBgh+tAdrIF8WP
	 seCIFvOi3Zn6r4wqVg7IjG+1IAE+Gy6JH4QAP0F8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Takashi Iwai <tiwai@suse.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0899/1674] ALSA: ctxfi: Check the error for index mapping
Date: Sat, 17 Oct 2026 17:52:51 +0200
Message-ID: <20261017160454.205846123@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Takashi Iwai <tiwai@suse.de>

[ Upstream commit 277c6960d4ddb94d16198afd70c92c3d4593d131 ]

The ctxfi driver blindly assumed a proper value returned from
daio_device_index(), but it's not always true.  Add a proper error
check to deal with the error from the function.

Cc: <stable@vger.kernel.org>
Link: https://lore.kernel.org/87cy149n6k.wl-tiwai@suse.de
Link: https://patch.msgid.link/20260329091240.420194-2-tiwai@suse.de
Signed-off-by: Takashi Iwai <tiwai@suse.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/pci/ctxfi/ctdaio.c | 85 ++++++++++++++++++++++++----------------
 1 file changed, 52 insertions(+), 33 deletions(-)

diff --git a/sound/pci/ctxfi/ctdaio.c b/sound/pci/ctxfi/ctdaio.c
index de06e8243c137..411c6a7758d2a 100644
--- a/sound/pci/ctxfi/ctdaio.c
+++ b/sound/pci/ctxfi/ctdaio.c
@@ -98,7 +98,7 @@ static const struct rsc_ops daio_in_rsc_ops_20k2 = {
 	.output_slot	= daio_index,
 };
 
-static unsigned int daio_device_index(enum DAIOTYP type, struct hw *hw)
+static int daio_device_index(enum DAIOTYP type, struct hw *hw)
 {
 	switch (hw->chip_type) {
 	case ATC20K1:
@@ -111,7 +111,9 @@ static unsigned int daio_device_index(enum DAIOTYP type, struct hw *hw)
 		case LINEO3:	return 5;
 		case LINEO4:	return 6;
 		case LINEIM:	return 7;
-		default:	return -EINVAL;
+		default:
+			pr_err("ctxfi: Invalid type %d for hw20k1\n", type);
+			return -EINVAL;
 		}
 	case ATC20K2:
 		switch (type) {
@@ -124,9 +126,12 @@ static unsigned int daio_device_index(enum DAIOTYP type, struct hw *hw)
 		case LINEO4:	return 6;
 		case LINEIM:	return 4;
 		case MIC:	return 5;
-		default:	return -EINVAL;
+		default:
+			pr_err("ctxfi: Invalid type %d for hw20k2\n", type);
+			return -EINVAL;
 		}
 	default:
+		pr_err("ctxfi: Invalid chip type %d\n", hw->chip_type);
 		return -EINVAL;
 	}
 }
@@ -147,8 +152,11 @@ static int dao_spdif_set_spos(struct dao *dao, unsigned int spos)
 
 static int dao_commit_write(struct dao *dao)
 {
-	dao->hw->dao_commit_write(dao->hw,
-		daio_device_index(dao->daio.type, dao->hw), dao->ctrl_blk);
+	int idx = daio_device_index(dao->daio.type, dao->hw);
+
+	if (idx < 0)
+		return idx;
+	dao->hw->dao_commit_write(dao->hw, idx, dao->ctrl_blk);
 	return 0;
 }
 
@@ -308,8 +316,11 @@ static int dai_set_enb_srt(struct dai *dai, unsigned int enb)
 
 static int dai_commit_write(struct dai *dai)
 {
-	dai->hw->dai_commit_write(dai->hw,
-		daio_device_index(dai->daio.type, dai->hw), dai->ctrl_blk);
+	int idx = daio_device_index(dai->daio.type, dai->hw);
+
+	if (idx < 0)
+		return idx;
+	dai->hw->dai_commit_write(dai->hw, idx, dai->ctrl_blk);
 	return 0;
 }
 
@@ -388,7 +399,7 @@ static int dao_rsc_init(struct dao *dao,
 {
 	struct hw *hw = mgr->mgr.hw;
 	unsigned int conf;
-	int err;
+	int idx, err;
 
 	err = daio_rsc_init(&dao->daio, desc, mgr->mgr.hw);
 	if (err)
@@ -407,15 +418,18 @@ static int dao_rsc_init(struct dao *dao,
 	if (err)
 		goto error2;
 
-	hw->daio_mgr_dsb_dao(mgr->mgr.ctrl_blk,
-			daio_device_index(dao->daio.type, hw));
+	idx = daio_device_index(dao->daio.type, hw);
+	if (idx < 0) {
+		err = idx;
+		goto error2;
+	}
+
+	hw->daio_mgr_dsb_dao(mgr->mgr.ctrl_blk, idx);
 	hw->daio_mgr_commit_write(hw, mgr->mgr.ctrl_blk);
 
 	conf = (desc->msr & 0x7) | (desc->passthru << 3);
-	hw->daio_mgr_dao_init(hw, mgr->mgr.ctrl_blk,
-			daio_device_index(dao->daio.type, hw), conf);
-	hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk,
-			daio_device_index(dao->daio.type, hw));
+	hw->daio_mgr_dao_init(hw, mgr->mgr.ctrl_blk, idx, conf);
+	hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk, idx);
 	hw->daio_mgr_commit_write(hw, mgr->mgr.ctrl_blk);
 
 	return 0;
@@ -464,7 +478,7 @@ static int dai_rsc_init(struct dai *dai,
 			const struct daio_desc *desc,
 			struct daio_mgr *mgr)
 {
-	int err;
+	int idx, err;
 	struct hw *hw = mgr->mgr.hw;
 	unsigned int rsr, msr;
 
@@ -478,6 +492,12 @@ static int dai_rsc_init(struct dai *dai,
 	if (err)
 		goto error1;
 
+	idx = daio_device_index(dai->daio.type, dai->hw);
+	if (idx < 0) {
+		err = idx;
+		goto error1;
+	}
+
 	for (rsr = 0, msr = desc->msr; msr > 1; msr >>= 1)
 		rsr++;
 
@@ -486,8 +506,7 @@ static int dai_rsc_init(struct dai *dai,
 	/* default to disabling control of a SRC */
 	hw->dai_srt_set_ec(dai->ctrl_blk, 0);
 	hw->dai_srt_set_et(dai->ctrl_blk, 0); /* default to disabling SRT */
-	hw->dai_commit_write(hw,
-		daio_device_index(dai->daio.type, dai->hw), dai->ctrl_blk);
+	hw->dai_commit_write(hw, idx, dai->ctrl_blk);
 
 	return 0;
 
@@ -605,28 +624,28 @@ static int put_daio_rsc(struct daio_mgr *mgr, struct daio *daio)
 static int daio_mgr_enb_daio(struct daio_mgr *mgr, struct daio *daio)
 {
 	struct hw *hw = mgr->mgr.hw;
-
-	if (daio->output) {
-		hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk,
-				daio_device_index(daio->type, hw));
-	} else {
-		hw->daio_mgr_enb_dai(mgr->mgr.ctrl_blk,
-				daio_device_index(daio->type, hw));
-	}
+	int idx = daio_device_index(daio->type, hw);
+
+	if (idx < 0)
+		return idx;
+	if (daio->output)
+		hw->daio_mgr_enb_dao(mgr->mgr.ctrl_blk, idx);
+	else
+		hw->daio_mgr_enb_dai(mgr->mgr.ctrl_blk, idx);
 	return 0;
 }
 
 static int daio_mgr_dsb_daio(struct daio_mgr *mgr, struct daio *daio)
 {
 	struct hw *hw = mgr->mgr.hw;
-
-	if (daio->output) {
-		hw->daio_mgr_dsb_dao(mgr->mgr.ctrl_blk,
-				daio_device_index(daio->type, hw));
-	} else {
-		hw->daio_mgr_dsb_dai(mgr->mgr.ctrl_blk,
-				daio_device_index(daio->type, hw));
-	}
+	int idx = daio_device_index(daio->type, hw);
+
+	if (idx < 0)
+		return idx;
+	if (daio->output)
+		hw->daio_mgr_dsb_dao(mgr->mgr.ctrl_blk, idx);
+	else
+		hw->daio_mgr_dsb_dai(mgr->mgr.ctrl_blk, idx);
 	return 0;
 }
 
-- 
2.53.0



