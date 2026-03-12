Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D76E72D0606;
	Thu, 12 Mar 2026 20:24:34 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347074; cv=none; b=G1o/z29k4PVE00JIDE8xQNer9d9N1E+/HTM+lD9ff25UtxoIkU00EdIibjifwdAiiJesyojZZnYfVdh5bjab9tVU/ShQtjJT2DKTP3QKg6S9KDkvgtFY9pHv90+XRi21J57gvHhwEM3BVEx8kfi/pMmvdiYi59BCoKiFB+LK/W4=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347074; c=relaxed/simple;
	bh=T9kEJNonYVDLJr/jYYgITPEukiPgXL6MSqAFcXHLgFk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=YUQnb/GvMXpx2tGukiItlY4AGXiKJrElu7aqdvh2ec1frMEB2Ddqh5soCSPgaS2MeaWOlQbqYOMTIO84whI+ANn7xl0zVosYFjRx+3B8RtvnwdXHVFL5Ynv/9R5m1hOTI/A0RLXs3dD5GJ/0u2qCcp0nFa3Fh9UpsPIalK4mp9s=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=O0BM+1RH; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="O0BM+1RH"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3415EC4CEF7;
	Thu, 12 Mar 2026 20:24:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347074;
	bh=T9kEJNonYVDLJr/jYYgITPEukiPgXL6MSqAFcXHLgFk=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=O0BM+1RHjbyFHlu2oYfuPRJJcJ33WAB6jM7wyXZgFvEkFO1EhUO3AzNy5VG+F4xuY
	 qBb8lz+M4+PvEkLjpaGyZLPfsKu6OBngoVgb2BE74F4harc8pmJ57xBp9eewRnK2SZ
	 S34SvK2OBVqjCmyQ7qnBH46RJt4VtNK2o3XZsiNo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 188/265] xsk: Fix zero-copy AF_XDP fragment drop
Date: Thu, 12 Mar 2026 21:09:35 +0100
Message-ID: <20260312201025.104015013@linuxfoundation.org>
X-Mailer: git-send-email 2.53.0
In-Reply-To: <20260312201018.128816016@linuxfoundation.org>
References: <20260312201018.128816016@linuxfoundation.org>
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

6.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Nikhil P. Rao <nikhil.rao@amd.com>

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
index 158c92918bc3a..ed1aeaded9be7 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -159,25 +159,31 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
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



