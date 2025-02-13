Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3051F14B95A;
	Thu, 13 Feb 2025 14:33:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1739457205; cv=none; b=hmLEMU9n6oYsE05O7oLyUt3qaJzZk5ZCGkxQ2nJibIAS7SYwoK2jj+OQwYFLcXzfONQr0ZV+r5qPaXd4WMao/IWXwJudQWR+3Sk+zNw2emmO0vFLs5HLneBilmkYivFGKlJ6XIsn/juqj6sYt161uLLadbXh9ia+q8oHGvKhF0Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1739457205; c=relaxed/simple;
	bh=VF8LFm3M2Krj7sB9XfHa2qepJ8x9LCEUNZzVjUcVUnI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=F8YGb1GyDpGJNl1JwJ2bwg0xwUhaeZmxQcSfzMjxbAtonUgx5ubfLc6L/XTo7wzfqHbIENWsmqQeQXmUq64K+NMxOtYj7V0XLWD2fQDOK0t1DVmkX2ZsmRQYzXE7eWEXkVqVT3+N8PxNA4w02YMlYN59Tr5l1K3acSzknJrCwo8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CM6D74FI; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CM6D74FI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B755C4CED1;
	Thu, 13 Feb 2025 14:33:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1739457205;
	bh=VF8LFm3M2Krj7sB9XfHa2qepJ8x9LCEUNZzVjUcVUnI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CM6D74FI2JAPq3+CE/6jXt7MWpC5YTFoqD9ptqCUpZm3FXDLFnNx5Hu+Xq9p0zd85
	 EV+veKKbhPiW/kMFhhJg87ElaYJcnorzqyyRbELl79CVoIeLVjsEbucWSu2SEBdngf
	 83eMOsnFyt8RXkOE8CywWxR0nOWFmD2wstl3iC4U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	kernel test robot <lkp@intel.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 045/422] drm/amd/display: Increase sanitizer frame larger than limit when compile testing with clang
Date: Thu, 13 Feb 2025 15:23:14 +0100
Message-ID: <20250213142438.301529198@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250213142436.408121546@linuxfoundation.org>
References: <20250213142436.408121546@linuxfoundation.org>
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



