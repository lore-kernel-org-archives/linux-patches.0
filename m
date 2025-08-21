Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8C1A72EAD16;
	Thu, 21 Aug 2025 21:16:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755810988; cv=none; b=FdizWoHrnXRv+64MxsVwiK2NT0h1MbkUIIYvTt2xFw/PYeFI/m8dBLBanboRi2RZjcKd+2YxnEUPiS1d45GOlMOFPK4TrvVdG7u88yg9MOJZLBADteC0BwJ7aSPBLq86+ZNI33gN58q/TGJy/QYX2JZRlikrQO88X1wi1k3m468=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755810988; c=relaxed/simple;
	bh=/FaxCgWn3QZynXYwl6BT/KtUuhJScaSVbC/LfUVi4W0=;
	h=From:Date:Subject:MIME-Version:Content-Type:Message-Id:References:
	 In-Reply-To:To:Cc; b=d+cNOFvYApJB85gZ89tgYq5ywTfqegLNYH8Ek3p0EMIv4z0ViCa6bkR99r1ItMoXFxu6aCEUGy2ng4jCwWrgQXG60D655T2HkjLvItuTvQS8U3SklSb1PGfIshL113erCA3MKGhLQjzpcIf5wENFKhRd3apj3EC92u5ZctgmLBE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=gDZDpVuf; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="gDZDpVuf"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2A358C4CEEB;
	Thu, 21 Aug 2025 21:16:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1755810988;
	bh=/FaxCgWn3QZynXYwl6BT/KtUuhJScaSVbC/LfUVi4W0=;
	h=From:Date:Subject:References:In-Reply-To:To:Cc:From;
	b=gDZDpVuffNi0v19lwBN+668IPRSI9pXSGKcj8YgR1I/mooCWzH1KcC3mLeymG6ipu
	 MlUYE9GPfOHYZxJRF9xwT52Qh7+DlO7opTuWA6Y3XazZhG8KjdXu8+ugvNIwotnMyE
	 GgVFrN5UgVgh8ulOfs8p1TXq5xopkxRm8EPOTys0CySKRQmxK7MGlPxlh2BBHLAG/4
	 dXRQve0ubBmwwkPpaHDLCzPYYfjob0j8ECMcS/MsQtNCjbo02kO6UarYLITiD1vVmt
	 SdsRXIcQn1ULK6tA6e7ZuxxqkZgnxldiJZQ18j1lxuYNko7LD6p3G3ki/FjKHYayf1
	 5X1bM/NPMSrlQ==
From: Nathan Chancellor <nathan@kernel.org>
Date: Thu, 21 Aug 2025 14:15:49 -0700
Subject: [PATCH v2 12/12] KMSAN: Remove tautological checks
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <20250821-bump-min-llvm-ver-15-v2-12-635f3294e5f0@kernel.org>
References: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
In-Reply-To: <20250821-bump-min-llvm-ver-15-v2-0-635f3294e5f0@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Arnd Bergmann <arnd@arndb.de>, Kees Cook <kees@kernel.org>, 
 Nick Desaulniers <nick.desaulniers+lkml@gmail.com>, 
 Bill Wendling <morbo@google.com>, Justin Stitt <justinstitt@google.com>, 
 llvm@lists.linux.dev, patches@lists.linux.dev, 
 Marco Elver <elver@google.com>, Nathan Chancellor <nathan@kernel.org>, 
 kasan-dev@googlegroups.com
X-Mailer: b4 0.15-dev
X-Developer-Signature: v=1; a=openpgp-sha256; l=1830; i=nathan@kernel.org;
 h=from:subject:message-id; bh=/FaxCgWn3QZynXYwl6BT/KtUuhJScaSVbC/LfUVi4W0=;
 b=owGbwMvMwCUmm602sfCA1DTG02pJDBnLe1pcPUNm9W6MDuLs/myrJcfNFJTLWv9E/6ZRWI+r5
 4pje5w7SlkYxLgYZMUUWaofqx43NJxzlvHGqUkwc1iZQIYwcHEKwER0OBj+157XEo/zEZQ9YZU8
 z15PkJ858EdhvfS/qz6rSs+b7NykzfDfXe6x0fb3Xy5P/1MXV231eo2pntlbyVJlX8s71sbm1gb
 sAA==
X-Developer-Key: i=nathan@kernel.org; a=openpgp;
 fpr=2437CB76E544CB6AB3D9DFD399739260CB6CB716

Now that the minimum supported version of LLVM for building the kernel
has been bumped to 15.0.0, two KMSAN checks can be cleaned up.

CONFIG_HAVE_KMSAN_COMPILER will always be true when using clang so
remove the cc-option test and use a simple check for CONFIG_CC_IS_CLANG.

CONFIG_HAVE_KMSAN_PARAM_RETVAL will always be true so it can be removed
outright.

Acked-by: Marco Elver <elver@google.com>
Reviewed-by: Kees Cook <kees@kernel.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
---
Cc: kasan-dev@googlegroups.com
---
 lib/Kconfig.kmsan | 11 +----------
 1 file changed, 1 insertion(+), 10 deletions(-)

diff --git a/lib/Kconfig.kmsan b/lib/Kconfig.kmsan
index 0541d7b079cc..7251b6b59e69 100644
--- a/lib/Kconfig.kmsan
+++ b/lib/Kconfig.kmsan
@@ -3,10 +3,7 @@ config HAVE_ARCH_KMSAN
 	bool
 
 config HAVE_KMSAN_COMPILER
-	# Clang versions <14.0.0 also support -fsanitize=kernel-memory, but not
-	# all the features necessary to build the kernel with KMSAN.
-	depends on CC_IS_CLANG && CLANG_VERSION >= 140000
-	def_bool $(cc-option,-fsanitize=kernel-memory -mllvm -msan-disable-checks=1)
+	def_bool CC_IS_CLANG
 
 config KMSAN
 	bool "KMSAN: detector of uninitialized values use"
@@ -28,15 +25,9 @@ config KMSAN
 
 if KMSAN
 
-config HAVE_KMSAN_PARAM_RETVAL
-	# -fsanitize-memory-param-retval is supported only by Clang >= 14.
-	depends on HAVE_KMSAN_COMPILER
-	def_bool $(cc-option,-fsanitize=kernel-memory -fsanitize-memory-param-retval)
-
 config KMSAN_CHECK_PARAM_RETVAL
 	bool "Check for uninitialized values passed to and returned from functions"
 	default y
-	depends on HAVE_KMSAN_PARAM_RETVAL
 	help
 	  If the compiler supports -fsanitize-memory-param-retval, KMSAN will
 	  eagerly check every function parameter passed by value and every

-- 
2.50.1

