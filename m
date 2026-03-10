Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 597B43803CD;
	Tue, 10 Mar 2026 11:29:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142195; cv=none; b=eamu3HYY9wnrXczhUm9Qp7bnZlm7k/ogHGgxH8ao4JD++QzsOsWp3AncWjfwDdjuX9b6u/jNnkaAGHXOXIzmYD4JqIN3Zu0gAxofrGhoRsgjjmNzDTuMylEehbIrRrgS9tFDpHv5cXkoRC6Qs2s+/Q98sYt9TJnUyieHWwRwieE=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142195; c=relaxed/simple;
	bh=pScjQtZGnL4N4URp9eQ6R1L1dFyMN50g0++HvtUueQY=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=gKm1wG9N0OF/J1PW2tTVGtjyOXtqu2x+6ubcWKNMs7BDlfddkGEhCE9CZrY8/FFoZNetDim7TRZej6dpxxQWZh510G7Aro0UiO5TygBeaisKZYuZAPbDI0fqxJ++Z86pXC3zNYjg63gD5FB5yqUDgqlQraviviGl0pnL4jmMTYI=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=BVFK27dY; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="BVFK27dY"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99A92C2BC86;
	Tue, 10 Mar 2026 11:29:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142195;
	bh=pScjQtZGnL4N4URp9eQ6R1L1dFyMN50g0++HvtUueQY=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=BVFK27dY6qeknQmKgjjKTiiu9ByyXIKEq5fUOX1ceANAnrb/ySjoZ1fxZsTO2BmBu
	 HvmzYeOAk8TmjPtnmb57Dn3wD/HgVrv5peQUGttKeD40n1oUuNG07c7vp7MHmvc0SD
	 8aK7rLkcP3JKn0p7A/82uXrFfhRR2u4wWH8c1ilZvCbONYTicdFSnbBV8rMTA6S12A
	 9EzrXdta0tCplCKv/yxQ1FdcTRz9DFCAI0Vojcx2JAJwayuwQGPuzQb7+u9uOnn3ef
	 2DUGKfbFIYM3b6AWIhnFPNau31cEgfh96WMAAnmqbqdo2SG7E52+7rWyJVgK044n6K
	 BHc09c3BXgqqQ==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: Jakub Kicinski <kuba@kernel.org>,
	Joe Damato <joe@dama.to>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 284/314] nfc: nci: free skb on nci_transceive early error paths
Date: Tue, 10 Mar 2026 07:19:03 -0400
Message-ID: <c37b1a42324bab3432783d60551453c25556673e.1773141555.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773141554.git.sashal@kernel.org>
References: <cover.1773141554.git.sashal@kernel.org>
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
X-stable: review
X-Patchwork-Hint: Ignore
Content-Transfer-Encoding: 8bit

From: Jakub Kicinski <kuba@kernel.org>

[ Upstream commit 7bd4b0c4779f978a6528c9b7937d2ca18e936e2c ]

nci_transceive() takes ownership of the skb passed by the caller,
but the -EPROTO, -EINVAL, and -EBUSY error paths return without
freeing it.

Due to issues clearing NCI_DATA_EXCHANGE fixed by subsequent changes
the nci/nci_dev selftest hits the error path occasionally in NIPA,
and kmemleak detects leaks:

unreferenced object 0xff11000015ce6a40 (size 640):
  comm "nci_dev", pid 3954, jiffies 4295441246
  hex dump (first 32 bytes):
    6b 6b 6b 6b 00 a4 00 0c 02 e1 03 6b 6b 6b 6b 6b  kkkk.......kkkkk
    6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b 6b  kkkkkkkkkkkkkkkk
  backtrace (crc 7c40cc2a):
    kmem_cache_alloc_node_noprof+0x492/0x630
    __alloc_skb+0x11e/0x5f0
    alloc_skb_with_frags+0xc6/0x8f0
    sock_alloc_send_pskb+0x326/0x3f0
    nfc_alloc_send_skb+0x94/0x1d0
    rawsock_sendmsg+0x162/0x4c0
    do_syscall_64+0x117/0xfc0

Fixes: 6a2968aaf50c ("NFC: basic NCI protocol implementation")
Reviewed-by: Joe Damato <joe@dama.to>
Link: https://patch.msgid.link/20260303162346.2071888-2-kuba@kernel.org
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/nfc/nci/core.c | 9 +++++++--
 1 file changed, 7 insertions(+), 2 deletions(-)

diff --git a/net/nfc/nci/core.c b/net/nfc/nci/core.c
index 46681bdaeabff..f6dc0a94b8d54 100644
--- a/net/nfc/nci/core.c
+++ b/net/nfc/nci/core.c
@@ -1035,18 +1035,23 @@ static int nci_transceive(struct nfc_dev *nfc_dev, struct nfc_target *target,
 	struct nci_conn_info *conn_info;
 
 	conn_info = ndev->rf_conn_info;
-	if (!conn_info)
+	if (!conn_info) {
+		kfree_skb(skb);
 		return -EPROTO;
+	}
 
 	pr_debug("target_idx %d, len %d\n", target->idx, skb->len);
 
 	if (!ndev->target_active_prot) {
 		pr_err("unable to exchange data, no active target\n");
+		kfree_skb(skb);
 		return -EINVAL;
 	}
 
-	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags))
+	if (test_and_set_bit(NCI_DATA_EXCHANGE, &ndev->flags)) {
+		kfree_skb(skb);
 		return -EBUSY;
+	}
 
 	/* store cb and context to be used on receiving data */
 	conn_info->data_exchange_cb = cb;
-- 
2.51.0

