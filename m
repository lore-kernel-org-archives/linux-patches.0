Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 28BAE43C7A2;
	Thu, 30 Jul 2026 14:17:27 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785421050; cv=none; b=KBLtG+3KG/G/MTCje71Ldy1AHhTXlWxp/9LqL2sx9aMK77CrLqZCi5ZyFXlm/SqxMcntRVVEF+goYNVAJNG8BX1By0JLpKL64MCZ/Sc0pwkN3KyncBK9Rwi/Lmk9gP2efEvle1kkCmbHW5yREA8LJ6oGkkRiwYrJC2ROHWiihf0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785421050; c=relaxed/simple;
	bh=Ox/pI9jLAE41Lh/6FZP/UrweZx31Nl2vLP/qYtf+R90=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UTxZZxJdpPCqvZN0P6bYoZCt0JEoRBf4wXIRvYypkRxxQRXImsgxtH4Icy8ATt9kTMds+pPvSXtJlG4FnCKzCegUD/TaMDGaBdiLApkDU21fMB9dslCG/SL8Jg8j7DCMkFOjrrxEsAivFI1HRM5GhH4muAzJ3cd59W3UvcetSHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ihx85oMu; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ihx85oMu"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 899031F000E9;
	Thu, 30 Jul 2026 14:17:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785421047;
	bh=smN0kQa8cRoMw89ohDgDOl6jYZojsAIZEGiJzcN25Q0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ihx85oMuSSZLUaXUKkHtYrL2JGEz5k+PMionmdRktzCEgzTGy2wL72iByLuZBXjt6
	 Kt7Fu1uPRerxYE+d/hzXAQq5JRVkmoofOdHhau2W/eOMQQQRtdtc1/f9EN6bNuQUIc
	 D916+uLs8SZImXhTdjVbV20sWiYI/P1+Lyptz3LQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Philo Lu <lulie@linux.alibaba.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 002/484] bpf: Fix ld_{abs,ind} failure path analysis in subprogs
Date: Thu, 30 Jul 2026 16:08:19 +0200
Message-ID: <20260730141423.449880591@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141423.392222816@linuxfoundation.org>
References: <20260730141423.392222816@linuxfoundation.org>
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
index 1da0092122c1db..5e094c12fc94c5 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15120,6 +15120,23 @@ static int check_ld_abs(struct bpf_verifier_env *env, struct bpf_insn *insn)
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



