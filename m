Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8AE662BE058;
	Tue, 26 Aug 2025 14:21:17 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1756218077; cv=none; b=j8QEg0BdMvr3NGPIKnmoXgTyD6u4bv00In36145IxsZYwLvjrJ4NKQ6mf+7X0xB1aVrCiLxV0KuxuxZJcqdCmhNxnJKIhgjeJKTT2+py7SNECRTxKyJyZpt3/BL2RtTu+KVm4DecP5S+3jWZbnBrH58pIRi5syXHfr+zXAsd1Jo=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1756218077; c=relaxed/simple;
	bh=urs2VZgSSh7QJPSZnhRQj8p+fKdkQs3C7VheCEAYZdg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version:Content-Type; b=UxDgp4VAJ8EwWwhSC6IQwpLNPdarYmRtuyIAfPGqIokOM1Tlpc7UqwZHbKd3n7r7dAT/meiRckdHEUGP5RAzRQmK80DdPQe0CvDtEc/pbhLlyt4QM13nqZJZJD8zlyOTJ2lSgRthOoUQ9eMikDeYct4Q9V/ixZOIGDDm9H+vCS4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=JRJ1K4mB; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="JRJ1K4mB"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12BBBC4CEF1;
	Tue, 26 Aug 2025 14:21:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1756218077;
	bh=urs2VZgSSh7QJPSZnhRQj8p+fKdkQs3C7VheCEAYZdg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=JRJ1K4mBBZ6V+bVR/ioIvMUXObwABOZF+VL37LHZRKsDdaLaRXLRCOuBg4bbGokg3
	 3KlvZ8HTaoOrXjBj6NxiPsa/JHjj/1qSpryF12BzHksgiIff8NMjlAauSSo7TmTNkG
	 iI6Nb1z1CPhxUBV7x6kOxIEzWoaQi/7jDDgzId1U=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	stable@kernel.org,
	syzbot+a81f2759d022496b40ab@syzkaller.appspotmail.com,
	Jakub Acs <acsjakub@amazon.de>,
	Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH 5.10 385/523] net, hsr: reject HSR frame if skb cant hold tag
Date: Tue, 26 Aug 2025 13:09:55 +0200
Message-ID: <20250826110933.957227484@linuxfoundation.org>
X-Mailer: git-send-email 2.50.1
In-Reply-To: <20250826110924.562212281@linuxfoundation.org>
References: <20250826110924.562212281@linuxfoundation.org>
User-Agent: quilt/0.68
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit

5.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jakub Acs <acsjakub@amazon.de>

commit 7af76e9d18a9fd6f8611b3313c86c190f9b6a5a7 upstream.

Receiving HSR frame with insufficient space to hold HSR tag in the skb
can result in a crash (kernel BUG):

[   45.390915] skbuff: skb_under_panic: text:ffffffff86f32cac len:26 put:14 head:ffff888042418000 data:ffff888042417ff4 tail:0xe end:0x180 dev:bridge_slave_1
[   45.392559] ------------[ cut here ]------------
[   45.392912] kernel BUG at net/core/skbuff.c:211!
[   45.393276] Oops: invalid opcode: 0000 [#1] SMP DEBUG_PAGEALLOC KASAN NOPTI
[   45.393809] CPU: 1 UID: 0 PID: 2496 Comm: reproducer Not tainted 6.15.0 #12 PREEMPT(undef)
[   45.394433] Hardware name: QEMU Standard PC (i440FX + PIIX, 1996), BIOS rel-1.16.3-0-ga6ed6b701f0a-prebuilt.qemu.org 04/01/2014
[   45.395273] RIP: 0010:skb_panic+0x15b/0x1d0

<snip registers, remove unreliable trace>

[   45.402911] Call Trace:
[   45.403105]  <IRQ>
[   45.404470]  skb_push+0xcd/0xf0
[   45.404726]  br_dev_queue_push_xmit+0x7c/0x6c0
[   45.406513]  br_forward_finish+0x128/0x260
[   45.408483]  __br_forward+0x42d/0x590
[   45.409464]  maybe_deliver+0x2eb/0x420
[   45.409763]  br_flood+0x174/0x4a0
[   45.410030]  br_handle_frame_finish+0xc7c/0x1bc0
[   45.411618]  br_handle_frame+0xac3/0x1230
[   45.413674]  __netif_receive_skb_core.constprop.0+0x808/0x3df0
[   45.422966]  __netif_receive_skb_one_core+0xb4/0x1f0
[   45.424478]  __netif_receive_skb+0x22/0x170
[   45.424806]  process_backlog+0x242/0x6d0
[   45.425116]  __napi_poll+0xbb/0x630
[   45.425394]  net_rx_action+0x4d1/0xcc0
[   45.427613]  handle_softirqs+0x1a4/0x580
[   45.427926]  do_softirq+0x74/0x90
[   45.428196]  </IRQ>

This issue was found by syzkaller.

The panic happens in br_dev_queue_push_xmit() once it receives a
corrupted skb with ETH header already pushed in linear data. When it
attempts the skb_push() call, there's not enough headroom and
skb_push() panics.

The corrupted skb is put on the queue by HSR layer, which makes a
sequence of unintended transformations when it receives a specific
corrupted HSR frame (with incomplete TAG).

Fix it by dropping and consuming frames that are not long enough to
contain both ethernet and hsr headers.

Alternative fix would be to check for enough headroom before skb_push()
in br_dev_queue_push_xmit().

In the reproducer, this is injected via AF_PACKET, but I don't easily
see why it couldn't be sent over the wire from adjacent network.

Further Details:

In the reproducer, the following network interface chain is set up:

┌────────────────┐   ┌────────────────┐
│ veth0_to_hsr   ├───┤  hsr_slave0    ┼───┐
└────────────────┘   └────────────────┘   │
                                          │ ┌──────┐
                                          ├─┤ hsr0 ├───┐
                                          │ └──────┘   │
┌────────────────┐   ┌────────────────┐   │            │┌────────┐
│ veth1_to_hsr   ┼───┤  hsr_slave1    ├───┘            └┤        │
└────────────────┘   └────────────────┘                ┌┼ bridge │
                                                       ││        │
                                                       │└────────┘
                                                       │
                                        ┌───────┐      │
                                        │  ...  ├──────┘
                                        └───────┘

To trigger the events leading up to crash, reproducer sends a corrupted
HSR frame with incomplete TAG, via AF_PACKET socket on 'veth0_to_hsr'.

The first HSR-layer function to process this frame is
hsr_handle_frame(). It and then checks if the
protocol is ETH_P_PRP or ETH_P_HSR. If it is, it calls
skb_set_network_header(skb, ETH_HLEN + HSR_HLEN), without checking that
the skb is long enough. For the crashing frame it is not, and hence the
skb->network_header and skb->mac_len fields are set incorrectly,
pointing after the end of the linear buffer.

I will call this a BUG#1 and it is what is addressed by this patch. In
the crashing scenario before the fix, the skb continues to go down the
hsr path as follows.

hsr_handle_frame() then calls this sequence
hsr_forward_skb()
  fill_frame_info()
    hsr->proto_ops->fill_frame_info()
      hsr_fill_frame_info()

hsr_fill_frame_info() contains a check that intends to check whether the
skb actually contains the HSR header. But the check relies on the
skb->mac_len field which was erroneously setup due to BUG#1, so the
check passes and the execution continues  back in the hsr_forward_skb():

hsr_forward_skb()
  hsr_forward_do()
    hsr->proto_ops->get_untagged_frame()
      hsr_get_untagged_frame()
        create_stripped_skb_hsr()

In create_stripped_skb_hsr(), a copy of the skb is created and is
further corrupted by operation that attempts to strip the HSR tag in a
call to __pskb_copy().

The skb enters create_stripped_skb_hsr() with ethernet header pushed in
linear buffer. The skb_pull(skb_in, HSR_HLEN) thus pulls 6 bytes of
ethernet header into the headroom, creating skb_in with a headroom of
size 8. The subsequent __pskb_copy() then creates an skb with headroom
of just 2 and skb->len of just 12, this is how it looks after the copy:

gdb) p skb->len
$10 = 12
(gdb) p skb->data
$11 = (unsigned char *) 0xffff888041e45382 "\252\252\252\252\252!\210\373",
(gdb) p skb->head
$12 = (unsigned char *) 0xffff888041e45380 ""

It seems create_stripped_skb_hsr() assumes that ETH header is pulled
in the headroom when it's entered, because it just pulls HSR header on
top. But that is not the case in our code-path and we end up with the
corrupted skb instead. I will call this BUG#2

*I got confused here because it seems that under no conditions can
create_stripped_skb_hsr() work well, the assumption it makes is not true
during the processing of hsr frames - since the skb_push() in
hsr_handle_frame to skb_pull in hsr_deliver_master(). I wonder whether I
missed something here.*

Next, the execution arrives in hsr_deliver_master(). It calls
skb_pull(ETH_HLEN), which just returns NULL - the SKB does not have
enough space for the pull (as it only has 12 bytes in total at this
point).

*The skb_pull() here further suggests that ethernet header is meant
to be pushed through the whole hsr processing and
create_stripped_skb_hsr() should pull it before doing the HSR header
pull.*

hsr_deliver_master() then puts the corrupted skb on the queue, it is
then picked up from there by bridge frame handling layer and finally
lands in br_dev_queue_push_xmit where it panics.

Cc: stable@kernel.org
Fixes: 48b491a5cc74 ("net: hsr: fix mac_len checks")
Reported-by: syzbot+a81f2759d022496b40ab@syzkaller.appspotmail.com
Signed-off-by: Jakub Acs <acsjakub@amazon.de>
Reviewed-by: Eric Dumazet <edumazet@google.com>
Link: https://patch.msgid.link/20250819082842.94378-1-acsjakub@amazon.de
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 net/hsr/hsr_slave.c |    8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

--- a/net/hsr/hsr_slave.c
+++ b/net/hsr/hsr_slave.c
@@ -60,8 +60,14 @@ static rx_handler_result_t hsr_handle_fr
 	skb_push(skb, ETH_HLEN);
 	skb_reset_mac_header(skb);
 	if ((!hsr->prot_version && protocol == htons(ETH_P_PRP)) ||
-	    protocol == htons(ETH_P_HSR))
+	    protocol == htons(ETH_P_HSR)) {
+		if (!pskb_may_pull(skb, ETH_HLEN + HSR_HLEN)) {
+			kfree_skb(skb);
+			goto finish_consume;
+		}
+
 		skb_set_network_header(skb, ETH_HLEN + HSR_HLEN);
+	}
 	skb_reset_mac_len(skb);
 
 	hsr_forward_skb(skb, port);


