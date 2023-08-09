Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id F39E91773D
	for <patches@lists.linux.dev>; Wed,  9 Aug 2023 11:18:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 74742C433C7;
	Wed,  9 Aug 2023 11:18:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1691579898;
	bh=NXMHAvA2/MMpP/mRwMTUPCFYlW1B8yNBcD/yJg8l9rU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Stxw+StB6Re/YfYObGiqgMr26SPy/ULF0UejLHwNqnu/XrCAb3ZCBNLn0PNI7e1un
	 om+ljSVUOZdlw+j7YZj1SGCj3B6cx8IP0BpiQ60eQdKgJ5ZwXkgwb78Lr9cEsvTYkR
	 23fXfN9isSfYREKk8EjBEzjFHq1+7SQRW6cCvaKw=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Ding Hui <dinghui@sangfor.com.cn>,
	Chuck Lever <chuck.lever@oracle.com>
Subject: [PATCH 4.19 155/323] SUNRPC: Fix UAF in svc_tcp_listen_data_ready()
Date: Wed,  9 Aug 2023 12:39:53 +0200
Message-ID: <20230809103705.245561890@linuxfoundation.org>
X-Mailer: git-send-email 2.41.0
In-Reply-To: <20230809103658.104386911@linuxfoundation.org>
References: <20230809103658.104386911@linuxfoundation.org>
User-Agent: quilt/0.67
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

From: Ding Hui <dinghui@sangfor.com.cn>

commit fc80fc2d4e39137869da3150ee169b40bf879287 upstream.

After the listener svc_sock is freed, and before invoking svc_tcp_accept()
for the established child sock, there is a window that the newsock
retaining a freed listener svc_sock in sk_user_data which cloning from
parent. In the race window, if data is received on the newsock, we will
observe use-after-free report in svc_tcp_listen_data_ready().

Reproduce by two tasks:

1. while :; do rpc.nfsd 0 ; rpc.nfsd; done
2. while :; do echo "" | ncat -4 127.0.0.1 2049 ; done

KASAN report:

  ==================================================================
  BUG: KASAN: slab-use-after-free in svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
  Read of size 8 at addr ffff888139d96228 by task nc/102553
  CPU: 7 PID: 102553 Comm: nc Not tainted 6.3.0+ #18
  Hardware name: VMware, Inc. VMware Virtual Platform/440BX Desktop Reference Platform, BIOS 6.00 11/12/2020
  Call Trace:
   <IRQ>
   dump_stack_lvl+0x33/0x50
   print_address_description.constprop.0+0x27/0x310
   print_report+0x3e/0x70
   kasan_report+0xae/0xe0
   svc_tcp_listen_data_ready+0x1cf/0x1f0 [sunrpc]
   tcp_data_queue+0x9f4/0x20e0
   tcp_rcv_established+0x666/0x1f60
   tcp_v4_do_rcv+0x51c/0x850
   tcp_v4_rcv+0x23fc/0x2e80
   ip_protocol_deliver_rcu+0x62/0x300
   ip_local_deliver_finish+0x267/0x350
   ip_local_deliver+0x18b/0x2d0
   ip_rcv+0x2fb/0x370
   __netif_receive_skb_one_core+0x166/0x1b0
   process_backlog+0x24c/0x5e0
   __napi_poll+0xa2/0x500
   net_rx_action+0x854/0xc90
   __do_softirq+0x1bb/0x5de
   do_softirq+0xcb/0x100
   </IRQ>
   <TASK>
   ...
   </TASK>

  Allocated by task 102371:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   __kasan_kmalloc+0x7b/0x90
   svc_setup_socket+0x52/0x4f0 [sunrpc]
   svc_addsock+0x20d/0x400 [sunrpc]
   __write_ports_addfd+0x209/0x390 [nfsd]
   write_ports+0x239/0x2c0 [nfsd]
   nfsctl_transaction_write+0xac/0x110 [nfsd]
   vfs_write+0x1c3/0xae0
   ksys_write+0xed/0x1c0
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

  Freed by task 102551:
   kasan_save_stack+0x1e/0x40
   kasan_set_track+0x21/0x30
   kasan_save_free_info+0x2a/0x50
   __kasan_slab_free+0x106/0x190
   __kmem_cache_free+0x133/0x270
   svc_xprt_free+0x1e2/0x350 [sunrpc]
   svc_xprt_destroy_all+0x25a/0x440 [sunrpc]
   nfsd_put+0x125/0x240 [nfsd]
   nfsd_svc+0x2cb/0x3c0 [nfsd]
   write_threads+0x1ac/0x2a0 [nfsd]
   nfsctl_transaction_write+0xac/0x110 [nfsd]
   vfs_write+0x1c3/0xae0
   ksys_write+0xed/0x1c0
   do_syscall_64+0x38/0x90
   entry_SYSCALL_64_after_hwframe+0x72/0xdc

Fix the UAF by simply doing nothing in svc_tcp_listen_data_ready()
if state != TCP_LISTEN, that will avoid dereferencing svsk for all
child socket.

Link: https://lore.kernel.org/lkml/20230507091131.23540-1-dinghui@sangfor.com.cn/
Fixes: fa9251afc33c ("SUNRPC: Call the default socket callbacks instead of open coding")
Signed-off-by: Ding Hui <dinghui@sangfor.com.cn>
Cc: <stable@vger.kernel.org>
Signed-off-by: Chuck Lever <chuck.lever@oracle.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/sunrpc/svcsock.c |   27 +++++++++++++--------------
 1 file changed, 13 insertions(+), 14 deletions(-)

--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -757,12 +757,6 @@ static void svc_tcp_listen_data_ready(st
 	dprintk("svc: socket %p TCP (listen) state change %d\n",
 		sk, sk->sk_state);
 
-	if (svsk) {
-		/* Refer to svc_setup_socket() for details. */
-		rmb();
-		svsk->sk_odata(sk);
-	}
-
 	/*
 	 * This callback may called twice when a new connection
 	 * is established as a child socket inherits everything
@@ -771,15 +765,20 @@ static void svc_tcp_listen_data_ready(st
 	 *    when one of child sockets become ESTABLISHED.
 	 * 2) data_ready method of the child socket may be called
 	 *    when it receives data before the socket is accepted.
-	 * In case of 2, we should ignore it silently.
+	 * In case of 2, we should ignore it silently and DO NOT
+	 * dereference svsk.
 	 */
-	if (sk->sk_state == TCP_LISTEN) {
-		if (svsk) {
-			set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
-			svc_xprt_enqueue(&svsk->sk_xprt);
-		} else
-			printk("svc: socket %p: no user data\n", sk);
-	}
+	if (sk->sk_state != TCP_LISTEN)
+		return;
+
+	if (svsk) {
+		/* Refer to svc_setup_socket() for details. */
+		rmb();
+		svsk->sk_odata(sk);
+		set_bit(XPT_CONN, &svsk->sk_xprt.xpt_flags);
+		svc_xprt_enqueue(&svsk->sk_xprt);
+	} else
+		printk("svc: socket %p: no user data\n", sk);
 }
 
 /*


