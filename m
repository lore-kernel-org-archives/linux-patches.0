Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EEECD2AD04;
	Mon, 23 Jun 2025 21:31:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714265; cv=none; b=NxUx2mxGD8lQe5bQMOsTAcjKbsbIAo9s8R644POtanm2UOWkIFwVKnu7xSEe9th+l2QM05WLVznGLLqMo+E9uIscs0CY84eHTu+gtet6n96MAtkgOr2XGzw/2NchMLKl7Ew1AmWYesdZX5fdsH5Y4KjNgNM5P4kTgmQnGIXq9q8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714265; c=relaxed/simple;
	bh=iM6JA2p8B+wfuf+71kLAQx4er68qZFaXbuC7/vvp6+0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=L0n48BcR8qaNv+68nHyg4F8EnylcBeOoYzS+5Ckb2k0qTnhU54saivOWkI9Nmsf3crvDNNZPykl/agG0awW7BcY/NvIffC5Zg6c/IWoGJ5DoP0wimLKMyC/2k3ZOCthdji3hFb+R9ybvm8SFraF3U+oILhItav+pSxWnKEujlPo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=v+0mhN1o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="v+0mhN1o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 87B33C4CEEA;
	Mon, 23 Jun 2025 21:31:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714264;
	bh=iM6JA2p8B+wfuf+71kLAQx4er68qZFaXbuC7/vvp6+0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=v+0mhN1onkt99egT5fDWyR97BcD35kMn7rTx9R8mWUbxo85N/DlsDe7AFi2E3aLzR
	 c8Wl1PBKOOSZyhopDvGirWi3H+EQAz1viswy6SAwZb3wiR3fbtDUzwXvGx1US6ezwk
	 xYuHlGMtKlt9nKh/m//6e0DV2zq8RVGO/2jqnZIY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>
Subject: [PATCH 5.15 177/411] drm/amd/display: Do not add -mhard-float to dcn2{1,0}_resource.o for clang
Date: Mon, 23 Jun 2025 15:05:21 +0200
Message-ID: <20250623130638.142726101@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130632.993849527@linuxfoundation.org>
References: <20250623130632.993849527@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -10,7 +10,7 @@ DCN20 = dcn20_resource.o dcn20_init.o dc
 DCN20 += dcn20_dsc.o
 
 ifdef CONFIG_X86
-CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn20/dcn20_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 endif
 
 ifdef CONFIG_PPC64
--- a/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
+++ b/drivers/gpu/drm/amd/display/dc/dcn21/Makefile
@@ -6,7 +6,7 @@ DCN21 = dcn21_init.o dcn21_hubp.o dcn21_
 	 dcn21_hwseq.o dcn21_link_encoder.o dcn21_dccg.o
 
 ifdef CONFIG_X86
-CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := -mhard-float -msse
+CFLAGS_$(AMDDALPATH)/dc/dcn21/dcn21_resource.o := $(if $(CONFIG_CC_IS_GCC), -mhard-float) -msse
 endif
 
 ifdef CONFIG_PPC64


