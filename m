Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6EDF33D3337;
	Tue, 21 Jul 2026 17:02:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784653376; cv=none; b=RSWTxYpdfu+1p3y85Vgm6T1AYVLmxWV5ZN0JidAx8TUyVi//cNaKr7zk8JZCFotmUZdj0Nts23NeA781UQZjh7A/pYryxRNo3UsJi53DL9tkdbinsv0djsJcTZsLoOdtIUnWJWfTcaSKPhdDupOUD89IFDZsNrcQ83CVB+6pI6c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784653376; c=relaxed/simple;
	bh=8Kk2U/o2MTRb+FSd0vbe/5SwLlJOEKDDWjYnSpS2ZVc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=V8ZyPcBqlE7XXh6X0Bt7mXIqfRZVKk7EN8gGCdhRcR7PEVJ/vEvjgW7cNUWR3dgal3+4bLwT8mzU260X5sCMxDYcfs3JgprEVtGQ0LE/EospHvv2NDwycO+g/2FWDzVsSG/dFpCSl/AK/BhyI7pqpMAWRzUCL16gsmfBRppoVsk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TL1TJCYS; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TL1TJCYS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7A5A71F000E9;
	Tue, 21 Jul 2026 17:02:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784653375;
	bh=EzKH4Yz6y+6n0Np6hXGrLGC+nt+sRUZ4OhYxufidovM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=TL1TJCYSwpUnXcXXRr+TrLN24H83nFeUk/QdVv6i1fleg2/oyAHxxbgovvLm9Qr1v
	 l0anDSH4voj2hTBvqxGq5ePqSi5W/pqcj+DD/b7XpdrBjz32y3IUcEZmpR0fuUeBDf
	 3/t9yeQnxk6ogG/5DCoDcXnP3om1Bv8nPdOWSfks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuaisong Yang <yangshuaisong@h-partners.com>,
	Jijie Shao <shaojijie@huawei.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1304/2077] net: hns3: differentiate autoneg default values between copper and fiber
Date: Tue, 21 Jul 2026 17:16:17 +0200
Message-ID: <20260721152623.575145565@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index b8563ac34ad198..2a6e4d17452c4f 100644
--- a/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
+++ b/drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c
@@ -11926,6 +11926,13 @@ static int hclge_init_ae_dev(struct hnae3_ae_dev *ae_dev)
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



