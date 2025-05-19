Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2138623E324;
	Mon, 19 May 2025 21:23:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689796; cv=none; b=p7KWthxQt+uN7iEljYP0G5y98KU8le916TMQ4z3lqrXfIKuqnWoycXmUFpLS+5+iO08K6Z9JGg2pBAAkeLGM7jxqRXjvSI/zoHNMnGqeHoC+H1UWUHyxpH1XYseHQEu7JUShl7xRrq2YIDhh5Zs51vluQdc8rTFIRWX512OJf2c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689796; c=relaxed/simple;
	bh=01V2kp9PR7OuzoxgYCqNxryI2MMU4E7MhSbRS54NI7A=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=UU8a+fTezo+Q3tfSu6fh3MGSjR2R/V2m1Pt5lG66Hdj3+8b6VGp/OpGdXG8BeWb2r0hsL+LVUNNLpDK8WC2KYrRAgc/7WtEynPDABr6LYk1KD5dTndVWJGZRUzo8Jmia7sddMZ94/1MLqdNtRrKO4EiXA3qfQ/my3p+nSCVMKkE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=T/sDpt9E; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="T/sDpt9E"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B11E5C4CEED;
	Mon, 19 May 2025 21:23:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689796;
	bh=01V2kp9PR7OuzoxgYCqNxryI2MMU4E7MhSbRS54NI7A=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T/sDpt9EARXbj9sgQ9sZu/80cXKnT95njuh+msu2/mXg18P7CUlDUUiGz5mPmU2rk
	 EGzHR0AEMXpnD1eQmgabprd9I1OiS1Yp/FWrFIJdjbBdjxz1Jk8qwwjNNdfTyJFhSM
	 vI7IUF2fIdqgl94dF0TI2xl0T2hlb0v6yipt+k54MeItauXXuT2AcBP75KUogH4dsy
	 TDV+HK+QOwTf8mJqOPX9PEG2k0/1xjiKw7ZM4Q8w8iGqY87qre0lxg03TCdoS/Hz4X
	 uxprMqZDJa8SwKMXvkHi69OjZ3kITxWfBDSm9oMqPdMv9PgZMaEd1umAUM8mHBb17J
	 U90cWfMEir5sg==
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
Subject: [PATCH AUTOSEL 5.15 4/7] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:23:05 -0400
Message-Id: <20250519212308.1986645-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212308.1986645-1-sashal@kernel.org>
References: <20250519212308.1986645-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 5.15.183
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
index 3dbd0e3b660ea..1257ef03d1b7a 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -153,5 +153,6 @@ MRPROPER_FILES += $(HOST_DIR)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS DEV_NULL_PATH
-- 
2.39.5

