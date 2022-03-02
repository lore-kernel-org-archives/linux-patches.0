Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C8B2D7E;
	Thu,  3 Mar 2022 00:00:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF1CAC004E1;
	Thu,  3 Mar 2022 00:00:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1646265631;
	bh=emP5V4PCefI6SM2R2A5r+FMHKurilNfJXOVZ4AGNCBY=;
	h=From:To:Cc:Subject:Date:From;
	b=u+rsMyJm2kOP8hQkHqMkhYF36BTAI7Cnq+wcPj03GzVbHoHAcXIHO6d/67QOopLjW
	 jgwBJJuLdFv/YOXCgqI4hEUiAjVLfDzSjEZnLoMJzz0pPa1/tao/6AUPTyO6Keib/3
	 EDiDg8xiZXYoQiWDFMAQP8yAf0UFn3FlvUl0w9O6bq5PX55X2X7S5MfrejUjF7FTVl
	 vhK0RmLLidwIk++DSUR1lbUh6U6939vxdC6i/OOBlOsG0ZmdlILBKyRCr7wbqWc4oo
	 YVGqiZBhCh6ZLwhmkPBEv632Q5CPoqs7G+LJwDgolelFr7jS9DKyQ0TNRhfVnrBsOO
	 kOhuOANVy637g==
From: Nathan Chancellor <nathan@kernel.org>
To: David Airlie <airlied@linux.ie>,
	Daniel Vetter <daniel@ffwll.ch>
Cc: Nick Desaulniers <ndesaulniers@google.com>,
	Claudio Suarez <cssk@net-c.es>,
	dri-devel@lists.freedesktop.org,
	llvm@lists.linux.dev,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	kernel test robot <lkp@intel.com>
Subject: [PATCH] drm/selftest: plane_helper: Put test structures in static storage
Date: Wed,  2 Mar 2022 16:59:09 -0700
Message-Id: <20220302235909.784935-1-nathan@kernel.org>
X-Mailer: git-send-email 2.35.1
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

Clang warns on certain 32-bit architectures:

  drivers/gpu/drm/selftests/test-drm_plane_helper.c:76:5: warning: stack frame size (1064) exceeds limit (1024) in 'igt_check_plane_state' [-Wframe-larger-than]
  int igt_check_plane_state(void *ignored)
      ^
  1 warning generated.

The structures in igt_check_plane_state() total 1008 bytes, so any small
amount of inlining will cause the stack frame to exceed the 32-bit limit
of 1024, triggering the warning.

Move these structures to static storage, which dramatically reduces the
amount of stack space in igt_check_plane_state(). There is no testing
impact, as igt_check_plane_state() is only called once in the driver.

Fixes: 943e6a8beeac ("mock a drm_plane in igt_check_plane_state to make the test more robust")
Link: https://github.com/ClangBuiltLinux/linux/issues/1600
Reported-by: kernel test robot <lkp@intel.com>
Suggested-by: Nick Desaulniers <ndesaulniers@google.com>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
 drivers/gpu/drm/selftests/test-drm_plane_helper.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/gpu/drm/selftests/test-drm_plane_helper.c b/drivers/gpu/drm/selftests/test-drm_plane_helper.c
index ceebeede55ea..b61273e9c403 100644
--- a/drivers/gpu/drm/selftests/test-drm_plane_helper.c
+++ b/drivers/gpu/drm/selftests/test-drm_plane_helper.c
@@ -77,7 +77,7 @@ int igt_check_plane_state(void *ignored)
 {
 	int ret;
 
-	const struct drm_crtc_state crtc_state = {
+	static const struct drm_crtc_state crtc_state = {
 		.crtc = ZERO_SIZE_PTR,
 		.enable = true,
 		.active = true,
@@ -87,14 +87,14 @@ int igt_check_plane_state(void *ignored)
 				DRM_MODE_FLAG_NHSYNC | DRM_MODE_FLAG_NVSYNC)
 		},
 	};
-	struct drm_plane plane = {
+	static struct drm_plane plane = {
 		.dev = NULL
 	};
-	struct drm_framebuffer fb = {
+	static struct drm_framebuffer fb = {
 		.width = 2048,
 		.height = 2048
 	};
-	struct drm_plane_state plane_state = {
+	static struct drm_plane_state plane_state = {
 		.plane = &plane,
 		.crtc = ZERO_SIZE_PTR,
 		.fb = &fb,

base-commit: 9ae2ac4d31a85ce59cc560d514a31b95f4ace154
-- 
2.35.1

