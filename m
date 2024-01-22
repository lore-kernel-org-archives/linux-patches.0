Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D1381420C8;
	Tue, 23 Jan 2024 00:02:44 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1705968164; cv=none; b=i1b35yS+WuqY0GBHewYLbcmN7KRxWytFF+T8wFP231/aDqmkg1qUenLg2hBrL9ITEjTjMZwl9o4UYqKTjnh9UXEXTq3Vrolc76B0KhU/lkFB7dA3y67T7qMkFUvN6cCpLIyPshqImekfnfTS9iEaLzF5ss9sPl/UZLb/Pl2TGUw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1705968164; c=relaxed/simple;
	bh=dKilVSNHS4pNFNh43DQE7yPazYh+EedEITvdAtTr8CU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ODyr41XX8pZsEi1kdvXRCqGkrU/YhFJjxMGa4VEUI9UcsqRq6SwDHkzp/xYoOuUP+Tu/wSrAbxjjRPmxXIEssFF/fmWj/tzkAeJJolIYD8bXHAmQoPYkcP9C+sZxA36MGKAfELci8i1YmVazu740LXY+No2NslGdUWEYgihE+Gg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ngg7t1Y1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ngg7t1Y1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 190CEC433C7;
	Tue, 23 Jan 2024 00:02:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1705968163;
	bh=dKilVSNHS4pNFNh43DQE7yPazYh+EedEITvdAtTr8CU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Ngg7t1Y1yQXxcW6N7rJucrnyRO17Zd8hUMeyy9sjlmmrg1Zk5YwjWiDNCb/roMigP
	 G92/TKqAsmBgl3ssD6KKQL2JbOgg6YDhyB2lcu0FQrYWVdzKqW+Qt2m14yG3j9eX0L
	 AgFaLwnnrhLmiUEdxT9FfpJuZC3Fl3UVVJ117Z44=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Masahiro Yamada <masahiroy@kernel.org>,
	Nicholas Piggin <npiggin@gmail.com>,
	Michael Ellerman <mpe@ellerman.id.au>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 4.19 029/148] powerpc: add crtsavres.o to always-y instead of extra-y
Date: Mon, 22 Jan 2024 15:56:25 -0800
Message-ID: <20240122235713.589766363@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240122235712.442097787@linuxfoundation.org>
References: <20240122235712.442097787@linuxfoundation.org>
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

4.19-stable review patch.  If anyone has any objections, please let me know.

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
index 36f913084429..6f1e57182876 100644
--- a/arch/powerpc/lib/Makefile
+++ b/arch/powerpc/lib/Makefile
@@ -22,7 +22,7 @@ obj-$(CONFIG_PPC32)	+= div64.o copy_32.o crtsavres.o strlen_32.o
 # so it is only needed for modules, and only for older linkers which
 # do not support --save-restore-funcs
 ifeq ($(call ld-ifversion, -lt, 225000000, y),y)
-extra-$(CONFIG_PPC64)	+= crtsavres.o
+always-$(CONFIG_PPC64)	+= crtsavres.o
 endif
 
 obj-$(CONFIG_PPC_BOOK3S_64) += copyuser_power7.o copypage_power7.o \
-- 
2.43.0



