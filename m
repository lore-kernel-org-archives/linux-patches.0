Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795625588;
	b=vKvzsaQjcSno/IVrFe4zE0bEzU5EwnK0pQXAqV9LGV+SvUY4cI5hVrPFZ5KxKF1QucSG
	 26uWik1g7G4OQBVBRnEoRp5D3Cc+0XBvpo7xopQ1uq3j5lMJ/xVkfVOlaCJ9Oh2KhfIqT
	 RbynO5l/QOcvf6kOUx32IDpBuUh/xDX048kgiq1UU5UImOrnb0zxWtXSxr5kzQkjDVyPh
	 vhN8YSDyc1XoKPrKoje9r5mJin7bG7AYZqKjYNbl7oRc/bG8Fym7hf2t2d7wuQe39Rkul
	 rmJ8AcNH8u1sGYVBrb7CzLPS4Q43OaL+QAW418wxXbnKU/XpX/fVu7JcBv5IZvY16ww==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795625588;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=ZQTk2Woue7l3NFdnbtTg8CWLfYIE6gGyIjrwS3diYRg=;
	b=tpfWUbB/8uMz1a8Y2Q3K38oRtnuh8YM/xV3t04Tq2L04xXmH/hHF+BOYDn6XPf1zrsRs
	 0+gfafiGjoWDdRZtp4NMlFBJmtcR6McvUXBQUU0I6Mvzagaza1uEm9jGT+JcWACZ845GY
	 X5TEP0sH8TqUmrxFK2QXSD8C+AFfdodZgLwrRyqiyJBuKV0F4QNtxlTxeF8sWroskK6rl
	 7WsZBmqJooqqPkqBoGF9211ErWysRWh0hRIbFX5slr/Auhgu3LHnQmw6oAG+UDTAE7MrC
	 6jv900bXRhkZOd/E8YM8TCxlgQXaAkWxQ+R5fF/lQ1cfjHjALn+QzBLuK++CC7worVA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVS+lpjI;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 751B8606A31E;
	Wed, 25 Nov 2026 16:53:08 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=BVS+lpjI
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CAB1F000C4;
	Wed, 25 Nov 2026 16:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795625588;
	bh=ZQTk2Woue7l3NFdnbtTg8CWLfYIE6gGyIjrwS3diYRg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=BVS+lpjIvJzERqRhhCJGh2R32umTY5o+PZpBcZ/K/EieVaR24Q7UTfLnpV+QzGo9m
	 IbHVU0n8nc63+pMRXMur5p38b3+hFo67JxFNzrelhn9iDAmvND7Ojs4XlhhBwEDR13
	 CZlcT86YfC1uDqARnKPG0IMcRzqkHEifJFIBzPTE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 511/816] bpf: Dont let an extension reach further into the context than its target
Date: Wed, 25 Nov 2026 15:34:19 +0100
Message-ID: <20261125143901.013415408@linuxfoundation.org>
X-Mailer: git-send-email 2.56.1
In-Reply-To: <20261125143849.205329330@linuxfoundation.org>
References: <20261125143849.205329330@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexei Starovoitov <ast@kernel.org>

[ Upstream commit fcbfa99aa657627528b75e7dc1023bcb0b84e558 ]

How large the context of a raw tracepoint, tracepoint or syscall program
is depends on what the program is attached to, or is run with.
bpf_probe_register(), perf_event_set_bpf_prog() and the test runs compare
that with max_ctx_offset of the program.

An extension of the program, or of one of its global functions, gets the
same context.  How far it reaches is noted in its own max_ctx_offset, which
nobody looks at.  On a tracepoint with one argument it reads the stack
behind the arguments, in a test run the memory behind the context, or
from NULL if there is none:

  BUG: KASAN: stack-out-of-bounds in bpf_prog_954b5d2051843629_ts28_ext_far+0x7e/0x113
  Read of size 8 at addr ffffc90000def7b8 by task ts28/104

  BUG: KASAN: slab-out-of-bounds in bpf_prog_954b5d2051843629_ts28_ext_far+0x7e/0x113
  Read of size 8 at addr ffff88810712c3e8 by task ts28/104

Refuse to attach an extension that reaches further than the program which
it extends.  A program that leaves the context to its extensions has to
touch as much of it as they do.

Fixes: be8704ff07d2 ("bpf: Introduce dynamic program extensions")
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Link: https://patch.msgid.link/20261017230950.802052-3-alexei.starovoitov@gmail.com
[ sashal: Dropped the missing kprobe_write_ctx context block, so the new max_ctx_offset check for EXT programs is inserted after the trampoline/tgt_prog selection instead. ]
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index 8fd823047c3a0..2626189f746ba 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3452,6 +3452,19 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		tr = prog->aux->dst_trampoline;
 		tgt_prog = prog->aux->dst_prog;
 	}
+	/*
+	 * The size of these contexts depends on what the program is attached
+	 * to, or run with. That is compared with max_ctx_offset of the program,
+	 * and nobody looks at the one of its extensions.
+	 */
+	if (prog->type == BPF_PROG_TYPE_EXT &&
+	    (tgt_prog->type == BPF_PROG_TYPE_RAW_TRACEPOINT ||
+	     tgt_prog->type == BPF_PROG_TYPE_TRACEPOINT ||
+	     tgt_prog->type == BPF_PROG_TYPE_SYSCALL) &&
+	    prog->aux->max_ctx_offset > tgt_prog->aux->max_ctx_offset) {
+		err = -EINVAL;
+		goto out_unlock;
+	}
 
 	err = bpf_link_prime(&link->link.link, &link_primer);
 	if (err)
-- 
2.53.0



