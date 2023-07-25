Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BDD5C1D301
	for <patches@lists.linux.dev>; Tue, 25 Jul 2023 11:05:58 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id ED3E9C433C7;
	Tue, 25 Jul 2023 11:05:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1690283158;
	bh=Z890YDLEJRpxZU1TH7OmQR5NgoSvLq2HVwpJWEraWgM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=r2PAoIUEF6ZYxexT6QoDEgs2jkPXbvPL0cXBKrw6gurIRu7NhJT2OAggYlHf/GRB2
	 2xVJovGxlT9TmOa/yBJ8lIZvMiGt9jgN8+L/j3UeTdWyT0NplMJ6BEbyRtsxOtBn/x
	 qay/QoXfMKPpFuCWSnpD6lrCKbgRDRafB5X2P1Wo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 130/183] bpf: Repeat check_max_stack_depth for async callbacks
Date: Tue, 25 Jul 2023 12:45:58 +0200
Message-ID: <20230725104512.614693982@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230725104507.756981058@linuxfoundation.org>
References: <20230725104507.756981058@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit b5e9ad522c4ccd32d322877515cff8d47ed731b9 ]

While the check_max_stack_depth function explores call chains emanating
from the main prog, which is typically enough to cover all possible call
chains, it doesn't explore those rooted at async callbacks unless the
async callback will have been directly called, since unlike non-async
callbacks it skips their instruction exploration as they don't
contribute to stack depth.

It could be the case that the async callback leads to a callchain which
exceeds the stack depth, but this is never reachable while only
exploring the entry point from main subprog. Hence, repeat the check for
the main subprog *and* all async callbacks marked by the symbolic
execution pass of the verifier, as execution of the program may begin at
any of them.

Consider functions with following stack depths:
main: 256
async: 256
foo: 256

main:
    rX = async
    bpf_timer_set_callback(...)

async:
    foo()

Here, async is not descended as it does not contribute to stack depth of
main (since it is referenced using bpf_pseudo_func and not
bpf_pseudo_call). However, when async is invoked asynchronously, it will
end up breaching the MAX_BPF_STACK limit by calling foo.

Hence, in addition to main, we also need to explore call chains
beginning at all async callback subprogs in a program.

Fixes: 7ddc80a476c2 ("bpf: Teach stack depth check about async callbacks.")
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20230717161530.1238-3-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 21 +++++++++++++++++++--
 1 file changed, 19 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index fdba4086881b3..f25ce959fae64 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4288,16 +4288,17 @@ static int update_stack_depth(struct bpf_verifier_env *env,
  * Since recursion is prevented by check_cfg() this algorithm
  * only needs a local stack of MAX_CALL_FRAMES to remember callsites
  */
-static int check_max_stack_depth(struct bpf_verifier_env *env)
+static int check_max_stack_depth_subprog(struct bpf_verifier_env *env, int idx)
 {
-	int depth = 0, frame = 0, idx = 0, i = 0, subprog_end;
 	struct bpf_subprog_info *subprog = env->subprog_info;
 	struct bpf_insn *insn = env->prog->insnsi;
+	int depth = 0, frame = 0, i, subprog_end;
 	bool tail_call_reachable = false;
 	int ret_insn[MAX_CALL_FRAMES];
 	int ret_prog[MAX_CALL_FRAMES];
 	int j;
 
+	i = subprog[idx].start;
 process_func:
 	/* protect against potential stack overflow that might happen when
 	 * bpf2bpf calls get combined with tailcalls. Limit the caller's stack
@@ -4398,6 +4399,22 @@ static int check_max_stack_depth(struct bpf_verifier_env *env)
 	goto continue_func;
 }
 
+static int check_max_stack_depth(struct bpf_verifier_env *env)
+{
+	struct bpf_subprog_info *si = env->subprog_info;
+	int ret;
+
+	for (int i = 0; i < env->subprog_cnt; i++) {
+		if (!i || si[i].is_async_cb) {
+			ret = check_max_stack_depth_subprog(env, i);
+			if (ret < 0)
+				return ret;
+		}
+		continue;
+	}
+	return 0;
+}
+
 #ifndef CONFIG_BPF_JIT_ALWAYS_ON
 static int get_callee_stack_depth(struct bpf_verifier_env *env,
 				  const struct bpf_insn *insn, int idx)
-- 
2.39.2



