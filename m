Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F3EF23A8F3
	for <patches@lists.linux.dev>; Wed, 15 Nov 2023 19:51:51 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="2QSbng0I"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A57F9C433CA;
	Wed, 15 Nov 2023 19:51:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1700077911;
	bh=pG2ITld3UQLG43pBbuGcrZD4YPMJ13sStMlb8li8GHk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=2QSbng0Idh0M2Xtx+nod2GeM92oF2dVpVrAgIG4LDViggBHWJ1HflQKY2SWxy6ZCm
	 jPQ+Ny9k1CJQrR23cd75ndwID2npurTan7gT9LHdA8Z5yTlt6ATR6nldXtkfH+wGUI
	 zJ+x7T7068WECxj3fMRBO+GQzQG4ttuSZd198+Nw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Shigeru Yoshida <syoshida@redhat.com>,
	Stefano Garzarella <sgarzare@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>,
	syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
Subject: [PATCH 6.6 571/603] virtio/vsock: Fix uninit-value in virtio_transport_recv_pkt()
Date: Wed, 15 Nov 2023 14:18:36 -0500
Message-ID: <20231115191651.031685492@linuxfoundation.org>
X-Mailer: git-send-email 2.42.1
In-Reply-To: <20231115191613.097702445@linuxfoundation.org>
References: <20231115191613.097702445@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Shigeru Yoshida <syoshida@redhat.com>

[ Upstream commit 34c4effacfc329aeca5635a69fd9e0f6c90b4101 ]

KMSAN reported the following uninit-value access issue:

=====================================================
BUG: KMSAN: uninit-value in virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 virtio_transport_recv_pkt+0x1dfb/0x26a0 net/vmw_vsock/virtio_transport_common.c:1421
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was stored to memory at:
 virtio_transport_space_update net/vmw_vsock/virtio_transport_common.c:1274 [inline]
 virtio_transport_recv_pkt+0x1ee8/0x26a0 net/vmw_vsock/virtio_transport_common.c:1415
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

Uninit was created at:
 slab_post_alloc_hook+0x105/0xad0 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x5a2/0xaf0 mm/slub.c:3523
 kmalloc_reserve+0x13c/0x4a0 net/core/skbuff.c:559
 __alloc_skb+0x2fd/0x770 net/core/skbuff.c:650
 alloc_skb include/linux/skbuff.h:1286 [inline]
 virtio_vsock_alloc_skb include/linux/virtio_vsock.h:66 [inline]
 virtio_transport_alloc_skb+0x90/0x11e0 net/vmw_vsock/virtio_transport_common.c:58
 virtio_transport_reset_no_sock net/vmw_vsock/virtio_transport_common.c:957 [inline]
 virtio_transport_recv_pkt+0x1279/0x26a0 net/vmw_vsock/virtio_transport_common.c:1387
 vsock_loopback_work+0x3bb/0x5a0 net/vmw_vsock/vsock_loopback.c:120
 process_one_work kernel/workqueue.c:2630 [inline]
 process_scheduled_works+0xff6/0x1e60 kernel/workqueue.c:2703
 worker_thread+0xeca/0x14d0 kernel/workqueue.c:2784
 kthread+0x3cc/0x520 kernel/kthread.c:388
 ret_from_fork+0x66/0x80 arch/x86/kernel/process.c:147
 ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:304

CPU: 1 PID: 10664 Comm: kworker/1:5 Not tainted 6.6.0-rc3-00146-g9f3ebbef746f #3
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.16.2-1.fc38 04/01/2014
Workqueue: vsock-loopback vsock_loopback_work
=====================================================

The following simple reproducer can cause the issue described above:

int main(void)
{
  int sock;
  struct sockaddr_vm addr = {
    .svm_family = AF_VSOCK,
    .svm_cid = VMADDR_CID_ANY,
    .svm_port = 1234,
  };

  sock = socket(AF_VSOCK, SOCK_STREAM, 0);
  connect(sock, (struct sockaddr *)&addr, sizeof(addr));
  return 0;
}

This issue occurs because the `buf_alloc` and `fwd_cnt` fields of the
`struct virtio_vsock_hdr` are not initialized when a new skb is allocated
in `virtio_transport_init_hdr()`. This patch resolves the issue by
initializing these fields during allocation.

Fixes: 71dc9ec9ac7d ("virtio/vsock: replace virtio_vsock_pkt with sk_buff")
Reported-and-tested-by: syzbot+0c8ce1da0ac31abbadcd@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=0c8ce1da0ac31abbadcd
Signed-off-by: Shigeru Yoshida <syoshida@redhat.com>
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Link: https://lore.kernel.org/r/20231104150531.257952-1-syoshida@redhat.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/vmw_vsock/virtio_transport_common.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/vmw_vsock/virtio_transport_common.c b/net/vmw_vsock/virtio_transport_common.c
index eb1465d506ef3..8bc272b6003bb 100644
--- a/net/vmw_vsock/virtio_transport_common.c
+++ b/net/vmw_vsock/virtio_transport_common.c
@@ -68,6 +68,8 @@ virtio_transport_alloc_skb(struct virtio_vsock_pkt_info *info,
 	hdr->dst_port	= cpu_to_le32(dst_port);
 	hdr->flags	= cpu_to_le32(info->flags);
 	hdr->len	= cpu_to_le32(len);
+	hdr->buf_alloc	= cpu_to_le32(0);
+	hdr->fwd_cnt	= cpu_to_le32(0);
 
 	if (info->msg && len > 0) {
 		payload = skb_put(skb, len);
-- 
2.42.0



