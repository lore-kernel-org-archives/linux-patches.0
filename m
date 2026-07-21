Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8D0C93B1ECC;
	Tue, 21 Jul 2026 20:43:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784666621; cv=none; b=FXfyrB6PEgnmMCWclJ5jL3ZD4s30CRRyQnVa07Eb7ZNd1UwMH3adF0q1bS5MQ9HKgHHSop9l55rMBdLAiSm3SvtX6UyPcie80WDNvFGzNAi/TEVK92EViaSfV475AP86IXXrUS3ovgxrtTc0ApW8yXRnc3Pt8CB4dxFhAX9ybIA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784666621; c=relaxed/simple;
	bh=dbrKrBTcrVf1tjQ8OeixJtaWRFnXMtzSdIoEoNYtU0Q=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=scU/CMtp56ocAP/4JOdITx7vPK2ANH6R/dFJ7wWSeidn9DX2Yzjss/b7ck1hatcsifA1wSo3y/LA2a+ZBL6i3oknMVnO1k3O/vM/FSNiepue/m/pC3XR92S9tOh0n4JmZeRWyZntKfkSFc8l2uc/UM7WNsP51wRIOvDqxN2Cne8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=IAgEgRag; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="IAgEgRag"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F30841F000E9;
	Tue, 21 Jul 2026 20:43:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784666620;
	bh=aEIRUJLRXR2T7Epfwk7oE3T2uAnIfO3hW2Zeg5BfHYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=IAgEgRagE0wnjtsOqoOMAxwhYCAFm7zDKAxxRQWR92PuoiEeDNtvnImpdpvAK8U4x
	 QVKHJQa2AZDDp/+Zmwf01qYGZaCvrJuzLQt/a5gek+1aysZMbwJO721xHVJVGcWU2M
	 3o4R2osS4e9+Xau4+IBRw/7JsThm96ZKhuo7Zlvs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Wayen Yan <win847@gmail.com>,
	Lorenzo Bianconi <lorenzo@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0753/1266] net: ethernet: mtk_ppe: Fix rhashtable leak in mtk_ppe_init error paths
Date: Tue, 21 Jul 2026 17:19:50 +0200
Message-ID: <20260721152458.720584759@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152441.786066624@linuxfoundation.org>
References: <20260721152441.786066624@linuxfoundation.org>
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
index 1e033d63b45100..eb4df95fe9d0f4 100644
--- a/drivers/net/ethernet/mediatek/mtk_ppe.c
+++ b/drivers/net/ethernet/mediatek/mtk_ppe.c
@@ -916,7 +916,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 		mib = dmam_alloc_coherent(ppe->dev, MTK_PPE_ENTRIES * sizeof(*mib),
 					  &ppe->mib_phys, GFP_KERNEL);
 		if (!mib)
-			return NULL;
+			goto err_free_l2_flows;
 
 		ppe->mib_table = mib;
 
@@ -924,7 +924,7 @@ struct mtk_ppe *mtk_ppe_init(struct mtk_eth *eth, void __iomem *base, int index)
 				    GFP_KERNEL);
 
 		if (!acct)
-			return NULL;
+			goto err_free_l2_flows;
 
 		ppe->acct_table = acct;
 	}
-- 
2.53.0



