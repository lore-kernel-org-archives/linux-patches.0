Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8A26E1E22E9;
	Wed,  7 May 2025 19:08:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1746644923; cv=none; b=f7Dnknu9dC6nBatMNOpS/gWcmpiYCWsaPYgpbnpZlKhwT3KxOKVeFr2o9QCiIMqDD0Vjw3YlLmBkzxa6RskmOJ6wU5T38Y2xtT48beGHrPekvi0AfkeaivgAg+0/gg5QcohSLniVd11/5uYWEArTGM4p1AM99yVRiQSDseUFV8o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1746644923; c=relaxed/simple;
	bh=0Wv1vGOsmF5/vICAvM+NzSJBOYQx+sP5znVRPtom7ok=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=QNGJYoGnVgk6zf68pNYxzMLCSv29eTZ2UHoGnlugigttObt+5PQ3SxutRxFbJ/3JakeQ1dStGGu+f/Cwgb9L6OsAy4JgBiP0Ws64lPxSXIeLUAxVo/hhdZEcsu+xtO33BxnIE6lRFl+pZX4bRSkHOrQa0VVnP/gy0LN8MT/wst4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=rQZgu2UU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="rQZgu2UU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 084E5C4CEE2;
	Wed,  7 May 2025 19:08:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1746644923;
	bh=0Wv1vGOsmF5/vICAvM+NzSJBOYQx+sP5znVRPtom7ok=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=rQZgu2UUOmzIjtfkNiQlnjsM8lyfOxhl2Ex0sLcivjgEPNaJYoRsCXeeJBusoqJyq
	 pU42X736rroSz7oBqCPvQy4AEyt0bI862dA5yW6zpQfc2YnFVoVXqpLbwwGWrGYpdR
	 rkXm6QVaoTx/qRRPeth0Ol7sKu+j95vc1ub03eR0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <alexei.starovoitov@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>
Subject: [PATCH 6.6 037/129] bpf: check changes_pkt_data property for extension programs
Date: Wed,  7 May 2025 20:39:33 +0200
Message-ID: <20250507183815.040571850@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250507183813.500572371@linuxfoundation.org>
References: <20250507183813.500572371@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

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
[ shung-hsi.yu: adapt to missing fields in "struct bpf_prog_aux". Context
difference in jit_subprogs() because BPF Exception is not supported. Context
difference in bpf_check() because commit 5b5f51bff1b6 "bpf:
no_caller_saved_registers attribute for helper calls" is not present. ]
Signed-off-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf.h   |    1 +
 kernel/bpf/verifier.c |   16 ++++++++++++----
 2 files changed, 13 insertions(+), 4 deletions(-)

--- a/include/linux/bpf.h
+++ b/include/linux/bpf.h
@@ -1430,6 +1430,7 @@ struct bpf_prog_aux {
 	bool sleepable;
 	bool tail_call_reachable;
 	bool xdp_has_frags;
+	bool changes_pkt_data;
 	/* BTF_KIND_FUNC_PROTO for valid attach_btf_id */
 	const struct btf_type *attach_func_proto;
 	/* function name for valid attach_btf_id */
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15462,6 +15462,7 @@ static int check_cfg(struct bpf_verifier
 		}
 	}
 	ret = 0; /* cfg looks good */
+	env->prog->aux->changes_pkt_data = env->subprog_info[0].changes_pkt_data;
 
 err_free:
 	kvfree(insn_state);
@@ -18622,6 +18623,7 @@ static int jit_subprogs(struct bpf_verif
 		}
 		func[i]->aux->num_exentries = num_exentries;
 		func[i]->aux->tail_call_reachable = env->subprog_info[i].tail_call_reachable;
+		func[i]->aux->changes_pkt_data = env->subprog_info[i].changes_pkt_data;
 		func[i] = bpf_int_jit_compile(func[i]);
 		if (!func[i]->jited) {
 			err = -ENOTSUPP;
@@ -19934,6 +19936,12 @@ int bpf_check_attach_target(struct bpf_v
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
@@ -20393,10 +20401,6 @@ int bpf_check(struct bpf_prog **prog, un
 	if (ret < 0)
 		goto skip_full_check;
 
-	ret = check_attach_btf_id(env);
-	if (ret)
-		goto skip_full_check;
-
 	ret = resolve_pseudo_ldimm64(env);
 	if (ret < 0)
 		goto skip_full_check;
@@ -20411,6 +20415,10 @@ int bpf_check(struct bpf_prog **prog, un
 	if (ret < 0)
 		goto skip_full_check;
 
+	ret = check_attach_btf_id(env);
+	if (ret)
+		goto skip_full_check;
+
 	ret = do_check_subprogs(env);
 	ret = ret ?: do_check_main(env);
 


