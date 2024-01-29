Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 836E473722;
	Mon, 29 Jan 2024 17:15:37 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1706548537; cv=none; b=aZBX2aldCSa+U89ttH5zT6o7aFXwBvk1DPbVcO9u8b0tHmf9ezTu0Ej4Oy/jL6tW60aMBye//j4pQlZKjQP1+Wrplizr+B2CGUbncXI0j0JOo9VHerM4UOH2AlS5KyVL3hjReir6jUg8FR9GPp8lBmuB0zpoGVdpOFGWOC3dBoU=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1706548537; c=relaxed/simple;
	bh=XoQhAezgJnrqJD8/y9PzKWJflPZ2ocxhhmr5Yo5f7j8=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PcyK+BqCGRus5NGn11mqY5p+9nehi+kFB4kx9SPP6+nCZN8CKQE9NvcjNAGEifnl9YLfOpEAkKxb2RrOCd4lY+8U1UrLWN/9EKoXHOmpfsd4sKMfHR33i83XOGSYcha32G0HzAeO+byTnauGQZyGOEHiRN7kCixedOUvj/fN98c=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KLlAxprP; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KLlAxprP"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4AD30C433F1;
	Mon, 29 Jan 2024 17:15:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1706548537;
	bh=XoQhAezgJnrqJD8/y9PzKWJflPZ2ocxhhmr5Yo5f7j8=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KLlAxprPp9SZqnI1mrDPBUZ1aBodmeWUPJdqPZYtlIxZlhGp21hw0w8hDqqMgvQhA
	 aPUpCr/KZgqKpv+lUKceMsFlA36dzGmJZKCqlvP1jvrNUST72yVGc9OW+3hJrarOaf
	 vQIUKBAbcJNVdc9CBX1fItISP+KHMDs9VeIzNum0=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+b5ad66046b913bc04c6f@syzkaller.appspotmail.com,
	Kuniyuki Iwashima <kuniyu@amazon.com>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 176/331] llc: Drop support for ETH_P_TR_802_2.
Date: Mon, 29 Jan 2024 09:04:00 -0800
Message-ID: <20240129170020.061918474@linuxfoundation.org>
X-Mailer: git-send-email 2.43.0
In-Reply-To: <20240129170014.969142961@linuxfoundation.org>
References: <20240129170014.969142961@linuxfoundation.org>
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

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Kuniyuki Iwashima <kuniyu@amazon.com>

[ Upstream commit e3f9bed9bee261e3347131764e42aeedf1ffea61 ]

syzbot reported an uninit-value bug below. [0]

llc supports ETH_P_802_2 (0x0004) and used to support ETH_P_TR_802_2
(0x0011), and syzbot abused the latter to trigger the bug.

  write$tun(r0, &(0x7f0000000040)={@val={0x0, 0x11}, @val, @mpls={[], @llc={@snap={0xaa, 0x1, ')', "90e5dd"}}}}, 0x16)

llc_conn_handler() initialises local variables {saddr,daddr}.mac
based on skb in llc_pdu_decode_sa()/llc_pdu_decode_da() and passes
them to __llc_lookup().

However, the initialisation is done only when skb->protocol is
htons(ETH_P_802_2), otherwise, __llc_lookup_established() and
__llc_lookup_listener() will read garbage.

The missing initialisation existed prior to commit 211ed865108e
("net: delete all instances of special processing for token ring").

It removed the part to kick out the token ring stuff but forgot to
close the door allowing ETH_P_TR_802_2 packets to sneak into llc_rcv().

Let's remove llc_tr_packet_type and complete the deprecation.

[0]:
BUG: KMSAN: uninit-value in __llc_lookup_established+0xe9d/0xf90
 __llc_lookup_established+0xe9d/0xf90
 __llc_lookup net/llc/llc_conn.c:611 [inline]
 llc_conn_handler+0x4bd/0x1360 net/llc/llc_conn.c:791
 llc_rcv+0xfbb/0x14a0 net/llc/llc_input.c:206
 __netif_receive_skb_one_core net/core/dev.c:5527 [inline]
 __netif_receive_skb+0x1a6/0x5a0 net/core/dev.c:5641
 netif_receive_skb_internal net/core/dev.c:5727 [inline]
 netif_receive_skb+0x58/0x660 net/core/dev.c:5786
 tun_rx_batched+0x3ee/0x980 drivers/net/tun.c:1555
 tun_get_user+0x53af/0x66d0 drivers/net/tun.c:2002
 tun_chr_write_iter+0x3af/0x5d0 drivers/net/tun.c:2048
 call_write_iter include/linux/fs.h:2020 [inline]
 new_sync_write fs/read_write.c:491 [inline]
 vfs_write+0x8ef/0x1490 fs/read_write.c:584
 ksys_write+0x20f/0x4c0 fs/read_write.c:637
 __do_sys_write fs/read_write.c:649 [inline]
 __se_sys_write fs/read_write.c:646 [inline]
 __x64_sys_write+0x93/0xd0 fs/read_write.c:646
 do_syscall_x64 arch/x86/entry/common.c:51 [inline]
 do_syscall_64+0x44/0x110 arch/x86/entry/common.c:82
 entry_SYSCALL_64_after_hwframe+0x63/0x6b

Local variable daddr created at:
 llc_conn_handler+0x53/0x1360 net/llc/llc_conn.c:783
 llc_rcv+0xfbb/0x14a0 net/llc/llc_input.c:206

CPU: 1 PID: 5004 Comm: syz-executor994 Not tainted 6.6.0-syzkaller-14500-g1c41041124bd #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 10/09/2023

Fixes: 211ed865108e ("net: delete all instances of special processing for token ring")
Reported-by: syzbot+b5ad66046b913bc04c6f@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=b5ad66046b913bc04c6f
Signed-off-by: Kuniyuki Iwashima <kuniyu@amazon.com>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://lore.kernel.org/r/20240119015515.61898-1-kuniyu@amazon.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/llc_pdu.h | 6 ++----
 net/llc/llc_core.c    | 7 -------
 2 files changed, 2 insertions(+), 11 deletions(-)

diff --git a/include/net/llc_pdu.h b/include/net/llc_pdu.h
index 7e73f8e5e497..1d55ba7c45be 100644
--- a/include/net/llc_pdu.h
+++ b/include/net/llc_pdu.h
@@ -262,8 +262,7 @@ static inline void llc_pdu_header_init(struct sk_buff *skb, u8 type,
  */
 static inline void llc_pdu_decode_sa(struct sk_buff *skb, u8 *sa)
 {
-	if (skb->protocol == htons(ETH_P_802_2))
-		memcpy(sa, eth_hdr(skb)->h_source, ETH_ALEN);
+	memcpy(sa, eth_hdr(skb)->h_source, ETH_ALEN);
 }
 
 /**
@@ -275,8 +274,7 @@ static inline void llc_pdu_decode_sa(struct sk_buff *skb, u8 *sa)
  */
 static inline void llc_pdu_decode_da(struct sk_buff *skb, u8 *da)
 {
-	if (skb->protocol == htons(ETH_P_802_2))
-		memcpy(da, eth_hdr(skb)->h_dest, ETH_ALEN);
+	memcpy(da, eth_hdr(skb)->h_dest, ETH_ALEN);
 }
 
 /**
diff --git a/net/llc/llc_core.c b/net/llc/llc_core.c
index 6e387aadffce..4f16d9c88350 100644
--- a/net/llc/llc_core.c
+++ b/net/llc/llc_core.c
@@ -135,22 +135,15 @@ static struct packet_type llc_packet_type __read_mostly = {
 	.func = llc_rcv,
 };
 
-static struct packet_type llc_tr_packet_type __read_mostly = {
-	.type = cpu_to_be16(ETH_P_TR_802_2),
-	.func = llc_rcv,
-};
-
 static int __init llc_init(void)
 {
 	dev_add_pack(&llc_packet_type);
-	dev_add_pack(&llc_tr_packet_type);
 	return 0;
 }
 
 static void __exit llc_exit(void)
 {
 	dev_remove_pack(&llc_packet_type);
-	dev_remove_pack(&llc_tr_packet_type);
 }
 
 module_init(llc_init);
-- 
2.43.0



