Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1DF4618D647;
	Thu, 15 Aug 2024 00:55:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683324; cv=none; b=OK5ZdWf309Ke/bA0czKhKrzKghGWkd5hKo0g58fFZkWenWdYUIybFahg/vuddGU0Tw1aAmTidZuN+83szaQ2QDm3+6g9HIY6EeXmum9QmlMtb8zxbUH4PcCrALdEqyTTAksXHAMowm21Q8BUu8xQoqJVhi8vL0I2CNsU/yCIE8E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683324; c=relaxed/simple;
	bh=jSrW+wA39NVGL2cGyKFMIseAxgZWnPBWZKgKQiLUEG0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=WsibmgZxmMKZQfr8S0SLuau9Dd4vHtFZXPcymxi0Pd4Ku8pt7c2nIhJT30l6Tok527e1c3aAazUlSSXzIgWzRkWxsWVbyrLwfMndIOBstaLwo9SKpQEAek9iJoYq2pWaf4kxKMYll4u6PNz2CGgvoz/FMPeTzGROldHEL9ICohw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=EIpxA52v; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="EIpxA52v"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A4745C116B1;
	Thu, 15 Aug 2024 00:55:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683324;
	bh=jSrW+wA39NVGL2cGyKFMIseAxgZWnPBWZKgKQiLUEG0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EIpxA52vSNY2I4JqdHwsVbIJAbk04HAphOImm2ejrpn8XXV3fA0I5PaK+mv63YBpV
	 LLjY9ZVALM1T1RPGa0ZBtbgI8e9O+QgJQhK9oT+iRVMPne0k7x187rNMmxa+08O9bv
	 +cZdMnWOaNyoZPKLNFbT3brR4AYlVQep7HdJVv1EoCMlBXVuwChz6UFKmmtC0bLEXs
	 VkFRxvP4G/BlBuUwLrwxdFaew229vtJ9GbATIULz6mJjcuKb57DHUdQi9wYaQVihRy
	 45KZNfj8zWNUP0I3T/dQLWcFrT9K+k0yd/lb+3EfaIYznbnEPcmNUMW9q23pHS5nAx
	 z+bOIlrV08oLw==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 04/12] clk: Add tests for unregistering clk_hw and using consumer APIs
Date: Wed, 14 Aug 2024 17:55:10 -0700
Message-ID: <20240815005520.1192374-5-sboyd@kernel.org>
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

Test the clk consumer APIs after unregistering the underlying clk_hw
that provides the clk_ops for the clk held by the consumer. The clk
framework replaces the clk_ops when the clk_hw has been unregistered
with functions that fail. Ensure that clk API behavior is consistent by
testing the APIs to make sure the original clk_ops aren't called and
that the clk APIs return failure as expected.

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 298 +++++++++++++++++++++++++++++++++++++++++
 1 file changed, 298 insertions(+)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 41fc8eba3418..c06971fe9922 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3108,6 +3108,303 @@ static struct kunit_suite clk_register_clk_parent_data_device_suite = {
 	.test_cases = clk_register_clk_parent_data_device_test_cases,
 };
 
+struct clk_unregister_consumer_clk_ctx {
+	struct kunit *test;
+	struct clk_hw hw;
+	bool unregistered;
+	unsigned long rate;
+	unsigned long accuracy;
+	struct clk *clk;
+};
+
+/* Unregister the clk and mark it as unregistered for the tests. */
+static void clk_unregister_consumer_clk_unregister(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_unregister_kunit(test, &ctx->hw));
+	ctx->unregistered = true;
+}
+
+/* Test that clk_put() can be called after the clk_hw has been unregistered. */
+static void clk_unregister_consumer_clk_put(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_EQ(test, 0, clk_put_kunit(test, ctx->clk));
+}
+
+/* Test that clk_prepare() fails after the clk_hw has been unregistered. */
+static void clk_unregister_consumer_clk_prepare_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_prepare(ctx->clk));
+}
+
+/*
+ * Test that clk_unprepare() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_unprepare_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, 0, clk_prepare(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	clk_unprepare(ctx->clk);
+}
+
+/* Test that clk_enable() fails after the clk_hw has been unregistered. */
+static void clk_unregister_consumer_clk_enable_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, 0, clk_prepare(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_enable(ctx->clk));
+	clk_unprepare(ctx->clk);
+}
+
+/*
+ * Test that clk_disable() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_disable_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, 0, clk_prepare(ctx->clk));
+	KUNIT_ASSERT_EQ(test, 0, clk_enable(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	clk_disable(ctx->clk);
+	clk_unprepare(ctx->clk);
+}
+
+/*
+ * Test that clk_round_rate() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_round_rate_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const unsigned long test_rate = 10200;
+
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_round_rate(ctx->clk, test_rate));
+}
+
+/*
+ * Test that clk_set_rate() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_set_rate_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const unsigned long test_rate = 38000;
+
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_set_rate(ctx->clk, test_rate));
+	KUNIT_EXPECT_NE(test, ctx->rate, test_rate);
+}
+
+/*
+ * Test that clk_get_rate() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_get_rate_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, ctx->rate, clk_get_rate(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_EQ(test, ctx->rate, clk_get_rate(ctx->clk));
+}
+
+/*
+ * Test that clk_get_accuracy() doesn't call the clk_op after the clk_hw has been
+ * unregistered.
+ */
+static void clk_unregister_consumer_clk_get_accuracy_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	KUNIT_ASSERT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
+}
+
+static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
+	KUNIT_CASE(clk_unregister_consumer_clk_prepare_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_unprepare_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_enable_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_disable_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_round_rate_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_set_rate_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_get_rate_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_get_accuracy_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_put),
+	{}
+};
+
+static void clk_unregister_consumer_clk_clk_op_called(struct clk_hw *hw,
+						       const char *clk_op_name)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+
+	/*
+	 * This code should never be reached because the clk_hw has been
+	 * unregistered.
+	 */
+	KUNIT_EXPECT_FALSE_MSG(ctx->test, ctx->unregistered,
+			       "clk_op %s was called for unregistered clk\n",
+			       clk_op_name);
+}
+
+static int clk_unregister_consumer_clk_op_prepare(struct clk_hw *hw)
+{
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return 0;
+}
+
+static void clk_unregister_consumer_clk_op_unprepare(struct clk_hw *hw)
+{
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+}
+
+static int clk_unregister_consumer_clk_op_enable(struct clk_hw *hw)
+{
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return 0;
+}
+
+static void clk_unregister_consumer_clk_op_disable(struct clk_hw *hw)
+{
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+}
+
+static unsigned long
+clk_unregister_consumer_clk_op_recalc_rate(struct clk_hw *hw, unsigned long parent_rate)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return ctx->rate;
+}
+
+static int
+clk_unregister_consumer_clk_op_determine_rate(struct clk_hw *hw,
+					       struct clk_rate_request *req)
+{
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return 0;
+}
+
+static long
+clk_unregister_consumer_clk_op_round_rate(struct clk_hw *hw, unsigned long rate,
+					   unsigned long *parent_rate)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return ctx->rate;
+}
+
+static int
+clk_unregister_consumer_clk_op_set_rate(struct clk_hw *hw, unsigned long rate,
+					 unsigned long parent_rate)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	ctx->rate = rate;
+
+	return 0;
+}
+
+static unsigned long
+clk_unregister_consumer_clk_op_recalc_accuracy(struct clk_hw *hw,
+						unsigned long parent_accuracy)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return ctx->accuracy;
+}
+
+static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
+	.prepare = clk_unregister_consumer_clk_op_prepare,
+	.unprepare = clk_unregister_consumer_clk_op_unprepare,
+	.enable = clk_unregister_consumer_clk_op_enable,
+	.disable = clk_unregister_consumer_clk_op_disable,
+	.recalc_rate = clk_unregister_consumer_clk_op_recalc_rate,
+	.round_rate = clk_unregister_consumer_clk_op_round_rate,
+	.determine_rate = clk_unregister_consumer_clk_op_determine_rate,
+	.set_rate = clk_unregister_consumer_clk_op_set_rate,
+	.recalc_accuracy = clk_unregister_consumer_clk_op_recalc_accuracy,
+};
+
+static int clk_unregister_consumer_clk_init(struct kunit *test)
+{
+	struct clk *clk;
+	struct clk_init_data init = { };
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = kunit_kzalloc(test, sizeof(*ctx), GFP_KERNEL);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
+	test->priv = ctx;
+	ctx->test = test;
+
+	init.name = "unregister_consumer_clk_test_clk";
+	init.ops = &clk_unregister_consumer_clk_clk_ops;
+	ctx->hw.init = &init;
+
+	ctx->rate = 42;
+	ctx->accuracy = 34;
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, &ctx->hw));
+
+	clk = clk_hw_get_clk_kunit(test, &ctx->hw, __func__);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, clk);
+	ctx->clk = clk;
+
+	return 0;
+}
+
+/*
+ * Test suite for clk consumer API behavior after the clk_hw has been
+ * unregistered. The clk consumer APIs should return failure and the clk_ops
+ * shouldn't be called.
+ */
+static struct kunit_suite clk_unregister_consumer_clk_suite = {
+	.name = "clk_unregister_consumer_clk",
+	.init = clk_unregister_consumer_clk_init,
+	.test_cases = clk_unregister_consumer_clk_test_cases,
+};
+
 kunit_test_suites(
 	&clk_leaf_mux_set_rate_parent_test_suite,
 	&clk_test_suite,
@@ -3124,6 +3421,7 @@ kunit_test_suites(
 	&clk_register_clk_parent_data_device_suite,
 	&clk_single_parent_mux_test_suite,
 	&clk_uncached_test_suite,
+	&clk_unregister_consumer_clk_suite,
 );
 MODULE_DESCRIPTION("Kunit tests for clk framework");
 MODULE_LICENSE("GPL v2");
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

