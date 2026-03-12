Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 2249826F288;
	Thu, 12 Mar 2026 20:26:35 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773347195; cv=none; b=IL7XiGaHjHQAI6gZ2ARME/ukGAP+TOa8VzK2aQA8BZAuXRX2L0lEW2w0S2qYKa9WLgHKWImy5bKPe/xGoqDH9UxXsbdMHPeiaxdrLVLC2KIzj2OqzMk1MZPXdHpscvMYAojk0Dyr/rE54ijCpD60/iAPeeC71LJiw7o3BdJlrSY=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773347195; c=relaxed/simple;
	bh=t9mgYqf692Dugm/QAqnzWct0QKB59PJBWbS0NGKKW4o=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=oKerrLhxrbe3L7bVE1coUr6Zg3yTY1PdpLM30buiTQUJKP3CAgDVb4b9CfncW2Vilbf4wxCPC63PnNuYALjWwnqru4H3EbxQYGaIofY6v8kki0NdaLf34rrC8VP7CNjm1W2UU0c1Vxo7FwdlUDqJ52RPxHKkiZfDnp46FMOjTfU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=d4a+zB6U; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="d4a+zB6U"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47AD1C4CEF7;
	Thu, 12 Mar 2026 20:26:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
	s=korg; t=1773347195;
	bh=t9mgYqf692Dugm/QAqnzWct0QKB59PJBWbS0NGKKW4o=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=d4a+zB6U8S9qUnRBVRgmv50tly8PVwROv543xpp6U0BEMgguin8uO5pcpqlunhV/E
	 xr0rsRtwjMM2q77HjwLj7gv4+zZswAamaqRuURTvygcQx1AcFj6izgv/02Sz7ZH9R8
	 kuDb5aSRQmAVHtcZ2UJuhiI4BEf0XCoTy3dS2Jqk=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	"Nikhil P. Rao" <nikhil.rao@amd.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.12 187/265] xsk: Fix fragment node deletion to prevent buffer leak
Date: Thu, 12 Mar 2026 21:09:34 +0100
Message-ID: <20260312201025.068111189@linuxfoundation.org>
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
Stable-dep-of: f7387d6579d6 ("xsk: Fix zero-copy AF_XDP fragment drop")
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 6 +++---
 net/xdp/xsk.c              | 2 +-
 2 files changed, 4 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index 40085afd91607..27d0068d0b704 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -127,7 +127,7 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 		goto out;
 
 	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
-		list_del(&pos->list_node);
+		list_del_init(&pos->list_node);
 		xp_free(pos);
 	}
 
@@ -152,7 +152,7 @@ static inline struct xdp_buff *xsk_buff_get_frag(struct xdp_buff *first)
 	frag = list_first_entry_or_null(&xskb->pool->xskb_list,
 					struct xdp_buff_xsk, list_node);
 	if (frag) {
-		list_del(&frag->list_node);
+		list_del_init(&frag->list_node);
 		ret = &frag->xdp;
 	}
 
@@ -163,7 +163,7 @@ static inline void xsk_buff_del_tail(struct xdp_buff *tail)
 {
 	struct xdp_buff_xsk *xskb = container_of(tail, struct xdp_buff_xsk, xdp);
 
-	list_del(&xskb->list_node);
+	list_del_init(&xskb->list_node);
 }
 
 static inline struct xdp_buff *xsk_buff_get_tail(struct xdp_buff *first)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index bbf45b68dbf5c..158c92918bc3a 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -178,7 +178,7 @@ static int xsk_rcv_zc(struct xdp_sock *xs, struct xdp_buff *xdp, u32 len)
 		err = __xsk_rcv_zc(xs, pos, len, contd);
 		if (err)
 			goto err;
-		list_del(&pos->list_node);
+		list_del_init(&pos->list_node);
 	}
 
 	return 0;
-- 
2.51.0



