Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D898168C5
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:46:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2EE2C433EF;
	Mon,  8 May 2023 10:46:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683542769;
	bh=G0tGC8k0SBDCDGJ6Iv4A5FGuN2gQNmpMbtGLNVHDqD8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rjLE7DympG84lLa6Y27G8tOLD3URHhG3NBLDAWw9iCLiGcI3glJJOFP/pifxJL0KG
	 QU+uL/Cwjq28DSUU9+F9FctivE2w8N9HjWV2E428Gr/hlnvCnKz14oHATtPX+s26AN
	 GNaQwLsQdw+sIv+Sr7OktvfayWRvU2MaKnCdwbIA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Cl=C3=A9ment=20L=C3=A9ger?= <clement.leger@bootlin.com>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 542/663] clk: add missing of_node_put() in "assigned-clocks" property parsing
Date: Mon,  8 May 2023 11:46:08 +0200
Message-Id: <20230508094446.600105188@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Clément Léger <clement.leger@bootlin.com>

[ Upstream commit 27a6e1b09a782517fddac91259970ac466a3f7b6 ]

When returning from of_parse_phandle_with_args(), the np member of the
of_phandle_args structure should be put after usage. Add missing
of_node_put() calls in both __set_clk_parents() and __set_clk_rates().

Fixes: 86be408bfbd8 ("clk: Support for clock parents and rates assigned from device tree")
Signed-off-by: Clément Léger <clement.leger@bootlin.com>
Link: https://lore.kernel.org/r/20230131083227.10990-1-clement.leger@bootlin.com
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-conf.c | 12 ++++++++++--
 1 file changed, 10 insertions(+), 2 deletions(-)

diff --git a/drivers/clk/clk-conf.c b/drivers/clk/clk-conf.c
index 2ef819606c417..1a4e6340f95ce 100644
--- a/drivers/clk/clk-conf.c
+++ b/drivers/clk/clk-conf.c
@@ -33,9 +33,12 @@ static int __set_clk_parents(struct device_node *node, bool clk_supplier)
 			else
 				return rc;
 		}
-		if (clkspec.np == node && !clk_supplier)
+		if (clkspec.np == node && !clk_supplier) {
+			of_node_put(clkspec.np);
 			return 0;
+		}
 		pclk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(pclk)) {
 			if (PTR_ERR(pclk) != -EPROBE_DEFER)
 				pr_warn("clk: couldn't get parent clock %d for %pOF\n",
@@ -48,10 +51,12 @@ static int __set_clk_parents(struct device_node *node, bool clk_supplier)
 		if (rc < 0)
 			goto err;
 		if (clkspec.np == node && !clk_supplier) {
+			of_node_put(clkspec.np);
 			rc = 0;
 			goto err;
 		}
 		clk = of_clk_get_from_provider(&clkspec);
+		of_node_put(clkspec.np);
 		if (IS_ERR(clk)) {
 			if (PTR_ERR(clk) != -EPROBE_DEFER)
 				pr_warn("clk: couldn't get assigned clock %d for %pOF\n",
@@ -93,10 +98,13 @@ static int __set_clk_rates(struct device_node *node, bool clk_supplier)
 				else
 					return rc;
 			}
-			if (clkspec.np == node && !clk_supplier)
+			if (clkspec.np == node && !clk_supplier) {
+				of_node_put(clkspec.np);
 				return 0;
+			}
 
 			clk = of_clk_get_from_provider(&clkspec);
+			of_node_put(clkspec.np);
 			if (IS_ERR(clk)) {
 				if (PTR_ERR(clk) != -EPROBE_DEFER)
 					pr_warn("clk: couldn't get clock %d for %pOF\n",
-- 
2.39.2



