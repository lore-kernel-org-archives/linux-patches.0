Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 379411DE2CE;
	Mon, 19 May 2025 21:23:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689783; cv=none; b=KaI8XaQaG4gojLYD9QvbbYbfAUjO3S7QGfn8mBluz+gwhpZCOoiv5HWwKMWSDE6gPGx/W6kcaDbw71bMFY2zy6p6F678nkZfK4yzzZrz1ej136/T+TACxUSVYwZ5DwOQcBpaanMeOmt/AE6CIaOYgi1HwACLM9oqWo12Ztq3SfY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689783; c=relaxed/simple;
	bh=6n+OngFmmbP+Dw1XzvTK/BDDrMreBDWb/qqniRIyRMQ=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=bk7p94e1kQHDhQzZeMbw6MqPFggL/0dxBTrDAyzgibyeXtvxpv7Fx2PdxR0Gw2ftDbqcrmW4VzziVvjnp3TPTekI01gGJ8LMHXR9EuiuKjxq5mJ1xFmsRLr7jdd2y2lfC4wutEAm+vFE550ItHmSkajs9rbSJdO/sQCGtriCuR4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=eUV9oAo6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="eUV9oAo6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 72100C4CEEB;
	Mon, 19 May 2025 21:23:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689782;
	bh=6n+OngFmmbP+Dw1XzvTK/BDDrMreBDWb/qqniRIyRMQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=eUV9oAo67Clmf9ptaMkKfGs9Ks29RAo1yQ/Yw6ZhSZHvC7R4H2oX5gshu0BFRrNtV
	 PwpgQh1F+A49VIGWegexvkmLctqnvBkCiBGMNfyHSVxGTucZYSXBbiDQKlC0elQ1Q4
	 jcj5Ku5iOOyBUM1t9Nd8q3aSpCpKvqRXlXXLv/ITgh2DqpTFIuRiXTocVn0XvISCCl
	 QirUl/h1S57FvMCccvZmPOiki34CmAGB7RITfLz7t8Pxhqp3XEi0OSzjZyjE0vk9K5
	 Dk9BKoEOm1uaXWd0NRRJ5KRf90k2Hgy151X9BMXIkjUcGfrJc2ymFlsg2hVRKU0f23
	 atipN4XPKS0xQ==
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
Subject: [PATCH AUTOSEL 6.1 4/8] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:22:51 -0400
Message-Id: <20250519212255.1986527-4-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212255.1986527-1-sashal@kernel.org>
References: <20250519212255.1986527-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.1.139
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

