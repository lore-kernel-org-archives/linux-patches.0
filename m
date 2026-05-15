Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F253130568A;
	Fri, 15 May 2026 16:04:00 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1778861041; cv=none; b=l6gNG7GO+7aivV7+TTY95qjcLzOvtW4D5LhUAlhPCYKVUowvQB/Jct1N3+knkuaKrit7FpJ1BR88AMHnzf51QlwZwtsRQcL4I85uIk6+2cEZ9M/ZYzduLWWfeNyeIizKGeu+ZSwgmFgqTCKGi557spDeX4gHEj8695exJgRYxBA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1778861041; c=relaxed/simple;
	bh=OjEALiGyQlX+kuR4zThfEUVdbsPfP4SRN940x+L0CCk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=BV0WGoN4n31SfFh5C2HC7Tjo9DSDm5eVGvU2K0DmfnFdfgF+MWCWohz6I8tqTn3mOk6e84CDAt32Ti1WsP1rOF5cJrTXoG3waO+Tk8kIWE3MU+AgsRonRnexwTAgu6NTiuDzfm/Na072U0YHlO6WRT0d/9nNfD/ac+MQtpf5OYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=GIWP9YKM; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="GIWP9YKM"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 89769C2BCB0;
	Fri, 15 May 2026 16:04:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1778861040;
	bh=OjEALiGyQlX+kuR4zThfEUVdbsPfP4SRN940x+L0CCk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=GIWP9YKMyinBxBLYCzCqnQDDspfoUJEJaQ+eo1oUVuKDtcuvRhRBsOlSFIoX1iIZJ
	 NzZppNjs3cnhoR9kFpp+liXGuOUm4B6bBt5SF7h2nV6CoCwbBgxXu1Lwu/BdXPpI9B
	 SUsc9T37dIjXYG5To/pr4/x48w9H9YcjsAJd89Ks=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Eduard Zingerman <eddyz87@gmail.com>,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Shung-Hsi Yu <shung-hsi.yu@suse.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/474] bpf: preserve constant zero when doing partial register restore
Date: Fri, 15 May 2026 17:44:45 +0200
Message-ID: <20260515154718.832335397@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260515154715.053014143@linuxfoundation.org>
References: <20260515154715.053014143@linuxfoundation.org>
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

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit e322f0bcb8d371f4606eaf141c7f967e1a79bcb7 ]

Similar to special handling of STACK_ZERO, when reading 1/2/4 bytes from
stack from slot that has register spilled into it and that register has
a constant value zero, preserve that zero and mark spilled register as
precise for that. This makes spilled const zero register and STACK_ZERO
cases equivalent in their behavior.

Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20231205184248.1502704-7-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Acked-by: Shung-Hsi Yu <shung-hsi.yu@suse.com>
Acked-by: Daniel Borkmann <daniel@iogearbox.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 25 +++++++++++++++++++++----
 1 file changed, 21 insertions(+), 4 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 8309504d1660e..eaeb996ff56a2 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -4952,22 +4952,39 @@ static int check_stack_read_fixed_off(struct bpf_verifier_env *env,
 				copy_register_state(&state->regs[dst_regno], reg);
 				state->regs[dst_regno].subreg_def = subreg_def;
 			} else {
+				int spill_cnt = 0, zero_cnt = 0;
+
 				for (i = 0; i < size; i++) {
 					type = stype[(slot - i) % BPF_REG_SIZE];
-					if (type == STACK_SPILL)
+					if (type == STACK_SPILL) {
+						spill_cnt++;
 						continue;
+					}
 					if (type == STACK_MISC)
 						continue;
-					if (type == STACK_ZERO)
+					if (type == STACK_ZERO) {
+						zero_cnt++;
 						continue;
+					}
 					if (type == STACK_INVALID && env->allow_uninit_stack)
 						continue;
 					verbose(env, "invalid read from stack off %d+%d size %d\n",
 						off, i, size);
 					return -EACCES;
 				}
-				mark_reg_unknown(env, state->regs, dst_regno);
-				insn_flags = 0; /* not restoring original register state */
+
+				if (spill_cnt == size &&
+				    tnum_is_const(reg->var_off) && reg->var_off.value == 0) {
+					__mark_reg_const_zero(&state->regs[dst_regno]);
+					/* this IS register fill, so keep insn_flags */
+				} else if (zero_cnt == size) {
+					/* similarly to mark_reg_stack_read(), preserve zeroes */
+					__mark_reg_const_zero(&state->regs[dst_regno]);
+					insn_flags = 0; /* not restoring original register state */
+				} else {
+					mark_reg_unknown(env, state->regs, dst_regno);
+					insn_flags = 0; /* not restoring original register state */
+				}
 			}
 			state->regs[dst_regno].live |= REG_LIVE_WRITTEN;
 		} else if (dst_regno >= 0) {
-- 
2.53.0



