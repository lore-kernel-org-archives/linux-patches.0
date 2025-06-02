Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 162831FC0EF;
	Mon,  2 Jun 2025 15:19:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748877570; cv=none; b=V7yz1A9gIxbEBwmcsIjcfHYT8hM/kJRwwKV3ieD3twJAFJxNogcpuu3x0XSeZrXEtm7IYM8ejlqanSSwCdk37utdekhY2oN7oUL9+AyipfEaqC9Q+HBQXNl7UaWzGIfxws/2lvtgOVOUI6BPOBRloukizDzI3553qHlJW3WMyvo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748877570; c=relaxed/simple;
	bh=GOkVOfidRk3M1NgL+lRy7dRQ6nF8mKpDbhGKtwYsYBs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QLEzWjn/JRjYMEZOOasPyWj6kO5LibTFrZ5RpHCiccg3gknogoRclybggrGARg8F5ua5DfoIqTDepSfLYXgfu+WhOimaIVbSXnk5k0JgTc0Q/V9gCbJTfsNG1xGA+N0k5weNqAz5l3+rEjBHRWKTy4ixMQvsNnnGmiWdxe1l2D0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=loCMKWoa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="loCMKWoa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7586CC4CEEE;
	Mon,  2 Jun 2025 15:19:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748877569;
	bh=GOkVOfidRk3M1NgL+lRy7dRQ6nF8mKpDbhGKtwYsYBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=loCMKWoayd7Pyc4QbgdEfuM8Cl891KIu5rgthheTRTUNV/OBlAcROSwXsfHFRDVJj
	 vM1cm/Xug96uU4jXuI82K7DQ9G3JN/ZqGGaJ4duOZBpDBbmtjumWQrsqQ5iH0c+toJ
	 kS5YuYvZjiP6UPN3Nfh2YGqOsBGAvr42RlbzjThw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 319/325] um: let make clean properly clean underlying SUBARCH as well
Date: Mon,  2 Jun 2025 15:49:55 +0200
Message-ID: <20250602134332.892839328@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134319.723650984@linuxfoundation.org>
References: <20250602134319.723650984@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

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
index 778c50f273992..25d0501549f54 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -155,5 +155,6 @@ MRPROPER_FILES += $(HOST_DIR)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING OS DEV_NULL_PATH
-- 
2.39.5



