Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5C6A25743B;
	Thu, 17 Apr 2025 17:54:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1744912478; cv=none; b=A+JMnjEcnTvaPJrelMWrVfVW1tSHt4RQtMsevfH5WtzSJ1wwZ1+H4CZxUXcijhWkZ0Pul7vJd8WVOhiZ0/nH5dEJpLJUkKRKf83yv4M83YD2pQgYbweIOCWBJJGU1loEAet3yTedOKyCZAtA7zntF8+pp6qGpLnbDt8gMaXVbms=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1744912478; c=relaxed/simple;
	bh=pyoO6cTdRc5J0nC0aEil/iSPMfFevYC20YG0uRmB9WU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=pCm1lOLWamxVa6otiuSduHBN9SBbpdiy5VJeZZ51U8BQblmZPwTuMUFq8bhekUShsyz9jFdCICbCTCQU6N5a4OUVo1grocGYupxho7gQoxzXelg7zz4IqLqLdKpLiF5tZZIa4Wxbc/EN6waCKAzFmQdtapY2sXTdXiOBC8MlLTA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iellTKCS; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iellTKCS"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6E35C4CEE4;
	Thu, 17 Apr 2025 17:54:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1744912478;
	bh=pyoO6cTdRc5J0nC0aEil/iSPMfFevYC20YG0uRmB9WU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iellTKCSrXURl6UIxj98SgnBxZvzT42IuoFkoqimcn8sPPklyTH9nMGl6UqIwON8D
	 I0duKVLyUFILCvxVeVe++jQOFLWjhQCccCVyJUFcJYLbjO+S0USo0qXSgqcn43wQiN
	 gyINIzRWN29fAM0/TerBPXaoOkwYAc5VfTrXZM6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Philipp Stanner <phasta@mailbox.org>,
	Thomas Zimmermann <tzimmermann@suse.de>,
	Maxime Ripard <mripard@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.14 023/449] drm/tests: modeset: Fix drm_display_mode memory leak
Date: Thu, 17 Apr 2025 19:45:11 +0200
Message-ID: <20250417175118.920309661@linuxfoundation.org>
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



