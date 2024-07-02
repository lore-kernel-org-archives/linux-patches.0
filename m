Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E6201BD51C;
	Tue,  2 Jul 2024 17:07:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1719940073; cv=none; b=JfwH/bQMINU7N+x3D+GrwwboOU/GV7hW8HY3YGkEtsplufU0LGU8XAvOUnGcX8MsRo5mnTERZPksp2vDyeugtKxscSYiOdjcRlqhsrhoFcv4NIZNdbnJzWh7I8N8+FdtSKgWPVim1pObatXJlYIjstS3Zcc5QQrvJdezidd34SY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1719940073; c=relaxed/simple;
	bh=YCkhX7qd8v5GpyDESKhMJFf9afGGdgZS6DvZ1wgRLts=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=p+P6s7piNTQBtIGdcTPr6epKZYPoCUHX8hkHBKNE/jjHackmvkBTaPFGezF+HQtBGi/vQ3/k07IuleSWPn7TAseeLzJe26W7sWEWti0drnAdxwzsHv9OwcAAmolfAjrsubUcBm0AZ56CPSX0+cwR7nr/6PENWfwiD4v+3mDnDUM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=pkSnV33G; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="pkSnV33G"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B0934C116B1;
	Tue,  2 Jul 2024 17:07:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1719940073;
	bh=YCkhX7qd8v5GpyDESKhMJFf9afGGdgZS6DvZ1wgRLts=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=pkSnV33GLdh1ytQdsDb6GscD1j+4t/C2yT2C6eVc82984BffEV2GgXpYXz7OvZPJy
	 bdV1Z/hAV3tqGm/afi5A+IfLY8Yl0LXMigiUCh0goW/nIw2Gvu93MiBiWwF9uM4oX3
	 1hBM/9WWjjoCRFSw0xFkvZ6tCiF2a1WuVgLHljx0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zac Ecob <zacecob@protonmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Andrii Nakryiko <andrii@kernel.org>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 043/222] bpf: Fix may_goto with negative offset.
Date: Tue,  2 Jul 2024 19:01:21 +0200
Message-ID: <20240702170245.622624267@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240702170243.963426416@linuxfoundation.org>
References: <20240702170243.963426416@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit 2b2efe1937ca9f8815884bd4dcd5b32733025103 ]

Zac's syzbot crafted a bpf prog that exposed two bugs in may_goto.
The 1st bug is the way may_goto is patched. When offset is negative
it should be patched differently.
The 2nd bug is in the verifier:
when current state may_goto_depth is equal to visited state may_goto_depth
it means there is an actual infinite loop. It's not correct to prune
exploration of the program at this point.
Note, that this check doesn't limit the program to only one may_goto insn,
since 2nd and any further may_goto will increment may_goto_depth only
in the queued state pushed for future exploration. The current state
will have may_goto_depth == 0 regardless of number of may_goto insns
and the verifier has to explore the program until bpf_exit.

Fixes: 011832b97b31 ("bpf: Introduce may_goto instruction")
Reported-by: Zac Ecob <zacecob@protonmail.com>
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Closes: https://lore.kernel.org/bpf/CAADnVQL-15aNp04-cyHRn47Yv61NXfYyhopyZtUyxNojUZUXpA@mail.gmail.com/
Link: https://lore.kernel.org/bpf/20240619235355.85031-1-alexei.starovoitov@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 9 ++++++---
 1 file changed, 6 insertions(+), 3 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 2233bf50a9012..ab558eea1c9ee 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -17308,11 +17308,11 @@ static int is_state_visited(struct bpf_verifier_env *env, int insn_idx)
 				goto skip_inf_loop_check;
 			}
 			if (is_may_goto_insn_at(env, insn_idx)) {
-				if (states_equal(env, &sl->state, cur, RANGE_WITHIN)) {
+				if (sl->state.may_goto_depth != cur->may_goto_depth &&
+				    states_equal(env, &sl->state, cur, RANGE_WITHIN)) {
 					update_loop_entry(cur, &sl->state);
 					goto hit;
 				}
-				goto skip_inf_loop_check;
 			}
 			if (calls_callback(env, insn_idx)) {
 				if (states_equal(env, &sl->state, cur, RANGE_WITHIN))
@@ -19853,7 +19853,10 @@ static int do_misc_fixups(struct bpf_verifier_env *env)
 
 			stack_depth_extra = 8;
 			insn_buf[0] = BPF_LDX_MEM(BPF_DW, BPF_REG_AX, BPF_REG_10, stack_off);
-			insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off + 2);
+			if (insn->off >= 0)
+				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off + 2);
+			else
+				insn_buf[1] = BPF_JMP_IMM(BPF_JEQ, BPF_REG_AX, 0, insn->off - 1);
 			insn_buf[2] = BPF_ALU64_IMM(BPF_SUB, BPF_REG_AX, 1);
 			insn_buf[3] = BPF_STX_MEM(BPF_DW, BPF_REG_10, BPF_REG_AX, stack_off);
 			cnt = 4;
-- 
2.43.0



