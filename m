Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B58ED47127B;
	Tue, 21 Jul 2026 18:14:59 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784657701; cv=none; b=r267KYJ8Go0SqvQS7jKgzB+mCNm9rXBsRTgdpQ06NDCdNh8oMtlESKom3GsxgGDU01/4dozPiXZmeyV1B7sVg3kwM1Ogva/GYWBwdnC+syTMG2PiWXksgouyRZVwWTqo7hHI+IZ+s/JhC5oa15T8Iv9ZKhEkJvt0J84ATahKdpg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784657701; c=relaxed/simple;
	bh=LRzLankbMMTfUUVDmGAproIj8a7L982lFUIS+DWcrCc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=brZYeatRMT9yDPkXGBRJZWgq3q2PwUPuVKKw+Q4b4/D0ZkHYizq/mhq4+4SCsyEahaPvDEuSR2BG9h7EsiKeAOpfBGyC1NUedfNtpCAUBLCr+wVhdd3DYjgF86okBqV7IFlFRk8WAgDqo8wUqOut7R+MnONshi+jT4T2DPEpSjs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FrDcwXHo; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FrDcwXHo"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D82AD1F000E9;
	Tue, 21 Jul 2026 18:14:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784657699;
	bh=tm6pC9uYfYGcPYI7mqXnsnwODe4PMeC8j2rt/SDoKFg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=FrDcwXHo3czVYrqAkb1Gk8WpNvUMy50GckAOsDlbFQbgUCZ+FEmNxq9XcjxczL5r4
	 dXWxB6+vQnSCPwG3BV24r4WpmMplTtW3WWOr+p2VrJ+oWYDbAG1LBGaOzfXgE94p0u
	 lcwFC9BI79huiPEUlvkTkOFH7mP7LcwTlIlOUzsQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0864/1611] net: ethernet: mtk_ppe: Fix rhashtable leak in mtk_ppe_init error paths
Date: Tue, 21 Jul 2026 17:16:20 +0200
Message-ID: <20260721152534.824069775@linuxfoundation.org>
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

From: Wayen Yan <win847@gmail.com>

[ Upstream commit 41782770be567abc6509169d0ffdada31c783a66 ]

In mtk_ppe_init(), when accounting is enabled, the error paths for
dmam_alloc_coherent(mib) and devm_kzalloc(acct) failures return NULL
directly, bypassing the err_free_l2_flows label that destroys the
rhashtable initialized earlier.

While this leak only occurs during probe (not runtime) and the leaked
memory is minimal (an empty rhash table), fixing it ensures proper
error path cleanup consistency.

Fix by changing the two return NULL statements to goto err_free_l2_flows.

Fixes: 603ea5e7ffa7 ("net: ethernet: mtk_eth_soc: fix memory leak in error path")
Signed-off-by: Wayen Yan <win847@gmail.com>
Acked-by: Lorenzo Bianconi <lorenzo@kernel.org>
Link: https://patch.msgid.link/178167550101.2217645.14579307712717502425@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/mediatek/mtk_ppe.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/mediatek/mtk_ppe.c b/drivers/net/ethernet/mediatek/mtk_ppe.c
index fa688a42a22f5c..bb01a7355932aa 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -918,7 +918,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 		mib = dmam_alloc_coherent(ppe->dev, MTK_PPE_ENTRIES * sizeof(*mib),
 					  &ppe->mib_phys, GFP_KERNEL);
 		if (!mib)
-			return NULL;
+			goto err_free_l2_flows;
 
 		ppe->mib_table = mib;
 
@@ -926,7 +926,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 				    GFP_KERNEL);
 
 		if (!acct)
-			return NULL;
+			goto err_free_l2_flows;
 
 		ppe->acct_table = acct;
 	}
-- 
2.53.0



