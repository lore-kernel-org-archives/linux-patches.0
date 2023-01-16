Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1E05B6FA0
	for <patches@lists.linux.dev>; Mon, 16 Jan 2023 16:43:59 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 976B9C433D2;
	Mon, 16 Jan 2023 16:43:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1673887439;
	bh=XcKqXjicsE4RpB26nqk2BrcH1KF+POS3pWOXIxr5+Xw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G+eTQs91u4IUPKGG80SnvKCRpe5Fxtan59imyN4/wUQZ6UiKRRRtIbAIcBM+U+yIz
	 gcj8+zxnQLGJaRpkx4D3vvsK6yZoldYJRP0hgO8ccK3O9MsEkgAvVrQY+JyZmA4Duy
	 PmIYpvTL6davdqx+K8tZmYVtEmQ7ZbQXOXti30As=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 150/521] clk: samsung: Fix memory leak in _samsung_clk_register_pll()
Date: Mon, 16 Jan 2023 16:46:52 +0100
Message-Id: <20230116154853.972802570@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20230116154847.246743274@linuxfoundation.org>
References: <20230116154847.246743274@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Xiu Jianfeng <xiujianfeng@huawei.com>

[ Upstream commit 5174e5b0d1b669a489524192b6adcbb3c54ebc72 ]

If clk_register() fails, @pll->rate_table may have allocated memory by
kmemdup(), so it needs to be freed, otherwise will cause memory leak
issue, this patch fixes it.

Fixes: 3ff6e0d8d64d ("clk: samsung: Add support to register rate_table for samsung plls")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221123032015.63980-1-xiujianfeng@huawei.com
Reviewed-by: Alim Akhtar <alim.akhtar@samsung.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/samsung/clk-pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/samsung/clk-pll.c b/drivers/clk/samsung/clk-pll.c
index 1c4c7a3039f1..8cbf0f2cf196 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -1392,6 +1392,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	if (ret) {
 		pr_err("%s: failed to register pll clock %s : %d\n",
 			__func__, pll_clk->name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		return;
 	}
-- 
2.35.1



