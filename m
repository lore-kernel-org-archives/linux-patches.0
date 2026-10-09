Received: from smtp.kernel.org (aws-us-west-2-korg-mail-alma10-1.taild15c8.ts.net [100.103.45.18])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 10C17399CE9;
	Fri,  9 Oct 2026 14:36:56 +0000 (UTC)
Authentication-Results: smtp.subspace.kernel.org; arc=none smtp.client-ip=100.103.45.18
ARC-Seal:i=1; a=rsa-sha256; d=subspace.kernel.org; s=arc-20240116;
	t=1791556617; cv=none; b=YPwmgADqt1rN/lK4b+xn6orUTqLwjXhE2Fo7u9PXBUhzOukheAUE+JZU0pvcwa8OAOIcDMYUp33QnW2lMjXyUfIce3510yLnewIVGEFASBWhhoprvpXuWxjeCQLReS67RTIBTDv8NT6Le4j4oQTuEMaxD2zA/BGAT49woDBT018=
ARC-Message-Signature:i=1; a=rsa-sha256; d=subspace.kernel.org;
	s=arc-20240116; t=1791556617; c=relaxed/simple;
	bh=lOl/Jozva6s5OO1X/peXhNZp4e9cgAnkywzGmUaIVt0=;
	h=From:To:Cc:Subject:Date:Message-ID:In-Reply-To:References:
	 MIME-Version; b=mLIwG+gDovSzUuPcfvSqjw1XE7QCBLCLZwdpaGGCrLRkTaQg+cV6jCSaQImH01FOIJPLF2TAQ53mo3BFnlf6pbExdHCYcLzvM3a4AQBs1CXoaaTDpvZrBHbrEcf4kOFa4GdCPpfD8HdBWj9iPZ1dheEUcLY+gjetiJSFII7J7Rs=
ARC-Authentication-Results:i=1; smtp.subspace.kernel.org; dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b=OpQg6exl; arc=none smtp.client-ip=100.103.45.18
Authentication-Results: smtp.subspace.kernel.org;
	dkim=pass (1024-bit key) header.d=linuxfoundation.org header.i=@linuxfoundation.org header.b="OpQg6exl"
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 662511F000FF;
	Fri,  9 Oct 2026 14:36:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linuxfoundation.org;
	s=korg; t=1791556616;
	bh=HucJkU0xhkOEox73yAWXi1qYATfoQU/fjTXYG9kO9f0=;
	h=From:To:Cc:Subject:Date:In-Reply-To:References;
	b=OpQg6exlJ1OJ6fdS70ER0xqN9yXiuN6WEp3RU6BOcHrQwmG+rqJkasraM4Eanz+Di
	 l+ihsXHSvDCt3HOHcpYezHYqwr0e6qglmTNVDtGcc7SNEWCqu5vwpm+abbZarsvdsu
	 ViRhf9A33v9Kn97zhmwRp0+W9LsWlWbbiXPuAT9I=
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: stable@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	patches@lists.linux.dev,
	Tianchu Chen <flynnnchen@tencent.com>,
	Johannes Berg <johannes.berg@intel.com>
Subject: [PATCH 6.18 264/403] wifi: cw1200: fix TX padding OOB read leaking heap data to device
Date: Fri,  9 Oct 2026 16:10:25 +0200
Message-ID: <20261009140958.352518169@linuxfoundation.org>
X-Mailer: git-send-email 2.56.0
In-Reply-To: <20261009140952.119038291@linuxfoundation.org>
References: <20261009140952.119038291@linuxfoundation.org>
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

From: Tianchu Chen <flynnnchen@tencent.com>

commit 7c1611780823b76219cb1478db53dfd890c4a9a2 upstream.

The TX path rounds the transfer size up to the bus alignment
(align_size(), up to 511 bytes for SDIO, 1 byte for SPI) but sends
the padded length straight from the frame buffer, which has no room
reserved for the padding.  cw1200_data_write() therefore reads past
the end of the frame and the bus transfer carries those bytes to the
device.  A bogus device can collect up to 511 bytes of kernel heap
data per TX frame.

The RX path does not have this problem: it allocates the skb with
the aligned length (alloc_len) before reading.

Compute the exact padding with the bus align_size() callback, make
sure queued TX frames have tailroom for it, and zero the padding
bytes before the transfer so nothing past the frame is exposed.

This is not expected to change driver behavior on most cases: frame
contents and transfer sizes are unchanged, only the content of the
padding bytes (previously undefined stale memory, now zero), which
the device never reads since the WSM header carries the real frame
length.  The skb expansion can only fail under memory exhaustion,
in which case the frame is dropped like on the existing error paths
of cw1200_tx().

Discovered by Atuin - Automated Vulnerability Discovery Engine.

Fixes: a910e4a94f69 ("cw1200: add driver for the ST-E CW1100 & CW1200 WLAN chipsets")
Cc: stable@vger.kernel.org
Assisted-by: LLM
Signed-off-by: Tianchu Chen <flynnnchen@tencent.com>
Link: https://patch.msgid.link/7982b4a7e64f74e2068790ec389ca680a081f730@linux.dev
Signed-off-by: Johannes Berg <johannes.berg@intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/wireless/st/cw1200/bh.c   |    8 +++++++-
 drivers/net/wireless/st/cw1200/txrx.c |   14 ++++++++++++++
 2 files changed, 21 insertions(+), 1 deletion(-)

--- a/drivers/net/wireless/st/cw1200/bh.c
+++ b/drivers/net/wireless/st/cw1200/bh.c
@@ -343,6 +343,7 @@ static int cw1200_bh_tx_helper(struct cw
 			       int *tx_burst)
 {
 	size_t tx_len;
+	size_t aligned_len;
 	u8 *data;
 	int ret;
 	struct wsm_hdr *wsm;
@@ -375,9 +376,14 @@ static int cw1200_bh_tx_helper(struct cw
 
 	atomic_inc(&priv->bh_tx);
 
-	tx_len = priv->hwbus_ops->align_size(
+	aligned_len = priv->hwbus_ops->align_size(
 		priv->hwbus_priv, tx_len);
 
+	/* Zero the bus alignment padding so no stale data is sent. */
+	if (aligned_len > tx_len)
+		memset(data + tx_len, 0, aligned_len - tx_len);
+	tx_len = aligned_len;
+
 	/* Check if not exceeding CW1200 capabilities */
 	if (WARN_ON_ONCE(tx_len > EFFECTIVE_BUF_SIZE))
 		pr_debug("Write aligned len: %zu\n", tx_len);
--- a/drivers/net/wireless/st/cw1200/txrx.c
+++ b/drivers/net/wireless/st/cw1200/txrx.c
@@ -14,6 +14,7 @@
 #include "wsm.h"
 #include "bh.h"
 #include "sta.h"
+#include "hwbus.h"
 #include "debug.h"
 
 #define CW1200_INVALID_RATE_ID (0xFF)
@@ -716,6 +717,7 @@ void cw1200_tx(struct ieee80211_hw *dev,
 	struct ieee80211_sta *sta;
 	struct wsm_tx *wsm;
 	bool tid_update = false;
+	size_t pad_len;
 	u8 flags = 0;
 	int ret;
 
@@ -764,6 +766,18 @@ void cw1200_tx(struct ieee80211_hw *dev,
 
 	sta = t.sta;
 
+	/*
+	 * The bus transfer is padded up to the bus alignment and the
+	 * padding is transferred from the frame buffer.  Make sure the
+	 * buffer has room for the padding so the device never receives
+	 * data past the end of the frame.
+	 */
+	pad_len = priv->hwbus_ops->align_size(priv->hwbus_priv, skb->len) -
+		skb->len;
+	if (skb_tailroom(skb) < pad_len &&
+	    pskb_expand_head(skb, 0, pad_len, GFP_ATOMIC))
+		goto drop;
+
 	spin_lock_bh(&priv->ps_state_lock);
 	{
 		tid_update = cw1200_tx_h_pm_state(priv, &t);


