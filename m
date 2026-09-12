Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 65C47472071;
	Sat, 12 Sep 2026 11:14:32 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1789211673; cv=none; b=iv/COxkH/UDTkZs0RRR5CA+vBh3MSWfhRLoOJUPWnLDHsG2DvNxKOdV7AqDGnyfUBSOhhrlPBk8cLRIXmNkpkPweKSbyJ9MnzXvDI3Sf09qr+pvOe9FLPCCLFB6qCuXK7bh6cChkdrXb26hhMctExwlgyQRgzUYH13M2MEPaDD8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1789211673; c=relaxed/simple;
	bh=t8COs3n8IwSbG15acOvFQdiDDNt5RyEUBSgaztxSpXM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=LKynrrSythENhTOWvA21G7CYa9yYgUoDYX3N8XR5km0h3vS6SV4eus1ba9vowPF/WGkxU9ibZciqqzERrDLOIZJ+0B9+zhqOp0EZCPGTxf/lbroyD3eLV8ztYYVCzvDXYrsGPLkQQna5TX0O8FDbQlMUHs7zRubks8y4fp5szEs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Viq7acWt; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Viq7acWt"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 610971F000FF;
	Sat, 12 Sep 2026 11:14:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1789211672;
	bh=3xF9JJ3ppqWkpN4GgorMlf08+NEFVmsaHusoMG00gSA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Viq7acWt1Hb09xK01hiSbpRfi/dHrVkXGKCuESxo6nB5JBnoprARHPk4PWNaCEkBx
	 ezRbEvf2f2OO/f/CgQXAZ5S7vmRLUKe1mJxNwb8aiCK0z/dkM3RELfHGCMtXErKCg7
	 hFPDZGtPb+uHAHAIFebgQd+HeL76Np3EPLSl9zCA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Sechang Lim <rhkrqnwk98@gmail.com>,
	Junseo Lim <zirajs7@gmail.com>,
	Daniel Borkmann <daniel@iogearbox.net>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 1242/1518] bpf: Reject negative optlen in cgroup getsockopt hook
Date: Sat, 12 Sep 2026 08:56:51 +0200
Message-ID: <20260912065651.602116594@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Junseo Lim <zirajs7@gmail.com>

[ Upstream commit 1b5aacd5b2419b0790e955e466d389a61c79b4b1 ]

A cgroup getsockopt BPF program can shrink ctx->optlen after the
kernel getsockopt handler has run. The kernel-buffer variant, used by
TCP_ZEROCOPY_RECEIVE, only rejects values larger than the original
length.

If BPF writes a negative optlen, that value is accepted and propagated
back to the TCP getsockopt code. It can then be passed to
copy_to_sockptr() as a size_t and trigger the hardened usercopy
bytes > INT_MAX warning.

Reject negative ctx.optlen in __cgroup_bpf_run_filter_getsockopt_kern(),
matching the lower-bound validation already present in the sockptr-based
getsockopt hook.

Fixes: 9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")
Reported-by: Sechang Lim <rhkrqnwk98@gmail.com>
Signed-off-by: Junseo Lim <zirajs7@gmail.com>
Signed-off-by: Daniel Borkmann <daniel@iogearbox.net>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Link: https://lore.kernel.org/bpf/187a4d756275aaaee5d65eecb63c1477b3b66554.1786448307.git.zirajs7@gmail.com
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 kernel/bpf/cgroup.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/bpf/cgroup.c b/kernel/bpf/cgroup.c
index 0f456765a09ed..8980373c7dab0 100644
--- a/kernel/bpf/cgroup.c
+++ b/kernel/bpf/cgroup.c
@@ -2264,7 +2264,7 @@ int __cgroup_bpf_run_filter_getsockopt_kern(struct sock *sk, int level,
 	if (ret < 0)
 		return ret;
 
-	if (ctx.optlen > *optlen)
+	if (ctx.optlen > *optlen || ctx.optlen < 0)
 		return -EFAULT;
 
 	/* BPF programs can shrink the buffer, export the modifications.
-- 
2.53.0



