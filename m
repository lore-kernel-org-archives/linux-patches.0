Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2BB901DDC3C;
	Mon,  6 Jan 2025 16:01:01 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1736179261; cv=none; b=S5stxrnF0i/EBqwxEegnUcM48/3pROA0FcZyUeQJovfwFGXELwCimay/vb+Thasta4Jcn/WPcy2LDeCC/6+u1k7FsUT3tEV0J+egp22ZrKBH24HVmYcpy31sLlUihu9XGsI7rVdfgH0qoJMUtfSjRn8bjv5o6KDrz7Ag6SAwfyc=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1736179261; c=relaxed/simple;
	bh=eqlWQbAwOtvl544agQJ+2IEtM9EWi+3wpvn/w1W/vEc=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=vAazZFVl/YJNIgTuibBo3OsAS4WnKEP1NpfSVJCMQp1cggXsm/f71ULP6OSI0dSysGWJdzd8W/wRIHmnaJZsDFnZAbqTqDEsmPNX/YtZ37uRk7KVle7gngwPgT9OqYLSMGa/DojuFSF5dpJNjE6Auu+HVg2tvDOlRgUm8UyZ7Fc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=KudCeR0o; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="KudCeR0o"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 96CA4C4CED2;
	Mon,  6 Jan 2025 16:01:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1736179261;
	bh=eqlWQbAwOtvl544agQJ+2IEtM9EWi+3wpvn/w1W/vEc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=KudCeR0oXxpQY+MD+CIUN5qBPHPGkNfQM1vCIhM+XdgApH6ql2d6QH4g9k0yEfNRu
	 g2bgEfX3n//ALtXH3L+7s5RMOL2GTo2moA4MtJKLlyYGuXBhqyiPATMTq2naw7a4Qt
	 gxj++tIK1sslHB058b1QNgkiIxFAIOInMZQ764Ns=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+74f70bb1cb968bf09e4f@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	Chengen Du <chengen.du@canonical.com>,
	Willem de Bruijn <willemb@google.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.4 78/93] af_packet: fix vlan_get_protocol_dgram() vs MSG_PEEK
Date: Mon,  6 Jan 2025 16:17:54 +0100
Message-ID: <20250106151131.649639006@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20250106151128.686130933@linuxfoundation.org>
References: <20250106151128.686130933@linuxfoundation.org>
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

5.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Eric Dumazet <edumazet@google.com>

[ Upstream commit f91a5b8089389eb408501af2762f168c3aaa7b79 ]

Blamed commit forgot MSG_PEEK case, allowing a crash [1] as found
by syzbot.

Rework vlan_get_protocol_dgram() to not touch skb at all,
so that it can be used from many cpus on the same skb.

Add a const qualifier to skb argument.

[1]
skbuff: skb_under_panic: text:ffffffff8a8ccd05 len:29 put:14 head:ffff88807fc8e400 data:ffff88807fc8e3f4 tail:0x11 end:0x140 dev:<NULL>
------------[ cut here ]------------
 kernel BUG at net/core/skbuff.c:206 !
Oops: invalid opcode: 0000 [#1] PREEMPT SMP KASAN PTI
CPU: 1 UID: 0 PID: 5892 Comm: syz-executor883 Not tainted 6.13.0-rc4-syzkaller-00054-gd6ef8b40d075 #0
Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 09/13/2024
 RIP: 0010:skb_panic net/core/skbuff.c:206 [inline]
 RIP: 0010:skb_under_panic+0x14b/0x150 net/core/skbuff.c:216
Code: 0b 8d 48 c7 c6 86 d5 25 8e 48 8b 54 24 08 8b 0c 24 44 8b 44 24 04 4d 89 e9 50 41 54 41 57 41 56 e8 5a 69 79 f7 48 83 c4 20 90 <0f> 0b 0f 1f 00 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 90 f3
RSP: 0018:ffffc900038d7638 EFLAGS: 00010282
RAX: 0000000000000087 RBX: dffffc0000000000 RCX: 609ffd18ea660600
RDX: 0000000000000000 RSI: 0000000080000000 RDI: 0000000000000000
RBP: ffff88802483c8d0 R08: ffffffff817f0a8c R09: 1ffff9200071ae60
R10: dffffc0000000000 R11: fffff5200071ae61 R12: 0000000000000140
R13: ffff88807fc8e400 R14: ffff88807fc8e3f4 R15: 0000000000000011
FS:  00007fbac5e006c0(0000) GS:ffff8880b8700000(0000) knlGS:0000000000000000
CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: 00007fbac5e00d58 CR3: 000000001238e000 CR4: 00000000003526f0
DR0: 0000000000000000 DR1: 0000000000000000 DR2: 0000000000000000
DR3: 0000000000000000 DR6: 00000000fffe0ff0 DR7: 0000000000000400
Call Trace:
 <TASK>
  skb_push+0xe5/0x100 net/core/skbuff.c:2636
  vlan_get_protocol_dgram+0x165/0x290 net/packet/af_packet.c:585
  packet_recvmsg+0x948/0x1ef0 net/packet/af_packet.c:3552
  sock_recvmsg_nosec net/socket.c:1033 [inline]
  sock_recvmsg+0x22f/0x280 net/socket.c:1055
  ____sys_recvmsg+0x1c6/0x480 net/socket.c:2803
  ___sys_recvmsg net/socket.c:2845 [inline]
  do_recvmmsg+0x426/0xab0 net/socket.c:2940
  __sys_recvmmsg net/socket.c:3014 [inline]
  __do_sys_recvmmsg net/socket.c:3037 [inline]
  __se_sys_recvmmsg net/socket.c:3030 [inline]
  __x64_sys_recvmmsg+0x199/0x250 net/socket.c:3030
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xf3/0x230 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 79eecf631c14 ("af_packet: Handle outgoing VLAN packets without hardware offloading")
Reported-by: syzbot+74f70bb1cb968bf09e4f@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6772c485.050a0220.2f3838.04c5.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: Chengen Du <chengen.du@canonical.com>
Reviewed-by: Willem de Bruijn <willemb@google.com>
Link: https://patch.msgid.link/20241230161004.2681892-2-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/linux/if_vlan.h | 16 +++++++++++++---
 net/packet/af_packet.c  | 16 ++++------------
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/include/linux/if_vlan.h b/include/linux/if_vlan.h
index 4e7e72f3da5b..b3dae069bcd9 100644
--- a/include/linux/if_vlan.h
+++ b/include/linux/if_vlan.h
@@ -574,13 +574,16 @@ static inline int vlan_get_tag(const struct sk_buff *skb, u16 *vlan_tci)
  * vlan_get_protocol - get protocol EtherType.
  * @skb: skbuff to query
  * @type: first vlan protocol
+ * @mac_offset: MAC offset
  * @depth: buffer to store length of eth and vlan tags in bytes
  *
  * Returns the EtherType of the packet, regardless of whether it is
  * vlan encapsulated (normal or hardware accelerated) or not.
  */
-static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
-					 int *depth)
+static inline __be16 __vlan_get_protocol_offset(const struct sk_buff *skb,
+						__be16 type,
+						int mac_offset,
+						int *depth)
 {
 	unsigned int vlan_depth = skb->mac_len, parse_depth = VLAN_MAX_DEPTH;
 
@@ -599,7 +602,8 @@ static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
 		do {
 			struct vlan_hdr vhdr, *vh;
 
-			vh = skb_header_pointer(skb, vlan_depth, sizeof(vhdr), &vhdr);
+			vh = skb_header_pointer(skb, mac_offset + vlan_depth,
+						sizeof(vhdr), &vhdr);
 			if (unlikely(!vh || !--parse_depth))
 				return 0;
 
@@ -614,6 +618,12 @@ static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
 	return type;
 }
 
+static inline __be16 __vlan_get_protocol(const struct sk_buff *skb, __be16 type,
+					 int *depth)
+{
+	return __vlan_get_protocol_offset(skb, type, 0, depth);
+}
+
 /**
  * vlan_get_protocol - get protocol EtherType.
  * @skb: skbuff to query
diff --git a/net/packet/af_packet.c b/net/packet/af_packet.c
index 4938926137b2..b1cf6a069e63 100644
--- a/net/packet/af_packet.c
+++ b/net/packet/af_packet.c
@@ -522,21 +522,13 @@ static u16 vlan_get_tci(const struct sk_buff *skb, struct net_device *dev)
 	return ntohs(vh->h_vlan_TCI);
 }
 
-static __be16 vlan_get_protocol_dgram(struct sk_buff *skb)
+static __be16 vlan_get_protocol_dgram(const struct sk_buff *skb)
 {
 	__be16 proto = skb->protocol;
 
-	if (unlikely(eth_type_vlan(proto))) {
-		u8 *skb_orig_data = skb->data;
-		int skb_orig_len = skb->len;
-
-		skb_push(skb, skb->data - skb_mac_header(skb));
-		proto = __vlan_get_protocol(skb, proto, NULL);
-		if (skb_orig_data != skb->data) {
-			skb->data = skb_orig_data;
-			skb->len = skb_orig_len;
-		}
-	}
+	if (unlikely(eth_type_vlan(proto)))
+		proto = __vlan_get_protocol_offset(skb, proto,
+						   skb_mac_offset(skb), NULL);
 
 	return proto;
 }
-- 
2.39.5



