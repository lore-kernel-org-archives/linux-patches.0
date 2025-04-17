Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C42CB253B57;
	Thu, 17 Apr 2025 18:40:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915237; cv=none; b=QJEuyk0DutsQGQqOC9J8fiyEI2h6emxg8a1Znq8ZiNm562KtTKVCNQTEnuKvdhrmha/hznWovGI/zoWJRxVEr+3Rim2QMXj7qX6DjcA+Uqt4U8MKAxa/94DfdAWIxoM07z7HOPHLh/R6RrlUDReGJgmyKlhK+yj9nbLoKGkxQ7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915237; c=relaxed/simple;
	bh=6gcVLLn75hDHoZEsqKvfhukLoCx0taUxTzcRI3fzmUk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Qc3T6mn8aiKpA9mLkTh0A7E/ahVo0Axa8HKQp3E26cCZnnzmhUbVoXo0BG0kXMExJL0uQvt2yGiQy1Rj6v99ZGlqhrxAPpL+2jA2gV/kiWLjkWQZ7k/UY1okxMOD+Fk8RxebVkxt4xJem4eS9mD8mrFiZ0xqlZ9WllF6ePS4+Eo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AXyLMale; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AXyLMale"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B354C4CEE4;
	Thu, 17 Apr 2025 18:40:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915237;
	bh=6gcVLLn75hDHoZEsqKvfhukLoCx0taUxTzcRI3fzmUk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=AXyLMale01vUYjFbpF6ADwZJtkWrH9WCr+T97e1bhFsrL4tYeVBdm6EGBwO4Ej2q7
	 BY01IbetW6ss9/VUXw0ky6H4r7W1bvCnXJJTpyDk494ks0tTlGthwZponpiSuBtWSs
	 Q1G79MaIYQSfWnC2oWOMzq3vVkJ7blbpE+pL172E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 023/393] drm/tests: modeset: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:47:12 +0200
Message-ID: <20250417175108.523048528@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175107.546547190@linuxfoundation.org>
References: <20250417175107.546547190@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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



