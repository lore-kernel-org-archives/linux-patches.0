Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C7E752C3247;
	Mon,  2 Jun 2025 14:36:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748875000; cv=none; b=tanrUHub2OTShuyEBrlUuq00uPRmSpcH+9jzuBWMLBXPshmrRlhAcLqnMPLiKDTdGaBv9VVY8bffk/IPnJZ52VXc91HTpVUCZpoPaE41Pnz2dLbZsu7p4xz+KKSYSfSXcET9bMifP4AM6r+KPkgucWblJ/m0mjQCXwFfK6Y46js=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748875000; c=relaxed/simple;
	bh=eSv8jQBNXbwEa9L6zxBKwBvP9sgCdYF++8fmo18B2Zk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gsK5MDtxqYoBJFguBOzlgtjA7XxPYILFzoFWifNFcXvAr2O7y8e5k3ajfVTAPBBgkHFM+aIPG0kK/riT+VjfNZXHla+uIzAjFCskJYx4OVI506n4N3qw+0shWw2SRD2Z50pfyAOmcGiC8lY3z4MU9VCOCY1/MRIei+Cbn9SSGZY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0nOM3hjv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0nOM3hjv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 37EC8C4CEEB;
	Mon,  2 Jun 2025 14:36:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748875000;
	bh=eSv8jQBNXbwEa9L6zxBKwBvP9sgCdYF++8fmo18B2Zk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0nOM3hjvWplva6Lc4mDYgkYpNdgXP+7CkJJHOM+wGjN3/bArdjMJZDplezacgl9gf
	 Iupbv47HTHYatOUhgKYA6XY65xGcm5qLUXJUcBjXOQHmu0IxWHKlzcFpWV0/3SAEsR
	 SDXdQH4U9QQdl+dz6HQq/nwcTWxfXQ6ZdlPWUWS4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shuah Khan <skhan@linuxfoundation.org>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Johannes Berg <johannes@sipsolutions.net>,
	David Gow <davidgow@google.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 200/204] um: let make clean properly clean underlying SUBARCH as well
Date: Mon,  2 Jun 2025 15:48:53 +0200
Message-ID: <20250602134303.532454453@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250602134255.449974357@linuxfoundation.org>
References: <20250602134255.449974357@linuxfoundation.org>
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



