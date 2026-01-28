Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 006D52C237E;
	Wed, 28 Jan 2026 15:35:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1769614532; cv=none; b=AJoFm02mgL1gUVG9q1XjTaOY2W6f83ckiya7AeUzZvVbFECjq4yWL+xuHJNvPoIIPE0T3QViAOBmf04gxwBZtRdglgTnRG0xuMGM/ZY/16gT2HDxtfv+sQEt9RLqmTspwDLq092JpOo/yvemL7ZvKx12PL0FFVOaYUw4PKxVghs=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1769614532; c=relaxed/simple;
	bh=b1SDx0XIz5q507UOiaEmw9CTaoajF3UUtbkAinl8XyE=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XU1HR982BZS2Nyqf3zOYMp3V6J5IF0Q6cPDsCxSCaeZDyK7JDc+1+bJvpdnMtoAJmfqx7sjX/5oWykbQnFb+yIBD8EYvYgJIXfd4JXKP+GBtdRwDswRya+V0vDHW9bn+1xpnTeBGa2bVS9B4zz+9QwPgSDJ3MfI38Vx/O4xfYsg=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=VYJXCMt2; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="VYJXCMt2"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 60BD2C4CEF7;
	Wed, 28 Jan 2026 15:35:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1769614531;
	bh=b1SDx0XIz5q507UOiaEmw9CTaoajF3UUtbkAinl8XyE=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=VYJXCMt2K3Rc9At9Ai6167oyLpqMukuhEs7iRiybZgULefNhpqqVz8HEWhIDQ8nqL
	 zwWXwlWukd0M6r9nl3IL78g5qNSVmU0cXhbLYGM92DIv+MnoUAxP0wbDTpgUB9rE5f
	 +rG8X6yJhn9vdFsjnzL7uOCmqAuosXtWQjn7Hl1o=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	David Yang <mmyangfl@gmail.com>,
	Vadim Fedorenko <vadim.fedorenko@linux.dev>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.6 165/254] be2net: fix data race in be_get_new_eqd
Date: Wed, 28 Jan 2026 16:22:21 +0100
Message-ID: <20260128145350.746924132@linuxfoundation.org>
X-Mailer: git-send-email 2.52.0
In-Reply-To: <20260128145344.698118637@linuxfoundation.org>
References: <20260128145344.698118637@linuxfoundation.org>
User-Agent: quilt/0.69
X-stable: review
X-Patchwork-Hint: ignore
Precedence: bulk
X-Mailing-List: patches@lists.linux.dev
List-Id: <patches.lists.linux.dev>
List-Subscribe: <mailto:patches+subscribe@lists.linux.dev>
List-Unsubscribe: <mailto:patches+unsubscribe@lists.linux.dev>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit

6.6-stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Yang <mmyangfl@gmail.com>

[ Upstream commit 302e5b481caa7b3d11ec0e058434c1fc95195e50 ]

In be_get_new_eqd(), statistics of pkts, protected by u64_stats_sync, are
read and accumulated in ignorance of possible u64_stats_fetch_retry()
events. Before the commit in question, these statistics were retrieved
one by one directly from queues. Fix this by reading them into temporary
variables first.

Fixes: 209477704187 ("be2net: set interrupt moderation for Skyhawk-R using EQ-DB")
Signed-off-by: David Yang <mmyangfl@gmail.com>
Reviewed-by: Vadim Fedorenko <vadim.fedorenko@linux.dev>
Link: https://patch.msgid.link/20260119153440.1440578-1-mmyangfl@gmail.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 drivers/net/ethernet/emulex/benet/be_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/emulex/benet/be_main.c b/drivers/net/ethernet/emulex/benet/be_main.c
index 011c8cc8429e3..2ed1e290f9d78 100644
--- a/drivers/net/ethernet/emulex/benet/be_main.c
+++ b/drivers/net/ethernet/emulex/benet/be_main.c
@@ -2141,7 +2141,7 @@ static int be_get_new_eqd(struct be_eq_obj *eqo)
 	struct be_aic_obj *aic;
 	struct be_rx_obj *rxo;
 	struct be_tx_obj *txo;
-	u64 rx_pkts = 0, tx_pkts = 0;
+	u64 rx_pkts = 0, tx_pkts = 0, pkts;
 	ulong now;
 	u32 pps, delta;
 	int i;
@@ -2157,15 +2157,17 @@ static int be_get_new_eqd(struct be_eq_obj *eqo)
 	for_all_rx_queues_on_eq(adapter, eqo, rxo, i) {
 		do {
 			start = u64_stats_fetch_begin(&rxo->stats.sync);
-			rx_pkts += rxo->stats.rx_pkts;
+			pkts = rxo->stats.rx_pkts;
 		} while (u64_stats_fetch_retry(&rxo->stats.sync, start));
+		rx_pkts += pkts;
 	}
 
 	for_all_tx_queues_on_eq(adapter, eqo, txo, i) {
 		do {
 			start = u64_stats_fetch_begin(&txo->stats.sync);
-			tx_pkts += txo->stats.tx_reqs;
+			pkts = txo->stats.tx_reqs;
 		} while (u64_stats_fetch_retry(&txo->stats.sync, start));
+		tx_pkts += pkts;
 	}
 
 	/* Skip, if wrapped around or first calculation */
-- 
2.51.0



