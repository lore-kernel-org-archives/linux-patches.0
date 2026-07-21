Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 942633EEAC7;
	Tue, 21 Jul 2026 19:09:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660961; cv=none; b=DNZ08ABsnJ6RrD7OxPhXWb56a58XRnnpvWOwXPcYJXF9DgSQfpximuNtg8Ed+qKZsEDhOo+3U8j8Mbaeiud4/6zSw1iOiH+ID99SuWoK7bEq63pLOjT+xW4cMAks+s7nlORoJmMCJj2+4p6ql88+iaS5PmtBwpKatvx6hSb8cyo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660961; c=relaxed/simple;
	bh=pPvQ2xAlHLb5xj2in2aAuaiddf2S9bQWshbXBndp1Kw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=peoklZKnKmxUApZMVRknar2QFC9+RobrQXoaozypgGXvMlDU/tGvEBWWggtPu3SqX5kg7YJtUmISpF+A2BCkDJDcuPI/SnofojM7sRSJZkk4SurI+t4OBXtPwrGR/R5mR7dMQlQgUEfZfWQlXHxbv3hjx4U0XMtfdZrSe6ha5LM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uegADGUs; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uegADGUs"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED5831F000E9;
	Tue, 21 Jul 2026 19:09:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660960;
	bh=m+QPwAWUni6IFWu4DoUE+MZ5JBNPv7ECUy/aMeX43S4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=uegADGUsbdErJ6yLghz1y+q8X2gy3Jq4tHqQq9pEZA/Ktht6TTk9RIO7UvQj3RniH
	 HQ+PthHcJETvWF33N+MyGUm0daW53vePc/NTVeVKvM75s2jeBO1plGf95ypk063CxV
	 ivocodnAW7QapddHJFMYtf3/o1BJN7JzX3U3zAIk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 1178/2077] net: ethernet: mtk_ppe: Fix rhashtable leak in mtk_ppe_init error paths
Date: Tue, 21 Jul 2026 17:14:11 +0200
Message-ID: <20260721152620.605352431@linuxfoundation.org>
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
index 18279e2a7022ef..8451dc3fd00aa2 100644
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



