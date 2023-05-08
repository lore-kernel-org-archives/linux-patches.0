Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F09C168AD
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:05:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 67DADC433A4;
	Mon,  8 May 2023 10:05:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683540310;
	bh=rPqTwewVKgAV3LUJ58k4LYfZP5qcLAfFcBbae+JYG8U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LWEjSV4LxEKUmwXorahneK0VD8/3kKy4SgTGLAC3wEU0JSpcXj/gtZHHf4HmldzuT
	 W9fqrPwB6EDRPMw+Zf1L5c7YZ27w5GNm2YsxmMRf7Cp6seS6TX9Syp5+Id89wOg8QS
	 yksMK4a1vIn/pl6P+nM9bu0Z0IwwOl+TVUMFAKYw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Luis Gerhorst <gerhorst@cs.fau.de>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 283/611] bpf: Remove misleading spec_v1 check on var-offset stack read
Date: Mon,  8 May 2023 11:42:05 +0200
Message-Id: <20230508094431.575330498@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094421.513073170@linuxfoundation.org>
References: <20230508094421.513073170@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Luis Gerhorst <gerhorst@cs.fau.de>

[ Upstream commit 082cdc69a4651dd2a77539d69416a359ed1214f5 ]

For every BPF_ADD/SUB involving a pointer, adjust_ptr_min_max_vals()
ensures that the resulting pointer has a constant offset if
bypass_spec_v1 is false. This is ensured by calling sanitize_check_bounds()
which in turn calls check_stack_access_for_ptr_arithmetic(). There,
-EACCESS is returned if the register's offset is not constant, thereby
rejecting the program.

In summary, an unprivileged user must never be able to create stack
pointers with a variable offset. That is also the case, because a
respective check in check_stack_write() is missing. If they were able
to create a variable-offset pointer, users could still use it in a
stack-write operation to trigger unsafe speculative behavior [1].

Because unprivileged users must already be prevented from creating
variable-offset stack pointers, viable options are to either remove
this check (replacing it with a clarifying comment), or to turn it
into a "verifier BUG"-message, also adding a similar check in
check_stack_write() (for consistency, as a second-level defense).
This patch implements the first option to reduce verifier bloat.

This check was introduced by commit 01f810ace9ed ("bpf: Allow
variable-offset stack access") which correctly notes that
"variable-offset reads and writes are disallowed (they were already
disallowed for the indirect access case) because the speculative
execution checking code doesn't support them". However, it does not
further discuss why the check in check_stack_read() is necessary.
The code which made this check obsolete was also introduced in this
commit.

I have compiled ~650 programs from the Linux selftests, Linux samples,
Cilium, and libbpf/examples projects and confirmed that none of these
trigger the check in check_stack_read() [2]. Instead, all of these
programs are, as expected, already rejected when constructing the
variable-offset pointers. Note that the check in
check_stack_access_for_ptr_arithmetic() also prints "off=%d" while the
code removed by this patch does not (the error removed does not appear
in the "verification_error" values). For reproducibility, the
repository linked includes the raw data and scripts used to create
the plot.

  [1] https://arxiv.org/pdf/1807.03757.pdf
  [2] https://gitlab.cs.fau.de/un65esoq/bpf-spectre/-/raw/53dc19fcf459c186613b1156a81504b39c8d49db/data/plots/23-02-26_23-56_bpftool/bpftool/0004-errors.pdf?inline=false

Fixes: 01f810ace9ed ("bpf: Allow variable-offset stack access")
Signed-off-by: Luis Gerhorst <gerhorst@cs.fau.de>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/bpf/20230315165358.23701-1-gerhorst@cs.fau.de
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8a9f5143bbd1f..32ea9aaa8b8db 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3518,17 +3518,13 @@ static int check_stack_read(struct bpf_verifier_env *env,
 	}
 	/* Variable offset is prohibited for unprivileged mode for simplicity
 	 * since it requires corresponding support in Spectre masking for stack
-	 * ALU. See also retrieve_ptr_limit().
+	 * ALU. See also retrieve_ptr_limit(). The check in
+	 * check_stack_access_for_ptr_arithmetic() called by
+	 * adjust_ptr_min_max_vals() prevents users from creating stack pointers
+	 * with variable offsets, therefore no check is required here. Further,
+	 * just checking it here would be insufficient as speculative stack
+	 * writes could still lead to unsafe speculative behaviour.
 	 */
-	if (!env->bypass_spec_v1 && var_off) {
-		char tn_buf[48];
-
-		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "R%d variable offset stack access prohibited for !root, var_off=%s\n",
-				ptr_regno, tn_buf);
-		return -EACCES;
-	}
-
 	if (!var_off) {
 		off += reg->var_off.value;
 		err = check_stack_read_fixed_off(env, state, off, size,
-- 
2.39.2



