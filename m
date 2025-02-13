Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0A00113B58A;
	Thu, 13 Feb 2025 14:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739458689; cv=none; b=bKykA5T72gBEvvDpMx3L0CUnJ3n4cIq2E6Rj2UEKOZ1RTjYjKRA3P6HBFTsaMtPjiBCizMMAIq6IjO7AVNTN2QRtBq2GRkXjDHhvyq8vayf1TZ8qFvi5yNtAcCFlkgzx3FdYx48/H85P5KSHQdDPGxvQFUYb5tInoP1RmD6saTI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739458689; c=relaxed/simple;
	bh=F/GrVb0dcMW3//kOXhgBGeFgskKse472/SLS9z0mrZY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=tS3v36vfZGT1SGk7EGvvWS5/WIMQDK64VJkOrOqEA0R12YrVCzjdcb1N9kVB4rMY9bzwWxPgheP1lyttFodgLBHBjNZbhC7wXwwG459w6eZUILDJ3CJBVu3mJe2evdjLJUhI675+1s+vDmxZGpePb/v9c4tFVwJREMbQUSzWE9E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z7obo0rp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z7obo0rp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D031C4CED1;
	Thu, 13 Feb 2025 14:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739458688;
	bh=F/GrVb0dcMW3//kOXhgBGeFgskKse472/SLS9z0mrZY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Z7obo0rpBbYl/v6A/MZRMlDlYu+XFqrywe266JY4ENojzxS0goj/4S57gFvJmReOt
	 MNdnEOW2wFHSs/elOHTGuSQ+rhhGG+k6+/F9O9MJxwrbX/JeMLKHn8VQhl1IFcZsUT
	 ZBTHCBiRfimesaKB7L3yoM/eBtcyQYgfDeNRuQ48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.13 050/443] drm/amd/display: Increase sanitizer frame larger than limit when compile testing with clang
Date: Thu, 13 Feb 2025 15:23:35 +0100
Message-ID: <20250213142442.552544577@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142440.609878115@linuxfoundation.org>
References: <20250213142440.609878115@linuxfoundation.org>
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

6.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

[ Upstream commit e4479aecf6581af81bc0908575447878d2a07e01 ]

Commit 24909d9ec7c3 ("drm/amd/display: Overwriting dualDPP UBF values
before usage") added a new warning in dml2/display_mode_core.c when
building allmodconfig with clang:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6268:13: error: stack frame size (3128) exceeds limit (3072) in 'dml_prefetch_check' [-Werror,-Wframe-larger-than]
   6268 | static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
        |             ^

Commit be4e3509314a ("drm/amd/display: DML21 Reintegration For Various
Fixes") introduced one in dml2_core/dml2_core_dcn4_calcs.c with the same
configuration:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:7236:13: error: stack frame size (3256) exceeds limit (3072) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
   7236 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out_params)
        |             ^

In the case of the first warning, the stack usage was already at the
limit at the parent change, so the offending change was rather
innocuous. In the case of the second warning, there was a rather
dramatic increase in stack usage compared to the parent:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/dml21/src/dml2_core/dml2_core_dcn4_calcs.c:7032:13: error: stack frame size (2696) exceeds limit (2048) in 'dml_core_mode_support' [-Werror,-Wframe-larger-than]
   7032 | static bool dml_core_mode_support(struct dml2_core_calcs_mode_support_ex *in_out_params)
        |             ^

This is an unfortunate interaction between an issue with stack slot
reuse in LLVM that gets exacerbated by sanitization (which gets enabled
with all{mod,yes}config) and function calls using a much higher number
of parameters than is typical in the kernel, necessitating passing most
of these values on the stack.

While it is possible that there should be source code changes to address
these warnings, this code is difficult to modify for various reasons, as
has been noted in other changes that have occurred for similar reasons,
such as commit 6740ec97bcdb ("drm/amd/display: Increase frame warning
limit with KASAN or KCSAN in dml2").

Increase the frame larger than limit when compile testing with clang and
the sanitizers enabled to avoid this breakage in all{mod,yes}config, as
they are commonly used and valuable testing targets. While it is not the
best to hide this issue, it is not really relevant when compile testing,
as the sanitizers are commonly stressful on optimizations and they are
only truly useful at runtime, which COMPILE_TEST states will not occur
with the current build.

Reported-by: kernel test robot <lkp@intel.com>
Closes: https://lore.kernel.org/oe-kbuild-all/202412121748.chuX4sap-lkp@intel.com/
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Alex Deucher <alexander.deucher@amd.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index c4378e620cbf9..986a69c5bd4bc 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -29,7 +29,11 @@ dml2_rcflags := $(CC_FLAGS_NO_FPU)
 
 ifneq ($(CONFIG_FRAME_WARN),0)
 ifeq ($(filter y,$(CONFIG_KASAN)$(CONFIG_KCSAN)),y)
+ifeq ($(CONFIG_CC_IS_CLANG)$(CONFIG_COMPILE_TEST),yy)
+frame_warn_flag := -Wframe-larger-than=4096
+else
 frame_warn_flag := -Wframe-larger-than=3072
+endif
 else
 frame_warn_flag := -Wframe-larger-than=2048
 endif
-- 
2.39.5



