Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBE52566FF;
	Thu, 17 Apr 2025 17:54:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912484; cv=none; b=F4OQD1NrnFtHHInieWG1Rv0YyGHq2GH8hevmEjRfMkP7ZBc5yri9B/PuPGHQdy8fs30k1ldZjebYOHrWO+PdTEPNhfSBtLzckvIw3LliA7DGqesxhrfCxd674rgYMRQemKgsKbAksfWT82WxOj9onNlq7/DPBdPqoC8ErC0dlxE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912484; c=relaxed/simple;
	bh=1ZvwSIyI4dsMaPMWdhwb0CEB5gqVXm2CkWzhQHFFhnc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=iuyj9ZhKbcJ6rrK08IMBd7DEUm3q+wZ0FxJI3oo+SGuXSSf5k//rrHrXawkoN0CQ2D7iW/DbkfaJS+7tcZvJA5d7zVCUj4ghSS+OCR30LI6Ve7GEPiQmmpx2n76tkNZTEoc+pP2wpQ1acCxUplMbDFZ+pIVAd3aKmdrOOhYvnJQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Bh+js6Qb; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Bh+js6Qb"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BD4D0C4CEE4;
	Thu, 17 Apr 2025 17:54:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912484;
	bh=1ZvwSIyI4dsMaPMWdhwb0CEB5gqVXm2CkWzhQHFFhnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Bh+js6QbItkkvC2DKckDSrZCz1RUxK4qdMRHXlabNVBLQhC1jGASXCNMtR8ArUI3E
	 1te1O7hJzoj+r9G1sIBFtp3Hgk1wfKcgfszDrlpui2T3Cth1OBAbcDc+S9FPKhM53B
	 t75ad+mi0/6R6D51fF2C0JvwvwWqoO3l3j1zG3r0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 025/449] drm/tests: cmdline: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:45:13 +0200
Message-ID: <20250417175119.014118439@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250417175117.964400335@linuxfoundation.org>
References: <20250417175117.964400335@linuxfoundation.org>
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

6.14-stable review patch.  If anyone has any objections, please let me know.

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



