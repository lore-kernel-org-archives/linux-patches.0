Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF4F0408617;
	Mon, 17 Aug 2026 14:43:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786977789; cv=none; b=bjnVNrrhGVQtKcchJvDaN5LS0PCw3KCtmbf39UwYtYypjvdS4S6zIYKzOMO4Dd2+1y5UZ/QNzLJhs8uoW/vB+SYixyEJYrk+QJvRK8MCwqSj5r6DXr+CwOlLdInuN/u2zj0sYlrHnN8hJRuEnrvZp6H/xbyvY5RkpgUXYEXmnss=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786977789; c=relaxed/simple;
	bh=Togtsr0F3brscqgAkuuvSVJqrxAZpAwFFNceBF4B8Pc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=uAqghEEgGAAu+SwA5O0eYHinj4jJtzzkRznr0fDn0lgsZgmq7LC835s83/GW7GcglDZwWFIg27BdYboo7rMgkUPajDRsZRjLgRkzo9fL2IHtWWwFcA10gyX8gWS2P3jgS5vyj+3X1U/0t8TV9b+A8MaJxfxq8SjMAAV0GNXN3bk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Z3/Ye8rr; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Z3/Ye8rr"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3547C1F000E9;
	Mon, 17 Aug 2026 14:43:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786977787;
	bh=zCVpMCRYQAkyeJql4+KgPM66+merkQWf3Alcqp5bhOg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Z3/Ye8rrCbmi2nnUQ2P6FtthajLcOJV3gAdLMpgkbJjuHBFCUGMYA3BTCGYdl6Prd
	 YfAnUTb3NB+yDfMN0+X4+HMmOJnZFHj2lD4B4FyHgAvtAJOOn+zeltBvmGjbJIG/7W
	 bYRUiCoJv96a/gn5uiz4/kKJ66NL32Q0rbE92mjk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 5.15 451/456] bpf, sockmap: Fix sk_redir use-after-free in send verdict
Date: Mon, 17 Aug 2026 15:34:01 +0200
Message-ID: <20260817132556.669271303@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132539.792407575@linuxfoundation.org>
References: <20260817132539.792407575@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Chengfeng Ye <nicoyip.dev@gmail.com>

commit a76624733730e541e4955fdecf506af2f6b20558 upstream.

sk_psock_msg_verdict() takes a socket reference for psock->sk_redir.
tcp_bpf_send_verdict() copies that pointer while holding the source socket
lock, but does not take a reference for the local copy before dropping the
lock around tcp_bpf_sendmsg_redir().

When apply_bytes keeps the cached verdict active, another sendmsg() on the
same source socket can consume the remaining bytes and release the cached
reference while the first thread still holds only the raw local pointer:

  CPU 0                                  CPU 1
  sk_redir = psock->sk_redir
  apply_bytes remains nonzero
  release_sock(sk)
                                         lock_sock(sk)
                                         apply_bytes reaches zero
                                         psock->sk_redir = NULL
                                         release_sock(sk)
                                         tcp_bpf_sendmsg_redir(sk_redir)
                                         sock_put(sk_redir)
  tcp_bpf_sendmsg_redir(sk_redir)

The final sock_put() can free sk_redir before CPU 0 dereferences it.

KASAN reported:

  BUG: KASAN: slab-use-after-free in tcp_bpf_sendmsg_redir+0xf39/0x1020
  Read of size 8 at addr ffff888108537090 by task poc/87
  Call Trace:
   tcp_bpf_sendmsg_redir+0xf39/0x1020
   tcp_bpf_sendmsg+0x977/0x1a50
   __sys_sendto+0x32c/0x3a0
   __x64_sys_sendto+0xdb/0x1b0
  Allocated by task 85:
   sk_prot_alloc+0x56/0x210
   sk_clone+0x6f/0x14b0
   inet_csk_clone_lock+0x24/0x740
   tcp_create_openreq_child+0x25/0x2710
   tcp_v4_syn_recv_sock+0x10a/0xe00
  Freed by task 0:
   __kasan_slab_free+0x43/0x70
   slab_free_after_rcu_debug+0xa6/0x1e0
   rcu_core+0x50a/0x1850
  Last potentially related work creation:
   __sk_destruct+0x3da/0x540
   sk_psock_destroy+0x81e/0xab0
   process_one_work+0x63a/0x1070

Take a temporary socket reference while the source socket lock still
protects psock->sk_redir, and drop it after tcp_bpf_sendmsg_redir()
returns.  This keeps each unlocked use independent of cached-verdict
ownership.

Fixes: 604326b41a6f ("bpf, sockmap: convert to generic sk_msg interface")
Signed-off-by: Chengfeng Ye <nicoyip.dev@gmail.com>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Reviewed-by: Emil Tsalapatis <emil@etsalapatis.com>
Cc: stable@vger.kernel.org
Link: https://lore.kernel.org/bpf/20260719152207.2892156-1-nicoyip.dev@gmail.com
Signed-off-by: Kumar Kartikeya Dwivedi <memxor@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/ipv4/tcp_bpf.c |    2 ++
 1 file changed, 2 insertions(+)

--- a/net/ipv4/tcp_bpf.c
+++ b/net/ipv4/tcp_bpf.c
@@ -390,6 +390,7 @@ more_data:
 	case __SK_REDIRECT:
 		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
+		sock_hold(sk_redir);
 		sk_msg_apply_bytes(psock, tosend);
 		if (!psock->apply_bytes) {
 			/* Clean up before releasing the sock lock. */
@@ -410,6 +411,7 @@ more_data:
 
 		if (eval == __SK_REDIRECT)
 			sock_put(sk_redir);
+		sock_put(sk_redir);
 
 		lock_sock(sk);
 		sk_mem_uncharge(sk, sent);


