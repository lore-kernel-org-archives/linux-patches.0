Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 72B361DF969;
	Wed,  6 Nov 2024 12:33:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1730896408; cv=none; b=qkfvQsz2wf+nawiKyBylukJxcH4zKHtBCkqVaUtwKkqEASAAWnDmdjeugVU+M316Ud7pp4Ql0Y/cMkbbNO5x6VAkGhsK26DglkOP7G1WgnSQF2tbgtlJn+0bfro3WPf+eCjeYQI6OzpJPrc9tHHf2aYteJ2BqYILpYahml7efSA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1730896408; c=relaxed/simple;
	bh=xkb0kep0iYfqxgbaEd+xQC1kvUtt/3YyRrpyxIXhshc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VA2DjOc77x1/ijR04kPvnQWPyBtgFomoEicsl6HeEgCZBUGd8wUJ7YtUuaA9JCmduPRGCIaj3BpW9MIiQXhf0Rt+EyebgsbFkPY8M7kF9qqqt+H+jhVM/orqHUMtV54G02QD3/C227hFl9ALS+Pg2zf+XrmcjgPNIFiq/j1IvM0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2QWcUy29; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QWcUy29"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC08FC4CECD;
	Wed,  6 Nov 2024 12:33:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1730896408;
	bh=xkb0kep0iYfqxgbaEd+xQC1kvUtt/3YyRrpyxIXhshc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QWcUy29u+OgUIE2logzpm7mCAVV1Awof+faG9VDdGrGE1o/P6DiGZtLtS73bL/Ze
	 EB/pTXNK0MATmZWtNw0eacT/S+RXxRsl9ptpCfPPrF4B5xmmPPh43eCKTVwQci4u1l
	 RMcDcN6kCovxvehXO2GPdsr+zb5C/57N1ZzYtWFM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maxime Ripard <mripard@kernel.org>,
	Jinjie Ruan <ruanjinjie@huawei.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.11 191/245] drm/connector: hdmi: Fix memory leak in drm_display_mode_from_cea_vic()
Date: Wed,  6 Nov 2024 13:04:04 +0100
Message-ID: <20241106120323.946308311@linuxfoundation.org>
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

[ Upstream commit 926163342a2e7595d950e84c17c693b1272bd491 ]

modprobe drm_connector_test and then rmmod drm_connector_test,
the following memory leak occurs.

The `mode` allocated in drm_mode_duplicate() called by
drm_display_mode_from_cea_vic() is not freed, which cause the memory leak:

	unreferenced object 0xffffff80cb0ee400 (size 128):
	  comm "kunit_try_catch", pid 1948, jiffies 4294950339
	  hex dump (first 32 bytes):
	    14 44 02 00 80 07 d8 07 04 08 98 08 00 00 38 04  .D............8.
	    3c 04 41 04 65 04 00 00 05 00 00 00 00 00 00 00  <.A.e...........
	  backtrace (crc 90e9585c):
	    [<00000000ec42e3d7>] kmemleak_alloc+0x34/0x40
	    [<00000000d0ef055a>] __kmalloc_cache_noprof+0x26c/0x2f4
	    [<00000000c2062161>] drm_mode_duplicate+0x44/0x19c
	    [<00000000f96c74aa>] drm_display_mode_from_cea_vic+0x88/0x98
	    [<00000000d8f2c8b4>] 0xffffffdc982a4868
	    [<000000005d164dbc>] kunit_try_run_case+0x13c/0x3ac
	    [<000000006fb23398>] kunit_generic_run_threadfn_adapter+0x80/0xec
	    [<000000006ea56ca0>] kthread+0x2e8/0x374
	    [<000000000676063f>] ret_from_fork+0x10/0x20
	......

Free `mode` by using drm_kunit_display_mode_from_cea_vic()
to fix it.

Cc: stable@vger.kernel.org
Fixes: abb6f74973e2 ("drm/tests: Add HDMI TDMS character rate tests")
Acked-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Jinjie Ruan <ruanjinjie@huawei.com>
Link: https://patchwork.freedesktop.org/patch/msgid/20241030023504.530425-3-ruanjinjie@huawei.com
Signed-off-by: Maxime Ripard <mripard@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/tests/drm_connector_test.c | 24 +++++++++++-----------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/gpu/drm/tests/drm_connector_test.c b/drivers/gpu/drm/tests/drm_connector_test.c
index 15e36a8db6858..6bba97d0be88e 100644
--- a/drivers/gpu/drm/tests/drm_connector_test.c
+++ b/drivers/gpu/drm/tests/drm_connector_test.c
@@ -996,7 +996,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb(struct kunit *test)
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1017,7 +1017,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb_10bpc(struct kunit *test)
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1038,7 +1038,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb_10bpc_vic_1(struct kunit *t
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	rate = drm_hdmi_compute_mode_clock(mode, 10, HDMI_COLORSPACE_RGB);
@@ -1056,7 +1056,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb_12bpc(struct kunit *test)
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1077,7 +1077,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb_12bpc_vic_1(struct kunit *t
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 1);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 1);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	rate = drm_hdmi_compute_mode_clock(mode, 12, HDMI_COLORSPACE_RGB);
@@ -1095,7 +1095,7 @@ static void drm_test_drm_hdmi_compute_mode_clock_rgb_double(struct kunit *test)
 	unsigned long long rate;
 	struct drm_device *drm = &priv->drm;
 
-	mode = drm_display_mode_from_cea_vic(drm, 6);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 6);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_TRUE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1118,7 +1118,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv420_valid(struct kunit
 	unsigned long long rate;
 	unsigned int vic = *(unsigned int *)test->param_value;
 
-	mode = drm_display_mode_from_cea_vic(drm, vic);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, vic);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1155,7 +1155,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv420_10_bpc(struct kuni
 		drm_hdmi_compute_mode_clock_yuv420_vic_valid_tests[0];
 	unsigned long long rate;
 
-	mode = drm_display_mode_from_cea_vic(drm, vic);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, vic);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1180,7 +1180,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv420_12_bpc(struct kuni
 		drm_hdmi_compute_mode_clock_yuv420_vic_valid_tests[0];
 	unsigned long long rate;
 
-	mode = drm_display_mode_from_cea_vic(drm, vic);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, vic);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1203,7 +1203,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv422_8_bpc(struct kunit
 	struct drm_device *drm = &priv->drm;
 	unsigned long long rate;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1225,7 +1225,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv422_10_bpc(struct kuni
 	struct drm_device *drm = &priv->drm;
 	unsigned long long rate;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
@@ -1247,7 +1247,7 @@ static void drm_test_connector_hdmi_compute_mode_clock_yuv422_12_bpc(struct kuni
 	struct drm_device *drm = &priv->drm;
 	unsigned long long rate;
 
-	mode = drm_display_mode_from_cea_vic(drm, 16);
+	mode = drm_kunit_display_mode_from_cea_vic(test, drm, 16);
 	KUNIT_ASSERT_NOT_NULL(test, mode);
 
 	KUNIT_ASSERT_FALSE(test, mode->flags & DRM_MODE_FLAG_DBLCLK);
-- 
2.43.0



