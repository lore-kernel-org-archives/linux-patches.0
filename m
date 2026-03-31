Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5E3AB29DB8F;
	Tue, 31 Mar 2026 16:57:18 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1774976238; cv=none; b=Yfqu3a1Y4rfMbPz/gyJ0k/DTpabqd/9XPu/VzGztiVZjqQcXA5VuIPDAKtkTub1alQF/l7HVw/V50S4h+Ra2mqI2NU/KdTt5Ws1ydE1VKgXTsvlzsLJnup9qbKaUFTTQBq7pXRePTtCcZXpe1efaQaqqX1XlvcpqAcuSpCkf71o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1774976238; c=relaxed/simple;
	bh=+hcW0ed9vXq2d/FcciSWiH1vhxQ+SRU+B2YbS45ie6I=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=DIG+UdGPbjMnhuIKZDcqzg7r7rF5Q1laKZv0xHUwnkjD/lHxaQoLoqD9nf8H9UwSEeOcDeNcqQ9kD0/rqg0lbcRjtQF27njnb9rgAELuZxGhhWE6EckMnJN2vzj5taHuGR0RQrHTmRl+9x42wrwqoirQp8/S0fh/4sK+xCa/HPk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=2CN8SR6V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2CN8SR6V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4FACC19423;
	Tue, 31 Mar 2026 16:57:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1774976238;
	bh=+hcW0ed9vXq2d/FcciSWiH1vhxQ+SRU+B2YbS45ie6I=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2CN8SR6VMX87qlUrXEhxzsc2PVQE74ibDEU2ZGW/MsEsOGV8h5h2zCfx6FAiuqeaE
	 Kj/hwW3kvbis24C493JB0dsZ2emO57XtGwJtLFVYhCHgS/9Varhlltq+QaQk8rvTOE
	 S5UwfgKcJkC5w5FXWtTAhDHsFflnf3//WTdBGQvk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Daniel Wade <danjwade95@gmail.com>,
	Amery Hung <ameryhung@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 016/309] bpf: Fix unsound scalar forking in maybe_fork_scalars() for BPF_OR
Date: Tue, 31 Mar 2026 18:18:39 +0200
Message-ID: <20260331161754.075659547@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260331161753.468533260@linuxfoundation.org>
References: <20260331161753.468533260@linuxfoundation.org>
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

From: Daniel Wade <danjwade95@gmail.com>

[ Upstream commit c845894ebd6fb43226b3118d6b017942550910c5 ]

maybe_fork_scalars() is called for both BPF_AND and BPF_OR when the
source operand is a constant.  When dst has signed range [-1, 0], it
forks the verifier state: the pushed path gets dst = 0, the current
path gets dst = -1.

For BPF_AND this is correct: 0 & K == 0.
For BPF_OR this is wrong:    0 | K == K, not 0.

The pushed path therefore tracks dst as 0 when the runtime value is K,
producing an exploitable verifier/runtime divergence that allows
out-of-bounds map access.

Fix this by passing env->insn_idx (instead of env->insn_idx + 1) to
push_stack(), so the pushed path re-executes the ALU instruction with
dst = 0 and naturally computes the correct result for any opcode.

Fixes: bffacdb80b93 ("bpf: Recognize special arithmetic shift in the verifier")
Signed-off-by: Daniel Wade <danjwade95@gmail.com>
Reviewed-by: Amery Hung <ameryhung@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/r/20260314021521.128361-2-danjwade95@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index af87530450ec2..f1264972e0245 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -15512,7 +15512,7 @@ static int maybe_fork_scalars(struct bpf_verifier_env *env, struct bpf_insn *ins
 	else
 		return 0;
 
-	branch = push_stack(env, env->insn_idx + 1, env->insn_idx, false);
+	branch = push_stack(env, env->insn_idx, env->insn_idx, false);
 	if (IS_ERR(branch))
 		return PTR_ERR(branch);
 
-- 
2.51.0



