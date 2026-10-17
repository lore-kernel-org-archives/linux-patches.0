Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AF2F53A7F41;
	Sat, 17 Oct 2026 17:32:05 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792258326; cv=none; b=ATs5ZYGNgZvded8G5M978W7xs2KBjTheyD5RBmiedyYueSQT7K2SDNqoG23NBIP36zzNq2C2QW05CdsG1XjNEUdVTIpCxcYZxFV+0Ll+26kbLCj/fpC7zeJy/Kf3B2V1aketEwvLq/cARp9QiKV3jUYs7otFiO3hTesIKOtfHP8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792258326; c=relaxed/simple;
	bh=JqbWYTMZgQPrpBp4eQIMa0l/5fz/+7mkeHCFLVZNgkM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=u+7VO0pPvD+bgZYoTePg4Uwukg4c14/wUvDQOhWCEzzo9VClxgFJmL/Ht5m2RNJGYfk3LFMx814yaz2FIWOngUo3VgXNpEgw3l7TQH2ZBZSc7MfaHrw/6HUhOp0nzy9KFCP3TOpaISTkcEAA7p9lAuqthpO9KXJNbOdT3cdGsm4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lm5jcmwa; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lm5jcmwa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CE32B1F000C4;
	Sat, 17 Oct 2026 17:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792258325;
	bh=bdZNWTiNPzQz7/hD3kDINmB5q1sRqtkZ998nr+ytZtQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lm5jcmwa6SB7BWMwrSUxyvxOC9gdhCRutBEM+YotmENAAsWm4Ng3c/wWmLXHrrWIM
	 OcKt4RkG3hqv3Nx0RH5UQyVfhS5nIfuPVo6wcjPVVNWRGfPX9LHlqD7rFw0oCFn9Po
	 xqptXra10xAOnMT06J1mjG/+pDbRbZhfwF4EzgGo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 0796/1674] bpf: add a get_helper_proto() utility function
Date: Sat, 17 Oct 2026 17:51:08 +0200
Message-ID: <20261017160451.539697962@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160431.119607952@linuxfoundation.org>
References: <20261017160431.119607952@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eduard Zingerman <eddyz87@gmail.com>

[ Upstream commit 45cbc7a5e004cf08528ef83633c62120cca3a5ee ]

Extract the part of check_helper_call() as a utility function allowing
to query 'struct bpf_func_proto' for a specific helper function id.

Acked-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20240722233844.1406874-2-eddyz87@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Stable-dep-of: e4414b01c1cd ("bpf: Check the helper function is valid in get_helper_proto")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 ++++++++++++++++++-------
 1 file changed, 18 insertions(+), 7 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index c693e6fabe403..958da74f9045e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -10071,6 +10071,19 @@ static void update_loop_inline_state(struct bpf_verifier_env *env, u32 subprogno
 				 state->callback_subprogno == subprogno);
 }
 
+static int get_helper_proto(struct bpf_verifier_env *env, int func_id,
+			    const struct bpf_func_proto **ptr)
+{
+	if (func_id < 0 || func_id >= __BPF_FUNC_MAX_ID)
+		return -ERANGE;
+
+	if (!env->ops->get_func_proto)
+		return -EINVAL;
+
+	*ptr = env->ops->get_func_proto(func_id, env->prog);
+	return *ptr ? 0 : -EINVAL;
+}
+
 static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn,
 			     int *insn_idx_p)
 {
@@ -10086,18 +10099,16 @@ static int check_helper_call(struct bpf_verifier_env *env, struct bpf_insn *insn
 
 	/* find function prototype */
 	func_id = insn->imm;
-	if (func_id < 0 || func_id >= __BPF_FUNC_MAX_ID) {
-		verbose(env, "invalid func %s#%d\n", func_id_name(func_id),
-			func_id);
+	err = get_helper_proto(env, insn->imm, &fn);
+	if (err == -ERANGE) {
+		verbose(env, "invalid func %s#%d\n", func_id_name(func_id), func_id);
 		return -EINVAL;
 	}
 
-	if (env->ops->get_func_proto)
-		fn = env->ops->get_func_proto(func_id, env->prog);
-	if (!fn) {
+	if (err) {
 		verbose(env, "program of this type cannot use helper %s#%d\n",
 			func_id_name(func_id), func_id);
-		return -EINVAL;
+		return err;
 	}
 
 	/* eBPF programs must be GPL compatible to use GPL-ed functions */
-- 
2.53.0



