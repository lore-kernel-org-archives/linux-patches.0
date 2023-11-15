Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0207E3C46F
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:41:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XrgaZQ3g"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A0E0DC433C8;
	Wed, 15 Nov 2023 19:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077268;
	bh=sAxA/0xjBz/YmJLUCwyQHlX/UFuZgUPxia/cg0VsjrQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=XrgaZQ3gBpwLoucS2IneMBJD8YeVMUGGUnrcEKbGK4u5bndqhJhROIUiELump0rKH
	 CgughtnC6lEryfbcSI3/WMdf+pCsQubKonvoomqrOmehF4VD5m4iQOjGxmBe+so2DA
	 rqfmH4aOrlCWa4PuhPOgGe16Oxuc6T0CTEkNMP+k=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Dan Carpenter <dan.carpenter@linaro.org>,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 199/603] clk: mediatek: fix double free in mtk_clk_register_pllfh()
Date: Wed, 15 Nov 2023 14:12:24 -0500
Message-ID: <20231115191627.030467940@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dan Carpenter <dan.carpenter@linaro.org>

[ Upstream commit bd54ccc0f147019dac38e7841876a7415459b875 ]

The mtk_clk_register_pll_ops() currently frees the "pll" parameter.
The function has two callers, mtk_clk_register_pll() and
mtk_clk_register_pllfh().  The first one, the _pll() function relies on
the free, but for the second _pllfh() function it causes a double free
bug.

Really the frees should be done in the caller because that's where
the allocation is.

Fixes: d7964de8a8ea ("clk: mediatek: Add new clock driver to handle FHCTL hardware")
Signed-off-by: Dan Carpenter <dan.carpenter@linaro.org>
Link: https://lore.kernel.org/r/cd7fa365-28cc-4c34-ac64-6da57c98baa6@moroto.mountain
Reviewed-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-pll.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/mediatek/clk-pll.c b/drivers/clk/mediatek/clk-pll.c
index a4eca5fd539c8..513ab6b1b3229 100644
--- a/drivers/clk/mediatek/clk-pll.c
+++ b/drivers/clk/mediatek/clk-pll.c
@@ -321,10 +321,8 @@ struct clk_hw *mtk_clk_register_pll_ops(struct mtk_clk_pll *pll,
 
 	ret = clk_hw_register(NULL, &pll->hw);
 
-	if (ret) {
-		kfree(pll);
+	if (ret)
 		return ERR_PTR(ret);
-	}
 
 	return &pll->hw;
 }
@@ -340,6 +338,8 @@ struct clk_hw *mtk_clk_register_pll(const struct mtk_pll_data *data,
 		return ERR_PTR(-ENOMEM);
 
 	hw = mtk_clk_register_pll_ops(pll, data, base, &mtk_pll_ops);
+	if (IS_ERR(hw))
+		kfree(pll);
 
 	return hw;
 }
-- 
2.42.0



