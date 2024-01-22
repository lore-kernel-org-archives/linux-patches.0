Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A157C12A17F;
	Tue, 23 Jan 2024 00:12:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968771; cv=none; b=rq0VDONBRtcxwO+LZFKVSUR0CZNbfNZ9ox9Uhec1wcE3TptMH29f3d6vyrRMvlgIGOunbukIoWAPMX3UhYhlmtvW/Du+JInQP56E5Sly6UizU6pE9a6/qJOzZfjzfR7EPZoHk+r/MkV2dCH/GgsvjvZTLbrd8CbnqCqfJLB+RHs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968771; c=relaxed/simple;
	bh=UXGTZ2FiQVjANxXwV51h37mN4mC11wm7qJAm1N69/ZQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=I9pKIGzevkZGPV6rl3ksxh/FNKWDmNiLsgrnTirHm+eLMnGF4D31XgKlcjiccnyrBMvMJgbdAsE+PhRGjvRqi46Kb/AjT9wzHW/t4GPoLdplig16du3zHpUmsSPrkC3SYsw7au6zehCuoGqUyX64Jud/TQQwWSMUx/4r1wWJxxY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=A8gJevGD; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="A8gJevGD"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5279FC433F1;
	Tue, 23 Jan 2024 00:12:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968771;
	bh=UXGTZ2FiQVjANxXwV51h37mN4mC11wm7qJAm1N69/ZQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=A8gJevGD9+IUjH4Tt0zmdsQ8haFD4pVV9alJbmvwtNLyVmwSWigP3Q2nybp7XwDPx
	 XFLl/Po6QleV0T0n9BNJXG1XsWrRL6MEZbz2L9QOJN1uSCa2cTwCj9EFe0aV10/p/7
	 sc6sVf6DK000WfX2Vrhc40Ean+ReZcz2TQ2Ekc0w=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 042/194] powerpc: add crtsavres.o to always-y instead of extra-y
Date: Mon, 22 Jan 2024 15:56:12 -0800
Message-ID: <20240122235721.032070764@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235719.206965081@linuxfoundation.org>
References: <20240122235719.206965081@linuxfoundation.org>
User-Agent: quilt/0.67
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

[ Upstream commit 1b1e38002648819c04773647d5242990e2824264 ]

crtsavres.o is linked to modules. However, as explained in commit
d0e628cd817f ("kbuild: doc: clarify the difference between extra-y
and always-y"), 'make modules' does not build extra-y.

For example, the following command fails:

  $ make ARCH=powerpc LLVM=1 KBUILD_MODPOST_WARN=1 mrproper ps3_defconfig modules
    [snip]
    LD [M]  arch/powerpc/platforms/cell/spufs/spufs.ko
  ld.lld: error: cannot open arch/powerpc/lib/crtsavres.o: No such file or directory
  make[3]: *** [scripts/Makefile.modfinal:56: arch/powerpc/platforms/cell/spufs/spufs.ko] Error 1
  make[2]: *** [Makefile:1844: modules] Error 2
  make[1]: *** [/home/masahiro/workspace/linux-kbuild/Makefile:350: __build_one_by_one] Error 2
  make: *** [Makefile:234: __sub-make] Error 2

Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Fixes: baa25b571a16 ("powerpc/64: Do not link crtsavres.o in vmlinux")
Reviewed-by: Nicholas Piggin <npiggin@gmail.com>
Signed-off-by: Michael Ellerman <mpe@ellerman.id.au>
Link: https://msgid.link/20231120232332.4100288-1-masahiroy@kernel.org
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/powerpc/lib/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/lib/Makefile b/arch/powerpc/lib/Makefile
index 8656b8d2ce55..7c603839fe28 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -35,7 +35,7 @@ obj-$(CONFIG_FUNCTION_ERROR_INJECTION)	+= error-inject.o
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
 ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
-extra-$(CONFIG_PPC64)	+= crtsavres.o
+always-$(CONFIG_PPC64)	+= crtsavres.o
 endif
 
 obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \
-- 
2.43.0



