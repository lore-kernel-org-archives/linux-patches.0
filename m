Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CB6F218DF62;
	Mon,  6 Jan 2025 16:01:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179312; cv=none; b=mZDTwhcDjmhvFz/XhHQF2Uq6mqz7CgcoRYdCM6eWnp6uCMRj5EQ/Ghpu+MXoSy3lWWKdzXDmdsbh+K+nktE7YSU0uKS6st9H6MTuNEnWRUinA3sh498h3PcMaoiKb274ZYX1/73wAh9F2AtOH88uFPeCZw6IV9aMLOuzpUL0gL0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179312; c=relaxed/simple;
	bh=XbA1qUYlmyoW+S94WA+ZBTlEe3obOIZnSSbN+yKldjk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=NgVvTxvOmwgJpghSWczICWuxnFOfDj7ISBlEhvn1APb+aiZ0y44zsz+7fVgjVCvPNpteuaeOAwd98bhxwr6Ypphu7mLyGQAJqW0jLdCSd8sjY+b2xboB6YzIO/gCBuFBhygwhwBiak6YN62KbbiXjNKSmIQs2hEcTJ5GWhHzelU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VK8OCrKA; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VK8OCrKA"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47C69C4CED2;
	Mon,  6 Jan 2025 16:01:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179312;
	bh=XbA1qUYlmyoW+S94WA+ZBTlEe3obOIZnSSbN+yKldjk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VK8OCrKAEFB5Ss8ttlmdGvsNzz3nceQ4tpXJ8MGjQxCScc+r47ovfE7pGGPY4D6fm
	 SJqePFguxMoOHL+Ht7adD1j+eJznR7VVS7qeAq4tREB4eO3Sc0EthvNxgl/YYrtDZM
	 oqiLRRKkVIhrCCqmxR/FqAAhNO+DFE+7RfJJcgbU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 85/93] ARC: build: Try to guess GCC variant of cross compiler
Date: Mon,  6 Jan 2025 16:18:01 +0100
Message-ID: <20250106151131.913566348@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Leon Romanovsky <leonro@nvidia.com>

[ Upstream commit 824927e88456331c7a999fdf5d9d27923b619590 ]

ARC GCC compiler is packaged starting from Fedora 39i and the GCC
variant of cross compile tools has arc-linux-gnu- prefix and not
arc-linux-. This is causing that CROSS_COMPILE variable is left unset.

This change allows builds without need to supply CROSS_COMPILE argument
if distro package is used.

Before this change:
$ make -j 128 ARCH=arc W=1 drivers/infiniband/hw/mlx4/
  gcc: warning: ‘-mcpu=’ is deprecated; use ‘-mtune=’ or ‘-march=’ instead
  gcc: error: unrecognized command-line option ‘-mmedium-calls’
  gcc: error: unrecognized command-line option ‘-mlock’
  gcc: error: unrecognized command-line option ‘-munaligned-access’

[1] https://packages.fedoraproject.org/pkgs/cross-gcc/gcc-arc-linux-gnu/index.html
Signed-off-by: Leon Romanovsky <leonro@nvidia.com>
Signed-off-by: Vineet Gupta <vgupta@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/arc/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/arc/Makefile b/arch/arc/Makefile
index 6f05e509889f..d72d9f4dfc3d 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -6,7 +6,7 @@
 KBUILD_DEFCONFIG := nsim_hs_defconfig
 
 ifeq ($(CROSS_COMPILE),)
-CROSS_COMPILE := $(call cc-cross-prefix, arc-linux- arceb-linux-)
+CROSS_COMPILE := $(call cc-cross-prefix, arc-linux- arceb-linux- arc-linux-gnu-)
 endif
 
 cflags-y	+= -fno-common -pipe -fno-builtin -mmedium-calls -D__linux__
-- 
2.39.5



