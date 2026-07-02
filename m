Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BE6D3318EC1;
	Thu,  2 Jul 2026 16:56:57 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1783011419; cv=none; b=pDM9F3bdDXo+tG1nArZmNmpARYrzLpzx199xfZsgZIVGs4o5ZkVaGh+9U6INI5crSbVpGGc8O9OdGBaVgX1ArVH11aUsvmySyXebA58377/F8SN0CfLTCoORpMVclY5tX96SVhEfFVU9r+E9On0is8zCEUBB6+YjEYH4qmtDAKU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1783011419; c=relaxed/simple;
	bh=dJBI+yulwnWf58WRTzPHSb3/WOlhUPB3GK01aL3hR5s=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=MQ0oTLJDRi9hQK4qmtUBXLyNobs7XgA2kUOhFkTsquK6RzqJkiFzZe0bG5G/S50nK3omDotBt7RLyc0jhYnFkwhHzFUN8SsWadZFW24ZzBBIAq/l1MVjg7dsEdhH6O6IXlMkOQa8TGSS39WGlSvmw+L85oIkcVhI4cX+c7oUnEE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=opxgfHM0; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="opxgfHM0"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DF7C01F00A3A;
	Thu,  2 Jul 2026 16:56:56 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1783011417;
	bh=bbssPvm1qspJE9I3snqFyAuuJj46Qg5EL8tcgOtdf4M=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=opxgfHM05WUGISwxLxcuRI8pJpKL5qvaVrQFBQ8Qv+GJd1AXVUfXv5e+pMegI8oEE
	 OdGUJYFuFtgmVJpVxViUe5m37f5gr5e54IzhL99p6lfDzgCyU7WeIgSUYrDMnqi35t
	 daHmvknP3gPNxTWWo1rAVFFRLcwpCxTvWZ+1FzaI=
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
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 6.18 047/108] gcov: use atomic counter updates to fix concurrent access crashes
Date: Thu,  2 Jul 2026 18:20:44 +0200
Message-ID: <20260702155113.083195748@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260702155112.110058792@linuxfoundation.org>
References: <20260702155112.110058792@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Konstantin Khorenko <khorenko@virtuozzo.com>

commit 56cb9b7d96b28a1173a510ab25354b6599ad3a33 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 Makefile |   27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

--- a/Makefile
+++ b/Makefile
@@ -806,12 +806,6 @@ endif # KBUILD_EXTMOD
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
@@ -1082,6 +1076,27 @@ endif
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
 # change __FILE__ to the relative path to the source directory
 ifdef building_out_of_srctree
 KBUILD_CPPFLAGS += $(call cc-option,-fmacro-prefix-map=$(srcroot)/=)


