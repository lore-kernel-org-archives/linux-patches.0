Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 099DE38910F;
	Tue, 21 Jul 2026 18:54:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1784660070; cv=none; b=DbDHEsuYmZibpwBMUdgIRCz0j0b35f22oWxVqgkiLj4DlKBHaOZKk78/gPDfWsTn9b9t7uFWMQyrliWexRg22057ly10XiaAnBdDYUp4axQxz2fH7JyB9TpT/S9LExsZ1hUG7DmxFesnstQGVWvuRK4UJozibjTIS21i2iYgHVk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1784660070; c=relaxed/simple;
	bh=yxXaBlwJHGAHexFbbikgfnJuXlkDvUyq7E+44m6uwfQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=SJOTe3YqCy2uh26WJs/iZlL5Wrlbv+C5kfgvvfWhL4bap7tudsbYYAbHFDH9Y3o3FZVwqIQllx9tOZPjc6aQmFEsAevaxdoMtA+G6jRx0+8oZXwLBf4kN07Bem9HkE12V4Gegm1DNrg9tCwKCKjVuq6v4/nR3GxTBXPteSRVnfY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=D7Xil7Z3; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="D7Xil7Z3"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 716121F000E9;
	Tue, 21 Jul 2026 18:54:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1784660068;
	bh=lJW/gRIqt/PVgNyu4VFQtb96rVxPMfpAIC5dd7hUDBs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=D7Xil7Z3TpX9/Wuh9Co3b+89wKtNLAdjgh7ttKUErIaksn9YR9v5n+Jc0E6VQ4vFU
	 9JkHYdaMQm2n5x3nBq6Wqc9/2M2I2vIO4mXEGHePO+XTIVoTi024K2NbhIcz1pNija
	 shTV0LHkNhU0YdnS+qMkfv23shJy2vHobKXi6wnQ=
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
	Arnaldo Carvalho de Melo <acme@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 0841/2077] perf callchain: Handle multiple address spaces
Date: Tue, 21 Jul 2026 17:08:34 +0200
Message-ID: <20260721152612.629996611@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260721152552.646164743@linuxfoundation.org>
References: <20260721152552.646164743@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Thomas Richter <tmricht@linux.ibm.com>

[ Upstream commit ae15db3e9b639491007cc1e9e99638e4b6091781 ]

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/perf/arch/common.c    | 4 +++-
 tools/perf/builtin-inject.c | 3 ++-
 2 files changed, 5 insertions(+), 2 deletions(-)

diff --git a/tools/perf/arch/common.c b/tools/perf/arch/common.c
index 21836f70f231e4..ad0cab830a4da3 100644
--- a/tools/perf/arch/common.c
+++ b/tools/perf/arch/common.c
@@ -237,5 +237,7 @@ int perf_env__lookup_objdump(struct perf_env *env, char **path)
  */
 bool perf_env__single_address_space(struct perf_env *env)
 {
-	return strcmp(perf_env__arch(env), "sparc");
+	const char *arch = perf_env__arch(env);
+
+	return strcmp(arch, "s390") && strcmp(arch, "sparc");
 }
diff --git a/tools/perf/builtin-inject.c b/tools/perf/builtin-inject.c
index f174bc69cec453..6ab20df358c43b 100644
--- a/tools/perf/builtin-inject.c
+++ b/tools/perf/builtin-inject.c
@@ -438,7 +438,8 @@ static int perf_event__convert_sample_callchain(const struct perf_tool *tool,
 
 	node = cursor->first;
 	for (k = 0; k < cursor->nr && i < PERF_MAX_STACK_DEPTH; k++) {
-		if (machine__kernel_ip(machine, node->ip))
+		if (machine->single_address_space &&
+		    machine__kernel_ip(machine, node->ip))
 			/* kernel IPs were added already */;
 		else if (node->ms.sym && node->ms.sym->inlined)
 			/* we can't handle inlined callchains */;
-- 
2.53.0



