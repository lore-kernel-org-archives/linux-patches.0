Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795059902;
	b=UZpiTQ0Y/g2ublzRSW1x0xpKwB9QOCP/KUkJ11XM1tnVkoRzMos9fC5aKfT/gfJPkG/i
	 V1aBc9siv1SbZQx4bXn+z6EUa2KBkNCFETuhzmWh61aY8Z8wbc1/+gK0ji8EzSCpJBsM5
	 uE/DbqDhE4WGegMDXhrXYtgjyAiIigJxzTStblGcKm14NGEF/+bytV3dldatxxYKiL+DI
	 V1mQ3+qivDxD7w5LaU6q+kOH2G5LIDttLWhrxwQZbP4tABRYWApP3dO9500weLHIkQXBn
	 329KZsw9u2mCPWhVx/Ud4rfl9aSsAKaG7kfkL/x/2Iyp5P1JxUtM4KjL94cZDHds2jw==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795059902;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=X0AjfCHBOZb7t2wBVUTscpkq1gOJlK39oIWWwI2s7DI=;
	b=Ia/SbP/5n+z/23dxS+gnxKngfg9EPaOaIZwq4Wb36i9wZ4ZgKQbNHDKpsqB+W9eukufx
	 ViaH4VoeRR3Ml8CCHT7mQKUs+3AnwaDlDl6/ojaWqVnFtCfzNVIZjE7+d156C7EbQsOop
	 keJ2feuwUx9bicTxKkYmnWBQyG0NlzNYO2cqLDukeThpPmEx3mCg6vdkwSavCxiPcHX4W
	 BV8L1YwYJAmG5tT7h0d5RIpcUF7/BUo3Z+U+bzPawC+6t4j+AAkgkgFnxXwSarove9OU6
	 c9Sv5rC4wEB2q0RPjPfkfkuPLm5jNZD1aFZuUzwRGOUjFrXCz3nxzryiujesak3LMPA==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rtLGTb6;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6B27E606A32C;
	Thu, 19 Nov 2026 03:45:02 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=1rtLGTb6
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AAA761F000C4;
	Thu, 19 Nov 2026 03:45:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795059902;
	bh=X0AjfCHBOZb7t2wBVUTscpkq1gOJlK39oIWWwI2s7DI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=1rtLGTb6yX3Uaw0Wji/NREPm6O3uTPtFrpMxLPSkvHNq2twkGM9Oglf3niNI9BAMD
	 fVcNtzEeGAmeDKwPPRuPxcXv1savRXwMYCOhpz3d7s0lYTVlBgbr06nA78L/ymFlB9
	 ObBJhMCt5nLIJQBVkzyj9jQpdgLvZEzeydwCXuGY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhengchao Shao <shaozhengchao@huawei.com>,
	Eric Dumazet <edumazet@google.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.10 1006/1848] ip6mr: fix UAF issue in ip6mr_sk_done() when addrconf_init_net() failed
Date: Wed, 18 Nov 2026 15:50:44 +0100
Message-ID: <20261118145958.889931099@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118145911.150052362@linuxfoundation.org>
References: <20261118145911.150052362@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

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
index ab65da6e63175..9f3ae5be7cdd4 100644
--- a/net/ipv6/addrconf.c
+++ b/net/ipv6/addrconf.c
@@ -7183,9 +7183,11 @@ static int __net_init addrconf_init_net(struct net *net)
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



