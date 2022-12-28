Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C7541875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 16:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0647DC433D2;
	Wed, 28 Dec 2022 16:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243215;
	bh=7TqnwCsT1oUHJkOJRgf2HlNmIL3Ngnf8RQmgOAXpsCY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xo67ZSNl8st9i2fwQaO5FqvP1ZNkMgpWKjd3Io1kEd9A6bnkW7VYHwLyQfmccdFZ7
	 F6zpgmWb3kj86p8Oa8zyY2dpAFmkqzOqgUFQ9cgMELXUt54smuk1hmVX033vR/PcGs
	 H+sQn/35eyzA6rbXDfX1lTEP0twEVPqOflvNmS0g=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Alim Akhtar <alim.akhtar@samsung.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.0 0502/1073] clk: samsung: Fix memory leak in _samsung_clk_register_pll()
Date: Wed, 28 Dec 2022 15:34:50 +0100
Message-Id: <20221228144341.671663165@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144328.162723588@linuxfoundation.org>
References: <20221228144328.162723588@linuxfoundation.org>
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
index fe383471c5f0..0ff28938943f 100644
--- a/drivers/clk/samsung/clk-pll.c
+++ b/drivers/clk/samsung/clk-pll.c
@@ -1583,6 +1583,7 @@ static void __init _samsung_clk_register_pll(struct samsung_clk_provider *ctx,
 	if (ret) {
 		pr_err("%s: failed to register pll clock %s : %d\n",
 			__func__, pll_clk->name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		return;
 	}
-- 
2.35.1



