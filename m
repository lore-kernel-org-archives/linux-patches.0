Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5AE8E43F4A1;
	Mon, 17 Aug 2026 13:56:13 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974976; cv=none; b=BG9fzjrr1bPwIurE2hTVWgjwnGq//cTAzknJvOqi1jEwOQDP8ozQA/PZEGgbDk4aGw5RmPGuPz6ZrOVDenxjZv8tmFmyRdEmoOiFXCoE/xeTckpLUULpQEyxItETCLvzhmaIs8tBlv7p3VGbkeGG8fDUY9JdO3Oh2u/MQy2KQ1Q=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974976; c=relaxed/simple;
	bh=FriHCdxY5UrFTdmDRlTP5+yyeS8Q/iHFGIh3CpRRXgo=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=IwrNwr9INi1qqGH0Ss7QhzIey/iKBis5GlX5AF4zcu7h/NnO4ThSp8dO0RE1o+2zy9Hb2W7coo+vBCEi6xqS/QibD4eFeMBO8wHTmuBmczvbLXF0HSbd8Bm/zEr5rAKMQ6dFefF35XQ25HtOt8wsGHgdOpQI4beN0/Hl0wQqiHU=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=yZ0BwE6r; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="yZ0BwE6r"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1D2A51F000E9;
	Mon, 17 Aug 2026 13:56:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974972;
	bh=9lz/V3FDcAdrLkf1t1SzTPIqtM8fYG+o/m3sqHTfuqc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=yZ0BwE6r2HjR6CiNkXrKeNUD6BKbGN0AePwgbjpM0FwD1+wsenhnHeyL+9NbCZy4I
	 7NTIPmH0ilsNp4sfJPT1EM1wOTtXu9umh7ZLtYORpDJ/2ljWkMLPR+5kIDOaVz73vj
	 9EGORNEHVZCWXLfDH9iHGcoVjJ/lLCt1mBmB2eXo=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 069/250] xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
Date: Mon, 17 Aug 2026 15:30:30 +0200
Message-ID: <20260817132539.273389454@linuxfoundation.org>
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

[ Upstream commit ddd0d6c5bfe2fef7c7cf31f62265f29b7b9eb9ef ]

xsk_tx_metadata_request() must validate metadata with
xsk_buff_valid_tx_metadata(), which is defined in xdp_sock_drv.h. Move the
helper there before adding that dependency. All callers already include
the destination header, so this has no functional effect.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-6-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock.h     | 43 --------------------------------------
 include/net/xdp_sock_drv.h | 43 ++++++++++++++++++++++++++++++++++++++
 2 files changed, 43 insertions(+), 43 deletions(-)

diff --git a/include/net/xdp_sock.h b/include/net/xdp_sock.h
index e14e575178940..8bf17ba6c3bd7 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -152,43 +152,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 	compl->tx_timestamp = &meta->completion.tx_timestamp;
 }
 
-/**
- *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
- *  and call appropriate xsk_tx_metadata_ops operation.
- *  @pmeta: pointer to pointer to AF_XDP metadata area
- *  @ops: pointer to struct xsk_tx_metadata_ops
- *  @priv: pointer to driver-private aread
- *
- *  This function should be called by the networking device when
- *  it prepares AF_XDP egress packet.
- */
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
-{
-	const struct xsk_tx_metadata *meta = *pmeta;
-
-	if (!meta)
-		return;
-
-	if (ops->tmo_request_launch_time)
-		if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
-			ops->tmo_request_launch_time(meta->request.launch_time,
-						     priv);
-
-	if (ops->tmo_request_timestamp)
-		if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
-			ops->tmo_request_timestamp(priv);
-
-	if (ops->tmo_request_checksum)
-		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
-			ops->tmo_request_checksum(meta->request.csum_start,
-						  meta->request.csum_offset, priv);
-
-	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
-		*pmeta = NULL;
-}
-
 /**
  *  xsk_tx_metadata_complete - Evaluate AF_XDP TX metadata at completion
  *  and call appropriate xsk_tx_metadata_ops operation.
@@ -232,12 +195,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
 {
 }
 
-static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
-					   const struct xsk_tx_metadata_ops *ops,
-					   void *priv)
-{
-}
-
 static inline void xsk_tx_metadata_complete(struct xsk_tx_metadata_compl *compl,
 					    const struct xsk_tx_metadata_ops *ops,
 					    void *priv)
diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index ce8315f049684..6d4f65b0ed53a 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -267,6 +267,43 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 	return !(*flags & ~XDP_TXMD_FLAGS_VALID);
 }
 
+/**
+ *  xsk_tx_metadata_request - Evaluate AF_XDP TX metadata at submission
+ *  and call appropriate xsk_tx_metadata_ops operation.
+ *  @pmeta: pointer to pointer to AF_XDP metadata area
+ *  @ops: pointer to struct xsk_tx_metadata_ops
+ *  @priv: pointer to driver-private aread
+ *
+ *  This function should be called by the networking device when
+ *  it prepares AF_XDP egress packet.
+ */
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
+					   const struct xsk_tx_metadata_ops *ops,
+					   void *priv)
+{
+	const struct xsk_tx_metadata *meta = *pmeta;
+
+	if (!meta)
+		return;
+
+	if (ops->tmo_request_launch_time)
+		if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
+			ops->tmo_request_launch_time(meta->request.launch_time,
+						     priv);
+
+	if (ops->tmo_request_timestamp)
+		if (meta->flags & XDP_TXMD_FLAGS_TIMESTAMP)
+			ops->tmo_request_timestamp(priv);
+
+	if (ops->tmo_request_checksum)
+		if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM)
+			ops->tmo_request_checksum(meta->request.csum_start,
+						  meta->request.csum_offset, priv);
+
+	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+		*pmeta = NULL;
+}
+
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
@@ -479,6 +516,12 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
 	return false;
 }
 
+static inline void xsk_tx_metadata_request(struct xsk_tx_metadata **pmeta,
+					   const struct xsk_tx_metadata_ops *ops,
+					   void *priv)
+{
+}
+
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
-- 
2.53.0



