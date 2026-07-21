Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C417F35DA40;
	Tue, 21 Jul 2026 19:30:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784662207; cv=none; b=DPPwJiiSt3HMla20X8w4ua3x0hYGDny2e8d6EZsvBYH5TlmhUS0pjYMwmAFu5mBfig/MmmAck8B37rb2tJTU3jEyQXa5k90QjTElQl+oPxYsjvmQsPVvnksFGbTMDMUn9sGft+a1GsOBe3O1OXh5Wi90MXeqCyXqydceqqvq4k4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784662207; c=relaxed/simple;
	bh=B6Y+wQpSk1Alt1cyd0+w16iAW0FmqjowRMdyDuFM7zM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=dfvJvqsx6TmElEYXBCUiiwQ4fb/7H1jZRQpCpgOlg/Dme5YOZHqFBIfTpGYFyDa+a28k1g4q589CUweS7iT6nI46ZdwPmCYLAZq5LktqS7gAtCfUX0hOq0uHEIiW/qhBvsRCdUx1B5EiOEmMSNcspVAxLoLYYDtTC+sdnC7oZ9c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hkmQFs9J; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hkmQFs9J"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 35E2E1F000E9;
	Tue, 21 Jul 2026 19:30:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784662206;
	bh=NH0KNv0gBAgexq/V35ypUdepjPLxxFRota/G/LhGZVI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hkmQFs9JukJLWmjafkngwHVMjMgPBF/emwTW391Ok02V3DdluVBmUg0+ykJxqR2HV
	 eZocTGpWk8tlhqyNHGX2BkpMnCZ2VIRsoNiqe4w1zaUfa7Qau7Ra/U/h8c6e78k9RY
	 CQNAHEzNfF7Tbs37p74qHIRm8VmLVAn5w5CB5T0Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhi-Jun You <hujy652@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 0356/1276] net: ethernet: mtk_wed: fix loading WO firmware for MT7986
Date: Tue, 21 Jul 2026 17:13:19 +0200
Message-ID: <20260721152454.079177397@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152446.065700225@linuxfoundation.org>
References: <20260721152446.065700225@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhi-Jun You <hujy652@gmail.com>

[ Upstream commit 9192a18f6de2f5e3eb3813ecd2895ac0f5c008a9 ]

MT7986 requires a different mask for second WO firmware.
Without this, WO would timeout after loading FW.

The correct mask was removed when adding WED for MT7988.
Add it back and add a WED version check to fix it.

This can be reproduced with a MT7986 + MT7916 board.

Fixes: e2f64db13aa1 ("net: ethernet: mtk_wed: introduce WED support for MT7988")
Signed-off-by: Zhi-Jun You <hujy652@gmail.com>
Link: https://patch.msgid.link/20260611150051.586-1-hujy652@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_wed_mcu.c | 8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
index c06e5ad18b0105..76eff9e3f47319 100644
--- a/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
+++ b/drivers/net/ethernet/mediatek/mtk_wed_mcu.c
@@ -377,8 +377,12 @@ mtk_wed_mcu_load_firmware(struct mtk_wed_wo *wo)
 	/* wo firmware reset */
 	wo_w32(MTK_WO_MCU_CFG_LS_WF_MCCR_CLR_ADDR, 0xc00);
 
-	val = wo_r32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR) |
-	      MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
+	val = wo_r32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR);
+
+	if (!mtk_wed_is_v3_or_greater(wo->hw) && wo->hw->index)
+		val |= MTK_WO_MCU_CFG_LS_WF_WM_WA_WA_CPU_RSTB_MASK;
+	else
+		val |= MTK_WO_MCU_CFG_LS_WF_WM_WA_WM_CPU_RSTB_MASK;
 	wo_w32(MTK_WO_MCU_CFG_LS_WF_MCU_CFG_WM_WA_ADDR, val);
 out:
 	release_firmware(fw);
-- 
2.53.0



