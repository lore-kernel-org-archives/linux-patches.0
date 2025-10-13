Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 620DE314D2F;
	Mon, 13 Oct 2025 15:43:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1760370228; cv=none; b=bXtkO1onUpVJB8cdFTaI37DBygnkHBdn1ugI6zgtpKSFpWRmPSkRPHacvOK6R3ZFlUQCgWLci9pwBEQ0lwtpYnrcrOCn3pYLzIZxGJyhDXYLS6I/tV/6kwlwW/fdDtwbgcpI8jVZjb5o+6y6NdOe5m0QFrNAnSG7mVyXE4pvENk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1760370228; c=relaxed/simple;
	bh=Fhjibp4K62B5JzoygfTTdPTlzuyCLfBDxgM8JrPkyGg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=Avbm1gg8tkLjJ1p4U1WEzBOGZKySBBTAKpmMwxNORNzfSC5NNBYcdr/4aNvaI4pozh9p8yyDJgBt0NBCSqDPMNKEpWymflatY8laoe6T2CufrWHNJpVdlXl24xUMbuPVrEMNxiu8KvagGkdz3AEcZq1NP+yFtgEC9pMEST6QlcA=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=ZVHCn+zZ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="ZVHCn+zZ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E3829C116B1;
	Mon, 13 Oct 2025 15:43:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1760370228;
	bh=Fhjibp4K62B5JzoygfTTdPTlzuyCLfBDxgM8JrPkyGg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=ZVHCn+zZVksKTt6QyLDqhfS+DqnyMqrzJc5jQ/9nbt4Ph4b5/u+zNWycrwTT8PwCK
	 m349F495BZvjh3nGXr5O5DHmu5+bignX1vT5JQOPSyZpW4RpgzpDKHwZhRREZ45wlE
	 VYZGb70gvy+kdxzFVH4QyXT2CQkTaHeVuAJsiXDc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d36d5ae81e1b0a53ef58@syzkaller.appspotmail.com,
	KaFai Wan <kafai.wan@linux.dev>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Brahmajit Das <listout@listout.xyz>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.17 491/563] bpf: Skip scalar adjustment for BPF_NEG if dst is a pointer
Date: Mon, 13 Oct 2025 16:45:52 +0200
Message-ID: <20251013144429.079488434@linuxfoundation.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <20251013144411.274874080@linuxfoundation.org>
References: <20251013144411.274874080@linuxfoundation.org>
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

6.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Brahmajit Das <listout@listout.xyz>

[ Upstream commit 34904582b502a86fdb4d7984b12cacd2faabbe0d ]

In check_alu_op(), the verifier currently calls check_reg_arg() and
adjust_scalar_min_max_vals() unconditionally for BPF_NEG operations.
However, if the destination register holds a pointer, these scalar
adjustments are unnecessary and potentially incorrect.

This patch adds a check to skip the adjustment logic when the destination
register contains a pointer.

Reported-by: syzbot+d36d5ae81e1b0a53ef58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d36d5ae81e1b0a53ef58
Fixes: aced132599b3 ("bpf: Add range tracking for BPF_NEG")
Suggested-by: KaFai Wan <kafai.wan@linux.dev>
Suggested-by: Eduard Zingerman <eddyz87@gmail.com>
Signed-off-by: Brahmajit Das <listout@listout.xyz>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20251001191739.2323644-2-listout@listout.xyz
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 6ad0dc226183a..299e43dac873e 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15592,7 +15592,8 @@ static int check_alu_op(struct bpf_verifier_env *env, struct bpf_insn *insn)
 		}
 
 		/* check dest operand */
-		if (opcode == BPF_NEG) {
+		if (opcode == BPF_NEG &&
+		    regs[insn->dst_reg].type == SCALAR_VALUE) {
 			err = check_reg_arg(env, insn->dst_reg, DST_OP_NO_MARK);
 			err = err ?: adjust_scalar_min_max_vals(env, insn,
 							 &regs[insn->dst_reg],
-- 
2.51.0



