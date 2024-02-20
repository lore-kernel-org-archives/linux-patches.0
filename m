Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 86D2614A4E6;
	Tue, 20 Feb 2024 21:27:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1708464420; cv=none; b=UjdKMn03JJwvsy8kLw3j2ILGIIj97tsM6Ll8YcGkCJRmv3AHzHi/otGRij9ZW4I7bUqNgtTHqQZepUwsbU2xPcuRsYjzyi0r1Xyb/3saKOUNjVvuwxZ80PSR1gYKI90tFRuVzMfizHY5hOrXvorwHMY1QcUHmR8AnsTh+XHLy04=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1708464420; c=relaxed/simple;
	bh=/zGf6fv+hr1oGxlkTRd/9UJw2rRDtWq3rElwPcNfBWY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cvzkFfnp1ozeczbtHWIqNTdhBqIajhEoDUaX/x5KxQMdKBrlD08kEQ8Z65BEiTbSVIXvcmLz9qiR6iKT+gMJz6rbZ0VEowdiPwLThKihm8AFxdm4En0KzRqqBqpzde274Atp8kW08pPul352xcb6jr+Bu5PNumsGiYDk4+NGWNY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lY3duZcY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lY3duZcY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F2821C433C7;
	Tue, 20 Feb 2024 21:26:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1708464420;
	bh=/zGf6fv+hr1oGxlkTRd/9UJw2rRDtWq3rElwPcNfBWY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lY3duZcY38M4fQoivuuNcX4a+tdHnpqGsIAeOtmJjrnFy7fo8fqbWGrmXTGPlCyDt
	 uqjVIoUgZIpLv2wg8cuIvagoVtHSrEB//5yweEvpZOsCQ28Ax3yt86TC5GY/+8enJr
	 Jr8jSs1WBQCVwwX4K2AKjQPsMUNnaW38YFWfkvn0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Jakub Jelinek <jakub@redhat.com>,
	Uros Bizjak <ubizjak@gmail.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Sean Christopherson <seanjc@google.com>,
	Andrew Pinski <quic_apinski@quicinc.com>,
	Linus Torvalds <torvalds@linux-foundation.org>
Subject: [PATCH 6.7 002/309] update workarounds for gcc "asm goto" issue
Date: Tue, 20 Feb 2024 21:52:41 +0100
Message-ID: <20240220205633.183123838@linuxfoundation.org>
X-Mailer: git-send-email 2.43.2
In-Reply-To: <20240220205633.096363225@linuxfoundation.org>
References: <20240220205633.096363225@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.7-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Linus Torvalds <torvalds@linux-foundation.org>

commit 68fb3ca0e408e00db1c3f8fccdfa19e274c033be upstream.

In commit 4356e9f841f7 ("work around gcc bugs with 'asm goto' with
outputs") I did the gcc workaround unconditionally, because the cause of
the bad code generation wasn't entirely clear.

In the meantime, Jakub Jelinek debugged the issue, and has come up with
a fix in gcc [2], which also got backported to the still maintained
branches of gcc-11, gcc-12 and gcc-13.

Note that while the fix technically wasn't in the original gcc-14
branch, Jakub says:

 "while it is true that no GCC 14 snapshots until today (or whenever the
  fix will be committed) have the fix, for GCC trunk it is up to the
  distros to use the latest snapshot if they use it at all and would
  allow better testing of the kernel code without the workaround, so
  that if there are other issues they won't be discovered years later.
  Most userland code doesn't actually use asm goto with outputs..."

so we will consider gcc-14 to be fixed - if somebody is using gcc
snapshots of the gcc-14 before the fix, they should upgrade.

Note that while the bug goes back to gcc-11, in practice other gcc
changes seem to have effectively hidden it since gcc-12.1 as per a
bisect by Jakub.  So even a gcc-14 snapshot without the fix likely
doesn't show actual problems.

Also, make the default 'asm_goto_output()' macro mark the asm as
volatile by hand, because of an unrelated gcc issue [1] where it doesn't
match the documented behavior ("asm goto is always volatile").

Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103979 [1]
Link: https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921 [2]
Link: https://lore.kernel.org/all/20240208220604.140859-1-seanjc@google.com/
Requested-by: Jakub Jelinek <jakub@redhat.com>
Cc: Uros Bizjak <ubizjak@gmail.com>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: Sean Christopherson <seanjc@google.com>
Cc: Andrew Pinski <quic_apinski@quicinc.com>
Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/compiler-gcc.h   |    7 ++++---
 include/linux/compiler_types.h |    9 ++++++++-
 init/Kconfig                   |    9 +++++++++
 3 files changed, 21 insertions(+), 4 deletions(-)

--- a/include/linux/compiler-gcc.h
+++ b/include/linux/compiler-gcc.h
@@ -67,10 +67,9 @@
 /*
  * GCC 'asm goto' with outputs miscompiles certain code sequences:
  *
- *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110420
- *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=110422
+ *   https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
  *
- * Work it around via the same compiler barrier quirk that we used
+ * Work around it via the same compiler barrier quirk that we used
  * to use for the old 'asm goto' workaround.
  *
  * Also, always mark such 'asm goto' statements as volatile: all
@@ -80,8 +79,10 @@
  *
  *    https://gcc.gnu.org/bugzilla/show_bug.cgi?id=98619
  */
+#ifdef CONFIG_GCC_ASM_GOTO_OUTPUT_WORKAROUND
 #define asm_goto_output(x...) \
 	do { asm volatile goto(x); asm (""); } while (0)
+#endif
 
 #if defined(CONFIG_ARCH_USE_BUILTIN_BSWAP)
 #define __HAVE_BUILTIN_BSWAP32__
--- a/include/linux/compiler_types.h
+++ b/include/linux/compiler_types.h
@@ -362,8 +362,15 @@ struct ftrace_likely_data {
 #define __member_size(p)	__builtin_object_size(p, 1)
 #endif
 
+/*
+ * Some versions of gcc do not mark 'asm goto' volatile:
+ *
+ *  https://gcc.gnu.org/bugzilla/show_bug.cgi?id=103979
+ *
+ * We do it here by hand, because it doesn't hurt.
+ */
 #ifndef asm_goto_output
-#define asm_goto_output(x...) asm goto(x)
+#define asm_goto_output(x...) asm volatile goto(x)
 #endif
 
 #ifdef CONFIG_CC_HAS_ASM_INLINE
--- a/init/Kconfig
+++ b/init/Kconfig
@@ -89,6 +89,15 @@ config CC_HAS_ASM_GOTO_TIED_OUTPUT
 	# Detect buggy gcc and clang, fixed in gcc-11 clang-14.
 	def_bool $(success,echo 'int foo(int *x) { asm goto (".long (%l[bar]) - .": "+m"(*x) ::: bar); return *x; bar: return 0; }' | $CC -x c - -c -o /dev/null)
 
+config GCC_ASM_GOTO_OUTPUT_WORKAROUND
+	bool
+	depends on CC_IS_GCC && CC_HAS_ASM_GOTO_OUTPUT
+	# Fixed in GCC 14, 13.3, 12.4 and 11.5
+	# https://gcc.gnu.org/bugzilla/show_bug.cgi?id=113921
+	default y if GCC_VERSION < 110500
+	default y if GCC_VERSION >= 120000 && GCC_VERSION < 120400
+	default y if GCC_VERSION >= 130000 && GCC_VERSION < 130300
+
 config TOOLS_SUPPORT_RELR
 	def_bool $(success,env "CC=$(CC)" "LD=$(LD)" "NM=$(NM)" "OBJCOPY=$(OBJCOPY)" $(srctree)/scripts/tools-support-relr.sh)
 


