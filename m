Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C27F345758;
	Thu, 15 Jan 2026 17:02:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768496546; cv=none; b=QbxgzhURuCUIMT4ebwI8pbG/mLJyrlh1KhghVYtIC3pDp/K4LLsS2nfLBFDWHTKO8+soLq/6XKkbxbrqoXLU0PeA4mtYtmt8yXyejKyMZwK6vFUITTYr8LMCWsFLbv1zCdPgONS9bKpsQ1LPZIcubXga1FZF3t5K36NKMXPO/7c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768496546; c=relaxed/simple;
	bh=ZkMal0X4EdC/zE1PYvDpssLk7FxTsKzb+1yyj57Hisg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=m82USn3gbxTpOf+Tv4tY9oua4yNmztfcD40lldlSYpQI+7Od1kpIJlCdXUW1eQsymHRXf3A/fdDKbgKRUA5hdINtq9c75JrRLUMYsrbM75SVaVqq+JuUzLW/L3dBemAAUP6R9RGHakyh0kDMW7DAkedhzKUFTDCKFZ3HMyJPR4o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JzBQ6mKG; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JzBQ6mKG"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8465BC116D0;
	Thu, 15 Jan 2026 17:02:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768496543;
	bh=ZkMal0X4EdC/zE1PYvDpssLk7FxTsKzb+1yyj57Hisg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JzBQ6mKGTOVCho+vxSL3R2X30A5skqj/kXKU1CgBa8pnZ4F6TN5i2bMsxSd7iVOZN
	 lLhUOwUQhQaNlQeCFVRYvPgP8drMoelL8ySSvA3vQZ2tcnU+XKCs6AkS+2GbyccLxP
	 wCngDIR0TS4HWHvDA2NoxSW1fAHluoGnZNt8I2t0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Harry Wentland <harry.wentland@amd.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 049/119] drm/amd/display: Respect users CONFIG_FRAME_WARN more for dml files
Date: Thu, 15 Jan 2026 17:47:44 +0100
Message-ID: <20260115164153.729904375@linuxfoundation.org>
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

[ Upstream commit 820ccf8cb2b145ab9fc12651f7f80339614fa46c ]

Currently, there are several files in drm/amd/display that aim to have a
higher -Wframe-larger-than value to avoid instances of that warning with
a lower value from the user's configuration. However, with the way that
it is currently implemented, it does not respect the user's request via
CONFIG_FRAME_WARN for a higher stack frame limit, which can cause pain
when new instances of the warning appear and break the build due to
CONFIG_WERROR.

Adjust the logic to switch from a hard coded -Wframe-larger-than value
to only using the value as a minimum clamp and deferring to the
requested value from CONFIG_FRAME_WARN if it is higher.

Suggested-by: Harry Wentland <harry.wentland@amd.com>
Reported-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Closes: https://lore.kernel.org/2025013003-audience-opposing-7f95@gregkh/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Stable-dep-of: 70740454377f ("drm/amd/display: Apply e4479aecf658 to dml")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile  | 14 ++++++++-----
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 22 ++++++++++++--------
 2 files changed, 22 insertions(+), 14 deletions(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml/Makefile b/drivers/gpu/drm/amd/display/dc/dml/Makefile
index 46f9c05de16e8..e1d500633dfad 100644
--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -29,11 +29,15 @@ dml_ccflags := $(CC_FLAGS_FPU)
 dml_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
-frame_warn_flag := -Wframe-larger-than=3072
-else
-frame_warn_flag := -Wframe-larger-than=2048
-endif
+    ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+        frame_warn_limit := 3072
+    else
+        frame_warn_limit := 2048
+    endif
+
+    ifeq ($(call test-lt, $(CONFIG_FRAME_WARN), $(frame_warn_limit)),y)
+        frame_warn_flag := -Wframe-larger-than=$(frame_warn_limit)
+    endif
 endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml/display_mode_lib.o := $(dml_ccflags)
diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index 986a69c5bd4bc..2a7669a1071e4 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -28,15 +28,19 @@ dml2_ccflags := $(CC_FLAGS_FPU)
 dml2_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
-ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
-frame_warn_flag := -Wframe-larger-than=4096
-else
-frame_warn_flag := -Wframe-larger-than=3072
-endif
-else
-frame_warn_flag := -Wframe-larger-than=2048
-endif
+    ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+        ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
+            frame_warn_limit := 4096
+        else
+            frame_warn_limit := 3072
+        endif
+    else
+        frame_warn_limit := 2048
+    endif
+
+    ifeq ($(call test-lt, $(CONFIG_FRAME_WARN), $(frame_warn_limit)),y)
+        frame_warn_flag := -Wframe-larger-than=$(frame_warn_limit)
+    endif
 endif
 
 subdir-ccflags-y += -I$(FULL_AMD_DISPLAY_PATH)/dc/dml2
-- 
2.51.0



