Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 22C6E2EA143;
	Tue, 17 Jun 2025 16:01:43 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750176103; cv=none; b=qjCqlT4w+XYh/6AP+B6uUfpMUoC/6j3bFSmnO4X5CXD2H+vkZVXP7rI/dYySncwbchy7Rm2xPDdnzYq4oPLJ1g15QUKMjUxqYmK5IN4ljH/p5ByBGFZI+tEwo7f7WaMFLP9uHd2+GtVxda4Q8M5Yr3wR40PJnz6e4E5VWcqZm7Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750176103; c=relaxed/simple;
	bh=zZeN5Ko0eypIRjKN/M8uacwOmVrFvlGFgn6TVKSM5mo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VPYlboE3bWyQT77whnPY6YKYC7wVFPRQbP+IN2rvlrbudz7ZJvnIj37rOi/0L9yfhtQk18DqAq7yF2wiqo9FHvP5OvCZtxFd/DRLw2uT6vYkZsBNWpUhdIoDg/h4hnKd3GYQWhPt8g9AHOB6ePcd+F05dTl1j2Nc1iHOow88nH8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FFymzH9m; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FFymzH9m"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91A7EC4CEE3;
	Tue, 17 Jun 2025 16:01:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750176103;
	bh=zZeN5Ko0eypIRjKN/M8uacwOmVrFvlGFgn6TVKSM5mo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FFymzH9mcIR4GFUy3b0oyS109JCBkZtRfinP4wIs4hwnbfVSgG2ewngP4Lj2FJhs3
	 w1ih1Lnn6KCClFqpZaIt1706G2jqp8J02kSbnTyLtvdln1QEDJDcgcn4A35w5o0JrM
	 FxGnkBZ4HANeusi1Ttr54fZnZJRqh+t3EBYRlDfY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Michal Luczaj <mhal@rbox.co>,
	Jiayuan Chen <jiayuan.chen@linux.dev>,
	Martin KaFai Lau <martin.lau@kernel.org>,
	John Fastabend <john.fastabend@gmail.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 196/512] bpf, sockmap: Avoid using sk_socket after free when sending
Date: Tue, 17 Jun 2025 17:22:42 +0200
Message-ID: <20250617152427.578392406@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250617152419.512865572@linuxfoundation.org>
References: <20250617152419.512865572@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Jiayuan Chen <jiayuan.chen@linux.dev>

[ Upstream commit 8259eb0e06d8f64c700f5fbdb28a5c18e10de291 ]

The sk->sk_socket is not locked or referenced in backlog thread, and
during the call to skb_send_sock(), there is a race condition with
the release of sk_socket. All types of sockets(tcp/udp/unix/vsock)
will be affected.

Race conditions:
'''
CPU0                               CPU1

backlog::skb_send_sock
  sendmsg_unlocked
    sock_sendmsg
      sock_sendmsg_nosec
                                   close(fd):
                                     ...
                                     ops->release() -> sock_map_close()
                                     sk_socket->ops = NULL
                                     free(socket)
      sock->ops->sendmsg
            ^
            panic here
'''

The ref of psock become 0 after sock_map_close() executed.
'''
void sock_map_close()
{
    ...
    if (likely(psock)) {
    ...
    // !! here we remove psock and the ref of psock become 0
    sock_map_remove_links(sk, psock)
    psock = sk_psock_get(sk);
    if (unlikely(!psock))
        goto no_psock; <=== Control jumps here via goto
        ...
        cancel_delayed_work_sync(&psock->work); <=== not executed
        sk_psock_put(sk, psock);
        ...
}
'''

Based on the fact that we already wait for the workqueue to finish in
sock_map_close() if psock is held, we simply increase the psock
reference count to avoid race conditions.

With this patch, if the backlog thread is running, sock_map_close() will
wait for the backlog thread to complete and cancel all pending work.

If no backlog running, any pending work that hasn't started by then will
fail when invoked by sk_psock_get(), as the psock reference count have
been zeroed, and sk_psock_drop() will cancel all jobs via
cancel_delayed_work_sync().

In summary, we require synchronization to coordinate the backlog thread
and close() thread.

The panic I catched:
'''
Workqueue: events sk_psock_backlog
RIP: 0010:sock_sendmsg+0x21d/0x440
RAX: 0000000000000000 RBX: ffffc9000521fad8 RCX: 0000000000000001
...
Call Trace:
 <TASK>
 ? die_addr+0x40/0xa0
 ? exc_general_protection+0x14c/0x230
 ? asm_exc_general_protection+0x26/0x30
 ? sock_sendmsg+0x21d/0x440
 ? sock_sendmsg+0x3e0/0x440
 ? __pfx_sock_sendmsg+0x10/0x10
 __skb_send_sock+0x543/0xb70
 sk_psock_backlog+0x247/0xb80
...
'''

Fixes: 4b4647add7d3 ("sock_map: avoid race between sock_map_close and sk_psock_put")
Reported-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Jiayuan Chen <jiayuan.chen@linux.dev>
Signed-off-by: Martin KaFai Lau <martin.lau@kernel.org>
Reviewed-by: John Fastabend <john.fastabend@gmail.com>
Link: https://lore.kernel.org/r/20250516141713.291150-1-jiayuan.chen@linux.dev
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/core/skmsg.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/net/core/skmsg.c b/net/core/skmsg.c
index 1219e0404def0..a8d238dd982af 100644
--- a/net/core/skmsg.c
+++ b/net/core/skmsg.c
@@ -655,6 +655,13 @@ static void sk_psock_backlog(struct work_struct *work)
 	bool ingress;
 	int ret;
 
+	/* Increment the psock refcnt to synchronize with close(fd) path in
+	 * sock_map_close(), ensuring we wait for backlog thread completion
+	 * before sk_socket freed. If refcnt increment fails, it indicates
+	 * sock_map_close() completed with sk_socket potentially already freed.
+	 */
+	if (!sk_psock_get(psock->sk))
+		return;
 	mutex_lock(&psock->work_mutex);
 	while ((skb = skb_peek(&psock->ingress_skb))) {
 		len = skb->len;
@@ -706,6 +713,7 @@ static void sk_psock_backlog(struct work_struct *work)
 	}
 end:
 	mutex_unlock(&psock->work_mutex);
+	sk_psock_put(psock->sk, psock);
 }
 
 struct sk_psock *sk_psock_init(struct sock *sk, int node)
-- 
2.39.5



