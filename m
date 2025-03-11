Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5CAB2255E37;
	Tue, 11 Mar 2025 15:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741707672; cv=none; b=WKhVT411Db/YsvnyjthGcQvT5TdXOroJEOXljTe5sSfkcbER2XqqeIC0dYlUxhbxv5iab3SIKLas9L9EvguaoTKHreVv8mUFXP9ObnzWkzz3RUOOkaj5EEVD++PYfhmWj2jgNrjDHHedZrinQApE6ySmaRIIEjDZkuDFudPaFm8=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741707672; c=relaxed/simple;
	bh=NYH8tbnkDVMDKfK5+wRHbVvMgdy6bhUy/KNAF/pwZEI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=CQxHdqtry5y2EnUN8MhEsd4AxK4OSx/iiSy5B5QKo/dBj51uz2bXvMECqHy0I5Y9ak7c9G29w+oqF6ioU4agny6u6LCY9rl1NSVYSVO0Qu/fb0/mtxn76sF/pIiXMoeK4EBdwkA+wNKJLEYRKoYJkuT9HBFKtuv8ho+zu/kucoo=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=CHJYwohp; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="CHJYwohp"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 45671C4CEE9;
	Tue, 11 Mar 2025 15:41:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741707671;
	bh=NYH8tbnkDVMDKfK5+wRHbVvMgdy6bhUy/KNAF/pwZEI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=CHJYwohpAqgVFvTviMRhlugBgwAhtzfvPIgA5m6MdqtHD2rJUKUcLXaZOo7G4VOsP
	 drTgE0YZYVYjj8kTCitZ8PrGIZapPrBFpOY8CXhXUpTCfZk8w7se7qx81VE1kZiP07
	 DnI948T+ad8D4Et5VXg2arH4xdkWYRYQjOi9XzTw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 5.10 453/462] vsock: Keep the binding until socket destruction
Date: Tue, 11 Mar 2025 16:01:59 +0100
Message-ID: <20250311145816.216789312@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250311145758.343076290@linuxfoundation.org>
References: <20250311145758.343076290@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michal Luczaj <mhal@rbox.co>

commit fcdd2242c0231032fc84e1404315c245ae56322a upstream.

Preserve sockets bindings; this includes both resulting from an explicit
bind() and those implicitly bound through autobind during connect().

Prevents socket unbinding during a transport reassignment, which fixes a
use-after-free:

    1. vsock_create() (refcnt=1) calls vsock_insert_unbound() (refcnt=2)
    2. transport->release() calls vsock_remove_bound() without checking if
       sk was bound and moved to bound list (refcnt=1)
    3. vsock_bind() assumes sk is in unbound list and before
       __vsock_insert_bound(vsock_bound_sockets()) calls
       __vsock_remove_bound() which does:
           list_del_init(&vsk->bound_table); // nop
           sock_put(&vsk->sk);               // refcnt=0

BUG: KASAN: slab-use-after-free in __vsock_bind+0x62e/0x730
Read of size 4 at addr ffff88816b46a74c by task a.out/2057
 dump_stack_lvl+0x68/0x90
 print_report+0x174/0x4f6
 kasan_report+0xb9/0x190
 __vsock_bind+0x62e/0x730
 vsock_bind+0x97/0xe0
 __sys_bind+0x154/0x1f0
 __x64_sys_bind+0x6e/0xb0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Allocated by task 2057:
 kasan_save_stack+0x1e/0x40
 kasan_save_track+0x10/0x30
 __kasan_slab_alloc+0x85/0x90
 kmem_cache_alloc_noprof+0x131/0x450
 sk_prot_alloc+0x5b/0x220
 sk_alloc+0x2c/0x870
 __vsock_create.constprop.0+0x2e/0xb60
 vsock_create+0xe4/0x420
 __sock_create+0x241/0x650
 __sys_socket+0xf2/0x1a0
 __x64_sys_socket+0x6e/0xb0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 2057:
 kasan_save_stack+0x1e/0x40
 kasan_save_track+0x10/0x30
 kasan_save_free_info+0x37/0x60
 __kasan_slab_free+0x4b/0x70
 kmem_cache_free+0x1a1/0x590
 __sk_destruct+0x388/0x5a0
 __vsock_bind+0x5e1/0x730
 vsock_bind+0x97/0xe0
 __sys_bind+0x154/0x1f0
 __x64_sys_bind+0x6e/0xb0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

refcount_t: addition on 0; use-after-free.
WARNING: CPU: 7 PID: 2057 at lib/refcount.c:25 refcount_warn_saturate+0xce/0x150
RIP: 0010:refcount_warn_saturate+0xce/0x150
 __vsock_bind+0x66d/0x730
 vsock_bind+0x97/0xe0
 __sys_bind+0x154/0x1f0
 __x64_sys_bind+0x6e/0xb0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

refcount_t: underflow; use-after-free.
WARNING: CPU: 7 PID: 2057 at lib/refcount.c:28 refcount_warn_saturate+0xee/0x150
RIP: 0010:refcount_warn_saturate+0xee/0x150
 vsock_remove_bound+0x187/0x1e0
 __vsock_release+0x383/0x4a0
 vsock_release+0x90/0x120
 __sock_release+0xa3/0x250
 sock_close+0x14/0x20
 __fput+0x359/0xa80
 task_work_run+0x107/0x1d0
 do_exit+0x847/0x2560
 do_group_exit+0xb8/0x250
 __x64_sys_exit_group+0x3a/0x50
 x64_sys_call+0xfec/0x14f0
 do_syscall_64+0x93/0x1b0
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Fixes: c0cfa2d8a788 ("vsock: add multi-transports support")
Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
Signed-off-by: Michal Luczaj <mhal@rbox.co>
Link: https://patch.msgid.link/20250128-vsock-transport-vs-autobind-v3-1-1cf57065b770@rbox.co
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Luigi Leonardi <leonardi@redhat.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/vmw_vsock/af_vsock.c |    8 ++++++--
 1 file changed, 6 insertions(+), 2 deletions(-)

--- a/net/vmw_vsock/af_vsock.c
+++ b/net/vmw_vsock/af_vsock.c
@@ -330,7 +330,10 @@ EXPORT_SYMBOL_GPL(vsock_find_connected_s
 
 void vsock_remove_sock(struct vsock_sock *vsk)
 {
-	vsock_remove_bound(vsk);
+	/* Transport reassignment must not remove the binding. */
+	if (sock_flag(sk_vsock(vsk), SOCK_DEAD))
+		vsock_remove_bound(vsk);
+
 	vsock_remove_connected(vsk);
 }
 EXPORT_SYMBOL_GPL(vsock_remove_sock);
@@ -782,12 +785,13 @@ static void __vsock_release(struct sock
 	 */
 	lock_sock_nested(sk, level);
 
+	sock_orphan(sk);
+
 	if (vsk->transport)
 		vsk->transport->release(vsk);
 	else if (sk->sk_type == SOCK_STREAM)
 		vsock_remove_sock(vsk);
 
-	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	skb_queue_purge(&sk->sk_receive_queue);


