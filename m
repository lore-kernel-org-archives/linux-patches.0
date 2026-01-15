Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5C2D03624C4;
	Thu, 15 Jan 2026 16:52:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1768495952; cv=none; b=ViCE1NCKpqe/EaK4m6RsxA3Rc4Fw+58/MSzHa23Khu/Eyl0PA+KLWK+k6ncXnKGKeXifNoBS2CgoGBFXchj+d0Q3zrAbD82bXUruNRj4c3Tf2i1xgaXtHcr7HxZW+c8ThMO4+zv2eV0v04d772xyPyPJ4nS1++WuXQQcvu5Gh4U=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1768495952; c=relaxed/simple;
	bh=yncm/ZDOVAQ7c4b6PRJodKcM2x5/5a5zdk4UR8LUVy0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LrIJVBsM7MiADQy88Pko40r0lk+nY8blGwtErpvkC8GkXoe9wnzoBWAxw9qVqWq9wfiyXj9rG8v5osfps7Y9EXbN7QnINKHFGCked+6Cvrys+3l7ZvZwYyOuIMxr58Sead79Xdt4vY0o3+nafCfBYJUxKKKVIdIGlX5mU2xH9e8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=EKrsvPVl; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="EKrsvPVl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9A5D4C116D0;
	Thu, 15 Jan 2026 16:52:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1768495952;
	bh=yncm/ZDOVAQ7c4b6PRJodKcM2x5/5a5zdk4UR8LUVy0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=EKrsvPVlOG9kfF9nXNu/Q2QrYbA8sFtKFkMeveL+vfCT4WzEeXXAHdf1kwOLFjRmR
	 TChouUyzMhHhVT+N5lRbY4iMQpH/7mU/GOKjFTXUWIwaFCcuBr7FaxTwmTYzhzDdjx
	 Nf+L+3dZlntWCIxXn4T+NMJBphr6kxLC5gVu/C/U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	Alex Deucher <alexander.deucher@amd.com>
Subject: [PATCH 6.18 025/181] drm/amd/display: Apply e4479aecf658 to dml
Date: Thu, 15 Jan 2026 17:46:02 +0100
Message-ID: <20260115164203.234489291@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260115164202.305475649@linuxfoundation.org>
References: <20260115164202.305475649@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit 70740454377f1ba3ff32f5df4acd965db99d055b upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dml/Makefile |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

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


