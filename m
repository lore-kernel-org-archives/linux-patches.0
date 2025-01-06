Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1EA71DE4CB;
	Mon,  6 Jan 2025 15:31:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736177469; cv=none; b=L/ZaOeKsJEcFjyEZhjsu6uEh5/5UGWUPCF/XNJ4WxGi9IThI5iE1cKUTPF+FsnODyEMcHDBN9vHTgqMfymBpCB6jnpT5xhr+ml3sUPEBb/a+DqiN23pCbHDI99Meoj5+IRirVUuGNB6Rdf8frWYwdM+kSU1z+O902hCp73tZkjg=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736177469; c=relaxed/simple;
	bh=AIqxo1KwBlyn/hAycIS6DX3ncROz5YwITeA8QqNGVxI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=d4bJ5wvAibTTFRLlcud/8NR0G4yI7GctUM9j1CoOtMmIP/+B2W5BQxAhypGqR5/TH3BViKyDE3otJ1/AfOhGmZcyeZaw/NpjMYWLvzRtlGggNeZ3s2ZYBSaFoG2GylPtwPcR4KO706ONCoWtQ3SYq2puWA5M/Y7vlFdZteCUMiI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=g5Z1ejBH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="g5Z1ejBH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0E838C4CEDF;
	Mon,  6 Jan 2025 15:31:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736177469;
	bh=AIqxo1KwBlyn/hAycIS6DX3ncROz5YwITeA8QqNGVxI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=g5Z1ejBH1ufIKgjjZ0q5gRSHmjR/yI2QHaLwU9y+Tyz2r2osjxJy8tyWssBRVKJf/
	 F/8QBw6MkaX9PDHaZZmTHCnQ1tBTRs8aPWh12boFbOzibpvNa+b1ZZ5oA1dkcNnkOn
	 Q03S2xTjm/cJi3wRTuoR0saHhqduvrB6/QCQBevg=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+8400677f3fd43f37d3bc@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Chengen Du <chengen.du@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 174/222] af_packet: fix vlan_get_tci() vs MSG_PEEK
Date: Mon,  6 Jan 2025 16:16:18 +0100
Message-ID: <20250106151157.350432676@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151150.585603565@linuxfoundation.org>
References: <20250106151150.585603565@linuxfoundation.org>
User-Agent: quilt/0.68
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

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit 77ee7a6d16b6ec07b5c3ae2b6b60a24c1afbed09 ]

Blamed commit forgot MSG_PEEK case, allowing a crash [1] as found
by syzbot.

Rework vlan_get_tci() to not touch skb at all,
so that it can be used from many cpus on the same skb.

Add a const qualifier to skb argument.

[1]
skbuff: skb_under_panic: text:ffffffff8a8da482 len:32 put:14 head:ffff88807a1d5800 data:ffff88807a1d5810 tail:0x14 end:0x140 dev:<NULL>
------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:206 !
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 0 UID: 0 PID: 5880 Comm: syz-executor172 Not tainted 6.13.0-rc3-syzkaller-00762-g9268abe611b0 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:skb_panic net/core/skbuff.c:206 [inline]
 RIP: 0010:skb_under_panic+0x14b/0x150 net/core/skbuff.c:216
Code: 0b 8d 48 c7 c6 9e 6c 26 8e 48 8b 54 24 08 8b 0c 24 44 8b 44 24 04 4d 89 e9 50 41 54 41 57 41 56 e8 3a 5a 79 f7 48 83 c4 20 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc90003baf5b8 EFLAGS: 00010286
RAX: 0000000000000087 RBX: dffffc0000000000 RCX: 8565c1eec37aa000
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff88802616fb50 R08: ffffffff817f0a4c R09: 1ffff92000775e50
R10: dffffc0000000000 R11: fffff52000775e51 R12: 0000000000000140
R13: ffff88807a1d5800 R14: ffff88807a1d5810 R15: 0000000000000014
FS:  00007fa03261f6c0(0000) GS:ffff8880b8600000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007ffd65753000 CR3: 0000000031720000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  skb_push+0xe5/0x100 net/core/skbuff.c:2636
  vlan_get_tci+0x272/0x550 net/packet/af_packet.c:565
  packet_recvmsg+0x13c9/0x1ef0 net/packet/af_packet.c:3616
  sock_recvmsg_nosec net/socket.c:1044 [inline]
  sock_recvmsg+0x22f/0x280 net/socket.c:1066
  ____sys_recvmsg+0x1c6/0x480 net/socket.c:2814
  ___sys_recvmsg net/socket.c:2856 [inline]
  do_recvmmsg+0x426/0xab0 net/socket.c:2951
  __sys_recvmmsg net/socket.c:3025 [inline]
  __do_sys_recvmmsg net/socket.c:3048 [inline]
  __se_sys_recvmmsg net/socket.c:3041 [inline]
  __x64_sys_recvmmsg+0x199/0x250 net/socket.c:3041
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83

Fixes: 79eecf631c14 ("af_packet: Handle outgoing VLAN packets without hardware offloading")
Reported-by: syzbot+8400677f3fd43f37d3bc@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6772c485.050a0220.2f3838.04c6.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Chengen Du <chengen.du@canonical.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20241230161004.2681892-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/packet/af_packet.c | 12 +++---------
 1 file changed, 3 insertions(+), 9 deletions(-)

diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 56e3ae3b6be9..96eca4a290ad 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -538,10 +538,8 @@ static void *packet_current_frame(struct packet_sock *po,
 	return packet_lookup_frame(po, rb, rb->head, status);
 }
 
-static u16 vlan_get_tci(struct sk_buff *skb, struct net_device *dev)
+static u16 vlan_get_tci(const struct sk_buff *skb, struct net_device *dev)
 {
-	u8 *skb_orig_data = skb->data;
-	int skb_orig_len = skb->len;
 	struct vlan_hdr vhdr, *vh;
 	unsigned int header_len;
 
@@ -562,12 +560,8 @@ static u16 vlan_get_tci(struct sk_buff *skb, struct net_device *dev)
 	else
 		return 0;
 
-	skb_push(skb, skb->data - skb_mac_header(skb));
-	vh = skb_header_pointer(skb, header_len, sizeof(vhdr), &vhdr);
-	if (skb_orig_data != skb->data) {
-		skb->data = skb_orig_data;
-		skb->len = skb_orig_len;
-	}
+	vh = skb_header_pointer(skb, skb_mac_offset(skb) + header_len,
+				sizeof(vhdr), &vhdr);
 	if (unlikely(!vh))
 		return 0;
 
-- 
2.39.5



