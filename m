Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A13A21170E
	for <patches@lists.linux.dev>; Mon, 11 Sep 2023 14:28:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1C097C433C8;
	Mon, 11 Sep 2023 14:28:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694442496;
	bh=/7Xf7XiS22OOIWgkQEI41Hi9ttUwHKlUu5PzKw64xJQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GlNE/TKam9OuDA/G5o2ZNS8I5ZE7e8i91BNKbaPqLt3g3uBfxRQIl7Gd1C7FtOhNM
	 +UqIJbnakUR4REwUGBAjMmbqGc5IpSzqcCzok7fZ6Kq1KlxZCeCVXw2HL+D+dUlBA1
	 Jew4x/yUPz6PNjDvaFktSShnm6wc88WQeJolS8PE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Huacai Chen <chenhuacai@loongson.cn>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.4 045/737] LoongArch: Only fiddle with CHECKFLAGS if `need-compiler
Date: Mon, 11 Sep 2023 15:38:24 +0200
Message-ID: <20230911134651.703858988@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230911134650.286315610@linuxfoundation.org>
References: <20230911134650.286315610@linuxfoundation.org>
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

6.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Huacai Chen <chenhuacai@loongson.cn>

[ Upstream commit 54c2c9df083fe1d4a9df54d9876f32582ce6d77a ]

This is a port of commit 4fe4a6374c4db9ae2b ("MIPS: Only fiddle with
CHECKFLAGS if `need-compiler'") to LoongArch.

We have originally guarded fiddling with CHECKFLAGS in our arch Makefile
by checking for the CONFIG_LOONGARCH variable, not set for targets such
as `distclean', etc. that neither include `.config' nor use the compiler.

Starting from commit 805b2e1d427aab4 ("kbuild: include Makefile.compiler
only when compiler is needed") we have had a generic `need-compiler'
variable explicitly telling us if the compiler will be used and thus its
capabilities need to be checked and expressed in the form of compilation
flags.  If this variable is not set, then `make' functions such as
`cc-option' are undefined, causing all kinds of weirdness to happen if
we expect specific results to be returned.

It doesn't cause problems on LoongArch now. But as a guard we replace
the check for CONFIG_LOONGARCH with one for `need-compiler' instead, so
as to prevent the compiler from being ever called for CHECKFLAGS when
not needed.

Signed-off-by: Huacai Chen <chenhuacai@loongson.cn>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/loongarch/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/loongarch/Makefile b/arch/loongarch/Makefile
index 63a637fdf6c28..95629322241f5 100644
--- a/arch/loongarch/Makefile
+++ b/arch/loongarch/Makefile
@@ -106,7 +106,7 @@ KBUILD_CFLAGS += -isystem $(shell $(CC) -print-file-name=include)
 
 KBUILD_LDFLAGS	+= -m $(ld-emul)
 
-ifdef CONFIG_LOONGARCH
+ifdef need-compiler
 CHECKFLAGS += $(shell $(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -dM -E -x c /dev/null | \
 	grep -E -vw '__GNUC_(MINOR_|PATCHLEVEL_)?_' | \
 	sed -e "s/^\#define /-D'/" -e "s/ /'='/" -e "s/$$/'/" -e 's/\$$/&&/g')
-- 
2.40.1



