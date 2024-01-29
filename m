Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EA817225E;
	Mon, 29 Jan 2024 17:15:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548518; cv=none; b=UcN31nJCKWSXnS51pe0dFcJqjkC5TybN+wKAc9LfJrt+M7cRZ7eRARlwOmyCb52mFolxEmECxx2aSHx8+0Z3bGG+ZcoK+y5AR9DF7YeDdWV41tXJaFnCo5nEo6bmPKA2DwOVBZKKuCdm3aKLrGw/j9wYApw59ZWNhNveHDMlHrA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548518; c=relaxed/simple;
	bh=jOCa2rJ2FNwL3fD2IqAZ14JtthV5B3gUeP+/8e7fCCA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JfS18/ZPsah5yZ01YtQi+9wUqOKdS9zyERCVMQYiQpG4qQbZ5dPfPGXdEatzhpGHbI29HvL+CTrYFmS4C/EmJFU/J3T50ZSqynlqqYeFpme5bR6AzjJPkFEGYl5xOGYOiPQxprQhNrZ7iphBUIRJs0jCsQZcNYpm0vCsjYU1Dgk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=lb8H0ex6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="lb8H0ex6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EDB22C433F1;
	Mon, 29 Jan 2024 17:15:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548518;
	bh=jOCa2rJ2FNwL3fD2IqAZ14JtthV5B3gUeP+/8e7fCCA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=lb8H0ex6QqSisiGNvXLjfCl2TwONzrmhb8+4XZo1E6GZaOXoUh0FDIDYuOUbPovV2
	 EKoQe8Ap3tHTWGF3neviGR0HUsKCflXgh4SLkx5sDuJlCWY54/2wzNAGCwQUM5QfdX
	 riak++kl0QrTPcbr4BjJIX3dvjEAEVvVbhQeze/A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>
Subject: [PATCH 6.6 151/331] selftests/bpf: test if state loops are detected in a tricky case
Date: Mon, 29 Jan 2024 09:03:35 -0800
Message-ID: <20240129170019.341695011@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 64870feebecb7130291a55caf0ce839a87405a70 upstream.

A convoluted test case for iterators convergence logic that
demonstrates that states with branch count equal to 0 might still be
a part of not completely explored loop.

E.g. consider the following state diagram:

               initial     Here state 'succ' was processed first,
                 |         it was eventually tracked to produce a
                 V         state identical to 'hdr'.
    .---------> hdr        All branches from 'succ' had been explored
    |            |         and thus 'succ' has its .branches == 0.
    |            V
    |    .------...        Suppose states 'cur' and 'succ' correspond
    |    |       |         to the same instruction + callsites.
    |    V       V         In such case it is necessary to check
    |   ...     ...        whether 'succ' and 'cur' are identical.
    |    |       |         If 'succ' and 'cur' are a part of the same loop
    |    V       V         they have to be compared exactly.
    |   succ <- cur
    |    |
    |    V
    |   ...
    |    |
    '----'

Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20231024000917.12153-7-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 tools/testing/selftests/bpf/progs/iters.c |  177 ++++++++++++++++++++++++++++++
 1 file changed, 177 insertions(+)

--- a/tools/testing/selftests/bpf/progs/iters.c
+++ b/tools/testing/selftests/bpf/progs/iters.c
@@ -999,6 +999,183 @@ __naked int loop_state_deps1(void)
 }
 
 SEC("?raw_tp")
+__failure
+__msg("math between fp pointer and register with unbounded")
+__flag(BPF_F_TEST_STATE_FREQ)
+__naked int loop_state_deps2(void)
+{
+	/* This is equivalent to C program below.
+	 *
+	 * The case turns out to be tricky in a sense that:
+	 * - states with read+precise mark on c are explored only on a second
+	 *   iteration of the first inner loop and in a state which is pushed to
+	 *   states stack first.
+	 * - states with c=-25 are explored only on a second iteration of the
+	 *   second inner loop and in a state which is pushed to states stack
+	 *   first.
+	 *
+	 * Depending on the details of iterator convergence logic
+	 * verifier might stop states traversal too early and miss
+	 * unsafe c=-25 memory access.
+	 *
+	 *   j = iter_new();             // fp[-16]
+	 *   a = 0;                      // r6
+	 *   b = 0;                      // r7
+	 *   c = -24;                    // r8
+	 *   while (iter_next(j)) {
+	 *     i = iter_new();           // fp[-8]
+	 *     a = 0;                    // r6
+	 *     b = 0;                    // r7
+	 *     while (iter_next(i)) {
+	 *       if (a == 1) {
+	 *         a = 0;
+	 *         b = 1;
+	 *       } else if (a == 0) {
+	 *         a = 1;
+	 *         if (random() == 42)
+	 *           continue;
+	 *         if (b == 1) {
+	 *           *(r10 + c) = 7;     // this is not safe
+	 *           iter_destroy(i);
+	 *           iter_destroy(j);
+	 *           return;
+	 *         }
+	 *       }
+	 *     }
+	 *     iter_destroy(i);
+	 *     i = iter_new();           // fp[-8]
+	 *     a = 0;                    // r6
+	 *     b = 0;                    // r7
+	 *     while (iter_next(i)) {
+	 *       if (a == 1) {
+	 *         a = 0;
+	 *         b = 1;
+	 *       } else if (a == 0) {
+	 *         a = 1;
+	 *         if (random() == 42)
+	 *           continue;
+	 *         if (b == 1) {
+	 *           a = 0;
+	 *           c = -25;
+	 *         }
+	 *       }
+	 *     }
+	 *     iter_destroy(i);
+	 *   }
+	 *   iter_destroy(j);
+	 *   return;
+	 */
+	asm volatile (
+		"r1 = r10;"
+		"r1 += -16;"
+		"r2 = 0;"
+		"r3 = 10;"
+		"call %[bpf_iter_num_new];"
+		"r6 = 0;"
+		"r7 = 0;"
+		"r8 = -24;"
+	"j_loop_%=:"
+		"r1 = r10;"
+		"r1 += -16;"
+		"call %[bpf_iter_num_next];"
+		"if r0 == 0 goto j_loop_end_%=;"
+
+		/* first inner loop */
+		"r1 = r10;"
+		"r1 += -8;"
+		"r2 = 0;"
+		"r3 = 10;"
+		"call %[bpf_iter_num_new];"
+		"r6 = 0;"
+		"r7 = 0;"
+	"i_loop_%=:"
+		"r1 = r10;"
+		"r1 += -8;"
+		"call %[bpf_iter_num_next];"
+		"if r0 == 0 goto i_loop_end_%=;"
+	"check_one_r6_%=:"
+		"if r6 != 1 goto check_zero_r6_%=;"
+		"r6 = 0;"
+		"r7 = 1;"
+		"goto i_loop_%=;"
+	"check_zero_r6_%=:"
+		"if r6 != 0 goto i_loop_%=;"
+		"r6 = 1;"
+		"call %[bpf_get_prandom_u32];"
+		"if r0 != 42 goto check_one_r7_%=;"
+		"goto i_loop_%=;"
+	"check_one_r7_%=:"
+		"if r7 != 1 goto i_loop_%=;"
+		"r0 = r10;"
+		"r0 += r8;"
+		"r1 = 7;"
+		"*(u64 *)(r0 + 0) = r1;"
+		"r1 = r10;"
+		"r1 += -8;"
+		"call %[bpf_iter_num_destroy];"
+		"r1 = r10;"
+		"r1 += -16;"
+		"call %[bpf_iter_num_destroy];"
+		"r0 = 0;"
+		"exit;"
+	"i_loop_end_%=:"
+		"r1 = r10;"
+		"r1 += -8;"
+		"call %[bpf_iter_num_destroy];"
+
+		/* second inner loop */
+		"r1 = r10;"
+		"r1 += -8;"
+		"r2 = 0;"
+		"r3 = 10;"
+		"call %[bpf_iter_num_new];"
+		"r6 = 0;"
+		"r7 = 0;"
+	"i2_loop_%=:"
+		"r1 = r10;"
+		"r1 += -8;"
+		"call %[bpf_iter_num_next];"
+		"if r0 == 0 goto i2_loop_end_%=;"
+	"check2_one_r6_%=:"
+		"if r6 != 1 goto check2_zero_r6_%=;"
+		"r6 = 0;"
+		"r7 = 1;"
+		"goto i2_loop_%=;"
+	"check2_zero_r6_%=:"
+		"if r6 != 0 goto i2_loop_%=;"
+		"r6 = 1;"
+		"call %[bpf_get_prandom_u32];"
+		"if r0 != 42 goto check2_one_r7_%=;"
+		"goto i2_loop_%=;"
+	"check2_one_r7_%=:"
+		"if r7 != 1 goto i2_loop_%=;"
+		"r6 = 0;"
+		"r8 = -25;"
+		"goto i2_loop_%=;"
+	"i2_loop_end_%=:"
+		"r1 = r10;"
+		"r1 += -8;"
+		"call %[bpf_iter_num_destroy];"
+
+		"r6 = 0;"
+		"r7 = 0;"
+		"goto j_loop_%=;"
+	"j_loop_end_%=:"
+		"r1 = r10;"
+		"r1 += -16;"
+		"call %[bpf_iter_num_destroy];"
+		"r0 = 0;"
+		"exit;"
+		:
+		: __imm(bpf_get_prandom_u32),
+		  __imm(bpf_iter_num_new),
+		  __imm(bpf_iter_num_next),
+		  __imm(bpf_iter_num_destroy)
+		: __clobber_all
+	);
+}
+
+SEC("?raw_tp")
 __success
 __naked int triple_continue(void)
 {


