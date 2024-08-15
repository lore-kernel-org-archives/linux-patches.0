Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 969993D967;
	Thu, 15 Aug 2024 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683327; cv=none; b=PaQ+RrGxaRS8te0jHR2Auq6XKG+aZ4JAZb16B207CWHqyeWIY/JePajrvtWNGdUlDrmSY51PHNrSFZ7MToJnso1PCN7sZC3Z29yBWnJoxpgWa1NkxgqvKtoh3JjcfVVn97o+OzTSkkP9/B6O/6QaKLxtZ85LA5SBCnA3w8myk5M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683327; c=relaxed/simple;
	bh=6YnJ3r8XPc1/MdUXzMOWijTo13nVHKAihGNQa+lGagA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=DEPMexiqv6e76KiDrKEfrRaAwBNDLQ8/fWCJ7Mt86beI/0iTzOlPm8ZDJfX9hunbxZF5Y/ugqYzVAcWQAbovYr9hKhZ19UMoZ0yDeaFfCtpGu7+r8NdvUcNvbPui52L5de6gHLz/xcy2Fa+PYz/sZ8YwYKIf9YzU94yNCp3ulxs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=daa0cyus; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="daa0cyus"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 251AFC4AF17;
	Thu, 15 Aug 2024 00:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683327;
	bh=6YnJ3r8XPc1/MdUXzMOWijTo13nVHKAihGNQa+lGagA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=daa0cyuspcjPtuaAWBoq+Tz6lTHL5cotLSCv4Ujgr81VIk/h9JtarfCLij+p17YEW
	 0/3Xt4C0fMGUxdzDXHT41CphAxl58RUIDZek6Ev1UXkqj5bUuFvgWxKu1g2dCfyPEL
	 su81RksqvXYV4iu91BhqFM2wLfqOF+zjI8AkUMOVHFLzDbCNNJWb5s7Wmj7cV4p6zG
	 XTfGEdXiiSdQYhif8zOXLdzSWkwz+HhGspA11IG2jia9ao9ubN6zVsyRegc0lUNT74
	 RWdCTRQ1HFbN/usnO+uWFsI60EoAFdEljgE0HpdGF0iXDQVl5/sFbfbQjZIfN/q4pB
	 gIGazneKTVIGQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 11/12] clk: Test parent/clk flags combos while unregistering a clk_hw
Date: Wed, 14 Aug 2024 17:55:17 -0700
Message-ID: <20240815005520.1192374-12-sboyd@kernel.org>
X-Mailer: git-send-email 2.46.0.76.ge559c4bf1a-goog
In-Reply-To: <20240815005520.1192374-1-sboyd@kernel.org>
References: <20240815005520.1192374-1-sboyd@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

Extend the clk_unregister_consumer_clk test suite to test different
combinations of number of parents and clk flags. The behavior should
stay consistent regardless of how many parents there are and what clk
flags were used during registration.

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 203 ++++++++++++++++++++++++++++++++++-------
 1 file changed, 169 insertions(+), 34 deletions(-)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 90bd0e0b93d5..591897162056 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3148,6 +3148,9 @@ static void clk_unregister_consumer_clk_prepare_fails(struct kunit *test)
 {
 	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
 
+	if (clk_hw_get_flags(&ctx->hw) & CLK_IS_CRITICAL)
+		kunit_skip(test, "Critical clks are already prepared");
+
 	clk_unregister_consumer_clk_unregister(test);
 
 	KUNIT_EXPECT_GT(test, 0, clk_prepare(ctx->clk));
@@ -3172,6 +3175,9 @@ static void clk_unregister_consumer_clk_enable_fails(struct kunit *test)
 {
 	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
 
+	if (clk_hw_get_flags(&ctx->hw) & CLK_IS_CRITICAL)
+		kunit_skip(test, "Critical clks are already enabled");
+
 	KUNIT_ASSERT_EQ(test, 0, clk_prepare(ctx->clk));
 	clk_unregister_consumer_clk_unregister(test);
 
@@ -3231,11 +3237,17 @@ static void clk_unregister_consumer_clk_set_rate_fails(struct kunit *test)
 static void clk_unregister_consumer_clk_get_rate_skips(struct kunit *test)
 {
 	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const unsigned long flags = clk_hw_get_flags(&ctx->hw);
 
 	KUNIT_ASSERT_EQ(test, ctx->rate, clk_get_rate(ctx->clk));
 	clk_unregister_consumer_clk_unregister(test);
 
-	KUNIT_EXPECT_EQ(test, ctx->rate, clk_get_rate(ctx->clk));
+	if (flags & CLK_GET_RATE_NOCACHE) {
+		/* No cache clks start returning 0 and also skip */
+		KUNIT_EXPECT_EQ(test, 0, clk_get_rate(ctx->clk));
+	} else {
+		KUNIT_EXPECT_EQ(test, ctx->rate, clk_get_rate(ctx->clk));
+	}
 }
 
 /*
@@ -3245,11 +3257,17 @@ static void clk_unregister_consumer_clk_get_rate_skips(struct kunit *test)
 static void clk_unregister_consumer_clk_get_accuracy_skips(struct kunit *test)
 {
 	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const unsigned long flags = clk_hw_get_flags(&ctx->hw);
 
 	KUNIT_ASSERT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
 	clk_unregister_consumer_clk_unregister(test);
 
-	KUNIT_EXPECT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
+	if (flags & CLK_GET_ACCURACY_NOCACHE) {
+		/* No cache clks start returning 0 and also skip */
+		KUNIT_EXPECT_EQ(test, 0, clk_get_accuracy(ctx->clk));
+	} else {
+		KUNIT_EXPECT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
+	}
 }
 
 /*
@@ -3334,7 +3352,8 @@ static void clk_unregister_consumer_clk_set_parent_fails(struct kunit *test)
 	/* Setting current parent is a no-op */
 	KUNIT_EXPECT_EQ(test, 0, clk_set_parent(ctx->clk, ctx->parents[0].clk));
 	/* Setting a new parent should fail */
-	KUNIT_EXPECT_GT(test, 0, clk_set_parent(ctx->clk, ctx->parents[1].clk));
+	if (ctx->parents[1].clk)
+		KUNIT_EXPECT_GT(test, 0, clk_set_parent(ctx->clk, ctx->parents[1].clk));
 	/* Parent is unchanged */
 	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
 }
@@ -3354,22 +3373,108 @@ static void clk_unregister_consumer_clk_get_parent_skips(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
 }
 
+/**
+ * struct clk_register_params - Test parameters for different combinations of clk_init_data
+ * @clk_flags: Flags to set in struct clk_init_data::flags
+ * @num_parents: Number of parents to register (0, 1, or 2)
+ */
+struct clk_register_params {
+	unsigned long clk_flags;
+	unsigned int num_parents;
+};
+
+static void clk_register_params_to_desc(const char *test_name,
+					const struct clk_register_params *p,
+					char *desc)
+{
+	snprintf(desc, KUNIT_PARAM_DESC_SIZE, "%s %d parents %#lx flags",
+		 test_name, p->num_parents, p->clk_flags);
+}
+
+/**
+ * clk_register_gen_params - Generate parameters for struct clk_init_data
+ * @test_name: Test name
+ * @_prev: Previous return value from this function
+ * @desc: Test description (to be filled in)
+ *
+ * Use this function in KUNIT_CASE_PARAM to generate struct clk_init_data
+ * parameters for a test that registers clks. It will return combinations of
+ * clk flags (exclusive of each other) and numbers of parents.
+ *
+ * Return: Test parameters in a struct clk_register_params.
+ */
+static const void *clk_register_gen_params(const char *test_name,
+					   const void *_prev, char *desc)
+{
+	const struct clk_register_params *prev = _prev;
+	struct clk_register_params *next;
+
+	next = krealloc(prev, sizeof(*next), GFP_KERNEL);
+	if (!next)
+		return NULL;
+	if (!prev)
+		memset(next, 0, sizeof(*next));
+
+	if (prev) {
+		if (next->clk_flags == 0)
+			next->clk_flags = 1;
+		else
+			next->clk_flags <<= 1;
+	}
+
+	if (next->clk_flags > CLK_DUTY_CYCLE_PARENT) {
+		next->clk_flags = 0;
+		next->num_parents++;
+		if (next->num_parents > 2)
+			return NULL;
+	}
+
+	clk_register_params_to_desc(test_name, next, desc);
+	return next;
+}
+
+#define CLK_REGISTER_GEN_PARAMS(name)					\
+	static const void *name##_gen_params(const void *prev,		\
+					    char *desc)			\
+	{								\
+		return clk_register_gen_params(#name, prev, desc);	\
+	}
+
+#define CLK_REGISTER_KUNIT_CASE_PARAM(name)				\
+	KUNIT_CASE_PARAM(name, name##_gen_params)
+
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_prepare_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_unprepare_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_enable_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_disable_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_round_rate_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_set_rate_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_get_rate_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_get_accuracy_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_set_phase_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_get_phase_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_set_duty_cycle_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_get_duty_cycle_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_set_parent_fails)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_get_parent_skips)
+CLK_REGISTER_GEN_PARAMS(clk_unregister_consumer_clk_put)
+
 static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
-	KUNIT_CASE(clk_unregister_consumer_clk_prepare_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_unprepare_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_enable_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_disable_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_round_rate_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_set_rate_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_get_rate_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_get_accuracy_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_set_phase_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_get_phase_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_set_duty_cycle_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_get_duty_cycle_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_set_parent_fails),
-	KUNIT_CASE(clk_unregister_consumer_clk_get_parent_skips),
-	KUNIT_CASE(clk_unregister_consumer_clk_put),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_prepare_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_unprepare_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_enable_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_disable_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_round_rate_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_set_rate_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_rate_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_accuracy_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_set_phase_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_phase_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_set_duty_cycle_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_duty_cycle_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_set_parent_fails),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_parent_skips),
+	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_put),
 	{}
 };
 
@@ -3586,33 +3691,63 @@ static int clk_unregister_consumer_clk_init(struct kunit *test)
 	struct clk *clk;
 	struct clk_init_data init = { };
 	struct clk_unregister_consumer_clk_ctx *ctx;
-	struct clk_hw *parent0_hw, *parent1_hw;
+	struct clk_hw *parent0_hw = NULL;
+	struct clk_hw *parent1_hw = NULL;
+	const struct clk_register_params *test_param;
+	unsigned int num_parents;
+	unsigned long clk_flags;
+	struct clk_ops *clk_ops;
+
+	test_param = test->param_value;
+	if (test_param) {
+		num_parents = test_param->num_parents;
+		clk_flags = test_param->clk_flags;
+	} else {
+		num_parents = 0;
+		clk_flags = 0;
+	}
 
 	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 	test->priv = ctx;
 	ctx->test = test;
 
-	parent0_hw = &ctx->parents[0].ctx.hw;
-	parent0_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk0",
-						&clk_dummy_rate_ops, 0);
-	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent0_hw));
-	ctx->parents[0].clk = clk_hw_get_clk_kunit(test, parent0_hw, "p0");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[0].clk);
+	if (num_parents >= 1) {
+		parent0_hw = &ctx->parents[0].ctx.hw;
+		parent0_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk0",
+							&clk_dummy_rate_ops, 0);
+		KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent0_hw));
+		ctx->parents[0].clk = clk_hw_get_clk_kunit(test, parent0_hw, "p0");
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[0].clk);
+	}
 
-	parent1_hw = &ctx->parents[1].ctx.hw;
-	parent1_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk1",
-						&clk_dummy_rate_ops, 0);
-	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent1_hw));
-	ctx->parents[1].clk = clk_hw_get_clk_kunit(test, parent1_hw, "p1");
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[1].clk);
+	if (num_parents >= 2) {
+		parent1_hw = &ctx->parents[1].ctx.hw;
+		parent1_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk1",
+							&clk_dummy_rate_ops, 0);
+		KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent1_hw));
+		ctx->parents[1].clk = clk_hw_get_clk_kunit(test, parent1_hw, "p1");
+		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[1].clk);
+	}
 
 	init.name = "unregister_consumer_clk_test_clk";
-	init.ops = &clk_unregister_consumer_clk_clk_ops;
-	init.parent_hws = (const struct clk_hw *[]){ parent0_hw, parent1_hw };
-	init.num_parents = ARRAY_SIZE(ctx->parents);
 	ctx->hw.init = &init;
 
+	clk_ops = kunit_kzalloc(test, sizeof(*clk_ops), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, clk_ops);
+	/* Copy clk_ops so we can modify them for different scenarios */
+	memcpy(clk_ops, &clk_unregister_consumer_clk_clk_ops, sizeof(*clk_ops));
+	init.ops = clk_ops;
+
+	init.flags = clk_flags;
+	init.num_parents = num_parents;
+	init.parent_hws = (const struct clk_hw *[]){ parent0_hw, parent1_hw };
+	if (!num_parents) {
+		clk_ops->get_parent = NULL;
+		clk_ops->set_parent = NULL;
+		clk_ops->set_rate_and_parent = NULL;
+	}
+
 	ctx->rate = 42;
 	ctx->accuracy = 34;
 	ctx->phase = 90;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

