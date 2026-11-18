Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795054374;
	b=e0lW51Ycxb+rnEBM11+/7omxqx4pYHuIJBd1S8HUqZQIur/LGquTdk8sgIu47nk/h8Sv
	 wPlujt184oSjMp1TTV4ewo9K6JsqwYqyLj2BJQq3AhtKbNSSC6/9qsKqG0GB/shFW7zAb
	 YE8Sp7iFKqT00DL7BspCDlbiiAfxzKNYJfgiw5Err5zlOMoviDGA5JikUvsCzxd0xM/sp
	 2/26d+4V1ahxbBd7kcw62z/EUSeT85DPiMKRaNJE98GA09uEFGuo4vp1tN5sgv6vdiKgd
	 FP7oD7gl48mpKWrx3bcgZvFmXabFg2t+uOaYQkrw0+YOepJUJswdReHi2gmSXuzdEjw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795054374;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=YmYmNguBwtN7JJBNdRLG8FDwsVzaW5G03AbO0Nx9nXY=;
	b=Z9pYWH0Y5w3mUFS1Un8Umu4X08FDtzh2LmdVgHXV3SglIO3hKPCKCIHAjWU+BU6dCHvp
	 cuk4O0/oQhb5O6sH3GPfeylEFaX5w7Q5rVpJ2cRoQf+iM4BsmNs2TJDSReNhHTmB9dYNY
	 L9PYt57Sv7Fu0faFysZH0kkY+QIhoHkLdaQKNGhCZN8Z9jPGhqtu1I1KBeurcyAKHGe5U
	 UsQDNMhtyI4YwxSboT49dd+IZaQNFkMuMuvxtKL4xseZDM/eBSpOYBmr2iU9JqmS373vH
	 gdFIMccxE0Hwkv7ROyBRtR3nD+J0ji8YE1QArlXT7BIZ5bvAs1S1BzaRuvzg+9w/nWA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vr07weeC;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2A4CC606A325;
	Thu, 19 Nov 2026 02:12:53 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=Vr07weeC
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D1DC1F000C5;
	Thu, 19 Nov 2026 02:12:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795054373;
	bh=YmYmNguBwtN7JJBNdRLG8FDwsVzaW5G03AbO0Nx9nXY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Vr07weeCk38rf3ZWPX8wRfW91RGNVXXLUEPFOiSh/nehlBDux8j9KqtYd+z5rbZ++
	 4Snmd0flaPG3IrV+fNaSlMnSzJyphVuuXh3i514AbBlOjPVgDHyzCcdh53+eL4lgBB
	 goUQeAVJAcOf3tUuEir93utFVSzJPRzTLfc5Jdr0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 1200/2214] ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
Date: Wed, 18 Nov 2026 15:47:56 +0100
Message-ID: <20261118150059.873087507@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150009.797899913@linuxfoundation.org>
References: <20261118150009.797899913@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhengchao Shao <shaozhengchao@huawei.com>

[ Upstream commit 1ca695207ed2271ecbf8ee6c641970f621c157cc ]

If the initialization fails in calling addrconf_init_net(), devconf_all is
the pointer that has been released. Then ip6mr_sk_done() is called to
release the net, accessing devconf->mc_forwarding directly causes invalid
pointer access.

The process is as follows:
setup_net()
	ops_init()
		addrconf_init_net()
		all = kmemdup(...)           ---> alloc "all"
		...
		net->ipv6.devconf_all = all;
		__addrconf_sysctl_register() ---> failed
		...
		kfree(all);                  ---> ipv6.devconf_all invalid
		...
	ops_exit_list()
		...
		ip6mr_sk_done()
			devconf = net->ipv6.devconf_all;
			//devconf is invalid pointer
			if (!devconf || !atomic_read(&devconf->mc_forwarding))

The following is the Call Trace information:
BUG: KASAN: use-after-free in ip6mr_sk_done+0x112/0x3a0
Read of size 4 at addr ffff888075508e88 by task ip/14554
Call Trace:
<TASK>
dump_stack_lvl+0x8e/0xd1
print_report+0x155/0x454
kasan_report+0xba/0x1f0
kasan_check_range+0x35/0x1b0
ip6mr_sk_done+0x112/0x3a0
rawv6_close+0x48/0x70
inet_release+0x109/0x230
inet6_release+0x4c/0x70
sock_release+0x87/0x1b0
igmp6_net_exit+0x6b/0x170
ops_exit_list+0xb0/0x170
setup_net+0x7ac/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0
RIP: 0033:0x7f7963322547

</TASK>
Allocated by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
__kasan_kmalloc+0xa1/0xb0
__kmalloc_node_track_caller+0x4a/0xb0
kmemdup+0x28/0x60
addrconf_init_net+0x1be/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Freed by task 14554:
kasan_save_stack+0x1e/0x40
kasan_set_track+0x21/0x30
kasan_save_free_info+0x2a/0x40
____kasan_slab_free+0x155/0x1b0
slab_free_freelist_hook+0x11b/0x220
__kmem_cache_free+0xa4/0x360
addrconf_init_net+0x623/0x840
ops_init+0xa5/0x410
setup_net+0x5aa/0xbd0
copy_net_ns+0x2e6/0x6b0
create_new_namespaces+0x382/0xa50
unshare_nsproxy_namespaces+0xa6/0x1c0
ksys_unshare+0x3a4/0x7e0
__x64_sys_unshare+0x2d/0x40
do_syscall_64+0x35/0x80
entry_SYSCALL_64_after_hwframe+0x46/0xb0

Fixes: 7d9b1b578d67 ("ip6mr: fix use-after-free in ip6mr_sk_done()")
Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20221017080331.16878-1-shaozhengchao@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/ipv6/addrconf.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/ipv6/addrconf.c b/net/ipv6/addrconf.c
index aa033c2cd8a0d..e429bcadd821e 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7273,9 +7273,11 @@ static int __net_init addrconf_init_net(struct net *net)
 	__addrconf_sysctl_unregister(net, all, NETCONFA_IFINDEX_ALL);
 err_reg_all:
 	kfree(dflt);
+	net->ipv6.devconf_dflt = NULL;
 #endif
 err_alloc_dflt:
 	kfree(all);
+	net->ipv6.devconf_all = NULL;
 err_alloc_all:
 	kfree(net->ipv6.inet6_addr_lst);
 err_alloc_addr:
-- 
2.53.0



