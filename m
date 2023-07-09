Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86524522E
	for <patches@lists.linux.dev>; Sun,  9 Jul 2023 11:31:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F3A42C433C7;
	Sun,  9 Jul 2023 11:31:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1688902280;
	bh=pT9oQ4BzMcVwhGlxL2/bGZ7IEIkYg1PgfMYNj8/7h6A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=e+L7R0Rvj3Ifg22X8mCodGAejFSKyfGM4P7SKL6D5zmiCYmLamJ5LEmjnWcjS40Bt
	 IFtOz+KGFYJvmsSb+ppeI3KuacZup8lhJ8y53L9ewJCQhvRPnmBZCNq1x4a0TFHVaf
	 nreu/8nr9Pp7Vdh96sQsR7rg64PICZoMdSxhSx5Q=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>,
	Chen-Yu Tsai <wenst@chromium.org>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.3 320/431] clk: mediatek: clk-mt8173-apmixedsys: Fix iomap not released issue
Date: Sun,  9 Jul 2023 13:14:28 +0200
Message-ID: <20230709111458.680659612@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230709111451.101012554@linuxfoundation.org>
References: <20230709111451.101012554@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>

[ Upstream commit b270ae61730e0ebccee39a21dd3311d6896a38ae ]

In case of error after of_ioremap() the resource must be released:
call iounmap() where appropriate to fix that.

Fixes: 41138fbf876c ("clk: mediatek: mt8173: Migrate to platform driver and common probe")
Signed-off-by: AngeloGioacchino Del Regno <angelogioacchino.delregno@collabora.com>
Link: https://lore.kernel.org/r/20230615122051.546985-4-angelogioacchino.delregno@collabora.com
Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/mediatek/clk-mt8173-apmixedsys.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/drivers/clk/mediatek/clk-mt8173-apmixedsys.c b/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
index a335d076d3f28..0b95d14c18042 100644
--- a/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
+++ b/drivers/clk/mediatek/clk-mt8173-apmixedsys.c
@@ -95,8 +95,10 @@ static int clk_mt8173_apmixed_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	clk_data = mtk_alloc_clk_data(CLK_APMIXED_NR_CLK);
-	if (IS_ERR_OR_NULL(clk_data))
+	if (IS_ERR_OR_NULL(clk_data)) {
+		iounmap(base);
 		return -ENOMEM;
+	}
 
 	r = mtk_clk_register_plls(node, plls, ARRAY_SIZE(plls), clk_data);
 	if (r)
@@ -127,6 +129,7 @@ static int clk_mt8173_apmixed_probe(struct platform_device *pdev)
 	mtk_clk_unregister_plls(plls, ARRAY_SIZE(plls), clk_data);
 free_clk_data:
 	mtk_free_clk_data(clk_data);
+	iounmap(base);
 	return r;
 }
 
-- 
2.39.2



