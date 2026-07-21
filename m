Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 02A9A3264FF;
	Tue, 21 Jul 2026 18:47:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784659676; cv=none; b=Uio3Vtw+/8ovxFPwqp+G62TPbGS9cKrP6Hard2BWzb2hGuBUMTeLbO0AX8AUXQ2vn2+1IpnAkyKWABut4vceonPT19xm91O4s6+92XMOyYD79YqOR3F4pqySnUjmGVE+BRH8/fgvv30Z/OMfsJJla7jdYHCD2/gaReD+KNuboLE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784659676; c=relaxed/simple;
	bh=TFWQ8pObsXAEidOYgSQTAIV2EsoxE7emok9nvLPe2Yc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=cmRekMv5tmNc15Jvglb8KlO8JRVTzGlH1YQrOzkCyYFgbD8BrcgQ0PLEF9mbbb/BzOJnfiWcI7D/ZYE4uxiQMf/zuDn+XEOFmYNNRG+dZ4r/0hCW593uM9IEXHMpzHFSsWzigeJByiAYwPWf5Fj4hJxE7UUfJMHdnxloFc3xjP8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=P+jIysSU; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="P+jIysSU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9DD821F000E9;
	Tue, 21 Jul 2026 18:47:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784659672;
	bh=7X4IUQnELY5EU0/m2PKrOe0BSoELa5Ak3LxBY9N93rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=P+jIysSUNh+892hwj7fOiwGYmJnllpFCtwR6Jtmg9Ll5Q5xaeEnbZwc9BXqAss68p
	 kX8NuohASff084Ba7SecORRG28UarVqlDvh1qloadpWIFEpr7Fb7jrFOIFYy40WQee
	 8zOr7J8xU9/9TzdvCCQc+Kh3e0xlrfAwKPrBsOYc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Thomas Richter <tmricht@linux.ibm.com>,
	Namhyung Kim <namhyung@kernel.org>,
	Alexander Gordeev <agordeev@linux.ibm.com>,
	Heiko Carstens <hca@linux.ibm.com>,
	Jan Polensky <japo@linux.ibm.com>,
	linux-s390@vger.kernel.org,
	Sumanth Korikkar <sumanthk@linux.ibm.com>,
	Vasily Gorbik <gor@linux.ibm.com>,
	Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6.18 1608/1611] perf callchain: Handle multiple address spaces
Date: Tue, 21 Jul 2026 17:28:44 +0200
Message-ID: <20260721152551.644487393@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152514.750365251@linuxfoundation.org>
References: <20260721152514.750365251@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

commit ae15db3e9b639491007cc1e9e99638e4b6091781 upstream.

perf test 'perf inject to convert DWARF callchains to regular ones'
fails on s390. It was introduced with commit 92ea788d2af4e65a ("perf
inject: Add --convert-callchain option")

The failure comes the difference in output. Without the inject script to
convert DWARF the callchains is:

 # perf record -F 999 --call-graph dwarf -- perf test -w noploop
 # perf report -i perf.data --stdio --no-children -q \
					 --percent-limit=1 > /tmp/111
 # cat /tmp/111
    99.30%  perf-noploop  perf               [.] noploop
            |
            ---noploop
               run_workload (inlined)
               cmd_test
               run_builtin (inlined)
               handle_internal_command
               run_argv (inlined)
               main
               __libc_start_call_main
               __libc_start_main_impl (inlined)
               _start
 #

With the inject script step the output is:

 # perf inject -i perf.data --convert-callchain -o /tmp/perf-inject-1.out
 # perf report -i /tmp/perf-inject-1.out --stdio --no-children -q \
		--percent-limit=1 > /tmp/222
 # cat /tmp/222
    99.40%  perf-noploop  perf               [.] noploop
            |
            ---noploop
               run_workload (inlined)
               cmd_test
               run_builtin (inlined)
               handle_internal_command
               run_argv (inlined)
               main
               _start
 # diff /tmp/111 /tmp/222
 1c1
 <     99.30%  perf-noploop  perf               [.] noploop
 ---
 >     99.40%  perf-noploop  perf               [.] noploop
 10,11d9
 <                __libc_start_call_main
 <                __libc_start_main_impl (inlined)
 #

The difference are the symbols __libc_start_call_main and
__libc_start_main_impl.

On x86_64, kernel and user space share a single virtual address space,
with the kernel mapped to the upper end of memory. The instruction
pointer value alone is sufficient to distinguish between user space and
kernel space addresses.

This is not true for s390, which uses separate address spaces for user
and kernel.

The same virtual address can be valid in both address spaces, so the
instruction pointer value alone cannot determine whether an address
belongs to the kernel or user space.

Instead, perf must rely on the cpumode metadata derived from the
processor status word (PSW) at sample time.

In function perf_event__convert_sample_callchain() the first part
copies a kernel callchain and context entries, if any.

It then appends additional entries ignoring the address space
architecture. Taking that into account, the symbols at addresses

   0x3ff970348cb __libc_start_call_main
   0x3ff970349c5 __libc_start_main_impl

(located after the kernel address space on s390) are now included.

Output before:

 # perf test 83
 83: perf inject to convert DWARF callchains to regular ones : FAILED!

Output after:
 # perf test 83
 83: perf inject to convert DWARF callchains to regular ones : Ok

Question to Namhyung:

In function perf_event__convert_sample_callchain() just before the
for() loop this patch modifies, the kernel callchain is copied,
see this comment and the next 5 lines:

   /* copy kernel callchain and context entries */

Then why is machine__kernel_ip() needed in the for() loop, when
the kernel entries have been copied just before the loop?

Note: This patch was tested on x86_64 virtual machine and succeeded.

Fixes: 92ea788d2af4e65a ("perf inject: Add --convert-callchain option")
Signed-off-by: Thomas Richter <tmricht@linux.ibm.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Alexander Gordeev <agordeev@linux.ibm.com>
Cc: Heiko Carstens <hca@linux.ibm.com>
Cc: Jan Polensky <japo@linux.ibm.com>
Cc: linux-s390@vger.kernel.org
Cc: Sumanth Korikkar <sumanthk@linux.ibm.com>
Cc: Vasily Gorbik <gor@linux.ibm.com>
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/perf/arch/common.c    |    4 +++-
 tools/perf/builtin-inject.c |    3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -237,5 +237,7 @@ int perf_env__lookup_objdump(struct perf
  */
 bool perf_env__single_address_space(struct perf_env *env)
 {
-	return strcmp(perf_env__arch(env), "sparc");
+	const char *arch = perf_env__arch(env);
+
+	return strcmp(arch, "s390") && strcmp(arch, "sparc");
 }
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -555,7 +555,8 @@ static int perf_event__convert_sample_ca
 
 	node = cursor->first;
 	for (k = 0; k < cursor->nr && i < PERF_MAX_STACK_DEPTH; k++) {
-		if (machine__kernel_ip(machine, node->ip))
+		if (machine->single_address_space &&
+		    machine__kernel_ip(machine, node->ip))
 			/* kernel IPs were added already */;
 		else if (node->ms.sym && node->ms.sym->inlined)
 			/* we can't handle inlined callchains */;


