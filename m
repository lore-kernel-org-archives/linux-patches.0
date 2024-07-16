Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 294A312B72;
	Tue, 16 Jul 2024 15:45:54 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1721144754; cv=none; b=gVei3SPPr1MfrKo+KhWadmcVg42ckWA0qpXPQI5t+dbu9LlfLzHhC1Rh8CYQoCHFGgVHhBzOcB2x/kledzGkq2RrcNtukcjrCdcgw+VL65G+JJvot2aV0va9qeHJhUOdaX9cPThIhSSIhoSNpxGJCWi4VwfvPWJ6jI2+Jw1UB8A=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1721144754; c=relaxed/simple;
	bh=DT4hT0+B6wD7MxxW74EEin5JlN1HV3yURq+GI+hagHs=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=H+oW7RYc2lMQndVhY+1jBt+E2dsp0hKkm1Ec3fnC8kCw5RpOOdZrUtAYgt/EEckHjvkp4YCnoCMxNQ7ylvWW6QPchhbmkV2nCx8XKYPIujLybf3PNz8s8e3fL0ep+GRST8VSCitBE+EE5S82B5kjgTVTKDX092Y2zwiS/9q9dUE=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=LAmiem/6; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="LAmiem/6"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A33EEC116B1;
	Tue, 16 Jul 2024 15:45:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1721144754;
	bh=DT4hT0+B6wD7MxxW74EEin5JlN1HV3yURq+GI+hagHs=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=LAmiem/6cpUzlcVYKUkx1Jif5Nu2tq7RSZ576UEmOuGSAkHipNB6EtSPrQ5Whxanu
	 98KlN1wuffh4E7qieUcMTT5OO976c0UkN0IJz+192hQiyR2sPhh0xBmAEkW2wb+N4a
	 QhkM8gl9RC0T+8Z/0uh3/j/8+wJOppnrNqKv5Bcc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Jason A. Donenfeld" <Jason@zx2c4.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 093/108] wireguard: send: annotate intentional data race in checking empty queue
Date: Tue, 16 Jul 2024 17:31:48 +0200
Message-ID: <20240716152749.560659978@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240716152745.988603303@linuxfoundation.org>
References: <20240716152745.988603303@linuxfoundation.org>
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

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jason A. Donenfeld <Jason@zx2c4.com>

commit 381a7d453fa2ac5f854a154d3c9b1bbb90c4f94f upstream.

KCSAN reports a race in wg_packet_send_keepalive, which is intentional:

    BUG: KCSAN: data-race in wg_packet_send_keepalive / wg_packet_send_staged_packets

    write to 0xffff88814cd91280 of 8 bytes by task 3194 on cpu 0:
     __skb_queue_head_init include/linux/skbuff.h:2162 [inline]
     skb_queue_splice_init include/linux/skbuff.h:2248 [inline]
     wg_packet_send_staged_packets+0xe5/0xad0 drivers/net/wireguard/send.c:351
     wg_xmit+0x5b8/0x660 drivers/net/wireguard/device.c:218
     __netdev_start_xmit include/linux/netdevice.h:4940 [inline]
     netdev_start_xmit include/linux/netdevice.h:4954 [inline]
     xmit_one net/core/dev.c:3548 [inline]
     dev_hard_start_xmit+0x11b/0x3f0 net/core/dev.c:3564
     __dev_queue_xmit+0xeff/0x1d80 net/core/dev.c:4349
     dev_queue_xmit include/linux/netdevice.h:3134 [inline]
     neigh_connected_output+0x231/0x2a0 net/core/neighbour.c:1592
     neigh_output include/net/neighbour.h:542 [inline]
     ip6_finish_output2+0xa66/0xce0 net/ipv6/ip6_output.c:137
     ip6_finish_output+0x1a5/0x490 net/ipv6/ip6_output.c:222
     NF_HOOK_COND include/linux/netfilter.h:303 [inline]
     ip6_output+0xeb/0x220 net/ipv6/ip6_output.c:243
     dst_output include/net/dst.h:451 [inline]
     NF_HOOK include/linux/netfilter.h:314 [inline]
     ndisc_send_skb+0x4a2/0x670 net/ipv6/ndisc.c:509
     ndisc_send_rs+0x3ab/0x3e0 net/ipv6/ndisc.c:719
     addrconf_dad_completed+0x640/0x8e0 net/ipv6/addrconf.c:4295
     addrconf_dad_work+0x891/0xbc0
     process_one_work kernel/workqueue.c:2633 [inline]
     process_scheduled_works+0x5b8/0xa30 kernel/workqueue.c:2706
     worker_thread+0x525/0x730 kernel/workqueue.c:2787
     kthread+0x1d7/0x210 kernel/kthread.c:388
     ret_from_fork+0x48/0x60 arch/x86/kernel/process.c:147
     ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242

    read to 0xffff88814cd91280 of 8 bytes by task 3202 on cpu 1:
     skb_queue_empty include/linux/skbuff.h:1798 [inline]
     wg_packet_send_keepalive+0x20/0x100 drivers/net/wireguard/send.c:225
     wg_receive_handshake_packet drivers/net/wireguard/receive.c:186 [inline]
     wg_packet_handshake_receive_worker+0x445/0x5e0 drivers/net/wireguard/receive.c:213
     process_one_work kernel/workqueue.c:2633 [inline]
     process_scheduled_works+0x5b8/0xa30 kernel/workqueue.c:2706
     worker_thread+0x525/0x730 kernel/workqueue.c:2787
     kthread+0x1d7/0x210 kernel/kthread.c:388
     ret_from_fork+0x48/0x60 arch/x86/kernel/process.c:147
     ret_from_fork_asm+0x11/0x20 arch/x86/entry/entry_64.S:242

    value changed: 0xffff888148fef200 -> 0xffff88814cd91280

Mark this race as intentional by using the skb_queue_empty_lockless()
function rather than skb_queue_empty(), which uses READ_ONCE()
internally to annotate the race.

Cc: stable@vger.kernel.org
Fixes: e7096c131e51 ("net: WireGuard secure network tunnel")
Signed-off-by: Jason A. Donenfeld <Jason@zx2c4.com>
Link: https://patch.msgid.link/20240704154517.1572127-5-Jason@zx2c4.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireguard/send.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/net/wireguard/send.c
+++ b/drivers/net/wireguard/send.c
@@ -222,7 +222,7 @@ void wg_packet_send_keepalive(struct wg_
 {
 	struct sk_buff *skb;
 
-	if (skb_queue_empty(&peer->staged_packet_queue)) {
+	if (skb_queue_empty_lockless(&peer->staged_packet_queue)) {
 		skb = alloc_skb(DATA_PACKET_HEAD_ROOM + MESSAGE_MINIMUM_LENGTH,
 				GFP_ATOMIC);
 		if (unlikely(!skb))


