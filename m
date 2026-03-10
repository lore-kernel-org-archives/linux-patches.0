Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7D3AA38737C;
	Tue, 10 Mar 2026 11:13:31 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141211; cv=none; b=sYCZgE7m7ZUazYagW1579v4N8/1UStTmd32sJP4uLJ/HY7huRg+iDwuMqdyf191ijHgubnfB5/4QOiabOtYvK97H4zM0Jy5kta+TqR27B9xI88ORux9ZS8bfkUPe4rmm82weNF5Zf0xfLEpbEjjT1OFPovPCr0kDs1bRb/S5too=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141211; c=relaxed/simple;
	bh=nBISOALUopwCtT7xCJ5XlzvY5mgeLbIaOjTP3SeVhkI=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=k6uT8UDEaNkbNpsNOWmuRx+xyqiKAwdEyWLRiorQ8wgxFw1wz93EFkL7D9rxHH7Nm6qYl6W3X+Y6piRj26opy1GdQ8uEf7wlSZfD87JyHRAnlw9GpicpD66PbxpYVgZf821iPiN3s+UDg/8BRWRY9FZODa4Qwb0bRHEdmxrktV8=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=WflaN4+j; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="WflaN4+j"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id C5385C2BC86;
	Tue, 10 Mar 2026 11:13:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141211;
	bh=nBISOALUopwCtT7xCJ5XlzvY5mgeLbIaOjTP3SeVhkI=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=WflaN4+j6hwHy2yIuaIXHU4B6r7mHbj6HftdZ2tdtg0rmQk5Gee/PfZYuPh1smwgy
	 dHM/Zsn5QLBNGX7JavcLQZF4GabVho/sA70R4BZEu2ErBvT1Yamh86VPhjvJCyocfr
	 lEdo1/VKrWi77U3HqTQVRi5YSqaBnyK9CNUjJ4H7xKO5HmMJTimYq/zI675xfBwQ4e
	 X24FjogyDrrEfWOwC1Gjoq+obUbmgDDe3qc1leSx1utqLjpGzGzE4+NBJbjV3BcUZt
	 z8Gz1UGouFsIceka6GYLU17YTpok1xeH7E4g3MntsEgwhQ2KUtwofuV2VFV8DxS8Ik
	 reKly45o7z3+g==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 212/311] xsk: Fix zero-copy AF_XDP fragment drop
Date: Tue, 10 Mar 2026 07:04:19 -0400
Message-ID: <3d0181a26fe2238988009ebcc2a1b57a9450eb30.1773140655.git.sashal@kernel.org>
X-Mailer: git-send-email 2.51.0
In-Reply-To: <cover.1773140654.git.sashal@kernel.org>
References: <cover.1773140654.git.sashal@kernel.org>
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
index f2ec4f78bbb6a..a6d3938154f21 100644
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

