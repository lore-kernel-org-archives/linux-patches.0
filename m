Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 086BF1E1A05;
	Mon, 12 May 2025 17:58:09 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1747072690; cv=none; b=o1Ri2dABbuvq1iNKcTR1zQ7ZTMKhWp5x8RVRyjGwU0NqwSO79+/eun3GFiYhhX8HigGdhhgPH01JVI4IFDoOrVLhVrKjtb48hUOhmzzFVCgzyGcnaH9zg5ep/4gKVt0/Njrj/brbqNbJyoTxiaguGHM76xi6tECXu1PLvWSicMY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1747072690; c=relaxed/simple;
	bh=Sk1tUuJc/6dw2LQwSo9WsBZuf4f/iiB4ucq8vyHejIQ=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=PeOgtnr+QTGqBkWBtUKfqis6jCnvvNuIPHyUMd/pC2lZHg0IAoorgzWc6ZjAJrFzgIh/ukavJC0h8ATtQ6A1TkgHzUIG1HvngrkY7fgiBUYnnmALcGTAs1XBDY+UB0Ln4XTvv0+gafAFIMtq+sbF+VG+rrvnOMOTI3bQQwaK/Pc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=iW3OPtw1; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="iW3OPtw1"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 18C3DC4CEE7;
	Mon, 12 May 2025 17:58:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1747072689;
	bh=Sk1tUuJc/6dw2LQwSo9WsBZuf4f/iiB4ucq8vyHejIQ=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=iW3OPtw14Foj1SZ/+zP50qTnYznpZmFgmtWntZThpvE28rlT2jLyo+zJnT+3JxDcH
	 5J15F0k5HSYGBe7LK9DGvoNslYYyjp7Du13SksgmrxOVqVJ9yeauAv6toGxSyAZhL/
	 lwurI9LR96v3B5yHPpvo6ErOTS3CHXQj7uLNbVLY=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Antonios Salios <antonios@mwa.re>,
	Vincent Mailhol <mailhol.vincent@wanadoo.fr>,
	Markus Schneider-Pargmann <msp@baylibre.com>,
	Marc Kleine-Budde <mkl@pengutronix.de>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 025/184] can: m_can: m_can_class_allocate_dev(): initialize spin lock on device probe
Date: Mon, 12 May 2025 19:43:46 +0200
Message-ID: <20250512172042.732020252@linuxfoundation.org>
X-Mailer: git-send-email 2.49.0
In-Reply-To: <20250512172041.624042835@linuxfoundation.org>
References: <20250512172041.624042835@linuxfoundation.org>
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

From: Antonios Salios <antonios@mwa.re>

[ Upstream commit dcaeeb8ae84c5506ebc574732838264f3887738c ]

The spin lock tx_handling_spinlock in struct m_can_classdev is not
being initialized. This leads the following spinlock bad magic
complaint from the kernel, eg. when trying to send CAN frames with
cansend from can-utils:

| BUG: spinlock bad magic on CPU#0, cansend/95
|  lock: 0xff60000002ec1010, .magic: 00000000, .owner: <none>/-1, .owner_cpu: 0
| CPU: 0 UID: 0 PID: 95 Comm: cansend Not tainted 6.15.0-rc3-00032-ga79be02bba5c #5 NONE
| Hardware name: MachineWare SIM-V (DT)
| Call Trace:
| [<ffffffff800133e0>] dump_backtrace+0x1c/0x24
| [<ffffffff800022f2>] show_stack+0x28/0x34
| [<ffffffff8000de3e>] dump_stack_lvl+0x4a/0x68
| [<ffffffff8000de70>] dump_stack+0x14/0x1c
| [<ffffffff80003134>] spin_dump+0x62/0x6e
| [<ffffffff800883ba>] do_raw_spin_lock+0xd0/0x142
| [<ffffffff807a6fcc>] _raw_spin_lock_irqsave+0x20/0x2c
| [<ffffffff80536dba>] m_can_start_xmit+0x90/0x34a
| [<ffffffff806148b0>] dev_hard_start_xmit+0xa6/0xee
| [<ffffffff8065b730>] sch_direct_xmit+0x114/0x292
| [<ffffffff80614e2a>] __dev_queue_xmit+0x3b0/0xaa8
| [<ffffffff8073b8fa>] can_send+0xc6/0x242
| [<ffffffff8073d1c0>] raw_sendmsg+0x1a8/0x36c
| [<ffffffff805ebf06>] sock_write_iter+0x9a/0xee
| [<ffffffff801d06ea>] vfs_write+0x184/0x3a6
| [<ffffffff801d0a88>] ksys_write+0xa0/0xc0
| [<ffffffff801d0abc>] __riscv_sys_write+0x14/0x1c
| [<ffffffff8079ebf8>] do_trap_ecall_u+0x168/0x212
| [<ffffffff807a830a>] handle_exception+0x146/0x152

Initializing the spin lock in m_can_class_allocate_dev solves that
problem.

Fixes: 1fa80e23c150 ("can: m_can: Introduce a tx_fifo_in_flight counter")
Signed-off-by: Antonios Salios <antonios@mwa.re>
Reviewed-by: Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Link: https://patch.msgid.link/20250425111744.37604-2-antonios@mwa.re
Reviewed-by: Markus Schneider-Pargmann <msp@baylibre.com>
Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/can/m_can/m_can.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/can/m_can/m_can.c b/drivers/net/can/m_can/m_can.c
index 3c2c1db9866d4..dbd4d8796f9b0 100644
--- a/drivers/net/can/m_can/m_can.c
+++ b/drivers/net/can/m_can/m_can.c
@@ -2372,6 +2372,7 @@ struct m_can_classdev *m_can_class_allocate_dev(struct device *dev,
 	SET_NETDEV_DEV(net_dev, dev);
 
 	m_can_of_parse_mram(class_dev, mram_config_vals);
+	spin_lock_init(&class_dev->tx_handling_spinlock);
 out:
 	return class_dev;
 }
-- 
2.39.5



