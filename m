Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDAC3217679;
	Mon, 19 May 2025 21:21:42 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747689702; cv=none; b=l3vECAhS+cICRKkcAxAWDThC9yiftjAynaMs8K2H4DDbzizDtMaJRXOQsphrQXhnhswxvJ/hM45LR//46UxAMT6AI4qkSInpjsivKPNFeNFVzkaqvWUAF9MxFQmo8maSAH0niSgsILF9xyb6US8xk/JhCGoVy3b9ZlBxuOHHzx8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747689702; c=relaxed/simple;
	bh=KYLe2AhfSV9Xk4BDZ17de7Uw/ON1XQ1IFlFIrYLsaaE=;
	h=From:To:Cc:Subject:Date:Message-Id:In-Reply-To:References:
	 MIME-Version; b=hNoGdag+grrqZ0PkwpeQc6ipmj53rZl8oP0Y9cQIinvaBDtG0KTrvo/pHe6z8nWduucT19PngazEiQ9GOymMJc03fctfutaQwrVrjDdYtZ510svKL10ywn9ekbjcN9HMmkPGYpH8QeRopDo+gQhGw3PMfPnU3ESMO09o9q52X4Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=mnktO4p7; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="mnktO4p7"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54678C4CEE9;
	Mon, 19 May 2025 21:21:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1747689702;
	bh=KYLe2AhfSV9Xk4BDZ17de7Uw/ON1XQ1IFlFIrYLsaaE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=mnktO4p7jYkCLPA/j/1pJYX7XVHlzNSGhtYiTmrysDZdLnmQBkbOcZvAAfJWwZoq9
	 4G4bXxMx6s3PoeTb+ASal3OVwJO3YG3Z6Yj2gGFsZxD8063tNoDihu3E71sSnJq7Pk
	 VfrKm3fDHRXptAOwqSe2LwIX6exfrzNFrbP9VcH+d9YiYhU/jDGsl/ikoa6MUjlG+J
	 lQPEJM++w1sjwWzw4qPGFLwnbHNInn1KiRBF1UQjXryiNcn6mIV/vEp4gtmbnh6m/f
	 nMTg5QMhGcVQWNv0U34M5AMfqPc29kxDmIfBVf2pvO30uoCIX308cjKFIifyfSueSC
	 iePWuR6cyvV9w==
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
Subject: [PATCH AUTOSEL 6.14 07/23] um: let 'make clean' properly clean underlying SUBARCH as well
Date: Mon, 19 May 2025 17:21:14 -0400
Message-Id: <20250519212131.1985647-7-sashal@kernel.org>
X-Mailer: git-send-email 2.39.5
In-Reply-To: <20250519212131.1985647-1-sashal@kernel.org>
References: <20250519212131.1985647-1-sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
X-stable-base: Linux 6.14.7
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
index 1d36a613aad83..9ed792e565c91 100644
--- a/arch/um/Makefile
+++ b/arch/um/Makefile
@@ -154,5 +154,6 @@ MRPROPER_FILES += $(HOST_DIR)/include/generated
 archclean:
 	@find . \( -name '*.bb' -o -name '*.bbg' -o -name '*.da' \
 		-o -name '*.gcov' \) -type f -print | xargs rm -f
+	$(Q)$(MAKE) -f $(srctree)/Makefile ARCH=$(HEADER_ARCH) clean
 
 export HEADER_ARCH SUBARCH USER_CFLAGS CFLAGS_NO_HARDENING DEV_NULL_PATH
-- 
2.39.5

