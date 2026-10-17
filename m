Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EBFF33B71A7;
	Sat, 17 Oct 2026 16:52:33 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255955; cv=none; b=B9xTrNlYLEDytLXZegY8F4tc6pS6Xf5QOTHLNPEQ+0/1+sxG0IQet8GsmFh7YaiDquRRpCktgAL9DNOFDdkY5s302c1TagLf5hSvxiYNDnqqYbzqpPZeDcu0quQn8LfRGg1WCGRnf+PdMS4j2Gu+v39d4kvkXnnCZXHv8AdPhjY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255955; c=relaxed/simple;
	bh=tzHL8kbwh+G2I9q2fzA8D6grdtgwRUSJL6BdPorXc1k=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=U7tMUwIaYOnGgS4Q6IQL8o4HnnA409z/Q97VYoxfjUE59d7YGR/GfcM3J/BfAaHd+uIkILyetwZtdggUPmDNchMcT+s7qYbC/90vRcoI2+IwwSjhbbOK9eO6AqeS0mtWC6DQtTu2EEdrubKw0wmqBtAdU9AuRykLHdpsihFzgag=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TI7kIiCG; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TI7kIiCG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42B221F000C4;
	Sat, 17 Oct 2026 16:52:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255953;
	bh=AUgpcx61nqJJTJSAFqbqdSyZ3/NQDBWu3XKgCXsgysk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TI7kIiCG8xQ//Obqonv4tyzDT2sOlDuqhTQf+KB9g6h7ifkOoAKQpV50hmDhnwhmb
	 lDB6xsD8Nh5arNix1ulCPc/auIKxYo8f38GKtIcZ1hfJle8S7WtyIfKyeA9ZCjfh+1
	 qzl1GB+apWh/8M9kjJOhPimfRgOgP9DnLrbu+EIs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Val Packett <val@packett.cool>,
	Luca Weiss <luca.weiss@fairphone.com>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0069/1674] ASoC: codecs: aw88261: reduce log spam
Date: Sat, 17 Oct 2026 17:39:01 +0200
Message-ID: <20261017160432.905797417@linuxfoundation.org>
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
---
 sound/soc/codecs/aw88261.c | 24 ++++++++++++++----------
 1 file changed, 14 insertions(+), 10 deletions(-)

diff --git a/sound/soc/codecs/aw88261.c b/sound/soc/codecs/aw88261.c
index eed05b2508dd7..9019a12cd0f03 100644
--- a/sound/soc/codecs/aw88261.c
+++ b/sound/soc/codecs/aw88261.c
@@ -151,7 +151,7 @@ static int aw88261_dev_get_iis_status(struct aw_device *aw_dev)
 	if (ret)
 		return ret;
 	if ((reg_val & AW88261_BIT_PLL_CHECK) != AW88261_BIT_PLL_CHECK) {
-		dev_err(aw_dev->dev, "check pll lock fail,reg_val:0x%04x", reg_val);
+		dev_dbg(aw_dev->dev, "check pll lock fail,reg_val:0x%04x", reg_val);
 		return -EINVAL;
 	}
 
@@ -165,7 +165,7 @@ static int aw88261_dev_check_mode1_pll(struct aw_device *aw_dev)
 	for (i = 0; i < AW88261_DEV_SYSST_CHECK_MAX; i++) {
 		ret = aw88261_dev_get_iis_status(aw_dev);
 		if (ret) {
-			dev_err(aw_dev->dev, "mode1 iis signal check error");
+			dev_dbg(aw_dev->dev, "mode1 iis signal check error");
 			usleep_range(AW88261_2000_US, AW88261_2000_US + 10);
 		} else {
 			return ret;
@@ -256,7 +256,7 @@ static int aw88261_dev_check_sysst(struct aw_device *aw_dev)
 		check_val = reg_val & (~AW88261_BIT_SYSST_CHECK_MASK)
 							& AW88261_BIT_SYSST_CHECK;
 		if (check_val != AW88261_BIT_SYSST_CHECK) {
-			dev_err(aw_dev->dev, "check sysst fail, reg_val=0x%04x, check:0x%x",
+			dev_dbg(aw_dev->dev, "check sysst fail, reg_val=0x%04x, check:0x%x",
 				reg_val, AW88261_BIT_SYSST_CHECK);
 			usleep_range(AW88261_2000_US, AW88261_2000_US + 10);
 		} else {
@@ -548,7 +548,7 @@ static int aw88261_dev_start(struct aw88261 *aw88261)
 	int ret;
 
 	if (aw_dev->status == AW88261_DEV_PW_ON) {
-		dev_info(aw_dev->dev, "already power on");
+		dev_dbg(aw_dev->dev, "already power on");
 		return 0;
 	}
 
@@ -558,7 +558,7 @@ static int aw88261_dev_start(struct aw88261 *aw88261)
 
 	ret = aw88261_dev_check_syspll(aw_dev);
 	if (ret) {
-		dev_err(aw_dev->dev, "pll check failed cannot start");
+		dev_dbg(aw_dev->dev, "pll check failed");
 		goto pll_check_fail;
 	}
 
@@ -569,7 +569,7 @@ static int aw88261_dev_start(struct aw88261 *aw88261)
 	/* check i2s status */
 	ret = aw88261_dev_check_sysst(aw_dev);
 	if (ret) {
-		dev_err(aw_dev->dev, "sysst check failed");
+		dev_dbg(aw_dev->dev, "sysst check failed");
 		goto sysst_check_fail;
 	}
 
@@ -670,18 +670,22 @@ static void aw88261_start_pa(struct aw88261 *aw88261)
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
@@ -1210,7 +1214,7 @@ static int aw88261_init(struct aw88261 **aw88261, struct i2c_client *i2c, struct
 		return ret;
 	}
 	if (chip_id != AW88261_CHIP_ID) {
-		dev_err(&i2c->dev, "unsupported device");
+		dev_err(&i2c->dev, "unsupported device id = %x", chip_id);
 		return -ENXIO;
 	}
 
-- 
2.53.0



