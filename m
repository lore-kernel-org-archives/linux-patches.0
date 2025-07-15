Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C36382D028A;
	Tue, 15 Jul 2025 13:32:04 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1752586324; cv=none; b=tZgtHji+V7/LgCH5vjHpqddSSmiPFT2u99LFJ8OrNm9VGlYvTKQciAy5jerl4gpjYseQjkDQXn5v21NGcRQQl0hkUM4nKypgYJG9aLEPSSuXR/rcXCRBSzXvt/C/orK2mdLHqaEc9arQ2c6tsRZcd53yAVyuEoHOMWx/oPwpoPI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1752586324; c=relaxed/simple;
	bh=w1SNLCDWFkU/Qf9N9IjjTPsWFIcKINHD35q3dYnwCeE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VT3p539hSpvAhPk7var7W7v9G3wUZRr4O4tdPr3WKamlz3F0SEnGD1XI07KpqahyBTSh8+aEBN6EFvhb4ENSMm3Fz3hBPKhmb8fSDwPE+OYratD71Bb6W9vbBH2ANLC8nOnbss0YAwQ9d3dny5b8FsPDDq0VOO1JSBS8RL7Lf68=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A/ZynmJk; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A/ZynmJk"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5550EC4CEE3;
	Tue, 15 Jul 2025 13:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1752586324;
	bh=w1SNLCDWFkU/Qf9N9IjjTPsWFIcKINHD35q3dYnwCeE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A/ZynmJkXVTEStc1LeL7NdlLrlSlv+6d+1AX6BQ9+7sN754/gFN8M4RODmAuHsm4t
	 8jZJhSWBFbVXTUBBhs7NDHeVNHN2Y18vBk9q2vgf5uw10vEa+2vZ4RwdSNOAaFbSYM
	 tUc5k/tl1puPuMNBu4j6nAf5DEkNLoWY4hVkbs6o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nathan Chancellor <nathan@kernel.org>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 022/148] kbuild: add --target to correctly cross-compile UAPI headers with Clang
Date: Tue, 15 Jul 2025 15:12:24 +0200
Message-ID: <20250715130801.204557777@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250715130800.293690950@linuxfoundation.org>
References: <20250715130800.293690950@linuxfoundation.org>
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

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit 9fbed27a7a1101c926718dfa9b49aff1d04477b5 ]

When you compile-test UAPI headers (CONFIG_UAPI_HEADER_TEST=y) with
Clang, they are currently compiled for the host target (likely x86_64)
regardless of the given ARCH=.

In fact, some exported headers include libc headers. For example,
include/uapi/linux/agpgart.h includes <stdlib.h> after being exported.
The header search paths should match to the target we are compiling
them for.

Pick up the --target triple from KBUILD_CFLAGS in the same ways as
commit 7f58b487e9ff ("kbuild: make Clang build userprogs for target
architecture").

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Reviewed-by: Nathan Chancellor <nathan@kernel.org>
Reviewed-by: Nick Desaulniers <ndesaulniers@google.com>
Stable-dep-of: 02e9a22ceef0 ("kbuild: hdrcheck: fix cross build with clang")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 usr/include/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/usr/include/Makefile b/usr/include/Makefile
index 3d9dc4a5c6fca..de6f9bffb01ed 100644
--- a/usr/include/Makefile
+++ b/usr/include/Makefile
@@ -10,7 +10,7 @@ UAPI_CFLAGS := -std=c90 -Wall -Werror=implicit-function-declaration
 
 # In theory, we do not care -m32 or -m64 for header compile tests.
 # It is here just because CONFIG_CC_CAN_LINK is tested with -m32 or -m64.
-UAPI_CFLAGS += $(filter -m32 -m64, $(KBUILD_CFLAGS))
+UAPI_CFLAGS += $(filter -m32 -m64 --target=%, $(KBUILD_CFLAGS))
 
 override c_flags = $(UAPI_CFLAGS) -Wp,-MMD,$(depfile) -I$(objtree)/usr/include
 
-- 
2.39.5



