Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A91133066C;
	Mon, 29 Dec 2025 16:18:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025135; cv=none; b=H8fl1iSk6XLRKRqRRPrL0LdtG/jkY+JRQTdqFk1rNJuqecNfVOP98M9MEpzZNwZVs9y+CoN/isvr73bNEM5RqfpQpm/S6xPNn63sRxHPvGLzK2BqvM7/6mwXMnYTGSGPFn55E4X19QfD15CfBk00WahtCm1IehsHpib3oq+Jdl0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025135; c=relaxed/simple;
	bh=4fYF1bepCQIrrJFuuKypvUUxuwuIoCZ3bOIZvDVNZrU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cYFdLHkFOxtmX/rIV66cIVJu/0GINlwvWXp7256XXFSjDIs04DEd87Q1DRbJmJKwDhGYIb3SBsGGpagAvUvad2SQ1vcHU9HxkXnW7UQ9VdlGeihrS0DfHYgCLUovbgUK/lWnTfj8CAtNq49fZGJcewy8CllHKgkx3RpEF4v3Vrg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=gSVT4pQH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="gSVT4pQH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA21C4CEF7;
	Mon, 29 Dec 2025 16:18:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025135;
	bh=4fYF1bepCQIrrJFuuKypvUUxuwuIoCZ3bOIZvDVNZrU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gSVT4pQHGjwXasfRRM/ovvaAUpoF3uiqHKK4T+cIbpUIcELfmpwOWRAzG+0zlKmN0
	 RAIY0R8oD0gTaw6F9uyczQ9wi+oQiP7/3CnxLG3hdG5NtUr2p2xBm4xGqXtuC7JJm5
	 ZUh8OvzKsq/Y2VMvQAdGyW3opVgCFSjypbRfKRu0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 107/430] drm/tests: Handle EDEADLK in set_up_atomic_state()
Date: Mon, 29 Dec 2025 17:08:29 +0100
Message-ID: <20251229160728.306652386@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20251229160724.139406961@linuxfoundation.org>
References: <20251229160724.139406961@linuxfoundation.org>
User-Agent: quilt/0.69
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: José Expósito <jose.exposito89@gmail.com>

[ Upstream commit 526aafabd756cc56401b383d6ae554af3e21dcdd ]

Fedora/CentOS/RHEL CI is reporting intermittent failures while running
the drm_validate_modeset test [1]:

    # drm_test_check_connector_changed_modeset: EXPECTATION FAILED at
    # drivers/gpu/drm/tests/drm_atomic_state_test.c:162
    Expected ret == 0, but
        ret == -35 (0xffffffffffffffdd)

Change the set_up_atomic_state() helper function to return on error and
restart the atomic sequence when the returned error is EDEADLK.

[1] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2106744096/test_x86_64/11762450343/artifacts/jobwatch/logs/recipes/19797909/tasks/204139142/results/945095586/logs/dmesg.log

Fixes: 73d934d7b6e3 ("drm/tests: Add test for drm_atomic_helper_commit_modeset_disables()")
Closes: https://datawarehouse.cki-project.org/issue/4004
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://patch.msgid.link/20251104102535.12212-2-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_atomic_state_test.c | 27 +++++++++++++++----
 1 file changed, 22 insertions(+), 5 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_atomic_state_test.c b/drivers/gpu/drm/tests/drm_atomic_state_test.c
index 1e857d86574c..bc27f65b2823 100644
--- a/drivers/gpu/drm/tests/drm_atomic_state_test.c
+++ b/drivers/gpu/drm/tests/drm_atomic_state_test.c
@@ -156,24 +156,29 @@ static int set_up_atomic_state(struct kunit *test,
 
 	if (connector) {
 		conn_state = drm_atomic_get_connector_state(state, connector);
-		KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conn_state);
+		if (IS_ERR(conn_state))
+			return PTR_ERR(conn_state);
 
 		ret = drm_atomic_set_crtc_for_connector(conn_state, crtc);
-		KUNIT_EXPECT_EQ(test, ret, 0);
+		if (ret)
+			return ret;
 	}
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc_state);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
 
 	ret = drm_atomic_set_mode_for_crtc(crtc_state, &drm_atomic_test_mode);
-	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return ret;
 
 	crtc_state->enable = true;
 	crtc_state->active = true;
 
 	if (connector) {
 		ret = drm_atomic_commit(state);
-		KUNIT_ASSERT_EQ(test, ret, 0);
+		if (ret)
+			return ret;
 	} else {
 		// dummy connector mask
 		crtc_state->connector_mask = DRM_TEST_CONN_0;
@@ -206,7 +211,13 @@ static void drm_test_check_connector_changed_modeset(struct kunit *test)
 	drm_modeset_acquire_init(&ctx, 0);
 
 	// first modeset to enable
+retry_set_up:
 	ret = set_up_atomic_state(test, priv, old_conn, &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_set_up;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
@@ -277,7 +288,13 @@ static void drm_test_check_valid_clones(struct kunit *test)
 
 	drm_modeset_acquire_init(&ctx, 0);
 
+retry_set_up:
 	ret = set_up_atomic_state(test, priv, NULL, &ctx);
+	if (ret == -EDEADLK) {
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry_set_up;
+	}
 	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
-- 
2.51.0



