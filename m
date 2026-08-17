Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 31F2E3D0903;
	Mon, 17 Aug 2026 13:53:52 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974840; cv=none; b=GJp3byr6n31g0IpPFgsJInQRHIZcX/TeVRCYlUxE0ac+zEdKBhOv1k9lIZ301aj+YIhX5iWZuu9IY6Ht4qh21ckOwyHMFXY4/bmubG7olmmRUmqH6TmWh/keXiqmWQrUDurjRCN1Z6G7hhqZH2d3M8aLUp6Q+rr999v2x1nv+SI=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974840; c=relaxed/simple;
	bh=211O0hO0G9YBppwDQjwxJAOuguLyYrfKvmEOSZy0JHk=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=b/5LB5DWjOXyORZcfbsMUaLNwE6LPbaowDDqYJueVWrAqOxHe+G3jI7kB+ohv6XEzmIEGHPqA7jXnd9eDA3saNPHX+/NdQFAUv7IiX4Mk2soOSGb35OOoa0NvA0JcZIO9xIY8CrnEFjue0uWnuDQdwJEgwOORNebZoomPfNkbic=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=H8AVKKWm; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="H8AVKKWm"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D3D791F00A3D;
	Mon, 17 Aug 2026 13:53:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974830;
	bh=+XM/upzEnZ1x6qw7D3IrUCYRN+Ppczu0A3kuwm++p0k=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=H8AVKKWmO7Np6IFgX8cTDUE0p7OHP86LFgeN3WxM4Bb5ohqpFdUCZbu/NjGc4XwCz
	 bKAv6EkGkn1oSCiXN/11xYQIw+214tVZmO2C/EP1YiDra6jFTssoI+48gOSKtekzlx
	 dUKB8Pvn86VZO/24JHb2fAfOayFmxk6BHTK5nadc=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 067/250] xsk: clear metadata pointer when no timestamp is requested
Date: Mon, 17 Aug 2026 15:30:28 +0200
Message-ID: <20260817132539.189477901@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.466235697@linuxfoundation.org>
References: <20260817132536.466235697@linuxfoundation.org>
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

6.18-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Stanislav Fomichev <sdf.kernel@gmail.com>

[ Upstream commit 9f60a67df8d3c862503bee62bada8e7089cba438 ]

User space can change metadata flags after request processing. Rereading
them during completion can therefore make the kernel write a timestamp
that was not requested when the packet was submitted.

Clear the metadata pointer during request processing unless timestamp
completion is requested. Completion handling can then use the pointer
itself instead of rereading the flags.

On the mlx5 multi-packet WQE path metadata is evaluated per batch:
xsk_tx_metadata_request() runs only for the descriptor that starts a
session, just like the checksum offload that is applied once through the
shared WQE. Only that descriptor's pointer is reset, so completion
handling can record a timestamp for the other descriptors of the session
regardless of their own XDP_TXMD_FLAGS_TIMESTAMP bit. The write stays
inside the metadata area; the single-WQE, other zero-copy, and generic
paths reset the pointer per descriptor and are unaffected.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-4-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h | 14 ++++++++++----
 net/xdp/xsk.c          |  2 ++
 2 files changed, 12 insertions(+), 4 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index b93d6bd368d00..e14e575178940 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -140,13 +140,16 @@ void __xsk_map_flush(struct list_head *flush_list);
 static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 					    struct xsk_tx_metadata_compl *compl)
 {
+	compl->tx_timestamp = NULL;
+
 	if (!meta)
 		return;
 
-	if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
-		compl->tx_timestamp = &meta->completion.tx_timestamp;
-	else
-		compl->tx_timestamp = NULL;
+	/* we can only arrive here if the completion timestamp has been
+	 * requested via XDP_TXMD_FLAGS_TIMESTAMP, see xsk_tx_metadata_request
+	 */
+
+	compl->tx_timestamp = &meta->completion.tx_timestamp;
 }
 
 /**
@@ -181,6 +184,9 @@ static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
 		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
 			ops->tmo_request_checksum(meta->request.csum_start,
 						  meta->request.csum_offset, priv);
+
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		*pmeta = NULL;
 }
 
 /**
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 70c57c5d8e1da..3b82fb850bee3 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -730,6 +730,8 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 
 	if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
 		skb->skb_mstamp_ns = meta->request.launch_time;
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		meta = NULL;
 	xsk_tx_metadata_to_compl(meta, &skb_shinfo(skb)->xsk_meta);
 
 	return 0;
-- 
2.53.0



