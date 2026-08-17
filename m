Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 834C53DB964;
	Mon, 17 Aug 2026 13:53:55 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1786974840; cv=none; b=h4pRTpNihlQyynj2a4XtGywq+5lvPI2tCnAdh2uGBVacTfli7Z5d5XIofSmUWoFUupWC7tr8QSdkMvdsa+QtycJvtv/BIY3BT9S1TXp7fHrwFpNq/7yg10e7Mm0GygglI6Z7eI16rnHJAR1xxAD9Tq0124oZn/6ej+7UFSJr4Jk=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1786974840; c=relaxed/simple;
	bh=zXKIp8edvkhtHkLu7P8mI+SHAbUqUFR+HfixJSBRLLw=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=VveXyF+kycRH4QI4zuD5+xWHFu5LjFLOi7gfO7U9LxxY2rKxUlJBHPs86bHczptthOP8f21WxZE2QVWqQrIgNiv9hkVfT3wyHMHM7hSqMEmRwsSN8pg1BKCT5ndG7i1ooA+loIgF2kE3eM4ZtyNK6MWRoUBijuiJneuEPY+PPY0=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=seWLunuK; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="seWLunuK"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B52051F000E9;
	Mon, 17 Aug 2026 13:53:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1786974833;
	bh=tCMpRvm9hf0+hG9gVTtXiikoZlHVM73m703WOly2uRc=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=seWLunuKMYz5RFIJffT9yoZ2tGgfzugArRcG2FD0e1guRzI/LznS6Dsn93pGOyFWo
	 omWS2S+cOV/7CCwyNLsr/alHaZmHlEgNvKs4NfnKZDlbJ2opTNuicnd75PyJJgS/oW
	 d8iKueHvJFSdiY24NH6n6U0bIpdDnYjpKbc9lJeE=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	"Cen Zhang (Microsoft)" <blbllhy@gmail.com>,
	Stanislav Fomichev <sdf@fomichev.me>,
	Jakub Kicinski <kuba@kernel.org>,
	Sasha Levin <sashal@kernel.org>
Subject: [PATCH 6.18 068/250] xsk: validate launch-time metadata size
Date: Mon, 17 Aug 2026 15:30:29 +0200
Message-ID: <20260817132539.229774781@linuxfoundation.org>
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

[ Upstream commit 439ce2dddf3d22129b9113a7881637256a35e936 ]

Launch-time metadata extends beyond the first 16 bytes of struct
xsk_tx_metadata. Reject the request when the registered metadata area does
not contain the complete field.

Snapshot the validated flags for the generic transmit path and use that
snapshot for request and completion processing, avoiding inconsistent
decisions if user space changes the flags concurrently.

Note that only xsk_skb_metadata is properly using the flags,
__xsk_buff_get_metadata ignores them. Next commits address that.

Fixes: ca4419f15abd ("xsk: Add launch time hardware offload support to XDP Tx metadata")
Cc: Cen Zhang (Microsoft) <blbllhy@gmail.com>
Signed-off-by: Stanislav Fomichev <sdf@fomichev.me>
Link: https://patch.msgid.link/20260727161959.885642-5-sdf@fomichev.me
Signed-off-by: Jakub Kicinski <kuba@kernel.org>
Signed-off-by: Sasha Levin <sashal@kernel.org>
---
 include/net/xdp_sock_drv.h | 17 +++++++++++++----
 net/xdp/xsk.c              | 11 ++++++-----
 2 files changed, 19 insertions(+), 9 deletions(-)

diff --git a/include/net/xdp_sock_drv.h b/include/net/xdp_sock_drv.h
index dd1d3a6e1b780..ce8315f049684 100644
--- a/include/net/xdp_sock_drv.h
+++ b/include/net/xdp_sock_drv.h
@@ -256,21 +256,28 @@ xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
 	0)
 
 static inline bool
-xsk_buff_valid_tx_metadata(const struct xsk_tx_metadata *meta)
+xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
+			   const struct xsk_tx_metadata *meta, u64 *flags)
 {
-	return !(meta->flags & ~XDP_TXMD_FLAGS_VALID);
+	*flags = READ_ONCE(meta->flags);
+	if (*flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
+		if (pool->tx_metadata_len <
+		    offsetofend(struct xsk_tx_metadata, request.launch_time))
+			return false;
+	return !(*flags & ~XDP_TXMD_FLAGS_VALID);
 }
 
 static inline struct xsk_tx_metadata *
 __xsk_buff_get_metadata(const struct xsk_buff_pool *pool, void *data)
 {
 	struct xsk_tx_metadata *meta;
+	u64 flags;
 
 	if (!pool->tx_metadata_len)
 		return NULL;
 
 	meta = data - pool->tx_metadata_len;
-	if (unlikely(!xsk_buff_valid_tx_metadata(meta)))
+	if (unlikely(!xsk_buff_valid_tx_metadata(pool, meta, &flags)))
 		return NULL; /* no way to signal the error to the user */
 
 	return meta;
@@ -465,7 +472,9 @@ xsk_buff_raw_get_ctx(const struct xsk_buff_pool *pool, u64 addr)
 	return (struct xdp_desc_ctx){ };
 }
 
-static inline bool xsk_buff_valid_tx_metadata(struct xsk_tx_metadata *meta)
+static inline bool
+xsk_buff_valid_tx_metadata(const struct xsk_buff_pool *pool,
+			   const struct xsk_tx_metadata *meta, u64 *flags)
 {
 	return false;
 }
diff --git a/net/xdp/xsk.c b/net/xdp/xsk.c
index 3b82fb850bee3..ff93fd7ac6317 100644
--- a/net/xdp/xsk.c
+++ b/net/xdp/xsk.c
@@ -699,15 +699,16 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 {
 	struct xsk_tx_metadata *meta = NULL;
 	u16 csum_start, csum_offset;
+	u64 flags;
 
 	if (unlikely(pool->tx_metadata_len == 0))
 		return -EINVAL;
 
 	meta = buffer - pool->tx_metadata_len;
-	if (unlikely(!xsk_buff_valid_tx_metadata(meta)))
+	if (unlikely(!xsk_buff_valid_tx_metadata(pool, meta, &flags)))
 		return -EINVAL;
 
-	if (meta->flags & XDP_TXMD_FLAGS_CHECKSUM) {
+	if (flags & XDP_TXMD_FLAGS_CHECKSUM) {
 		csum_start = READ_ONCE(meta->request.csum_start);
 		csum_offset = READ_ONCE(meta->request.csum_offset);
 
@@ -728,9 +729,9 @@ static int xsk_skb_metadata(struct sk_buff *skb, void *buffer,
 		}
 	}
 
-	if (meta->flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
-		skb->skb_mstamp_ns = meta->request.launch_time;
-	if (!(meta->flags & XDP_TXMD_FLAGS_TIMESTAMP))
+	if (flags & XDP_TXMD_FLAGS_LAUNCH_TIME)
+		skb->skb_mstamp_ns = READ_ONCE(meta->request.launch_time);
+	if (!(flags & XDP_TXMD_FLAGS_TIMESTAMP))
 		meta = NULL;
 	xsk_tx_metadata_to_compl(meta, &skb_shinfo(skb)->xsk_meta);
 
-- 
2.53.0



