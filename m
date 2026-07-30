Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A01793D75C4;
	Thu, 30 Jul 2026 14:37:03 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1785422224; cv=none; b=Wt41v0yC4dR2YO2qhcRBJMX9PnPjnA1TNsauFXuru2BBnPgFh2GRkB0RtKq03f4WVA2nY8uR79SmPEgmvFPre24Hy614OctCS0yeVANcSFnOKt/drofvt9D/sAolhUCVvW9pe0UZTvOHxmfni0vgSn2uHLb/lvjN0cI8TZSA+rw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1785422224; c=relaxed/simple;
	bh=bRfafhcEXZZUheN6TNQAatimFsauSpFDB9CNkJHUoC0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=eqBZMalc1pJGL4g74StuuFkeUuLdtIXRnZPmrxW4sOZArmQaj+VzqnYtq/cnnOxt0VS2NOJiFdy1QsXPE1858Q6ADuKIrlrasEr8ALXlnrnA5gwYmPWAPM/9x8sad5qfzCZQlDrRKRY3HT2cO9gnGH2eWjo2OZ0QTESdgIi0It0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Ys37YDDL; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Ys37YDDL"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F1BD41F000E9;
	Thu, 30 Jul 2026 14:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1785422223;
	bh=sPQaFjsmwYFhemtRQcETXd6pHvzrkSj0qQkiM3fCa1o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Ys37YDDLr+ZcCKOgaqwHUZjIF7WeKUnRioMxQ9pwQtAv77lfFtPJFjSbqoiCd9yWT
	 cFBWcyDDUIZUGOb6Ds4diBscJRAhoj5cWTgPLTvFjt6dG6gF5uxvtCMhHtLHZI7WUW
	 1ms+oMf44HvJEbc13G+F7qQJMJFi3AqAwDoc9OKM=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Eric Dumazet <edumazet@google.com>,
	Jordan Rife <jordan@jrife.io>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 321/744] bpf: tcp: fix double sock release on batch realloc
Date: Thu, 30 Jul 2026 16:09:54 +0200
Message-ID: <20260730141451.108532623@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260730141444.267951807@linuxfoundation.org>
References: <20260730141444.267951807@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

[ Upstream commit 980a813452754f8001704744e92f7aa697c53dd3 ]

bpf_iter_tcp_batch() releases the current batch via
bpf_iter_tcp_put_batch(), which drops the socket refs and rewrites
each slot with the socket cookie, then grows the batch. cur_sk/end_sk
are kept for bpf_iter_tcp_resume(), but on realloc failure the function
returns ERR_PTR() before resume runs, leaving cur_sk < end_sk over
slots that now hold cookies rather than sock pointers.
bpf_iter_tcp_seq_stop() then calls bpf_iter_tcp_put_batch() again and
dereferences a cookie as a struct sock.

Empty the batch on the failure path so stop() does not release it
again. The sockets were already freed by the first
bpf_iter_tcp_put_batch(), so nothing leaks, and a later read() rescans
the bucket from the start instead of skipping it. The sibling
GFP_NOWAIT failure path still holds real socket references and is left
for stop() to release.

  BUG: KASAN: null-ptr-deref in __sock_gen_cookie
  Read of size 8 at addr 0000000000000059 by task exploit
   ...
   __sock_gen_cookie (net/core/sock_diag.c:28)
   bpf_iter_tcp_put_batch (net/ipv4/tcp_ipv4.c:2918)
   bpf_iter_tcp_seq_stop (net/ipv4/tcp_ipv4.c:3270)
   bpf_seq_read (kernel/bpf/bpf_iter.c:205)
   vfs_read (fs/read_write.c:572)
   ksys_read (fs/read_write.c:716)
   do_syscall_64
   entry_SYSCALL_64_after_hwframe
  Kernel panic - not syncing: Fatal exception

Fixes: cdec67a489d4 ("bpf: tcp: Make sure iter->batch always contains a full bucket snapshot")
Reported-by: AutonomousCodeSecurity@microsoft.com
Signed-off-by: Xiang Mei (Microsoft) <xmei5@asu.edu>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Reviewed-by: Jordan Rife <jordan@jrife.io>
Link: https://patch.msgid.link/20260713233230.3553593-1-xmei5@asu.edu
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv4/tcp_ipv4.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/net/ipv4/tcp_ipv4.c b/net/ipv4/tcp_ipv4.c
index d5cd238358ef04..c7cf086cc6a1eb 100644
--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3144,8 +3144,11 @@ static struct sock *bpf_iter_tcp_batch(struct seq_file *seq)
 	bpf_iter_tcp_put_batch(iter);
 	err = bpf_iter_tcp_realloc_batch(iter, expected * 3 / 2,
 					 GFP_USER);
-	if (err)
+	if (err) {
+		iter->cur_sk = 0;
+		iter->end_sk = 0;
 		return ERR_PTR(err);
+	}
 
 	sk = bpf_iter_tcp_resume(seq);
 	if (!sk)
-- 
2.53.0



