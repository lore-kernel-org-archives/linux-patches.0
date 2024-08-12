Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C0043134AC;
	Mon, 12 Aug 2024 16:27:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1723480028; cv=none; b=ET6x4j2+cMXlhqbAouwgXaqX0jpMLvlur7gSOux+2jo5KVnGHcTVcktPwev+dg2zYyYKGWqlfjTmJtwzVcDj/icIeHgJi472kdLcVCX0YdxWWvBSZy23M9Ph5oBJh4gqbRgChO9sAgKjYJof1HpzW9JNKpC4hDw0OfgEtR9bujk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1723480028; c=relaxed/simple;
	bh=XIQY5lvDcFDz9riSkkObPfpY+7PZ1wSw6UjXlRhirdM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=OElzFaM1DVJ/6H/rlslOCmA5JYepAYSW+ZuTTXvVqlGIlo8XwuReAOllcL3F8YTvY+XzvyENE5r7q3H5rpmOivDrhO6yRwJwqDx5OOSKmMLWaXSBq3E8+22cqqhHtrpjHNAloZztjvWEOGLXY/mSt2UAEH6gMSVDHnx6qeK7uKI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GaTikEJa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GaTikEJa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A8E8C32782;
	Mon, 12 Aug 2024 16:27:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1723480028;
	bh=XIQY5lvDcFDz9riSkkObPfpY+7PZ1wSw6UjXlRhirdM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GaTikEJaOVZ6g2fIg50dVVKlXRtDyfg44YV1Uu4lyOIylxTqNx0ieYp8IFUhM/mbL
	 AUC6vgq/7bIsSnK3nohmegSq3VtyBZ/pVaQEF9Ahj6pKe8Q5r+rmD8R3cuzQjIJ7Zs
	 BVry7Ew0L+p6PQe0D6r2tRWVvwMx2/NduGRLceVM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Matt Bobrowski <mattbobrowski@google.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.10 074/263] bpf: add missing check_func_arg_reg_off() to prevent out-of-bounds memory accesses
Date: Mon, 12 Aug 2024 18:01:15 +0200
Message-ID: <20240812160149.376178718@linuxfoundation.org>
X-Mailer: git-send-email 2.46.0
In-Reply-To: <20240812160146.517184156@linuxfoundation.org>
References: <20240812160146.517184156@linuxfoundation.org>
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

6.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Matt Bobrowski <mattbobrowski@google.com>

[ Upstream commit ec2b9a5e11e51fea1bb04c1e7e471952e887e874 ]

Currently, it's possible to pass in a modified CONST_PTR_TO_DYNPTR to
a global function as an argument. The adverse effects of this is that
BPF helpers can continue to make use of this modified
CONST_PTR_TO_DYNPTR from within the context of the global function,
which can unintentionally result in out-of-bounds memory accesses and
therefore compromise overall system stability i.e.

[  244.157771] BUG: KASAN: slab-out-of-bounds in bpf_dynptr_data+0x137/0x140
[  244.161345] Read of size 8 at addr ffff88810914be68 by task test_progs/302
[  244.167151] CPU: 0 PID: 302 Comm: test_progs Tainted: G O E 6.10.0-rc3-00131-g66b586715063 #533
[  244.174318] Call Trace:
[  244.175787]  <TASK>
[  244.177356]  dump_stack_lvl+0x66/0xa0
[  244.179531]  print_report+0xce/0x670
[  244.182314]  ? __virt_addr_valid+0x200/0x3e0
[  244.184908]  kasan_report+0xd7/0x110
[  244.187408]  ? bpf_dynptr_data+0x137/0x140
[  244.189714]  ? bpf_dynptr_data+0x137/0x140
[  244.192020]  bpf_dynptr_data+0x137/0x140
[  244.194264]  bpf_prog_b02a02fdd2bdc5fa_global_call_bpf_dynptr_data+0x22/0x26
[  244.198044]  bpf_prog_b0fe7b9d7dc3abde_callback_adjust_bpf_dynptr_reg_off+0x1f/0x23
[  244.202136]  bpf_user_ringbuf_drain+0x2c7/0x570
[  244.204744]  ? 0xffffffffc0009e58
[  244.206593]  ? __pfx_bpf_user_ringbuf_drain+0x10/0x10
[  244.209795]  bpf_prog_33ab33f6a804ba2d_user_ringbuf_callback_const_ptr_to_dynptr_reg_off+0x47/0x4b
[  244.215922]  bpf_trampoline_6442502480+0x43/0xe3
[  244.218691]  __x64_sys_prlimit64+0x9/0xf0
[  244.220912]  do_syscall_64+0xc1/0x1d0
[  244.223043]  entry_SYSCALL_64_after_hwframe+0x77/0x7f
[  244.226458] RIP: 0033:0x7ffa3eb8f059
[  244.228582] Code: 08 89 e8 5b 5d c3 66 2e 0f 1f 84 00 00 00 00 00 90 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 8b 0d 8f 1d 0d 00 f7 d8 64 89 01 48
[  244.241307] RSP: 002b:00007ffa3e9c6eb8 EFLAGS: 00000206 ORIG_RAX: 000000000000012e
[  244.246474] RAX: ffffffffffffffda RBX: 00007ffa3e9c7cdc RCX: 00007ffa3eb8f059
[  244.250478] RDX: 00007ffa3eb162b4 RSI: 0000000000000000 RDI: 00007ffa3e9c7fb0
[  244.255396] RBP: 00007ffa3e9c6ed0 R08: 00007ffa3e9c76c0 R09: 0000000000000000
[  244.260195] R10: 0000000000000000 R11: 0000000000000206 R12: ffffffffffffff80
[  244.264201] R13: 000000000000001c R14: 00007ffc5d6b4260 R15: 00007ffa3e1c7000
[  244.268303]  </TASK>

Add a check_func_arg_reg_off() to the path in which the BPF verifier
verifies the arguments of global function arguments, specifically
those which take an argument of type ARG_PTR_TO_DYNPTR |
MEM_RDONLY. Also, process_dynptr_func() doesn't appear to perform any
explicit and strict type matching on the supplied register type, so
let's also enforce that a register either type PTR_TO_STACK or
CONST_PTR_TO_DYNPTR is by the caller.

Reported-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Matt Bobrowski <mattbobrowski@google.com>
Link: https://lore.kernel.org/r/20240625062857.92760-1-mattbobrowski@google.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 17 +++++++++++------
 1 file changed, 11 insertions(+), 6 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6b422c275f78c..a8845cc299fec 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -7716,6 +7716,13 @@ static int process_dynptr_func(struct bpf_verifier_env *env, int regno, int insn
 	struct bpf_reg_state *regs = cur_regs(env), *reg = &regs[regno];
 	int err;
 
+	if (reg->type != PTR_TO_STACK && reg->type != CONST_PTR_TO_DYNPTR) {
+		verbose(env,
+			"arg#%d expected pointer to stack or const struct bpf_dynptr\n",
+			regno);
+		return -EINVAL;
+	}
+
 	/* MEM_UNINIT and MEM_RDONLY are exclusive, when applied to an
 	 * ARG_PTR_TO_DYNPTR (or ARG_PTR_TO_DYNPTR | DYNPTR_TYPE_*):
 	 */
@@ -9465,6 +9472,10 @@ static int btf_check_func_arg_match(struct bpf_verifier_env *env, int subprog,
 				return -EINVAL;
 			}
 		} else if (arg->arg_type == (ARG_PTR_TO_DYNPTR | MEM_RDONLY)) {
+			ret = check_func_arg_reg_off(env, reg, regno, ARG_PTR_TO_DYNPTR);
+			if (ret)
+				return ret;
+
 			ret = process_dynptr_func(env, regno, -1, arg->arg_type, 0);
 			if (ret)
 				return ret;
@@ -11958,12 +11969,6 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 			enum bpf_arg_type dynptr_arg_type = ARG_PTR_TO_DYNPTR;
 			int clone_ref_obj_id = 0;
 
-			if (reg->type != PTR_TO_STACK &&
-			    reg->type != CONST_PTR_TO_DYNPTR) {
-				verbose(env, "arg#%d expected pointer to stack or dynptr_ptr\n", i);
-				return -EINVAL;
-			}
-
 			if (reg->type == CONST_PTR_TO_DYNPTR)
 				dynptr_arg_type |= MEM_RDONLY;
 
-- 
2.43.0



