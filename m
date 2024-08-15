Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1583A18D64B;
	Thu, 15 Aug 2024 00:55:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683326; cv=none; b=pF4GXysgP5uqOD4mWpt5/hUGCniImNSu8EXmZqPqZVDuMyLClqvI8MLXNlq7cXgaAReSOa/KW3nWwBs87aDvl+Ll3ugdQS9FAROIzqxD9k8aeFUsBrTFibzfPLEHheBPG7prs4pZkblP3YDJozokj3BBFgcGomjxbKzX9r/X44E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683326; c=relaxed/simple;
	bh=CgN/q13mNOEFVCkeiX1EsHumaXiCGBBTX6yoG51ApSE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=AdgRp4kWcIt5ZlEC2yOO5iBKmHVBgv1tfSCTjXLbEaFWPCUMP0kRfsqTAgcdrVdE/i16e7AywpJL/qcsQXXRC8PbTFjsS9SNLPV5WGrxBzjZ2kfwGM1kE0LlF4oOwyHgNY3tRZjUQNy5mroHNcjcMrSEFN8teTs9RBhtw6g+LGk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=Hayo92lf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="Hayo92lf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F768C4AF11;
	Thu, 15 Aug 2024 00:55:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683326;
	bh=CgN/q13mNOEFVCkeiX1EsHumaXiCGBBTX6yoG51ApSE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Hayo92lfVjrJzsa6zT8CkQpNDvbxS0fts9b1KW9uKVFCbf1b+Dxh9ANKypv+oxEwh
	 aiAeY35SqsMpO02VyfKPRh0JOTHuzujUht7szzBnnsW9xPnoJ2GFwmy+ZPZkB8dSul
	 KGw72dp2Qt7YAh6nafIny1+JcfSFMP3oep+MAz1BXAMtG3TfGU+cbi5C0NMU0PQ2Dv
	 VIi/z4gFMDRVHzR0+8EI0aMQhGdlJfTNVP1yOCSOVm2S9R3s6nXZFS6naGLVX699ng
	 fphLzJjj5rfL7GyTCocoXvZb7/+0vgTFDGHJ/PmwqhXgcAhW/58pTod2DHA5j5iGhz
	 Lp+8Xfo4buKvQ==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 08/12] clk: Test clk_set_duty_cycle() behavior after clk_hw is unregistered
Date: Wed, 14 Aug 2024 17:55:14 -0700
Message-ID: <20240815005520.1192374-9-sboyd@kernel.org>
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

The previous commit fixed clk_set_duty_cycle() so that it returns
failure after a clk_hw is unregistered. Add a test for that so that
stays true.

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 70 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 70 insertions(+)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index f97d13bb0242..1fea29f93b2a 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3115,6 +3115,7 @@ struct clk_unregister_consumer_clk_ctx {
 	unsigned long rate;
 	unsigned long accuracy;
 	int phase;
+	struct clk_duty duty;
 	struct clk *clk;
 };
 
@@ -3278,6 +3279,42 @@ static void clk_unregister_consumer_clk_get_phase_skips(struct kunit *test)
 	KUNIT_EXPECT_GT(test, 0, clk_get_phase(ctx->clk));
 }
 
+/*
+ * Test that clk_set_duty_cycle() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns failure.
+ */
+static void clk_unregister_consumer_clk_set_duty_cycle_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const int num = 20, den = 30;
+
+	KUNIT_ASSERT_NE(test, ctx->duty.num, num);
+	KUNIT_ASSERT_NE(test, ctx->duty.den, den);
+	KUNIT_ASSERT_EQ(test, ctx->duty.num, clk_get_scaled_duty_cycle(ctx->clk, ctx->duty.den));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_set_duty_cycle(ctx->clk, num, den));
+	/* Duty cycle is unchanged */
+	KUNIT_EXPECT_EQ(test, ctx->duty.num, clk_get_scaled_duty_cycle(ctx->clk, ctx->duty.den));
+}
+
+/*
+ * Test that clk_get_scaled_duty_cycle() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns original duty cycle.
+ */
+static void clk_unregister_consumer_clk_get_duty_cycle_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const int num = ctx->duty.num;
+	const int den = ctx->duty.den;
+
+	KUNIT_ASSERT_EQ(test, num, clk_get_scaled_duty_cycle(ctx->clk, den));
+	clk_unregister_consumer_clk_unregister(test);
+
+	/* Duty cycle is unchanged */
+	KUNIT_EXPECT_EQ(test, num, clk_get_scaled_duty_cycle(ctx->clk, den));
+}
+
 static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_prepare_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_unprepare_skips),
@@ -3289,6 +3326,8 @@ static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_get_accuracy_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_set_phase_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_get_phase_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_set_duty_cycle_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_get_duty_cycle_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_put),
 	{}
 };
@@ -3415,6 +3454,33 @@ clk_unregister_consumer_clk_op_set_phase(struct clk_hw *hw, int degrees)
 	return 0;
 }
 
+static int clk_unregister_consumer_clk_op_get_duty_cycle(struct clk_hw *hw,
+							  struct clk_duty *duty)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	*duty = ctx->duty;
+
+	return 0;
+}
+
+static int clk_unregister_consumer_clk_op_set_duty_cycle(struct clk_hw *hw,
+							  struct clk_duty *duty)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	ctx->duty.num = duty->num;
+	ctx->duty.den = duty->den;
+
+	return 0;
+}
+
 static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
 	.prepare = clk_unregister_consumer_clk_op_prepare,
 	.unprepare = clk_unregister_consumer_clk_op_unprepare,
@@ -3427,6 +3493,8 @@ static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
 	.recalc_accuracy = clk_unregister_consumer_clk_op_recalc_accuracy,
 	.get_phase = clk_unregister_consumer_clk_op_get_phase,
 	.set_phase = clk_unregister_consumer_clk_op_set_phase,
+	.get_duty_cycle = clk_unregister_consumer_clk_op_get_duty_cycle,
+	.set_duty_cycle = clk_unregister_consumer_clk_op_set_duty_cycle,
 };
 
 static int clk_unregister_consumer_clk_init(struct kunit *test)
@@ -3447,6 +3515,8 @@ static int clk_unregister_consumer_clk_init(struct kunit *test)
 	ctx->rate = 42;
 	ctx->accuracy = 34;
 	ctx->phase = 90;
+	ctx->duty.num = 50;
+	ctx->duty.den = 100;
 	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, &ctx->hw));
 
 	clk = clk_hw_get_clk_kunit(test, &ctx->hw, __func__);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

