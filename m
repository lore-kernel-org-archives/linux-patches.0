Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D515E1422B8;
	Wed, 19 Jun 2024 13:12:48 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1718802768; cv=none; b=JzrL3SXt1vDnp0dmSmcrzeIgtrtuvPh03vNMdSyJE3uOOY14p73MYYGXINlp8ECcNQwZRtjgHzj27Ticnqlk4gs1qtAZFYStIrhF7MvFuHrTpslS6swjQyRbf0B7/g4bXVPOcggYmGAFfG3ojcLw3Do015Fv7r4cG7fwHUZJomE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1718802768; c=relaxed/simple;
	bh=IXQ93fVF61SlT5BRxXtBLFcjeOSLZxgPHcxNlZhamSY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=KYTadWKytDPlk1dfHBeBV7wyOhzdnGf/0204//E2FIzUC7no/D7fPHxaDw7Sk9/yJZpmYu4FRmcd8iOasqSm5zH2gFRx2u668dHWlq2+yRw76OJepABRCjEZeCAGvoy54hq1JMKRCiOZIkw5S5LhGkVe3olNUdvLw5EgeoLJ8Gc=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZuSJdZz; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZuSJdZz"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 587F9C2BBFC;
	Wed, 19 Jun 2024 13:12:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1718802768;
	bh=IXQ93fVF61SlT5BRxXtBLFcjeOSLZxgPHcxNlZhamSY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=yZuSJdZz9+/0Lb6Nmgo7vSKIN1cEK5YN52QjYJxrvRw4TTQ0pG61ZI6clzyYDDtLB
	 X7x4HTPsJI4OE4h1oez5LKan2aY0TkkYC4rEVhm1VMVsJlMzgDoluSqymB7NIq28cy
	 En3J71RDZToLS3jo92LNr8sysHPxKVQl7RFClW24=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Taehee Yoo <ap420073@gmail.com>,
	Shannon Nelson <shannon.nelson@amd.com>,
	Brett Creeley <brett.creeley@amd.com>,
	"David S. Miller" <davem@davemloft.net>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.9 039/281] ionic: fix kernel panic in XDP_TX action
Date: Wed, 19 Jun 2024 14:53:18 +0200
Message-ID: <20240619125611.353303338@linuxfoundation.org>
X-Mailer: git-send-email 2.45.2
In-Reply-To: <20240619125609.836313103@linuxfoundation.org>
References: <20240619125609.836313103@linuxfoundation.org>
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

6.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Taehee Yoo <ap420073@gmail.com>

[ Upstream commit 491aee894a08bc9b8bb52e7363b9d4bc6403f363 ]

In the XDP_TX path, ionic driver sends a packet to the TX path with rx
page and corresponding dma address.
After tx is done, ionic_tx_clean() frees that page.
But RX ring buffer isn't reset to NULL.
So, it uses a freed page, which causes kernel panic.

BUG: unable to handle page fault for address: ffff8881576c110c
PGD 773801067 P4D 773801067 PUD 87f086067 PMD 87efca067 PTE 800ffffea893e060
Oops: Oops: 0000 [#1] PREEMPT SMP DEBUG_PAGEALLOC KASAN NOPTI
CPU: 1 PID: 25 Comm: ksoftirqd/1 Not tainted 6.9.0+ #11
Hardware name: ASUS System Product Name/PRIME Z690-P D4, BIOS 0603 11/01/2021
RIP: 0010:bpf_prog_f0b8caeac1068a55_balancer_ingress+0x3b/0x44f
Code: 00 53 41 55 41 56 41 57 b8 01 00 00 00 48 8b 5f 08 4c 8b 77 00 4c 89 f7 48 83 c7 0e 48 39 d8
RSP: 0018:ffff888104e6fa28 EFLAGS: 00010283
RAX: 0000000000000002 RBX: ffff8881576c1140 RCX: 0000000000000002
RDX: ffffffffc0051f64 RSI: ffffc90002d33048 RDI: ffff8881576c110e
RBP: ffff888104e6fa88 R08: 0000000000000000 R09: ffffed1027a04a23
R10: 0000000000000000 R11: 0000000000000000 R12: ffff8881b03a21a8
R13: ffff8881589f800f R14: ffff8881576c1100 R15: 00000001576c1100
FS: 0000000000000000(0000) GS:ffff88881ae00000(0000) knlGS:0000000000000000
CS: 0010 DS: 0000 ES: 0000 CR0: 0000000080050033
CR2: ffff8881576c110c CR3: 0000000767a90000 CR4: 00000000007506f0
PKRU: 55555554
Call Trace:
<TASK>
? __die+0x20/0x70
? page_fault_oops+0x254/0x790
? __pfx_page_fault_oops+0x10/0x10
? __pfx_is_prefetch.constprop.0+0x10/0x10
? search_bpf_extables+0x165/0x260
? fixup_exception+0x4a/0x970
? exc_page_fault+0xcb/0xe0
? asm_exc_page_fault+0x22/0x30
? 0xffffffffc0051f64
? bpf_prog_f0b8caeac1068a55_balancer_ingress+0x3b/0x44f
? do_raw_spin_unlock+0x54/0x220
ionic_rx_service+0x11ab/0x3010 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
? ionic_tx_clean+0x29b/0xc60 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
? __pfx_ionic_tx_clean+0x10/0x10 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
? __pfx_ionic_rx_service+0x10/0x10 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
? ionic_tx_cq_service+0x25d/0xa00 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
? __pfx_ionic_rx_service+0x10/0x10 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
ionic_cq_service+0x69/0x150 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
ionic_txrx_napi+0x11a/0x540 [ionic 9180c3001ab627d82bbc5f3ebe8a0decaf6bb864]
__napi_poll.constprop.0+0xa0/0x440
net_rx_action+0x7e7/0xc30
? __pfx_net_rx_action+0x10/0x10

Fixes: 8eeed8373e1c ("ionic: Add XDP_TX support")
Signed-off-by: Taehee Yoo <ap420073@gmail.com>
Reviewed-by: Shannon Nelson <shannon.nelson@amd.com>
Reviewed-by: Brett Creeley <brett.creeley@amd.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/pensando/ionic/ionic_txrx.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
index 5dba6d2d633cb..2427610f4306d 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
+++ b/drivers/net/ethernet/pensando/ionic/ionic_txrx.c
@@ -586,6 +586,7 @@ static bool ionic_run_xdp(struct ionic_rx_stats *stats,
 			netdev_dbg(netdev, "tx ionic_xdp_post_frame err %d\n", err);
 			goto out_xdp_abort;
 		}
+		buf_info->page = NULL;
 		stats->xdp_tx++;
 
 		/* the Tx completion will free the buffers */
-- 
2.43.0



