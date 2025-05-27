Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B296778F32;
	Tue, 27 May 2025 17:00:50 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1748365250; cv=none; b=QO3DtE8ZXG6HtDlnq8QAnKGfVyJ9kW23vAki5jjmEGZ6oyke0CsuKH7K2E4i9VR0/1luVGfOw6QFn3WogtyaJgvHhnb8+YyfNW2nKEoIuwwZJVkonoZtk20jYqj8PNf38O434QMWuMU2K7UKVH/pai70Z1m+n1bjSF9gPQ37xQo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1748365250; c=relaxed/simple;
	bh=jrjReLochCXFCzoe9kfJDZTAfvYu7mb1rMOx4AL4cgs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=jX8jQtdP0QU9i655+dChxBkdLY3cq0lDp+p2NE0m15TKFYjugkKoLkMsDUbZSdvHCBQOBPBSMWPGIWd4qx47mm13TshgAmaIpGduHTn43Dm9h3cH3KcFwDd8I4MWf/6ZtmCjVQlK/ieGISixi0Hj1/Hq2F1Q+byhXvHqlL5SMNs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=blixa7Zc; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="blixa7Zc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2E3E9C4CEE9;
	Tue, 27 May 2025 17:00:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1748365250;
	bh=jrjReLochCXFCzoe9kfJDZTAfvYu7mb1rMOx4AL4cgs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=blixa7ZcxTkVorTZwx2LVyfEx0EkRzUDfER/2U0w4GhhpyCEC1bV7vp3Hw7nQZLWp
	 0bjDqTLLTdK9cNEampK+tri7P9ZrKJILT/t0BXtCrRRW+TyQfwDE2sqgZBKd/iUtXB
	 9M9JyZKEeXT1xmPiMOTOer+2jHXUs9HaYHnb0WXk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Amery Hung <amery.hung@bytedance.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 284/626] bpf: Search and add kfuncs in struct_ops prologue and epilogue
Date: Tue, 27 May 2025 18:22:57 +0200
Message-ID: <20250527162456.572711920@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250527162445.028718347@linuxfoundation.org>
References: <20250527162445.028718347@linuxfoundation.org>
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

From: Amery Hung <amery.hung@bytedance.com>

[ Upstream commit d519594ee2445d7cd1ad51f4db4cee58f8213400 ]

Currently, add_kfunc_call() is only invoked once before the main
verification loop. Therefore, the verifier could not find the
bpf_kfunc_btf_tab of a new kfunc call which is not seen in user defined
struct_ops operators but introduced in gen_prologue or gen_epilogue
during do_misc_fixup(). Fix this by searching kfuncs in the patching
instruction buffer and add them to prog->aux->kfunc_tab.

Signed-off-by: Amery Hung <amery.hung@bytedance.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Martin KaFai Lau <martin.lau@kernel.org>
Link: https://lore.kernel.org/r/20250225233545.285481-1-ameryhung@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 ++++++++++++++++++++++++-
 1 file changed, 24 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8656208aa4bbb..294fbafbeba75 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -2987,6 +2987,21 @@ bpf_jit_find_kfunc_model(const struct bpf_prog *prog,
 	return res ? &res->func_model : NULL;
 }
 
+static int add_kfunc_in_insns(struct bpf_verifier_env *env,
+			      struct bpf_insn *insn, int cnt)
+{
+	int i, ret;
+
+	for (i = 0; i < cnt; i++, insn++) {
+		if (bpf_pseudo_kfunc_call(insn)) {
+			ret = add_kfunc_call(env, insn->imm, insn->off);
+			if (ret < 0)
+				return ret;
+		}
+	}
+	return 0;
+}
+
 static int add_subprog_and_kfunc(struct bpf_verifier_env *env)
 {
 	struct bpf_subprog_info *subprog = env->subprog_info;
@@ -19768,7 +19783,7 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 {
 	struct bpf_subprog_info *subprogs = env->subprog_info;
 	const struct bpf_verifier_ops *ops = env->ops;
-	int i, cnt, size, ctx_field_size, delta = 0, epilogue_cnt = 0;
+	int i, cnt, size, ctx_field_size, ret, delta = 0, epilogue_cnt = 0;
 	const int insn_cnt = env->prog->len;
 	struct bpf_insn *epilogue_buf = env->epilogue_buf;
 	struct bpf_insn *insn_buf = env->insn_buf;
@@ -19797,6 +19812,10 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 				return -ENOMEM;
 			env->prog = new_prog;
 			delta += cnt - 1;
+
+			ret = add_kfunc_in_insns(env, epilogue_buf, epilogue_cnt - 1);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
@@ -19817,6 +19836,10 @@ static int convert_ctx_accesses(struct bpf_verifier_env *env)
 
 			env->prog = new_prog;
 			delta += cnt - 1;
+
+			ret = add_kfunc_in_insns(env, insn_buf, cnt - 1);
+			if (ret < 0)
+				return ret;
 		}
 	}
 
-- 
2.39.5



