Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 663C8426690;
	Wed,  4 Feb 2026 15:24:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770218653; cv=none; b=n83KvW/RuscNA+pdsAOdfhU7e44q3oQA2L84c87wcOmumLyemoWM4AOAa2/HVP+j1vXMWUK79T6kw3yVMhn1qTpuNnKhH/+FELakPKS6h0j+Vyr0wXfTsV5bGWZMx6h/YEGkLe7JKUhIPXJkF4ztaPEQpcdEnqc25E43SDML0yI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770218653; c=relaxed/simple;
	bh=Pq6qfZzUOWf71AxMshSQo9EO5BPaZFFHmy3XBDT0+lc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=JmR9r8lHc7oltovwQG3Y7FEYxC7rSO637vmSnFbHW0iWD6eLryB2y614UH22HeNW+BAeTAyv6JNv9j0TzIACExpkRAJ+YfUfKL9TSJQ5rWAvtOjVV4AUmAlAsI7IS99b9+IK6be0S1VxwqPLJfnrehsLnv6CSqcRisgP1uqBc0w=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VFxSYRpq; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VFxSYRpq"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E48DBC4CEF7;
	Wed,  4 Feb 2026 15:24:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770218653;
	bh=Pq6qfZzUOWf71AxMshSQo9EO5BPaZFFHmy3XBDT0+lc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VFxSYRpq3zVSnwzH1AEQa9+w8bi5UkQbgmQ+M4jssYlHiCElZbW4dD+xt3fSe7mzL
	 I6HVgNnMAIwigYR0KXTHB39jIkWHQK+xywIntYr6Fcb1hDXPMqmMRRmZweEF9q5trD
	 EGAY6TA38eBi46IOKNEC+aUofRSUQJQ6Ewlwtm0U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+f2d245f1d76bbfa50e4c@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Simon Horman <horms@kernel.org>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 13/87] nfc: llcp: Fix memleak in nfc_llcp_send_ui_frame().
Date: Wed,  4 Feb 2026 15:40:11 +0100
Message-ID: <20260204143847.390693230@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143846.906385641@linuxfoundation.org>
References: <20260204143846.906385641@linuxfoundation.org>
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

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 165c34fb6068ff153e3fc99a932a80a9d5755709 ]

syzbot reported various memory leaks related to NFC, struct
nfc_llcp_sock, sk_buff, nfc_dev, etc. [0]

The leading log hinted that nfc_llcp_send_ui_frame() failed
to allocate skb due to sock_error(sk) being -ENXIO.

ENXIO is set by nfc_llcp_socket_release() when struct
nfc_llcp_local is destroyed by local_cleanup().

The problem is that there is no synchronisation between
nfc_llcp_send_ui_frame() and local_cleanup(), and skb
could be put into local->tx_queue after it was purged in
local_cleanup():

  CPU1                          CPU2
  ----                          ----
  nfc_llcp_send_ui_frame()      local_cleanup()
  |- do {                       '
     |- pdu = nfc_alloc_send_skb(..., &err)
     |                          .
     |                          |- nfc_llcp_socket_release(local, false, ENXIO);
     |                          |- skb_queue_purge(&local->tx_queue);      |
     |                          '                                          |
     |- skb_queue_tail(&local->tx_queue, pdu);                             |
    ...                                                                    |
     |- pdu = nfc_alloc_send_skb(..., &err)                                |
                                       ^._________________________________.'

local_cleanup() is called for struct nfc_llcp_local only
after nfc_llcp_remove_local() unlinks it from llcp_devices.

If we hold local->tx_queue.lock then, we can synchronise
the thread and nfc_llcp_send_ui_frame().

Let's do that and check list_empty(&local->list) before
queuing skb to local->tx_queue in nfc_llcp_send_ui_frame().

[0]:
[   56.074943][ T6096] llcp: nfc_llcp_send_ui_frame: Could not allocate PDU (error=-6)
[   64.318868][ T5813] kmemleak: 6 new suspected memory leaks (see /sys/kernel/debug/kmemleak)
BUG: memory leak
unreferenced object 0xffff8881272f6800 (size 1024):
  comm "syz.0.17", pid 6096, jiffies 4294942766
  hex dump (first 32 bytes):
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
    27 00 03 40 00 00 00 00 00 00 00 00 00 00 00 00  '..@............
  backtrace (crc da58d84d):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    __do_kmalloc_node mm/slub.c:5645 [inline]
    __kmalloc_noprof+0x3e3/0x6b0 mm/slub.c:5658
    kmalloc_noprof include/linux/slab.h:961 [inline]
    sk_prot_alloc+0x11a/0x1b0 net/core/sock.c:2239
    sk_alloc+0x36/0x360 net/core/sock.c:2295
    nfc_llcp_sock_alloc+0x37/0x130 net/nfc/llcp_sock.c:979
    llcp_sock_create+0x71/0xd0 net/nfc/llcp_sock.c:1044
    nfc_sock_create+0xc9/0xf0 net/nfc/af_nfc.c:31
    __sock_create+0x1a9/0x340 net/socket.c:1605
    sock_create net/socket.c:1663 [inline]
    __sys_socket_create net/socket.c:1700 [inline]
    __sys_socket+0xb9/0x1a0 net/socket.c:1747
    __do_sys_socket net/socket.c:1761 [inline]
    __se_sys_socket net/socket.c:1759 [inline]
    __x64_sys_socket+0x1b/0x30 net/socket.c:1759
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

BUG: memory leak
unreferenced object 0xffff88810fbd9800 (size 240):
  comm "syz.0.17", pid 6096, jiffies 4294942850
  hex dump (first 32 bytes):
    68 f0 ff 08 81 88 ff ff 68 f0 ff 08 81 88 ff ff  h.......h.......
    00 00 00 00 00 00 00 00 00 68 2f 27 81 88 ff ff  .........h/'....
  backtrace (crc 6cc652b1):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4979 [inline]
    slab_alloc_node mm/slub.c:5284 [inline]
    kmem_cache_alloc_node_noprof+0x36f/0x5e0 mm/slub.c:5336
    __alloc_skb+0x203/0x240 net/core/skbuff.c:660
    alloc_skb include/linux/skbuff.h:1383 [inline]
    alloc_skb_with_frags+0x69/0x3f0 net/core/skbuff.c:6671
    sock_alloc_send_pskb+0x379/0x3e0 net/core/sock.c:2965
    sock_alloc_send_skb include/net/sock.h:1859 [inline]
    nfc_alloc_send_skb+0x45/0x80 net/nfc/core.c:724
    nfc_llcp_send_ui_frame+0x162/0x360 net/nfc/llcp_commands.c:766
    llcp_sock_sendmsg+0x14c/0x1d0 net/nfc/llcp_sock.c:814
    sock_sendmsg_nosec net/socket.c:727 [inline]
    __sock_sendmsg net/socket.c:742 [inline]
    __sys_sendto+0x2d8/0x2f0 net/socket.c:2244
    __do_sys_sendto net/socket.c:2251 [inline]
    __se_sys_sendto net/socket.c:2247 [inline]
    __x64_sys_sendto+0x28/0x30 net/socket.c:2247
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xfa0 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 94f418a20664 ("NFC: UI frame sending routine implementation")
Reported-by: syzbot+f2d245f1d76bbfa50e4c@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/697569c7.a00a0220.33ccc7.0014.GAE@google.com/T/#u
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Simon Horman <horms@kernel.org>
Link: https://patch.msgid.link/20260125010214.1572439-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/llcp_commands.c | 17 ++++++++++++++++-
 net/nfc/llcp_core.c     |  4 +++-
 2 files changed, 19 insertions(+), 2 deletions(-)

diff --git a/net/nfc/llcp_commands.c b/net/nfc/llcp_commands.c
index e2680a3bef799..b652323bc2c12 100644
--- a/net/nfc/llcp_commands.c
+++ b/net/nfc/llcp_commands.c
@@ -778,8 +778,23 @@ int nfc_llcp_send_ui_frame(struct nfc_llcp_sock *sock, u8 ssap, u8 dsap,
 		if (likely(frag_len > 0))
 			skb_put_data(pdu, msg_ptr, frag_len);
 
+		spin_lock(&local->tx_queue.lock);
+
+		if (list_empty(&local->list)) {
+			spin_unlock(&local->tx_queue.lock);
+
+			kfree_skb(pdu);
+
+			len -= remaining_len;
+			if (len == 0)
+				len = -ENXIO;
+			break;
+		}
+
 		/* No need to check for the peer RW for UI frames */
-		skb_queue_tail(&local->tx_queue, pdu);
+		__skb_queue_tail(&local->tx_queue, pdu);
+
+		spin_unlock(&local->tx_queue.lock);
 
 		remaining_len -= frag_len;
 		msg_ptr += frag_len;
diff --git a/net/nfc/llcp_core.c b/net/nfc/llcp_core.c
index 18be13fb9b75a..ced99d2a90cc1 100644
--- a/net/nfc/llcp_core.c
+++ b/net/nfc/llcp_core.c
@@ -314,7 +314,9 @@ static struct nfc_llcp_local *nfc_llcp_remove_local(struct nfc_dev *dev)
 	spin_lock(&llcp_devices_lock);
 	list_for_each_entry_safe(local, tmp, &llcp_devices, list)
 		if (local->dev == dev) {
-			list_del(&local->list);
+			spin_lock(&local->tx_queue.lock);
+			list_del_init(&local->list);
+			spin_unlock(&local->tx_queue.lock);
 			spin_unlock(&llcp_devices_lock);
 			return local;
 		}
-- 
2.51.0



