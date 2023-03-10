Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id ADE768481
	for <patches@lists.linux.dev>; Fri, 10 Mar 2023 14:04:49 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 29C84C433EF;
	Fri, 10 Mar 2023 14:04:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1678457089;
	bh=6EYrF6M0qUJmbvXb+T/4fpb0RDE97dt16mHUJG9yEEk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=QjBZ5mF4LVbfxEyTFoFF/rfUP8L1VNXq9z0OkAdurPTyjqxXJZuRazo+BMHgcdSHn
	 iIoFUl9yEX9CTBBETbWYIAbbfq4uyFZzyfCONbU9hKzww7pCL1C+OEuF/dQKvzGcDE
	 l1Hw864RLZ74Nr0AdGKcCxmTJ56PS0rTQWmSDiQU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roger Lu <roger.lu@mediatek.com>,
	Matthias Brugger <matthias.bgg@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 017/200] soc: mediatek: mtk-svs: restore default voltages when svs_init02() fail
Date: Fri, 10 Mar 2023 14:37:04 +0100
Message-Id: <20230310133717.570324751@linuxfoundation.org>
X-Mailer: git-send-email 2.39.2
In-Reply-To: <20230310133717.050159289@linuxfoundation.org>
References: <20230310133717.050159289@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Roger Lu <roger.lu@mediatek.com>

[ Upstream commit a0674cd237fc24b08c7dcb4f8e48df3ee769293a ]

If svs init02 fail, it means we cannot rely on svs bank voltages anymore.
We need to disable svs function and restore DVFS opp voltages back to the
default voltages for making sure we have enough DVFS voltages.

Fixes: 681a02e95000 ("soc: mediatek: SVS: introduce MTK SVS engine")
Fixes: 0bbb09b2af9d ("soc: mediatek: SVS: add mt8192 SVS GPU driver")
Signed-off-by: Roger Lu <roger.lu@mediatek.com>
Link: https://lore.kernel.org/r/20230111074528.29354-2-roger.lu@mediatek.com
Signed-off-by: Matthias Brugger <matthias.bgg@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/soc/mediatek/mtk-svs.c | 24 ++++++++++++++++++++++--
 1 file changed, 22 insertions(+), 2 deletions(-)

diff --git a/drivers/soc/mediatek/mtk-svs.c b/drivers/soc/mediatek/mtk-svs.c
index 75b2f534aa9d0..9859e6cf6b8f9 100644
--- a/drivers/soc/mediatek/mtk-svs.c
+++ b/drivers/soc/mediatek/mtk-svs.c
@@ -1461,6 +1461,7 @@ static int svs_init02(struct svs_platform *svsp)
 {
 	struct svs_bank *svsb;
 	unsigned long flags, time_left;
+	int ret;
 	u32 idx;
 
 	for (idx = 0; idx < svsp->bank_max; idx++) {
@@ -1479,7 +1480,8 @@ static int svs_init02(struct svs_platform *svsp)
 							msecs_to_jiffies(5000));
 		if (!time_left) {
 			dev_err(svsb->dev, "init02 completion timeout\n");
-			return -EBUSY;
+			ret = -EBUSY;
+			goto out_of_init02;
 		}
 	}
 
@@ -1497,12 +1499,30 @@ static int svs_init02(struct svs_platform *svsp)
 		if (svsb->type == SVSB_HIGH || svsb->type == SVSB_LOW) {
 			if (svs_sync_bank_volts_from_opp(svsb)) {
 				dev_err(svsb->dev, "sync volt fail\n");
-				return -EPERM;
+				ret = -EPERM;
+				goto out_of_init02;
 			}
 		}
 	}
 
 	return 0;
+
+out_of_init02:
+	for (idx = 0; idx < svsp->bank_max; idx++) {
+		svsb = &svsp->banks[idx];
+
+		spin_lock_irqsave(&svs_lock, flags);
+		svsp->pbank = svsb;
+		svs_switch_bank(svsp);
+		svs_writel_relaxed(svsp, SVSB_PTPEN_OFF, SVSEN);
+		svs_writel_relaxed(svsp, SVSB_INTSTS_VAL_CLEAN, INTSTS);
+		spin_unlock_irqrestore(&svs_lock, flags);
+
+		svsb->phase = SVSB_PHASE_ERROR;
+		svs_adjust_pm_opp_volts(svsb);
+	}
+
+	return ret;
 }
 
 static void svs_mon_mode(struct svs_platform *svsp)
-- 
2.39.2



