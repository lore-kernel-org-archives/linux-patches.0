Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A9CD52253E0;
	Thu, 12 Dec 2024 17:04:29 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1734023069; cv=none; b=DU52GhF7y6VaFq4ANxUozY0EpTdLxZwiMjTs9dfbQz6vQGcuUZmRpB9yhsdq+TR4pQoIW4juuh3jqYeY9GGNCZygcMOGRUi0yHrDb32sE3AAdrn8E04dLWbOi4WOpFHIpyO1MLUoghWj5XN/fWtAxjTCSN4VNT0Rxz/yZakXCas=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1734023069; c=relaxed/simple;
	bh=Pec7IZQb3KsBKISv1A/GDpv8ySzHVkl0WkxLFL5pCxU=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=axXDgze9sziTXHdvIMfPAxXqfwwPXnXo7qHlofr71wg/uhkL7t9H6U/9J+5X7V99CrqBonBHrErGGQFudAvnpSgAlvNx2chUNmpr/gpNAp0peCyt1vQPn15DC4740t28be6IYRfQnjrFTBXRaRvmJlgTUcRjv9TQJI0RS3zSJis=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VlMTIwXH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VlMTIwXH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C8F8CC4CECE;
	Thu, 12 Dec 2024 17:04:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1734023069;
	bh=Pec7IZQb3KsBKISv1A/GDpv8ySzHVkl0WkxLFL5pCxU=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VlMTIwXHlKwE8R2X1qZ780RsSjKORXWdvKGOswYlYCF/LSg0Xv6ETm7f61jkKqKjI
	 YlkJHho9PM9U/2xMbhp01tg/+vsEHEcG4dtQNMclVIijtkrIUvxrZk6Nfy9ftOZw5H
	 Jji+NcPzj9utiLjHh6mkfib/Es5xH1iV4uUJ7HQ8=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+671e2853f9851d039551@syzkaller.appspotmail.com,
	Eric Dumazet <edumazet@google.com>,
	WingMan Kwok <w-kwok2@ti.com>,
	Murali Karicheri <m-karicheri2@ti.com>,
	MD Danish Anwar <danishanwar@ti.com>,
	Jiri Pirko <jiri@nvidia.com>,
	George McCollister <george.mccollister@gmail.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 412/565] net: hsr: avoid potential out-of-bound access in fill_frame_info()
Date: Thu, 12 Dec 2024 16:00:07 +0100
Message-ID: <20241212144327.944525689@linuxfoundation.org>
X-Mailer: git-send-email 2.47.1
In-Reply-To: <20241212144311.432886635@linuxfoundation.org>
References: <20241212144311.432886635@linuxfoundation.org>
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

[ Upstream commit b9653d19e556c6afd035602927a93d100a0d7644 ]

syzbot is able to feed a packet with 14 bytes, pretending
it is a vlan one.

Since fill_frame_info() is relying on skb->mac_len already,
extend the check to cover this case.

BUG: KMSAN: uninit-value in fill_frame_info net/hsr/hsr_forward.c:709 [inline]
 BUG: KMSAN: uninit-value in hsr_forward_skb+0x9ee/0x3b10 net/hsr/hsr_forward.c:724
  fill_frame_info net/hsr/hsr_forward.c:709 [inline]
  hsr_forward_skb+0x9ee/0x3b10 net/hsr/hsr_forward.c:724
  hsr_dev_xmit+0x2f0/0x350 net/hsr/hsr_device.c:235
  __netdev_start_xmit include/linux/netdevice.h:5002 [inline]
  netdev_start_xmit include/linux/netdevice.h:5011 [inline]
  xmit_one net/core/dev.c:3590 [inline]
  dev_hard_start_xmit+0x247/0xa20 net/core/dev.c:3606
  __dev_queue_xmit+0x366a/0x57d0 net/core/dev.c:4434
  dev_queue_xmit include/linux/netdevice.h:3168 [inline]
  packet_xmit+0x9c/0x6c0 net/packet/af_packet.c:276
  packet_snd net/packet/af_packet.c:3146 [inline]
  packet_sendmsg+0x91ae/0xa6f0 net/packet/af_packet.c:3178
  sock_sendmsg_nosec net/socket.c:711 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:726
  __sys_sendto+0x594/0x750 net/socket.c:2197
  __do_sys_sendto net/socket.c:2204 [inline]
  __se_sys_sendto net/socket.c:2200 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2200
  x64_sys_call+0x346a/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:45
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Uninit was created at:
  slab_post_alloc_hook mm/slub.c:4091 [inline]
  slab_alloc_node mm/slub.c:4134 [inline]
  kmem_cache_alloc_node_noprof+0x6bf/0xb80 mm/slub.c:4186
  kmalloc_reserve+0x13d/0x4a0 net/core/skbuff.c:587
  __alloc_skb+0x363/0x7b0 net/core/skbuff.c:678
  alloc_skb include/linux/skbuff.h:1323 [inline]
  alloc_skb_with_frags+0xc8/0xd00 net/core/skbuff.c:6612
  sock_alloc_send_pskb+0xa81/0xbf0 net/core/sock.c:2881
  packet_alloc_skb net/packet/af_packet.c:2995 [inline]
  packet_snd net/packet/af_packet.c:3089 [inline]
  packet_sendmsg+0x74c6/0xa6f0 net/packet/af_packet.c:3178
  sock_sendmsg_nosec net/socket.c:711 [inline]
  __sock_sendmsg+0x30f/0x380 net/socket.c:726
  __sys_sendto+0x594/0x750 net/socket.c:2197
  __do_sys_sendto net/socket.c:2204 [inline]
  __se_sys_sendto net/socket.c:2200 [inline]
  __x64_sys_sendto+0x125/0x1d0 net/socket.c:2200
  x64_sys_call+0x346a/0x3c30 arch/x86/include/generated/asm/syscalls_64.h:45
  do_syscall_x64 arch/x86/entry/common.c:52 [inline]
  do_syscall_64+0xcd/0x1e0 arch/x86/entry/common.c:83
 entry_SYSCALL_64_after_hwframe+0x77/0x7f

Fixes: 48b491a5cc74 ("net: hsr: fix mac_len checks")
Reported-by: syzbot+671e2853f9851d039551@syzkaller.appspotmail.com
Closes: https://lore.kernel.org/netdev/6745dc7f.050a0220.21d33d.0018.GAE@google.com/T/#u
Signed-off-by: Eric Dumazet <edumazet@google.com>
Cc: WingMan Kwok <w-kwok2@ti.com>
Cc: Murali Karicheri <m-karicheri2@ti.com>
Cc: MD Danish Anwar <danishanwar@ti.com>
Cc: Jiri Pirko <jiri@nvidia.com>
Cc: George McCollister <george.mccollister@gmail.com>
Link: https://patch.msgid.link/20241126144344.4177332-1-edumazet@google.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index e31747d328e70..20d4c3f8d8750 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -546,6 +546,8 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 		frame->is_vlan = true;
 
 	if (frame->is_vlan) {
+		if (skb->mac_len < offsetofend(struct hsr_vlan_ethhdr, vlanhdr))
+			return -EINVAL;
 		vlan_hdr = (struct hsr_vlan_ethhdr *)ethhdr;
 		proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
 		/* FIXME: */
-- 
2.43.0



