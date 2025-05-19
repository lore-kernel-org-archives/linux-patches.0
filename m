Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1C44247297;
	Mon, 19 May 2025 21:23:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689818; cv=none; b=GSkuCNW6Ex3FhaCUCWTkiCpok7RZx4PCGcyjnn5tepMUferIi8DNaV5lqIRvldeuSbhjjs3xee8D8hpgdHFR3Mb56+e2oCP6aZ+HP5sL+6K6dRXJYXWJxcL6NhmqCqfUuK2PYE8iLo7W1lVRHAp5T3qdLJ95XsMvxggJdFQu9Pc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689818; c=relaxed/simple;
	bh=Y2fcy43w1c29ZAiohb+yJAKWKqujaYpYj9pN82NIrVM=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=QS0Uk6Yr8OPHrwFiCL84PtD/x62G3TIOO3vSKeLu41DolMk8tU3+lcN5UJPTZhoxaNsdPujQCcyUpRvav9x1KS0u/uMjVhE4GYS02+MFppziBKIFj97RGwO24jGW8nvu2Rtzr2cTvkStweF8PUjXwyX6r09dwTEvPSIX2ttiNTw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=TmRduaLe; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="TmRduaLe"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0BDE6C4CEEB;
	Mon, 19 May 2025 21:23:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689818;
	bh=Y2fcy43w1c29ZAiohb+yJAKWKqujaYpYj9pN82NIrVM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=TmRduaLeaG1Tpl4l1jYvrx6SzHw68cSMfpd2itfrDcB8pxnge7w+6MVbJKnkXfV2S
	 7k5Xhv2mN3Eea/jfJd2swJGHpQSB7Wk6w/3AOxV6ck58STkhR0RH9eTceevrpC6mQ1
	 7DTTdLqYuSX0ysxtCd8H6vBOUBtoDPeMCvFtivc2OIXyzfcu4t/Wke/r15/98z1GbT
	 RAdqkRh+cU28iNS1KRRpgH4/NcZu7RxQUUIJ8tufWqVSNWx63somwMCLsadnKEsGge
	 +oFmhQb1mACy8yotKc6JA6f76PtYdg18NoTEwxWNlzCqc1xWKLQMaE3idlhoeAmsTb
	 gFfbeod2T02LQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Masahiro Yamada <masahiroy@kernel.org>,
	Shuah Khan <skhan@linuxfoundation.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>,
	jdike@addtoit.com,
	richard@nod.at,
	anton.ivanov@cambridgegreys.com,
	linux-um@lists.infradead.org,
	linux-kernel@vger.kernel.org
Subject: [PATCH AUTOSEL 5.4 4/5] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:23:30 -0400
Message-Id: <20250519212331.1986865-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212331.1986865-1-sashal@kernel.org>
References: <20250519212331.1986865-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.4.293
Content-Transfer-Encoding: 8bit

From: Masahiro Yamada <masahiroy@kernel.org>

[ Upstream commit ab09da75700e9d25c7dfbc7f7934920beb5e39b9 ]

Building the kernel with O= is affected by stale in-tree build artifacts.

So, if the source tree is not clean, Kbuild displays the following:

  $ make ARCH=um O=build defconfig
  make[1]: Entering directory '/.../linux/build'
  ***
  *** The source tree is not clean, please run 'make ARCH=um mrproper'
  *** in /.../linux
  ***
  make[2]: *** [/.../linux/Makefile:673: outputmakefile] Error 1
  make[1]: *** [/.../linux/Makefile:248: __sub-make] Error 2
  make[1]: Leaving directory '/.../linux/build'
  make: *** [Makefile:248: __sub-make] Error 2

Usually, running 'make mrproper' is sufficient for cleaning the source
tree for out-of-tree builds.

However, building UML generates build artifacts not only in arch/um/,
but also in the SUBARCH directory (i.e., arch/x86/). If in-tree stale
files remain under arch/x86/, Kbuild will reuse them instead of creating
new ones under the specified build directory.

This commit makes 'make ARCH=um clean' recurse into the SUBARCH directory.

Reported-by: Shuah Khan <skhan@linuxfoundation.org>
Closes: https://lore.kernel.org/lkml/20250502172459.14175-1-skhan@linuxfoundation.org/
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Acked-by: Johannes Berg <johannes@sipsolutions.net>
Reviewed-by: David Gow <davidgow@google.com>
Reviewed-by: Shuah Khan <skhan@linuxfoundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/um/Makefile | 1 +
 1 file changed, 1 insertion(+)

diff --git a/arch/um/Makefile b/arch/um/Makefile
index 94cea8d46b222..daec900ed4631 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -154,5 +154,6 @@ MRPROPER_DIRS += arch/$(SUBARCH)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS DEV_NULL_PATH
-- 
2.39.5

