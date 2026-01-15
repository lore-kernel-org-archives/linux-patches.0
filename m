Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BAA5B3BF2E0;
	Thu, 15 Jan 2026 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496546; cv=none; b=ZAdR4kKcz//bZi3jhwKDIO0OfWCA+3wh6e6NhSYofMg4HsMvKkxzkWIxmdZZxfa/kgmxkNmyQzBgVEhYvpwoV7C61LmD5zaSWxc7Nh7Z4tWeaLhJKVJqYr/pWHSjeYueLp8a43UnbSOQVbfsNI+mZypfYZfGtxh4/HWCcJZH35M=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496546; c=relaxed/simple;
	bh=+Y+z22X5ElG47kW4UdEUOKN/Z/OuR5y8n3yUd5hb65s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UP/NJ9F6OtuE/fQKKYmOFIMRkypKibbgobwyloX9EbPXljj9CrN3FM4ZkOpFHM84SagCFfPOb6DvIRS0wL4NsSUdR29lmozaLM5r7IePYksM2hs5HtqhKYp4kdznPwN3Rg/vtvVVKZ3PoJLRItx92lNt5+qN/fOu5rCfLibt4pM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T7fPSqaN; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T7fPSqaN"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 49726C116D0;
	Thu, 15 Jan 2026 17:02:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496546;
	bh=+Y+z22X5ElG47kW4UdEUOKN/Z/OuR5y8n3yUd5hb65s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T7fPSqaNFm1ZBncrzlosT+0Qf1LVY4eS6hIwf0nsKSy2CmDaA18Z08ta1k+XH3WLv
	 0wdW9DpWCXz6p9qJ4/KA5eTwcWO1RCKOPZpI9jDorXzUtnVNWD9wPn386X8k4OZ9ks
	 Vc/UIBag5FhmapO4vuZ5QQNcX7l0ZischdBzu7T0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 050/119] drm/amd/display: Apply e4479aecf658 to dml
Date: Thu, 15 Jan 2026 17:47:45 +0100
Message-ID: <20260115164153.765632853@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164151.948839306@linuxfoundation.org>
References: <20260115164151.948839306@linuxfoundation.org>
User-Agent: quilt/0.69
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

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit 70740454377f1ba3ff32f5df4acd965db99d055b ]

After an innocuous optimization change in clang-22, allmodconfig (which
enables CONFIG_KASAN and CONFIG_WERROR) breaks with:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.c:1724:6: error: stack frame size (3144) exceeds limit (3072) in 'dml32_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
   1724 | void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
        |      ^

With clang-21, this function was already pretty close to the existing
limit of 3072 bytes.

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml/dcn32/display_mode_vba_32.c:1724:6: error: stack frame size (2904) exceeds limit (2048) in 'dml32_ModeSupportAndSystemConfigurationFull' [-Werror,-Wframe-larger-than]
   1724 | void dml32_ModeSupportAndSystemConfigurationFull(struct display_mode_lib *mode_lib)
        |      ^

A similar situation occurred in dml2, which was resolved by
commit e4479aecf658 ("drm/amd/display: Increase sanitizer frame larger
than limit when compile testing with clang") by increasing the limit for
clang when compile testing with certain sanitizer enabled, so that
allmodconfig (an easy testing target) continues to work.

Apply that same change to the dml folder to clear up the warning for
allmodconfig, unbreaking the build.

Closes: https://github.com/ClangBuiltLinux/linux/issues/2135
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit 25314b453cf812150e9951a32007a32bba85707e)
Cc: stable@vger.kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index e1d500633dfad..54a2af210b4c0 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -30,7 +30,11 @@ dml_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
     ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
-        frame_warn_limit := 3072
+        ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
+            frame_warn_limit := 4096
+        else
+            frame_warn_limit := 3072
+        endif
     else
         frame_warn_limit := 2048
     endif
-- 
2.51.0



