Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795027408;
	b=14RL1aRLwjuILBLVAl8BNYAoUedewhiZvFTCUPjs1V6Z7qU5YrYyIYADtXl5UW0oJFWD
	 THXqyS8n6mMsQZFwQb4AH4wXQwZYDpsdRpa44Q9GrTMoME+s7JisHhali4MuvdIbPm5rn
	 AqvJhid/7BoBxM06WjegpksiA+CwZZJilsIzJyCoPwjIyi0Ena7Zbi+DaP1J/dM4dPWO4
	 JT+rN2ojRNLhCV4/qTQJ3G2J+cvoeyPdmOwNfnXhKUxeOIo9pmOjxV4qEGWhkwez8SvGG
	 Y164dspeNpBuHtuAQo9DKl1PJZIrgTUEWsQ08Xlc+H1o2jRi966yhQAnQ/DGcB4IrkQ==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795027408;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=PAp1rWBO3Z+WR4zEnY0mpLYVw+f3iihNbBEUwSrZM4U=;
	b=FkehH39IWMMuYQiY8/HOgJOYqzf/OXpy8itC0PbPo8ySwMJn1yFyNIGsKkZeJLqIZ0Gu
	 ppMRMjh0pzctSXc0XuAXZqkLh4dZtybRTZy99OvODYtmcRxoDsVdqR+EbGQ5gqMZ7Ziwz
	 Jrrg3C7WGXbhnjvNPy39MZ4IhEoddbuZ7BuDud5Nhuk9ObvknpP725Co7ZIGQPpYTGBSj
	 TaCGhgKquBIIrcDrT0xjyVW7Cpkl6Iz7y0/AYzYsdzN+PVv2N2hlpkBa9bGbjUIFt+2d/
	 so94DPkgfePEScmunzv0DXYzV6xNJGMVvv9ydELOUcVK1KE3aV1Wv3WD5ayV8ahEsGA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0q2t9eeR;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CC0B160A2611;
	Wed, 18 Nov 2026 18:43:28 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=0q2t9eeR
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 315031F000C4;
	Wed, 18 Nov 2026 18:43:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795027408;
	bh=PAp1rWBO3Z+WR4zEnY0mpLYVw+f3iihNbBEUwSrZM4U=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=0q2t9eeRIMKxTNo1+7B/fXJdwZlXEYyqxRmEL4S2ZnUfPF/YxTFt1ZlLPZFi35fYL
	 kzzuTjhRe/7VCT+PEpQ5QLdt6dN6LbupFA1eH5tWyckLgSTHr6TTr9pcboHL+ByB5i
	 FpHn1MhObRTY3W+aAEBohyfNq2w9n6ZrYnpqWCHU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1737/2151] bpf: Dont let an extension reach further into the context than its target
Date: Wed, 18 Nov 2026 15:57:52 +0100
Message-ID: <20261118150225.140802985@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150121.603863898@linuxfoundation.org>
References: <20261118150121.603863898@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

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
index d2f4cd5eaaa0d..fc3d530095a18 100644
--- a/kernel/bpf/syscall.c
+++ b/kernel/bpf/syscall.c
@@ -3740,6 +3740,19 @@ static int bpf_tracing_prog_attach(struct bpf_prog *prog,
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



