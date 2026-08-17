Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id B461A3E4C94;
	Mon, 17 Aug 2026 13:38:49 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786973930; cv=none; b=DMP2LEqlPGEr+m8ShjYXEvcdZ2dwDvYeJKL5S+V3L2+wq9aScAIK8WhFgqWzMQ6I+4sF4zWZNF+WxQDZPN/Iu4EpXd+3pHetTMRYHoOKP252G6l8ezQ7EjfRqVLPlPzdJsRpYtVp8HI8jWTIMZjw1jqdj1jtEwVX5ihYt43QduQ=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786973930; c=relaxed/simple;
	bh=RRrjqbVPrNg98dNTIzEv2nPfyQx/dOYypdAQQzPUPDo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=cGBy51JOtaxRPn4MtSascFKAj9D2e+rLYHLpGR3WWA94s4FIvWgQup0P1wC75wgxpoXXGTynNpKfXsaRJ77xm3Utyan5Jnmewu7YXslqiW92ucr6sgArcUaMhOCFZnAnXV9Ac5XgCdKa/aZrJwCiHj7mwOL2ALIvJuTb7pUN9pw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=hrT4M9XP; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="hrT4M9XP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B60DC1F000E9;
	Mon, 17 Aug 2026 13:38:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786973929;
	bh=ilRckA51Ur2FK4x7MrTUebVQ9PULa5ZliS4p+ZDkI5w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=hrT4M9XP4Mk6JeiTzv+WlMYx79hI3qFfB825xPK5BZASdJsBAhBeovG7DaKLyqIWs
	 2FcBsnTMfbdN84C8r1RYzJRzn4rhEKusOc4C1cvJofKkcThCanXOkuRGHCESQNFmIK
	 DavRB+RfjsutrOE9qHzLZ2+b54lLlYpg1x00KHGs=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Mykyta Yatsenko <yatsenko@meta.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	"=?UTF-8?q?Ricardo=20B . =20Marli=C3=A8re=20 ?=" <ricardo@marliere.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 003/271] selftests/bpf: Add tests for sleepable tracepoint programs
Date: Mon, 17 Aug 2026 15:28:48 +0200
Message-ID: <20260817132536.896421533@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Mykyta Yatsenko <yatsenko@meta.com>

[ Upstream commit 8a20655749c625dcc4debdfdeeaa0cf8bb85c203 ]

Cover all three sleepable tracepoint types (tp_btf.s, raw_tp.s, tp.s)
and sys_exit (via bpf_task_pt_regs) with functional tests using
bpf_copy_from_user() on getcwd. Verify alias and bare SEC variants,
bpf_prog_test_run_raw_tp() with BPF_F_TEST_RUN_ON_CPU rejection,
attach-time rejection on non-faultable tracepoints, and load-time
rejection for sleepable tp_btf on non-faultable tracepoints.

[ rbm: Removed hunks from (new) files:
        tools/testing/selftests/bpf/prog_tests/sleepable_tracepoints.c
        tools/testing/selftests/bpf/progs/test_sleepable_tracepoints.c
        tools/testing/selftests/bpf/progs/test_sleepable_tracepoints_fail.c
       These rely on libbpf's ".s" tracepoint section handlers
       (0cd420a6f40c7) and on kernel-side sleepable tracepoint runtime
       support (439ebd5b5708, 12628ffaf98b, 57918341dd19), none of which
       are backported here; kept only the verifier/sleepable.c hunk, which
       is correct and needed on its own. ]

Signed-off-by: Mykyta Yatsenko <yatsenko@meta.com>
Acked-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/bpf/20260422-sleepable_tracepoints-v13-6-99005dff21ef@meta.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Ricardo B. Marlière (SUSE) <ricardo@marliere.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 .../testing/selftests/bpf/verifier/sleepable.c  | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

diff --git a/tools/testing/selftests/bpf/verifier/sleepable.c b/tools/testing/selftests/bpf/verifier/sleepable.c
index c2b7f5ebf168c..6dabc55229455 100644
--- a/tools/testing/selftests/bpf/verifier/sleepable.c
+++ b/tools/testing/selftests/bpf/verifier/sleepable.c
@@ -76,7 +76,20 @@
 	.runs = -1,
 },
 {
-	"sleepable raw tracepoint reject",
+	"sleepable raw tracepoint accept",
+	.insns = {
+	BPF_MOV64_IMM(BPF_REG_0, 0),
+	BPF_EXIT_INSN(),
+	},
+	.prog_type = BPF_PROG_TYPE_TRACING,
+	.expected_attach_type = BPF_TRACE_RAW_TP,
+	.kfunc = "sys_enter",
+	.result = ACCEPT,
+	.flags = BPF_F_SLEEPABLE,
+	.runs = -1,
+},
+{
+	"sleepable raw tracepoint reject non-faultable",
 	.insns = {
 	BPF_MOV64_IMM(BPF_REG_0, 0),
 	BPF_EXIT_INSN(),
@@ -85,7 +98,7 @@
 	.expected_attach_type = BPF_TRACE_RAW_TP,
 	.kfunc = "sched_switch",
 	.result = REJECT,
-	.errstr = "Only fentry/fexit/fsession/fmod_ret, lsm, iter, uprobe, and struct_ops programs can be sleepable",
+	.errstr = "Sleepable program cannot attach to non-faultable tracepoint",
 	.flags = BPF_F_SLEEPABLE,
 	.runs = -1,
 },
-- 
2.53.0



