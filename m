Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEEBE1AB6C9;
	Tue,  3 Dec 2024 16:20:16 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1733242816; cv=none; b=TSEO8xYpphUuZC9Ymy0c3v3bBrMnYDoHiD57bC2jT/0zLabiAgdMX79h9gXTCN46j06LtpfHtvgmhn/+Nv9+BufiYU8WIxBSB+/CbXQOq2FnpWumWXbetxVgAyfxR/N5vhYENhsI4brPZec/lGvg8RZWxPoYqgID5YbjBNNohWE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1733242816; c=relaxed/simple;
	bh=TE3mBYh88cF7OWlo+275da6LJmuz0G/pYC/ByLmvSBE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=GZbV699UmapcPkVHHhSIMnfK6gcdhfVKzhvHbxWmg1XXt0Ayu8wRjEP2O/48Wt2lPo+vEznhbi01Dn5JpU0lBsDfCokZe+rlbcOZCEfLt7o5pEcH1Aeo0+h5pYu42/dx7qfvRNRxzrdpTDIXyerIX0iTduFdwvZQpdVpA3jwqr0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Okgcztzw; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Okgcztzw"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3F7B5C4CECF;
	Tue,  3 Dec 2024 16:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1733242816;
	bh=TE3mBYh88cF7OWlo+275da6LJmuz0G/pYC/ByLmvSBE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=Okgcztzwh/TwbO2T0fzDgmODg1jLxlNn+c4BbEXSeaA01EKIu+q0/Vrsk069HV3CD
	 lMGdyWb2mKCt0NdI9zKLQ5J1IRGOgVWr6bouBHZa/D+JZWsrcZ1qfOty7TTxeADVr+
	 KPF3d7JrIwr5Glynwo5OOfGOmI7H3RGM9riItgkU=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Liu Jian <liujian56@huawei.com>,
	Jeff Layton <jlayton@kernel.org>,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Trond Myklebust <trond.myklebust@hammerspace.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 817/826] sunrpc: fix one UAF issue caused by sunrpc kernel tcp socket
Date: Tue,  3 Dec 2024 15:49:04 +0100
Message-ID: <20241203144815.622646274@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241203144743.428732212@linuxfoundation.org>
References: <20241203144743.428732212@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Liu Jian <liujian56@huawei.com>

[ Upstream commit 3f23f96528e8fcf8619895c4c916c52653892ec1 ]

BUG: KASAN: slab-use-after-free in tcp_write_timer_handler+0x156/0x3e0
Read of size 1 at addr ffff888111f322cd by task swapper/0/0

CPU: 0 UID: 0 PID: 0 Comm: swapper/0 Not tainted 6.12.0-rc4-dirty #7
Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS 1.15.0-1
Call Trace:
 <IRQ>
 dump_stack_lvl+0x68/0xa0
 print_address_description.constprop.0+0x2c/0x3d0
 print_report+0xb4/0x270
 kasan_report+0xbd/0xf0
 tcp_write_timer_handler+0x156/0x3e0
 tcp_write_timer+0x66/0x170
 call_timer_fn+0xfb/0x1d0
 __run_timers+0x3f8/0x480
 run_timer_softirq+0x9b/0x100
 handle_softirqs+0x153/0x390
 __irq_exit_rcu+0x103/0x120
 irq_exit_rcu+0xe/0x20
 sysvec_apic_timer_interrupt+0x76/0x90
 </IRQ>
 <TASK>
 asm_sysvec_apic_timer_interrupt+0x1a/0x20
RIP: 0010:default_idle+0xf/0x20
Code: 4c 01 c7 4c 29 c2 e9 72 ff ff ff 90 90 90 90 90 90 90 90 90 90 90 90
 90 90 90 90 f3 0f 1e fa 66 90 0f 00 2d 33 f8 25 00 fb f4 <fa> c3 cc cc cc
 cc 66 66 2e 0f 1f 84 00 00 00 00 00 90 90 90 90 90
RSP: 0018:ffffffffa2007e28 EFLAGS: 00000242
RAX: 00000000000f3b31 RBX: 1ffffffff4400fc7 RCX: ffffffffa09c3196
RDX: 0000000000000000 RSI: 0000000000000000 RDI: ffffffff9f00590f
RBP: 0000000000000000 R08: 0000000000000001 R09: ffffed102360835d
R10: ffff88811b041aeb R11: 0000000000000001 R12: 0000000000000000
R13: ffffffffa202d7c0 R14: 0000000000000000 R15: 00000000000147d0
 default_idle_call+0x6b/0xa0
 cpuidle_idle_call+0x1af/0x1f0
 do_idle+0xbc/0x130
 cpu_startup_entry+0x33/0x40
 rest_init+0x11f/0x210
 start_kernel+0x39a/0x420
 x86_64_start_reservations+0x18/0x30
 x86_64_start_kernel+0x97/0xa0
 common_startup_64+0x13e/0x141
 </TASK>

Allocated by task 595:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 __kasan_slab_alloc+0x87/0x90
 kmem_cache_alloc_noprof+0x12b/0x3f0
 copy_net_ns+0x94/0x380
 create_new_namespaces+0x24c/0x500
 unshare_nsproxy_namespaces+0x75/0xf0
 ksys_unshare+0x24e/0x4f0
 __x64_sys_unshare+0x1f/0x30
 do_syscall_64+0x70/0x180
 entry_SYSCALL_64_after_hwframe+0x76/0x7e

Freed by task 100:
 kasan_save_stack+0x24/0x50
 kasan_save_track+0x14/0x30
 kasan_save_free_info+0x3b/0x60
 __kasan_slab_free+0x54/0x70
 kmem_cache_free+0x156/0x5d0
 cleanup_net+0x5d3/0x670
 process_one_work+0x776/0xa90
 worker_thread+0x2e2/0x560
 kthread+0x1a8/0x1f0
 ret_from_fork+0x34/0x60
 ret_from_fork_asm+0x1a/0x30

Reproduction script:

mkdir -p /mnt/nfsshare
mkdir -p /mnt/nfs/netns_1
mkfs.ext4 /dev/sdb
mount /dev/sdb /mnt/nfsshare
systemctl restart nfs-server
chmod 777 /mnt/nfsshare
exportfs -i -o rw,no_root_squash *:/mnt/nfsshare

ip netns add netns_1
ip link add name veth_1_peer type veth peer veth_1
ifconfig veth_1_peer 11.11.0.254 up
ip link set veth_1 netns netns_1
ip netns exec netns_1 ifconfig veth_1 11.11.0.1

ip netns exec netns_1 /root/iptables -A OUTPUT -d 11.11.0.254 -p tcp \
	--tcp-flags FIN FIN  -j DROP

(note: In my environment, a DESTROY_CLIENTID operation is always sent
 immediately, breaking the nfs tcp connection.)
ip netns exec netns_1 timeout -s 9 300 mount -t nfs -o proto=tcp,vers=4.1 \
	11.11.0.254:/mnt/nfsshare /mnt/nfs/netns_1

ip netns del netns_1

The reason here is that the tcp socket in netns_1 (nfs side) has been
shutdown and closed (done in xs_destroy), but the FIN message (with ack)
is discarded, and the nfsd side keeps sending retransmission messages.
As a result, when the tcp sock in netns_1 processes the received message,
it sends the message (FIN message) in the sending queue, and the tcp timer
is re-established. When the network namespace is deleted, the net structure
accessed by tcp's timer handler function causes problems.

To fix this problem, let's hold netns refcnt for the tcp kernel socket as
done in other modules. This is an ugly hack which can easily be backported
to earlier kernels. A proper fix which cleans up the interfaces will
follow, but may not be so easy to backport.

Fixes: 26abe14379f8 ("net: Modify sk_alloc to not reference count the netns of kernel sockets.")
Signed-off-by: Liu Jian <liujian56@huawei.com>
Acked-by: Jeff Layton <jlayton@kernel.org>
Reviewed-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Signed-off-by: Trond Myklebust <trond.myklebust@hammerspace.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/sunrpc/svcsock.c  | 4 ++++
 net/sunrpc/xprtsock.c | 7 +++++++
 2 files changed, 11 insertions(+)

diff --git a/net/sunrpc/svcsock.c b/net/sunrpc/svcsock.c
index 825ec53576912..59e2c46240f5c 100644
--- a/net/sunrpc/svcsock.c
+++ b/net/sunrpc/svcsock.c
@@ -1551,6 +1551,10 @@ static struct svc_xprt *svc_create_socket(struct svc_serv *serv,
 	newlen = error;
 
 	if (protocol == IPPROTO_TCP) {
+		__netns_tracker_free(net, &sock->sk->ns_tracker, false);
+		sock->sk->sk_net_refcnt = 1;
+		get_net_track(net, &sock->sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(net, 1);
 		if ((error = kernel_listen(sock, 64)) < 0)
 			goto bummer;
 	}
diff --git a/net/sunrpc/xprtsock.c b/net/sunrpc/xprtsock.c
index 43fb96de8ebe5..b69e6290acfab 100644
--- a/net/sunrpc/xprtsock.c
+++ b/net/sunrpc/xprtsock.c
@@ -1940,6 +1940,13 @@ static struct socket *xs_create_sock(struct rpc_xprt *xprt,
 		goto out;
 	}
 
+	if (protocol == IPPROTO_TCP) {
+		__netns_tracker_free(xprt->xprt_net, &sock->sk->ns_tracker, false);
+		sock->sk->sk_net_refcnt = 1;
+		get_net_track(xprt->xprt_net, &sock->sk->ns_tracker, GFP_KERNEL);
+		sock_inuse_add(xprt->xprt_net, 1);
+	}
+
 	filp = sock_alloc_file(sock, O_NONBLOCK, NULL);
 	if (IS_ERR(filp))
 		return ERR_CAST(filp);
-- 
2.43.0



