Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A2E2C1A3178;
	Thu, 17 Apr 2025 18:18:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744913934; cv=none; b=mlQdcBYSyhzOi22LdFvZwIwXyxvgkJHYf1vrBlTrdVh3eGY8Ci/9+Yvb2D2Yj6jePVlD72zgOHn3Cm8tOFl47qLBs8AD8aavS5Ik1+CxY1vX1BhJqJrrV9hoFO8EMum2566lkaZRiwN9wqT2NNsab4BxHhDTwvNLy+gjEGyb45M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744913934; c=relaxed/simple;
	bh=nUK/ju/aDiXcmFXg0FHGz/UhsHGzQeyB87Qf94jZkek=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ZVlruihWwYYQTJ7J7/ZyJDKV6qv7l/acu+IqqXx+ykkK6aLS//TI+weq4jCECA55vQQI5KcF/03A341S5lkxCZ4f4XPTGIzqbzNpHQXXevJZ/XD07DyFud6gX51uS925EYcBr0jMGpKiZWJ/tQ70+sY8qZQiZGiXERNQWHH2caU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FU+P9IkE; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FU+P9IkE"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 234FCC4CEE4;
	Thu, 17 Apr 2025 18:18:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744913934;
	bh=nUK/ju/aDiXcmFXg0FHGz/UhsHGzQeyB87Qf94jZkek=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FU+P9IkE8LC5nTGSJ2/cT103eEHPJ4yUyNYo1PcST+og1C5H9orEjrRilaotSIbCt
	 FjR6fHAVIC2FlpFduVJ5mYSqXOS6zTjgUYedlk3O9/P07SOiYTwBkQBmAHq0vMeLxb
	 63KhnQwnX8ix0IJ/FCQmHoDSqnqR55c4LB2W8BWM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 020/414] drm/tests: modeset: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:46:18 +0200
Message-ID: <20250417175112.214385132@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175111.386381660@linuxfoundation.org>
References: <20250417175111.386381660@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <mripard@kernel.org>

[ Upstream commit dacafdcc7789cfeb0f0552716db56f210238225d ]

drm_mode_find_dmt() returns a drm_display_mode that needs to be
destroyed later one. The drm_test_pick_cmdline_res_1920_1080_60() test
never does however, which leads to a memory leak.

Let's make sure it's freed.

Reported-by: Philipp Stanner <phasta@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/a7655158a6367ac46194d57f4b7433ef0772a73e.camel@mailbox.org/
Fixes: 8fc0380f6ba7 ("drm/client: Add some tests for drm_connector_pick_cmdline_mode()")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250408-drm-kunit-drm-display-mode-memleak-v1-2-996305a2e75a@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_client_modeset_test.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/gpu/drm/tests/drm_client_modeset_test.c b/drivers/gpu/drm/tests/drm_client_modeset_test.c
index 7516f6cb36e4e..3e9518d7b8b7e 100644
--- a/drivers/gpu/drm/tests/drm_client_modeset_test.c
+++ b/drivers/gpu/drm/tests/drm_client_modeset_test.c
@@ -95,6 +95,9 @@ static void drm_test_pick_cmdline_res_1920_1080_60(struct kunit *test)
 	expected_mode = drm_mode_find_dmt(priv->drm, 1920, 1080, 60, false);
 	KUNIT_ASSERT_NOT_NULL(test, expected_mode);
 
+	ret = drm_kunit_add_mode_destroy_action(test, expected_mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
+
 	KUNIT_ASSERT_TRUE(test,
 			  drm_mode_parse_command_line_for_connector(cmdline,
 								    connector,
-- 
2.39.5



