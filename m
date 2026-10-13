Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5280733B6F8;
	Tue, 13 Oct 2026 12:54:41 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791896082; cv=none; b=OPOrYLZ+ezR8OdqVn7bgvU9rSw8LW6loJaV5Rm02KTIx0Bo6tzbUlpEwidtcCmUW6P5feeyNv2luLfCfS/829eU+kJ4X4M3pnoxEDlvR4IpE/wET/Lkt/34LNbgD7RrtCHtEaIqK79sCKNcY7iusB7OwoXhAjHSRnvb//f11mqM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791896082; c=relaxed/simple;
	bh=aUCEfttsQ0NC34RruQG6zYnEFqz1qY2mFsfWtTm77q4=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=AHv2yOa2MepPKdquMdY1tmcgkM+UEnAnq7DnLMfmno7DpZJukc3h9QwsNariL006GniC9yEaYreyilxIi4lpR7GvbzeuAnPe6ovqXbv+oNf8BoxzF0cZFArcX4LYZ45NpDiEdwqshofN0iJYAlr4oUC6sZwHomgRphA3PwdAF9U=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OwxYDCIm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OwxYDCIm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A05251F000FF;
	Tue, 13 Oct 2026 12:54:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791896081;
	bh=QqcoUmDAwDpH3/tztZ2ETMgoCJJcePNqfzp+BpyAiNM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OwxYDCImabP++sPATPUOKRImzd8hGQhG9VaPZxgNpuqW3RB/7XMeYBMUUy1i4gudr
	 /mmutbtIWnuQaQM13Y0Ii5OkFw98/9apMloEY1nqHZbsKbB+xxOdywvVrWOjaHoxlr
	 yTMjlfgVVkp8nppToeww9UJoxiPqd+Vej2bp2R48=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Ilia Gavrilov <Ilia.Gavrilov@infotecs.ru>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 490/497] vsock: Fix memory leak in vmci_transport_recv_dgram_cb()
Date: Tue, 13 Oct 2026 13:40:57 +0200
Message-ID: <20261013112919.506068746@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261013112907.864180619@linuxfoundation.org>
References: <20261013112907.864180619@linuxfoundation.org>
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
index 0cbe5a1a40d33..1fa4dd2ca405b 100644
--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -890,6 +890,8 @@ static void vsock_sk_destruct(struct sock *sk)
 {
 	struct vsock_sock *vsk = vsock_sk(sk);
 
+	/* Socket buffers may remain in the queue in VMCI datagram mode */
+	__skb_queue_purge(&sk->sk_receive_queue);
 	/* Flush MSG_ZEROCOPY leftovers. */
 	__skb_queue_purge(&sk->sk_error_queue);
 
-- 
2.53.0



