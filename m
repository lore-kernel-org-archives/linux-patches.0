Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DA5FD221723;
	Mon, 23 Jun 2025 21:28:23 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1750714103; cv=none; b=GWTBPwhiBiLrK4P8RtHEL0ZIDlL7U7/4tuk3ShAepS12mPP4ziACptF7ieKJGTJhsSoMs55qtdNXLKu4poEmt5mJsdunt0S7X6s3mciJiGDrUJzQiaOOfKOikvSIgcrg/r9SO5SxGyFGbUrIJ0AG3O1iGlSxrpLrbO8hI5qfHHA=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1750714103; c=relaxed/simple;
	bh=96r9Qg84fJDPhXJTDS9Snb0Q11QUGOSw0aLGxubq4wI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=MUuC+yR2Ma5WPBVeApppzwQfUA7NN7NsaFJIXIbcKl8isjd0M2MfcX0feLh1Wax/mNtdyjhMt9fU3wGO7cKkKn+MP6g/qDeAqgy+CCbRqYsDeSiS4dKZdzgzsZps/OL165tP+kr8UpShZXUL+DUqBJ7NDT+/HJr4X0vOQ0hV8H0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=T0c45g1F; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="T0c45g1F"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 730BEC4CEEA;
	Mon, 23 Jun 2025 21:28:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1750714103;
	bh=96r9Qg84fJDPhXJTDS9Snb0Q11QUGOSw0aLGxubq4wI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=T0c45g1Fq2IsDmopvF3FhZUfXZwbk8w2lgwpU5W4fbNiruq4HpNc2D9LugM/ody4P
	 qEI2GqCUjuLDDnOI3nQJQ4zv6NRlnLPtDtWgfBwj8vtziNV8rq+AawynkPA/ZgHNLh
	 5UiZ9Z+XbR1I47vWJGtBfS2DH9gvlP2kzZenfIpE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Fedor Pchelkin <pchelkin@ispras.ru>,
	Marc Kleine-Budde <mkl@pengutronix.de>
Subject: [PATCH 6.12 081/414] can: kvaser_pciefd: refine error prone echo_skb_max handling logic
Date: Mon, 23 Jun 2025 15:03:38 +0200
Message-ID: <20250623130644.106725203@linuxfoundation.org>
X-Mailer: git-send-email 2.50.0
In-Reply-To: <20250623130642.015559452@linuxfoundation.org>
References: <20250623130642.015559452@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

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
 drivers/net/can/kvaser_pciefd.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/can/kvaser_pciefd.c b/drivers/net/can/kvaser_pciefd.c
index 7d3066691d5d..52301511ed1b 100644
--- a/drivers/net/can/kvaser_pciefd.c
+++ b/drivers/net/can/kvaser_pciefd.c
@@ -966,7 +966,7 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		u32 status, tx_nr_packets_max;
 
 		netdev = alloc_candev(sizeof(struct kvaser_pciefd_can),
-				      KVASER_PCIEFD_CAN_TX_MAX_COUNT);
+				      roundup_pow_of_two(KVASER_PCIEFD_CAN_TX_MAX_COUNT));
 		if (!netdev)
 			return -ENOMEM;
 
@@ -995,7 +995,6 @@ static int kvaser_pciefd_setup_can_ctrls(struct kvaser_pciefd *pcie)
 		can->tx_max_count = min(KVASER_PCIEFD_CAN_TX_MAX_COUNT, tx_nr_packets_max - 1);
 
 		can->can.clock.freq = pcie->freq;
-		can->can.echo_skb_max = roundup_pow_of_two(can->tx_max_count);
 		spin_lock_init(&can->lock);
 
 		can->can.bittiming_const = &kvaser_pciefd_bittiming_const;
-- 
2.50.0



