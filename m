Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C61FA2820A8;
	Wed, 23 Apr 2025 15:19:15 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1745421555; cv=none; b=Bm2CEhXWYy+Z47lMxLdPQrx7Nio5S0zDGRfqqm9TES0kxKkks8+UJNFgtpjMRetEj7FNbYM2NiZyb5aUPBOGzFlotJnbFdrN10cjbHLJL5lXfAOaUKMgJV32nxh4mGnk6/exe6Tt77b1h6s2fdU/5vTP36eVEvLCGDL3EFMG8WM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1745421555; c=relaxed/simple;
	bh=xm9yKs0dzFiuQJ//xtkoG6AuTojR8XRkiCamC2P9E9g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ccOXAmeKCBwwvI49vx1iMxF0/lCMrGcdk0nkxe9XJQIC2AlQ8fqzPBaon916sF3pw+0TsulLhs+WmjstqH2Fgn8780Azy7TeIVsnrYQOCAIvbZqxB/pIK/ZEchWU/4rF4HsjpUrE9zXEpp0L829EuK1nrD6c10bYmGU7xAPnHRQ=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uH8HKfqJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uH8HKfqJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EE367C4CEE2;
	Wed, 23 Apr 2025 15:19:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1745421555;
	bh=xm9yKs0dzFiuQJ//xtkoG6AuTojR8XRkiCamC2P9E9g=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uH8HKfqJAPMorKi4QyIDSC4qt2Vu1saCHpQvJ+FqPsI82gwSZtiKQSuEYo8MjqiVB
	 GpyFqcg4TLnvSXkR/prdLsPe820uJ4mWIeS8x6njLIbvLy6Xtc8eihkip8XaoGRMA2
	 BYD6xzeJHShulXip+eH2ex4LoJOTYr5rVVQmFjkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.12 218/223] bpf: check changes_pkt_data property for extension programs
Date: Wed, 23 Apr 2025 16:44:50 +0200
Message-ID: <20250423142626.045637070@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250423142617.120834124@linuxfoundation.org>
References: <20250423142617.120834124@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

commit 81f6d0530ba031b5f038a091619bf2ff29568852 upstream.

When processing calls to global sub-programs, verifier decides whether
to invalidate all packet pointers in current state depending on the
changes_pkt_data property of the global sub-program.

Because of this, an extension program replacing a global sub-program
must be compatible with changes_pkt_data property of the sub-program
being replaced.

This commit:
- adds changes_pkt_data flag to struct bpf_prog_aux:
  - this flag is set in check_cfg() for main sub-program;
  - in jit_subprogs() for other sub-programs;
- modifies bpf_check_attach_btf_id() to check changes_pkt_data flag;
- moves call to check_attach_btf_id() after the call to check_cfg(),
  because it needs changes_pkt_data flag to be set:

    bpf_check:
      ...                             ...
    - check_attach_btf_id             resolve_pseudo_ldimm64
      resolve_pseudo_ldimm64   -->    bpf_prog_is_offloaded
      bpf_prog_is_offloaded           check_cfg
      check_cfg                     + check_attach_btf_id
      ...                             ...

The following fields are set by check_attach_btf_id():
- env->ops
- prog->aux->attach_btf_trace
- prog->aux->attach_func_name
- prog->aux->attach_func_proto
- prog->aux->dst_trampoline
- prog->aux->mod
- prog->aux->saved_dst_attach_type
- prog->aux->saved_dst_prog_type
- prog->expected_attach_type

Neither of these fields are used by resolve_pseudo_ldimm64() or
bpf_prog_offload_verifier_prep() (for netronome and netdevsim
drivers), so the reordering is safe.

Suggested-by: Alexei Starovoitov <alexei.starovoitov@gmail.com>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20241210041100.1898468-6-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ shung-hsi.yu: both jits_use_priv_stack and priv_stack_requested fields are
missing from context because "bpf: Support private stack for bpf progs" series
is not present.]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    1 +
 kernel/bpf/verifier.c |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1499,6 +1499,7 @@ struct bpf_prog_aux {
 	bool exception_cb;
 	bool exception_boundary;
 	bool is_extended; /* true if extended by freplace program */
+	bool changes_pkt_data;
 	u64 prog_array_member_cnt; /* counts how many times as member of prog_array */
 	struct mutex ext_mutex; /* mutex for is_extended and prog_array_member_cnt */
 	struct bpf_arena *arena;
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16650,6 +16650,7 @@ walk_cfg:
 		}
 	}
 	ret = 0; /* cfg looks good */
+	env->prog->aux->changes_pkt_data = env->subprog_info[0].changes_pkt_data;
 
 err_free:
 	kvfree(insn_state);
@@ -20152,6 +20153,7 @@ static int jit_subprogs(struct bpf_verif
 		func[i]->aux->num_exentries = num_exentries;
 		func[i]->aux->tail_call_reachable = env->subprog_info[i].tail_call_reachable;
 		func[i]->aux->exception_cb = env->subprog_info[i].is_exception_cb;
+		func[i]->aux->changes_pkt_data = env->subprog_info[i].changes_pkt_data;
 		if (!i)
 			func[i]->aux->exception_boundary = env->seen_exception;
 		func[i] = bpf_int_jit_compile(func[i]);
@@ -22022,6 +22024,12 @@ int bpf_check_attach_target(struct bpf_v
 					"Extension programs should be JITed\n");
 				return -EINVAL;
 			}
+			if (prog->aux->changes_pkt_data &&
+			    !aux->func[subprog]->aux->changes_pkt_data) {
+				bpf_log(log,
+					"Extension program changes packet data, while original does not\n");
+				return -EINVAL;
+			}
 		}
 		if (!tgt_prog->jited) {
 			bpf_log(log, "Can attach to only JITed progs\n");
@@ -22487,10 +22495,6 @@ int bpf_check(struct bpf_prog **prog, un
 	if (ret < 0)
 		goto skip_full_check;
 
-	ret = check_attach_btf_id(env);
-	if (ret)
-		goto skip_full_check;
-
 	ret = resolve_pseudo_ldimm64(env);
 	if (ret < 0)
 		goto skip_full_check;
@@ -22505,6 +22509,10 @@ int bpf_check(struct bpf_prog **prog, un
 	if (ret < 0)
 		goto skip_full_check;
 
+	ret = check_attach_btf_id(env);
+	if (ret)
+		goto skip_full_check;
+
 	ret = mark_fastcall_patterns(env);
 	if (ret < 0)
 		goto skip_full_check;


