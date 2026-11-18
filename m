Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.remote-ip=100.103.45.18
ARC-Seal: i=1; d=subspace.kernel.org; s=arc20261015; a=rsa-sha256; cv=none;
	t=1795050186;
	b=RHJEHD8Bl6TQPc2Ys3XvUuZFCaWsMRWcKFmExcFz8gTXn2ylpG7fklXkjpZVk9yFNyWW
	 RFqPeNw3jVXCmrez9gVk8qp9/ecPiM9HmZgPzHiRlU+oDDWbOitHdVT6VfsXQRgJRamDF
	 +ugRocnuUd9jW0OOjOJij/ynbOzFnWBZClQSG1rzRYHtjOZ7RZvnTFtj8HLlNgL3I5m0b
	 sObT6IxPeTjIPrtcGvwX7RRT39Xjj58fOypIhCs9gph5lGX6EQ7UZu/VNF7HS2gGaeLgK
	 YMsmMoDEIbXFTJcgyGAYRM47lHaY6OoX1EwdteRwjgwC7k8rcfQDlTAjDlC2j0Zld5w==
ARC-Message-Signature: i=1; d=subspace.kernel.org; s=arc20261015;
	a=rsa-sha256; c=relaxed/relaxed; t=1795050186;
	h=Received:DKIM-Signature:From:To:Cc:Subject:Date:Message-ID:X-Mailer:
	 In-Reply-To:References:User-Agent:X-stable:X-Patchwork-Hint:
	 MIME-Version:Content-Transfer-Encoding;
	bh=s/JKeBItFu3qyvJJhu7eygdjHBw8Glz2MAd/6OTo4Sw=;
	b=KhsEFSiFhLiqNtjOvRo2Kxe1WhYMkono2VeWLwxCGYN7zgjQAM3jHChwB83T+olLZDr2
	 WjDwOBTaHImz16xS9wtXdgcB16e/TdS43vqawx0cC9dG6gLn6Pfpg2a48yl4iQQEI7rOg
	 Yjlb3hygQRAPft6Lpk21hgq44Inp3YB2BMJLg2d4l2eBnMbB6eLwyAlq444ocfn8ktqO9
	 nSjbfb64liy58TkfNkqIO85vTz6nT4BHzOst+q83Rm4fPTgXPWmuL+PZIQKdamK0eP1hx
	 AQgCCJa0DNfxT4dE/QmyMpFyKqU3qE0aDxZCmdwR9/QVGX5RviNwf8rYrZGFvE76jyQ==
ARC-Authentication-Results: i=1; smtp.subspace.kernel.org; 
	dkim=pass header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6iEUct+;
	arc=none smtp.remote-ip=100.103.45.18
Received: from smtp.kernel.org (quasi.space.kernel.org [100.103.45.18])
	(using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
	 key-exchange X25519 server-signature ECDSA (prime256v1))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0F934606A320;
	Thu, 19 Nov 2026 01:03:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.a=rsa-sha256 header.s=korg header.b=q6iEUct+
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 622931F000C4;
	Thu, 19 Nov 2026 01:03:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1795050185;
	bh=s/JKeBItFu3qyvJJhu7eygdjHBw8Glz2MAd/6OTo4Sw=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=q6iEUct+vOqv/uVhi4HNIQ5bGu98kQsNr/0MA1io+il9J++v3FEUanDy5/V1MfLLs
	 XQfDvfdiUHZnvtoJKhu5RC99h/gruyqUpStH56Gdsa8DFtUh/MsUQA4WL0Z3T4CGgu
	 spL8wtvaQtH9MKPklSmroMpPDyOP/JKnT3NZeggo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Zhu Yanjun <yanjun.zhu@linux.dev>,
	Zhiwei Zhang <202275009@qq.com>,
	Leon Romanovsky <leon@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.1 2617/2857] RDMA/rxe: Clear pkt->qp before the early drop exits in rxe_rcv()
Date: Wed, 18 Nov 2026 16:00:51 +0100
Message-ID: <20261118150335.804971248@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261118150201.293410965@linuxfoundation.org>
References: <20261118150201.293410965@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Post: <mailto:patches@lists.linux.dev>
List-Help: <mailto:patches+help@lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
List-Owner: <mailto:patches+owner@lists.linux.dev>
Precedence: list
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.1-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Zhiwei Zhang <202275009@qq.com>

[ Upstream commit 7d7214b39b14c9763c14445b139f63369063b65e ]

rxe_rcv() puts pkt->qp at its drop label, but leaves pkt->qp
uninitialized on the two paths that take an early goto:

	if (unlikely(skb->len < RXE_BTH_BYTES))
		goto drop;

	if (rxe_chk_dgid(rxe, skb) < 0)
		goto drop;

	pkt->opcode = bth_opcode(pkt);
	pkt->psn = bth_psn(pkt);
	pkt->qp = NULL;		<- too late for the gotos above
	...
drop:
	if (pkt->qp)
		rxe_put(pkt->qp);

pkt points into skb->cb, which rxe does not own at this point: the
network stack has used that space for its own state.  For IPv6,
ip6_rcv_core() memsets inet6_skb_parm and then writes

	IP6CB(skb)->nhoff = offsetof(struct ipv6hdr, nexthdr);

at offset 14, so the qword at cb + 8, which is where pkt->qp lives,
reads back as 0x0006000000000000 for every IPv6 packet.

Any IPv6 datagram to port 4791 whose payload is shorter than the BTH
takes the first goto and reaches the drop label with that value, so
rxe_put() runs refcount_dec_and_test() on 0x0006000000000150 and the
kernel faults, in softirq, on a non-canonical address:

	general protection fault, probably for non-canonical address
	0x0006000000000150: 0000 [#1] PREEMPT SMP
	RIP: 0010:__rxe_put+0x.../...
	Call Trace:
	 <IRQ>
	 rxe_rcv+0x.../... [rdma_rxe]
	 rxe_udp_encap_recv+0x.../... [rdma_rxe]
	 udp_queue_rcv_one_skb
	 ...
	Kernel panic - not syncing: Fatal exception in interrupt

The fault happens in softirq, so it panics even with panic_on_oops=0,
and with panic=0 the machine hangs until it is power cycled.  A remote
sender only needs to send an empty UDP datagram to port 4791; no RDMA
connection, GID or other state is involved and the rxe socket is bound
in init_net.

IPv4 is not affected: ip_rcv_core() memsets the whole inet_skb_parm, so
the pkt->qp slot is zero there.

Fix by clearing pkt->qp before the first early exit.  pkt->qp is only
ever assigned a reference-owning value by hdr_check() and
rxe_rcv_mcast_pkt(), both of which run after this point, so the put at
the drop label stays balanced.

The ordering has been unsafe since the driver was merged: the two early
gotos have preceded pkt->qp = NULL in every version since 8700e3e7c485.

Testing done: the driver was built and run on a 6.2 vendor tree that
carries this code, where a single 0-byte IPv6 datagram to port 4791
reproduced the panic above (that tree does not pull the UDP header in
rxe_udp_encap_recv(), so payloads of 0..3 bytes reach the first goto
there, versus 0..11 on mainline).  With this change, the same packets
are dropped as intended and tracing the drop label shows pkt->qp is 0
on every path that reaches it.  Not done: the mainline tree was not
built in the environment used to prepare this, and the reproducer is
left out of this message on purpose - both are available on request.

Fixes: 8700e3e7c485 ("Soft RoCE driver")
Reviewed-by: Zhu Yanjun <yanjun.zhu@linux.dev>
Signed-off-by: Zhiwei Zhang <202275009@qq.com>
Link: https://patch.msgid.link/tencent_FBB0EE9F592FD21FD4B0F3BFAD3336765209@qq.com
Signed-off-by: Leon Romanovsky <leon@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/infiniband/sw/rxe/rxe_recv.c | 9 ++++++++-
 1 file changed, 8 insertions(+), 1 deletion(-)

diff --git a/drivers/infiniband/sw/rxe/rxe_recv.c b/drivers/infiniband/sw/rxe/rxe_recv.c
index ab4745f208234..4c85d76be5a6b 100644
--- a/drivers/infiniband/sw/rxe/rxe_recv.c
+++ b/drivers/infiniband/sw/rxe/rxe_recv.c
@@ -311,6 +311,14 @@ void rxe_rcv(struct sk_buff *skb)
 	struct rxe_pkt_info *pkt = SKB_TO_PKT(skb);
 	struct rxe_dev *rxe = pkt->rxe;
 
+	/*
+	 * pkt lives in skb->cb, which the network stack has already used
+	 * for its own state: for IPv6 the qword holding pkt->qp holds
+	 * inet6_skb_parm.nhoff.  The drop label puts pkt->qp, so clear
+	 * it before the first early exit.
+	 */
+	pkt->qp = NULL;
+
 	if (unlikely(skb->len < RXE_BTH_BYTES))
 		goto drop;
 
@@ -319,7 +327,6 @@ void rxe_rcv(struct sk_buff *skb)
 
 	pkt->opcode = bth_opcode(pkt);
 	pkt->psn = bth_psn(pkt);
-	pkt->qp = NULL;
 	pkt->mask |= rxe_opcode[pkt->opcode].mask;
 
 	/*
-- 
2.53.0



