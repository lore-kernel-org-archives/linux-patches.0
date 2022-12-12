Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B7B28ED
	for <patches@lists.linux.dev>; Mon, 12 Dec 2022 13:24:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 11641C433F0;
	Mon, 12 Dec 2022 13:24:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1670851494;
	bh=sMbiJspHz1FpW09joxFASI7BIyRDAaDDtMpeZz2orik=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=q53IUVez5qFFE2OGB2c6Hzasns/rKJuFAE6QOYaRu5VXD3rIF0SDMt44WAeHQinHv
	 ccBX64x97REgCutvvYa/W4e0Tgu515NpP9Ce2+uRDStEeyR/DaiK3AOmAg3FCZjReX
	 T9MteDO22U53HwfixyOlxmveiQeNycgE/u2+N/f8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jonathan Cameron <Jonathan.Cameron@huawei.com>,
	Alexandru Ardelean <aardelean@deviqon.com>,
	=?UTF-8?q?Uwe=20Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>,
	Stephen Boyd <sboyd@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 001/123] clk: generalize devm_clk_get() a bit
Date: Mon, 12 Dec 2022 14:16:07 +0100
Message-Id: <20221212130926.878822208@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221212130926.811961601@linuxfoundation.org>
References: <20221212130926.811961601@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>

[ Upstream commit abae8e57e49aa75f6db76aa866c775721523908f ]

Allow to add an exit hook to devm managed clocks. Also use
clk_get_optional() in devm_clk_get_optional instead of open coding it.
The generalisation will be used in the next commit to add some more
devm_clk helpers.

Reviewed-by: Jonathan Cameron <Jonathan.Cameron@huawei.com>
Reviewed-by: Alexandru Ardelean <aardelean@deviqon.com>
Signed-off-by: Uwe Kleine-König <u.kleine-koenig@pengutronix.de>
Link: https://lore.kernel.org/r/20220520075737.758761-3-u.kleine-koenig@pengutronix.de
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
Stable-dep-of: c61bfb1cb63d ("mmc: mtk-sd: Fix missing clk_disable_unprepare in msdc_of_clock_parse()")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/clk/clk-devres.c | 66 +++++++++++++++++++++++++++++-----------
 1 file changed, 49 insertions(+), 17 deletions(-)

diff --git a/drivers/clk/clk-devres.c b/drivers/clk/clk-devres.c
index f9d5b7334341..c822f4ef1584 100644
--- a/drivers/clk/clk-devres.c
+++ b/drivers/clk/clk-devres.c
@@ -4,39 +4,71 @@
 #include <linux/export.h>
 #include <linux/gfp.h>
 
+struct devm_clk_state {
+	struct clk *clk;
+	void (*exit)(struct clk *clk);
+};
+
 static void devm_clk_release(struct device *dev, void *res)
 {
-	clk_put(*(struct clk **)res);
+	struct devm_clk_state *state = *(struct devm_clk_state **)res;
+
+	if (state->exit)
+		state->exit(state->clk);
+
+	clk_put(state->clk);
 }
 
-struct clk *devm_clk_get(struct device *dev, const char *id)
+static struct clk *__devm_clk_get(struct device *dev, const char *id,
+				  struct clk *(*get)(struct device *dev, const char *id),
+				  int (*init)(struct clk *clk),
+				  void (*exit)(struct clk *clk))
 {
-	struct clk **ptr, *clk;
+	struct devm_clk_state *state;
+	struct clk *clk;
+	int ret;
 
-	ptr = devres_alloc(devm_clk_release, sizeof(*ptr), GFP_KERNEL);
-	if (!ptr)
+	state = devres_alloc(devm_clk_release, sizeof(*state), GFP_KERNEL);
+	if (!state)
 		return ERR_PTR(-ENOMEM);
 
-	clk = clk_get(dev, id);
-	if (!IS_ERR(clk)) {
-		*ptr = clk;
-		devres_add(dev, ptr);
-	} else {
-		devres_free(ptr);
+	clk = get(dev, id);
+	if (IS_ERR(clk)) {
+		ret = PTR_ERR(clk);
+		goto err_clk_get;
 	}
 
+	if (init) {
+		ret = init(clk);
+		if (ret)
+			goto err_clk_init;
+	}
+
+	state->clk = clk;
+	state->exit = exit;
+
+	devres_add(dev, state);
+
 	return clk;
+
+err_clk_init:
+
+	clk_put(clk);
+err_clk_get:
+
+	devres_free(state);
+	return ERR_PTR(ret);
+}
+
+struct clk *devm_clk_get(struct device *dev, const char *id)
+{
+	return __devm_clk_get(dev, id, clk_get, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get);
 
 struct clk *devm_clk_get_optional(struct device *dev, const char *id)
 {
-	struct clk *clk = devm_clk_get(dev, id);
-
-	if (clk == ERR_PTR(-ENOENT))
-		return NULL;
-
-	return clk;
+	return __devm_clk_get(dev, id, clk_get_optional, NULL, NULL);
 }
 EXPORT_SYMBOL(devm_clk_get_optional);
 
-- 
2.35.1



