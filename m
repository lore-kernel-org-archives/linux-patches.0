Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1BBA73C2794;
	Mon, 17 Aug 2026 13:50:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974617; cv=none; b=feXPAE9MclZiSqjaWAwgfbpjb7ypi/RqDaGvN/smmEr/rUJmeUX/3431yxuLN0A1Dc4s1wYW8fZW1ZBPgIR547JPT++hQKg4wEqvKLSzRcEd4vMCgzFqtlkPPXAY6SQc8W0PrLimOFCzMwxRosXlWZ4/ydf1Mp2/OVnpV46JB98=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974617; c=relaxed/simple;
	bh=it1nzfsE6ViZokxgc5VntxjJqXlAnuyfInMgIof5D6g=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TJMROSusDRJ8vXrpyH+kkAluQAI2LJy97oQrmTwlBxm6GQ9oDgm2c6E5MJLW7E/WGvBjjojOLsmxPUnfe2NTNEjy5uH9+0c/BPvrQ0sh2AUih1KcM0o6CSpPqZ8eHkzPAY/IDZM1L0CT/PWuAJ3MwZAhuVLo2Oh1u/4aalhcfxI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=DjRyV3sx; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="DjRyV3sx"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 395A81F00A3D;
	Mon, 17 Aug 2026 13:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974608;
	bh=pM9b9N9AIt2J19BH3NwgbE+PTJsU7Ejaxga06iWPpaY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=DjRyV3sxKU2Tf0+Y1rYlHfW3Z32VG5veDBjmSReiwVIc1NtGElyU78le6KyNlOu8s
	 xbjO2Vws9uY2kNvWnr5F+yWsMMzzVWdCsC79yNCk0j1yg6LjJqw2cFav6VsZ8NxLz0
	 7gEGOtxXU0HytOpNi4SgZBv19qD554m5qkSqXf4E=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Chengfeng Ye <nicoyip.dev@gmail.com>,
	John Fastabend <john.fastabend@gmail.com>,
	Emil Tsalapatis <emil@etsalapatis.com>,
	Kumar Kartikeya Dwivedi <memxor@gmail.com>
Subject: [PATCH 7.1 265/271] bpf, sockmap: Fix sk_redir use-after-free in send verdict
Date: Mon, 17 Aug 2026 15:33:10 +0200
Message-ID: <20260817132547.620414669@linuxfoundation.org>
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
Content-Transfer-Encoding: 8bit

7.1-stable review patch.  If anyone has any objections, please let me know.

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
@@ -454,6 +454,7 @@ more_data:
 	case __SK_REDIRECT:
 		redir_ingress = psock->redir_ingress;
 		sk_redir = psock->sk_redir;
+		sock_hold(sk_redir);
 		sk_msg_apply_bytes(psock, tosend);
 		if (!psock->apply_bytes) {
 			/* Clean up before releasing the sock lock. */
@@ -474,6 +475,7 @@ more_data:
 
 		if (eval == __SK_REDIRECT)
 			sock_put(sk_redir);
+		sock_put(sk_redir);
 
 		lock_sock(sk);
 		sk_mem_uncharge(sk, sent);


