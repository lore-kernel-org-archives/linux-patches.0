Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9EBCB32D7F8;
	Sat, 12 Sep 2026 18:19:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789237143; cv=none; b=ius/W1Y4jUfEzaGSCx0bxU6BjZqNl7uWKWYbFtdDndfCLGl/TzXOiU9jLI1xcMjNF1F4sNR6Qz4V1niEYrJ3vDjvbAfaK7NrvO8jjNkvSJuq7oWWfb5TfiqvoAC4l9e5cIVT5daeM0FjOg6lOQgarRGnPXe2KCvEcyFMQSNR8lE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789237143; c=relaxed/simple;
	bh=g5MoJKeTxoFR9MsV66jXvJcO5Kv1ggJ6Mhc4ebgt8UU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MgXDdw3k2LABhBT4dJ3MS99D0E+2cPYX3VKlDEGNmq52weCBo9WbLet3q/uhKBIybM/zmjD3U4M1R4TnyJB9ZgMYMmVAkgwSUYaoZGae5UkIv8O83h2O1lkZn+3WCZl7Rpp9hg2A4/z03h46fmmyv43oP6PC904j5W3vhYlPAX8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OJvw5fXI; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OJvw5fXI"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7B4901F000FF;
	Sat, 12 Sep 2026 18:19:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789237142;
	bh=lydVdr2XIbfQ5uBYm3QqYFF9ajlblTzZWiv6nYculcE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OJvw5fXIx+Ey+ZpDhSkmqjgTaWg0vG9Aagmkvgo+NqYEEj0ROgUNyWAMAbzkXtBMi
	 TTxviTIEInBt6VbEgTjpdxVbx+EiIsztYAnZDxylTXR6q8Kl99viMIZI7X8AmBhZlP
	 WqoLpg7Il8OJbM5b3Pb1D8QgkRqg1Gd1pBSiEQkA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nathan Chancellor <nathan@kernel.org>,
	"Mike Rapoport (Microsoft)" <rppt@kernel.org>,
	Kees Cook <kees@kernel.org>,
	Bill Wendling <morbo@google.com>,
	Justin Stitt <justinstitt@google.com>,
	Nick Desaulniers <ndesaulniers@google.com>,
	Andrew Morton <akpm@linux-foundation.org>
Subject: [PATCH 5.15 198/935] arch_numa: avoid false positive fortify warning in setup_node_to_cpumask_map()
Date: Sat, 12 Sep 2026 08:53:48 +0200
Message-ID: <20260912065531.356433869@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065526.833703348@linuxfoundation.org>
References: <20260912065526.833703348@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nathan Chancellor <nathan@kernel.org>

commit f2b1cb39d5ccab090d8353788f186f7e7a1fffd4 upstream.

When building ARCH=riscv using clang with CONFIG_FORTIFY_SOURCE and
CONFIG_UBSAN_BOUNDS enabled, CONFIG_NR_CPUS > 64, and the default value of
2 for CONFIG_NODES_SHIFT, there is a compiletime warning from the fortify
routines.

  In file included from mm/arch_numa.c:11:
  In file included from include/linux/acpi.h:14:
  In file included from include/linux/resource_ext.h:11:
  In file included from include/linux/slab.h:17:
  In file included from include/linux/gfp.h:7:
  In file included from include/linux/mmzone.h:8:
  In file included from include/linux/spinlock.h:60:
  In file included from include/linux/interrupt_rc.h:17:
  In file included from include/linux/smp.h:13:
  In file included from include/linux/cpumask.h:11:
  In file included from include/linux/bitmap.h:13:
  In file included from include/linux/string.h:383:
  include/linux/fortify-string.h:430:4: warning: call to '__write_overflow_field' declared with 'warning' attribute: detected write beyond size of field (1st parameter); maybe use struct_group()? [-Wattribue-warning]
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  include/linux/fortify-string.h:430:4: note: called by function 'fortify_memset_chk(unsigned long, unsigned long, unsigned long)'
  include/linux/bitmap.h:248:3: note: inlined by function 'setup_node_to_cpumask_map'
    248 |                 memset(dst, 0, len);
        |                 ^
  include/linux/fortify-string.h:462:25: note: expanded from macro 'memset'
    462 | #define memset(p, c, s) __fortify_memset_chk(p, c, s,                   \
        |                         ^
  include/linux/fortify-string.h:453:2: note: expanded from macro '__fortify_memset_chk'
    453 |         fortify_memset_chk(__fortify_size, p_size, p_size_field),       \
        |         ^
  include/linux/fortify-string.h:430:4: note: use '-gline-directives-only' (implied by '-g1') or higher for more accurate inlining chain locations
    430 |                         __write_overflow_field(p_size_field, size);
        |                         ^
  1 warning generated.

In this configuration, MAX_NUMNODES is 4.  clang unrolls the for loop in
setup_node_to_cpumask_map() past this, which triggers the fortify check
when accessing node_to_cpumask_map on the theoretical fifth loop iteration
because it would be an out of bounds write.

Make it clear to clang that nr_node_ids is bounded by MAX_NUMNODES due to
the logic in setup_nr_node_ids() by early returning in
setup_node_to_cpumask_map() should that condition be violated.

Link: https://lore.kernel.org/20260813-arch_numa-avoid-fortify-warning-v2-1-093ad97a78df@kernel.org
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Closes: https://github.com/ClangBuiltLinux/linux/issues/2174
Reviewed-by: Mike Rapoport (Microsoft) <rppt@kernel.org>
Cc: Kees Cook <kees@kernel.org>
Cc: Bill Wendling <morbo@google.com>
Cc: Justin Stitt <justinstitt@google.com>
Cc: Nathan Chancellor <nathan@kernel.org>
Cc: Nick Desaulniers <ndesaulniers@google.com>
Cc: <stable@vger.kernel.org>
Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
Signed-off-by: Nathan Chancellor <nathan@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/base/arch_numa.c |   12 ++++++++++++
 1 file changed, 12 insertions(+)

--- a/drivers/base/arch_numa.c
+++ b/drivers/base/arch_numa.c
@@ -105,6 +105,18 @@ static void __init setup_node_to_cpumask
 	if (nr_node_ids == MAX_NUMNODES)
 		setup_nr_node_ids();
 
+	/*
+	 * This check should never be true but it makes it clear to compilers
+	 * that node_to_cpumask_map is bound by nr_node_ids, avoiding false
+	 * positive fortify warnings when accessing node_to_cpumask_map in the
+	 * for loop below.
+	 */
+	if (unlikely(nr_node_ids > MAX_NUMNODES)) {
+		pr_err("nr_node_ids (%u) is larger than MAX_NUMNODES (%u)\n",
+		       nr_node_ids, MAX_NUMNODES);
+		return;
+	}
+
 	/* allocate and clear the mapping */
 	for (node = 0; node < nr_node_ids; node++) {
 		alloc_bootmem_cpumask_var(&node_to_cpumask_map[node]);


