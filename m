Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A1B41DDCC;
	Thu,  2 Nov 2023 16:25:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mva+y3X4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E2127C433CA;
	Thu,  2 Nov 2023 16:25:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1698942305;
	bh=ZP/kIBCdvT4zzHe9YkNWVQ0ufjZVnXPWplIffBkOZoU=;
	h=From:Date:Subject:To:Cc:From;
	b=mva+y3X476vfa8R9Ay7i+hgpOKdcBcnT38YLWatpi/J8z8Z6sPJZsOtffdqm7TfpG
	 VRuccAfqXOOUW5HLNq/PDoDaIH9jezPF/Qrjze+v/BtdTwA6ug9URafaxvMWtlHok6
	 s00AoYSmXQmmr/XCNSgDOPYumIUd1DaV0TiI5gH6T+DYbG50NpuLzr+dWfmINnt8Tw
	 VYY3T4Z6fUsewqp3Ov5l3g3EVsO4Atjw9MocsBie8EjEf4fFQwPyiYWFY8QtUOAbVp
	 4fBqiMhkSexrR4dxZLHOKHFaK0T+d89HUEknPkspkOg6CQy2koq5v7dc6hPEUAoDlY
	 g0JHHZqIrez0g==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 02 Nov 2023 09:24:53 -0700
Subject: [PATCH] drm/amd/display: Increase frame warning limit for clang in
 dml2
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20231102-amdgpu-dml2-increase-frame-size-warning-for-clang-v1-1-6eb157352931@kernel.org>
X-B4-Tracking: v=1; b=H4sIAFTNQ2UC/x3NSwrDMAwA0asErSuIHejvKqUL1ZZdQawEmbQlI
 XeP6XI2bzaobMIV7t0Gxh+pMmkLd+ogvEkzo8TW4Hs/ONd7pBLzvGAso0fRYEyVMRkVxior45d
 MRTOmyTCMTcBwG17RxzNdLw6aOxsn+f2fj+e+H2ns4L+DAAAA
To: harry.wentland@amd.com, sunpeng.li@amd.com, Rodrigo.Siqueira@amd.com, 
 alexander.deucher@amd.com, christian.koenig@amd.com, Xinhui.Pan@amd.com
Cc: ndesaulniers@google.com, trix@redhat.com, amd-gfx@lists.freedesktop.org, 
 dri-devel@lists.freedesktop.org, llvm@lists.linux.dev, 
 patches@lists.linux.dev, Nathan Chancellor <nathan@kernel.org>
X-Mailer: b4 0.13-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=3010; i=nathan@kernel.org;
 h=from:subject:message-id; bh=ZP/kIBCdvT4zzHe9YkNWVQ0ufjZVnXPWplIffBkOZoU=;
 b=owGbwMvMwCEmm602sfCA1DTG02pJDKnOZxOE5a7O1RNk3ayX/IjH2VpChG1W37WPdUsva134J
 bep79PpjlIWBjEOBlkxRZbqx6rHDQ3nnGW8cWoSzBxWJpAhDFycAjCR0hiGv9Jd7iE/9zJdrvsU
 L3/8f5hZQVXfqbU/bjyftcxv83NBqZsM//3PJT6qUm/167ww8/p3VffuTYYm+5ui1ikLfqyrUt1
 0mgsA
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

When building ARCH=x86_64 allmodconfig with clang, which have sanitizers
enabled, there is a warning about a large stack frame.

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6265:13: error: stack frame size (2520) exceeds limit (2048) in 'dml_prefetch_check' [-Werror,-Wframe-larger-than]
   6265 | static void dml_prefetch_check(struct display_mode_lib_st *mode_lib)
        |             ^
  1 error generated.

Notably, GCC 13.2.0 does not do too much of a better job, as it is right
at the current limit of 2048:

  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c: In function 'dml_prefetch_check':
  drivers/gpu/drm/amd/amdgpu/../display/dc/dml2/display_mode_core.c:6705:1: error: the frame size of 2048 bytes is larger than 1800 bytes [-Werror=frame-larger-than=]
   6705 | }
        | ^

In the past, these warnings have been avoided by reducing the number of
parameters to various functions so that not as many arguments need to be
passed on the stack. However, these patches take a good amount of effort
to write despite being mechanical due to code structure and complexity
and they are never carried forward to new generations of the code so
that effort has to be expended every new hardware generation, which
becomes harder to justify as time goes on.

There is some effort to improve clang's code generation but that may
take some time between code review, shifting priorities, and release
cycles. To avoid having a noticeable or lengthy breakage in
all{mod,yes}config, which are easy testing targets that have -Werror
enabled, increase the limit for clang by 50% so that cases of extremely
poor code generation can still be caught while not breaking the majority
of builds. When clang's code generation improves, the limit increase can
be restricted to older clang versions.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
If there is another DRM pull before 6.7-rc1, it would be much
appreciated if this could make that so that other trees are not
potentially broken by this. If not, no worries, as it was my fault for
not sending this sooner.
---
 drivers/gpu/drm/amd/display/dc/dml2/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/gpu/drm/amd/display/dc/dml2/Makefile b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
index 70ae5eba624e..dff8237c0999 100644
--- a/drivers/gpu/drm/amd/display/dc/dml2/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dml2/Makefile
@@ -60,7 +60,7 @@ endif
 endif
 
 ifneq ($(CONFIG_FRAME_WARN),0)
-frame_warn_flag := -Wframe-larger-than=2048
+frame_warn_flag := -Wframe-larger-than=$(if $(CONFIG_CC_IS_CLANG),3072,2048)
 endif
 
 CFLAGS_$(AMDDALPATH)/dc/dml2/display_mode_core.o := $(dml2_ccflags) $(frame_warn_flag)

---
base-commit: 21e80f3841c01aeaf32d7aee7bbc87b3db1aa0c6
change-id: 20231102-amdgpu-dml2-increase-frame-size-warning-for-clang-c93bd2d6a871

Best regards,
-- 
Nathan Chancellor <nathan@kernel.org>

