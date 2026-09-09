Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6090572699;
	Wed,  9 Sep 2026 14:38:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788964684; cv=none; b=oxDJMx3VX8Wqa1KriZ3mpk6afdZP1qbwIhL9QU2NHOqytzheJECRTRT8PqTTW2pRPy3Nd6vA2BDDz0ylPbf6vuCScbfwRE6BqT/XRovpvTYK58Flc/fXzNd+fyw6Oxfit/JI0wtEe4zae0UQMAteqbrhxZGsXv8D60R256TosJ8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788964684; c=relaxed/simple;
	bh=uCwb5cpfbxSkpwyTPUOZ8b+Ljlya3inyO0EsrJ04O/w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k+5otG+tSfcKpJslbVRCqv8HCdQz+sIqq/wx3vShubZi9kQFYGqJnJQyvZpeTuhwR497BtW0cSBiT8s56qUVXqIwI5u3USZ2faCJzCDz27pDGOCxrojYYD0/DHKIp+DMY1+/WiTSjCSuoEuHAjoo2sX6ENqtPGC8gV+7vCmZkLU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lXn4elx9; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lXn4elx9"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 011DC1F00A3D;
	Wed,  9 Sep 2026 14:38:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788964682;
	bh=6tp32J8mImBnTnNAUtVCQlU09KnopqI2egeicYUIvec=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=lXn4elx9G0oAj34rNFcaGhae1YxDba8hqZ0xkAGSI95qj4Z2CJegWU9tcKvPAcwLN
	 onsfj989UP3Ss/R6DNM8+2xYClw7TsATvn2TAZq9igQIVffA20dxvDWXD7g2tu0H4B
	 3uYTmfczozpYArpb9WBaY2F6c+Q+O/iC+Blo6Ja0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 506/583] ASoC: codecs: aw88261: reduce log spam
Date: Wed,  9 Sep 2026 15:43:11 +0200
Message-ID: <20260909134255.288903278@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260909134237.773280130@linuxfoundation.org>
References: <20260909134237.773280130@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Val Packett <val@packett.cool>

[ Upstream commit d90c361af215a9fa2a986d9f47d554d0cf3401dd ]

This driver would create a wall of logspam during initialization due to
e.g. the PLL not being ready while waiting for it to stabilize. Change
intermediate dev_err() calls to dev_dbg() to reduce the noise.

While here, log the detected chip ID when that check fails.

Signed-off-by: Val Packett <val@packett.cool>
Tested-by: Luca Weiss <luca.weiss@fairphone.com>
Link: https://patch.msgid.link/20260529200550.529719-4-val@packett.cool
Signed-off-by: Mark Brown <broonie@kernel.org>
Stable-dep-of: 06b6f1245567 ("ASoC: codecs: aw88261: only check PLL and clock state at power-up")
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 sound/soc/codecs/aw88261.c |   24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -150,7 +150,7 @@ static int aw88261_dev_get_iis_status(st
 	if (ret)
 		return ret;
 	if ((reg_val & AW88261_BIT_PLL_CHECK) != AW88261_BIT_PLL_CHECK) {
-		dev_err(aw_dev->dev, "check pll lock fail,reg_val:0x%04x", reg_val);
+		dev_dbg(aw_dev->dev, "check pll lock fail,reg_val:0x%04x", reg_val);
 		return -EINVAL;
 	}
 
@@ -164,7 +164,7 @@ static int aw88261_dev_check_mode1_pll(s
 	for (i = 0; i < AW88261_DEV_SYSST_CHECK_MAX; i++) {
 		ret = aw88261_dev_get_iis_status(aw_dev);
 		if (ret) {
-			dev_err(aw_dev->dev, "mode1 iis signal check error");
+			dev_dbg(aw_dev->dev, "mode1 iis signal check error");
 			usleep_range(AW88261_2000_US, AW88261_2000_US + 10);
 		} else {
 			return ret;
@@ -255,7 +255,7 @@ static int aw88261_dev_check_sysst(struc
 		check_val = reg_val & (~AW88261_BIT_SYSST_CHECK_MASK)
 							& AW88261_BIT_SYSST_CHECK;
 		if (check_val != AW88261_BIT_SYSST_CHECK) {
-			dev_err(aw_dev->dev, "check sysst fail, reg_val=0x%04x, check:0x%x",
+			dev_dbg(aw_dev->dev, "check sysst fail, reg_val=0x%04x, check:0x%x",
 				reg_val, AW88261_BIT_SYSST_CHECK);
 			usleep_range(AW88261_2000_US, AW88261_2000_US + 10);
 		} else {
@@ -549,7 +549,7 @@ static int aw88261_dev_start(struct aw88
 	int ret;
 
 	if (aw_dev->status == AW88261_DEV_PW_ON) {
-		dev_info(aw_dev->dev, "already power on");
+		dev_dbg(aw_dev->dev, "already power on");
 		return 0;
 	}
 
@@ -559,7 +559,7 @@ static int aw88261_dev_start(struct aw88
 
 	ret = aw88261_dev_check_syspll(aw_dev);
 	if (ret) {
-		dev_err(aw_dev->dev, "pll check failed cannot start");
+		dev_dbg(aw_dev->dev, "pll check failed");
 		goto pll_check_fail;
 	}
 
@@ -570,7 +570,7 @@ static int aw88261_dev_start(struct aw88
 	/* check i2s status */
 	ret = aw88261_dev_check_sysst(aw_dev);
 	if (ret) {
-		dev_err(aw_dev->dev, "sysst check failed");
+		dev_dbg(aw_dev->dev, "sysst check failed");
 		goto sysst_check_fail;
 	}
 
@@ -671,18 +671,22 @@ static void aw88261_start_pa(struct aw88
 	for (i = 0; i < AW88261_START_RETRIES; i++) {
 		ret = aw88261_reg_update(aw88261, aw88261->phase_sync);
 		if (ret) {
-			dev_err(aw88261->aw_pa->dev, "fw update failed, cnt:%d\n", i);
+			dev_dbg(aw88261->aw_pa->dev,
+				"aw88261_reg_update failed, cnt:%d, ret:%d\n", i, ret);
 			continue;
 		}
 		ret = aw88261_dev_start(aw88261);
 		if (ret) {
-			dev_err(aw88261->aw_pa->dev, "aw88261 device start failed. retry = %d", i);
+			dev_dbg(aw88261->aw_pa->dev,
+				"aw88261_dev_start failed, cnt:%d, ret:%d\n", i, ret);
 			continue;
 		} else {
-			dev_info(aw88261->aw_pa->dev, "start success\n");
+			dev_dbg(aw88261->aw_pa->dev, "start success\n");
 			break;
 		}
 	}
+	if (ret != 0)
+		dev_err(aw88261->aw_pa->dev, "start failure (%d)\n", ret);
 }
 
 static void aw88261_startup_work(struct work_struct *work)
@@ -1198,7 +1202,7 @@ static int aw88261_init(struct aw88261 *
 		return ret;
 	}
 	if (chip_id != AW88261_CHIP_ID) {
-		dev_err(&i2c->dev, "unsupported device");
+		dev_err(&i2c->dev, "unsupported device id = %x", chip_id);
 		return -ENXIO;
 	}
 


