Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 14AF61DF974;
	Wed,  6 Nov 2024 12:33:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896412; cv=none; b=SXcfeSPaB0JvNtCReYtGE8H7AOQiidiW00FW/GMMrITuAHhS6rJY1hadOZ6ZfvggtBp9LJb2qQSQe/2tdB9e6pqQt9qeD5WSlz27TB6IoPdBZWi45QI2Wrm8mY+YffmOZWolURKzeJxmHSe7jDjgHruxS9hTKEuzDbMo7trWqOs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896412; c=relaxed/simple;
	bh=zyapEtjt+3MRk6BcKnSUfU9Dl3zfB3LoDkG0GzLK2vw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GFoU4KI8LdfoA04uCwijzNoqzVM6N1q7qmu5XhxZ/9IuTmoMG1M4nZV1EYqczFsDXw3C8yv4rge2etkcPTaVEAvgJ8XRHjrOFHC9pQB7An1RCjycVLha697YnHXI1pJeHqH/xXJn33EFy+sI1v7MBiT/mPs5PCoKsc3NAE4zQUg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CQ7P8Hn7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CQ7P8Hn7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 751DFC4CECD;
	Wed,  6 Nov 2024 12:33:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896412;
	bh=zyapEtjt+3MRk6BcKnSUfU9Dl3zfB3LoDkG0GzLK2vw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CQ7P8Hn7xhH080wTB1G9UxGmzi22v8o+BLF/YYmgSP0fclw4zsdtwINVXK1gytgTS
	 SGLvbPJkTbw7aroyVx/IXxE2IwblOCeAnsRFhNXtvdSuo2HVYbPDE9fh7GOUosnq10
	 8uom46BJV36tt5QRExq7p/nrTiBVe+dT6dDVF8LI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 192/245] drm/tests: hdmi: Fix memory leaks in drm_display_mode_from_cea_vic()
Date: Wed,  6 Nov 2024 13:04:05 +0100
Message-ID: <20241106120323.972015771@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241106120319.234238499@linuxfoundation.org>
References: <20241106120319.234238499@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.11-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jinjie Ruan <ruanjinjie@huawei.com>

[ Upstream commit add4163aca0d4a86e9fe4aa513865e4237db8aef ]

modprobe drm_hdmi_state_helper_test and then rmmod it, the following
memory leak occurs.

The `mode` allocated in drm_mode_duplicate() called by
drm_display_mode_from_cea_vic() is not freed, which cause the memory leak:

	unreferenced object 0xffffff80ccd18100 (size 128):
	  comm "kunit_try_catch", pid 1851, jiffies 4295059695
	  hex dump (first 32 bytes):
	    57 62 00 00 80 02 90 02 f0 02 20 03 00 00 e0 01  Wb........ .....
	    ea 01 ec 01 0d 02 00 00 0a 00 00 00 00 00 00 00  ................
	  backtrace (crc c2f1aa95):
	    [<000000000f10b11b>] kmemleak_alloc+0x34/0x40
	    [<000000001cd4cf73>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<00000000f1f3cffa>] drm_mode_duplicate+0x44/0x19c
	    [<000000008cbeef13>] drm_display_mode_from_cea_vic+0x88/0x98
	    [<0000000019daaacf>] 0xffffffedc11ae69c
	    [<000000000aad0f85>] kunit_try_run_case+0x13c/0x3ac
	    [<00000000a9210bac>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<000000000a0b2e9e>] kthread+0x2e8/0x374
	    [<00000000bd668858>] ret_from_fork+0x10/0x20
	......

Free `mode` by using drm_kunit_display_mode_from_cea_vic()
to fix it.

Cc: stable@vger.kernel.org
Fixes: 4af70f19e559 ("drm/tests: Add RGB Quantization tests")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241030023504.530425-4-ruanjinjie@huawei.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
index 34ee95d41f296..294773342e710 100644
--- a/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
+++ b/drivers/gpu/drm/tests/drm_hdmi_state_helper_test.c
@@ -441,7 +441,7 @@ static void drm_test_check_broadcast_rgb_auto_cea_mode_vic_1(struct kunit *test)
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	drm = &priv->drm;
@@ -555,7 +555,7 @@ static void drm_test_check_broadcast_rgb_full_cea_mode_vic_1(struct kunit *test)
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	drm = &priv->drm;
@@ -671,7 +671,7 @@ static void drm_test_check_broadcast_rgb_limited_cea_mode_vic_1(struct kunit *te
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	drm = &priv->drm;
@@ -1263,7 +1263,7 @@ static void drm_test_check_output_bpc_format_vic_1(struct kunit *test)
 	ctx = drm_kunit_helper_acquire_ctx_alloc(test);
 	KUNIT_ASSERT_NOT_ERR_OR_NULL(test, ctx);
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	/*
-- 
2.43.0



