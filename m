Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 97E44168A2
	for <patches@lists.linux.dev>; Mon,  8 May 2023 10:33:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 005D1C433D2;
	Mon,  8 May 2023 10:33:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1683541992;
	bh=JFeMi7UbGEXelyc10S/ujGQi39GPv1UwZz3tMcwkSLU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=kcvi3HkGFCc94q1hTwQuN36NBUEsFG9YT7c8HUxYHVph8FvihQH9ydOFUGkahY7jC
	 QZqCn6jIvy1+/ZheRJVcTrT8UogbdIzmkaRg+m3bRY7LxS+ddR9ELOikEapI9jDlUa
	 56Zb0F9wNkxaOVaBNYhMBbeUnPatHH7nNe3xCJzc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Andrii Nakryiko <andrii@kernel.org>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.2 292/663] bpf: take into account liveness when propagating precision
Date: Mon,  8 May 2023 11:41:58 +0200
Message-Id: <20230508094437.669927879@linuxfoundation.org>
X-Mailer: git-send-email 2.40.1
In-Reply-To: <20230508094428.384831245@linuxfoundation.org>
References: <20230508094428.384831245@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Andrii Nakryiko <andrii@kernel.org>

[ Upstream commit 52c2b005a3c18c565fc70cfd0ca49375f301e952 ]

When doing state comparison, if old state has register that is not
marked as REG_LIVE_READ, then we just skip comparison, regardless what's
the state of corresponing register in current state. This is because not
REG_LIVE_READ register is irrelevant for further program execution and
correctness. All good here.

But when we get to precision propagation, after two states were declared
equivalent, we don't take into account old register's liveness, and thus
attempt to propagate precision for register in current state even if
that register in old state was not REG_LIVE_READ anymore. This is bad,
because register in current state could be anything at all and this
could cause -EFAULT due to internal logic bugs.

Fix by taking into account REG_LIVE_READ liveness mark to keep the logic
in state comparison in sync with precision propagation.

Fixes: a3ce685dd01a ("bpf: fix precision tracking")
Signed-off-by: Andrii Nakryiko <andrii@kernel.org>
Link: https://lore.kernel.org/r/20230309224131.57449-1-andrii@kernel.org
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/verifier.c | 6 ++++--
 1 file changed, 4 insertions(+), 2 deletions(-)

diff --git a/kernel/bpf/verifier.c b/kernel/bpf/verifier.c
index 9db6afc86733b..a53ba87a1cd2a 100644
--- a/kernel/bpf/verifier.c
+++ b/kernel/bpf/verifier.c
@@ -13674,7 +13674,8 @@ static int propagate_precision(struct bpf_verifier_env *env,
 		state_reg = state->regs;
 		for (i = 0; i < BPF_REG_FP; i++, state_reg++) {
 			if (state_reg->type != SCALAR_VALUE ||
-			    !state_reg->precise)
+			    !state_reg->precise ||
+			    !(state_reg->live & REG_LIVE_READ))
 				continue;
 			if (env->log.level & BPF_LOG_LEVEL2)
 				verbose(env, "frame %d: propagating r%d\n", i, fr);
@@ -13688,7 +13689,8 @@ static int propagate_precision(struct bpf_verifier_env *env,
 				continue;
 			state_reg = &state->stack[i].spilled_ptr;
 			if (state_reg->type != SCALAR_VALUE ||
-			    !state_reg->precise)
+			    !state_reg->precise ||
+			    !(state_reg->live & REG_LIVE_READ))
 				continue;
 			if (env->log.level & BPF_LOG_LEVEL2)
 				verbose(env, "frame %d: propagating fp%d\n",
-- 
2.39.2



