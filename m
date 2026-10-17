Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9F1D838F950;
	Sat, 17 Oct 2026 18:04:20 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792260261; cv=none; b=dauCMlcJ60i9/L/nWXJwRcxRaNtaf5vhVXbfmtI845Lydjrz4qnlJ30+/egZJvoMP062azWjKv1uG2AngiV1Slt6QFu1sDOuNc++M9LHWJNOGF4Z8eJOKUEsfjH01ElBc1nGVstzL+gjQLiYnDI5uG1/H3CEAx8LsXhACDEmCP0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792260261; c=relaxed/simple;
	bh=C7av8CAN8Kz3FDdGP9ZIr3aJ9/r7F7earN+yA5xeR8c=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XCpMCYrarr7cdATqVUJCjeiDqHe3VLfWWfQNmef8daoMvsCn9KxN1m1Kis5rz59xCw8FScBh4bY9dK8onYwXGjydtInv7KNSWidShdYtIw1Iu2gY6iRdb7aI/kDEO4+pU0s9bpAyMtMYf/LbXAGC7xfcbA4qvjqq4i3NOZQ2ueY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=e3Y/ZDIP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="e3Y/ZDIP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F6E31F000C4;
	Sat, 17 Oct 2026 18:04:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792260260;
	bh=RPOigce2bXFpqJmarWIVJrIKNTslixgcfcjOTOu313s=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=e3Y/ZDIPNPXWaYjVXDemkP51hOyHdKqGZufN8vui6Rnvz6yDzb509jnKh6huMBHk9
	 v+f25cB0kstkctILQ3FuQO48MpGdDoh59Oht559gzpiWG0uba4hYRBIz1ergL3HX3w
	 qR4w+Hz1EUEwmH9CBjPUcATHLl0ussKdG2l2BTz0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Dudar <main.kalliope@gmail.com>,
	Eduard Zingerman <eddyz87@gmail.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 1485/1674] bpf: Reject rdonly/rdwr_buf_size kfunc arguments that exceed u32 max
Date: Sat, 17 Oct 2026 18:02:37 +0200
Message-ID: <20261017160509.264774907@linuxfoundation.org>
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

From: Nicholas Dudar <main.kalliope@gmail.com>

[ Upstream commit 2aaf67f0516fde29620d0edfc29c01b9ea7ad430 ]

check_kfunc_args() detects a kfunc argument named rdonly_buf_size or
rdwr_buf_size and stores reg->var_off.value into meta->r0_size, a u64,
and does not bound it. check_kfunc_call() later copies that value into
the returned register's mem_size field:

  meta->r0_size = reg->var_off.value;
  ...
  regs[BPF_REG_0].mem_size = meta.r0_size;

regs[BPF_REG_0].mem_size is u32. A constant whose upper 32 bits are set
gets truncated instead of causing a load-time rejection, so the verifier
records a PTR_TO_MEM register with an approximately 4 GiB mem_size for
whatever allocation the kfunc returned. A later access check against
that register uses the truncated, wrong bound.

Reject rdonly_buf_size/rdwr_buf_size values that exceed U32_MAX at the
point meta->r0_size is set.

Fixes: eb1f7f71c126 ("bpf/verifier: allow kfunc to return an allocated mem")
Signed-off-by: Nicholas Dudar <main.kalliope@gmail.com>
Acked-by: Eduard Zingerman <eddyz87@gmail.com>
Link: https://lore.kernel.org/bpf/20260709155837.1879230-2-main.kalliope@gmail.com
Assisted-by: Claude:claude-opus-4-8
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 4 ++++
 1 file changed, 4 insertions(+)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index ac801a81f1967..6437863ff24c7 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -11493,6 +11493,10 @@ static int check_kfunc_args(struct bpf_verifier_env *env, struct bpf_kfunc_call_
 				}
 
 				meta->r0_size = reg->var_off.value;
+				if (meta->r0_size > U32_MAX) {
+					verbose(env, "R%d rdonly/rdwr_buf_size exceeds u32 max\n", regno);
+					return -EINVAL;
+				}
 				ret = mark_chain_precision(env, regno);
 				if (ret)
 					return ret;
-- 
2.53.0



