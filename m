Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5791217BD9;
	Thu, 15 Aug 2024 00:55:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683325; cv=none; b=pMFRgoAuRNZYLeMaKYAcFFXJKjahLWcpcpxc03JQZns7TjT3QyWotTPIGiskYr7Kz4bZpGYr5hN+WD8l4kPwdXn19ADuhUMTeSgoYUNgbAHU9VFd+GNQBPuYQL+K8E2LZxqU4jKMZGPyuvNl0FIGJz8A9nDnYWxcgR0lbjc5bzk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683325; c=relaxed/simple;
	bh=ZU84pHG3d40zDH7wjEjU96WhGyhp9uNluBwXi1csJTw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OWEttjqKfSUwUQq8kSIGgXfS/OIsUMYTjOFXgdg1e54A3kYGpLAQRX7jxS5qPaciWkzeEwg31Dbu6O1SYTITafRJdGkobV2XscauAomd04YeTFVb+HZ9aY74KVib4s7/WWhfS+azSzAH1UeTchwPwQXHDyd8q8eKm9A8pFnAF70=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qf9PK9Ck; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qf9PK9Ck"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A31DFC4AF19;
	Thu, 15 Aug 2024 00:55:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683325;
	bh=ZU84pHG3d40zDH7wjEjU96WhGyhp9uNluBwXi1csJTw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qf9PK9Cktss50lkOCVkmK0w1fi0zXA5qEhWu7rh1HZsXQqUTPLf2E6yOOK08fqQXo
	 0UHbMholIZYK2cIRHD0pmHvPtJtaX/bHaGAGWA6G43c0o09GpmmCGp92cPrnuj4oA4
	 HVmqOthAzh5pdzOTYV93wyfk7d+l7TLARS1DgHpVM/qvHXjK+B6YE3qHeRmMnS49ZS
	 fzNyJyr1CMUvPwF1ArHZOQK7jaoFKLfJ5Sdz/lsGCipjiW15npLt1/N4jMCgVs6BuJ
	 aXYCS47ocS9UK01r0zzBsO6jm8y1utkgF69+OPgiFytrhnoraz22wAhjsa+5+3Raa/
	 qVoW0pRaprQBA==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 06/12] clk: Test clk_get_phase() behavior after clk_hw is unregistered
Date: Wed, 14 Aug 2024 17:55:12 -0700
Message-ID: <20240815005520.1192374-7-sboyd@kernel.org>
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

The previous commit fixed clk_get_phase() so that it returns failure
after a clk_hw is unregistered. Add a test for that so that stays true.

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 62 ++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 62 insertions(+)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index c06971fe9922..f97d13bb0242 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3114,6 +3114,7 @@ struct clk_unregister_consumer_clk_ctx {
 	bool unregistered;
 	unsigned long rate;
 	unsigned long accuracy;
+	int phase;
 	struct clk *clk;
 };
 
@@ -3245,6 +3246,38 @@ static void clk_unregister_consumer_clk_get_accuracy_skips(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, ctx->accuracy, clk_get_accuracy(ctx->clk));
 }
 
+/*
+ * Test that clk_set_phase() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns failure.
+ */
+static void clk_unregister_consumer_clk_set_phase_fails(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const int degrees = 12;
+
+	KUNIT_ASSERT_NE(test, degrees, clk_get_phase(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_set_phase(ctx->clk, degrees));
+	/* Phase is unchanged */
+	KUNIT_EXPECT_NE(test, degrees, clk_get_phase(ctx->clk));
+}
+
+/*
+ * Test that clk_get_phase() doesn't call the clk_op after the clk_hw has been
+ * unregistered and returns 0.
+ */
+static void clk_unregister_consumer_clk_get_phase_skips(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	const int phase = ctx->phase;
+
+	KUNIT_ASSERT_EQ(test, phase, clk_get_phase(ctx->clk));
+	clk_unregister_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_GT(test, 0, clk_get_phase(ctx->clk));
+}
+
 static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_prepare_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_unprepare_skips),
@@ -3254,6 +3287,8 @@ static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	KUNIT_CASE(clk_unregister_consumer_clk_set_rate_fails),
 	KUNIT_CASE(clk_unregister_consumer_clk_get_rate_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_get_accuracy_skips),
+	KUNIT_CASE(clk_unregister_consumer_clk_set_phase_fails),
+	KUNIT_CASE(clk_unregister_consumer_clk_get_phase_skips),
 	KUNIT_CASE(clk_unregister_consumer_clk_put),
 	{}
 };
@@ -3356,6 +3391,30 @@ clk_unregister_consumer_clk_op_recalc_accuracy(struct clk_hw *hw,
 	return ctx->accuracy;
 }
 
+static int clk_unregister_consumer_clk_op_get_phase(struct clk_hw *hw)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	return ctx->phase;
+}
+
+static int
+clk_unregister_consumer_clk_op_set_phase(struct clk_hw *hw, int degrees)
+{
+
+	struct clk_unregister_consumer_clk_ctx *ctx;
+
+	ctx = container_of(hw, struct clk_unregister_consumer_clk_ctx, hw);
+	clk_unregister_consumer_clk_clk_op_called(hw, __func__);
+
+	ctx->phase = degrees;
+
+	return 0;
+}
+
 static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
 	.prepare = clk_unregister_consumer_clk_op_prepare,
 	.unprepare = clk_unregister_consumer_clk_op_unprepare,
@@ -3366,6 +3425,8 @@ static const struct clk_ops clk_unregister_consumer_clk_clk_ops = {
 	.determine_rate = clk_unregister_consumer_clk_op_determine_rate,
 	.set_rate = clk_unregister_consumer_clk_op_set_rate,
 	.recalc_accuracy = clk_unregister_consumer_clk_op_recalc_accuracy,
+	.get_phase = clk_unregister_consumer_clk_op_get_phase,
+	.set_phase = clk_unregister_consumer_clk_op_set_phase,
 };
 
 static int clk_unregister_consumer_clk_init(struct kunit *test)
@@ -3385,6 +3446,7 @@ static int clk_unregister_consumer_clk_init(struct kunit *test)
 
 	ctx->rate = 42;
 	ctx->accuracy = 34;
+	ctx->phase = 90;
 	KUNIT_ASSERT_EQ(test, 0, clk_hw_register_kunit(test, NULL, &ctx->hw));
 
 	clk = clk_hw_get_clk_kunit(test, &ctx->hw, __func__);
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

