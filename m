Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B652EE5E9;
	Tue, 17 Jun 2025 15:53:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175604; cv=none; b=lfnmGlJdX0oXNrESYmw1dWFbf29xV/tFTdOqwve1SS45ICJH3S+05sI607mI9QhtPuFOf0amU+DUal2pAeed6Z/goeAYwDNO93pQk1ExXGQhD/k1svkLkuHbyZh796JU9eZQJSSyjCiRFNECNvvO53BDCGo2/Eeq3D1v+B+hDs8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175604; c=relaxed/simple;
	bh=YyZx4j02OCJuab5/4gyOa0fsuv/m38iOvBPJINRlHWQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Jq2jUHzEmGCxcDMQ+Ek0OgEYxYNM5IILbJKk2hzqOjanRob0UW8Ev1vr7LMHqfY08nepA7VcRDzIQLMs/cvegO7q7YJrG2O/Hty/UsCgsi8FFRFPjKV0ZHZy2ZL2HBW4vdG2p9xpLXKWLiXVMZ3TNn34j96Ae80ZWmu94rvuhiA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=xtNaeFGT; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="xtNaeFGT"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 86AC0C4CEE3;
	Tue, 17 Jun 2025 15:53:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175604;
	bh=YyZx4j02OCJuab5/4gyOa0fsuv/m38iOvBPJINRlHWQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=xtNaeFGTI9LtaFL0O3pV8H50Y6f4vsiIiEPJchiwZXUmUYomxCU7hoP9wOehv6q3N
	 4qfn2HQMMeP+d7zjqDDlfNi8ErWcXYXNtcUZ3H8sUv/HAb3H1WI4297zRWVnGvznGQ
	 pvacgQAxgZoD8IBTiQjNqNDdt7oS9izrkZB0Vt9s=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 096/780] drm/vc4: tests: Stop allocating the state in test init
Date: Tue, 17 Jun 2025 17:16:44 +0200
Message-ID: <20250617152455.421270678@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152451.485330293@linuxfoundation.org>
References: <20250617152451.485330293@linuxfoundation.org>
User-Agent: quilt/0.68
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit 7e0351ae91ed2b6178abbfae96c3c6aaa1652567 ]

The vc4-pv-muxing-combinations and vc5-pv-muxing-combinations test
suites use a common test init function which, in part, allocates the
drm atomic state the test will use.

That allocation relies on  drm_kunit_helper_atomic_state_alloc(), and
thus requires a struct drm_modeset_acquire_ctx. This context will then
be stored in the allocated state->acquire_ctx field.

However, the context is local to the test init function, and is cleared
as soon as drm_kunit_helper_atomic_state_alloc() is done. We thus end up
with an dangling pointer to a cleared context in state->acquire_ctx for
our test to consumes.

We should really allocate the context and the state in the test
functions, so we can also control when we're done with it.

Fixes: 30188df0c387 ("drm/tests: Drop drm_kunit_helper_acquire_ctx_alloc()")
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250403-drm-vc4-kunit-failures-v2-3-e09195cc8840@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../gpu/drm/vc4/tests/vc4_test_pv_muxing.c    | 41 ++++++++++++-------
 1 file changed, 27 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/vc4/tests/vc4_test_pv_muxing.c b/drivers/gpu/drm/vc4/tests/vc4_test_pv_muxing.c
index 992e8f5c5c6ea..52c04ef33206b 100644
--- a/drivers/gpu/drm/vc4/tests/vc4_test_pv_muxing.c
+++ b/drivers/gpu/drm/vc4/tests/vc4_test_pv_muxing.c
@@ -20,7 +20,6 @@
 
 struct pv_muxing_priv {
 	struct vc4_dev *vc4;
-	struct drm_atomic_state *state;
 };
 
 static bool check_fifo_conflict(struct kunit *test,
@@ -677,10 +676,19 @@ static void drm_vc4_test_pv_muxing(struct kunit *test)
 {
 	const struct pv_muxing_param *params = test->param_value;
 	const struct pv_muxing_priv *priv = test->priv;
-	struct drm_atomic_state *state = priv->state;
+	struct drm_modeset_acquire_ctx ctx;
+	struct drm_atomic_state *state;
+	struct drm_device *drm;
+	struct vc4_dev *vc4;
 	unsigned int i;
 	int ret;
 
+	drm_modeset_acquire_init(&ctx, 0);
+
+	vc4 = priv->vc4;
+	drm = &vc4->base;
+	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, state);
 	for (i = 0; i < params->nencoders; i++) {
 		enum vc4_encoder_type enc_type = params->encoders[i];
 
@@ -700,16 +708,29 @@ static void drm_vc4_test_pv_muxing(struct kunit *test)
 		KUNIT_EXPECT_TRUE(test, check_channel_for_encoder(test, state, enc_type,
 								  params->check_fn));
 	}
+
+	drm_modeset_drop_locks(&ctx);
+	drm_modeset_acquire_fini(&ctx);
 }
 
 static void drm_vc4_test_pv_muxing_invalid(struct kunit *test)
 {
 	const struct pv_muxing_param *params = test->param_value;
 	const struct pv_muxing_priv *priv = test->priv;
-	struct drm_atomic_state *state = priv->state;
+	struct drm_modeset_acquire_ctx ctx;
+	struct drm_atomic_state *state;
+	struct drm_device *drm;
+	struct vc4_dev *vc4;
 	unsigned int i;
 	int ret;
 
+	drm_modeset_acquire_init(&ctx, 0);
+
+	vc4 = priv->vc4;
+	drm = &vc4->base;
+	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
+	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, state);
+
 	for (i = 0; i < params->nencoders; i++) {
 		enum vc4_encoder_type enc_type = params->encoders[i];
 
@@ -719,14 +740,15 @@ static void drm_vc4_test_pv_muxing_invalid(struct kunit *test)
 
 	ret = drm_atomic_check_only(state);
 	KUNIT_EXPECT_LT(test, ret, 0);
+
+	drm_modeset_drop_locks(&ctx);
+	drm_modeset_acquire_fini(&ctx);
 }
 
 static int vc4_pv_muxing_test_init(struct kunit *test)
 {
 	const struct pv_muxing_param *params = test->param_value;
-	struct drm_modeset_acquire_ctx ctx;
 	struct pv_muxing_priv *priv;
-	struct drm_device *drm;
 	struct vc4_dev *vc4;
 
 	priv = kunit_kzalloc(test, sizeof(*priv), GFP_KERNEL);
@@ -737,15 +759,6 @@ static int vc4_pv_muxing_test_init(struct kunit *test)
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, vc4);
 	priv->vc4 = vc4;
 
-	drm_modeset_acquire_init(&ctx, 0);
-
-	drm = &vc4->base;
-	priv->state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, priv->state);
-
-	drm_modeset_drop_locks(&ctx);
-	drm_modeset_acquire_fini(&ctx);
-
 	return 0;
 }
 
-- 
2.39.5



