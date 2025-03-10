Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8498F1C3C1C;
	Mon, 10 Mar 2025 18:23:45 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1741631025; cv=none; b=WI97+p9sfHwraFiQkIuusM2z+DSx41+1S6TW/RMqFKP02f3gZRyyTD/paqT3U61QRgQgquSNRJOI95VgKqFng5Q60xiGNZ0gFBh5606R/zjlv5VmUup3nX/yJtwLGvkT12v6rvDMfIv68Q8i4DO2QVT+JSx85Zajw7NGtbx4OdM=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1741631025; c=relaxed/simple;
	bh=0MRihkeKRYA/9MaR3wylJRLnbRqBx6GcyGyirw1yKmI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=P7U7kLfB91x+nMgBQ+zCvWLe9WupvCMEVPa9gEqK8CKKlZ3AiPiQIsl2JWt5d3eGrstCSyNrv7TpcC0lA0bRc4jYhs+KMTUPAtK8V87YoRN94MoUkvjHD6DUeCSMgKUnbYzfwh88mNbkbbhjuuZ80FWGVx7goBb7OwNzqL1anJ0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=FuKy1adm; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="FuKy1adm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FAD5C4CEE5;
	Mon, 10 Mar 2025 18:23:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1741631025;
	bh=0MRihkeKRYA/9MaR3wylJRLnbRqBx6GcyGyirw1yKmI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=FuKy1adm7mqIoA3aS3Tx3URyZBepk9H+0BUzkZcf3DSJviF8lkM+0H03OpiZ1eddS
	 IFnBAqaCIbviGA+IC8jmIVOHTfFa3pHO2WvMkFdFchwbOzGcLVEfdBf44LNHixxEYA
	 GytORIDLaPg5M/UdFSNQaYxtPZy53Gzi3NN5W3aI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Stefano Garzarella <sgarzare@redhat.com>,
	Michal Luczaj <mhal@rbox.co>,
	Jakub Kicinski <kuba@kernel.org>,
	Luigi Leonardi <leonardi@redhat.com>
Subject: [PATCH 5.15 616/620] vsock: Keep the binding until socket destruction
Date: Mon, 10 Mar 2025 18:07:42 +0100
Message-ID: <20250310170609.850947639@linuxfoundation.org>
X-Mailer: git-send-email 2.48.1
In-Reply-To: <20250310170545.553361750@linuxfoundation.org>
References: <20250310170545.553361750@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

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
@@ -815,12 +818,13 @@ static void __vsock_release(struct sock
 	 */
 	lock_sock_nested(sk, level);
 
+	sock_orphan(sk);
+
 	if (vsk->transport)
 		vsk->transport->release(vsk);
 	else if (sock_type_connectible(sk->sk_type))
 		vsock_remove_sock(vsk);
 
-	sock_orphan(sk);
 	sk->sk_shutdown = SHUTDOWN_MASK;
 
 	skb_queue_purge(&sk->sk_receive_queue);


