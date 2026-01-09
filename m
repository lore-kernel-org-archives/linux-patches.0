Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5394535B12B;
	Fri,  9 Jan 2026 12:36:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1767962197; cv=none; b=ulh5HiuY29nx+nHMRcjbUIVv96qFCZ1A3kERApFDAGnFKsmWL3aXdPLD8XFKfNx+VZAmmbbeZkKT1jkFT6v6VnUEoAy09wy3PW/4+ltGwWPUAU3+uYXvSgTIjS5T1QkUNBlz0avDkyCa1WAePljfvJZY6xWzdXVz9U1u0PjpZYw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1767962197; c=relaxed/simple;
	bh=QQqyLg7FSNLQRAHw1UHw0NbeHtsqcta4ds9wwwLpnUA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MAGtbKYezxbar0wpaUuBzhLMch6h1Q+gq26uYc2xCSN7VnutsRndF8LKabmGK3hBI1RC5joNOnRf1m+aiBapEyzZmwwwnJQQ18JMDESARQN+Dvjq2rQ5J6f/rdvTn3O7jvbK69qgANTD4uy1ioABDG35SO0MDgfFEQvrXo/elJw=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=jheh2h6y; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="jheh2h6y"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D556CC4CEF1;
	Fri,  9 Jan 2026 12:36:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1767962197;
	bh=QQqyLg7FSNLQRAHw1UHw0NbeHtsqcta4ds9wwwLpnUA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=jheh2h6yhAJRn8lCPLX8SGJb0N8gQ2nmC9cTT8yOP4MfXz4DvEDd7zcGAURq69WHw
	 NKGsweyTFLBCUTyi/R8/abTDhK5I91gyWRZ5gtYH28a4Gbw4MmmhrGbLsonj91QCln
	 HvSpDIxwrHlF4pXaigy1YtV/sQ3K6dsjB/CgKmc8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+d7abc36bbbb6d7d40b58@syzkaller.appspotmail.com,
	Wang Liang <wangliang74@huawei.com>,
	Paolo Abeni <pabeni@redhat.com>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 248/634] netrom: Fix memory leak in nr_sendmsg()
Date: Fri,  9 Jan 2026 12:38:46 +0100
Message-ID: <20260109112126.872254380@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260109112117.407257400@linuxfoundation.org>
References: <20260109112117.407257400@linuxfoundation.org>
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

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Wang Liang <wangliang74@huawei.com>

[ Upstream commit 613d12dd794e078be8ff3cf6b62a6b9acf7f4619 ]

syzbot reported a memory leak [1].

When function sock_alloc_send_skb() return NULL in nr_output(), the
original skb is not freed, which was allocated in nr_sendmsg(). Fix this
by freeing it before return.

[1]
BUG: memory leak
unreferenced object 0xffff888129f35500 (size 240):
  comm "syz.0.17", pid 6119, jiffies 4294944652
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    00 00 00 00 00 00 00 00 00 10 52 28 81 88 ff ff  ..........R(....
  backtrace (crc 1456a3e4):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4983 [inline]
    slab_alloc_node mm/slub.c:5288 [inline]
    kmem_cache_alloc_node_noprof+0x36f/0x5e0 mm/slub.c:5340
    __alloc_skb+0x203/0x240 net/core/skbuff.c:660
    alloc_skb include/linux/skbuff.h:1383 [inline]
    alloc_skb_with_frags+0x69/0x3f0 net/core/skbuff.c:6671
    sock_alloc_send_pskb+0x379/0x3e0 net/core/sock.c:2965
    sock_alloc_send_skb include/net/sock.h:1859 [inline]
    nr_sendmsg+0x287/0x450 net/netrom/af_netrom.c:1105
    sock_sendmsg_nosec net/socket.c:727 [inline]
    __sock_sendmsg net/socket.c:742 [inline]
    sock_write_iter+0x293/0x2a0 net/socket.c:1195
    new_sync_write fs/read_write.c:593 [inline]
    vfs_write+0x45d/0x710 fs/read_write.c:686
    ksys_write+0x143/0x170 fs/read_write.c:738
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Reported-by: syzbot+d7abc36bbbb6d7d40b58@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=d7abc36bbbb6d7d40b58
Tested-by: syzbot+d7abc36bbbb6d7d40b58@syzkaller.appspotmail.com
Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
Signed-off-by: Wang Liang <wangliang74@huawei.com>
Link: https://patch.msgid.link/20251129041315.1550766-1-wangliang74@huawei.com
Signed-off-by: Paolo Abeni <pabeni@redhat.com>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/netrom/nr_out.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/netrom/nr_out.c b/net/netrom/nr_out.c
index 5e531394a724b..2b3cbceb0b52d 100644
--- a/net/netrom/nr_out.c
+++ b/net/netrom/nr_out.c
@@ -43,8 +43,10 @@ void nr_output(struct sock *sk, struct sk_buff *skb)
 		frontlen = skb_headroom(skb);
 
 		while (skb->len > 0) {
-			if ((skbn = sock_alloc_send_skb(sk, frontlen + NR_MAX_PACKET_SIZE, 0, &err)) == NULL)
+			if ((skbn = sock_alloc_send_skb(sk, frontlen + NR_MAX_PACKET_SIZE, 0, &err)) == NULL) {
+				kfree_skb(skb);
 				return;
+			}
 
 			skb_reserve(skbn, frontlen);
 
-- 
2.51.0



