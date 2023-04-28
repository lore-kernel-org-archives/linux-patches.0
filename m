Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B97E9290A
	for <patches@lists.linux.dev>; Fri, 28 Apr 2023 11:28:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3CD74C433D2;
	Fri, 28 Apr 2023 11:28:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1682681316;
	bh=Op2dXB//TRDl8Ibmf7f1Vl/mOLmzqoYEyjRsfAgm2Zw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=gZECbyPkEt5u54HlVKjg5ghm8YnoDZ9rMlqBE72xsaStKUv35QSUCrs+/oZ35Qhvy
	 muXej5cD9X+BeqteiVGfJibtS9G8Dspyq+cf/4d3vZXW586BmNuw8ledAi2cy6ixt/
	 U8ydHmUUYtTihytarmOoVBvkQv377Av7t4PWewqo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Roberto Sassu <roberto.sassu@huaweicloud.com>,
	SeongJae Park <sj@kernel.org>,
	David Gow <davidgow@google.com>,
	Vincenzo Palazzo <vincenzopalazzodev@gmail.com>,
	Arthur Grillo <arthurgrillo@riseup.net>,
	Richard Weinberger <richard@nod.at>
Subject: [PATCH 6.2 02/15] um: Only disable SSE on clang to work around old GCC bugs
Date: Fri, 28 Apr 2023 13:27:46 +0200
Message-Id: <20230428112040.217604155@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230428112040.137898986@linuxfoundation.org>
References: <20230428112040.137898986@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: David Gow <davidgow@google.com>

commit a3046a618a284579d1189af8711765f553eed707 upstream.

As part of the Rust support for UML, we disable SSE (and similar flags)
to match the normal x86 builds. This both makes sense (we ideally want a
similar configuration to x86), and works around a crash bug with SSE
generation under Rust with LLVM.

However, this breaks compiling stdlib.h under gcc < 11, as the x86_64
ABI requires floating-point return values be stored in an SSE register.
gcc 11 fixes this by only doing register allocation when a function is
actually used, and since we never use atof(), it shouldn't be a problem:
https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652

Nevertheless, only disable SSE on clang setups, as that's a simple way
of working around everyone's bugs.

Fixes: 884981867947 ("rust: arch/um: Disable FP/SIMD instruction to match x86")
Reported-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
Link: https://lore.kernel.org/linux-um/6df2ecef9011d85654a82acd607fdcbc93ad593c.camel@huaweicloud.com/
Tested-by: Roberto Sassu <roberto.sassu@huaweicloud.com>
Tested-by: SeongJae Park <sj@kernel.org>
Signed-off-by: David Gow <davidgow@google.com>
Reviewed-by: Vincenzo Palazzo <vincenzopalazzodev@gmail.com>
Tested-by: Arthur Grillo <arthurgrillo@riseup.net>
Signed-off-by: Richard Weinberger <richard@nod.at>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/x86/Makefile.um |    5 +++++
 1 file changed, 5 insertions(+)

--- a/arch/x86/Makefile.um
+++ b/arch/x86/Makefile.um
@@ -3,9 +3,14 @@ core-y += arch/x86/crypto/
 
 #
 # Disable SSE and other FP/SIMD instructions to match normal x86
+# This is required to work around issues in older LLVM versions, but breaks
+# GCC versions < 11. See:
+# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=99652
 #
+ifeq ($(CONFIG_CC_IS_CLANG),y)
 KBUILD_CFLAGS += -mno-sse -mno-mmx -mno-sse2 -mno-3dnow -mno-avx
 KBUILD_RUSTFLAGS += -Ctarget-feature=-sse,-sse2,-sse3,-ssse3,-sse4.1,-sse4.2,-avx,-avx2
+endif
 
 ifeq ($(CONFIG_X86_32),y)
 START := 0x8048000


