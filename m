Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795020917;
	b=uHR5oM6b8mnCdWwzvVtaO4gfuZ6PPR3gW+Ncen/uXsBd45OqQJfBHy5HTqEFSBKxT1/Q
	 hWHyJjtGPjln7PUh+d7XrfB0yInQ9xXDEE1uhds5b3xgNrnHWVhhoPwS+D6nx7Awq2N95
	 4xK83Qi8kgzRpqFatutO6gBllhMK06py39OAIZyPLTgNCWDilTXsUKWowMHhSh6OF0w/a
	 Whmspe28kwfpuB8yRYqTIPBN/C5Lnxohhxnd8ZVb1wGyocg0KW9MpVMcOl6bcRwsYT6IA
	 ZglipyWhemahifoeHiY1Y65v28QjQhG7csnyE9islDdq183tqqJjo9DtsrpnaUqO7og==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795020917;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=m5Xngg/VW9TSccjmtD7zp5d2sLhc/CMfA87ArYIUK3Y=;
	b=ijsr/14vgr3tUJ/oLEKPdYi/B0617LF2eQ/ctxankzpB4P2WUH6/vcxwHcAqRZJD7O7P
	 I2AQ7Ydn/zGEPP4F3lo2jd8mBJ4SSLI7zZHsYcnoNY1LVrEczQm56NEpcWQhUqebmv8N/
	 nnDU/cV3UKvyP/QxRdhQ6epmZS8kDye5/Z2SRYzNROYWrEk40Cdtzyz61lZ8HHGg1LaWC
	 roqnE5Xt/dWTKLo6zHsONWJ5i4uzfnF7A10kNO11V1NhNr9WSe9qjjHFqXTvZq8lKpD94
	 KiweCc6bO9VeiAh/oNKJrZ6UgpTY1fxmdEx+XMQdBgKw5/Ze+Fw1bfi9LsGS/7PkPGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSRKJxsJ;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6F519606B596;
	Wed, 18 Nov 2026 16:55:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=WSRKJxsJ
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C25E41F000C8;
	Wed, 18 Nov 2026 16:55:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795020917;
	bh=m5Xngg/VW9TSccjmtD7zp5d2sLhc/CMfA87ArYIUK3Y=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=WSRKJxsJA7R0YxACfQAkZOIwCl/QNPuGuTWD+oihBfzzazXOP0+Csz0GRpOGjtwH7
	 RZfZ4b3bdrafl0IsL7vvjCy6dm7uhvzvp8td5QQVvwkGIVFvsq7nY6ZG7er6ffYkps
	 6RTu9YDLRec0iglu0OumonlhO3mz+l7us0sUvpTQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.3 2122/2651] bpf: Dont let an extension reach further into the context than its target
Date: Wed, 18 Nov 2026 15:56:02 +0100
Message-ID: <20261118150402.311290892@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150247.972732815@linuxfoundation.org>
References: <20261118150247.972732815@linuxfoundation.org>
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

7.3-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/syscall.c | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
index ffd6802706d4f..de04cd266a422 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3831,6 +3831,19 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
 		err = -EINVAL;
 		goto out_unlock;
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



