Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E5C8510A22;
	Sat,  3 Feb 2024 04:09:25 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706933366; cv=none; b=l1kcnpLs1+EOlFhkkFfITxGILiJVl7QzCMLbhI+5xOe8SZv+c+mGA3UDDVsCqvap9N68kcrK3iuuJZoUCyWJLN7jFLnQaUI7H9p4UecBsnc3Mx1uTehl21/5JV3KVT5ihPLpRm0RdncIWi2NyzSwzzhvyet7DiP5ce39cf9aOYI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706933366; c=relaxed/simple;
	bh=aiLsS1FX/fxaxYYFSvSTqFIUgh/dpRbs9WDFE07S5y0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Ma5IepKi6h7vo3QwmBvpq2cejq7H02XH0/TBrMqkfRayRnBvod95JN2dqlZVoMvfFF3d6MLQ5iKA3ibNK3+Gev6p8BGg3EN5FQZcWn3wAOf3TiZb//uyFeBSDU+l13tLM7SSABns9sxAeTSywrEGh6rhaHNY+lLhaNKwpJ6F6fM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=fPfXoE1m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="fPfXoE1m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AEB03C43390;
	Sat,  3 Feb 2024 04:09:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706933365;
	bh=aiLsS1FX/fxaxYYFSvSTqFIUgh/dpRbs9WDFE07S5y0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=fPfXoE1m6EVnWl3hBTX26gSHd05FBNJhR1DFgKEo/2Onaw0rLh0Icn09jx4D3Ukht
	 /4OeTMi3bcGzapsD2bvaUvwOK4k2dr2KCAws8n31PfCiGX5xT0rMBFgxA1C5b1Rq6o
	 yVo27238hihTTwvpv0n3O32FaRZZ4cxMjve3GgtM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Yonghong Song <yonghong.song@linux.dev>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alan Maguire <alan.maguire@oracle.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 047/219] selftests/bpf: Fix pyperf180 compilation failure with clang18
Date: Fri,  2 Feb 2024 20:03:40 -0800
Message-ID: <20240203035323.314312178@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240203035317.354186483@linuxfoundation.org>
References: <20240203035317.354186483@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Yonghong Song <yonghong.song@linux.dev>

[ Upstream commit 100888fb6d8a185866b1520031ee7e3182b173de ]

With latest clang18 (main branch of llvm-project repo), when building bpf selftests,
    [~/work/bpf-next (master)]$ make -C tools/testing/selftests/bpf LLVM=1 -j

The following compilation error happens:
    fatal error: error in backend: Branch target out of insn range
    ...
    Stack dump:
    0.      Program arguments: clang -g -Wall -Werror -D__TARGET_ARCH_x86 -mlittle-endian
      -I/home/yhs/work/bpf-next/tools/testing/selftests/bpf/tools/include
      -I/home/yhs/work/bpf-next/tools/testing/selftests/bpf -I/home/yhs/work/bpf-next/tools/include/uapi
      -I/home/yhs/work/bpf-next/tools/testing/selftests/usr/include -idirafter
      /home/yhs/work/llvm-project/llvm/build.18/install/lib/clang/18/include -idirafter /usr/local/include
      -idirafter /usr/include -Wno-compare-distinct-pointer-types -DENABLE_ATOMICS_TESTS -O2 --target=bpf
      -c progs/pyperf180.c -mcpu=v3 -o /home/yhs/work/bpf-next/tools/testing/selftests/bpf/pyperf180.bpf.o
    1.      <eof> parser at end of file
    2.      Code generation
    ...

The compilation failure only happens to cpu=v2 and cpu=v3. cpu=v4 is okay
since cpu=v4 supports 32-bit branch target offset.

The above failure is due to upstream llvm patch [1] where some inlining behavior
are changed in clang18.

To workaround the issue, previously all 180 loop iterations are fully unrolled.
The bpf macro __BPF_CPU_VERSION__ (implemented in clang18 recently) is used to avoid
unrolling changes if cpu=v4. If __BPF_CPU_VERSION__ is not available and the
compiler is clang18, the unrollng amount is unconditionally reduced.

  [1] https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c607313a566eebb16e

Signed-off-by: Yonghong Song <yonghong.song@linux.dev>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Tested-by: Alan Maguire <alan.maguire@oracle.com>
Link: https://lore.kernel.org/bpf/20231110193644.3130906-1-yonghong.song@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 tools/testing/selftests/bpf/progs/pyperf180.c | 22 +++++++++++++++++++
 1 file changed, 22 insertions(+)

diff --git a/tools/testing/selftests/bpf/progs/pyperf180.c b/tools/testing/selftests/bpf/progs/pyperf180.c
index c39f559d3100..42c4a8b62e36 100644
--- a/tools/testing/selftests/bpf/progs/pyperf180.c
+++ b/tools/testing/selftests/bpf/progs/pyperf180.c
@@ -1,4 +1,26 @@
 // SPDX-License-Identifier: GPL-2.0
 // Copyright (c) 2019 Facebook
 #define STACK_MAX_LEN 180
+
+/* llvm upstream commit at clang18
+ *   https://github.com/llvm/llvm-project/commit/1a2e77cf9e11dbf56b5720c607313a566eebb16e
+ * changed inlining behavior and caused compilation failure as some branch
+ * target distance exceeded 16bit representation which is the maximum for
+ * cpu v1/v2/v3. Macro __BPF_CPU_VERSION__ is later implemented in clang18
+ * to specify which cpu version is used for compilation. So a smaller
+ * unroll_count can be set if __BPF_CPU_VERSION__ is less than 4, which
+ * reduced some branch target distances and resolved the compilation failure.
+ *
+ * To capture the case where a developer/ci uses clang18 but the corresponding
+ * repo checkpoint does not have __BPF_CPU_VERSION__, a smaller unroll_count
+ * will be set as well to prevent potential compilation failures.
+ */
+#ifdef __BPF_CPU_VERSION__
+#if __BPF_CPU_VERSION__ < 4
+#define UNROLL_COUNT 90
+#endif
+#elif __clang_major__ == 18
+#define UNROLL_COUNT 90
+#endif
+
 #include "pyperf.h"
-- 
2.43.0



