Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1F20279C0
	for <patches@lists.linux.dev>; Wed, 30 Nov 2022 18:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96111C433D6;
	Wed, 30 Nov 2022 18:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1669833650;
	bh=V0JtBzyNcM8vdmPVOHLs2Qx6zVmUQfzvpE48LVouQzw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=C+kGq6TrQTELpBhRezp/wW3GY6Nw/2FJsDM3IoSIKA0HL3udHRHSONyCUlH/H6HLd
	 E3yt78B9kM0JaR0DTFf6PDQyAjGBgu4VfOWakWoQ3hAGWLWe1nyUn1ux7riupsvhv7
	 FVAfySIDWJb5BrVvDC5LO/ldkdprJaGn8ZczF+r4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexandre Belloni <alexandre.belloni@bootlin.com>,
	Sean Christopherson <seanjc@google.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 135/206] init/Kconfig: fix CC_HAS_ASM_GOTO_TIED_OUTPUT test with dash
Date: Wed, 30 Nov 2022 19:23:07 +0100
Message-Id: <20221130180536.474994719@linuxfoundation.org>
X-Mailer: git-send-email 2.38.1
In-Reply-To: <20221130180532.974348590@linuxfoundation.org>
References: <20221130180532.974348590@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Alexandre Belloni <alexandre.belloni@bootlin.com>

[ Upstream commit 534bd70374d646f17e2cebe0e6e4cdd478ce4f0c ]

When using dash as /bin/sh, the CC_HAS_ASM_GOTO_TIED_OUTPUT test fails
with a syntax error which is not the one we are looking for:

<stdin>: In function ‘foo’:
<stdin>:1:29: warning: missing terminating " character
<stdin>:1:29: error: missing terminating " character
<stdin>:2:5: error: expected ‘:’ before ‘+’ token
<stdin>:2:7: warning: missing terminating " character
<stdin>:2:7: error: missing terminating " character
<stdin>:2:5: error: expected declaration or statement at end of input

Removing '\n' solves this.

Fixes: 1aa0e8b144b6 ("Kconfig: Add option for asm goto w/ tied outputs to workaround clang-13 bug")
Signed-off-by: Alexandre Belloni <alexandre.belloni@bootlin.com>
Reviewed-by: Sean Christopherson <seanjc@google.com>
Signed-off-by: Masahiro Yamada <masahiroy@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 init/Kconfig | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/init/Kconfig b/init/Kconfig
index d19ed66aba3b..a4144393717b 100644
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -80,7 +80,7 @@ config CC_HAS_ASM_GOTO_OUTPUT
 config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	depends on CC_HAS_ASM_GOTO_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
-	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .\n": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
+	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
-- 
2.35.1



