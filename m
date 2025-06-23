Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 349B02F24;
	Mon, 23 Jun 2025 13:32:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750685565; cv=none; b=Tap4XFL0B3ATLDq4JxU6QlVYr5K3pqvNMYfw8VGdJW7BIbunqa7juxmALGYuNAoNguAAitcvpHRknoSKHd5y+xWtAqaktUFgLljao6pSAxDL6IOJ6SSfJtnUpq9/z5KtefPrKBd9DH/Y+NoFULgyk5HFql0SAfqefXgxq+uTR1E=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750685565; c=relaxed/simple;
	bh=Vxd6tKkqzq5WLjo3dKK/Qn98YZxAVbwq0bHmpRDRH6w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XMistV3qQ42Qx8ZgHsklgUUgyVQzooYkmFKL2ClgGe/S+HU8axKhjBtuXSsIdY04MGjk6HbpGeIiBC0pLJJdzLNFy9zO6OyTTqPlFSFJx0AaYfDkv6omQXKOalZd/3Uo0TxCrALsfytGGCHhKlCTjgHVi87iW37nAUyg0X3mpEI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=TVsYo9v3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="TVsYo9v3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60436C4CEEA;
	Mon, 23 Jun 2025 13:32:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750685564;
	bh=Vxd6tKkqzq5WLjo3dKK/Qn98YZxAVbwq0bHmpRDRH6w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TVsYo9v3/p+mHgQm6ccQBoqSY97TL/k0ZqUu3TyRf8oCn9Ngru9Q5T0Cgu86u64Gf
	 iThUYhtK0KWhSyNfUWhWQpYAxijzwqsEMkfBm6GtWJnMy3QZ1OMFjxFmpfjtL/YL1i
	 VW5Tt7aPun9brI7dEKeYT+iJN4S9Lt4xojfSz1pw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.4 095/222] drm/amd/display: Do not add -mhard-float to dcn2{1,0}_resource.o for clang
Date: Mon, 23 Jun 2025 15:07:10 +0200
Message-ID: <20250623130614.964901858@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130611.896514667@linuxfoundation.org>
References: <20250623130611.896514667@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

This patch is for linux-5.15.y and earlier only. It is functionally
equivalent to upstream commit 7db038d9790e ("drm/amd/display: Do not add
'-mhard-float' to dml_ccflags for clang"), which was created after all
files that require '-mhard-float' were moved under the dml folder. In
kernels older than 5.18, which do not contain upstream commits

  22f87d998326 ("drm/amd/display: move FPU operations from dcn21 to dml/dcn20 folder")
  cf689e869cf0 ("drm/amd/display: move FPU-related code from dcn20 to dml folder")

newer versions of clang error with

  clang: error: unsupported option '-mhard-float' for target 'x86_64-linux-gnu'
  make[6]: *** [scripts/Makefile.build:289: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn20/dcn20_resource.o] Error 1
  clang: error: unsupported option '-mhard-float' for target 'x86_64-linux-gnu'
  make[6]: *** [scripts/Makefile.build:289: drivers/gpu/drm/amd/amdgpu/../display/dc/dcn21/dcn21_resource.o] Error 1

Apply a functionally equivalent change to prevent adding '-mhard-float'
with clang for these files.

Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/gpu/drm/amd/display/dc/dcn20/Makefile |    2 +-
 drivers/gpu/drm/amd/display/dc/dcn21/Makefile |    2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn20/Makefile
@@ -10,7 +10,7 @@ ifdef CONFIG_DRM_AMD_DC_DSC_SUPPORT
 DCN20 += dcn20_dsc.o
 endif
 
-CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -3,7 +3,7 @@
 
 DCN21 = dcn21_hubp.o dcn21_hubbub.o dcn21_resource.o
 
-CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 
 ifdef CONFIG_CC_IS_GCC
 ifeq ($(call cc-ifversion, -lt, 0701, y), y)


