Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F05342AB1;
	Thu, 15 Aug 2024 00:55:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723683328; cv=none; b=CdE1JsrLbQRA+A1hP+AJV0BBqWxkX2M5JzBiG81Y1wmFfoxqsXMSqO+ikwUE2GIMmnoxwrv1nmIfB8iGLiTr6e+djqvfFDRiiiG4vqwZcXpz/MUc8EiQZz+KmfJCWIWqIeCZ5UQoHhX0MYg4JAS/Js/8NfbfDrGd7BQ4jEdkuDY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723683328; c=relaxed/simple;
	bh=xSrynoas2VR4X6Sh/7Pxh/r2s4reqen1keWxuGVhuPE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=I4KwXB7+Zk7pNjFxif3Oac1kPUeTz6/sZZKfPcuWkuNdAEKk5RH4qv7FSTFNN2wUh5/d0JKn7qqV23KF6puw6wR+m/AJXCyuRp0sl8Wt11v2mCORGlX9UBsui17ISaxJKGl67TEUKo/h0Y0w7jjEUjyJ0eGHmp+GoKFCcUq7imc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=qV0705xE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="qV0705xE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9B45EC4AF14;
	Thu, 15 Aug 2024 00:55:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1723683327;
	bh=xSrynoas2VR4X6Sh/7Pxh/r2s4reqen1keWxuGVhuPE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=qV0705xEMZwtGF2ZlkTzkye7gxkDlAuQ9fauHQdiryKGfcut8ofEbiHtB3ahQnALL
	 x2QxUVPobSybFfuzHGmDsHgnDTYQJxo4e3lUeO2Ua9m4Ht4NAre1Dw0AoHGuNsw6hO
	 BJ/A6PjfBeNjQ9Dcgn9HyVCmzD70JePnIUOLI6pOYEwccNQ2oNHVOuIOxsdy9h9fpT
	 XXLD0HLikrwYcAytkYZrdr8knVKcjeRKBq1oK4/0PaF6uTDt8EDeFHy48kO7hEyxeL
	 M4BNYAajWppc6mhTMB+elHJktzsVEHGt6QxqEIloMs3LMdwTbct0J4gwJTA8kcT13l
	 dZVvChLI5Taxg==
From: Stephen Boyd <sboyd@kernel.org>
To: Michael Turquette <mturquette@baylibre.com>,
	Stephen Boyd <sboyd@kernel.org>
Cc: linux-kernel@vger.kernel.org,
	linux-clk@vger.kernel.org,
	patches@lists.linux.dev,
	=?UTF-8?q?Nuno=20S=C3=A1?= <nuno.sa@analog.com>
Subject: [PATCH 12/12] WIP: clk: Test behavior of children clks after a parent is unregistered
Date: Wed, 14 Aug 2024 17:55:18 -0700
Message-ID: <20240815005520.1192374-13-sboyd@kernel.org>
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

When a parent clk is unregistered, descendant clks are orphaned and
removed from the clk tree. Test this scenario to make sure clk consumer
APIs with a child clk don't cause problems.

TODO: Fix the crashes

Cc: Nuno Sá <nuno.sa@analog.com>
Signed-off-by: Stephen Boyd <sboyd@kernel.org>
---
 drivers/clk/clk_test.c | 60 +++++++++++++++++++++++++++++++++++++++---
 1 file changed, 57 insertions(+), 3 deletions(-)

diff --git a/drivers/clk/clk_test.c b/drivers/clk/clk_test.c
index 591897162056..e6479c002023 100644
--- a/drivers/clk/clk_test.c
+++ b/drivers/clk/clk_test.c
@@ -3133,6 +3133,17 @@ static void clk_unregister_consumer_clk_unregister(struct kunit *test)
 	ctx->unregistered = true;
 }
 
+static void clk_unregister_parent_consumer_clk_unregister(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+	struct clk_hw *parent_hw = &ctx->parents[0].ctx.hw;
+	struct clk *parent_clk = ctx->parents[0].clk;
+
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, parent_clk);
+	KUNIT_ASSERT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), parent_clk));
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_unregister_kunit(test, parent_hw));
+}
+
 /* Test that clk_put() can be called after the clk_hw has been unregistered. */
 static void clk_unregister_consumer_clk_put(struct kunit *test)
 {
@@ -3143,6 +3154,15 @@ static void clk_unregister_consumer_clk_put(struct kunit *test)
 	KUNIT_EXPECT_EQ(test, 0, clk_put_kunit(test, ctx->clk));
 }
 
+static void clk_unregister_parent_consumer_clk_put(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	clk_unregister_parent_consumer_clk_unregister(test);
+
+	KUNIT_EXPECT_EQ(test, 0, clk_put_kunit(test, ctx->clk));
+}
+
 /* Test that clk_prepare() fails after the clk_hw has been unregistered. */
 static void clk_unregister_consumer_clk_prepare_fails(struct kunit *test)
 {
@@ -3358,6 +3378,24 @@ static void clk_unregister_consumer_clk_set_parent_fails(struct kunit *test)
 	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
 }
 
+/*
+ * Test that clk_set_parent() doesn't re-parent the clk back to the clk that
+ * was unregistered.
+ */
+static void clk_unregister_parent_consumer_clk_set_parent(struct kunit *test)
+{
+	struct clk_unregister_consumer_clk_ctx *ctx = test->priv;
+
+	kunit_skip(test, "Fix in the core. This blows up spectacularly!");
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx->parents[0].clk);
+	KUNIT_ASSERT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), ctx->parents[0].clk));
+	KUNIT_ASSERT_EQ(test, 0, clk_hw_unregister_kunit(test, &ctx->parents[0].ctx.hw));
+
+	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), NULL));
+	KUNIT_EXPECT_GT(test, 0, clk_set_parent(ctx->clk, ctx->parents[0].clk));
+	KUNIT_EXPECT_TRUE(test, clk_is_match(clk_get_parent(ctx->clk), NULL));
+}
+
 /*
  * Test that clk_get_parent() doesn't call the clk_op after the clk_hw has been
  * unregistered and returns original parent.
@@ -3396,6 +3434,8 @@ static void clk_register_params_to_desc(const char *test_name,
  * @test_name: Test name
  * @_prev: Previous return value from this function
  * @desc: Test description (to be filled in)
+ * @must_have_parents: True if struct clk_register_params::num_parents must be
+ * 1 or greater
  *
  * Use this function in KUNIT_CASE_PARAM to generate struct clk_init_data
  * parameters for a test that registers clks. It will return combinations of
@@ -3404,7 +3444,8 @@ static void clk_register_params_to_desc(const char *test_name,
  * Return: Test parameters in a struct clk_register_params.
  */
 static const void *clk_register_gen_params(const char *test_name,
-					   const void *_prev, char *desc)
+					   const void *_prev, char *desc,
+					   bool must_have_parents)
 {
 	const struct clk_register_params *prev = _prev;
 	struct clk_register_params *next;
@@ -3412,8 +3453,11 @@ static const void *clk_register_gen_params(const char *test_name,
 	next = krealloc(prev, sizeof(*next), GFP_KERNEL);
 	if (!next)
 		return NULL;
-	if (!prev)
+	if (!prev) {
 		memset(next, 0, sizeof(*next));
+		if (must_have_parents)
+			next->num_parents = 1;
+	}
 
 	if (prev) {
 		if (next->clk_flags == 0)
@@ -3433,11 +3477,19 @@ static const void *clk_register_gen_params(const char *test_name,
 	return next;
 }
 
+static const void *
+clk_unregister_parent_consumer_clk_gen_params(const void *prev,
+					      char *desc)
+{
+	return clk_register_gen_params("parent", prev, desc, true);
+}
+
 #define CLK_REGISTER_GEN_PARAMS(name)					\
 	static const void *name##_gen_params(const void *prev,		\
 					    char *desc)			\
 	{								\
-		return clk_register_gen_params(#name, prev, desc);	\
+		return clk_register_gen_params(#name, prev, desc,	\
+					       false);			\
 	}
 
 #define CLK_REGISTER_KUNIT_CASE_PARAM(name)				\
@@ -3475,6 +3527,8 @@ static struct kunit_case clk_unregister_consumer_clk_test_cases[] = {
 	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_set_parent_fails),
 	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_get_parent_skips),
 	CLK_REGISTER_KUNIT_CASE_PARAM(clk_unregister_consumer_clk_put),
+	KUNIT_CASE_PARAM(clk_unregister_parent_consumer_clk_put, clk_unregister_parent_consumer_clk_gen_params),
+	KUNIT_CASE_PARAM(clk_unregister_parent_consumer_clk_set_parent, clk_unregister_parent_consumer_clk_gen_params),
 	{}
 };
 
-- 
https://git.kernel.org/pub/scm/linux/kernel/git/clk/linux.git/
https://git.kernel.org/pub/scm/linux/kernel/git/sboyd/spmi.git

