Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E1D134F5DF3;
	Tue, 13 Oct 2026 11:59:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791892782; cv=none; b=NL6gEZPrKhZAL/VdHczv6WveIBr2ebT6U6YMlSnfG9wDJlrLmjTw9BhJ2mbsVC9ZhD5OstCdzPe9zodMgtdaW+hsiYyyDNwMHfYHphTQR2sCyQNCSJwCL5zgQoTK4GNu9NAKRBHjGhuzYPwbqP3qHBmtAvs/rxsoEIfmnalcBks=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791892782; c=relaxed/simple;
	bh=XMz/OnaFY0/BpQFnOP0Yd+GiF4w2R4uSnFOoQACyqXw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UsDj9ITfd6qRRjglKpCz00fGJNcoJUiFCH39Lzl7mTlr8uu5538rahksRnbHkrdgXPXR6+c6FVfgpjTjD4vU0xoz8acnxIIaaiDunVetrNKcAl03/8gWX5wPFEGoZ3KxjmZ4rI0wk1n+bjBvyA6g6M4+eFrrR8hPtGZl7QMU96Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=UbpZfinz; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="UbpZfinz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 42AAA1F000FF;
	Tue, 13 Oct 2026 11:59:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791892780;
	bh=ss9Zp/uueAixg32BLOXSd9NEOtitdGqLvd6Xo+kHeQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=UbpZfinzN/VKvTy7/R9x59b1bl77q3KD/zPZ2CIpD0xDyuxUXogjCsRWcqnHBF7z7
	 C+yfPah4sdrJdF4cp9QqEKk4O9xUBMd/qqJIok6ck8zgJjL5mJxr2QPlPXF54VKnSu
	 TOqVCbrMF4xU0dDN5idv3PtHwIMV3y6po0mVy/hc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.2 272/281] vsock: Fix memory leak in vmci_transport_recv_dgram_cb()
Date: Tue, 13 Oct 2026 13:39:48 +0200
Message-ID: <20261013112901.740471480@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112855.045212108@linuxfoundation.org>
References: <20261013112855.045212108@linuxfoundation.org>
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

7.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>

[ Upstream commit 7c24a4e87e219072e5e106f6791146cbf3b056b3 ]

During the closure of a datagram socket, the vmci_transport_recv_dgram_cb()
function may be called, which will add the packets
to the socket's backlog; then, after the receive queue is cleared,
the __release_sock() function will move the packet back from the socket's
backlog to the receive queue, which will lead to a memory leak.

sock_close
  __sock_release
    __vsock_release
      // take ownership by user-space
      lock_sock_nested
      sock_set_flag(sk, SOCK_DEAD)
      vmci_transport_release
                                      vmci_dispatch_dgs
                                        vmci_datagram_invoke_guest_handler
                                          vmci_transport_recv_dgram_cb
                                            sk_receive_skb
                                              if (!sock_owned_by_user(sk))
                                                  [...]
                                         (!)  else if sk_add_backlog()
                                                  [...]
  (!) skb_queue_purge(&sk->sk_receive_queue)

      release_sock
        __release_sock
          // move all packets from the backlog
          // to the receive queue
   (!)    sk_backlog_rcv
            vsock_queue_rcv_skb
            [...]
              __sock_queue_rcv_skb
                if (!sock_flag(sk, SOCK_DEAD))
                  // Since the socket is "dead", the function will not
                  // be called
                  sk->sk_data_ready(sk)
        sock_release_ownership(sk);
        sock_put

Add a receive queue cleanup in the socket destructor to fix this.

syzkaller report:

unreferenced object 0xffff8880117bfb80 (size 240):
  comm "irq/56-vmw_vmci", pid 205, jiffies 4295064448 (age 73.992s)
  hex dump (first 32 bytes):
    78 dc 26 1e 80 88 ff ff 78 dc 26 1e 80 88 ff ff  x.&.....x.&.....
    00 00 00 00 00 00 00 00 c0 da 26 1e 80 88 ff ff  ..........&.....
  backtrace:
    [<ffffffff82be8d97>] __alloc_skb+0x287/0x330 net/core/skbuff.c:505
    [<ffffffffa114bcbd>] vmci_transport_recv_dgram_cb+0xbd/0x210 [vmw_vsock_vmci_transport]
    [<ffffffffa05072c6>] vmci_datagram_invoke_guest_handler+0x366/0x450 [vmw_vmci]
    [<ffffffffa050ad75>] vmci_dispatch_dgs+0x235/0x490 [vmw_vmci]
    [<ffffffffa050b025>] vmci_interrupt+0x55/0x290 [vmw_vmci]
    [<ffffffff8137ad2b>] irq_thread_fn+0x8b/0x1a0 kernel/irq/manage.c:1205
    [<ffffffff8137c7ae>] irq_thread+0x28e/0x530 kernel/irq/manage.c:1314
    [<ffffffff81253dd6>] kthread+0x2e6/0x3a0 kernel/kthread.c:376
    [<ffffffff81004392>] ret_from_fork+0x22/0x30 arch/x86/entry/entry_64.S:295

Found by InfoTeCS on behalf of Linux Verification Center
(linuxtesting.org) with Syzkaller.

Fixes: d021c344051a ("VSOCK: Introduce VM Sockets")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>
Link: https://patch.msgid.link/20261008144046.90853-1-Ilia.Gavrilov@infotecs.ru
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/af_vsock.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
index 4a1dfde8414f4..f271a095996c9 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -1021,6 +1021,8 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	/* Socket buffers may remain in the queue in VMCI datagram mode */
+	__skb_queue_purge(&sk->sk_receive_queue);
 	/* Flush MSG_ZEROCOPY leftovers. */
 	__skb_queue_purge(&sk->sk_error_queue);
 
-- 
2.53.0



