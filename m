Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F40333032A;
	Mon, 29 Dec 2025 16:18:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767025132; cv=none; b=nF7HXcVtrF9ToE7KiLTXILY1/GqAPvH0nVnzWl109A68mfXR58jFg8qokBCgOg6nokhmTtLXvwmySH8UI6OCAWsflm9mNqRNDewlvbEBhD2J2i4qpu33Y7uDMFBcj+rHUD0QTrcs+Btq1+2OaL5ouVMr9VEZnTbPPT9D9ebYTU8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767025132; c=relaxed/simple;
	bh=EQpE6NlL5nJ9Jdn0L4NnOV8WAjcZJ4oLSOAO0oOg5Kg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=Z2Ivw7qru5QXq7LWS+m/wagiJW3xgq6mxbj+w/81X6AjcvVa++acyXbMh4Bap/ssUCLG1HTqKpMBfs0KeeRs8Xa/VvvC7AELDyqDrgD3f2gyR9jz5Zvk/l7xJt1GzGRnGSvixQ9XDMvL1AznyZKRLNgVquJLwJHIrwMQ04TsbZQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=kX/KrOmj; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="kX/KrOmj"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2480C4CEF7;
	Mon, 29 Dec 2025 16:18:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767025132;
	bh=EQpE6NlL5nJ9Jdn0L4NnOV8WAjcZJ4oLSOAO0oOg5Kg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kX/KrOmjMYW0JKiGzPkIpzWHwsQyheCvdva7ezLXnVvDBx6qmnYj/BG8jOH/gKM3W
	 BpJcJrc1y2yQWkM8QvtITPDBXnBCPu54xKJyxh6N56NQLOKhBfVUa8scU3tjVrvC+q
	 9rB1bfu9HhIiEE378x9XB6lyTa76jFR31LVEP3e8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	=?UTF-8?q?Jos=C3=A9=20Exp=C3=B3sito?= <jose.exposito89@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 106/430] drm/tests: Handle EDEADLK in drm_test_check_valid_clones()
Date: Mon, 29 Dec 2025 17:08:28 +0100
Message-ID: <20251229160728.270157101@linuxfoundation.org>
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

[ Upstream commit 141d95e42884628314f5ad9394657b0b35424300 ]

Fedora/CentOS/RHEL CI is reporting intermittent failures while running
the drm_test_check_valid_clones() KUnit test.

The error log can be either [1]:

    # drm_test_check_valid_clones: ASSERTION FAILED at
    # drivers/gpu/drm/tests/drm_atomic_state_test.c:295
    Expected ret == param->expected_result, but
        ret == -35 (0xffffffffffffffdd)
        param->expected_result == 0 (0x0)

Or [2] depending on the test case:

    # drm_test_check_valid_clones: ASSERTION FAILED at
    # drivers/gpu/drm/tests/drm_atomic_state_test.c:295
    Expected ret == param->expected_result, but
        ret == -35 (0xffffffffffffffdd)
        param->expected_result == -22 (0xffffffffffffffea)

Restart the atomic sequence when EDEADLK is returned.

[1] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2113057246/test_x86_64/11802139999/artifacts/jobwatch/logs/recipes/19824965/tasks/204347800/results/946112713/logs/dmesg.log
[2] https://s3.amazonaws.com/arr-cki-prod-trusted-artifacts/trusted-artifacts/2106744297/test_aarch64/11762450907/artifacts/jobwatch/logs/recipes/19797942/tasks/204139727/results/945094561/logs/dmesg.log

Fixes: 88849f24e2ab ("drm/tests: Add test for drm_atomic_helper_check_modeset()")
Closes: https://datawarehouse.cki-project.org/issue/4004
Reviewed-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: José Expósito <jose.exposito89@gmail.com>
Link: https://patch.msgid.link/20251104102535.12212-1-jose.exposito89@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_atomic_state_test.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_atomic_state_test.c b/drivers/gpu/drm/tests/drm_atomic_state_test.c
index 2f6ac7a09f44..1e857d86574c 100644
--- a/drivers/gpu/drm/tests/drm_atomic_state_test.c
+++ b/drivers/gpu/drm/tests/drm_atomic_state_test.c
@@ -283,7 +283,14 @@ static void drm_test_check_valid_clones(struct kunit *test)
 	state = drm_kunit_helper_atomic_state_alloc(test, drm, &ctx);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, state);
 
+retry:
 	crtc_state = drm_atomic_get_crtc_state(state, priv->crtc);
+	if (PTR_ERR(crtc_state) == -EDEADLK) {
+		drm_atomic_state_clear(state);
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry;
+	}
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc_state);
 
 	crtc_state->encoder_mask = param->encoder_mask;
@@ -292,6 +299,12 @@ static void drm_test_check_valid_clones(struct kunit *test)
 	crtc_state->mode_changed = true;
 
 	ret = drm_atomic_helper_check_modeset(drm, state);
+	if (ret == -EDEADLK) {
+		drm_atomic_state_clear(state);
+		ret = drm_modeset_backoff(&ctx);
+		if (!ret)
+			goto retry;
+	}
 	KUNIT_ASSERT_EQ(test, ret, param->expected_result);
 
 	drm_modeset_drop_locks(&ctx);
-- 
2.51.0



