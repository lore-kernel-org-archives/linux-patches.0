Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 389722571A0;
	Thu, 17 Apr 2025 18:39:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744915176; cv=none; b=dMTb+/m63L4wZzEdSVfIgC0BTIWbKnltQEjK8jju4sAUygOAutEyuZA6Kkwh6K7PHopzeuWsSeB0TL1QcPcXKnDGwLgReXCoWfmYrgYZMGFj9D0C4AFxuJ/PLiF3i78f8bbtogJPu5tR1FIHbXCl9qtSmvIKgeriP0eeM/i3pAY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744915176; c=relaxed/simple;
	bh=Q7Rn/f3B5u/OUPoZtrsp2hUkRSspln/Bas8gF9nyRtE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QMkjNLvLfMGoz7uSwMuUH5UszI1W1zERjShxp+05ySMP1Prx+TdL9T2OOlBYJF5eHHUC1abeRchqUFlm1tqoR6SjqoO0+9WtYd+htGTKFIYCo4Kvfz0TmiXzg7J3cmxSv3Byu7RUWxC7Mx6uBhT90hk/r6MrjdPmOtF+x+ciSVk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KIu1T/jp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KIu1T/jp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 56E41C4CEF0;
	Thu, 17 Apr 2025 18:39:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744915175;
	bh=Q7Rn/f3B5u/OUPoZtrsp2hUkRSspln/Bas8gF9nyRtE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KIu1T/jpfXOZrcJwB1aB7ErdW1yBc9twrwSnyHj9J94PuKdBp2uX9b52722Byk/CX
	 jIkQNYG6RGaYoiDaIatZl8pOKthi+qKlGTt5BR/J7WViR4U9wllpEm+Mellq0CRUkH
	 Tr4OWzE7mGseL3yaVqzmcYiPEcLLy5B7HBsbzbOE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/393] drm/tests: cmdline: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:47:14 +0200
Message-ID: <20250417175108.602682401@linuxfoundation.org>
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

[ Upstream commit 70f29ca3117a8796cd6bde7612a3ded96d0f2dde ]

drm_analog_tv_mode() and its variants return a drm_display_mode that
needs to be destroyed later one. The drm_test_cmdline_tv_options() test
never does however, which leads to a memory leak.

Let's make sure it's freed.

Reported-by: Philipp Stanner <phasta@mailbox.org>
Closes: https://lore.kernel.org/dri-devel/a7655158a6367ac46194d57f4b7433ef0772a73e.camel@mailbox.org/
Fixes: e691c9992ae1 ("drm/modes: Introduce the tv_mode property as a command-line option")
Reviewed-by: Thomas Zimmermann <tzimmermann@suse.de>
Link: https://lore.kernel.org/r/20250408-drm-kunit-drm-display-mode-memleak-v1-4-996305a2e75a@kernel.org
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_cmdline_parser_test.c | 10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/tests/drm_cmdline_parser_test.c b/drivers/gpu/drm/tests/drm_cmdline_parser_test.c
index 59c8408c453c2..1cfcb597b088b 100644
--- a/drivers/gpu/drm/tests/drm_cmdline_parser_test.c
+++ b/drivers/gpu/drm/tests/drm_cmdline_parser_test.c
@@ -7,6 +7,7 @@
 #include <kunit/test.h>
 
 #include <drm/drm_connector.h>
+#include <drm/drm_kunit_helpers.h>
 #include <drm/drm_modes.h>
 
 static const struct drm_connector no_connector = {};
@@ -955,8 +956,15 @@ struct drm_cmdline_tv_option_test {
 static void drm_test_cmdline_tv_options(struct kunit *test)
 {
 	const struct drm_cmdline_tv_option_test *params = test->param_value;
-	const struct drm_display_mode *expected_mode = params->mode_fn(NULL);
+	struct drm_display_mode *expected_mode;
 	struct drm_cmdline_mode mode = { };
+	int ret;
+
+	expected_mode = params->mode_fn(NULL);
+	KUNIT_ASSERT_NOT_NULL(test, expected_mode);
+
+	ret = drm_kunit_add_mode_destroy_action(test, expected_mode);
+	KUNIT_ASSERT_EQ(test, ret, 0);
 
 	KUNIT_EXPECT_TRUE(test, drm_mode_parse_command_line_for_connector(params->cmdline,
 									  &no_connector, &mode));
-- 
2.39.5



