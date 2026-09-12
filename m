Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EE902246BCD;
	Sat, 12 Sep 2026 10:11:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789207884; cv=none; b=hO7e1Jhic/zGfNfpO2iawIUdHGYFtiDEHnC1l6hNaz+nemDc5QzPXi/i9/yGriVhUPrAO4Z3USqWjJ00AMPOPmUyH6w5AYM2YF3Yy3B15RlAoin30rWGbwn/wknDcw0/m5bhbx4NcCL4mBumUcHjAG6y4DVsb5r0t3vXu1MQSQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789207884; c=relaxed/simple;
	bh=coNj0bL4ahb98e40w9ZuoN2oVY/yObzJTgnyWJ1zslk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=mRIkX+4XydqMmOABGVPbw58SrMFQnR7Epv4x7XJOJoUqP6m4EbW9HjyAjefW3RkIdgGVTQ17uLD1uqDaWX/9rCf2nBpumFUP+cnrOAVRr9zatDy/+5ZVI38LVlr7ng9VEpFwN3CvUlcM4MkKgnx/PUzKHwRdI3Zxx4ILBIXW3iM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ra2PrgUF; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ra2PrgUF"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 290581F000FF;
	Sat, 12 Sep 2026 10:11:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789207882;
	bh=85eJnSED1oaGsMNtMhvYPJ0vuAjkNnP9EuHAHf/mSSc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=ra2PrgUFjSuNa0ubFRWWF5LGbWC0UwZurpeuvuvL7BIZooLxlKEgG3t7EDmE0UXMJ
	 Mmt2KtLUz7n/i1FyVec4Z83/AZGMO2EQzI4qayPTZKJojGVaV+f+ybAdzbYlss3oNs
	 rgnid++lggp1rZ7N1+nNr0PiRpwLGi8A4TQfcRlE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Pu Lehui <pulehui@huawei.com>,
	Feng Jiang <jiangfeng@kylinos.cn>,
	=?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn@kernel.org>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 0502/1518] bpf, riscv: Fix extable handling for arena load_acquire
Date: Sat, 12 Sep 2026 08:44:31 +0200
Message-ID: <20260912065634.800555506@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260912065623.398859879@linuxfoundation.org>
References: <20260912065623.398859879@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Feng Jiang <jiangfeng@kylinos.cn>

[ Upstream commit 5eb8921371c6fd117d4a328b6053dfda38707df8 ]

emit_atomic_ld_st() returns 1 to have build_body() skip the zext after
a sub-word load_acquire. The caller does "ret = ret ?:
add_exception_handler(...)", which skips add_exception_handler() on any
non-zero ret, so the extable entry is missing and a faulting
PROBE_ATOMIC load_acquire oopses.

REG_DONT_CLEAR_MARKER leaves rd stale on fault, and the verifier still
thinks the load overwrote it, so a program can leak it through a map.

Check ret >= 0 before calling add_exception_handler(), and pass rd for
LOAD_ACQ so the fault zeroes rd like a PROBE_MEM load. Return ret
unchanged for the zext skip.

Fixes: fb7cefabae81 ("riscv, bpf: Add support arena atomics for RV64")
Suggested-by: Pu Lehui <pulehui@huawei.com>
Signed-off-by: Feng Jiang <jiangfeng@kylinos.cn>
Reviewed-by: Pu Lehui <pulehui@huawei.com>
Reviewed-by: Björn Töpel <bjorn@kernel.org>
Acked-by: Björn Töpel <bjorn@kernel.org>
Link: https://lore.kernel.org/bpf/20260720-bpf-riscv-fix-extable-v4-1-165c0b3b07d5@kylinos.cn
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 arch/riscv/net/bpf_jit_comp64.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/arch/riscv/net/bpf_jit_comp64.c b/arch/riscv/net/bpf_jit_comp64.c
index 1e9b2475f514c..93beb95d0a886 100644
--- a/arch/riscv/net/bpf_jit_comp64.c
+++ b/arch/riscv/net/bpf_jit_comp64.c
@@ -1925,7 +1925,12 @@ int bpf_jit_emit_insn(const struct bpf_insn *insn, struct rv_jit_context *ctx,
 		else
 			ret = emit_atomic_rmw(rd, rs, insn, ctx);
 
-		ret = ret ?: add_exception_handler(insn, REG_DONT_CLEAR_MARKER, ctx);
+		/* ret can be 1 (skip-zext); extable entry still needs to be added */
+		if (ret >= 0)
+			ret = add_exception_handler(insn,
+				insn->imm == BPF_LOAD_ACQ ? rd : REG_DONT_CLEAR_MARKER,
+				ctx) ?: ret;
+
 		if (ret)
 			return ret;
 		break;
-- 
2.53.0



