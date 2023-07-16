Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60F528F5D
	for <patches@lists.linux.dev>; Sun, 16 Jul 2023 20:38:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 88082C433C7;
	Sun, 16 Jul 2023 20:38:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1689539913;
	bh=mCzF67IMLzGbRzEoXNmbp5j4Wa06crgi6TgOYVWOW68=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0Vm5M8pP8y79LLCI+C1LUM0GTPfFlKW1i+h9v+BKCCxhj3g0NM434eEyqpsWUUj7O
	 nKCOO36BVGHUf9bm9gKlyproxp7XSLWBfHDIvLqTWmJfXNAy34ZM/3jE3S39hN0+WA
	 VJg/eKsjwJXkmvugGViZ3Wt4vGLiK/5j1NBnYd68=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	Abel Vesa <abel.vesa@linaro.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 177/591] clk: imx: scu: use _safe list iterator to avoid a use after free
Date: Sun, 16 Jul 2023 21:45:16 +0200
Message-ID: <20230716194928.444567882@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230716194923.861634455@linuxfoundation.org>
References: <20230716194923.861634455@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit 632c60ecd25dbacee54d5581fe3aeb834b57010a ]

This loop is freeing "clk" so it needs to use list_for_each_entry_safe().
Otherwise it dereferences a freed variable to get the next item on the
loop.

Fixes: 77d8f3068c63 ("clk: imx: scu: add two cells binding support")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Reviewed-by: Abel Vesa <abel.vesa@linaro.org>
Link: https://lore.kernel.org/r/0793fbd1-d2b5-4ec2-9403-3c39343a3e2d@kili.mountain
Signed-off-by: Abel Vesa <abel.vesa@linaro.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/imx/clk-scu.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/imx/clk-scu.c b/drivers/clk/imx/clk-scu.c
index 1e6870f3671f6..db307890e4c16 100644
--- a/drivers/clk/imx/clk-scu.c
+++ b/drivers/clk/imx/clk-scu.c
@@ -707,11 +707,11 @@ struct clk_hw *imx_clk_scu_alloc_dev(const char *name,
 
 void imx_clk_scu_unregister(void)
 {
-	struct imx_scu_clk_node *clk;
+	struct imx_scu_clk_node *clk, *n;
 	int i;
 
 	for (i = 0; i < IMX_SC_R_LAST; i++) {
-		list_for_each_entry(clk, &imx_scu_clks[i], node) {
+		list_for_each_entry_safe(clk, n, &imx_scu_clks[i], node) {
 			clk_hw_unregister(clk->hw);
 			kfree(clk);
 		}
-- 
2.39.2



