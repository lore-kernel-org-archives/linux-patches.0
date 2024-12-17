Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4E95D1F4735;
	Tue, 17 Dec 2024 17:10:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734455435; cv=none; b=MjUDpFdQZ+cbK5cpOlgxmPraZdHgLJ3ccWvphrBTmbIdeo6Y9w/a0+EhCkGnF/t6jpDzXHpuuqGsohi4714KJs15Q11ghc/iBhG2m1hqDstzqc18WSmBoh1wOabJ32RWLhkkjqm4rsam97ERty8rwHh0/ZnL7ZvefQx1Q2NBUM4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734455435; c=relaxed/simple;
	bh=lqWOK/rbKmF7J2S6T3EgIlUSrlqoSuKW/j/bamfWurM=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=A1OBVVgw3tQXZvRG+CaVqjohVwNVSgXqzGEA7UCRRFLA4oo467WaLcMn9smCEGKW/8V9yQHmhB557cHHSsF8XJov+CIFAa27e2Dp0sG43T98fAsTnpkn8sMP3f8z7LaeqCuwuZhQGJahEqZZ+mrAgbwwUca6E039exxDoCA5+SY=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=0KxxQSnz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="0KxxQSnz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C6B48C4CED3;
	Tue, 17 Dec 2024 17:10:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734455435;
	bh=lqWOK/rbKmF7J2S6T3EgIlUSrlqoSuKW/j/bamfWurM=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=0KxxQSnzG/smTqsPUNxQYGtnNPwzHObSUbjIc4M5i3S2yvc13T5+bPaz00srDSTIn
	 TkE26+lix5/zWNJ5dC/OlVa12SIOo5HtkPC6lKI+mbfniG2krVL7SEoW3cwmXjGytZ
	 1sbjdwRAONdcIeYz1/sQSF5VQvzplkg3FjQVtUtE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Paolo Abeni <pabeni@redhat.com>,
	Tomas Krcka <krckatom@amazon.de>
Subject: [PATCH 5.10 10/43] virtio/vsock: Fix accept_queue memory leak
Date: Tue, 17 Dec 2024 18:07:01 +0100
Message-ID: <20241217170520.873801175@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241217170520.459491270@linuxfoundation.org>
References: <20241217170520.459491270@linuxfoundation.org>
User-Agent: quilt/0.67
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

commit d7b0ff5a866724c3ad21f2628c22a63336deec3f upstream.

As the final stages of socket destruction may be delayed, it is possible
that virtio_transport_recv_listen() will be called after the accept_queue
has been flushed, but before the SOCK_DONE flag has been set. As a result,
sockets enqueued after the flush would remain unremoved, leading to a
memory leak.

vsock_release
  __vsock_release
    lock
    virtio_transport_release
      virtio_transport_close
        schedule_delayed_work(close_work)
    sk_shutdown = SHUTDOWN_MASK
(!) flush accept_queue
    release
                                        virtio_transport_recv_pkt
                                          vsock_find_bound_socket
                                          lock
                                          if flag(SOCK_DONE) return
                                          virtio_transport_recv_listen
                                            child = vsock_create_connected
                                      (!)   vsock_enqueue_accept(child)
                                          release
close_work
  lock
  virtio_transport_do_close
    set_flag(SOCK_DONE)
    virtio_transport_remove_sock
      vsock_remove_sock
        vsock_remove_bound
  release

Introduce a sk_shutdown check to disallow vsock_enqueue_accept() during
socket destruction.

unreferenced object 0xffff888109e3f800 (size 2040):
  comm "kworker/5:2", pid 371, jiffies 4294940105
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    28 00 0b 40 00 00 00 00 00 00 00 00 00 00 00 00  (..@............
  backtrace (crc 9e5f4e84):
    [<ffffffff81418ff1>] kmem_cache_alloc_noprof+0x2c1/0x360
    [<ffffffff81d27aa0>] sk_prot_alloc+0x30/0x120
    [<ffffffff81d2b54c>] sk_alloc+0x2c/0x4b0
    [<ffffffff81fe049a>] __vsock_create.constprop.0+0x2a/0x310
    [<ffffffff81fe6d6c>] virtio_transport_recv_pkt+0x4dc/0x9a0
    [<ffffffff81fe745d>] vsock_loopback_work+0xfd/0x140
    [<ffffffff810fc6ac>] process_one_work+0x20c/0x570
    [<ffffffff810fce3f>] worker_thread+0x1bf/0x3a0
    [<ffffffff811070dd>] kthread+0xdd/0x110
    [<ffffffff81044fdd>] ret_from_fork+0x2d/0x50
    [<ffffffff8100785a>] ret_from_fork_asm+0x1a/0x30

Fixes: 3fe356d58efa ("vsock/virtio: discard packets only when socket is really closed")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
[ Adapted due to missing commit 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff") ]
Signed-off-by: Tomas Krcka <krckatom@amazon.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/virtio_transport_common.c |    8 ++++++++
 1 file changed, 8 insertions(+)

--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -1062,6 +1062,14 @@ virtio_transport_recv_listen(struct sock
 		return -ENOMEM;
 	}
 
+	/* __vsock_release() might have already flushed accept_queue.
+	 * Subsequent enqueues would lead to a memory leak.
+	 */
+	if (sk->sk_shutdown == SHUTDOWN_MASK) {
+		virtio_transport_reset_no_sock(t, pkt);
+		return -ESHUTDOWN;
+	}
+
 	child = vsock_create_connected(sk);
 	if (!child) {
 		virtio_transport_reset_no_sock(t, pkt);


