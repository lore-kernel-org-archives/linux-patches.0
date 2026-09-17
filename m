Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A86C64DE720;
	Thu, 17 Sep 2026 17:17:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789665481; cv=none; b=AIueGLTfgiNDqFjcmS2aXY8qVfbuvVrTgNvyzPEl46wS+a1V48+SIdURAeJlY2e+OwbJt7mbh+SeZz6D559DXDi0KT+qtHPPB24c40/OQLfYaNcKbVkOZA1cJmYoc5xvF8nAhL9cuUSdhD5R+47rzonjZKj6k7W40w0TbsjbdYY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789665481; c=relaxed/simple;
	bh=hvTrQ8rCd5OBc9q4GcMPeMPF5WjWgJgRUjmqPUEZBkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=NZDJ9xmf9hvyBl4yVMeJV7+8C1SabHtfq/N0MsAXP7fu73b/xJGVET2+7isQG5vhyj/CNEOmhBmpw9VsPflmmeCvJfohteUlLmezd1nEsM65yyryasJA/FfB5AVe+H5tQHu0euv0a645SZKeNWINggsPX++zDm3qsEqyc9q0QaU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=WbJQdn4y; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="WbJQdn4y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C67F61F00893;
	Thu, 17 Sep 2026 17:17:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789665479;
	bh=hJx1ztDNizuamD8nYvjz1s1HQBma5XYfiGrq5zrkaEs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WbJQdn4ytl9FL29mj857DEzIbFbWp9VpngF0R+W+S3yrFvTFq9dedpuLISNwr/qFB
	 TM5+y2DCbWVfAwn8VMuX4WsBedniyDKPlXRLsCFv/3O8BP+wp9ji0vnejpu9dPlClH
	 mfrfTPPTK6uYBUhPiY8IctnqkNjLCZZXzWD+sSlM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Linus Walleij <linusw@kernel.org>,
	Mark Brown <broonie@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0718/1250] ASoC: ux500: Deassert the MSP reset during probe
Date: Thu, 17 Sep 2026 16:08:33 +0100
Message-ID: <20260917151611.355499030@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260917151551.901433442@linuxfoundation.org>
References: <20260917151551.901433442@linuxfoundation.org>
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

From: Linus Walleij <linusw@kernel.org>

[ Upstream commit 66ec63e7a90bedc56aa050fbe437964008c3d584 ]

The devicetree has described each MSP reset line since the PRCC reset
controller was added, but the driver never acquires or deasserts it. The
block can consequently remain inaccessible when firmware has left it in
reset.

Acquire the reset exclusively and keep it deasserted for the lifetime of
the bound device.

Fixes: 95f04048325c ("ARM: dts: ux500: Add reset lines to IP blocks")
Assisted-by: LLM
Signed-off-by: Linus Walleij <linusw@kernel.org>
Link: https://patch.msgid.link/20260902-ux500-msp-fixes-v2-5-4b60b002d55a@kernel.org
Signed-off-by: Mark Brown <broonie@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 sound/soc/ux500/ux500_msp_dai.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/sound/soc/ux500/ux500_msp_dai.c b/sound/soc/ux500/ux500_msp_dai.c
index 78278927cc53a..b3de115d829a7 100644
--- a/sound/soc/ux500/ux500_msp_dai.c
+++ b/sound/soc/ux500/ux500_msp_dai.c
@@ -14,6 +14,7 @@
 #include <linux/clk.h>
 #include <linux/of.h>
 #include <linux/regulator/consumer.h>
+#include <linux/reset.h>
 #include <linux/mfd/db8500-prcmu.h>
 
 #include <sound/soc.h>
@@ -686,6 +687,7 @@ static const struct snd_soc_component_driver ux500_msp_component = {
 static int ux500_msp_drv_probe(struct platform_device *pdev)
 {
 	struct ux500_msp_i2s_drvdata *drvdata;
+	struct reset_control *reset;
 	int ret = 0;
 
 	drvdata = devm_kzalloc(&pdev->dev,
@@ -733,6 +735,11 @@ static int ux500_msp_drv_probe(struct platform_device *pdev)
 		return -EINVAL;
 	}
 
+	reset = devm_reset_control_get_exclusive_deasserted(&pdev->dev, NULL);
+	if (IS_ERR(reset))
+		return dev_err_probe(&pdev->dev, PTR_ERR(reset),
+				     "Failed to deassert MSP reset\n");
+
 	ret = ux500_msp_i2s_init_msp(pdev, &drvdata->msp);
 	if (ret) {
 		dev_err(&pdev->dev,
-- 
2.53.0



