Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A44A39FD9;
	Thu, 15 Aug 2024 00:55:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683327; cv=none; b=ipd6mUVx1uGKKI18FZ3bUFBsjWRN2WRgsoPUXk6caEz+AF1B1FJL/uJjF+rRnrBjlWtRcwzJQx+Pnvt5xDSWmobK/G2Yq48FLGNBgKuUKCpxrPqHUO+/P8o00RuT6enqJ+gjKiKYP3ivBrEiwodCbnD4x3wxjBOyn6kEOCqkIUU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683327; c=relaxed/simple;
	bh=k9KZ3KijKptDTCY/wBpiJfZyU6TBgQcQzNu7hWGM2pk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mv3jx6XzzTsFa2oOwNcwhpuGr3rsB4AULhJn5fMd2pKh/yvT+rsoHgB22wR2Jr9NODpLebF5jD7SbyuSL9roPm+WdtKaYRqDBKfrrc09jODCLbbWmH1zzW+xhrk6DR8Nn5NkVS7+8MgEHSi6v6HhBtwxxZU1YA3ZaOb86CpJjMw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Sh03+G1Z; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Sh03+G1Z"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A299BC4AF14;
	Thu, 15 Aug 2024 00:55:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683327;
	bh=k9KZ3KijKptDTCY/wBpiJfZyU6TBgQcQzNu7hWGM2pk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Sh03+G1ZdJLdkzBfYcM/Kb6gpOa8YcRBMW6rDPGnh7ATu130PitibwbdS6lMytgMv
	 gkPNDMxsuvSpjmyAOUjeD7LQFgawGDBu3vsNinfRYI9w4hyhgFSOvgTEQfvJl2AkAU
	 r1jygfZcY2wquBBqsr/SZfFLiXmMriaPVWxrNTwk5+D0Rw+LEQL8Qa7e9zWWzg8CUx
	 2alHtHEtyVB8bdyf4KmIgZmig20cxGFwdYtTdWFuARt/awHj6Bz2eFQr2Jk8BnmvKK
	 HPD5QPt2ubMrODOvvAJDZRG0rbHQ9n52UHhl+3YG6NMVHiWFTvgKfxxpdT8EnbTiXo
	 zu/TTmJ7kjeCQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 10/12] clk: Test clk_set_parent() behavior after clk_hw is unregistered
Date: Wed, 14 Aug 2024 17:55:16 -0700
Message-ID: <20240815005520.1192374-11-sboyd@kernel.org>
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

The previous commit fixed clk_set_parent() so that it returns failure
after a clk_hw is unregistered. Add a test for that so that stays true.

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 101 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 101 insertions(+)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 1fea29f93b2a..90bd0e0b93d5 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3117,6 +3117,11 @@ struct clk_unregister_consumer_clk_ctx {
 	int phase;
 	struct clk_duty duty;
 	struct clk *clk;
+	struct {
+		struct clk_dummy_context ctx;
+		struct clk *clk;
+	} parents[2];
+	u8 parent;
 };
 
 /* Unregister the clk and mark it as unregistered for the tests. */
@@ -3315,6 +3320,40 @@ static void clk_unregister_consumer_clk_get_duty_cycle_skips(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, num, clk_get_scaled_duty_cycle(ctx->clk, den));
 }
 
+/*
+ * Test that clk_set_parent() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns failure.
+ */
+static void clk_unregister_consumer_clk_set_parent_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	/* Setting current parent is a no-op */
+	KUNIT_EXPECT_EQ(test, 0, clk_set_parent(ctx->clk, ctx->parents[0].clk));
+	/* Setting a new parent should fail */
+	KUNIT_EXPECT_GT(test, 0, clk_set_parent(ctx->clk, ctx->parents[1].clk));
+	/* Parent is unchanged */
+	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
+}
+
+/*
+ * Test that clk_get_parent() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns original parent.
+ */
+static void clk_unregister_consumer_clk_get_parent_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	/* Parent is unchanged */
+	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
+}
+
 static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_prepare_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_unprepare_skips),
@@ -3328,6 +3367,8 @@ static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_get_phase_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_set_duty_cycle_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_get_duty_cycle_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_set_parent_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_get_parent_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_put),
 	{}
 };
@@ -3418,6 +3459,46 @@ clk_unregister_consumer_clk_op_set_rate(struct clk_hw *hw, unsigned long rate,
 	return 0;
 }
 
+static int
+clk_unregister_consumer_clk_op_set_parent(struct clk_hw *hw, u8 index)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	ctx->parent = index;
+
+	return 0;
+}
+
+static u8 clk_unregister_consumer_clk_op_get_parent(struct clk_hw *hw)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return ctx->parent;
+}
+
+static int
+clk_unregister_consumer_clk_op_set_rate_and_parent(struct clk_hw *hw,
+						   unsigned long rate,
+						   unsigned long parent_rate,
+						   u8 index)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	ctx->parent = index;
+	ctx->rate = rate;
+
+	return 0;
+}
+
 static unsigned long
 clk_unregister_consumer_clk_op_recalc_accuracy(struct clk_hw *hw,
 						unsigned long parent_accuracy)
@@ -3490,6 +3571,9 @@ static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
 	.round_rate = clk_unregister_consumer_clk_op_round_rate,
 	.determine_rate = clk_unregister_consumer_clk_op_determine_rate,
 	.set_rate = clk_unregister_consumer_clk_op_set_rate,
+	.set_parent = clk_unregister_consumer_clk_op_set_parent,
+	.get_parent = clk_unregister_consumer_clk_op_get_parent,
+	.set_rate_and_parent = clk_unregister_consumer_clk_op_set_rate_and_parent,
 	.recalc_accuracy = clk_unregister_consumer_clk_op_recalc_accuracy,
 	.get_phase = clk_unregister_consumer_clk_op_get_phase,
 	.set_phase = clk_unregister_consumer_clk_op_set_phase,
@@ -3502,14 +3586,31 @@ static int clk_unregister_consumer_clk_init(struct kunit *test)
 	struct clk *clk;
 	struct clk_init_data init = { };
 	struct clk_unregister_consumer_clk_ctx *ctx;
+	struct clk_hw *parent0_hw, *parent1_hw;
 
 	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 	test->priv = ctx;
 	ctx->test = test;
 
+	parent0_hw = &ctx->parents[0].ctx.hw;
+	parent0_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk0",
+						&clk_dummy_rate_ops, 0);
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent0_hw));
+	ctx->parents[0].clk = clk_hw_get_clk_kunit(test, parent0_hw, "p0");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[0].clk);
+
+	parent1_hw = &ctx->parents[1].ctx.hw;
+	parent1_hw->init = CLK_HW_INIT_NO_PARENT("parent-clk1",
+						&clk_dummy_rate_ops, 0);
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, parent1_hw));
+	ctx->parents[1].clk = clk_hw_get_clk_kunit(test, parent1_hw, "p1");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[1].clk);
+
 	init.name = "unregister_consumer_clk_test_clk";
 	init.ops = &clk_unregister_consumer_clk_clk_ops;
+	init.parent_hws = (const struct clk_hw *[]){ parent0_hw, parent1_hw };
+	init.num_parents = ARRAY_SIZE(ctx->parents);
 	ctx->hw.init = &init;
 
 	ctx->rate = 42;
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

