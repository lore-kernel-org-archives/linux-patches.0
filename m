Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F5576FB5
	for <patches@lists.linux.dev>; Sun, 17 Sep 2023 20:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B054AC433C7;
	Sun, 17 Sep 2023 20:41:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1694983291;
	bh=91BioLJnozvFzwKh/WNabdfFg+F3pcHqpdAByr/WAI4=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=psiCJXm51NwKQphYNBYNKIiyFm3jJPaqXnD+Zdj/gPZvxeZBm+leTWHeOMK+7lmwp
	 RhBtnL5t6dGZM6yK08nqC9yh3tmk5OvjzszJ64YnU9x20t0Dnc9dcAuL+fI2pXVokT
	 WOKdOLuMmx5PuiRFPCyq10n8wkY+h49D12MV1vHI=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	syzbot+bf7e6250c7ce248f3ec9@syzkaller.appspotmail.com,
	Ziyang Xuan <william.xuanziyang@huawei.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 5.15 498/511] hsr: Fix uninit-value access in fill_frame_info()
Date: Sun, 17 Sep 2023 21:15:25 +0200
Message-ID: <20230917191125.752045262@linuxfoundation.org>
X-Mailer: git-send-email 2.42.0
In-Reply-To: <20230917191113.831992765@linuxfoundation.org>
References: <20230917191113.831992765@linuxfoundation.org>
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

From: Ziyang Xuan <william.xuanziyang@huawei.com>

[ Upstream commit 484b4833c604c0adcf19eac1ca14b60b757355b5 ]

Syzbot reports the following uninit-value access problem.

=====================================================
BUG: KMSAN: uninit-value in fill_frame_info net/hsr/hsr_forward.c:601 [inline]
BUG: KMSAN: uninit-value in hsr_forward_skb+0x9bd/0x30f0 net/hsr/hsr_forward.c:616
 fill_frame_info net/hsr/hsr_forward.c:601 [inline]
 hsr_forward_skb+0x9bd/0x30f0 net/hsr/hsr_forward.c:616
 hsr_dev_xmit+0x192/0x330 net/hsr/hsr_device.c:223
 __netdev_start_xmit include/linux/netdevice.h:4889 [inline]
 netdev_start_xmit include/linux/netdevice.h:4903 [inline]
 xmit_one net/core/dev.c:3544 [inline]
 dev_hard_start_xmit+0x247/0xa10 net/core/dev.c:3560
 __dev_queue_xmit+0x34d0/0x52a0 net/core/dev.c:4340
 dev_queue_xmit include/linux/netdevice.h:3082 [inline]
 packet_xmit+0x9c/0x6b0 net/packet/af_packet.c:276
 packet_snd net/packet/af_packet.c:3087 [inline]
 packet_sendmsg+0x8b1d/0x9f30 net/packet/af_packet.c:3119
 sock_sendmsg_nosec net/socket.c:730 [inline]
 sock_sendmsg net/socket.c:753 [inline]
 __sys_sendto+0x781/0xa30 net/socket.c:2176
 __do_sys_sendto net/socket.c:2188 [inline]
 __se_sys_sendto net/socket.c:2184 [inline]
 __ia32_sys_sendto+0x11f/0x1c0 net/socket.c:2184
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x37/0x80 arch/x86/entry/common.c:203
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:246
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

Uninit was created at:
 slab_post_alloc_hook+0x12f/0xb70 mm/slab.h:767
 slab_alloc_node mm/slub.c:3478 [inline]
 kmem_cache_alloc_node+0x577/0xa80 mm/slub.c:3523
 kmalloc_reserve+0x148/0x470 net/core/skbuff.c:559
 __alloc_skb+0x318/0x740 net/core/skbuff.c:644
 alloc_skb include/linux/skbuff.h:1286 [inline]
 alloc_skb_with_frags+0xc8/0xbd0 net/core/skbuff.c:6299
 sock_alloc_send_pskb+0xa80/0xbf0 net/core/sock.c:2794
 packet_alloc_skb net/packet/af_packet.c:2936 [inline]
 packet_snd net/packet/af_packet.c:3030 [inline]
 packet_sendmsg+0x70e8/0x9f30 net/packet/af_packet.c:3119
 sock_sendmsg_nosec net/socket.c:730 [inline]
 sock_sendmsg net/socket.c:753 [inline]
 __sys_sendto+0x781/0xa30 net/socket.c:2176
 __do_sys_sendto net/socket.c:2188 [inline]
 __se_sys_sendto net/socket.c:2184 [inline]
 __ia32_sys_sendto+0x11f/0x1c0 net/socket.c:2184
 do_syscall_32_irqs_on arch/x86/entry/common.c:112 [inline]
 __do_fast_syscall_32+0xa2/0x100 arch/x86/entry/common.c:178
 do_fast_syscall_32+0x37/0x80 arch/x86/entry/common.c:203
 do_SYSENTER_32+0x1f/0x30 arch/x86/entry/common.c:246
 entry_SYSENTER_compat_after_hwframe+0x70/0x82

It is because VLAN not yet supported in hsr driver. Return error
when protocol is ETH_P_8021Q in fill_frame_info() now to fix it.

Fixes: 451d8123f897 ("net: prp: add packet handling support")
Reported-by: syzbot+bf7e6250c7ce248f3ec9@syzkaller.appspotmail.com
Closes: https://syzkaller.appspot.com/bug?extid=bf7e6250c7ce248f3ec9
Signed-off-by: Ziyang Xuan <william.xuanziyang@huawei.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/hsr/hsr_forward.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/net/hsr/hsr_forward.c b/net/hsr/hsr_forward.c
index 35382ed686d1d..12ba43023d30e 100644
--- a/net/hsr/hsr_forward.c
+++ b/net/hsr/hsr_forward.c
@@ -552,6 +552,7 @@ static int fill_frame_info(struct hsr_frame_info *frame,
 		proto = vlan_hdr->vlanhdr.h_vlan_encapsulated_proto;
 		/* FIXME: */
 		netdev_warn_once(skb->dev, "VLAN not yet supported");
+		return -EINVAL;
 	}
 
 	frame->is_from_san = false;
-- 
2.40.1



