Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A130C3859DF;
	Tue, 10 Mar 2026 11:13:30 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773141210; cv=none; b=XhXZ09XXkzmY3TQHN8+O/Dg7Zl5GEh21dB/a1PDOcYZKCldSrwqSxlrL6wx0E+nP4f3EUSXs8Fr7tWi1Hew8uGdYvE4IBDb127+8IRbmxI6c/oqxJR+UCvTtbtm+X8i4oNvZCaH2cng2R0hoXfSUMxV+bTHx7YE6SDeitRBlJx0=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773141210; c=relaxed/simple;
	bh=rydZbUZuIz2TCpzRAlZCzhwj0onXIsxgAqeuENW7aXA=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XpNeDw6BqwgPiAydEwfC5Oo4Zep1XMldWl2pOX/PWXhY+/hCynKio3+3w76tAXD1cWwpNYcrpU40f3JZwqpi8yNEtxAWhW4WdPF/nDK2eVOPCE+DYyDet/wO2YnJI7OuShK2N9p6jPlz7o4e5ftGBxqBXB3FFazDhvuHGcfmNo4=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=f/qSs0Aa; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="f/qSs0Aa"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D91BEC19423;
	Tue, 10 Mar 2026 11:13:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773141210;
	bh=rydZbUZuIz2TCpzRAlZCzhwj0onXIsxgAqeuENW7aXA=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=f/qSs0Aaa/H1Q3487C+TDGlwkCrc8UTHL871Bo3G1EU5sXXRtxfUp2DqIrKlUhjqx
	 QtALZQPFAxcvhibmvFaFaC4IAvslNj4PrmKSpyPLnxBXapE73e8bF/4K2Ey7UtWs5h
	 IkhN9cW6a3KZgjRfLOZA0sOq3MDhrFVDjNCozhzvwohYnT25MuRXFjb0cKjvvlgxzG
	 vFC86/vpb5q3S/CV4dQoaY46/vDJBvR55HYj2L64ArEpyiafou/R2czI77chLZ6Fjy
	 SVWU17BTbq8UtzXZapnjld8YfRAS1Yp1g9CIMhujioGMNWJmFM6PezfG+vcKlerMXH
	 QFukoF6O63j6Q==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Nikhil P. Rao" <nikhil.rao@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.19 211/311] xsk: Fix fragment node deletion to prevent buffer leak
Date: Tue, 10 Mar 2026 07:04:18 -0400
Message-ID: <9a133c67c946144140e924d2480642210a379ecb.1773140655.git.sashal@kernel.org>
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

[ Upstream commit 60abb0ac11dccd6b98fd9182bc5f85b621688861 ]

After commit b692bf9a7543 ("xsk: Get rid of xdp_buff_xsk::xskb_list_node"),
the list_node field is reused for both the xskb pool list and the buffer
free list, this causes a buffer leak as described below.

xp_free() checks if a buffer is already on the free list using
list_empty(&xskb->list_node). When list_del() is used to remove a node
from the xskb pool list, it doesn't reinitialize the node pointers.
This means list_empty() will return false even after the node has been
removed, causing xp_free() to incorrectly skip adding the buffer to the
free list.

Fix this by using list_del_init() instead of list_del() in all fragment
handling paths, this ensures the list node is reinitialized after removal,
allowing the list_empty() to work correctly.

Fixes: b692bf9a7543 ("xsk: Get rid of xdp_buff_xsk::xskb_list_node")
Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Signed-off-by: Nikhil P. Rao <nikhil.rao@amd.com>
Link: https://patch.msgid.link/20260225000456.107806-2-nikhil.rao@amd.com
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 6 +++---
 net/xdp/xsk.c              | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 242e34f771cca..aefc368449d59 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -122,7 +122,7 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 		goto out;
 
 	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
-		list_del(&pos->list_node);
+		list_del_init(&pos->list_node);
 		xp_free(pos);
 	}
 
@@ -157,7 +157,7 @@ static inline struct xdp_buff *xsk_buff_get_frag(const struct xdp_buff *first)
 	frag = list_first_entry_or_null(&xskb->pool->xskb_list,
 					struct xdp_buff_xsk, list_node);
 	if (frag) {
-		list_del(&frag->list_node);
+		list_del_init(&frag->list_node);
 		ret = &frag->xdp;
 	}
 
@@ -168,7 +168,7 @@ static inline void xsk_buff_del_frag(struct xdp_buff *xdp)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
 
-	list_del(&xskb->list_node);
+	list_del_init(&xskb->list_node);
 }
 
 static inline struct xdp_buff *xsk_buff_get_head(struct xdp_buff *first)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index f093c3453f64c..f2ec4f78bbb6a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -186,7 +186,7 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		err = __xsk_rcv_zc(xs, pos, len, contd);
 		if (err)
 			goto err;
-		list_del(&pos->list_node);
+		list_del_init(&pos->list_node);
 	}
 
 	return 0;
-- 
2.51.0

