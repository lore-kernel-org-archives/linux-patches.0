Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D780C2F2346;
	Tue, 17 Jun 2025 15:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750175511; cv=none; b=GEgO5+j5RSzuFFq/m2Hz36UO6Ep1EFpKzQLr2fJ0tWCli37QAaOPvvB5k/xWUb7ykDvBupKd9h3Ii9qMmULb98ug6dW7M5jX3W6PPknFAkG96n8jz6VXVlv52YvhTAPHvakzeFaCCE7RZodjYq52fYLOIuw8QeozPTYAzM0r7VQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750175511; c=relaxed/simple;
	bh=OIXFBKsvK3sMPgEd0s6annLlqWojUXaErnNZLfTnrDk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=OdwhIq2rWkphNlMV1opVagJukdNxxTB4Z1kZF6HGm5S546rEfuA2wW2FW1zx6XorYfr+4pr2Lfytp6nPMPAuxUlzSRf8FFxv5LxL9KYrgvd6a2rNx5ue0YLLuahlmFz1vs1o2GN7V7IaujWsu5zcuCK5SbOeGJxj/m1WO2kBVu0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jGGPTI7c; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jGGPTI7c"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 62BC5C4CEE3;
	Tue, 17 Jun 2025 15:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750175511;
	bh=OIXFBKsvK3sMPgEd0s6annLlqWojUXaErnNZLfTnrDk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jGGPTI7c5c5UIt/oVGzOEeYqLw7AelwOsPJZUEe0hXHKvJkj6wrxA38ZmPK1lQlkp
	 HRa2h8emp0GgUaInrSaMZXXR4dLf9Dm/Cfyd9I8meKZ6/4v0DV83ZjVnXW9PhZUuJ1
	 W6wnqRYPtRwPTNZBpzGyebupSICh795ykht5T31E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	=?UTF-8?q?Ma=C3=ADra=20Canal?= <mcanal@igalia.com>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.15 095/780] drm/vc4: tests: Use return instead of assert
Date: Tue, 17 Jun 2025 17:16:43 +0200
Message-ID: <20250617152455.382553080@linuxfoundation.org>
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

[ Upstream commit 9e26a3740cc08ef8bcdc5e5d824792cd677affce ]

The vc4_mock_atomic_add_output() and vc4_mock_atomic_del_output() assert
that the functions they are calling didn't fail. Since some of them can
return EDEADLK, we can't properly deal with it.

Since both functions are expected to return an int, and all caller check
the return value, let's just properly propagate the errors when they
occur.

Fixes: f759f5b53f1c ("drm/vc4: tests: Introduce a mocking infrastructure")
Fixes: 76ec18dc5afa ("drm/vc4: tests: Add unit test suite for the PV muxing")
Reviewed-by: Maíra Canal <mcanal@igalia.com>
Link: https://lore.kernel.org/r/20250403-drm-vc4-kunit-failures-v2-1-e09195cc8840@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/vc4/tests/vc4_mock_output.c | 36 ++++++++++++++-------
 1 file changed, 24 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/vc4/tests/vc4_mock_output.c b/drivers/gpu/drm/vc4/tests/vc4_mock_output.c
index e70d7c3076acf..f0ddc223c1f83 100644
--- a/drivers/gpu/drm/vc4/tests/vc4_mock_output.c
+++ b/drivers/gpu/drm/vc4/tests/vc4_mock_output.c
@@ -75,24 +75,30 @@ int vc4_mock_atomic_add_output(struct kunit *test,
 	int ret;
 
 	encoder = vc4_find_encoder_by_type(drm, type);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, encoder);
+	if (!encoder)
+		return -ENODEV;
 
 	crtc = vc4_find_crtc_for_encoder(test, drm, encoder);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc);
+	if (!crtc)
+		return -ENODEV;
 
 	output = encoder_to_vc4_dummy_output(encoder);
 	conn = &output->connector;
 	conn_state = drm_atomic_get_connector_state(state, conn);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conn_state);
+	if (IS_ERR(conn_state))
+		return PTR_ERR(conn_state);
 
 	ret = drm_atomic_set_crtc_for_connector(conn_state, crtc);
-	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return ret;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc_state);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
 
 	ret = drm_atomic_set_mode_for_crtc(crtc_state, &default_mode);
-	KUNIT_EXPECT_EQ(test, ret, 0);
+	if (ret)
+		return ret;
 
 	crtc_state->active = true;
 
@@ -113,26 +119,32 @@ int vc4_mock_atomic_del_output(struct kunit *test,
 	int ret;
 
 	encoder = vc4_find_encoder_by_type(drm, type);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, encoder);
+	if (!encoder)
+		return -ENODEV;
 
 	crtc = vc4_find_crtc_for_encoder(test, drm, encoder);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc);
+	if (!crtc)
+		return -ENODEV;
 
 	crtc_state = drm_atomic_get_crtc_state(state, crtc);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, crtc_state);
+	if (IS_ERR(crtc_state))
+		return PTR_ERR(crtc_state);
 
 	crtc_state->active = false;
 
 	ret = drm_atomic_set_mode_for_crtc(crtc_state, NULL);
-	KUNIT_ASSERT_EQ(test, ret, 0);
+	if (ret)
+		return ret;
 
 	output = encoder_to_vc4_dummy_output(encoder);
 	conn = &output->connector;
 	conn_state = drm_atomic_get_connector_state(state, conn);
-	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, conn_state);
+	if (IS_ERR(conn_state))
+		return PTR_ERR(conn_state);
 
 	ret = drm_atomic_set_crtc_for_connector(conn_state, NULL);
-	KUNIT_ASSERT_EQ(test, ret, 0);
+	if (ret)
+		return ret;
 
 	return 0;
 }
-- 
2.39.5



