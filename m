Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BF73C43C7C1;
	Mon, 17 Aug 2026 14:59:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786978778; cv=none; b=RRK2mldSGJyLmWuWnzDS0+j8sEfF6ESjbcoYYEhi7cOByM5lRJBBLSyOFWkBxgF5EvoTZaUwllbPTkEcRX2gy4uf9VMFUdoPs3r+1u/gaA8lYZi7X0v0oFWi+GUCOeRvLqd+9aS7LSj7vaM33po8zEuvPtuYZ9DN/BpIXkSVWhM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786978778; c=relaxed/simple;
	bh=TjPLRJQKXJwd+CWoUM5VLHziW27sPk7ohOEMrnpCQNc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=knzcqnmE0tU2MYmwhVUXOBptIJcMFNVOISepICWmAVvUDMhRmb1KSKt3WTWg9nhPtX7oFRj+0GM9hPyUK2UFQEnrYJ8MvQa3bR/vOEp9mcev9z3TlsAthvXhNwhsNfzf9r2hh68SWEN3khdqbuKXlub43T33nJA3tsjafkSQf4I=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=vz9xPtHB; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="vz9xPtHB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1A2251F000E9;
	Mon, 17 Aug 2026 14:59:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786978777;
	bh=M4FF4nbtrbPzsHXHidzEdx5QaFWX7rHHHFF1s9MVwwE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=vz9xPtHBaoKaB4jktOE2VjfMGNgeDCmpmtIThd61ZDjaQ3FwR/S8n3sXoP03wvAIL
	 H4z3530pp0JCbn0COqxpu8j3cq15W6bZfY8J4YjGxiJt1Fie54mlWmDD1GERAx2yYK
	 48YN2CzcIxMR2+g+BTeigw7qUCfjBE+rlSxc57nA=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	AutonomousCodeSecurity@microsoft.com,
	"Xiang Mei (Microsoft)" <xmei5@asu.edu>,
	Eric Dumazet <edumazet@google.com>,
	Jordan Rife <jordan@jrife.io>,
	Paolo Abeni <pabeni@redhat.com>
Subject: [PATCH 6.6 153/156] bpf: tcp: fix double sock release on batch realloc
Date: Mon, 17 Aug 2026 15:34:47 +0200
Message-ID: <20260817132540.743791100@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132534.666299318@linuxfoundation.org>
References: <20260817132534.666299318@linuxfoundation.org>
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

From: Xiang Mei (Microsoft) <xmei5@asu.edu>

commit 980a813452754f8001704744e92f7aa697c53dd3 upstream.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_ipv4.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/net/ipv4/tcp_ipv4.c
+++ b/net/ipv4/tcp_ipv4.c
@@ -3061,8 +3061,11 @@ again:
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


