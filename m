Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 244A63A8F4
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CTNFIMTk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AD655C433C8;
	Wed, 15 Nov 2023 19:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700078078;
	bh=Ml+Q/HRQiNfhScOvWddQuJiVsgRDDqhtK+MtO9eQrow=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CTNFIMTk7KnYaz1iHh5rG+t3R2kwf2Rrm2Hx2bRI5wjItH0EbFBjlat+46ePI1gtF
	 GYBlDF07yHv2dtWhjdadx1lsjDgJRd12PYGBW76wqB3GKKZeAWdhT3OoU8J9HpMT+p
	 6yoPhUzxnJOVr1Oy+2WjxmENb/wHU7OgQNm11mv4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Tony Lindgren <tony@atomide.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 097/379] clk: ti: fix double free in of_ti_divider_clk_setup()
Date: Wed, 15 Nov 2023 14:22:52 -0500
Message-ID: <20231115192650.876780052@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115192645.143643130@linuxfoundation.org>
References: <20231115192645.143643130@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 7af5b9eadd64c9e02a71f97c45bcdf3b64841f6b ]

The "div" pointer is freed in _register_divider() and again in
of_ti_divider_clk_setup().  Delete the free in _register_divider()

Fixes: fbbc18591585 ("clk: ti: divider: cleanup _register_divider and ti_clk_get_div_table")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/6d36eeec-6c8a-4f11-a579-aa3cd7c38749@moroto.mountain
Reviewed-by: Tony Lindgren <tony@atomide.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/ti/divider.c | 8 +-------
 1 file changed, 1 insertion(+), 7 deletions(-)

diff --git a/drivers/clk/ti/divider.c b/drivers/clk/ti/divider.c
index 768a1f3398b47..5d5bb123ba949 100644
--- a/drivers/clk/ti/divider.c
+++ b/drivers/clk/ti/divider.c
@@ -309,7 +309,6 @@ static struct clk *_register_divider(struct device_node *node,
 				     u32 flags,
 				     struct clk_omap_divider *div)
 {
-	struct clk *clk;
 	struct clk_init_data init;
 	const char *parent_name;
 	const char *name;
@@ -326,12 +325,7 @@ static struct clk *_register_divider(struct device_node *node,
 	div->hw.init = &init;
 
 	/* register the clock */
-	clk = of_ti_clk_register(node, &div->hw, name);
-
-	if (IS_ERR(clk))
-		kfree(div);
-
-	return clk;
+	return of_ti_clk_register(node, &div->hw, name);
 }
 
 int ti_clk_parse_divider_data(int *div_table, int num_dividers, int max_div,
-- 
2.42.0



