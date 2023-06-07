Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D29010FC
	for <patches@lists.linux.dev>; Wed,  7 Jun 2023 20:26:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1CE7C433D2;
	Wed,  7 Jun 2023 20:26:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1686169619;
	bh=O8cnvZqXeb7+PKLlbY/ihbCV2pJTD8h7I/NU5/OvDoY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GFRpqn4OsbwyCzEVOqCysn8xTrBfzKDcJzU+2DTsj2OOHUJX4XDYScSSi+fwGPHNA
	 8sdvW0jusx6boc/jMU5YXnfuXiVlHy6qUV+AxuIft2D1kBCDyAzBAWabyRSYv3w1sO
	 wuH8z7lsKJrIREFME0RmWhKGL98tSRh4nRJn3TWo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yun Lu <luyun@kylinos.cn>,
	Kalle Valo <kvalo@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 149/286] wifi: rtl8xxxu: fix authentication timeout due to incorrect RCR value
Date: Wed,  7 Jun 2023 22:14:08 +0200
Message-ID: <20230607200927.967415303@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230607200922.978677727@linuxfoundation.org>
References: <20230607200922.978677727@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Yun Lu <luyun@kylinos.cn>

[ Upstream commit 20429444e653ee8242dfbf815c0c37866beb371b ]

When using rtl8192cu with rtl8xxxu driver to connect wifi, there is a
probability of failure, which shows "authentication with ... timed out".
Through debugging, it was found that the RCR register has been inexplicably
modified to an incorrect value, resulting in the nic not being able to
receive authenticated frames.

To fix this problem, add regrcr in rtl8xxxu_priv struct, and store
the RCR value every time the register is written, and use it the next
time the register need to be modified.

Signed-off-by: Yun Lu <luyun@kylinos.cn>
Link: https://lore.kernel.org/all/20230427020512.1221062-1-luyun_611@163.com
Signed-off-by: Kalle Valo <kvalo@kernel.org>
Link: https://lore.kernel.org/r/20230512012055.2990472-1-luyun_611@163.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h      | 1 +
 drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c | 4 +++-
 2 files changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
index c8cee4a247551..4088aaa1c618d 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu.h
@@ -1518,6 +1518,7 @@ struct rtl8xxxu_priv {
 	u32 rege9c;
 	u32 regeb4;
 	u32 regebc;
+	u32 regrcr;
 	int next_mbox;
 	int nr_out_eps;
 
diff --git a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
index 54ca6f2ced3f3..74ff5130971e2 100644
--- a/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
+++ b/drivers/net/wireless/realtek/rtl8xxxu/rtl8xxxu_core.c
@@ -4049,6 +4049,7 @@ static int rtl8xxxu_init_device(struct ieee80211_hw *hw)
 		RCR_ACCEPT_MGMT_FRAME | RCR_HTC_LOC_CTRL |
 		RCR_APPEND_PHYSTAT | RCR_APPEND_ICV | RCR_APPEND_MIC;
 	rtl8xxxu_write32(priv, REG_RCR, val32);
+	priv->regrcr = val32;
 
 	if (priv->rtl_chip == RTL8188F) {
 		/* Accept all data frames */
@@ -6269,7 +6270,7 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
 				      unsigned int *total_flags, u64 multicast)
 {
 	struct rtl8xxxu_priv *priv = hw->priv;
-	u32 rcr = rtl8xxxu_read32(priv, REG_RCR);
+	u32 rcr = priv->regrcr;
 
 	dev_dbg(&priv->udev->dev, "%s: changed_flags %08x, total_flags %08x\n",
 		__func__, changed_flags, *total_flags);
@@ -6315,6 +6316,7 @@ static void rtl8xxxu_configure_filter(struct ieee80211_hw *hw,
 	 */
 
 	rtl8xxxu_write32(priv, REG_RCR, rcr);
+	priv->regrcr = rcr;
 
 	*total_flags &= (FIF_ALLMULTI | FIF_FCSFAIL | FIF_BCN_PRBRESP_PROMISC |
 			 FIF_CONTROL | FIF_OTHER_BSS | FIF_PSPOLL |
-- 
2.39.2



