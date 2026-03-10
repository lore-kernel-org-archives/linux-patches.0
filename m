Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 15A2238A702;
	Tue, 10 Mar 2026 11:29:06 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=10.30.226.201
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1773142146; cv=none; b=M26t4vdrEuApdyLjHY+999Onu6KOI1mbzUS+9NmRyNf6/YR4S0FYfuVZj894ML2mmq4HzjRtOGiRzsc9whbLCnhCj1q9u7f4wFW9fHVBxwt3x1oUEZXXC5wO1u7g9GhQPFiopRRo8GDbYs2i2ouCu9pJ9PXnbwGw08mC/jMcekw=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1773142146; c=relaxed/simple;
	bh=fiysjw9yfFP1154ivtCcmN8zRw3y4rDpPQL8Ufc6ssg=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=XRlv3WqdwB+rCVknyqwrcRjJqy/DOupDexUhnX/NDbbpIXTsFIKSYeoVjdm7MdA6c2K4bZtBddS03vuRQUWBZLcClDRpp7IZgfSOw7QOwqjTH7TNVOp4quBraRKij5t5tsfC8f/jyAVc2MqQMZzsNzCPyyLdzWMC+7rh4B/59+Y=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b=E38SBiOJ; arc=none smtp.client-ip=10.30.226.201
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (2048-bit key) header.d=kernel.org header.i=@kernel.org header.b="E38SBiOJ"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3FC67C19423;
	Tue, 10 Mar 2026 11:29:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1773142146;
	bh=fiysjw9yfFP1154ivtCcmN8zRw3y4rDpPQL8Ufc6ssg=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References:From;
	b=E38SBiOJ1EDqZjBFDgXE1qgXBpmDE2dOYPoip8GA3hpDAQKh8v6yxNpGpFqqPnhMf
	 2EilhaED/MjLjLpg2myIyNLUU8SBc7nicSmOJLgcqoYTTSwlxAw+3ZvTZfXKC5TlGj
	 R7OyfJl4IDkjwbesBQjB8/E2x03KDiRtNQd2wwDoMWXtqMVYd+Jb5jjOkYZXlojGqR
	 rt0Tjh0HH8IFZWAIkLh2q9JxtoWlGNjmDh/rvA1iOGYuwz0PXGIanF2xMnteUTH71H
	 ZuHElw/uBecHDme9rq3mbVA4cGYUXORp638yAUP9TAeYV1x7wJzlo3SXni5shLN5kq
	 gRRmNu2v0DoKw==
From: Sasha Levin <sashal@kernel.org>
To: patches@lists.linux.dev,
	stable@vger.kernel.org
Cc: "Nikhil P. Rao" <nikhil.rao@amd.com>,
	Maciej Fijalkowski <maciej.fijalkowski@intel.com>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 233/314] xsk: Fix fragment node deletion to prevent buffer leak
Date: Tue, 10 Mar 2026 07:18:12 -0400
Message-ID: <9c73e41a1521c8e8660ab749ee9b4bc0c2a31fe7.1773141555.git.sashal@kernel.org>
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
index 4f2d3268a6769..99b6c3358e363 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -118,7 +118,7 @@ static inline void xsk_buff_free(struct xdp_buff *xdp)
 		goto out;
 
 	list_for_each_entry_safe(pos, tmp, xskb_list, list_node) {
-		list_del(&pos->list_node);
+		list_del_init(&pos->list_node);
 		xp_free(pos);
 	}
 
@@ -153,7 +153,7 @@ static inline struct xdp_buff *xsk_buff_get_frag(const struct xdp_buff *first)
 	frag = list_first_entry_or_null(&xskb->pool->xskb_list,
 					struct xdp_buff_xsk, list_node);
 	if (frag) {
-		list_del(&frag->list_node);
+		list_del_init(&frag->list_node);
 		ret = &frag->xdp;
 	}
 
@@ -164,7 +164,7 @@ static inline void xsk_buff_del_frag(struct xdp_buff *xdp)
 {
 	struct xdp_buff_xsk *xskb = container_of(xdp, struct xdp_buff_xsk, xdp);
 
-	list_del(&xskb->list_node);
+	list_del_init(&xskb->list_node);
 }
 
 static inline struct xdp_buff *xsk_buff_get_head(struct xdp_buff *first)
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 69bbcca8ac753..0d3fc72147f84 100644
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

