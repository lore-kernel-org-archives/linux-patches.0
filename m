Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4FFF521E0A2;
	Mon, 19 May 2025 21:22:46 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689766; cv=none; b=SuEqZgjZN3krJ0AUIko1Ss/ZE6zcfUZDbxF1KvuuIQWvcsJjJT2uQ+fUMc8etrEhW360tR8QNlOTnRAamhaGB5JtN0OTjU36A1Ld9FT8aRJd7F+ldjxxUNuIy8JfLLqygi/XO3s+5alImE9VPpwWmRNqL15dWkbiXJxdvz56Nwo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689766; c=relaxed/simple;
	bh=8xcNgCbKv/2uMp8vF8NpZA2VkHV3QGDF3Y86ogSPFHE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=M5Briuz0M3PnT8nNFUOLI81UAVS9KgSvwEO9p/jrEfuHcuF/jRC3iUIGLr5npG26EMe/HWqcVpyN650PFJK2SBT/i5jMKvOam4T2l5rwrNDs88yox+cAJ5o64lH3WAI7x1Cd4mIw4G9TYe5XiauTrnBd5ohYrrBmC40deK5SIKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=ZaTF8YM3; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="ZaTF8YM3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E7416C4CEED;
	Mon, 19 May 2025 21:22:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689766;
	bh=8xcNgCbKv/2uMp8vF8NpZA2VkHV3QGDF3Y86ogSPFHE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZaTF8YM397TSGSJiDfTHmblP1tXCR+x2CoQkQw42YNHLXyfQtnIBSdIhgMYZG6fYF
	 oQJ4iMk9DbFqIoXT47oS3xj+YK69/A2VZK6sB08exDzyl1ZLGp6VZ5e5E4FrBEH1lu
	 7UznBfQqQ9J/3rVSbraDq5ZI5mGd9ffXCYTsLYkqtLRZ2KdpsA5x90XrdedFoMGKtA
	 t/bD5sU+55nDEGy7XCz7cJN3IavgZAfATWb3ZEIBdnw1EXefCuRFIeq1by8QXMfhNa
	 ydN4FgFwLfi+a/C7/hU/Cr5GtzUEXCkj7MVtUIV+M9/FuMMSBtLxIdNJhNjSGA81yb
	 UC8Dob8jH/anw==
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
Subject: [PATCH AUTOSEL 6.6 05/11] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:22:31 -0400
Message-Id: <20250519212237.1986368-5-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212237.1986368-1-sashal@kernel.org>
References: <20250519212237.1986368-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.6.91
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
index 34957dcb88b9c..744c5d0bdeb8f 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -151,5 +151,6 @@ MRPROPER_FILES += $(HOST_DIR)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING DEV_NULL_PATH
-- 
2.39.5

