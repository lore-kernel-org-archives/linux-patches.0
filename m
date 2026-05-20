Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F1F2D364E89;
	Wed, 20 May 2026 17:23:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1779297800; cv=none; b=RaONEVk4FSYFF9CQo2fmtcGwpz6B5Ihznys9wTQQ4n4v2fIt1gbBa25GPhxgeYZr8A09s4JMOVsukVy9FTPDhj0Q/UeWyNtF97o+nMNEQO91m6ak+bXKkNlqbhKpdSTn/gZcpObpCVVwAfh70jZYmxXwQAc8Z3LamevQPQ+2Mew=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1779297800; c=relaxed/simple;
	bh=2ABgCNNt0chc+sTfkjSKUGi/dQoZlbVHpLYKrh/KDms=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=j8ZDduLJZlg1S4+WDhy1sSEbYo9lmPlRadcbmIK1BipV9t6ciLEqUBhSmK1GZlzDPFce+Lckej+/bOOWcSxzAhzq5Waay8yh6kNTMyV7tzaolD/F75AnG9AGHnQkE7Y+ljm4SJOkHnNvDmc9B84Iak4iOtel5bPr9BJjPDgqc3s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=RFhwcLpc; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="RFhwcLpc"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 64DD21F000E9;
	Wed, 20 May 2026 17:23:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1779297798;
	bh=4Ma7YTrjCGqIyF8IK0VrrZtV6+1iwuN5sRFP/hjnWYQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=RFhwcLpc0vLvBFDPapDr7rj0zET1Inw/SYHoSTRyikAB2E3s6BUQGpZJNZ3TM8LDm
	 T4ZrM6JVY6X9RhqgsY3mKufWalEmmmcYSDfhiyod0wYEKfZ0MbHqb6oVQ+AOinmZfg
	 6DICnBxpMtsVmqEdYOB2je9bUDOYqM9fIDK6eGko=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	STAR Labs SG <info@starlabs.sg>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 131/957] bpf: Fix linked reg delta tracking when src_reg == dst_reg
Date: Wed, 20 May 2026 18:10:14 +0200
Message-ID: <20260520162137.396855889@linuxfoundation.org>
X-Mailer: git-send-email 2.54.0
In-Reply-To: <20260520162134.554764788@linuxfoundation.org>
References: <20260520162134.554764788@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Borkmann <daniel@iogearbox.net>

[ Upstream commit d7f14173c0d5866c3cae759dee560ad1bed10d2e ]

Consider the case of rX += rX where src_reg and dst_reg are pointers to
the same bpf_reg_state in adjust_reg_min_max_vals(). The latter first
modifies the dst_reg in-place, and later in the delta tracking, the
subsequent is_reg_const(src_reg)/reg_const_value(src_reg) reads the
post-{add,sub} value instead of the original source.

This is problematic since it sets an incorrect delta, which sync_linked_regs()
then propagates to linked registers, thus creating a verifier-vs-runtime
mismatch. Fix it by just skipping this corner case.

Fixes: 98d7ca374ba4 ("bpf: Track delta between "linked" registers.")
Reported-by: STAR Labs SG <info@starlabs.sg>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Link: https://lore.kernel.org/r/20260407192421.508817-1-daniel@iogearbox.net
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6cf8b13db301b..6d5fc1af7a1f6 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15808,7 +15808,8 @@ static int adjust_reg_min_max_vals(struct bpf_verifier_env *env,
 	 */
 	if (env->bpf_capable &&
 	    (BPF_OP(insn->code) == BPF_ADD || BPF_OP(insn->code) == BPF_SUB) &&
-	    dst_reg->id && is_reg_const(src_reg, alu32)) {
+	    dst_reg->id && is_reg_const(src_reg, alu32) &&
+	    !(BPF_SRC(insn->code) == BPF_X && insn->src_reg == insn->dst_reg)) {
 		u64 val = reg_const_value(src_reg, alu32);
 		s32 off;
 
-- 
2.53.0



