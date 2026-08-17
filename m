Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F37341F5C1;
	Mon, 17 Aug 2026 13:41:11 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974076; cv=none; b=SNlQs4SOn925GyIDHBQvi9xcaaFNvD51xU5D/fvCBgShcTPJaDWGKAGRde1OBW86o25L/1HJ6HXt63Feo5/ZrmCHb+5l1ExBAv++Q2yR9ONKyjA0xm1ou1i937GBzc2LAPcTE0ZZFicQSIEZQCdZyU5KxW+SWs36zjIrRXFnG4o=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974076; c=relaxed/simple;
	bh=AfdHZJC/HNljHjIjq/1o0OuiYpb2DrnWNx8R7e9dr9A=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=t9+CoaOgtDjX4OiRz23e/T2UrMJyxkXVz6cQkc9qMht8VRrJEe817csB722/KU1rnf8hsH5nDyXDdS8SciakiRLAIEcX2rpThSZVwk+DvK0d2CaS78a61lvf+W5WiGgeAu1Y4IcHmj4sUXCQoRFsAXLb+jbnVkpnxDHRYYiZJQk=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=Lvok3AIO; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="Lvok3AIO"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8DC6E1F00A3E;
	Mon, 17 Aug 2026 13:41:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974069;
	bh=W0bdd7G/j53esqEkQCIwt2uZLxt5KUaQKQRmAusEnR0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=Lvok3AIOYUO34S//q3sx0BRNPjjeANjFopiAmW7cqK3sH0LSCRpK7fdH5IcP1UFVF
	 a44LKNTd67cQrAjyqjZzqEdPvEwA0CLaIFKFfAYMvsiDDDIAbP1uyRQOR2nkeHvLGV
	 vt/FqGLs6+6xG7BsOBsXt459w8xLocDN1l8CQO2A=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 7.1 076/271] xsk: move xsk_tx_metadata_request() to xdp_sock_drv.h
Date: Mon, 17 Aug 2026 15:30:01 +0200
Message-ID: <20260817132539.865993450@linuxfoundation.org>
X-Mailer: git-send-email 2.55.0
In-Reply-To: <20260817132536.752504388@linuxfoundation.org>
References: <20260817132536.752504388@linuxfoundation.org>
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

7.1-stable review patch.  If anyone has any objections, please let me know.

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
index 2b2eb9b9d580e..6e70b320b399f 100644
--- a/include/net/xdp_sock.h
+++ b/include/net/xdp_sock.h
@@ -153,43 +153,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
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
@@ -239,12 +202,6 @@ static inline void xsk_tx_metadata_to_compl(struct xsk_tx_metadata *meta,
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
index 68a7876013572..f87c4215673ed 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -271,6 +271,43 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
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
@@ -483,6 +520,12 @@ xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
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



