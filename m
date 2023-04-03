Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 766AF6FA1
	for <patches@lists.linux.dev>; Mon,  3 Apr 2023 14:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2FC9C4339C;
	Mon,  3 Apr 2023 14:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1680532050;
	bh=W6ODByCyA/flrcRmuzoRnVse67s+Ev0Rk1mocG6tYJ8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Qu423GaLAMrC6QtwlD8qyjd5Z39WhyJXfmTlUWpsWNc/JU4vPJNEle7HvQS6RBHLU
	 LcAAzyQ7SGLQUPFFqg+TSBeWlxN+TzBMEXw/xtVDleOFM1OpF3Nizty5CDdqm77HHv
	 N5hGwK2WBc3O/c5/Cg7T49l/MMy8issdTDUoX6fg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Marco Elver <elver@google.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Alexander Potapenko <glider@google.com>,
	Dmitry Vyukov <dvyukov@google.com>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 107/173] kcsan: avoid passing -g for test
Date: Mon,  3 Apr 2023 16:08:42 +0200
Message-Id: <20230403140417.905091738@linuxfoundation.org>
X-Mailer: git-send-email 2.40.0
In-Reply-To: <20230403140414.174516815@linuxfoundation.org>
References: <20230403140414.174516815@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Marco Elver <elver@google.com>

[ Upstream commit 5eb39cde1e2487ba5ec1802dc5e58a77e700d99e ]

Nathan reported that when building with GNU as and a version of clang that
defaults to DWARF5, the assembler will complain with:

  Error: non-constant .uleb128 is not supported

This is because `-g` defaults to the compiler debug info default. If the
assembler does not support some of the directives used, the above errors
occur. To fix, remove the explicit passing of `-g`.

All the test wants is that stack traces print valid function names, and
debug info is not required for that. (I currently cannot recall why I
added the explicit `-g`.)

Link: https://lkml.kernel.org/r/20230316224705.709984-2-elver@google.com
Fixes: 1fe84fd4a402 ("kcsan: Add test suite")
Signed-off-by: Marco Elver <elver@google.com>
Reported-by: Nathan Chancellor <nathan@kernel.org>
Cc: Alexander Potapenko <glider@google.com>
Cc: Dmitry Vyukov <dvyukov@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/kcsan/Makefile | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/kcsan/Makefile b/kernel/kcsan/Makefile
index c95957741d366..a9b0ee63b6978 100644
--- a/kernel/kcsan/Makefile
+++ b/kernel/kcsan/Makefile
@@ -13,6 +13,6 @@ CFLAGS_core.o := $(call cc-option,-fno-conserve-stack) \
 obj-y := core.o debugfs.o report.o
 obj-$(CONFIG_KCSAN_SELFTEST) += selftest.o
 
-CFLAGS_kcsan-test.o := $(CFLAGS_KCSAN) -g -fno-omit-frame-pointer
+CFLAGS_kcsan-test.o := $(CFLAGS_KCSAN) -fno-omit-frame-pointer
 CFLAGS_kcsan_test.o += $(DISABLE_STRUCTLEAK_PLUGIN)
 obj-$(CONFIG_KCSAN_TEST) += kcsan-test.o
-- 
2.39.2



