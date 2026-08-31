Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 04AA44A091E;
	Mon, 31 Aug 2026 13:41:26 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1788183687; cv=none; b=NMT9NaG/MxbSHIk9Da1B5tybu+AVjlTV2xh8ayViFrnfwXmJa8MFUkjmgEyBufa8xvVRDlarvW304QDBRee4Pwz5P9bO1xs9wdjgcOProi8ah7Gce/ZtdLfWJmB+zd3WaoDlHFwmmC9ai2PQI20ITeZd5xbXl0mis+1mzaQnWb8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1788183687; c=relaxed/simple;
	bh=A1hh+CD7x3LpgV4+uOTUBGoXfdv9u9dkdcHNldMn9pY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=hqeTYzUTaZXwKu2OsDmrA2OlPpFdalif7EY8kk6xrN3/ScgI0zUccYUSJarkfZI1xZo8TXQxHddzfD/DAR847qyVs1ONQcduxxGH8+Aj335uj26O9i90BMqiqNN56A4JOEv4kFF651P5rSbXpGskE60t8fxeBrxU/hHwVH35Is4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=XuzOlX4a; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="XuzOlX4a"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 54AEC1F00A3E;
	Mon, 31 Aug 2026 13:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1788183685;
	bh=rNh5mxLYlO5GcYy8jBTdvIjFhOZ5rYyH0R1+r0LewBg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=XuzOlX4awYRSQ3njq4qy9kgj7cBtK+HEygej5RUILeTZexqYm7zWBArTlrAWKaFjq
	 g2f5OhzUd9ikiqgSXs6nve/5UmIVnAJAK//aef3P01/tKZOzHq2/2RPrQ903eyu2Ns
	 qxUgxGxk3EPDJvxgj8FK61RidDb872QFoOfB5Jhw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taegu Ha <hataegu0826@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 01/76] bpf: reject overlarge global subprog argument sizes
Date: Mon, 31 Aug 2026 15:33:33 +0200
Message-ID: <20260831133359.260482182@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260831133359.185608553@linuxfoundation.org>
References: <20260831133359.185608553@linuxfoundation.org>
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

From: Taegu Ha <hataegu0826@gmail.com>

[ Upstream commit de36adca634634c205a9eb8b56a28175ab7abf5f ]

Global subprogram argument checking derives generic pointer sizes from BTF
and passes the resolved size to check_mem_reg() as a u32. The access-size
validation path then uses a signed int, and stack pointers negate the value
before calling check_helper_mem_access().

This creates a wrap when BTF describes a pointee size larger than S32_MAX.
For example, a global subprogram argument of type:

  int (*p)[0x3fffffff]

has a BTF-resolved pointee size of 0xfffffffc bytes. At a call site the
caller can pass a pointer to a 4-byte stack slot at fp-4. The current
PTR_TO_STACK path computes:

  size = -(int)mem_size

so 0xfffffffc becomes -4 as a signed int and the negation validates only
a 4-byte stack range. That range is covered by the caller's stack slot,
so the call is accepted.

The callee is then verified independently with R1 as PTR_TO_MEM and
mem_size 0xfffffffc. A small instruction such as:

  r0 = *(u32 *)(r1 + 4)

is accepted as being inside that BTF-described memory region. At run time,
however, the actual argument value is still fp-4, so r1 + 4 addresses fp+0,
outside the 4-byte object that the caller provided.

Reject sizes that cannot be represented by the verifier's signed
access-size API before the stack-specific negation. Add a verifier
regression test for the oversized BTF argument.

[ taegu: Backport to 7.1.y: check_mem_reg() still takes a register number
  and reg_arg_name() is not available. Emit the equivalent R%d diagnostic
  using regno. The patched v7.1.10 kernel builds and the targeted
  verifier_global_subprogs/anon_user_mem_huge_size_invalid selftest passes
  after booting the kernel on x86_64 under QEMU. ]

Fixes: 2cb27158adb3 ("bpf: poison dead stack slots")
Signed-off-by: Taegu Ha <hataegu0826@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Link: https://lore.kernel.org/r/20260528062155.3988156-1-hataegu0826@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c                           |  6 ++++++
 .../bpf/progs/verifier_global_subprogs.c        | 17 +++++++++++++++++
 2 files changed, 23 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 5bad71f003dcc..c4173bf81ee75 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7119,6 +7119,12 @@ static int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg
 	if (bpf_register_is_null(reg))
 		return 0;
 
+	if (mem_size > S32_MAX) {
+		verbose(env, "R%d memory size %u is too large\n",
+			regno, mem_size);
+		return -EACCES;
+	}
+
 	/* Assuming that the register contains a value check if the memory
 	 * access is safe. Temporarily save and restore the register's state as
 	 * the conversion shouldn't be visible to a caller.
diff --git a/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c b/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
index 1e08aff7532e3..0ff8f85b4d461 100644
--- a/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
+++ b/tools/testing/selftests/bpf/progs/verifier_global_subprogs.c
@@ -151,6 +151,23 @@ int anon_user_mem_valid(void *ctx)
 	return subprog_user_anon_mem(&t);
 }
 
+__noinline __weak int subprog_user_anon_mem_huge(int (*p)[0x3fffffff])
+{
+	return p ? (*p)[1] : 0;
+}
+
+SEC("?tracepoint")
+__failure __log_level(2)
+__msg("R1 memory size 4294967292 is too large")
+int anon_user_mem_huge_size_invalid(void *ctx)
+{
+	int (*p)[0x3fffffff];
+	int tiny = 42;
+
+	p = (void *)&tiny;
+	return subprog_user_anon_mem_huge(p) + tiny;
+}
+
 __noinline __weak int subprog_nonnull_ptr_good(int *p1 __arg_nonnull, int *p2 __arg_nonnull)
 {
 	return (*p1) * (*p2); /* good, no need for NULL checks */
-- 
2.53.0



