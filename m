Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F1E01EBA0A;
	Tue, 15 Oct 2024 12:12:38 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1728994358; cv=none; b=MzxFIAYEvwlgn9fCeNUARRald2wl0FMCbzTE+kvTB8qGOzyum4gyPBkzuG3QxY5xgmsyfNe8EGZpoTH7pCgwpvjYtEjcxUdaT6Usf0urq5XhViXCTqp2KbWfO+yr/N81iMEFyLBF5bSAUNQHeCv3WLWDT0a6FGeUp3NRDWSX4nI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1728994358; c=relaxed/simple;
	bh=HaH6Dmk7Ihj/ybrDznR9z3F5wq2ucNqRvvrtJBYjKBA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=EmmxTAwHb2le1vAMtCgNf7XPcdYgYmL5KdHxbXPj7Ei4nQZmTctYR7ZHajpD0RnLtohvnQjFzxxuJJYbDRk6N+KJGR0zsiJdWlEQe7E3nQRN6k8HGtB3BOgfQWP4TY/tlPXwXD8eSxD9Y/S7nE+o5UZh+jA0u583es9sVhAmHu8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=sgnb2/2V; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="sgnb2/2V"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 7C9BFC4CEC6;
	Tue, 15 Oct 2024 12:12:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1728994357;
	bh=HaH6Dmk7Ihj/ybrDznR9z3F5wq2ucNqRvvrtJBYjKBA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=sgnb2/2V8+u4Kaxtq9SrNp+QL4V7B5Wtv4HgNHPhtCeD0l41LeP5KDXC0W7HUL8gi
	 2nZ09pBhcTTj/7xbrMRDeXfn9GjqKmd2QDS/AqK3sFjPz2R4xvIsEfXbPmXolk6ZDy
	 SBjfgUI2Pn9v/zPSXK1jwhN9dISmmKjzBZrndioQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+2ada1bc857496353be5a@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 658/691] slip: make slhc_remember() more robust against malicious packets
Date: Tue, 15 Oct 2024 13:30:06 +0200
Message-ID: <20241015112506.440654322@linuxfoundation.org>
X-Mailer: git-send-email 2.47.0
In-Reply-To: <20241015112440.309539031@linuxfoundation.org>
References: <20241015112440.309539031@linuxfoundation.org>
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

5.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 7d3fce8cbe3a70a1c7c06c9b53696be5d5d8dd5c ]

syzbot found that slhc_remember() was missing checks against
malicious packets [1].

slhc_remember() only checked the size of the packet was at least 20,
which is not good enough.

We need to make sure the packet includes the IPv4 and TCP header
that are supposed to be carried.

Add iph and th pointers to make the code more readable.

[1]

BUG: KMSAN: uninit-value in slhc_remember+0x2e8/0x7b0 drivers/net/slip/slhc.c:666
  slhc_remember+0x2e8/0x7b0 drivers/net/slip/slhc.c:666
  ppp_receive_nonmp_frame+0xe45/0x35e0 drivers/net/ppp/ppp_generic.c:2455
  ppp_receive_frame drivers/net/ppp/ppp_generic.c:2372 [inline]
  ppp_do_recv+0x65f/0x40d0 drivers/net/ppp/ppp_generic.c:2212
  ppp_input+0x7dc/0xe60 drivers/net/ppp/ppp_generic.c:2327
  pppoe_rcv_core+0x1d3/0x720 drivers/net/ppp/pppoe.c:379
  sk_backlog_rcv+0x13b/0x420 include/net/sock.h:1113
  __release_sock+0x1da/0x330 net/core/sock.c:3072
  release_sock+0x6b/0x250 net/core/sock.c:3626
  pppoe_sendmsg+0x2b8/0xb90 drivers/net/ppp/pppoe.c:903
  sock_sendmsg_nosec net/socket.c:729 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:744
  ____sys_sendmsg+0x903/0xb60 net/socket.c:2602
  ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2656
  __sys_sendmmsg+0x3c1/0x960 net/socket.c:2742
  __do_sys_sendmmsg net/socket.c:2771 [inline]
  __se_sys_sendmmsg net/socket.c:2768 [inline]
  __x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2768
  x64_sys_call+0xb6e/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:308
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:4091 [inline]
  slab_alloc_node mm/slub.c:4134 [inline]
  kmem_cache_alloc_node_noprof+0x6bf/0xb80 mm/slub.c:4186
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:587
  __alloc_skb+0x363/0x7b0 net/core/skbuff.c:678
  alloc_skb include/linux/skbuff.h:1322 [inline]
  sock_wmalloc+0xfe/0x1a0 net/core/sock.c:2732
  pppoe_sendmsg+0x3a7/0xb90 drivers/net/ppp/pppoe.c:867
  sock_sendmsg_nosec net/socket.c:729 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:744
  ____sys_sendmsg+0x903/0xb60 net/socket.c:2602
  ___sys_sendmsg+0x28d/0x3c0 net/socket.c:2656
  __sys_sendmmsg+0x3c1/0x960 net/socket.c:2742
  __do_sys_sendmmsg net/socket.c:2771 [inline]
  __se_sys_sendmmsg net/socket.c:2768 [inline]
  __x64_sys_sendmmsg+0xbc/0x120 net/socket.c:2768
  x64_sys_call+0xb6e/0x3ba0 arch/x86/include/generated/asm/syscalls_64.h:308
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

CPU: 0 UID: 0 PID: 5460 Comm: syz.2.33 Not tainted 6.12.0-rc2-syzkaller-00006-g87d6aab2389e #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024

Fixes: b5451d783ade ("slip: Move the SLIP drivers")
Reported-by: syzbot+2ada1bc857496353be5a@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/670646db.050a0220.3f80e.0027.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20241009091132.2136321-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/slip/slhc.c | 57 ++++++++++++++++++++++++-----------------
 1 file changed, 34 insertions(+), 23 deletions(-)

diff --git a/drivers/net/slip/slhc.c b/drivers/net/slip/slhc.c
index ba93bab948e09..bf9e801cc61cc 100644
--- a/drivers/net/slip/slhc.c
+++ b/drivers/net/slip/slhc.c
@@ -643,46 +643,57 @@ slhc_uncompress(struct slcompress *comp, unsigned char *icp, int isize)
 int
 slhc_remember(struct slcompress *comp, unsigned char *icp, int isize)
 {
-	struct cstate *cs;
-	unsigned ihl;
-
+	const struct tcphdr *th;
 	unsigned char index;
+	struct iphdr *iph;
+	struct cstate *cs;
+	unsigned int ihl;
 
-	if(isize < 20) {
-		/* The packet is shorter than a legal IP header */
+	/* The packet is shorter than a legal IP header.
+	 * Also make sure isize is positive.
+	 */
+	if (isize < (int)sizeof(struct iphdr)) {
+runt:
 		comp->sls_i_runt++;
-		return slhc_toss( comp );
+		return slhc_toss(comp);
 	}
+	iph = (struct iphdr *)icp;
 	/* Peek at the IP header's IHL field to find its length */
-	ihl = icp[0] & 0xf;
-	if(ihl < 20 / 4){
-		/* The IP header length field is too small */
-		comp->sls_i_runt++;
-		return slhc_toss( comp );
-	}
-	index = icp[9];
-	icp[9] = IPPROTO_TCP;
+	ihl = iph->ihl;
+	/* The IP header length field is too small,
+	 * or packet is shorter than the IP header followed
+	 * by minimal tcp header.
+	 */
+	if (ihl < 5 || isize < ihl * 4 + sizeof(struct tcphdr))
+		goto runt;
+
+	index = iph->protocol;
+	iph->protocol = IPPROTO_TCP;
 
 	if (ip_fast_csum(icp, ihl)) {
 		/* Bad IP header checksum; discard */
 		comp->sls_i_badcheck++;
-		return slhc_toss( comp );
+		return slhc_toss(comp);
 	}
-	if(index > comp->rslot_limit) {
+	if (index > comp->rslot_limit) {
 		comp->sls_i_error++;
 		return slhc_toss(comp);
 	}
-
+	th = (struct tcphdr *)(icp + ihl * 4);
+	if (th->doff < sizeof(struct tcphdr) / 4)
+		goto runt;
+	if (isize < ihl * 4 + th->doff * 4)
+		goto runt;
 	/* Update local state */
 	cs = &comp->rstate[comp->recv_current = index];
 	comp->flags &=~ SLF_TOSS;
-	memcpy(&cs->cs_ip,icp,20);
-	memcpy(&cs->cs_tcp,icp + ihl*4,20);
+	memcpy(&cs->cs_ip, iph, sizeof(*iph));
+	memcpy(&cs->cs_tcp, th, sizeof(*th));
 	if (ihl > 5)
-	  memcpy(cs->cs_ipopt, icp + sizeof(struct iphdr), (ihl - 5) * 4);
-	if (cs->cs_tcp.doff > 5)
-	  memcpy(cs->cs_tcpopt, icp + ihl*4 + sizeof(struct tcphdr), (cs->cs_tcp.doff - 5) * 4);
-	cs->cs_hsize = ihl*2 + cs->cs_tcp.doff*2;
+	  memcpy(cs->cs_ipopt, &iph[1], (ihl - 5) * 4);
+	if (th->doff > 5)
+	  memcpy(cs->cs_tcpopt, &th[1], (th->doff - 5) * 4);
+	cs->cs_hsize = ihl*2 + th->doff*2;
 	cs->initialized = true;
 	/* Put headers back on packet
 	 * Neither header checksum is recalculated
-- 
2.43.0



