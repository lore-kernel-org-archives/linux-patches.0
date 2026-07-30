Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 190F743DA50;
	Thu, 30 Jul 2026 14:17:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421067; cv=none; b=eOL5lvkGuwsX70lub8Ae6bcdNI9SyAo5q/DdjwxvwjCtaBgyqcfgS3rNKtEcH45oIBZiBrDJnJhJNXaM9SNkS6NECxlpTwVxoHf4p4lui1ACMTnCwly7EPRpJhCrQG37n2/OyY3JpcLk2YYTrx+KUTdKNUyHt6b6jTcqky111Ik=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421067; c=relaxed/simple;
	bh=DfFcXQ/H9Jw7HH9Z85BIsIp6zXnZym/Pr/6QkPpkg0A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=N0JGRY724Fn21/Z2Rg0UGgmXg3zygOk2cYq3FXVL62ihvYgiNoc55DWrmIryhouaDGidpAuzjqUiuiofj2TOYF/ul9wspID6mbv7G6bzpzX8+S9A8ivD8pu98cjqGzsj80J/eP8bPBMhPQClzUEQpoqgT08avQvoehyJgNCKVW0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=C1hrGZhB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="C1hrGZhB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3469B1F00A3D;
	Thu, 30 Jul 2026 14:17:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421065;
	bh=V35OBVt/K4ek/Mtntw3rU5vn2HKs3AKpIHTTH9LOUTM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=C1hrGZhB+cIjAjPo2Q3NHcgqfOE/TR2kQPo1eOrokc9gVnYkWPHKE5UCJ8jXzHYMS
	 SISReBlW0pnjn/nSfguJmC8woDQs5qg8xOZknxsYOikpq5ZmJGM7+yEbzGtF8Ubypu
	 3MnVF9CJ428rDciH/2N3lYMwX49NNpxSStyqKUjE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Philo Lu <lulie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 004/602] bpf: Fix ld_{abs,ind} failure path analysis in subprogs
Date: Thu, 30 Jul 2026 16:06:36 +0200
Message-ID: <20260730141436.082355561@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141435.976815864@linuxfoundation.org>
References: <20260730141435.976815864@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

commit ee861486e377edc55361c08dcbceab3f6b6577bd upstream.

Usage of ld_{abs,ind} instructions got extended into subprogs some time
ago via commit 09b28d76eac4 ("bpf: Add abnormal return checks."). These
are only allowed in subprograms when the latter are BTF annotated and
have scalar return types.

The code generator in bpf_gen_ld_abs() has an abnormal exit path (r0=0 +
exit) from legacy cBPF times. While the enforcement is on scalar return
types, the verifier must also simulate the path of abnormal exit if the
packet data load via ld_{abs,ind} failed.

This is currently not the case. Fix it by having the verifier simulate
both success and failure paths, and extend it in similar ways as we do
for tail calls. The success path (r0=unknown, continue to next insn) is
pushed onto stack for later validation and the r0=0 and return to the
caller is done on the fall-through side.

Fixes: 09b28d76eac4 ("bpf: Add abnormal return checks.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260408191242.526279-2-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
[ Dropped visit_abnormal_return_insn changes: depends on 7.0 symbols from
 e40f5a6bf88a ("bpf: correct stack liveness for tail calls");
 Hunk1: adapted IS_ERR/PTR_ERR to !branch/-EFAULT to match push_stack()
 NULL-on-failure convention. ]
Signed-off-by: Philo Lu <lulie@linux.alibaba.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 17 +++++++++++++++++
 1 file changed, 17 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 7f1144486a8c4a..8c3c4ab989a053 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -16100,6 +16100,23 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
 	mark_reg_unknown(env, regs, BPF_REG_0);
 	/* ld_abs load up to 32-bit skb data. */
 	regs[BPF_REG_0].subreg_def = env->insn_idx + 1;
+	/*
+	 * See bpf_gen_ld_abs() which emits a hidden BPF_EXIT with r0=0
+	 * which must be explored by the verifier when in a subprog.
+	 */
+	if (env->cur_state->curframe) {
+		struct bpf_verifier_state *branch;
+
+		mark_reg_scratched(env, BPF_REG_0);
+		branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+		if (!branch)
+			return -EFAULT;
+		mark_reg_known_zero(env, regs, BPF_REG_0);
+		err = prepare_func_exit(env, &env->insn_idx);
+		if (err)
+			return err;
+		env->insn_idx--;
+	}
 	return 0;
 }
 
-- 
2.53.0



