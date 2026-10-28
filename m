Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1793215164;
	b=aIdJOahM27dZTi3AKe5CeSP1gfJiuzJEUEHogz9w3/zoO1w07w2QcxDj3Lm50rn0X7DN
	 phc8IOd1qCI1FPvYusyG9Nuc3mF71u8kxjjBS5OSVXS3CPXm+AbSlbQZ2IwRHzjsKZGIt
	 fTW1a027SKIGpARxKA/+RIMYsO1gcRawnnxrAEkz+MZRxb/bNlWixvu4pJtP3Gtvjm5Cy
	 3JBQc46cVVh2Ml7hBxNZs+/yy++AleCDxSp5zkfUHBBEWbtCfMB+CyXxVlz1ndkKzokI/
	 KDA8QxiRKvXEzAnTtoJY5auWxjU5fRUI/Wp4zu/jKMyOSa3E4WWKd6c64Htfd1LDdJw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1793215164;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Type:Content-Transfer-Encoding;
	bh=oeCBKU1PA+LHgd4E+QoiVb7ILB+8izEciksgwKEYVOQ=;
	b=n/LKdX7YOpWGkwu9JoPj5wxPK0iN3mY8dlsRXKUoyIbl8dg3WsemoAIJCOK//H7U97XJ
	 qFtAOxaQ2l7AbJgTYV58hPog3y1NaxiTGZMBShCwmrtVpGQ+tYbejhNiWVdcXXqGD9hVk
	 +gwhxJlKognunGsBwih7wsh4Nc5N+WUz0y30tkbVqT9J4DDSUy1MKZICB7VcarMZYcjEt
	 wTQH0G4uv0pvAGnAn9isUqaeKY9jWo8LBO32JYozRZvyepUm0Ay0JOKiEayK/fpkj2kP1
	 x5D1zGrFVre89Cu+PvNQK6ywJQcE6kwtyg2Cw5RQN4z8pOLD4d1l+0sNurIGtUTiSPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnvbj5cX;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 88D87606A31A;
	Wed, 28 Oct 2026 19:19:24 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key, unprotected) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=tnvbj5cX
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D30641F01825;
	Wed, 28 Oct 2026 19:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1793215164;
	bh=oeCBKU1PA+LHgd4E+QoiVb7ILB+8izEciksgwKEYVOQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=tnvbj5cXdHlDlD/mwrOXxwhlnth/el0t08tCB5C1k8co+vHhn2O8EGLcfU41H7grO
	 28xTOxl/+Ov07MAUdnp9gMrQDPd9NVyVKnptJBFXgbqy5de1Nz4bwj9iTqrUQn1lVd
	 7EPfa01kX2DYsemZX8HgIcifKbxuuOyOST1VTzGg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Konstantin Khorenko <khorenko@virtuozzo.com>,
	Arnd Bergmann <arnd@arndb.de>,
	Peter Oberparleiter <oberpar@linux.ibm.com>,
	Masahiro Yamada <masahiroy@kernel.org>,
	Miguel Ojeda <ojeda@kernel.org>,
	Mikhail Zaslonko <zaslonko@linux.ibm.com>,
	Nathan Chancellor <nathan@kernel.org>,
	Pavel Tikhomirov <ptikhomirov@virtuozzo.com>,
	=?UTF-8?q?Thomas=20Wei=C3=9Fschuh?= <linux@weissschuh.net>,
	Andrew Morton <akpm@linux-foundation.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 1115/1887] gcov: use atomic counter updates to fix concurrent access crashes
Date: Wed, 28 Oct 2026 17:53:31 +0100
Message-ID: <20261028170524.776203954@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261028170459.200466217@linuxfoundation.org>
References: <20261028170459.200466217@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khorenko <khorenko@virtuozzo.com>

[ Upstream commit 56cb9b7d96b28a1173a510ab25354b6599ad3a33 ]

GCC's GCOV instrumentation can merge global branch counters with loop
induction variables as an optimization.  In inflate_fast(), the inner copy
loops get transformed so that the GCOV counter value is loaded multiple
times to compute the loop base address, start index, and end bound.  Since
GCOV counters are global (not per-CPU), concurrent execution on different
CPUs causes the counter to change between loads, producing inconsistent
values and out-of-bounds memory writes.

The crash manifests during IPComp (IP Payload Compression) processing when
inflate_fast() runs concurrently on multiple CPUs:

  BUG: unable to handle page fault for address: ffffd0a3c0902ffa
  RIP: inflate_fast+1431
  Call Trace:
   zlib_inflate
   __deflate_decompress
   crypto_comp_decompress
   ipcomp_decompress [xfrm_ipcomp]
   ipcomp_input [xfrm_ipcomp]
   xfrm_input

At the crash point, the compiler generated three loads from the same
global GCOV counter (__gcov0.inflate_fast+216) to compute base, start, and
end for an indexed loop.  Another CPU modified the counter between loads,
making the values inconsistent - the write went 3.4 MB past a 65 KB
buffer.

Add -fprofile-update=prefer-atomic to CFLAGS_GCOV at the global level in
the top-level Makefile, guarded by a try-run compile test.  The test
compiles a minimal program with and without -fprofile-update=prefer-atomic
using the full KBUILD_CFLAGS, then compares undefined symbols in the
resulting object files.  If prefer-atomic introduces new undefined
references (such as __atomic_fetch_add_8 on i386 or __aarch64_ldadd8_relax
on arm64 with outline-atomics), the flag is not added -- the kernel does
not link against libatomic.

On architectures where GCC inlines 64-bit atomic counter updates (x86_64,
s390, ...) the test passes and the flag is enabled, preventing the
compiler from merging counters with loop induction variables and fixing
the observed concurrent-access crash.

On architectures where the flag would introduce libatomic dependencies, it
is silently omitted and behaviour is no worse than before this patch.

Move the CFLAGS_GCOV block from its original position (before the arch
Makefile include) to after the core KBUILD_CFLAGS assignments but before
the scripts/Makefile.gcc-plugins include.  This placement ensures the
try-run test sees arch-specific flags (-m32, -march=,
-mno-outline-atomics) while avoiding GCC plugin flags (-fplugin=) that
would break the test on clean builds when plugin shared objects do not yet
exist.

Link: https://lore.kernel.org/20260511105052.417187-2-khorenko@virtuozzo.com
Signed-off-by: Konstantin Khorenko <khorenko@virtuozzo.com>
Tested-by: Arnd Bergmann <arnd@arndb.de>
Tested-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Reviewed-by: Peter Oberparleiter <oberpar@linux.ibm.com>
Cc: Masahiro Yamada <masahiroy@kernel.org>
Cc: Miguel Ojeda <ojeda@kernel.org>
Cc: Mikhail Zaslonko <zaslonko@linux.ibm.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Pavel Tikhomirov <ptikhomirov@virtuozzo.com>
Cc: Thomas Weißschuh <linux@weissschuh.net>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 Makefile | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/Makefile b/Makefile
index e4c0c25b58ed0..f77ce14254027 100644
--- a/Makefile
+++ b/Makefile
@@ -760,12 +760,6 @@ endif # KBUILD_EXTMOD
 # Defaults to vmlinux, but the arch makefile usually adds further targets
 all: vmlinux
 
-CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
-ifdef CONFIG_CC_IS_GCC
-CFLAGS_GCOV	+= -fno-tree-loop-im
-endif
-export CFLAGS_GCOV
-
 # The arch Makefiles can override CC_FLAGS_FTRACE. We may also append it later.
 ifdef CONFIG_FUNCTION_TRACER
   CC_FLAGS_FTRACE := -pg
@@ -1090,6 +1084,27 @@ KBUILD_CFLAGS   += $(call cc-option,-Werror=designated-init)
 # Ensure compilers do not transform certain loops into calls to wcslen()
 KBUILD_CFLAGS += -fno-builtin-wcslen
 
+CFLAGS_GCOV	:= -fprofile-arcs -ftest-coverage
+ifdef CONFIG_CC_IS_GCC
+CFLAGS_GCOV	+= -fno-tree-loop-im
+# Use atomic counter updates to avoid concurrent-access crashes in GCOV.
+# Only enable if -fprofile-update=prefer-atomic does not introduce new
+# undefined symbols (e.g. libatomic calls that the kernel cannot link).
+CFLAGS_GCOV	+= $(call try-run,\
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
+	-ftest-coverage -x c - -c -o "$$TMP.base" && \
+	echo 'long long x; void f(void){x++;}' | \
+	$(CC) $(KBUILD_CPPFLAGS) $(KBUILD_CFLAGS) -w -fprofile-arcs \
+	-ftest-coverage -fprofile-update=prefer-atomic \
+	-x c - -c -o "$$TMP" && \
+	$(NM) "$$TMP.base" | grep ' U ' > "$$TMP.ubase" || true ; \
+	$(NM) "$$TMP" | grep ' U ' > "$$TMP.utest" || true ; \
+	cmp -s "$$TMP.ubase" "$$TMP.utest",\
+	-fprofile-update=prefer-atomic)
+endif
+export CFLAGS_GCOV
+
 # change __FILE__ to the relative path from the srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srctree)/=)
 
-- 
2.53.0



