Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E8B8B143895;
	Tue, 23 Apr 2024 21:46:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1713908781; cv=none; b=eLXYfzIdCP2HV7Ts6mFyYXEXjmFlaIDXDSWQJUSiErAQ3iTotrwg9/fEVH1gHmuJ1bIlufOwAfEwBx8V7OBpgjI+GWjh7xqPTnxs1qu3Wb/6DCgTw4T39/NPkIP5XclsS9LatBuSjgJmnzACNDfpX6wgrNnvSubjkoaXe4zAC4c=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1713908781; c=relaxed/simple;
	bh=kW1B9vneb8i8hQY16iKBxlXnjQuBYofLtX9EUhLGOlc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=HyntV9jGcUMByyGpbb5kJkOEirQQmZeO0I36dLVEvh4EkiIfCCHlEYYHn+PJLmsHAugzj1F9oqptDdJZGA5yynlBwwcl0ZNGFiHM3GJYFDmr71ywfen7xs5ksyswmHjYBub1Vp1m0f4C65Q641EWfDCjsM+SUj3ioCA/GTCzZkg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=G0IjoD0j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="G0IjoD0j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6F226C32782;
	Tue, 23 Apr 2024 21:46:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1713908780;
	bh=kW1B9vneb8i8hQY16iKBxlXnjQuBYofLtX9EUhLGOlc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=G0IjoD0ja31ijq7BYlM9/0EpdbUxRlvopcmfUG7wmHTo1wJ4/Ye1FrvxryX7YjHgS
	 t9Ic9kRoTlCVg2rLUeze0jzk4ZlA7WDPmulZhvB8cbBUIwkgGVJg4t5iO9PWdkUTuH
	 GglUsynXOg9pRzPqJmnLkuSgRhnDbpE1W2NcFe5E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Borkmann <daniel@iogearbox.net>,
	John Fastabend <john.fastabend@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Edward Liaw <edliaw@google.com>
Subject: [PATCH 5.15 08/71] bpf: Generalize check_ctx_reg for reuse with other types
Date: Tue, 23 Apr 2024 14:39:21 -0700
Message-ID: <20240423213844.404702983@linuxfoundation.org>
X-Mailer: git-send-email 2.44.0
In-Reply-To: <20240423213844.122920086@linuxfoundation.org>
References: <20240423213844.122920086@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit be80a1d3f9dbe5aee79a325964f7037fe2d92f30 upstream.

Generalize the check_ctx_reg() helper function into a more generic named one
so that it can be reused for other register types as well to check whether
their offset is non-zero. No functional change.

Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: John Fastabend <john.fastabend@gmail.com>
Acked-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Edward Liaw <edliaw@google.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 include/linux/bpf_verifier.h |    4 ++--
 kernel/bpf/btf.c             |    2 +-
 kernel/bpf/verifier.c        |   21 +++++++++++----------
 3 files changed, 14 insertions(+), 13 deletions(-)

--- a/include/linux/bpf_verifier.h
+++ b/include/linux/bpf_verifier.h
@@ -541,8 +541,8 @@ bpf_prog_offload_replace_insn(struct bpf
 void
 bpf_prog_offload_remove_insns(struct bpf_verifier_env *env, u32 off, u32 cnt);
 
-int check_ctx_reg(struct bpf_verifier_env *env,
-		  const struct bpf_reg_state *reg, int regno);
+int check_ptr_off_reg(struct bpf_verifier_env *env,
+		      const struct bpf_reg_state *reg, int regno);
 int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
 		   u32 regno, u32 mem_size);
 
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -5558,7 +5558,7 @@ static int btf_check_func_arg_match(stru
 					i, btf_type_str(t));
 				return -EINVAL;
 			}
-			if (check_ctx_reg(env, reg, regno))
+			if (check_ptr_off_reg(env, reg, regno))
 				return -EINVAL;
 		} else if (is_kfunc && (reg->type == PTR_TO_BTF_ID ||
 			   (reg2btf_ids[base_type(reg->type)] && !type_flag(reg->type)))) {
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -3980,16 +3980,16 @@ static int get_callee_stack_depth(struct
 }
 #endif
 
-int check_ctx_reg(struct bpf_verifier_env *env,
-		  const struct bpf_reg_state *reg, int regno)
+int check_ptr_off_reg(struct bpf_verifier_env *env,
+		      const struct bpf_reg_state *reg, int regno)
 {
-	/* Access to ctx or passing it to a helper is only allowed in
-	 * its original, unmodified form.
+	/* Access to this pointer-typed register or passing it to a helper
+	 * is only allowed in its original, unmodified form.
 	 */
 
 	if (reg->off) {
-		verbose(env, "dereference of modified ctx ptr R%d off=%d disallowed\n",
-			regno, reg->off);
+		verbose(env, "dereference of modified %s ptr R%d off=%d disallowed\n",
+			reg_type_str(env, reg->type), regno, reg->off);
 		return -EACCES;
 	}
 
@@ -3997,7 +3997,8 @@ int check_ctx_reg(struct bpf_verifier_en
 		char tn_buf[48];
 
 		tnum_strn(tn_buf, sizeof(tn_buf), reg->var_off);
-		verbose(env, "variable ctx access var_off=%s disallowed\n", tn_buf);
+		verbose(env, "variable %s access var_off=%s disallowed\n",
+			reg_type_str(env, reg->type), tn_buf);
 		return -EACCES;
 	}
 
@@ -4447,7 +4448,7 @@ static int check_mem_access(struct bpf_v
 			return -EACCES;
 		}
 
-		err = check_ctx_reg(env, reg, regno);
+		err = check_ptr_off_reg(env, reg, regno);
 		if (err < 0)
 			return err;
 
@@ -5327,7 +5328,7 @@ static int check_func_arg(struct bpf_ver
 		return err;
 
 	if (type == PTR_TO_CTX) {
-		err = check_ctx_reg(env, reg, regno);
+		err = check_ptr_off_reg(env, reg, regno);
 		if (err < 0)
 			return err;
 	}
@@ -9561,7 +9562,7 @@ static int check_ld_abs(struct bpf_verif
 			return err;
 	}
 
-	err = check_ctx_reg(env, &regs[ctx_reg], ctx_reg);
+	err = check_ptr_off_reg(env, &regs[ctx_reg], ctx_reg);
 	if (err < 0)
 		return err;
 


