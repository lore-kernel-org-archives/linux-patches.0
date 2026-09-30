Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B56A64F7CBF;
	Wed, 30 Sep 2026 17:08:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1790788085; cv=none; b=Hsu+d/OZMavPwa2Xm6teRtc68illhAuwV9JrYgFlODtJhoW3+JhLeAXoIb8OIl3CVWm/Gnxd9Uf0v0cSioyljvwH8IojM3blvXUyYoYficLoU8xTCRTM5INYNfHaEDlTcxHsDHoOfG0cIcCg/xcS2G+3LLxmc2StfdQRs1//iVA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1790788085; c=relaxed/simple;
	bh=5WfhkFZKnUyZn424PqKPj0knwQc3r8iWNiyxmzQ7A+w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=h0WjLX7qVEQPhXstKVJgmvO53HkEUtztKzsL5fO+yyGrFVoiX9eGlLNqSK3KAVluk6F27FokFRlZ+wNJEPRhjJW8/d4x1S7KU2ontowyHc6RcKVjbcLMLCp31ni5Pwl3zQq0BkglOVGnec1ntCxK1DoP8lnaQgaZDHyQfCD2qAY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=AQOJ55Lp; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="AQOJ55Lp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1CC721F000FF;
	Wed, 30 Sep 2026 17:08:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1790788083;
	bh=Pp8adC71uzZsSRBBp7g+0YbiEORNjNhGJiBBdBif+W0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=AQOJ55Lp1SpqDGVoiMwZucRaD8y4WiQQeY0lsB36C9yAhZZh44clBRHP5sEF1M5eA
	 6NAdwFy/xU/oMCxHs0gFGehcRxZZozr5GMqc/gCQ8CoA+x4TGtO4cb0P/jzOdgHu6i
	 rcOnOUZS8LZckpjIsASj3jHL1H1KlB2HE99By6gU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leo Li <sunpeng.li@amd.com>,
	Alex Hung <alex.hung@amd.com>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 445/457] drm/amd/display: Relax DML frame limit with UBSAN
Date: Wed, 30 Sep 2026 17:29:10 +0200
Message-ID: <20260930152355.606460767@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260930152346.024115587@linuxfoundation.org>
References: <20260930152346.024115587@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alex Hung <alex.hung@amd.com>

[ Upstream commit 0fd5e9ddf362b1253b3c94b858371f90400e5c4a ]

[WHY]
UBSAN instrumentation adds checks and handler calls and increases
stack usage in the large DML calculation functions, similar to
KASAN and KCSAN. With UBSAN enabled these files exceed the default
-Wframe-larger-than limit and fail to build when -Werror is in effect.

Reproduced with LLVM (make LLVM=1, clang 19.1.1), CONFIG_UBSAN=y,
CONFIG_GCOV_PROFILE_ALL=y and CONFIG_DRM_AMDGPU_WERROR=y on x86_64.

[HOW]
Include CONFIG_UBSAN in the sanitizer check that selects the
higher per-file frame warning limit in the dml and dml2_0
Makefiles.

Suggested-by: Leo Li <sunpeng.li@amd.com>
Assisted-by: Copilot:Claude-Opus-5.5
Signed-off-by: Alex Hung <alex.hung@amd.com>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
(cherry picked from commit ebf8b0fd8508b744f85a8eee82b745b1d3502dd0)
Cc: stable@vger.kernel.org
[ Changed sanitizer checks to test for a nonempty filter result over space-separated configuration values. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile    |    2 +-
 drivers/gpu/drm/amd/display/dc/dml2_0/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dml/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml/Makefile
@@ -29,7 +29,7 @@ dml_ccflags := $(CC_FLAGS_FPU)
 dml_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-    ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+    ifneq ($(filter y,$(CONFIG_KASAN) $(CONFIG_KCSAN) $(CONFIG_UBSAN)),)
         ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
             frame_warn_limit := 4096
         else
--- a/drivers/gpu/drm/amd/display/dc/dml2_0/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2_0/Makefile
@@ -28,7 +28,7 @@ dml2_ccflags := $(CC_FLAGS_FPU)
 dml2_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-    ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+    ifneq ($(filter y,$(CONFIG_KASAN) $(CONFIG_KCSAN) $(CONFIG_UBSAN)),)
         ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
             frame_warn_limit := 4096
         else


