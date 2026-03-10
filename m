Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0217E41C30F;
	Tue, 10 Mar 2026 11:29:07 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142147; cv=none; b=P9qkgcXua46tuMq9QzRv01PsdW7CzmZcBw5NO8eRbY82Q6z0CzNp3HEi8eWtIKIY+6OWbKotDtN2U7i6Mkpen94rww5DbQw6DuwXzg0n4A4542BoiCJwVGUdA+98hBmliaPLwJ5tuKOAE+7tl2l3NnCG06l0eN40/E9QO8qhg8s=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142147; c=relaxed/simple;
	bh=ob6Cf0HstpdOyCuh+DOvwWOA5pDnN7RxmLJBwQeWZuo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=TPFL8LFKG4Dj3oawfSrwbP1CTaB9ChSnqjgBC23NRI5BX/Z8Z7S2wQaLhzAPFru/WewoZNRxTuAy4uBIw+lzD/kHHXvpaMx8zPW+J7JvPa1PwNO0KenZchDJdpWlsaNFhGgXrciEE1cI3stYLKRBqsjPHcNvzo21howpRylMZ9o=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=SnpBR0Q+; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="SnpBR0Q+"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3EAFCC2BCAF;
	Tue, 10 Mar 2026 11:29:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142146;
	bh=ob6Cf0HstpdOyCuh+DOvwWOA5pDnN7RxmLJBwQeWZuo=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=SnpBR0Q+mW/7eFpKwa0LoIdhX/Xv77TBd7C25NoKUmpbprZStzzSTT+824E84MCD9
	 83HIu27GWQJkVLUrdI2T6IWcllkCoTEzU7g2PIYvrUXvuA1tJtJq02q0wR3PLOOiWj
	 fsnH0WLCYDMBNuqUVNiUm7seXbelu10iAlzvNkuHFaLlWJi9LVqN9mBfRNPitr6szK
	 2q/VqXSFfdioHpIpxMqo3S1rseKtMUUD4uFyN7BUSLg4Nc5+gzShGbBQH8hmFfJi9f
	 7GmfFhToBPxk1/dTNMh8glxqpQxhGL9fyzCFTFn32pb9s4AdjGjsTsCfGC0mxH5qCw
	 eiFTmPxwWsySA==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 234/314] xsk: Fix zero-copy AF_XDP fragment drop
Date: Tue, 10 Mar 2026 07:18:13 -0400
Message-ID: <e7506f99881fe2e053f13f93d5bea6f45149ce7e.1773141555.git.sashal@kernel.org>
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

From: "Nikhil P. Rao" <nikhil.rao@amd.com>

[ Upstream commit f7387d6579d65efd490a864254101cb665f2e7a7 ]

AF_XDP should ensure that only a complete packet is sent to application.
In the zero-copy case, if the Rx queue gets full as fragments are being
enqueued, the remaining fragments are dropped.

For the multi-buffer case, add a check to ensure that the Rx queue has
enough space for all fragments of a packet before starting to enqueue
them.

Fixes: 24ea50127ecf ("xsk: support mbuf on ZC RX")
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260225000456.107806-3-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 net/xdp/xsk.c | 24 +++++++++++++++---------
 1 file changed, 15 insertions(+), 9 deletions(-)

diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 0d3fc72147f84..a78cdc3356937 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -167,25 +167,31 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 	struct xdp_buff_xsk *pos, *tmp;
 	struct list_head *xskb_list;
 	u32 contd = 0;
+	u32 num_desc;
 	int err;
 
-	if (frags)
-		contd = XDP_PKT_CONTD;
+	if (likely(!frags)) {
+		err = __xsk_rcv_zc(xs, xskb, len, contd);
+		if (err)
+			goto err;
+		return 0;
+	}
 
-	err = __xsk_rcv_zc(xs, xskb, len, contd);
-	if (err)
+	contd = XDP_PKT_CONTD;
+	num_desc = xdp_get_shared_info_from_buff(xdp)->nr_frags + 1;
+	if (xskq_prod_nb_free(xs->rx, num_desc) < num_desc) {
+		xs->rx_queue_full++;
+		err = -ENOBUFS;
 		goto err;
-	if (likely(!frags))
-		return 0;
+	}
 
+	__xsk_rcv_zc(xs, xskb, len, contd);
 	xskb_list = &xskb->pool->xskb_list;
 	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
 		if (list_is_singular(xskb_list))
 			contd = 0;
 		len = pos->xdp.data_end - pos->xdp.data;
-		err = __xsk_rcv_zc(xs, pos, len, contd);
-		if (err)
-			goto err;
+		__xsk_rcv_zc(xs, pos, len, contd);
 		list_del_init(&pos->list_node);
 	}
 
-- 
2.51.0

