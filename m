Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 27F0347124F;
	Tue, 21 Jul 2026 18:18:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657914; cv=none; b=dUD54TD1Qvj7+vcnlnQTp9Y/P0ZbhqkbI7R0HM5m5FRjz9n0LXQA9rDfaaRvgzkdo/4lROkOzNvXTT62M8KUWQ6hl08WPFHare590lDyvE7QxAIDKB9WuU0rDwqsb9IGtU96ACC0ykUafhrlX69IDeHK55gHFgM5AqswK5Qi/EM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657914; c=relaxed/simple;
	bh=Y2o9olVoj5nZuW8kei4158Nk5RWNTbilNIQfpNGt2CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=aEQZ282Kuq+pnEc9ezl8qvtSorCDJatKLWx7BSqQ6AUxjzGXPLpY/MWvft0oLiJP9zqzxVpBtBTdH3vEjfqGO4QWYAUi03YhTMpuSlSF9/UQqN7/FjqT5Mr9wk+0ilFYW9ZxT/UHTRhYSgfQCBFbeybSPSzztp5ItVEJA3Gx7oY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=tr/4RWDD; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="tr/4RWDD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 488EC1F000E9;
	Tue, 21 Jul 2026 18:18:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657912;
	bh=/RKkNCl/roA4tEHdti2xMLVjoHGtylx8LyBK1SOA21w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tr/4RWDD6OK0/9/QnJhZwyxz4WMlL0sMPRKEyCs4iW8t6tyPPYyNvO8UOnBH7kd0G
	 ul9/nmsvBi5j9qlrd7vePBn/PBxTKGrCpMeWg410w2PPUBJ2MNahFDW9H4ARPJ1/3F
	 lgB4QA4EYSKlzWsgbsR/chSaqYyHH6hdAY+1wVyk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0946/1611] net: hns3: differentiate autoneg default values between copper and fiber
Date: Tue, 21 Jul 2026 17:17:42 +0200
Message-ID: <20260721152536.666743810@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

From: Shuaisong Yang <yangshuaisong@h-partners.com>

[ Upstream commit d9d349c4e8a0acd73bac8baa3605443c0df5eb26 ]

Fix a link loss issue during driver initialization on optical ports
connected to forced-mode (non-autoneg) remote switches.

Previously, during driver probe or initialization, hclge_configure()
blindly hardcoded hdev->hw.mac.req_autoneg to AUTONEG_ENABLE for all
media types. While this is necessary for copper (BASE-T) ports to
establish a link, many high-speed optical (fiber) ports in data
centers are connected to switches running in forced mode (fixed speed,
autoneg disabled). Forcing autoneg on these optical ports during
initialization causes a permanent link failure since the remote end
refuses to respond to autoneg pulses.

Fix this by implementing media-type differentiated initialization in
hclge_init_ae_dev(). Copper ports continue to default to
AUTONEG_ENABLE, while optical ports strictly inherit the preset
autoneg status pre-configured by the firmware (hdev->hw.mac.autoneg),
preserving native compatibility with forced-mode network environments.

Fixes: 05eb60e9648c ("net: hns3: using user configure after hardware reset")
Signed-off-by: Shuaisong Yang <yangshuaisong@h-partners.com>
Signed-off-by: Jijie Shao <shaojijie@huawei.com>
Link: https://patch.msgid.link/20260624141319.271439-5-shaojijie@huawei.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
index 87322af852cdbc..7f174453928c1d 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11930,6 +11930,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
 	if (ret)
 		goto err_ptp_uninit;
 
+	if (hdev->hw.mac.media_type != HNAE3_MEDIA_TYPE_COPPER) {
+		hdev->hw.mac.req_autoneg = hdev->hw.mac.autoneg;
+		if (hdev->hw.mac.autoneg == AUTONEG_DISABLE &&
+		    hdev->hw.mac.speed != SPEED_UNKNOWN)
+			hdev->hw.mac.req_speed = hdev->hw.mac.speed;
+	}
+
 	ret = hclge_set_autoneg_speed_dup(hdev);
 	if (ret) {
 		dev_err(&pdev->dev,
-- 
2.53.0



