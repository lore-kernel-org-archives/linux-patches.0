Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88AEF84D26;
	Tue, 14 May 2024 11:43:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1715687006; cv=none; b=ggp8pAF9VEWgys6Cfg2lHisulPfDx/c+MaOjuW4kPexubYgD6lKL3H50Tw8brCovWDUP8rG7X41jAydhIHzsM0GexKULkvwBoZNe8FOw7EpdaNPAPrujE68ivBHkRJ9vL6XUAgp8FI7BYMLjGrcFWPEZL1V5+sO78F/xfz/Yb6E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1715687006; c=relaxed/simple;
	bh=rZzfxhUfnHR1HBDA1Qrez1qXuqjF/XtVImZP21yhqng=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hXepQzX8F21ND1oEPhTBm1NL29X8ogy7NZDGP6/KoG5Lx3NbQ2WQR0eFwgPiBHCIVvdrvi1d3XCMOrYY0TW27VvAqOfZKF0LJYbckUftNWdfUM1hERtupST8HiD78nV2ZaWypjRs0v/CJLsToRBmsIxvDpKvh+m4lex4JOPtE9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lQbog4XI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lQbog4XI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0EC5FC2BD10;
	Tue, 14 May 2024 11:43:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1715687004;
	bh=rZzfxhUfnHR1HBDA1Qrez1qXuqjF/XtVImZP21yhqng=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lQbog4XISnKSdRzcGBgOF1Wgz96Xi+cnMHT4hgpeLLtqJuVXDUAng7IWGfA8s5Dx3
	 bdAcQelYq27tp709dH5NgaOrAx/s1L7MnF4xehh0/gIcHELcGlPxFRBbQ32ZAvtJsu
	 6PVQPvD4cMLY4UGvDsdhEi5kWj2qhqJflHZf2fZI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Light Hsieh <light.hsieh@mediatek.com>,
	Sean Wang <sean.wang@kernel.org>,
	Linus Walleij <linus.walleij@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 06/84] pinctrl: mediatek: Supporting driving setting without mapping current to register value
Date: Tue, 14 May 2024 12:19:17 +0200
Message-ID: <20240514100951.931230944@linuxfoundation.org>
X-Mailer: git-send-email 2.45.0
In-Reply-To: <20240514100951.686412426@linuxfoundation.org>
References: <20240514100951.686412426@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Light Hsieh <light.hsieh@mediatek.com>

[ Upstream commit 5f755e1f1efe5ca3b475b14169e6e85bf1411bb5 ]

MediaTek's smartphone project actual usage does need to know current value
(in mA) in procedure of finding the best driving setting.
The steps in the procedure is like as follow:

1. set driving setting field in setting register as 0, measure waveform,
   perform test, and etc.
2. set driving setting field in setting register as 1, measure waveform,
   perform test, and etc.
...
n. set driving setting field in setting register as n-1, measure
   waveform, perform test, and etc.
Check the results of steps 1~n and adopt the setting that get best result.

This procedure does need to know the mapping between current to register
value.
Therefore, setting driving without mapping current is more practical for
MediaTek's smartphone usage.

Signed-off-by: Light Hsieh <light.hsieh@mediatek.com>
Link: https://lore.kernel.org/r/1579675994-7001-2-git-send-email-light.hsieh@mediatek.com
Acked-by: Sean Wang <sean.wang@kernel.org>
Signed-off-by: Linus Walleij <linus.walleij@linaro.org>
Stable-dep-of: c5d3b64c568a ("pinctrl: mediatek: paris: Rework support for PIN_CONFIG_{INPUT,OUTPUT}_ENABLE")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/pinctrl/mediatek/pinctrl-mt6765.c        |  4 ++--
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c | 12 ++++++++++++
 drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h |  5 +++++
 3 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/drivers/pinctrl/mediatek/pinctrl-mt6765.c b/drivers/pinctrl/mediatek/pinctrl-mt6765.c
index 32451e8693be7..12122646bbc28 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mt6765.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mt6765.c
@@ -1077,8 +1077,8 @@ static const struct mtk_pin_soc mt6765_data = {
 	.bias_disable_get = mtk_pinconf_bias_disable_get,
 	.bias_set = mtk_pinconf_bias_set,
 	.bias_get = mtk_pinconf_bias_get,
-	.drive_set = mtk_pinconf_drive_set_rev1,
-	.drive_get = mtk_pinconf_drive_get_rev1,
+	.drive_set = mtk_pinconf_drive_set_raw,
+	.drive_get = mtk_pinconf_drive_get_raw,
 	.adv_pull_get = mtk_pinconf_adv_pull_get,
 	.adv_pull_set = mtk_pinconf_adv_pull_set,
 };
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
index 2795d0fd0f5bd..fb87feec7bd3f 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.c
@@ -612,6 +612,18 @@ int mtk_pinconf_drive_get_rev1(struct mtk_pinctrl *hw,
 	return 0;
 }
 
+int mtk_pinconf_drive_set_raw(struct mtk_pinctrl *hw,
+			       const struct mtk_pin_desc *desc, u32 arg)
+{
+	return mtk_hw_set_value(hw, desc, PINCTRL_PIN_REG_DRV, arg);
+}
+
+int mtk_pinconf_drive_get_raw(struct mtk_pinctrl *hw,
+			       const struct mtk_pin_desc *desc, int *val)
+{
+	return mtk_hw_get_value(hw, desc, PINCTRL_PIN_REG_DRV, val);
+}
+
 int mtk_pinconf_adv_pull_set(struct mtk_pinctrl *hw,
 			     const struct mtk_pin_desc *desc, bool pullup,
 			     u32 arg)
diff --git a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
index 1b7da42aa1d53..75d0e0712c03f 100644
--- a/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
+++ b/drivers/pinctrl/mediatek/pinctrl-mtk-common-v2.h
@@ -288,6 +288,11 @@ int mtk_pinconf_drive_set_rev1(struct mtk_pinctrl *hw,
 int mtk_pinconf_drive_get_rev1(struct mtk_pinctrl *hw,
 			       const struct mtk_pin_desc *desc, int *val);
 
+int mtk_pinconf_drive_set_raw(struct mtk_pinctrl *hw,
+			       const struct mtk_pin_desc *desc, u32 arg);
+int mtk_pinconf_drive_get_raw(struct mtk_pinctrl *hw,
+			       const struct mtk_pin_desc *desc, int *val);
+
 int mtk_pinconf_adv_pull_set(struct mtk_pinctrl *hw,
 			     const struct mtk_pin_desc *desc, bool pullup,
 			     u32 arg);
-- 
2.43.0



