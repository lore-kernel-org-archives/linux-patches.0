Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 29CB63BE172;
	Sat, 17 Oct 2026 16:44:36 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1792255478; cv=none; b=KTD4sFEGdhA8TXlT/Y9yZj5wE/YPY67ytOt8nZpC1U9yZswAsooaRNHUzJxkrFoa3k7I64ixEORmLNIS2K8t8BuAfREfc9x9SDPZ1CGnF6OB1wUMc9pHkl/qKrVs+ARqxGjNsI3Ok1NWAVWJ3Iv0ucuZFOCc6RN1ZAcgwRgmUcg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1792255478; c=relaxed/simple;
	bh=5kRNC1dvVx3rRh67lXlhqfLVaUje1VVbG+8SZwq/Vaw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=ioQVENOjauzJzPxyw0VCuSpcywM0nG0EZSLUhXRgQuiaIqEMnPX6FRDfo9RVny8c1HcnkK+DOnDGF9PJaipLi43kfebe1gw6lHyboRRF5NVolUMb654lWuEwQfIc7yIs38R5GqGLbvnKK2PIGAHajJYEbDMx+9o1sEYJsiJof8U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jeKj9pRg; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jeKj9pRg"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3928F1F000C4;
	Sat, 17 Oct 2026 16:44:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1792255476;
	bh=oSOR3M6c9AjM2poQ+DH1QvrYDUHdLQGNQ9xtPwgiKnc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=jeKj9pRg/CkdW3ox4i/gRV3CS5R7U5yrY/LPqP8WO4WjNnXAgu8OeXmElc+a0JxwS
	 aYNcUjsLN2LiZjbCvH6+ZW3Xy17pCva6AphM6xdR7v335cEpESbLfdIXn5MX2BW+uA
	 aHias66V3A47eDufAMBin5GkosT0T7t5C9DZeisw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Nicholas Carlini <npc@anthropic.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>,
	Alexei Starovoitov <ast@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 787/869] bpf: Mark signal tracepoint siginfo arguments as scalar
Date: Sat, 17 Oct 2026 18:00:28 +0200
Message-ID: <20261017160057.088728152@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261017160036.979869304@linuxfoundation.org>
References: <20261017160036.979869304@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kumar Kartikeya Dwivedi <memxor@gmail.com>

[ Upstream commit 77515ab12e4983e6416f8c35039a3f0c0822ac70 ]

The signal_generate and signal_deliver tracepoints declare their info
argument as a struct kernel_siginfo pointer. btf_ctx_access() therefore
treats it as a trusted pointer for tp_btf programs.

Signal delivery also uses SEND_SIG_NOINFO and SEND_SIG_PRIV as special
values for this argument. Those values are zero and one respectively,
and are not pointers. A tp_btf program can currently dereference either
value and fault the kernel. In particular, signal_generate can run from
timer interrupt context, turning the fault into a kernel panic.

Record both tracepoints in raw_tp_null_args[] and mark argument one as
a non-pointer. This preserves scalar access to the cookie while rejecting
direct and helper-mediated pointer use. Merely marking it nullable would
not suffice because SEND_SIG_PRIV is nonzero.

Fixes: 838a10bd2ebf ("bpf: Augment raw_tp arguments with PTR_MAYBE_NULL")
Reported-by: Nicholas Carlini <npc@anthropic.com>
Suggested-by: Nicholas Carlini <npc@anthropic.com>
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Link: https://lore.kernel.org/r/20260903144433.1716731-2-memxor@gmail.com
Signed-off-by: Alexei Starovoitov <ast@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/btf.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/kernel/bpf/btf.c b/kernel/bpf/btf.c
index cd63c1e27f601..e8a79d92d4afa 100644
--- a/kernel/bpf/btf.c
+++ b/kernel/bpf/btf.c
@@ -6558,6 +6558,9 @@ static const struct bpf_raw_tp_null_args raw_tp_null_args[] = {
 	/* rxrpc */
 	{ "rxrpc_recvdata", 0x1 },
 	{ "rxrpc_resend", 0x10 },
+	/* signal */
+	{ "signal_generate", 0x20 },
+	{ "signal_deliver", 0x20 },
 	/* skb */
 	{"kfree_skb", 0x1000},
 	/* sunrpc */
-- 
2.53.0



