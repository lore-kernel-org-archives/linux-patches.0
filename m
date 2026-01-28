Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 226802F745C;
	Wed, 28 Jan 2026 15:53:21 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769615601; cv=none; b=EtoLdFjSneU7vVuaEu0H7wUpIfWu1nxsGY1WLx+R7pHVYHRRgEEv0kFxI9MixBVc2ig5mIgQR2zsrhbpoMy+803Mt4ANjk5q/ffJVil5rfRcqCPCEdwchjarE4k69rgqeKfleE8KxDy5uzAo4dejyr8YM07LpFwnrgUAk2jflqs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769615601; c=relaxed/simple;
	bh=WWTzsgZgygdwWGdl/ku/Ds2QQu4SdZErTnNUmwWOO7w=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=UU49wrmydcaHw9KnmvVEqjoelWp/lz0qLsqSLe0sW2TS8V25L37VEEnAkZkayaFVZFgZtVtq4f0wY3UkBvxeSX6NTIRxwfyha2J+MxSdPRubshdcnoWNhechfUhU/nHdW10LCCmEu+ujmuKnhR8K13ENWlx1SaW+OKiVZwHz4d8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=HtGt+pMB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="HtGt+pMB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 884A9C4CEF1;
	Wed, 28 Jan 2026 15:53:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769615601;
	bh=WWTzsgZgygdwWGdl/ku/Ds2QQu4SdZErTnNUmwWOO7w=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=HtGt+pMBhZYjwbj8vSqmz/ZNG7Xq5WJtY4Kcdsfj5zRrhIO1Kgr0UIcp/wEgy9XdV
	 9Upv0iLFjX/Z2gX7Rv9zS3ERNbjpSfVQUZocMx+7Z55EFaUh6coRtWgGlEUzG2GJqi
	 yxmKKWM8hoL4thxtZPTjsRmqclLx9kLZmrYcExJ4=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2c42ea4485b29beb0643@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@google.com>,
	Guillaume Nault <gnault@redhat.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 030/227] l2tp: Fix memleak in l2tp_udp_encap_recv().
Date: Wed, 28 Jan 2026 16:21:15 +0100
Message-ID: <20260128145345.429256844@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.331957407@linuxfoundation.org>
References: <20260128145344.331957407@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@google.com>

[ Upstream commit 4d10edfd1475b69dbd4c47f34b61a3772ece83ca ]

syzbot reported memleak of struct l2tp_session, l2tp_tunnel,
sock, etc. [0]

The cited commit moved down the validation of the protocol
version in l2tp_udp_encap_recv().

The new place requires an extra error handling to avoid the
memleak.

Let's call l2tp_session_put() there.

[0]:
BUG: memory leak
unreferenced object 0xffff88810a290200 (size 512):
  comm "syz.0.17", pid 6086, jiffies 4294944299
  hex dump (first 32 bytes):
    7d eb 04 0c 00 00 00 00 01 00 00 00 00 00 00 00  }...............
    00 00 00 00 00 00 00 00 00 00 00 00 00 00 00 00  ................
  backtrace (crc babb6a4f):
    kmemleak_alloc_recursive include/linux/kmemleak.h:44 [inline]
    slab_post_alloc_hook mm/slub.c:4958 [inline]
    slab_alloc_node mm/slub.c:5263 [inline]
    __do_kmalloc_node mm/slub.c:5656 [inline]
    __kmalloc_noprof+0x3e0/0x660 mm/slub.c:5669
    kmalloc_noprof include/linux/slab.h:961 [inline]
    kzalloc_noprof include/linux/slab.h:1094 [inline]
    l2tp_session_create+0x3a/0x3b0 net/l2tp/l2tp_core.c:1778
    pppol2tp_connect+0x48b/0x920 net/l2tp/l2tp_ppp.c:755
    __sys_connect_file+0x7a/0xb0 net/socket.c:2089
    __sys_connect+0xde/0x110 net/socket.c:2108
    __do_sys_connect net/socket.c:2114 [inline]
    __se_sys_connect net/socket.c:2111 [inline]
    __x64_sys_connect+0x1c/0x30 net/socket.c:2111
    do_syscall_x64 arch/x86/entry/syscall_64.c:63 [inline]
    do_syscall_64+0xa4/0xf80 arch/x86/entry/syscall_64.c:94
    entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 364798056f518 ("l2tp: Support different protocol versions with same IP/port quadruple")
Reported-by: syzbot+2c42ea4485b29beb0643@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/696693f2.a70a0220.245e30.0001.GAE@google.com/
Signed-off-by: Kuniyuki Iwashima <kuniyu@google.com>
Reviewed-by: Guillaume Nault <gnault@redhat.com>
Link: https://patch.msgid.link/20260113185446.2533333-1-kuniyu@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/l2tp/l2tp_core.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/net/l2tp/l2tp_core.c b/net/l2tp/l2tp_core.c
index 0710281dd95aa..d6f4bef0236dc 100644
--- a/net/l2tp/l2tp_core.c
+++ b/net/l2tp/l2tp_core.c
@@ -1086,8 +1086,10 @@ int l2tp_udp_encap_recv(struct sock *sk, struct sk_buff *skb)
 	tunnel = session->tunnel;
 
 	/* Check protocol version */
-	if (version != tunnel->version)
+	if (version != tunnel->version) {
+		l2tp_session_put(session);
 		goto invalid;
+	}
 
 	if (version == L2TP_HDR_VER_3 &&
 	    l2tp_v3_ensure_opt_in_linear(session, skb, &ptr, &optr)) {
-- 
2.51.0



