Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5DE2631CA50;
	Mon, 18 Aug 2025 13:00:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1755522036; cv=none; b=TuxjK29QTPjxh731dL4m6gNCa/TpcJSMnLWA2hoR3kPzZPzWttewoS4NhDOD66g8VAV6MBMt0CYII0dUiU4dkI6yWuvEFKjScWg327UiO4bcg013BQYB9oAazS4lfHbyerdhCjTMxoCjHK1Hp24P6BrzQv83rL7m/AnGIBH974A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1755522036; c=relaxed/simple;
	bh=W5OuXy5hARv+ItLF3ZEsbj3CcCALJvTd9HIBaddWAo8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UwBiSWGQNG5NNCCkiF7GDMTKMY72g4nD/Gf20blclKm5WLHUOdTp++ASumLoIOiFaiFHr8Jl0JyDOfb4b7uWXJ7Gk07elpa62lhGNcWunhNoxErX/MDtwXQe1a5kUbJ/dYsdC5wDLMp2LhUTB3ZdOWAbxNTSzd9ppdUEGNe5wH0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=uMGLK8FU; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="uMGLK8FU"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C3414C4CEEB;
	Mon, 18 Aug 2025 13:00:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1755522036;
	bh=W5OuXy5hARv+ItLF3ZEsbj3CcCALJvTd9HIBaddWAo8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=uMGLK8FUUdFcBAAD8pCwLug1RfQGtFuPDV+VGOE0JTjSFOFVk7+TeELfyPyaaKzp9
	 CLyY/UyCc7OFW8A6F05lCwewJZBTVo0pJeV0/FebRD7Ii6r1GDNRIgHHWlHCuVRLtn
	 QZUWQGjVVtRKnG5LCwXMpI0csBtkH5kSfCwZYVrg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+c711ce17dd78e5d4fdcf@syzkaller.appspotmail.com,
	Eduard Zingerman <eddyz87@gmail.com>,
	Yonghong Song <yonghong.song@linux.dev>,
	Paul Chaignon <paul.chaignon@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/444] bpf: Forget ranges when refining tnum after JSET
Date: Mon, 18 Aug 2025 14:43:42 +0200
Message-ID: <20250818124456.215487125@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250818124448.879659024@linuxfoundation.org>
References: <20250818124448.879659024@linuxfoundation.org>
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

From: Paul Chaignon <paul.chaignon@gmail.com>

[ Upstream commit 6279846b9b2532e1b04559ef8bd0dec049f29383 ]

Syzbot reported a kernel warning due to a range invariant violation on
the following BPF program.

  0: call bpf_get_netns_cookie
  1: if r0 == 0 goto <exit>
  2: if r0 & Oxffffffff goto <exit>

The issue is on the path where we fall through both jumps.

That path is unreachable at runtime: after insn 1, we know r0 != 0, but
with the sign extension on the jset, we would only fallthrough insn 2
if r0 == 0. Unfortunately, is_branch_taken() isn't currently able to
figure this out, so the verifier walks all branches. The verifier then
refines the register bounds using the second condition and we end
up with inconsistent bounds on this unreachable path:

  1: if r0 == 0 goto <exit>
    r0: u64=[0x1, 0xffffffffffffffff] var_off=(0, 0xffffffffffffffff)
  2: if r0 & 0xffffffff goto <exit>
    r0 before reg_bounds_sync: u64=[0x1, 0xffffffffffffffff] var_off=(0, 0)
    r0 after reg_bounds_sync:  u64=[0x1, 0] var_off=(0, 0)

Improving the range refinement for JSET to cover all cases is tricky. We
also don't expect many users to rely on JSET given LLVM doesn't generate
those instructions. So instead of improving the range refinement for
JSETs, Eduard suggested we forget the ranges whenever we're narrowing
tnums after a JSET. This patch implements that approach.

Reported-by: syzbot+c711ce17dd78e5d4fdcf@syzkaller.appspotmail.com
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Acked-by: Yonghong Song <yonghong.song@linux.dev>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Paul Chaignon <paul.chaignon@gmail.com>
Link: https://lore.kernel.org/r/9d4fd6432a095d281f815770608fdcd16028ce0b.1752171365.git.paul.chaignon@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 531412c5103d..b880dea7d858 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15052,6 +15052,10 @@ static void regs_refine_cond_op(struct bpf_reg_state *reg1, struct bpf_reg_state
 		if (!is_reg_const(reg2, is_jmp32))
 			break;
 		val = reg_const_value(reg2, is_jmp32);
+		/* Forget the ranges before narrowing tnums, to avoid invariant
+		 * violations if we're on a dead branch.
+		 */
+		__mark_reg_unbounded(reg1);
 		if (is_jmp32) {
 			t = tnum_and(tnum_subreg(reg1->var_off), tnum_const(~val));
 			reg1->var_off = tnum_with_subreg(reg1->var_off, t);
-- 
2.39.5



