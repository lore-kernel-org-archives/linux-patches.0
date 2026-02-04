Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 58FB642189C;
	Wed,  4 Feb 2026 14:55:40 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1770216940; cv=none; b=pOLhe6y9msxsnCIPzvT1ywVaOheH4A1dp6Q+QOYqCAQlc/k+2TMC0ntYN/aZhYgcwlP2CDf2bgQYvTYqQMuQRM/zWVRzEMFF5Rkf/U35PoWbRNRlhvOHRIvg1I1wQFNRZTcLIZDK98OkhtBGKQ7rcLEU2jKAGvEDIJxrHLB3YyE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1770216940; c=relaxed/simple;
	bh=cRv8pEVn8i80DbOxNWdD/3J2bLohkPdfCeENlXu2YFo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=sqVdQgmXddQgcTM2IXHYEey59GYFSHes8C9Jag+abmUjZU30x8D2hfD9x/7O4WWYYIRCGzqNnvGgl+fFOlKWmSZBI9BllX2lGUG6tpemOPtgXw3P7tcEHX9jx0W1a1WK6X1GpZqPeK9zWqjtnr/NBUi4RT1CJafYacWkWcMvr4E=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=NMMDVDAv; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="NMMDVDAv"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A5F1BC4CEF7;
	Wed,  4 Feb 2026 14:55:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1770216940;
	bh=cRv8pEVn8i80DbOxNWdD/3J2bLohkPdfCeENlXu2YFo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=NMMDVDAvSieM34WCmtuB4BalREfWntR5xwWkFvSnAVnqKBywyGzOAYUa8O+5utcM6
	 PrPzlVa5JTQVgR9rYyWi39LWhojZYMRTAwtwuCA6j4SJYGq2+7LBIo4OqlHI6QxbJu
	 rjLbGXDR0O5vJ9hkS2qsh4koxlMGUAERG4h5sza8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+7312e82745f7fa2526db@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	James Chapman <jchapman@katalix.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 077/206] l2tp: avoid one data-race in l2tp_tunnel_del_work()
Date: Wed,  4 Feb 2026 15:38:28 +0100
Message-ID: <20260204143900.986259490@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260204143858.193781818@linuxfoundation.org>
References: <20260204143858.193781818@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7a29f6bf60f2590fe5e9c4decb451e19afad2bcf ]

We should read sk->sk_socket only when dealing with kernel sockets.

syzbot reported the following data-race:

BUG: KCSAN: data-race in l2tp_tunnel_del_work / sk_common_release

write to 0xffff88811c182b20 of 8 bytes by task 5365 on cpu 0:
  sk_set_socket include/net/sock.h:2092 [inline]
  sock_orphan include/net/sock.h:2118 [inline]
  sk_common_release+0xae/0x230 net/core/sock.c:4003
  udp_lib_close+0x15/0x20 include/net/udp.h:325
  inet_release+0xce/0xf0 net/ipv4/af_inet.c:437
  __sock_release net/socket.c:662 [inline]
  sock_close+0x6b/0x150 net/socket.c:1455
  __fput+0x29b/0x650 fs/file_table.c:468
  ____fput+0x1c/0x30 fs/file_table.c:496
  task_work_run+0x131/0x1a0 kernel/task_work.c:233
  resume_user_mode_work include/linux/resume_user_mode.h:50 [inline]
  __exit_to_user_mode_loop kernel/entry/common.c:44 [inline]
  exit_to_user_mode_loop+0x1fe/0x740 kernel/entry/common.c:75
  __exit_to_user_mode_prepare include/linux/irq-entry-common.h:226 [inline]
  syscall_exit_to_user_mode_prepare include/linux/irq-entry-common.h:256 [inline]
  syscall_exit_to_user_mode_work include/linux/entry-common.h:159 [inline]
  syscall_exit_to_user_mode include/linux/entry-common.h:194 [inline]
  do_syscall_64+0x1e1/0x2b0 arch/x86/entry/syscall_64.c:100
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

read to 0xffff88811c182b20 of 8 bytes by task 827 on cpu 1:
  l2tp_tunnel_del_work+0x2f/0x1a0 net/l2tp/l2tp_core.c:1418
  process_one_work kernel/workqueue.c:3257 [inline]
  process_scheduled_works+0x4ce/0x9d0 kernel/workqueue.c:3340
  worker_thread+0x582/0x770 kernel/workqueue.c:3421
  kthread+0x489/0x510 kernel/kthread.c:463
  ret_from_fork+0x149/0x290 arch/x86/kernel/process.c:158
  ret_from_fork_asm+0x1a/0x30 arch/x86/entry/entry_64.S:246

value changed: 0xffff88811b818000 -> 0x0000000000000000

Fixes: d00fa9adc528 ("l2tp: fix races with tunnel socket close")
Reported-by: syzbot+7312e82745f7fa2526db@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6968b029.050a0220.58bed.0016.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: James Chapman <jchapman@katalix.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20260115092139.3066180-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index acd5b67858ddc..7e242ebac664a 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1252,8 +1252,6 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 {
 	struct l2tp_tunnel *tunnel = container_of(work, struct l2tp_tunnel,
 						  del_work);
-	struct sock *sk = tunnel->sock;
-	struct socket *sock = sk->sk_socket;
 
 	l2tp_tunnel_closeall(tunnel);
 
@@ -1261,6 +1259,8 @@ static void l2tp_tunnel_del_work(struct work_struct *work)
 	 * the sk API to release it here.
 	 */
 	if (tunnel->fd < 0) {
+		struct socket *sock = tunnel->sock->sk_socket;
+
 		if (sock) {
 			kernel_sock_shutdown(sock, SHUT_RDWR);
 			sock_release(sock);
-- 
2.51.0



