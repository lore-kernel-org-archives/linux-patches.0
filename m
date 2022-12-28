Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 83B6A1875
	for <patches@lists.linux.dev>; Wed, 28 Dec 2022 15:57:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 044FCC433F0;
	Wed, 28 Dec 2022 15:57:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1672243031;
	bh=8/sVOYx2bnqClV5wMIKys2+H3FCefamDGqS5rgWovWw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=tNv1CwrxJ/Xot+zmXczFA5STUyBo9wQxDsgDfrtRETZkjJPxnjy9NlL3G0OOF9Kl0
	 5ZPaEqcEWsyQZxDC3nbm11hKVh+Ef0pRQD/KMeNsl+V7jDcBkuX5ueV8n0CyxQoGTD
	 eNLgT6rTKVA0+Q44yLV5jnLHWTVkjNvqH71x3YVc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Xiu Jianfeng <xiujianfeng@huawei.com>,
	Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 0442/1146] clk: visconti: Fix memory leak in visconti_register_pll()
Date: Wed, 28 Dec 2022 15:33:01 +0100
Message-Id: <20221228144342.186273047@linuxfoundation.org>
X-Mailer: git-send-email 2.39.0
In-Reply-To: <20221228144330.180012208@linuxfoundation.org>
References: <20221228144330.180012208@linuxfoundation.org>
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

[ Upstream commit b55226f8553d255f5002c751c7c6ba9291f34bf2 ]

@pll->rate_table has allocated memory by kmemdup(), if clk_hw_register()
fails, it should be freed, otherwise it will cause memory leak issue,
this patch fixes it.

Fixes: b4cbe606dc36 ("clk: visconti: Add support common clock driver and reset driver")
Signed-off-by: Xiu Jianfeng <xiujianfeng@huawei.com>
Link: https://lore.kernel.org/r/20221122152353.204132-1-xiujianfeng@huawei.com
Acked-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/visconti/pll.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/clk/visconti/pll.c b/drivers/clk/visconti/pll.c
index a484cb945d67..1f3234f22667 100644
--- a/drivers/clk/visconti/pll.c
+++ b/drivers/clk/visconti/pll.c
@@ -277,6 +277,7 @@ static struct clk_hw *visconti_register_pll(struct visconti_pll_provider *ctx,
 	ret = clk_hw_register(NULL, &pll->hw);
 	if (ret) {
 		pr_err("failed to register pll clock %s : %d\n", name, ret);
+		kfree(pll->rate_table);
 		kfree(pll);
 		pll_hw_clk = ERR_PTR(ret);
 	}
-- 
2.35.1



