Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E889DF71;
	Mon,  6 Jan 2025 15:38:47 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177927; cv=none; b=Vi3uXS/ZWuYDZPgF5jlTOvgE9fgIZY8LHf+yJHwFiaDYGS6rQshm/auyNrbGBVJi62Y0SCAhsevRnNv5hn3gmXeMEQaEL3TeIyXJtFNn/7G+iwA5N+qQ65sGqQ1ogf0qo7JEs+G67sqbY5UopKvxTvjmha2YnBwMZ5nI8aGCCUY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177927; c=relaxed/simple;
	bh=C9euzmH2iumJKiN7wGCmXTwDeHZkuuJo+I3tiK8NJkQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=FdPhtZzb41j6yhvH45EAyVZj0G16aYUncO9DVcK1WpX5syrVaOYqmdv8EQ5F/seBCryyvxNnKZmRKpHbyLFerGZdjHA3eGZ4pGbXBHZjkOzJL59jBfZZNeQCky+3kDrz/79zTKPAgIx1pMWyWOHIGQZNBOAQKN1PrdmkqcMukqg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=k1GDXVHe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="k1GDXVHe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DC1A7C4CED2;
	Mon,  6 Jan 2025 15:38:46 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177927;
	bh=C9euzmH2iumJKiN7wGCmXTwDeHZkuuJo+I3tiK8NJkQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=k1GDXVHez/o8ujAYuQIuv4Gh5/0yVukQjnULCWoWvoErufiTZ9nKnsoWLkTjzLiUY
	 Lk5xCfMmJLcxsoTX/15H3w1Zr4A4l7J+4HxJazbxU/WWMRPBjKMQ8ZQf+J3mkSGryP
	 1umfQTB4QfykGKq7lH+1ev44gNjoWTsoXzEzduUc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Leon Romanovsky <leonro@nvidia.com>,
	Vineet Gupta <vgupta@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 103/156] ARC: build: Try to guess GCC variant of cross compiler
Date: Mon,  6 Jan 2025 16:16:29 +0100
Message-ID: <20250106151145.606813219@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151141.738050441@linuxfoundation.org>
References: <20250106151141.738050441@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
index 2390dd042e36..fb98478ed1ab 100644
--- a/arch/arc/Makefile
+++ b/arch/arc/Makefile
@@ -6,7 +6,7 @@
 KBUILD_DEFCONFIG := haps_hs_smp_defconfig
 
 ifeq ($(CROSS_COMPILE),)
-CROSS_COMPILE := $(call cc-cross-prefix, arc-linux- arceb-linux-)
+CROSS_COMPILE := $(call cc-cross-prefix, arc-linux- arceb-linux- arc-linux-gnu-)
 endif
 
 cflags-y	+= -fno-common -pipe -fno-builtin -mmedium-calls -D__linux__
-- 
2.39.5



