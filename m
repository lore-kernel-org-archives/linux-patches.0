Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BF8B13B58B;
	Mon, 23 Jun 2025 13:15:22 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750684522; cv=none; b=iteugOoi0PKzSaI44RTqGK7GSJDeoErDnei5AfjPC1pB8q4pKptdMl8Qd3wpuPPlCAD11QfX3StY6SKhS7NuwZVb+kqAtJBSTDSWqaZRhJXL6kq//v6SW6RtGWSwiPcZgew+A56Bft7bIkkjrZyIW8fw1S6jwXgogtnZIbhcDQE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750684522; c=relaxed/simple;
	bh=mbHQRbqukhhcsfKi9sVZoTK8Jt7DV11vuBccB9gxJp0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mMQh++STi2gP3pnsEQJmJRCTYQDoZ7vdkJxnoegQ5/unAG9hhISjpih3pgWf5pVZ6EDscXFrYxFVWDn3YhbeFfwoX7bAagn+aWjFkALzZgMo/W1mnQYQrRdbr58DyZiUPdkOlIJzfegljs+jivrThkMM7XIDSN3+LLy+Oa5cRwM=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=zyVGhWG4; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="zyVGhWG4"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0FD0EC4CEF1;
	Mon, 23 Jun 2025 13:15:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750684522;
	bh=mbHQRbqukhhcsfKi9sVZoTK8Jt7DV11vuBccB9gxJp0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=zyVGhWG4JSApCLSh+HEAUxGbdgYet75IVs4B9+6s2PZg1k1VFna1Zkt6GvQYpIoAD
	 Yk90wSk9FPqCA1xIVUVYekWgCvnUOJKUiXVVo2QV8DlZmwARGmAl9eZ3NyG+kCkzLP
	 FOSjPy9XcEFF+x4ocH3Et3P17+NvKHXvDRs0SIRQ=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.15 101/592] can: kvaser_pciefd: refine error prone echo_skb_max handling logic
Date: Mon, 23 Jun 2025 15:00:59 +0200
Message-ID: <20250623130702.677692961@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130700.210182694@linuxfoundation.org>
References: <20250623130700.210182694@linuxfoundation.org>
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

6.15-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Fedor Pchelkin <pchelkin@ispras.ru>

commit 54ec8b08216f3be2cc98b33633d3c8ea79749895 upstream.

echo_skb_max should define the supported upper limit of echo_skb[]
allocated inside the netdevice's priv. The corresponding size value
provided by this driver to alloc_candev() is KVASER_PCIEFD_CAN_TX_MAX_COUNT
which is 17.

But later echo_skb_max is rounded up to the nearest power of two (for the
max case, that would be 32) and the tx/ack indices calculated further
during tx/rx may exceed the upper array boundary. Kasan reported this for
the ack case inside kvaser_pciefd_handle_ack_packet(), though the xmit
function has actually caught the same thing earlier.

 BUG: KASAN: slab-out-of-bounds in kvaser_pciefd_handle_ack_packet+0x2d7/0x92a drivers/net/can/kvaser_pciefd.c:1528
 Read of size 8 at addr ffff888105e4f078 by task swapper/4/0

 CPU: 4 UID: 0 PID: 0 Comm: swapper/4 Not tainted 6.15.0 #12 PREEMPT(voluntary)
 Call Trace:
  <IRQ>
 dump_stack_lvl lib/dump_stack.c:122
 print_report mm/kasan/report.c:521
 kasan_report mm/kasan/report.c:634
 kvaser_pciefd_handle_ack_packet drivers/net/can/kvaser_pciefd.c:1528
 kvaser_pciefd_read_packet drivers/net/can/kvaser_pciefd.c:1605
 kvaser_pciefd_read_buffer drivers/net/can/kvaser_pciefd.c:1656
 kvaser_pciefd_receive_irq drivers/net/can/kvaser_pciefd.c:1684
 kvaser_pciefd_irq_handler drivers/net/can/kvaser_pciefd.c:1733
 __handle_irq_event_percpu kernel/irq/handle.c:158
 handle_irq_event kernel/irq/handle.c:210
 handle_edge_irq kernel/irq/chip.c:833
 __common_interrupt arch/x86/kernel/irq.c:296
 common_interrupt arch/x86/kernel/irq.c:286
  </IRQ>

Tx max count definitely matters for kvaser_pciefd_tx_avail(), but for seq
numbers' generation that's not the case - we're free to calculate them as
would be more convenient, not taking tx max count into account. The only
downside is that the size of echo_skb[] should correspond to the max seq
number (not tx max count), so in some situations a bit more memory would
be consumed than could be.

Thus make the size of the underlying echo_skb[] sufficient for the rounded
max tx value.

Found by Linux Verification Center (linuxtesting.org) with Syzkaller.

Fixes: 8256e0ca6010 ("can: kvaser_pciefd: Fix echo_skb race")
Cc: stable@vger.kernel.org
Signed-off-by: Fedor Pchelkin <pchelkin@ispras.ru>
Link: https://patch.msgid.link/20250528192713.63894-1-pchelkin@ispras.ru
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/can/kvaser_pciefd.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -966,7 +966,7 @@ static int kvaser_pciefd_setup_can_ctrls
 		u32 status, tx_nr_packets_max;
 
 		netdev = alloc_candev(sizeof(struct kvaser_pciefd_can),
-				      KVASER_PCIEFD_CAN_TX_MAX_COUNT);
+				      roundup_pow_of_two(KVASER_PCIEFD_CAN_TX_MAX_COUNT));
 		if (!netdev)
 			return -ENOMEM;
 
@@ -995,7 +995,6 @@ static int kvaser_pciefd_setup_can_ctrls
 		can->tx_max_count = min(KVASER_PCIEFD_CAN_TX_MAX_COUNT, tx_nr_packets_max - 1);
 
 		can->can.clock.freq = pcie->freq;
-		can->can.echo_skb_max = roundup_pow_of_two(can->tx_max_count);
 		spin_lock_init(&can->lock);
 
 		can->can.bittiming_const = &kvaser_pciefd_bittiming_const;


